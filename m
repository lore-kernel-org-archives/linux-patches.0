Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F363A13D890;
	Sat, 23 Nov 2024 22:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732400944; cv=none; b=Qu0Q3hxLiu+evlkCS+pGmPB6vNADW37S8amTlWZK3zwIxY+MOaNu/tnNzKS86COaBPL5szsxz4ycs8xwNVmlIw5tJRlgCuy+ifWlYS5i3asK3QTDR0oaY7/Cuhl61zaxYqHEp0ihJyk+NDVGCe++oQYhwKXgRSqfbg0r2HfwK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732400944; c=relaxed/simple;
	bh=6PCjz9RrSZ1Yw/TTVbEX2xuMJdKcdzDFBfIaGKpAUgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ71Hc/jZE0WH56ccJMpkywkUE22mlm01aPh1oMlOCm9qWddgfdhDVXSQy1W06PAj3rRvXuykOxKDDq+CxHSGCRTTxZnm1Zij1DfHBd8tM71P4pbAVc28BZe2kziX2uBS+D7yRNuzxBdeYIL3TsjPtqWGlF+jKE4Fn36zdnfeoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7c+zOxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7c+zOxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E1FC4CED3;
	Sat, 23 Nov 2024 22:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732400943;
	bh=6PCjz9RrSZ1Yw/TTVbEX2xuMJdKcdzDFBfIaGKpAUgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7c+zOxEDMIHDDOla6tErFZ3TWgrmeyKgJieM33Nm+RSiWN3efsU34LFka5fqGaxN
	 hImOTaEvO+9jDcHfujbx7LZ0INbEsHSt1OGgtGpOFQcVbCW6dfH9gSU+RknWghmVpP
	 9unAqI31T+MtyIWjcNcwuDqoo/usGLbgBPy4ex3oyIeQ9cc3m0KKifkn+DuZROYJpS
	 gfMhvWD7PZzwzSHUFwKIyX3VKj9VdVxy3alOXlWl8unpL12xGEGcTh2ot5UncBCTPy
	 EGm7WfyVaNlt5ufDIQlw7Y/6/AWDMCjDjIPB7VhdcDEQP7nmw1BNeFqeriEsOtY2hI
	 MWbUVZoDeXTjw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/3] rust: kernel: move `build_error` hidden function to prevent mistakes
Date: Sat, 23 Nov 2024 23:28:48 +0100
Message-ID: <20241123222849.350287-2-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-1-ojeda@kernel.org>
References: <20241123222849.350287-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Users were using the hidden exported `kernel::build_error` function
instead of the intended `kernel::build_error!` macro, e.g. see the
previous commit.

To force to use the macro, move it into the `build_assert` module,
thus making it a compilation error and avoiding a collision in the same
"namespace". Using the function now would require typing the module name
(which is hidden), not just a single character.

Now attempting to use the function will trigger this error with the
right suggestion by the compiler:

      error[E0423]: expected function, found macro `kernel::build_error`
      --> samples/rust/rust_minimal.rs:29:9
         |
      29 |         kernel::build_error();
         |         ^^^^^^^^^^^^^^^^^^^ not a function
         |
      help: use `!` to invoke the macro
         |
      29 |         kernel::build_error!();
         |                            +

An alternative would be using an alias, but it would be more complex
and moving it into the module seems right since it belongs there and
reduces the amount of code at the crate root.

Keep the `#[doc(hidden)]` inside `build_assert` in case the module is
not hidden in the future.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/build_assert.rs | 11 +++++++----
 rust/kernel/lib.rs          |  6 ++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/rust/kernel/build_assert.rs b/rust/kernel/build_assert.rs
index 9e37120bc69c..347ba5ce50f4 100644
--- a/rust/kernel/build_assert.rs
+++ b/rust/kernel/build_assert.rs
@@ -2,6 +2,9 @@
 
 //! Build-time assert.
 
+#[doc(hidden)]
+pub use build_error::build_error;
+
 /// Fails the build if the code path calling `build_error!` can possibly be executed.
 ///
 /// If the macro is executed in const context, `build_error!` will panic.
@@ -23,10 +26,10 @@
 #[macro_export]
 macro_rules! build_error {
     () => {{
-        $crate::build_error("")
+        $crate::build_assert::build_error("")
     }};
     ($msg:expr) => {{
-        $crate::build_error($msg)
+        $crate::build_assert::build_error($msg)
     }};
 }
 
@@ -73,12 +76,12 @@ macro_rules! build_error {
 macro_rules! build_assert {
     ($cond:expr $(,)?) => {{
         if !$cond {
-            $crate::build_error(concat!("assertion failed: ", stringify!($cond)));
+            $crate::build_assert::build_error(concat!("assertion failed: ", stringify!($cond)));
         }
     }};
     ($cond:expr, $msg:expr) => {{
         if !$cond {
-            $crate::build_error($msg);
+            $crate::build_assert::build_error($msg);
         }
     }};
 }
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index bf8d7f841f94..73e33a41ea04 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -32,7 +32,8 @@
 pub mod alloc;
 #[cfg(CONFIG_BLOCK)]
 pub mod block;
-mod build_assert;
+#[doc(hidden)]
+pub mod build_assert;
 pub mod device;
 pub mod error;
 #[cfg(CONFIG_RUST_FW_LOADER_ABSTRACTIONS)]
@@ -66,9 +67,6 @@
 pub use macros;
 pub use uapi;
 
-#[doc(hidden)]
-pub use build_error::build_error;
-
 /// Prefix to appear before log messages printed from within the `kernel` crate.
 const __LOG_PREFIX: &[u8] = b"rust_kernel\0";
 
-- 
2.47.0

