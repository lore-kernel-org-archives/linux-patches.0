Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DAB107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A23C433C1;
	Thu, 10 Nov 2022 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098569;
	bh=7/BYuBysk0ovFW2IxRe1BxcDiN48GCNf/QdZo7baLig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSG25kTpYBQoKiCLhSZTPhkydYrJwchGquJUJx4Y9FJC1OEa+uK/gflPhWRa+hZua
	 YV48APql0DDQMaQxHYWDX/4ofRlj0tp5tLr1bsx//+9I3IIEjEDtjhm0GTyYX+J2Nr
	 tFb7l87VZ6VbX3o3GPdwD8OfVtkUP266mzSoO4SvHIyYMh+hAMTkareFordH0ZLG4N
	 5/SBBKVarR5GCjlePpwbDvXzM4mdInmRTUziiDg82udpkJ11F5eaz2O5OK212qSgHv
	 UWuQ7CJ6cj+mfTyBjJU9j4qogTmhl5ffPd1eG4OI3e5l2L331qh9ul7AGPYr/Blnrp
	 Zpu64hINj4AWA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Adam Bratschi-Kaye <ark.email@gmail.com>,
	=?UTF-8?q?N=C3=A1ndor=20Istv=C3=A1n=20Kr=C3=A1cser?= <bonifaido@gmail.com>
Subject: [PATCH v1 10/28] rust: error: add `From` implementations for `Error`
Date: Thu, 10 Nov 2022 17:41:22 +0100
Message-Id: <20221110164152.26136-11-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wedson Almeida Filho <wedsonaf@gmail.com>

Add a set of `From` implementations for the `Error` kernel type.

These implementations allow to easily convert from standard Rust
error types to the usual kernel errors based on one of the `E*`
integer codes.

On top of that, the question mark Rust operator (`?`) implicitly
performs a conversion on the error value using the `From` trait
when propagating. Thus it is extra convenient to use.

For instance, a kernel function that needs to convert a `i64` into
a `i32` and to bubble up the error as a kernel error may write:

    fn f(x: i64) -> Result<...> {
        ...
        let y = i32::try_from(x)?;
        ...
    }

which will transform the `TryFromIntError` into an `Err(EINVAL)`.

Co-developed-by: Adam Bratschi-Kaye <ark.email@gmail.com>
Signed-off-by: Adam Bratschi-Kaye <ark.email@gmail.com>
Co-developed-by: Nándor István Krácser <bonifaido@gmail.com>
Signed-off-by: Nándor István Krácser <bonifaido@gmail.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 45 +++++++++++++++++++++++++++++++++++++++++++-
 rust/kernel/lib.rs   |  1 +
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 861746f2422d..5b9751d7ff1d 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -4,7 +4,14 @@
 //!
 //! C header: [`include/uapi/asm-generic/errno-base.h`](../../../include/uapi/asm-generic/errno-base.h)
 
-use alloc::collections::TryReserveError;
+use alloc::{
+    alloc::{AllocError, LayoutError},
+    collections::TryReserveError,
+};
+
+use core::convert::From;
+use core::num::TryFromIntError;
+use core::str::Utf8Error;
 
 /// Contains the C-compatible error codes.
 pub mod code {
@@ -71,12 +78,48 @@ impl Error {
     }
 }
 
+impl From<AllocError> for Error {
+    fn from(_: AllocError) -> Error {
+        code::ENOMEM
+    }
+}
+
+impl From<TryFromIntError> for Error {
+    fn from(_: TryFromIntError) -> Error {
+        code::EINVAL
+    }
+}
+
+impl From<Utf8Error> for Error {
+    fn from(_: Utf8Error) -> Error {
+        code::EINVAL
+    }
+}
+
 impl From<TryReserveError> for Error {
     fn from(_: TryReserveError) -> Error {
         code::ENOMEM
     }
 }
 
+impl From<LayoutError> for Error {
+    fn from(_: LayoutError) -> Error {
+        code::ENOMEM
+    }
+}
+
+impl From<core::fmt::Error> for Error {
+    fn from(_: core::fmt::Error) -> Error {
+        code::EINVAL
+    }
+}
+
+impl From<core::convert::Infallible> for Error {
+    fn from(e: core::convert::Infallible) -> Error {
+        match e {}
+    }
+}
+
 /// A [`Result`] with an [`Error`] error type.
 ///
 /// To be used as the return type for functions that may fail.
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index abd46261d385..ffc6626a6d29 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -12,6 +12,7 @@
 //! do so first instead of bypassing this crate.
 
 #![no_std]
+#![feature(allocator_api)]
 #![feature(core_ffi_c)]
 
 // Ensure conditional compilation based on the kernel configuration works;
-- 
2.38.1

