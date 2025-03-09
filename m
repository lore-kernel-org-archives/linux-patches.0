Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E331B0F18;
	Sun,  9 Mar 2025 09:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513818; cv=none; b=QQkwPzBdG45vC9C6iYxngXHk52QucSMSZVD8i7sA/OH/rusi8U49YdncGsbTtTUSLEmSipdKbqoN8NTexQR0UoIB2034tM60IEnU6hdmsH7WmARhu3Rd7/cFbziYEyvz8UTU7v4AVfMgAnqQfJ2lPTJPi7zuv9795N8i+TPzUHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513818; c=relaxed/simple;
	bh=tQfqnYSSZsUQoyGhEIdODEVbkTlUA4Hznl0JfZhFf1Y=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=V7zgr8ZCu8ie2gQEzZWHj7TOMkTPVVVpOZk/KIC/nU5tX/oRp+YCEdMhjB2Nz15FQiGK8LrBfSgReDfEyC+7l0YFqd8V8p5C/ZLfRswC52b+hu7gMrwoMmuAK1oZ1E/u+RGkVcMqjP6P2ehpsYndF0MG1mPqveaX+QiCA6ysQzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKrWqOzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKrWqOzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3221FC4CEE5;
	Sun,  9 Mar 2025 09:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513818;
	bh=tQfqnYSSZsUQoyGhEIdODEVbkTlUA4Hznl0JfZhFf1Y=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=WKrWqOzYAP7EUBeIBRuVf9iTlMsdUBRSmwd3SVzTE9LxjpJsXc8ixXlWRwcm8MlpJ
	 afeQ8Y3P5NdajSvW35IO+UvhFjDfXoP3t9i4cizbm7pGI3h8O8BVA77cn9pAXroS4C
	 hGdY5MzafA2rhxEBnELDPOiaoO30BnvNwEL6xoMw=
Subject: Patch "rust: error: optimize error type to use nonzero" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,felipe_life@live.com,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,me@kloenk.dev,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-20-ojeda@kernel.org>
Message-ID: <2025030951-enrich-natural-d2d6@gregkh>
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

    rust: error: optimize error type to use nonzero

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-error-optimize-error-type-to-use-nonzero.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121474-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:30 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:26 +0100
Subject: rust: error: optimize error type to use nonzero
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-20-ojeda@kernel.org>

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


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
