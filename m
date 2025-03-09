Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053D521D3EE;
	Sun,  9 Mar 2025 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741552958; cv=none; b=JVk2miL1nN3+Tpx8NIrNWPInFWQX6qrO/J0FAkO55IrmviClk0ibXm7kbMU1efThECdCsXgx0P2UXiLMPffOCCKcPODc1lfdK4ZUgmril3nn6TG7Ngri9y+cf9Q0LEJbGlOTVLz4V3Ifg3RDfAJENrpp3pB9UnHsKekzque1y/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741552958; c=relaxed/simple;
	bh=pWhnxuKrNlYmZE4ntSbCJBytDkwmDJpWmIEulmWNJVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URW2ELXw5ZRhR2EAzPOh+vesD2igZEILMs73m3mX1TP/e83a6VOCgjLa+4VLDQrh8LwZAQKePHohAMVJTWtFGCoxt6Rk8YMwiFosEQkYcLlVhmx5twxOST2AvCYZzQd9zPy3jwxiSBEl6N7FL81XYVcNM6X4s1UgLgx1q1RIvPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKkmdoMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKkmdoMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352B4C4CEEC;
	Sun,  9 Mar 2025 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741552957;
	bh=pWhnxuKrNlYmZE4ntSbCJBytDkwmDJpWmIEulmWNJVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKkmdoMHYQB+T37e/iIVn8tnZacg0t0PwzScax7iQS3N9/8kLG5RnNVdZmZxm7Ydv
	 FhnccPsm9JR1Hb3Lx/idveljEBHl5DE+JFTncRdoknemtdNZ8AuZoh/91OeaCi/Hwk
	 DDjUg7h9sCgWeioQjKyG9pZk9UlgLHq2xsXtGoxY7Uu4x8YjHiPKi7pnd/gd5zIY11
	 27n87PMtVgVZ7DgxuPIYOTM//MAqm3swlIxfu4sVZbYuPNMzjPSCJ804nyRcT77YaZ
	 0g/4sVwegyEO8Kh3Sn05BXGCh0cutQ/mESFH27iSITWUlwR90CB4/vagrnKKGrXrJJ
	 IoqLPjy+vzYfw==
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
Subject: [PATCH 6.12.y 2/2] rust: map `long` to `isize` and `char` to `u8`
Date: Sun,  9 Mar 2025 21:42:17 +0100
Message-ID: <20250309204217.1553389-3-ojeda@kernel.org>
In-Reply-To: <20250309204217.1553389-1-ojeda@kernel.org>
References: <2025030955-kindness-designing-246c@gregkh>
 <20250309204217.1553389-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Guo <gary@garyguo.net>

commit 1bae8729e50a900f41e9a1c17ae81113e4cf62b8 upstream.

The following FFI types are replaced compared to `core::ffi`:

1. `char` type is now always mapped to `u8`, since kernel uses
   `-funsigned-char` on the C code. `core::ffi` maps it to platform
   default ABI, which can be either signed or unsigned.

2. `long` is now always mapped to `isize`. It's very common in the
   kernel to use `long` to represent a pointer-sized integer, and in
   fact `intptr_t` is a typedef of `long` in the kernel. Enforce this
   mapping rather than mapping to `i32/i64` depending on platform can
   save us a lot of unnecessary casts.

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240913213041.395655-5-gary@garyguo.net
[ Moved `uaccess` changes from the next commit, since they were
  irrefutable patterns that Rust >= 1.82.0 warns about. Reworded
  slightly and reformatted a few documentation comments. Rebased on
  top of `rust-next`. Added the removal of two casts to avoid Clippy
  warnings. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/ffi.rs             | 37 ++++++++++++++++++++++++++++++++++++-
 rust/kernel/error.rs    |  5 +----
 rust/kernel/firmware.rs |  2 +-
 rust/kernel/uaccess.rs  | 27 +++++++--------------------
 4 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/rust/ffi.rs b/rust/ffi.rs
index be153c4d551b..584f75b49862 100644
--- a/rust/ffi.rs
+++ b/rust/ffi.rs
@@ -10,4 +10,39 @@
 
 #![no_std]
 
-pub use core::ffi::*;
+macro_rules! alias {
+    ($($name:ident = $ty:ty;)*) => {$(
+        #[allow(non_camel_case_types, missing_docs)]
+        pub type $name = $ty;
+
+        // Check size compatibility with `core`.
+        const _: () = assert!(
+            core::mem::size_of::<$name>() == core::mem::size_of::<core::ffi::$name>()
+        );
+    )*}
+}
+
+alias! {
+    // `core::ffi::c_char` is either `i8` or `u8` depending on architecture. In the kernel, we use
+    // `-funsigned-char` so it's always mapped to `u8`.
+    c_char = u8;
+
+    c_schar = i8;
+    c_uchar = u8;
+
+    c_short = i16;
+    c_ushort = u16;
+
+    c_int = i32;
+    c_uint = u32;
+
+    // In the kernel, `intptr_t` is defined to be `long` in all platforms, so we can map the type to
+    // `isize`.
+    c_long = isize;
+    c_ulong = usize;
+
+    c_longlong = i64;
+    c_ulonglong = u64;
+}
+
+pub use core::ffi::c_void;
diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 52c502432447..5fece574ec02 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -153,11 +153,8 @@ pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
 
     /// Returns the error encoded as a pointer.
     pub fn to_ptr<T>(self) -> *mut T {
-        #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
-        unsafe {
-            bindings::ERR_PTR(self.0.get().into()) as *mut _
-        }
+        unsafe { bindings::ERR_PTR(self.0.get() as _) as *mut _ }
     }
 
     /// Returns a string representing the error, if one exists.
diff --git a/rust/kernel/firmware.rs b/rust/kernel/firmware.rs
index 13a374a5cdb7..c5162fdc95ff 100644
--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -12,7 +12,7 @@
 /// One of the following: `bindings::request_firmware`, `bindings::firmware_request_nowarn`,
 /// `bindings::firmware_request_platform`, `bindings::request_firmware_direct`.
 struct FwFunc(
-    unsafe extern "C" fn(*mut *const bindings::firmware, *const i8, *mut bindings::device) -> i32,
+    unsafe extern "C" fn(*mut *const bindings::firmware, *const u8, *mut bindings::device) -> i32,
 );
 
 impl FwFunc {
diff --git a/rust/kernel/uaccess.rs b/rust/kernel/uaccess.rs
index 66cc76e68428..5a3c2d4df65f 100644
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -8,7 +8,7 @@
     alloc::Flags,
     bindings,
     error::Result,
-    ffi::{c_ulong, c_void},
+    ffi::c_void,
     prelude::*,
     types::{AsBytes, FromBytes},
 };
@@ -224,13 +224,9 @@ pub fn read_raw(&mut self, out: &mut [MaybeUninit<u8>]) -> Result {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
-        // SAFETY: `out_ptr` points into a mutable slice of length `len_ulong`, so we may write
+        // SAFETY: `out_ptr` points into a mutable slice of length `len`, so we may write
         // that many bytes to it.
-        let res =
-            unsafe { bindings::copy_from_user(out_ptr, self.ptr as *const c_void, len_ulong) };
+        let res = unsafe { bindings::copy_from_user(out_ptr, self.ptr as *const c_void, len) };
         if res != 0 {
             return Err(EFAULT);
         }
@@ -259,9 +255,6 @@ pub fn read<T: FromBytes>(&mut self) -> Result<T> {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
         let mut out: MaybeUninit<T> = MaybeUninit::uninit();
         // SAFETY: The local variable `out` is valid for writing `size_of::<T>()` bytes.
         //
@@ -272,7 +265,7 @@ pub fn read<T: FromBytes>(&mut self) -> Result<T> {
             bindings::_copy_from_user(
                 out.as_mut_ptr().cast::<c_void>(),
                 self.ptr as *const c_void,
-                len_ulong,
+                len,
             )
         };
         if res != 0 {
@@ -335,12 +328,9 @@ pub fn write_slice(&mut self, data: &[u8]) -> Result {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
-        // SAFETY: `data_ptr` points into an immutable slice of length `len_ulong`, so we may read
+        // SAFETY: `data_ptr` points into an immutable slice of length `len`, so we may read
         // that many bytes from it.
-        let res = unsafe { bindings::copy_to_user(self.ptr as *mut c_void, data_ptr, len_ulong) };
+        let res = unsafe { bindings::copy_to_user(self.ptr as *mut c_void, data_ptr, len) };
         if res != 0 {
             return Err(EFAULT);
         }
@@ -359,9 +349,6 @@ pub fn write<T: AsBytes>(&mut self, value: &T) -> Result {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
         // SAFETY: The reference points to a value of type `T`, so it is valid for reading
         // `size_of::<T>()` bytes.
         //
@@ -372,7 +359,7 @@ pub fn write<T: AsBytes>(&mut self, value: &T) -> Result {
             bindings::_copy_to_user(
                 self.ptr as *mut c_void,
                 (value as *const T).cast::<c_void>(),
-                len_ulong,
+                len,
             )
         };
         if res != 0 {
-- 
2.48.1

