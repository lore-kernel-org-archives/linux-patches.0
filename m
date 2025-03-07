Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D818BC36;
	Fri,  7 Mar 2025 22:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387899; cv=none; b=jos4cz+5ioFX8zavUhkuBPi5IVJ051g+oMAglFUZRLanCwzNAVFcDfmlxbcpYlUsqdJMmQDRQADk1/zDC7P2OyFn3tp88FuaOLfWpbZl7eUWgcDDjsLo/+D0ffw43edzllpE5sdKhUIOmmqEyLyXlURVmHUyPwGkFLZZNRSWzys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387899; c=relaxed/simple;
	bh=ILUK4XFVor/V3PteVTvhKr5JSpbyORLNBSE83H5XI6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub81eaqFIjuCeCGAHPIQqpIILncJ/yWM4FC4S2zm3lyBMwXltKpfu3+Mje/kH0H2mpvQ+tCC0jk1tmvhMzx58rZg+0NPHfXp338e6OtXQFlrSAIoLgkFjPnACfMXoxAt/FEhKYFye4BVVCFCJ1TX2T9VX7NP81pP3FV2hGUD3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lEUu1nIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lEUu1nIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A37FC4CED1;
	Fri,  7 Mar 2025 22:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387898;
	bh=ILUK4XFVor/V3PteVTvhKr5JSpbyORLNBSE83H5XI6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEUu1nIqOG9puY6b11e+PeiRuR4M1MWu7QXndEoz1NBHCxPjP8cS2UOJ14igtV2FW
	 PyPhHCM6hMinGZEarrB7WbihXQvA/HFYa7vZQ/a8524FKmVNARyc1eYZ+5V2/9XMVW
	 4oxFZe84CaNp0lT228eluvTOLOBLcwvflF+U3+CmlgpAdaLMvA+190dykulywytFi3
	 m71Go5Z8gVdwHKS3CyzHJlhqS5+fVFe5SLiyMsbe4WDADKvo/27qESu8tM889e9XQ3
	 wgmiLVzQetILKHRZNh9T40rC+cHrjcBJkB0wXC7Mp57bJ849ZwUdZQiAmf/ZXEtE+H
	 cbHCwFAQLDCUg==
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
Subject: [PATCH 6.12.y 23/60] rust: alloc: implement `ReallocFunc`
Date: Fri,  7 Mar 2025 23:49:30 +0100
Message-ID: <20250307225008.779961-24-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 rust/kernel/alloc.rs           |  9 +++++
 rust/kernel/alloc/allocator.rs | 70 ++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 998779cc6976..95d402feb6ff 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -187,3 +187,12 @@ unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
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
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 3b1c735ba409..9ed122401e8a 100644
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
 
@@ -36,6 +46,66 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: F
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
-- 
2.48.1

