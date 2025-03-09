Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E291AC43A;
	Sun,  9 Mar 2025 09:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513760; cv=none; b=gKkLBwrzUyFGKqCarVeJZyCOPSvI12bvbX0bw6VlbOghR01+e3Rx1oSo4/37XsiwJuqfwj6tbQSEITxtZSnE5k031ZpUAdGAC7y7U/2Fiza0wH2F+QrSl5TcOCLDJ5OglqEmQfEhFp6NWC3FcH7Pd6q/2oFooHxYCwSDNAYlp4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513760; c=relaxed/simple;
	bh=/gUtRBS4nUZs0gJ4fS7KhF5R6EU9PnZ+KUrn2EQZ3yc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=u6KWg5IpxjvUsi93rq8kMYu6Z1aw1s2PrGwXk8lkt7K9BTE06X38okFkRp0Ky2BWQkAdrSMC/bm/+mAh4n2054kKbTX14TrpQiF5oPmoQRA3XJzyfDEHK+oPyyDkyiPPExSkMx9KX6BD0dZQXJbRknsKRACIlT2ftQnMAboeKmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6KGpP0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6KGpP0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD950C4CEE5;
	Sun,  9 Mar 2025 09:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513760;
	bh=/gUtRBS4nUZs0gJ4fS7KhF5R6EU9PnZ+KUrn2EQZ3yc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=s6KGpP0Ga2KnGWdpwoOz1b6zUD1boetn5+/RLXpbWB0hxgspRYO/OCJCrEH0g6h/7
	 nbGWEV8P7N8f6TQlIoWvGLIvEAESUro/OJuZm71xVXX9+Kz5aB65P8iyfUm65o9pSa
	 vPETMro/lb4fFoWtM+MYfncOcw9fZYKTR9zhFe3Y=
Subject: Patch "rust: alloc: implement `ReallocFunc`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,benno.lossin@proton.me,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:49 +0100
In-Reply-To: <20250307225008.779961-24-ojeda@kernel.org>
Message-ID: <2025030949-envoy-criteria-e591@gregkh>
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

    rust: alloc: implement `ReallocFunc`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-alloc-implement-reallocfunc.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121478-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:42 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:30 +0100
Subject: rust: alloc: implement `ReallocFunc`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-24-ojeda@kernel.org>

From: Danilo Krummrich <dakr@kernel.org>

commit 8a799831fc63c988eec90d334fdd68ff5f2c7eb5 upstream.

`ReallocFunc` is an abstraction for the kernel's realloc derivates, such
as `krealloc`, `vrealloc` and `kvrealloc`.

All of the named functions share the same function signature and
implement the same semantics. The `ReallocFunc` abstractions provides a
generalized wrapper around those, to trivialize the implementation of
`Kmalloc`, `Vmalloc` and `KVmalloc` in subsequent patches.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-5-dakr@kernel.org
[ Added temporary `allow(dead_code)` for `dangling_from_layout` to clean
  warning in `rusttest` target as discussed in the list (but it is
  needed earlier, i.e. in this patch already). Added colon. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs           |    9 +++++
 rust/kernel/alloc/allocator.rs |   70 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -187,3 +187,12 @@ pub unsafe trait Allocator {
         let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
     }
 }
+
+#[allow(dead_code)]
+/// Returns a properly aligned dangling pointer from the given `layout`.
+pub(crate) fn dangling_from_layout(layout: Layout) -> NonNull<u8> {
+    let ptr = layout.align() as *mut u8;
+
+    // SAFETY: `layout.align()` (and hence `ptr`) is guaranteed to be non-zero.
+    unsafe { NonNull::new_unchecked(ptr) }
+}
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -1,10 +1,20 @@
 // SPDX-License-Identifier: GPL-2.0
 
 //! Allocator support.
+//!
+//! Documentation for the kernel's memory allocators can found in the "Memory Allocation Guide"
+//! linked below. For instance, this includes the concept of "get free page" (GFP) flags and the
+//! typical application of the different kernel allocators.
+//!
+//! Reference: <https://docs.kernel.org/core-api/memory-allocation.html>
 
 use super::{flags::*, Flags};
 use core::alloc::{GlobalAlloc, Layout};
 use core::ptr;
+use core::ptr::NonNull;
+
+use crate::alloc::AllocError;
+use crate::bindings;
 
 struct Kmalloc;
 
@@ -36,6 +46,66 @@ pub(crate) unsafe fn krealloc_aligned(pt
     unsafe { bindings::krealloc(ptr as *const core::ffi::c_void, size, flags.0) as *mut u8 }
 }
 
+/// # Invariants
+///
+/// One of the following: `krealloc`, `vrealloc`, `kvrealloc`.
+struct ReallocFunc(
+    unsafe extern "C" fn(*const core::ffi::c_void, usize, u32) -> *mut core::ffi::c_void,
+);
+
+#[expect(dead_code)]
+impl ReallocFunc {
+    /// # Safety
+    ///
+    /// This method has the same safety requirements as [`Allocator::realloc`].
+    ///
+    /// # Guarantees
+    ///
+    /// This method has the same guarantees as `Allocator::realloc`. Additionally
+    /// - it accepts any pointer to a valid memory allocation allocated by this function.
+    /// - memory allocated by this function remains valid until it is passed to this function.
+    unsafe fn call(
+        &self,
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError> {
+        let size = aligned_size(layout);
+        let ptr = match ptr {
+            Some(ptr) => {
+                if old_layout.size() == 0 {
+                    ptr::null()
+                } else {
+                    ptr.as_ptr()
+                }
+            }
+            None => ptr::null(),
+        };
+
+        // SAFETY:
+        // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc` and thus only requires that
+        //   `ptr` is NULL or valid.
+        // - `ptr` is either NULL or valid by the safety requirements of this function.
+        //
+        // GUARANTEE:
+        // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc`.
+        // - Those functions provide the guarantees of this function.
+        let raw_ptr = unsafe {
+            // If `size == 0` and `ptr != NULL` the memory behind the pointer is freed.
+            self.0(ptr.cast(), size, flags.0).cast()
+        };
+
+        let ptr = if size == 0 {
+            crate::alloc::dangling_from_layout(layout)
+        } else {
+            NonNull::new(raw_ptr).ok_or(AllocError)?
+        };
+
+        Ok(NonNull::slice_from_raw_parts(ptr, size))
+    }
+}
+
 // SAFETY: TODO.
 unsafe impl GlobalAlloc for Kmalloc {
     unsafe fn alloc(&self, layout: Layout) -> *mut u8 {


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
