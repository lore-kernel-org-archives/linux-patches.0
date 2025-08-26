Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D002F9992;
	Tue, 26 Aug 2025 11:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208838; cv=none; b=jZA+mQN+k0tiKjdLh+Uyg1S5XHHV+iggaBAp9r/BYzTh/bPGZpr+jRcyn0Yyfhbdm1in9i1zOznOV1m5Prj3ipVv8UiVGCrTnUJCS+wLG0Sv/g34qZSUGLMqlMnVbtr+8yk67WfGgxe2jFl+j1UoEIGlzUapN6rsXiT5Xwzkyig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208838; c=relaxed/simple;
	bh=mjSzy1uF7xBRx6718FRRWRFlQj+or6OqalAjqv1pS2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHSiCihk9J+zhxpM+Mvv2yJlj1z5Hzs56honLLKfRbv9yP/Em5vtVrSVChKwW7RD915Skb0WOSDpTE/waH7iyj5kcKTPaI7xvrKxX88zWuvK4oBAHGTePG9uQecflTAtEsKrbmHOkv4Fy5wcYnbPk+rxQvuPf/pHHjvamhnN4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXE+4l7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXE+4l7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF52C4CEF1;
	Tue, 26 Aug 2025 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208837;
	bh=mjSzy1uF7xBRx6718FRRWRFlQj+or6OqalAjqv1pS2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXE+4l7ERWjGJ8ljflAszxWUokzxmcX51kKVVc3/v/Y4GrCXbP0Pa+JcODokVP/0f
	 kIiSCzzFY7TTpNDyR9yjKzyB6X5dlJMe/+5T9GhqKuQ5Bp4Rd5rpUFc3+grlBSBRQa
	 pq2bRg1lGi9gGgA3+6MK+V+DNUqjOYWjP/7uA5Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/322] rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826110922.452427762@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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
index 439985e29fbc..e4cd29100007 100644
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
@@ -87,7 +76,7 @@ impl ReallocFunc {
         old_layout: Layout,
         flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        let size = aligned_size(layout);
+        let size = layout.size();
         let ptr = match ptr {
             Some(ptr) => {
                 if old_layout.size() == 0 {
@@ -122,6 +111,17 @@ impl ReallocFunc {
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
@@ -134,6 +134,8 @@ unsafe impl Allocator for Kmalloc {
         old_layout: Layout,
         flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
+        let layout = Kmalloc::aligned_layout(layout);
+
         // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
         unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
     }
@@ -175,6 +177,10 @@ unsafe impl Allocator for KVmalloc {
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



