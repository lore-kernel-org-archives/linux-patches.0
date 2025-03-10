Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE25617C225;
	Mon, 10 Mar 2025 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627154; cv=none; b=X8jB3E1N76/RMjbXYzBQGkoRj39+RaeBA4w7L5nD1JiSb9dvq/txFJH92VAAgZSqQAEUej3Wz+es9YiM6NIxg18A3+Z57jZBl+TC+gPaf6EkveAdrTvYwlZ3hF9mWIRAZ4SgAXs9HLQT+T332Tnn0xJgFqMfLCQE6U+5Dl7mzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627154; c=relaxed/simple;
	bh=Uu54+qm7DnfQGVbqP8L8jk70yuLYTe2ZSpozUQJx4v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myzmXvQvomvItWB+xxjlQqfpvOtFL40trAty0ewkzyr41BJiEzimFWEU0oeGq2SlDcysdiBuORXlyVIzEqaxwbTVq+FB66C06XVCoITnb6cwrxZk52khkuPIHfBjhGHuXChabuSLy/aOOkkNFedKhOWS3a5RR1RLP+FyvNCeKyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEp9ovgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEp9ovgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12643C4CEEC;
	Mon, 10 Mar 2025 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627153;
	bh=Uu54+qm7DnfQGVbqP8L8jk70yuLYTe2ZSpozUQJx4v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEp9ovgOD52qBpKEYqK5VC4zkh3WiJXJWJ+zt/aFha3P91AXZrVVsy5faoeo5Dgvt
	 neePtI6k+X24VeNnqURbSNfztEtsZKZSBCnKBl1ufby5wO+3reDKRPDIiEMLmktWcl
	 sfIyPc8C6lT4ICuGvvw4pFUteRBtIyLiLeHOX4B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 031/269] rust: alloc: add `Allocator` trait
Date: Mon, 10 Mar 2025 18:03:04 +0100
Message-ID: <20250310170458.956138866@linuxfoundation.org>
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

commit b7a084ba4fbb8f416ce8d19c93a3a2bee63c9c89 upstream.

Add a kernel specific `Allocator` trait, that in contrast to the one in
Rust's core library doesn't require unstable features and supports GFP
flags.

Subsequent patches add the following trait implementors: `Kmalloc`,
`Vmalloc` and `KVmalloc`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-2-dakr@kernel.org
[ Fixed typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -11,6 +11,7 @@ pub mod vec_ext;
 /// Indicates an allocation error.
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
+use core::{alloc::Layout, ptr::NonNull};
 
 /// Flags to be used when allocating memory.
 ///
@@ -86,3 +87,103 @@ pub mod flags {
     /// small allocations.
     pub const GFP_NOWAIT: Flags = Flags(bindings::GFP_NOWAIT);
 }
+
+/// The kernel's [`Allocator`] trait.
+///
+/// An implementation of [`Allocator`] can allocate, re-allocate and free memory buffers described
+/// via [`Layout`].
+///
+/// [`Allocator`] is designed to be implemented as a ZST; [`Allocator`] functions do not operate on
+/// an object instance.
+///
+/// In order to be able to support `#[derive(SmartPointer)]` later on, we need to avoid a design
+/// that requires an `Allocator` to be instantiated, hence its functions must not contain any kind
+/// of `self` parameter.
+///
+/// # Safety
+///
+/// - A memory allocation returned from an allocator must remain valid until it is explicitly freed.
+///
+/// - Any pointer to a valid memory allocation must be valid to be passed to any other [`Allocator`]
+///   function of the same type.
+///
+/// - Implementers must ensure that all trait functions abide by the guarantees documented in the
+///   `# Guarantees` sections.
+pub unsafe trait Allocator {
+    /// Allocate memory based on `layout` and `flags`.
+    ///
+    /// On success, returns a buffer represented as `NonNull<[u8]>` that satisfies the layout
+    /// constraints (i.e. minimum size and alignment as specified by `layout`).
+    ///
+    /// This function is equivalent to `realloc` when called with `None`.
+    ///
+    /// # Guarantees
+    ///
+    /// When the return value is `Ok(ptr)`, then `ptr` is
+    /// - valid for reads and writes for `layout.size()` bytes, until it is passed to
+    ///   [`Allocator::free`] or [`Allocator::realloc`],
+    /// - aligned to `layout.align()`,
+    ///
+    /// Additionally, `Flags` are honored as documented in
+    /// <https://docs.kernel.org/core-api/mm-api.html#mm-api-gfp-flags>.
+    fn alloc(layout: Layout, flags: Flags) -> Result<NonNull<[u8]>, AllocError> {
+        // SAFETY: Passing `None` to `realloc` is valid by its safety requirements and asks for a
+        // new memory allocation.
+        unsafe { Self::realloc(None, layout, Layout::new::<()>(), flags) }
+    }
+
+    /// Re-allocate an existing memory allocation to satisfy the requested `layout`.
+    ///
+    /// If the requested size is zero, `realloc` behaves equivalent to `free`.
+    ///
+    /// If the requested size is larger than the size of the existing allocation, a successful call
+    /// to `realloc` guarantees that the new or grown buffer has at least `Layout::size` bytes, but
+    /// may also be larger.
+    ///
+    /// If the requested size is smaller than the size of the existing allocation, `realloc` may or
+    /// may not shrink the buffer; this is implementation specific to the allocator.
+    ///
+    /// On allocation failure, the existing buffer, if any, remains valid.
+    ///
+    /// The buffer is represented as `NonNull<[u8]>`.
+    ///
+    /// # Safety
+    ///
+    /// - If `ptr == Some(p)`, then `p` must point to an existing and valid memory allocation
+    ///   created by this [`Allocator`]; if `old_layout` is zero-sized `p` does not need to be a
+    ///   pointer returned by this [`Allocator`].
+    /// - `ptr` is allowed to be `None`; in this case a new memory allocation is created and
+    ///   `old_layout` is ignored.
+    /// - `old_layout` must match the `Layout` the allocation has been created with.
+    ///
+    /// # Guarantees
+    ///
+    /// This function has the same guarantees as [`Allocator::alloc`]. When `ptr == Some(p)`, then
+    /// it additionally guarantees that:
+    /// - the contents of the memory pointed to by `p` are preserved up to the lesser of the new
+    ///   and old size, i.e. `ret_ptr[0..min(layout.size(), old_layout.size())] ==
+    ///   p[0..min(layout.size(), old_layout.size())]`.
+    /// - when the return value is `Err(AllocError)`, then `ptr` is still valid.
+    unsafe fn realloc(
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError>;
+
+    /// Free an existing memory allocation.
+    ///
+    /// # Safety
+    ///
+    /// - `ptr` must point to an existing and valid memory allocation created by this [`Allocator`];
+    ///   if `old_layout` is zero-sized `p` does not need to be a pointer returned by this
+    ///   [`Allocator`].
+    /// - `layout` must match the `Layout` the allocation has been created with.
+    /// - The memory allocation at `ptr` must never again be read from or written to.
+    unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
+        // SAFETY: The caller guarantees that `ptr` points at a valid allocation created by this
+        // allocator. We are passing a `Layout` with the smallest possible alignment, so it is
+        // smaller than or equal to the alignment previously used with this allocation.
+        let _ = unsafe { Self::realloc(Some(ptr), Layout::new::<()>(), layout, Flags(0)) };
+    }
+}


