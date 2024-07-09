Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5584B19EEC6;
	Tue,  9 Jul 2024 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541212; cv=none; b=SMT5AJ6mC6gCGJ5XhTkcZf2o48Wng/gUFDJA8/gM6pKzgd9Jf7G7A1uhqiuqPAkzYz2aL3hy9crXPwgksyRALmzj+rWoXx0pKllkxybOlOb721Cm8ew5/brsZZ4LChydV3z1FMkuLvvNwoytvp+ABZfwDLISW8vy/ZhcukdGaqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541212; c=relaxed/simple;
	bh=rvmuyTxepfmz99vfRXC8fLJLMvFHtkNIrTdX5AFdE58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdIe6qOlS+CSFNfXE7EwtpbZp3RLggpJdM6yNW1GbLVzkwYQgd/TXTOW4Sai4os2xzDUsUkMD6rjYqC8p3RPaCdzBVd20ukRCIFhym/dr8g7FrvDOWPsMy3jWDsbInSppJ5epGvQ2ovT18rrWo5/QEn4GO+nfF0PVMH/0F4CMBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJMvw+Q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJMvw+Q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E91C4AF07;
	Tue,  9 Jul 2024 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541212;
	bh=rvmuyTxepfmz99vfRXC8fLJLMvFHtkNIrTdX5AFdE58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJMvw+Q8VFdtdLXob3hO0x1hjFi5cMrfAfmQaDv847G3YNfBiSUhulxal1TALXFLO
	 4jVSShhOe21jP+bEHCECeDUrIr0D8jdAXtIcqLnOXLg/mTNiPCXUw4TQ1ew2Is/ZMZ
	 5dYcatfr9/+OAKK6ntR69UTjzzxwgq8jipC/6Z+7WIQigp/aAyhPhgIzyRTvK7LjKN
	 lGo50jLC+KAiCINUyHFAR9ZcvTOlxl/aeo+2+VcI/3uiHkP8dNtYciO70SBQ0Fx5kr
	 knwbwgBuxGVoK/v27OTV7mCw+0lYQRFdECdj9hu/swRC4tSkZ7qlpVtd8shpPnhrhI
	 SLCc8fcPIf7Bg==
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
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v2 06/13] rust: start supporting several compiler versions
Date: Tue,  9 Jul 2024 18:06:01 +0200
Message-ID: <20240709160615.998336-7-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is time to start supporting several Rust compiler versions and thus
establish a minimum Rust version.

We may still want to upgrade the minimum sometimes in the beginning since
there may be important features coming into the language that improve
how we write code (e.g. field projections), which may or may not make
sense to support conditionally.

We will start with a window of two stable releases, and widen it over
time. Thus this patch does not move the current minimum (1.78.0), but
instead adds support for the recently released 1.79.0.

This should already be enough for kernel developers in distributions that
provide recent Rust compiler versions routinely, such as Arch Linux,
Debian Unstable (outside the freeze period), Fedora Linux, Gentoo
Linux (especially the testing channel), Nix (unstable) and openSUSE
Tumbleweed. See the documentation patch about it later in this series.

In addition, Rust for Linux is now being built-tested in Rust's pre-merge
CI [1]. That is, every change that is attempting to land into the Rust
compiler is tested against the kernel, and it is merged only if it passes
-- thanks to the Rust project for that!

Thus, with the pre-merge CI in place, both projects hope to avoid
unintentional changes to Rust that break the kernel. This means that,
in general, apart from intentional changes on their side (that we will
need to workaround conditionally on our side), the upcoming Rust compiler
versions should generally work.

For instance, currently, the beta (1.80.0) and nightly (1.81.0) branches
work as well.

Of course, the Rust for Linux CI job in the Rust toolchain may still need
to be temporarily disabled for different reasons, but the intention is
to help bring Rust for Linux into stable Rust.

Link: https://github.com/rust-lang/rust/pull/125209 [1]
Reviewed-by: Finn Behrens <me@kloenk.dev>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - Update suggested `rustup` command to just install `stable`. (Finn)
  - Update suggested command for installing manually the Rust standard
    library sources with the version that `rustc` reports, rather than
    the minimum (since now the user may have installed e.g. stable).

 Documentation/process/changes.rst  |  4 +---
 Documentation/rust/quick-start.rst | 15 +++++++--------
 scripts/rust_is_available.sh       |  8 --------
 scripts/rust_is_available_test.py  |  5 -----
 4 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index 5685d7bfe4d0..0d0b7120792b 100644
--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -88,9 +88,7 @@ docs on :ref:`Building Linux with Clang/LLVM <kbuild_llvm>`.
 Rust (optional)
 ---------------

-A particular version of the Rust toolchain is required. Newer versions may or
-may not work because the kernel depends on some unstable Rust features, for
-the moment.
+A recent version of the Rust compiler is required.

 Each Rust toolchain comes with several "components", some of which are required
 (like ``rustc``) and some that are optional. The ``rust-src`` component (which
diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quick-start.rst
index ac2f16288458..89bbfde8c96c 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -36,16 +36,15 @@ if that is the case.
 rustc
 *****

-A particular version of the Rust compiler is required. Newer versions may or
-may not work because, for the moment, the kernel depends on some unstable
-Rust features.
+A recent version of the Rust compiler is required.

 If ``rustup`` is being used, enter the kernel build directory (or use
-``--path=<build-dir>`` argument to the ``set`` sub-command) and run::
+``--path=<build-dir>`` argument to the ``set`` sub-command) and run,
+for instance::

-	rustup override set $(scripts/min-tool-version.sh rustc)
+	rustup override set stable

-This will configure your working directory to use the correct version of
+This will configure your working directory to use the given version of
 ``rustc`` without affecting your default toolchain.

 Note that the override applies to the current working directory (and its
@@ -72,9 +71,9 @@ version later on requires re-adding the component.
 Otherwise, if a standalone installer is used, the Rust source tree may be
 downloaded into the toolchain's installation folder::

-	curl -L "https://static.rust-lang.org/dist/rust-src-$(scripts/min-tool-version.sh rustc).tar.gz" |
+	curl -L "https://static.rust-lang.org/dist/rust-src-$(rustc --version | cut -d' ' -f2).tar.gz" |
 		tar -xzf - -C "$(rustc --print sysroot)/lib" \
-		"rust-src-$(scripts/min-tool-version.sh rustc)/rust-src/lib/" \
+		"rust-src-$(rustc --version | cut -d' ' -f2)/rust-src/lib/" \
 		--strip-components=3

 In this case, upgrading the Rust compiler version later on requires manually
diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
index 117018946b57..67cb900124cc 100755
--- a/scripts/rust_is_available.sh
+++ b/scripts/rust_is_available.sh
@@ -117,14 +117,6 @@ if [ "$rust_compiler_cversion" -lt "$rust_compiler_min_cversion" ]; then
 	echo >&2 "***"
 	exit 1
 fi
-if [ "$rust_compiler_cversion" -gt "$rust_compiler_min_cversion" ]; then
-	echo >&2 "***"
-	echo >&2 "*** Rust compiler '$RUSTC' is too new. This may or may not work."
-	echo >&2 "***   Your version:     $rust_compiler_version"
-	echo >&2 "***   Expected version: $rust_compiler_min_version"
-	echo >&2 "***"
-	warning=1
-fi

 # Check that the Rust bindings generator is suitable.
 #
diff --git a/scripts/rust_is_available_test.py b/scripts/rust_is_available_test.py
index 57613fe5ed75..a255f79aafc2 100755
--- a/scripts/rust_is_available_test.py
+++ b/scripts/rust_is_available_test.py
@@ -193,11 +193,6 @@ else:
         result = self.run_script(self.Expected.FAILURE, { "RUSTC": rustc })
         self.assertIn(f"Rust compiler '{rustc}' is too old.", result.stderr)

-    def test_rustc_new_version(self):
-        rustc = self.generate_rustc("rustc 1.999.0 (a8314ef7d 2099-06-27)")
-        result = self.run_script(self.Expected.SUCCESS_WITH_WARNINGS, { "RUSTC": rustc })
-        self.assertIn(f"Rust compiler '{rustc}' is too new. This may or may not work.", result.stderr)
-
     def test_bindgen_nonexecutable(self):
         result = self.run_script(self.Expected.FAILURE, { "BINDGEN": self.nonexecutable })
         self.assertIn(f"Running '{self.nonexecutable}' to check the Rust bindings generator version failed with", result.stderr)
--
2.45.2
