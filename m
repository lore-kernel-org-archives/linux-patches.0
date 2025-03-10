Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FF1231A2A;
	Mon, 10 Mar 2025 17:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627162; cv=none; b=aqgn4mYDRtfMb6f7IEcEpaWDPiRlj+Ra8OSex9VJyFfXNGchNtqlWjLdtN3kqPKhx2ZpfpLIRHvkEV0emVFuMKMP3kl4/s2xAeOXb7gQiLj5dKGtZZvogxD6pcweG0bHeTUYEBAoaDe+oqkMT0YL8TekrKVLMwZvaVgDnSPSW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627162; c=relaxed/simple;
	bh=IyQ6220qUo43GQaoKtPR5rX7GW335qpkADhou0eHkYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkHQU1iO9hAT2+0Gr2RX3SYFjiWo2dOtCjP7Rxa6mmQLSWeQ8rb3qtF+24clLxABr/DED2H/L9773mCQdJI9zUEb4O4Rt32Ee4SFoHdsVX/3xMYj24+TyzX+jyfRmi+d6BY6qLV3jgth4nSVWF1xgpbzOoF1YFUc2ZXyrhEJQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln8pAq2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln8pAq2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14D2C4CEEC;
	Mon, 10 Mar 2025 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627162;
	bh=IyQ6220qUo43GQaoKtPR5rX7GW335qpkADhou0eHkYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ln8pAq2feXl68LV9iWPHkXrE4Rwo9tEJaDFFR8lz3MTfaf8sYc7s0w2NnDk7RIdYK
	 1WftKn2SqBq+VdHWaPFdg73vID7iKTiS2367l25hrHxgIz1FLgomGj85VoNDla+AMG
	 sJ1FrylZFTRSfNIgm0mWEQaFHP9j2lAa5aT2PyXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 034/269] rust: alloc: implement `ReallocFunc`
Date: Mon, 10 Mar 2025 18:03:07 +0100
Message-ID: <20250310170459.075906720@linuxfoundation.org>
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


