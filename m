Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C402580CE;
	Fri,  7 Mar 2025 22:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387912; cv=none; b=VJoxN0QbPtNThKL2w3l3VGCj/89v0kbo7HZXrP6cFUjyejyjqlTVD7vHaWRbjYr1uG4IzXowTk1lSS7K6sNWTnKeVcguMVepTJotR3CHc/0bfwS59wCF5+V4uwl4dXxDHyytzBlMyOPmSLA1V5V/tgKTGJT8kSWpx/sw65VJGXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387912; c=relaxed/simple;
	bh=PLefGRfWGNWn3il7VWMu4hRfMhhIQmexLq4Qe91k7PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcE8Srj/hPYHZGIYLgjHJ2NdlcWW7Pgt/V9gTXQ2O6aQauPn0aJg9a/VnahxpyqN1oUrDveYBwZ+d3CDAmXYHzNZr/lau9KKqODf3GHqTh4KRRz6fLqtOaDG+eIpwG6Lne80nM/ex7zjl+onJvUo+LdIJiyrdSayMX3wAEhjTNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ti1mhs1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ti1mhs1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396E5C4CEEB;
	Fri,  7 Mar 2025 22:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387912;
	bh=PLefGRfWGNWn3il7VWMu4hRfMhhIQmexLq4Qe91k7PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti1mhs1BhSbphjcCqPXAjaB2q9CHL+WFxI2biORz2SfjfeuI81QJ/y2Lh4mGutHEr
	 1o22Ka7ug5E6eqiVNXrcv+vcJbi1P9Rd3FJQN+8mBpyGLKBACst06igQlLkgqcTJBY
	 Aqm5b3p4N3uGvTY97gQyrrZ69H+89ZJcqV4w5GkXYWJ/0Lsvyflf+IboB1XfufC+k7
	 ralTjErF+UIHxhtgboECB0PjboXWgomHxONg33kA4K76rQkZeBbSslR9yMj926wzbE
	 T0Cwil8AmErYhfv4yQdnOhuaW02K7lLtSRO7a2f5f5ULlXUtQP2TcjBTDCLN6eYpil
	 Jah6MERF/RTbQ==
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
Subject: [PATCH 6.12.y 28/60] rust: alloc: implement `KVmalloc` allocator
Date: Fri,  7 Mar 2025 23:49:35 +0100
Message-ID: <20250307225008.779961-29-ojeda@kernel.org>
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

commit 8362c2608ba1be635ffa22a256dfcfe51c6238cc upstream.

Implement `Allocator` for `KVmalloc`, an `Allocator` that tries to
allocate memory with `kmalloc` first and, on failure, falls back to
`vmalloc`.

All memory allocations made with `KVmalloc` end up in
`kvrealloc_noprof()`; all frees in `kvfree()`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-10-dakr@kernel.org
[ Reworded typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/helpers/slab.c                 |  6 +++++
 rust/kernel/alloc/allocator.rs      | 36 +++++++++++++++++++++++++++++
 rust/kernel/alloc/allocator_test.rs |  1 +
 3 files changed, 43 insertions(+)

diff --git a/rust/helpers/slab.c b/rust/helpers/slab.c
index f043e087f9d6..a842bfbddcba 100644
--- a/rust/helpers/slab.c
+++ b/rust/helpers/slab.c
@@ -7,3 +7,9 @@ rust_helper_krealloc(const void *objp, size_t new_size, gfp_t flags)
 {
 	return krealloc(objp, new_size, flags);
 }
+
+void * __must_check __realloc_size(2)
+rust_helper_kvrealloc(const void *p, size_t size, gfp_t flags)
+{
+	return kvrealloc(p, size, flags);
+}
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index ee4c828cbd58..f8a1f0feb25d 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -34,6 +34,15 @@
 /// For more details see [self].
 pub struct Vmalloc;
 
+/// The kvmalloc kernel allocator.
+///
+/// `KVmalloc` attempts to allocate memory with `Kmalloc` first, but falls back to `Vmalloc` upon
+/// failure. This allocator is typically used when the size for the requested allocation is not
+/// known and may exceed the capabilities of `Kmalloc`.
+///
+/// For more details see [self].
+pub struct KVmalloc;
+
 /// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
 fn aligned_size(new_layout: Layout) -> usize {
     // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
@@ -76,6 +85,9 @@ impl ReallocFunc {
     // INVARIANT: `vrealloc` satisfies the type invariants.
     const VREALLOC: Self = Self(bindings::vrealloc);
 
+    // INVARIANT: `kvrealloc` satisfies the type invariants.
+    const KVREALLOC: Self = Self(bindings::kvrealloc);
+
     /// # Safety
     ///
     /// This method has the same safety requirements as [`Allocator::realloc`].
@@ -205,6 +217,30 @@ unsafe fn realloc(
     }
 }
 
+// SAFETY: `realloc` delegates to `ReallocFunc::call`, which guarantees that
+// - memory remains valid until it is explicitly freed,
+// - passing a pointer to a valid memory allocation is OK,
+// - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
+unsafe impl Allocator for KVmalloc {
+    #[inline]
+    unsafe fn realloc(
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError> {
+        // TODO: Support alignments larger than PAGE_SIZE.
+        if layout.align() > bindings::PAGE_SIZE {
+            pr_warn!("KVmalloc does not support alignments larger than PAGE_SIZE yet.\n");
+            return Err(AllocError);
+        }
+
+        // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
+        // allocated with this `Allocator`.
+        unsafe { ReallocFunc::KVREALLOC.call(ptr, layout, old_layout, flags) }
+    }
+}
+
 #[global_allocator]
 static ALLOCATOR: Kmalloc = Kmalloc;
 
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index 32a1450c4d39..bd0cbcd93e52 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -8,6 +8,7 @@
 
 pub struct Kmalloc;
 pub type Vmalloc = Kmalloc;
+pub type KVmalloc = Kmalloc;
 
 unsafe impl Allocator for Kmalloc {
     unsafe fn realloc(
-- 
2.48.1

