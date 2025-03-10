Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D417C225;
	Mon, 10 Mar 2025 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627150; cv=none; b=gJB+EgEalUdohqp0i6mvf2lQ5lWQTm8aBVI2/Xf7XfQ+DKrhoo8i9JrPx3ILhGK7K5Zdgpcp7kKBisskinfO3gfQUV44AvgUy1GFGr7fudB/NHQJMmI2eS4IUVpxM/6KoH+cXTuCB51cgryCABZn9rM5nC6ZI+ziA9jk7TpWG7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627150; c=relaxed/simple;
	bh=9Q2tVffoyfXwjFSUtaI15zduhSWERRm02TmCMGZlKMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmRveWkEXa2eCOjkhJA3A23hf0ecH6uW63kn89dt7TrOkJJmwXFjMAVNnfgLt/Hy+unxRa6e5DONtQwutJrPs1+MKp8grbynEZxQhgrz3OCvX4jof+c/n0ZImUuJBVOZbBWEIHZZEZdg8y32u+VJJiNko9lyAFDQqHBConZHKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvGmopIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvGmopIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31329C4CEE5;
	Mon, 10 Mar 2025 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627150;
	bh=9Q2tVffoyfXwjFSUtaI15zduhSWERRm02TmCMGZlKMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvGmopIRMkFYesiBUDKrW88Y3tZeEc4/3dZVhRzg7gqclkFUboiD7lxHqlgKM8vK5
	 1dl9h+PVjPiUPYvQt1wP0bZXVnGt4SYhv4lye30N2JsiILLM+7TZV1oz3uOYv+vMwg
	 utEbglkbYbhNv+L3izX5jTcFZ709E5lSx8gVYQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Xavier <felipe_life@live.com>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Fiona Behrens <me@kloenk.dev>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 030/269] rust: error: optimize error type to use nonzero
Date: Mon, 10 Mar 2025 18:03:03 +0100
Message-ID: <20250310170458.916825524@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Xavier <felipe_life@live.com>

commit e9759c5b9ea555d09f426c70c880e9522e9b0576 upstream.

Optimize `Result<(), Error>` size by changing `Error` type to
`NonZero*` for niche optimization.

This reduces the space used by the `Result` type, as the `NonZero*`
type enables the compiler to apply more efficient memory layout.
For example, the `Result<(), Error>` changes size from 8 to 4 bytes.

Link: https://github.com/Rust-for-Linux/linux/issues/1120
Signed-off-by: Filipe Xavier <felipe_life@live.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Link: https://lore.kernel.org/r/BL0PR02MB4914B9B088865CF237731207E9732@BL0PR02MB4914.namprd02.prod.outlook.com
[ Removed unneeded block around `match`, added backticks in panic
  message and added intra-doc link. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -9,6 +9,7 @@ use crate::{alloc::AllocError, str::CStr
 use alloc::alloc::LayoutError;
 
 use core::fmt;
+use core::num::NonZeroI32;
 use core::num::TryFromIntError;
 use core::str::Utf8Error;
 
@@ -20,7 +21,11 @@ pub mod code {
             $(
             #[doc = $doc]
             )*
-            pub const $err: super::Error = super::Error(-(crate::bindings::$err as i32));
+            pub const $err: super::Error =
+                match super::Error::try_from_errno(-(crate::bindings::$err as i32)) {
+                    Some(err) => err,
+                    None => panic!("Invalid errno in `declare_err!`"),
+                };
         };
     }
 
@@ -88,7 +93,7 @@ pub mod code {
 ///
 /// The value is a valid `errno` (i.e. `>= -MAX_ERRNO && < 0`).
 #[derive(Clone, Copy, PartialEq, Eq)]
-pub struct Error(core::ffi::c_int);
+pub struct Error(NonZeroI32);
 
 impl Error {
     /// Creates an [`Error`] from a kernel error code.
@@ -107,7 +112,20 @@ impl Error {
 
         // INVARIANT: The check above ensures the type invariant
         // will hold.
-        Error(errno)
+        // SAFETY: `errno` is checked above to be in a valid range.
+        unsafe { Error::from_errno_unchecked(errno) }
+    }
+
+    /// Creates an [`Error`] from a kernel error code.
+    ///
+    /// Returns [`None`] if `errno` is out-of-range.
+    const fn try_from_errno(errno: core::ffi::c_int) -> Option<Error> {
+        if errno < -(bindings::MAX_ERRNO as i32) || errno >= 0 {
+            return None;
+        }
+
+        // SAFETY: `errno` is checked above to be in a valid range.
+        Some(unsafe { Error::from_errno_unchecked(errno) })
     }
 
     /// Creates an [`Error`] from a kernel error code.
@@ -115,21 +133,22 @@ impl Error {
     /// # Safety
     ///
     /// `errno` must be within error code range (i.e. `>= -MAX_ERRNO && < 0`).
-    unsafe fn from_errno_unchecked(errno: core::ffi::c_int) -> Error {
+    const unsafe fn from_errno_unchecked(errno: core::ffi::c_int) -> Error {
         // INVARIANT: The contract ensures the type invariant
         // will hold.
-        Error(errno)
+        // SAFETY: The caller guarantees `errno` is non-zero.
+        Error(unsafe { NonZeroI32::new_unchecked(errno) })
     }
 
     /// Returns the kernel error code.
     pub fn to_errno(self) -> core::ffi::c_int {
-        self.0
+        self.0.get()
     }
 
     #[cfg(CONFIG_BLOCK)]
     pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
         // SAFETY: `self.0` is a valid error due to its invariant.
-        unsafe { bindings::errno_to_blk_status(self.0) }
+        unsafe { bindings::errno_to_blk_status(self.0.get()) }
     }
 
     /// Returns the error encoded as a pointer.
@@ -137,7 +156,7 @@ impl Error {
         #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
         unsafe {
-            bindings::ERR_PTR(self.0.into()) as *mut _
+            bindings::ERR_PTR(self.0.get().into()) as *mut _
         }
     }
 
@@ -145,7 +164,7 @@ impl Error {
     #[cfg(not(testlib))]
     pub fn name(&self) -> Option<&'static CStr> {
         // SAFETY: Just an FFI call, there are no extra safety requirements.
-        let ptr = unsafe { bindings::errname(-self.0) };
+        let ptr = unsafe { bindings::errname(-self.0.get()) };
         if ptr.is_null() {
             None
         } else {


