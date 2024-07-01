Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA1016EB70;
	Mon,  1 Jul 2024 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859008; cv=none; b=LtXuh7xn9VvUO859ibFcPpTK2DSFvybgvrfwhiHIRUAbxPqcPK3P4DKxBaLKGGpe+roU2XJEAGcD0Q0+g5yYPEcdNQXkY5LSPeGNps3D3RQYxj4eteVN0StMrFQuZw+EVt0aRf0BFvqiJbO+Zmq/uN75cbsPEwXSnzU06epUBo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859008; c=relaxed/simple;
	bh=6irQFrUOYtg/mtmSRairb5nPKj33UQSNuMI8G+CrdDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lyaU7Tu5k0/FpBpsYcuRLKWszSRhdfx8mdG1jNt+Qvv9Br9y6Xy+wJYClVm5Vo+M0D/6Oe+mgROs9EA7OPyf+l5iCkafFD67ECNUGFwbcGsysihAXgw9Uzve5359/tbQKMj5TUZNq7+DftNoDE6uJVKjziOO5m+5P0EJPdEq0xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI08Fa6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI08Fa6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFCCC116B1;
	Mon,  1 Jul 2024 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859007;
	bh=6irQFrUOYtg/mtmSRairb5nPKj33UQSNuMI8G+CrdDQ=;
	h=From:To:Cc:Subject:Date:From;
	b=eI08Fa6FHYRAQ9oWAZP/phH9d0fNiZ3U2wg54VsMNcCg7s7FAIJPB9LlGl2Rza28T
	 JH44p144BD43MWITsEL3wCNpD/7luxZMOnN26y4WpYK7bjjrW0G84LfQ5VStbwV1x0
	 tNWnhpJ1KNucxrdJgrVfu/2v4I+8h5s+I/q6uP2thOn7ghl/r69a5eWyZY06ZibMTg
	 cZo9n5oZUCb+zoXbkWWiPu2kezosL+oLIPsy0CUca76qqGyNP1yZSuaPySoL5YiPxJ
	 eARQ46XlzEaTQRlnchs+vIVL+MmZIIY0iptky2nJfs7A9OfG350yysH7G6SbsBfe+s
	 sMmNFuVpKOhYg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 00/13] Support several Rust toolchain versions
Date: Mon,  1 Jul 2024 20:36:10 +0200
Message-ID: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

It is time to start supporting several Rust toolchain versions and thus
establish a minimum Rust compiler and `bindgen` version.

For the Rust compiler, we will start with a window of two stable
releases, and widen it over time. This series keeps the minimum where
it is (1.78.0), but adds support for the recently released 1.79.0.

This should already be enough for kernel developers in distributions that
provide recent Rust compiler versions routinely, such as Arch Linux,
Debian Unstable (outside the freeze period), Fedora Linux, Gentoo
Linux (especially the testing channel), Nix (unstable) and openSUSE
Tumbleweed. A documentation adds the instructions for each of them.

In addition, Rust for Linux is now being built-tested in Rust's
pre-merge CI. That is, every change that is attempting to land into the
Rust compiler is tested against the kernel, and it is merged only if it
passes -- thanks to the Rust project for that!

Thus, with the pre-merge CI in place, both projects hope to avoid
unintentional changes to Rust that break the kernel. This means that,
in general, apart from intentional changes on their side (that we will
need to workaround conditionally on our side), the upcoming Rust compiler
versions should generally work.

For instance, currently, the beta (1.80.0) and nightly (1.81.0) branches
work as well.

Similarly, we kept the minimum as it is for `bindgen`. `bindgen` is also
adding the kernel to its CI -- thanks!

Cheers,
Miguel


Miguel Ojeda (13):
  rust: macros: indent list item in `paste!`'s docs
  rust: init: simplify from `map_err` to `inspect_err`
  rust: allow `dead_code` for never constructed bindings
  rust: relax most deny-level lints to warnings
  rust: simplify Clippy warning flags set
  rust: start supporting several compiler versions
  rust: warn about `bindgen` versions 0.66.0 and 0.66.1
  rust: work around `bindgen` 0.69.0 issue
  rust: avoid assuming a particular `bindgen` build
  rust: start supporting several `bindgen` versions
  kbuild: rust: add `rustc-version` support
  rust: support the new `-Zub-checks` flag
  docs: rust: quick-start: add section on Linux distributions

 Documentation/process/changes.rst  |   9 +--
 Documentation/rust/quick-start.rst | 118 +++++++++++++++++++++++------
 Makefile                           |  29 +++----
 init/Kconfig                       |  11 ++-
 lib/Kconfig.debug                  |  18 +++++
 rust/Makefile                      |   4 +-
 rust/bindings/lib.rs               |   1 +
 rust/kernel/init.rs                |  12 +--
 rust/macros/lib.rs                 |   2 +-
 rust/uapi/lib.rs                   |   1 +
 scripts/Kconfig.include            |   6 ++
 scripts/Makefile.compiler          |   4 +
 scripts/rust_is_available.sh       |  20 ++---
 scripts/rust_is_available_test.py  |  40 +++++-----
 scripts/rustc-version.sh           |  52 +++++++++++++
 15 files changed, 238 insertions(+), 89 deletions(-)
 create mode 100755 scripts/rustc-version.sh


base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454
-- 
2.45.2

