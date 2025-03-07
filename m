Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E5018BC36;
	Fri,  7 Mar 2025 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387888; cv=none; b=Vqb5SGbhX50sxP6K65gGxLQlr+lYLVkrdyUqmLp1afruI2oczWQzFWnU0xry3pYSSN/u5UYR2+HZL4B8ix6KwCWs0Pigu4OkxvlFin37RSSIfFo3t+/4l/j6dfakUVdIrxhSKTp9nySyP8unlGLklofhoDwn15SOzncCTaWs4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387888; c=relaxed/simple;
	bh=IFsVEZtyNME8h9sO8w1L8+Hr0zDRB3RAI6Cil6+J8Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9iLQt0BCnAer7J52f/EUlBQBxmjMLX1ktlzZszObVI8lvuW4gJzxMBEhGv2asYlYVvLbBxmy0DryJsgZ33jyIPgsDdwIxY//2IzqOw0ztYzAD0czZrnbzABIPm9rjdmEoJxKvTqpmpoOkI0cT+J5mRO+HQyGUuEceLT+r7LAL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAxgtx6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAxgtx6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C983DC4CED1;
	Fri,  7 Mar 2025 22:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387888;
	bh=IFsVEZtyNME8h9sO8w1L8+Hr0zDRB3RAI6Cil6+J8Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAxgtx6Ej5wrT6HIPlrflF266qV7AF2vns3/xDwmtjtnnGWrwzqm6lVCJ4ZOu817D
	 ill0Q53uGC0t/719C4bOs9HUvc2R0BQlwgflznnJ+gR30d/nvM90RF1suuUhAdlMCP
	 IzQulrwzd+w0hTEZkRM5AnBddrWKh0/fvMe+734EZ2yKOamq9tn/zL/DV/sJicmCa7
	 KvIx0oZpPaPidqtohmLSa5pQoFfDCggbwv6a0egKlMQIGRCDwIg9NFR+zreycGYMkQ
	 f4BKo0n0EhXMObcYDle6yhgIuDb3GJIr9IkI4Aac4CTFeTMKLy8/1S4hBGHAqmtVvl
	 +vpaagkbM2NCw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 19/60] rust: error: optimize error type to use nonzero
Date: Fri,  7 Mar 2025 23:49:26 +0100
Message-ID: <20250307225008.779961-20-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 rust/kernel/error.rs | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 2f1e4b783bfb..be6509d5f4a4 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -9,6 +9,7 @@
 use alloc::alloc::LayoutError;
 
 use core::fmt;
+use core::num::NonZeroI32;
 use core::num::TryFromIntError;
 use core::str::Utf8Error;
 
@@ -20,7 +21,11 @@ macro_rules! declare_err {
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
 
@@ -88,7 +93,7 @@ macro_rules! declare_err {
 ///
 /// The value is a valid `errno` (i.e. `>= -MAX_ERRNO && < 0`).
 #[derive(Clone, Copy, PartialEq, Eq)]
-pub struct Error(core::ffi::c_int);
+pub struct Error(NonZeroI32);
 
 impl Error {
     /// Creates an [`Error`] from a kernel error code.
@@ -107,7 +112,20 @@ pub fn from_errno(errno: core::ffi::c_int) -> Error {
 
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
@@ -115,21 +133,22 @@ pub fn from_errno(errno: core::ffi::c_int) -> Error {
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
@@ -137,7 +156,7 @@ pub fn to_ptr<T>(self) -> *mut T {
         #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
         unsafe {
-            bindings::ERR_PTR(self.0.into()) as *mut _
+            bindings::ERR_PTR(self.0.get().into()) as *mut _
         }
     }
 
@@ -145,7 +164,7 @@ pub fn to_ptr<T>(self) -> *mut T {
     #[cfg(not(testlib))]
     pub fn name(&self) -> Option<&'static CStr> {
         // SAFETY: Just an FFI call, there are no extra safety requirements.
-        let ptr = unsafe { bindings::errname(-self.0) };
+        let ptr = unsafe { bindings::errname(-self.0.get()) };
         if ptr.is_null() {
             None
         } else {
-- 
2.48.1

