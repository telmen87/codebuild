terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = var.profile_name

  default_tags {
    tags = {
      Environment = "Development"
    }
  }
}

resource "aws_codebuild_project" "example" {
  name = "test-codebuild"
  service_role = "arn:aws:iam::113313628113:role/service-role/codebuild-test-service-role"
  source {
    buildspec       = "buildspec.yml"
    type            = "GITHUB"
    location        = "https://github.com/telmen87/codebuild.git"
    git_clone_depth = 1
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    type  = "LINUX_CONTAINER"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    compute_type = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
  }

  tags = {
    Environment = "experiment"
  }
}