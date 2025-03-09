Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E31E5210;
	Sun,  9 Mar 2025 21:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741554157; cv=none; b=LWcvqjVmsdoq56rgYyQ8dXEDvYInaxboodaoscJzugdgYZQFTfCHJ2g6aDc/q/Pjbh/uETx3ImX1rUq3N14zo4Xj7FSgOaWQceJVqBVjGaWuTmm4zwGNT/PHiLczyLW0r50C6wPjDkqS7j9B439IgMZtVcogB7/tRKkEtKBqjSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741554157; c=relaxed/simple;
	bh=znbftPFKkJYlsmyv8423rZPlNTsEFqLd5kYPH6KawAA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=GcDntcw5Lv4Emb3Qw2Jjeicok0aYaMdZUKHOvXtd+WqCqWMim8FcVqbP8//jiG1lYwOTQXVKpOrO8GIghYL/xLJuRBAIy/YJzbYgZCGmexz4fa7iNdVoEqyZ5JsitbAXUA/1d4oaetR+P+GuJpxlorJ6s9ixbyhxAQosckTdvLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBwACEl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBwACEl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA20BC4CEE3;
	Sun,  9 Mar 2025 21:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741554157;
	bh=znbftPFKkJYlsmyv8423rZPlNTsEFqLd5kYPH6KawAA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=SBwACEl3vknEFBL2tQEYqQwRYyWHgblj3Q9kuLvb9eie9RszgG+IEooEtfoF0Kbjc
	 mlJD+bwuB0nht12xmr1lZrfWUEnFxB+9bXBpXaTSqDtQ4XZGDrRjc3trPNnLrXKaJe
	 vLMFOAtNfopKeMmMn1/MTm+3OjhKCIhVK+dquruM=
Subject: Patch "rust: map `long` to `isize` and `char` to `u8`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 22:02:26 +0100
In-Reply-To: <20250309204217.1553389-3-ojeda@kernel.org>
Message-ID: <2025030926-pretzel-prune-b1b0@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    rust: map `long` to `isize` and `char` to `u8`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-map-long-to-isize-and-char-to-u8.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121623-greg=kroah.com@vger.kernel.org Sun Mar  9 21:42:43 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Sun,  9 Mar 2025 21:42:17 +0100
Subject: rust: map `long` to `isize` and `char` to `u8`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250309204217.1553389-3-ojeda@kernel.org>

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


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-map-long-to-isize-and-char-to-u8.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-finish-using-custom-ffi-integer-types.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
