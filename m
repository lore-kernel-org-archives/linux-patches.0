Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363832144B;
	Tue, 26 Aug 2025 11:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207959; cv=none; b=B918ZgBWyQH/kxsDCAOVjA+/EVztJerfCVRWAY/4DA49RMYdvBLAziA6BfyLpYV2rKMJt1bd5GSIqIgJ9fJ4kdch6hmGFxkJhTdpcZ9HOENa1E3AYE8Ci63cc6un0qdfTs8OFcUyDYOZhB2JSnicw0jn9pwt7XwLk905rlJRXwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207959; c=relaxed/simple;
	bh=hINt2RYz1hVIanxuI5wet5r9iqwDzvv59AaIMHlnR54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+pI64PXKp5kbWfEETD9BEr7htHXoTf64q22dAJJqYtWlMtVW4J1dmvU4GoeDjUzAkElBC0IG/ivwXAlUy6cfHyRdosPQ0j7YebpzHTUGd1y9xf1yrePcFbxX3WgDK93Nc/VOSOM2P72kLPq0pbezxzg92hMKGFDkbU01oHPcHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0zWxKpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0zWxKpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D2DC4CEF4;
	Tue, 26 Aug 2025 11:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207958;
	bh=hINt2RYz1hVIanxuI5wet5r9iqwDzvv59AaIMHlnR54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0zWxKpX9W+/zDx305vggs3SfsCNXM+ScT1PLBbB5/ZwjTqfuX8VOSpdZ+nT8CmCZ
	 3U1JS5b860DEg4VnkEPCTkkDHrIwWAHVzP8UObxG0sf5BnUykRBxl+C4W9RUz7TDbF
	 pagzaTzpQzpy4zylcHzGykEAp/5IAmvnB9xhVT+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 352/457] rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()
Date: Tue, 26 Aug 2025 13:10:36 +0200
Message-ID: <20250826110946.020935439@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit fde578c86281f27b182680c7642836a0dbbd0be7 ]

aligned_size() dates back to when Rust did support kmalloc() only, but
is now used in ReallocFunc::call() and hence for all allocators.

However, the additional padding applied by aligned_size() is only
required by the kmalloc() allocator backend.

Hence, replace aligned_size() with Kmalloc::aligned_layout() and use it
for the affected allocators, i.e. kmalloc() and kvmalloc(), only.

While at it, make Kmalloc::aligned_layout() public, such that Rust
abstractions, which have to call subsystem specific kmalloc() based
allocation primitives directly, can make use of it.

Fixes: 8a799831fc63 ("rust: alloc: implement `ReallocFunc`")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250731154919.4132-2-dakr@kernel.org
[ Remove `const` from Kmalloc::aligned_layout(). - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/allocator.rs | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index aa2dfa9dca4c..2692cf90c948 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -43,17 +43,6 @@ pub struct Vmalloc;
 /// For more details see [self].
 pub struct KVmalloc;
 
-/// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
-fn aligned_size(new_layout: Layout) -> usize {
-    // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
-    let layout = new_layout.pad_to_align();
-
-    // Note that `layout.size()` (after padding) is guaranteed to be a multiple of `layout.align()`
-    // which together with the slab guarantees means the `krealloc` will return a properly aligned
-    // object (see comments in `kmalloc()` for more information).
-    layout.size()
-}
-
 /// # Invariants
 ///
 /// One of the following: `krealloc`, `vrealloc`, `kvrealloc`.
@@ -88,7 +77,7 @@ impl ReallocFunc {
         old_layout: Layout,
         flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        let size = aligned_size(layout);
+        let size = layout.size();
         let ptr = match ptr {
             Some(ptr) => {
                 if old_layout.size() == 0 {
@@ -123,6 +112,17 @@ impl ReallocFunc {
     }
 }
 
+impl Kmalloc {
+    /// Returns a [`Layout`] that makes [`Kmalloc`] fulfill the requested size and alignment of
+    /// `layout`.
+    pub fn aligned_layout(layout: Layout) -> Layout {
+        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
+        // `layout.align()` which together with the slab guarantees means that `Kmalloc` will return
+        // a properly aligned object (see comments in `kmalloc()` for more information).
+        layout.pad_to_align()
+    }
+}
+
 // SAFETY: `realloc` delegates to `ReallocFunc::call`, which guarantees that
 // - memory remains valid until it is explicitly freed,
 // - passing a pointer to a valid memory allocation is OK,
@@ -135,6 +135,8 @@ unsafe impl Allocator for Kmalloc {
         old_layout: Layout,
         flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
+        let layout = Kmalloc::aligned_layout(layout);
+
         // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
         unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
     }
@@ -176,6 +178,10 @@ unsafe impl Allocator for KVmalloc {
         old_layout: Layout,
         flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
+        // `KVmalloc` may use the `Kmalloc` backend, hence we have to enforce a `Kmalloc`
+        // compatible layout.
+        let layout = Kmalloc::aligned_layout(layout);
+
         // TODO: Support alignments larger than PAGE_SIZE.
         if layout.align() > bindings::PAGE_SIZE {
             pr_warn!("KVmalloc does not support alignments larger than PAGE_SIZE yet.\n");
-- 
2.50.1



