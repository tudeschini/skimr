context("Change functions used by skim")

correct <- tibble::tribble(
  ~type,          ~stat,  ~level,   ~value,
  "numeric",      "iqr",  ".all",   IQR(iris$Sepal.Length),
  "numeric", "quantile",   "99%",   7.7
)

test_that("Skimming functions can be changed for different types", {
  funs <- list(iqr = IQR,
    quantile = purrr::partial(quantile, probs = .99))
  skim_with(numeric = funs, append = FALSE)
  input <- skim_v(iris$Sepal.Length)
  # Restore defaults
  skim_with_defaults()
  expect_identical(input, correct)
})

correct <- tibble::tribble(
  ~type,          ~stat,    ~level,   ~value,
  "numeric",      "missing", ".all",   0,
  "numeric",      "complete",".all",   150,
  "numeric",      "n",       ".all",   150,
  "numeric",      "mean",    ".all",   mean(iris$Sepal.Length),
  "numeric",      "sd",      ".all",   sd(iris$Sepal.Length),
  "numeric",      "min",     ".all",   4.3,
  "numeric",      "median",  ".all",   5.8,
  "numeric",      "quantile","25%",    5.1,
  "numeric",      "quantile","75%",    6.4,
  "numeric",      "max",     ".all",   7.9,
  "numeric",      "hist", "▂▇▅▇▆▆▅▂▂▂",0,              
  "numeric",      "iqr",     ".all",   IQR(iris$Sepal.Length),
  "numeric",      "quantile","99%",    7.7
)

test_that("Skimming functions can be appended.", {
  funs <- list(iqr = IQR,
               quantile = purrr::partial(quantile, probs = .99))
  skim_with(numeric = funs, append = TRUE)
  input <- skim_v(iris$Sepal.Length)
  # Restore defaults
  skim_with_defaults()
  expect_identical(input, correct)
})

correct <- tibble::tribble(
  ~type,          ~stat,  ~level,   ~value,
  "new_type",      "iqr",  ".all",   IQR(iris$Sepal.Length),
  "new_type", "quantile",   "99%",   7.7
)

test_that("Skimming functions for new types can be added", {
  funs <- list(iqr = IQR,
    quantile = purrr::partial(quantile, probs = .99))
  skim_with(new_type = funs)
  vector <- structure(iris$Sepal.Length, class = "new_type")
  input <- skim_v(vector)
  # Restore defaults
  skim_with_defaults()
  expect_identical(input, correct)
})

correct <- tibble::tribble(
  ~type,          ~stat,  ~level,   ~value,
  "new_type",      "iqr",  ".all",   IQR(iris$Sepal.Length),
  "new_type", "quantile",   "99%",   7.7,
  "new_type", "q2",   "99%",   7.7
)

test_that("Set multiple sets of skimming functions", {
  funs <- list(iqr = IQR,
    quantile = purrr::partial(quantile, probs = .99),
    q2 = purrr::partial(quantile, probs = .99))
  skim_with(numeric = funs, new_type = funs, append = FALSE)
  vector <- structure(iris$Sepal.Length, class = "new_type")
  input <- skim_v(vector)
  skim_with_defaults()
  expect_identical(input, correct)
})

test_that("Skimming functions without a name return a message.", {
  funs <- list( iqr = IQR,
               purrr::partial(quantile, probs = .99))
  
  input <- skim_with(numeric = funs, append = FALSE)
  # Restore defaults
  skim_with_defaults()
  expect_message(message("Error: A function is missing a name within this type: iqr,"))
})

test_that("show_skimmers() has a correct list of functions for a type", {
  correct <- names(get_funs("numeric"))
  skimmers <- show_skimmers()
  input <- names(skimmers[["numeric"]])
  identical(input, correct)
})

test_that("show_skimmers() has a correct list types", {
  correct <- c("numeric",   "integer",  "factor" ,   "ordered",   "character", "logical",   "complex",
               "date",      "Date",      "ts", "POSIXct" )
  skimmers <- show_skimmers()
  input <- names(skimmers)
  identical(input, correct)
})


skim_with_defaults()