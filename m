Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8739522D4C3;
	Mon, 10 Mar 2025 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627717; cv=none; b=Wad10YheA4nyAuiLhezAmrIW797Ofqrr2JlBl2/e41VWZyahG9x4ltLrWzS9aRwKOKm5lDIfbIFEI1t9WwCov5/T3mFq0THuhp47jwwLdXfdcv+3N5EzQoW/lV9w+ONq4wYrFcGQVDct2yKX+lsQ2LkNCuIdHiWKrCBaEZBsmS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627717; c=relaxed/simple;
	bh=MbtHpB0LfGz6o6zQku2y8ZMssZ45/jDJ2wORBU4bJJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFBYDq31TfcjrFoLhuVkw1Z567YP1tHMsgBrzAwVnJ37tYs87ILAP5dVr1qBqAXcFbJGlCzbZXZHnIgxIn9HNhTkmiZccWouNLwRWj4yLhoTgOgI1VKnyxbcNRe3nx/YwOaQXtBHIjaENPwPhuxOCnL8iguG617JHe9lJawoVyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMWwe8eP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMWwe8eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D263C4CEE5;
	Mon, 10 Mar 2025 17:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627717;
	bh=MbtHpB0LfGz6o6zQku2y8ZMssZ45/jDJ2wORBU4bJJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMWwe8ePpt3P12MjRCFLdPw36CcuEWAIYSW+PyPXHVgBclNXvMCgW+oYIhf5cyCBe
	 RwgWPef/5crr/W2fz2JT9fN4ApHcsykp/gV3QgB1aoLMjP7oY8WeUuYTYpRRLRiJOi
	 OcJCKn/sP/bS5NvsPHEJESdTx4685ngfW4fey17k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 226/269] rust: map `long` to `isize` and `char` to `u8`
Date: Mon, 10 Mar 2025 18:06:19 +0100
Message-ID: <20250310170506.695249114@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/ffi.rs             |   37 ++++++++++++++++++++++++++++++++++++-
 rust/kernel/error.rs    |    5 +----
 rust/kernel/firmware.rs |    2 +-
 rust/kernel/uaccess.rs  |   27 +++++++--------------------
 4 files changed, 45 insertions(+), 26 deletions(-)

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
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -153,11 +153,8 @@ impl Error {
 
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
--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -12,7 +12,7 @@ use core::ptr::NonNull;
 /// One of the following: `bindings::request_firmware`, `bindings::firmware_request_nowarn`,
 /// `bindings::firmware_request_platform`, `bindings::request_firmware_direct`.
 struct FwFunc(
-    unsafe extern "C" fn(*mut *const bindings::firmware, *const i8, *mut bindings::device) -> i32,
+    unsafe extern "C" fn(*mut *const bindings::firmware, *const u8, *mut bindings::device) -> i32,
 );
 
 impl FwFunc {
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -8,7 +8,7 @@ use crate::{
     alloc::Flags,
     bindings,
     error::Result,
-    ffi::{c_ulong, c_void},
+    ffi::c_void,
     prelude::*,
     types::{AsBytes, FromBytes},
 };
@@ -224,13 +224,9 @@ impl UserSliceReader {
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
@@ -259,9 +255,6 @@ impl UserSliceReader {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
         let mut out: MaybeUninit<T> = MaybeUninit::uninit();
         // SAFETY: The local variable `out` is valid for writing `size_of::<T>()` bytes.
         //
@@ -272,7 +265,7 @@ impl UserSliceReader {
             bindings::_copy_from_user(
                 out.as_mut_ptr().cast::<c_void>(),
                 self.ptr as *const c_void,
-                len_ulong,
+                len,
             )
         };
         if res != 0 {
@@ -335,12 +328,9 @@ impl UserSliceWriter {
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
@@ -359,9 +349,6 @@ impl UserSliceWriter {
         if len > self.length {
             return Err(EFAULT);
         }
-        let Ok(len_ulong) = c_ulong::try_from(len) else {
-            return Err(EFAULT);
-        };
         // SAFETY: The reference points to a value of type `T`, so it is valid for reading
         // `size_of::<T>()` bytes.
         //
@@ -372,7 +359,7 @@ impl UserSliceWriter {
             bindings::_copy_to_user(
                 self.ptr as *mut c_void,
                 (value as *const T).cast::<c_void>(),
-                len_ulong,
+                len,
             )
         };
         if res != 0 {


