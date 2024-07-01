Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D340E16F0C1;
	Mon,  1 Jul 2024 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859034; cv=none; b=LY1+D2uH8hQWp4+u2bdlsVw7m4X0lIqBosUk3Gw8yONLA47GuJoIRCV53veNQ9dq7Swj6i43/qLrG1wqbYYSKVqpay5l1oc29ostwFr5Y/JHvtM1Esd6KkMH78QVZ1j2HVCE736wk2XfUEzLfDwYH5Ce2tcxq1tMyyUM+KZHf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859034; c=relaxed/simple;
	bh=VDQcdRaYS4pHmzUm9z566MSM4z5FQavSl6glziiRPg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNihjH7i94+toM/L4VPfnZQimeECfQBsW+r48yCB3KeXXp4bpmPJrhUS8JpqiGhJ2SSf6vrP7ky4PGg4lNJKdUOmGuj5+yaGigZeOSKH8p2je+e25Q5yPGzECaeiDLODP0DkzKGSMDxznNM6KMEFLtr1CFeQQd4bC7snFeIpv0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rI0fmFgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rI0fmFgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A5FC4AF12;
	Mon,  1 Jul 2024 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859033;
	bh=VDQcdRaYS4pHmzUm9z566MSM4z5FQavSl6glziiRPg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rI0fmFgWp9rv4E/QxUDyHgpkQP8lQT3wZOzFZ/6Xm1Xp4cYeLf98SUDZqwntLujtN
	 1K3BmFnR6CehI3SiksKdCKiBKn23ayvYNvgbEaozvG9CDLZhQYcmNR0AcaGfZqKpT8
	 ntdbZ8+8oxVSsIJGeMZEoFk8mCa0vmqVt4Fpl6XMkbUB/bmJsQjImwr1OwnjoyPYJh
	 Q9gLPu1UlwhnTR794bPb5LKKETvGQXfRYj+JGHsHKalUOcTJgJnEuJduVWadw4l0cy
	 frgRXLyWuGWZvRJpT07CsqIeCf7JNk2p/PyImHJKcD9l9BBsugDAbwFtisoSc5vmF8
	 KeN04BI1T6gUA==
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
	Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 06/13] rust: start supporting several compiler versions
Date: Mon,  1 Jul 2024 20:36:16 +0200
Message-ID: <20240701183625.665574-7-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
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
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/process/changes.rst  | 4 +---
 Documentation/rust/quick-start.rst | 9 ++++-----
 scripts/rust_is_available.sh       | 8 --------
 scripts/rust_is_available_test.py  | 5 -----
 4 files changed, 5 insertions(+), 21 deletions(-)

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
index cc3f11e0d441..139a8a536838 100644
--- a/Documentation/rust/quick-start.rst
+++ b/Documentation/rust/quick-start.rst
@@ -29,16 +29,15 @@ if that is the case.
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
 
 	rustup override set $(scripts/min-tool-version.sh rustc)
 
-This will configure your working directory to use the correct version of
+This will configure your working directory to use the given version of
 ``rustc`` without affecting your default toolchain.
 
 Note that the override applies to the current working directory (and its
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

