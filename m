Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E02415AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CCCC433C7;
	Wed,  9 Aug 2023 10:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578094;
	bh=diZeuY1PlD3Ey7jm6sOVp1+uVq7bgI3PtpxnMFrjdd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15VeHeYXsK4YFvt/S+BuT159YL4zD6jCVpgYBvBVGt6DrDo07zc9Hx1/2khvS7nAe
	 xHaJeBTNtcKx8/zAmpqU8sjmpx4jT+l1DCuHOnw5PnrqNciZOWipd0/lokvW7aTwP7
	 Faah1oHyw0YVZj7VbDqqSXfVt87MlbGBH6dE8d/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	"Andreas Hindborg (Samsung)" <nmi@metaspace.dk>,
	Boqun Feng <boqun.feng@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.4 096/165] rust: allocator: Prevent mis-aligned allocation
Date: Wed,  9 Aug 2023 12:40:27 +0200
Message-ID: <20230809103645.922255823@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Boqun Feng <boqun.feng@gmail.com>

commit b3d8aa84bbfe9b58ccc5332cacf8ea17200af310 upstream.

Currently the rust allocator simply passes the size of the type Layout
to krealloc(), and in theory the alignment requirement from the type
Layout may be larger than the guarantee provided by SLAB, which means
the allocated object is mis-aligned.

Fix this by adjusting the allocation size to the nearest power of two,
which SLAB always guarantees a size-aligned allocation. And because Rust
guarantees that the original size must be a multiple of alignment and
the alignment must be a power of two, then the alignment requirement is
satisfied.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Co-developed-by: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
Signed-off-by: "Andreas Hindborg (Samsung)" <nmi@metaspace.dk>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: stable@vger.kernel.org # v6.1+
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Fixes: 247b365dc8dc ("rust: add `kernel` crate")
Link: https://github.com/Rust-for-Linux/linux/issues/974
Link: https://lore.kernel.org/r/20230730012905.643822-2-boqun.feng@gmail.com
[ Applied rewording of comment as discussed in the mailing list. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/bindings_helper.h |    1 
 rust/kernel/allocator.rs        |   74 +++++++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 15 deletions(-)

--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -12,5 +12,6 @@
 #include <linux/sched.h>
 
 /* `bindgen` gets confused at certain things. */
+const size_t BINDINGS_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const gfp_t BINDINGS_GFP_KERNEL = GFP_KERNEL;
 const gfp_t BINDINGS___GFP_ZERO = __GFP_ZERO;
--- a/rust/kernel/allocator.rs
+++ b/rust/kernel/allocator.rs
@@ -9,6 +9,36 @@ use crate::bindings;
 
 struct KernelAllocator;
 
+/// Calls `krealloc` with a proper size to alloc a new object aligned to `new_layout`'s alignment.
+///
+/// # Safety
+///
+/// - `ptr` can be either null or a pointer which has been allocated by this allocator.
+/// - `new_layout` must have a non-zero size.
+unsafe fn krealloc_aligned(ptr: *mut u8, new_layout: Layout, flags: bindings::gfp_t) -> *mut u8 {
+    // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
+    let layout = new_layout.pad_to_align();
+
+    let mut size = layout.size();
+
+    if layout.align() > bindings::BINDINGS_ARCH_SLAB_MINALIGN {
+        // The alignment requirement exceeds the slab guarantee, thus try to enlarge the size
+        // to use the "power-of-two" size/alignment guarantee (see comments in `kmalloc()` for
+        // more information).
+        //
+        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
+        // `layout.align()`, so `next_power_of_two` gives enough alignment guarantee.
+        size = size.next_power_of_two();
+    }
+
+    // SAFETY:
+    // - `ptr` is either null or a pointer returned from a previous `k{re}alloc()` by the
+    //   function safety requirement.
+    // - `size` is greater than 0 since it's either a `layout.size()` (which cannot be zero
+    //    according to the function safety requirement) or a result from `next_power_of_two()`.
+    unsafe { bindings::krealloc(ptr as *const core::ffi::c_void, size, flags) as *mut u8 }
+}
+
 unsafe impl GlobalAlloc for KernelAllocator {
     unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
         // `krealloc()` is used instead of `kmalloc()` because the latter is
@@ -30,10 +60,20 @@ static ALLOCATOR: KernelAllocator = Kern
 // to extract the object file that has them from the archive. For the moment,
 // let's generate them ourselves instead.
 //
+// Note: Although these are *safe* functions, they are called by the compiler
+// with parameters that obey the same `GlobalAlloc` function safety
+// requirements: size and align should form a valid layout, and size is
+// greater than 0.
+//
 // Note that `#[no_mangle]` implies exported too, nowadays.
 #[no_mangle]
-fn __rust_alloc(size: usize, _align: usize) -> *mut u8 {
-    unsafe { bindings::krealloc(core::ptr::null(), size, bindings::GFP_KERNEL) as *mut u8 }
+fn __rust_alloc(size: usize, align: usize) -> *mut u8 {
+    // SAFETY: See assumption above.
+    let layout = unsafe { Layout::from_size_align_unchecked(size, align) };
+
+    // SAFETY: `ptr::null_mut()` is null, per assumption above the size of `layout` is greater
+    // than 0.
+    unsafe { krealloc_aligned(ptr::null_mut(), layout, bindings::GFP_KERNEL) }
 }
 
 #[no_mangle]
@@ -42,23 +82,27 @@ fn __rust_dealloc(ptr: *mut u8, _size: u
 }
 
 #[no_mangle]
-fn __rust_realloc(ptr: *mut u8, _old_size: usize, _align: usize, new_size: usize) -> *mut u8 {
-    unsafe {
-        bindings::krealloc(
-            ptr as *const core::ffi::c_void,
-            new_size,
-            bindings::GFP_KERNEL,
-        ) as *mut u8
-    }
+fn __rust_realloc(ptr: *mut u8, _old_size: usize, align: usize, new_size: usize) -> *mut u8 {
+    // SAFETY: See assumption above.
+    let new_layout = unsafe { Layout::from_size_align_unchecked(new_size, align) };
+
+    // SAFETY: Per assumption above, `ptr` is allocated by `__rust_*` before, and the size of
+    // `new_layout` is greater than 0.
+    unsafe { krealloc_aligned(ptr, new_layout, bindings::GFP_KERNEL) }
 }
 
 #[no_mangle]
-fn __rust_alloc_zeroed(size: usize, _align: usize) -> *mut u8 {
+fn __rust_alloc_zeroed(size: usize, align: usize) -> *mut u8 {
+    // SAFETY: See assumption above.
+    let layout = unsafe { Layout::from_size_align_unchecked(size, align) };
+
+    // SAFETY: `ptr::null_mut()` is null, per assumption above the size of `layout` is greater
+    // than 0.
     unsafe {
-        bindings::krealloc(
-            core::ptr::null(),
-            size,
+        krealloc_aligned(
+            ptr::null_mut(),
+            layout,
             bindings::GFP_KERNEL | bindings::__GFP_ZERO,
-        ) as *mut u8
+        )
     }
 }


