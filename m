Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961851AE00E;
	Sun,  9 Mar 2025 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513742; cv=none; b=NfM8HyKVJp1C+wn91/fYwWJFNQ8donukX3stritbe7pzdZWcWtjxfoPg2/5IId+fgEc7drQ2DxySIRzU+IJuM0OI3enZWa+2jKf+oS5Y38cGa8Nc5OxIlPnnX3F81OjFZRE400GVZbWkRRPTyAS3KLf4TPvzsigxqS9sz+Dd+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513742; c=relaxed/simple;
	bh=Ayn8/9Xo/kADY/8L4YNsjiEPvs1n7nVSkPrWnnd2NLk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=K2mfOO35FTQCKV9pZuoTg1en5sIXau3U0lr5RJHc8jhFFSqQr1sLu/YnHv1T+nOtq1ud7Tvh0Mx11gzEVPHZCtymUD64HxQt1dJQ1/IpmnSmBonheRidRkVQ9HPXOkZm3Vuuz6t5O5lBsThOQOR7gmpip4/K+k3eU6GlvVpM/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVX1/eHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVX1/eHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020A8C4CEE5;
	Sun,  9 Mar 2025 09:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513742;
	bh=Ayn8/9Xo/kADY/8L4YNsjiEPvs1n7nVSkPrWnnd2NLk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=QVX1/eHDD6fM97j8rH+rDk2w+jDVeZtAmqQmTBncpKUGW2aablNngK5T+jR0lDzLc
	 gbyoMV1XXQ+3UA8w9hVOBdIgd0s86zizNXqMxt8JXVBXAfaiSnf7C0gAFIi53DZMje
	 yRxm4telU+jGVqGQSeDIPXJ31BXh6mfPcIp4AUHc=
Subject: Patch "rust: alloc: implement `collect` for `IntoIter`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,benno.lossin@proton.me,dakr@kernel.org,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:49 +0100
In-Reply-To: <20250307225008.779961-38-ojeda@kernel.org>
Message-ID: <2025030949-resonant-worsening-97eb@gregkh>
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

    rust: alloc: implement `collect` for `IntoIter`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-alloc-implement-collect-for-intoiter.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121492-greg=kroah.com@vger.kernel.org Fri Mar  7 23:52:20 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:44 +0100
Subject: rust: alloc: implement `collect` for `IntoIter`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-38-ojeda@kernel.org>

From: Danilo Krummrich <dakr@kernel.org>

commit 93e602310f87b7b515b86a8f919cc0799387e5c3 upstream.

Currently, we can't implement `FromIterator`. There are a couple of
issues with this trait in the kernel, namely:

  - Rust's specialization feature is unstable. This prevents us to
    optimize for the special case where `I::IntoIter` equals `Vec`'s
    `IntoIter` type.
  - We also can't use `I::IntoIter`'s type ID either to work around this,
    since `FromIterator` doesn't require this type to be `'static`.
  - `FromIterator::from_iter` does return `Self` instead of
    `Result<Self, AllocError>`, hence we can't properly handle allocation
    failures.
  - Neither `Iterator::collect` nor `FromIterator::from_iter` can handle
    additional allocation flags.

Instead, provide `IntoIter::collect`, such that we can at least convert
`IntoIter` into a `Vec` again.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-19-dakr@kernel.org
[ Added newline in documentation, changed case of section to be
  consistent with an existing one, fixed typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/kvec.rs |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -692,6 +692,101 @@ pub struct IntoIter<T, A: Allocator> {
     _p: PhantomData<A>,
 }
 
+impl<T, A> IntoIter<T, A>
+where
+    A: Allocator,
+{
+    fn into_raw_parts(self) -> (*mut T, NonNull<T>, usize, usize) {
+        let me = ManuallyDrop::new(self);
+        let ptr = me.ptr;
+        let buf = me.buf;
+        let len = me.len;
+        let cap = me.layout.len();
+        (ptr, buf, len, cap)
+    }
+
+    /// Same as `Iterator::collect` but specialized for `Vec`'s `IntoIter`.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let v = kernel::kvec![1, 2, 3]?;
+    /// let mut it = v.into_iter();
+    ///
+    /// assert_eq!(it.next(), Some(1));
+    ///
+    /// let v = it.collect(GFP_KERNEL);
+    /// assert_eq!(v, [2, 3]);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    ///
+    /// # Implementation details
+    ///
+    /// Currently, we can't implement `FromIterator`. There are a couple of issues with this trait
+    /// in the kernel, namely:
+    ///
+    /// - Rust's specialization feature is unstable. This prevents us to optimize for the special
+    ///   case where `I::IntoIter` equals `Vec`'s `IntoIter` type.
+    /// - We also can't use `I::IntoIter`'s type ID either to work around this, since `FromIterator`
+    ///   doesn't require this type to be `'static`.
+    /// - `FromIterator::from_iter` does return `Self` instead of `Result<Self, AllocError>`, hence
+    ///   we can't properly handle allocation failures.
+    /// - Neither `Iterator::collect` nor `FromIterator::from_iter` can handle additional allocation
+    ///   flags.
+    ///
+    /// Instead, provide `IntoIter::collect`, such that we can at least convert a `IntoIter` into a
+    /// `Vec` again.
+    ///
+    /// Note that `IntoIter::collect` doesn't require `Flags`, since it re-uses the existing backing
+    /// buffer. However, this backing buffer may be shrunk to the actual count of elements.
+    pub fn collect(self, flags: Flags) -> Vec<T, A> {
+        let old_layout = self.layout;
+        let (mut ptr, buf, len, mut cap) = self.into_raw_parts();
+        let has_advanced = ptr != buf.as_ptr();
+
+        if has_advanced {
+            // Copy the contents we have advanced to at the beginning of the buffer.
+            //
+            // SAFETY:
+            // - `ptr` is valid for reads of `len * size_of::<T>()` bytes,
+            // - `buf.as_ptr()` is valid for writes of `len * size_of::<T>()` bytes,
+            // - `ptr` and `buf.as_ptr()` are not be subject to aliasing restrictions relative to
+            //   each other,
+            // - both `ptr` and `buf.ptr()` are properly aligned.
+            unsafe { ptr::copy(ptr, buf.as_ptr(), len) };
+            ptr = buf.as_ptr();
+
+            // SAFETY: `len` is guaranteed to be smaller than `self.layout.len()`.
+            let layout = unsafe { ArrayLayout::<T>::new_unchecked(len) };
+
+            // SAFETY: `buf` points to the start of the backing buffer and `len` is guaranteed to be
+            // smaller than `cap`. Depending on `alloc` this operation may shrink the buffer or leaves
+            // it as it is.
+            ptr = match unsafe {
+                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags)
+            } {
+                // If we fail to shrink, which likely can't even happen, continue with the existing
+                // buffer.
+                Err(_) => ptr,
+                Ok(ptr) => {
+                    cap = len;
+                    ptr.as_ptr().cast()
+                }
+            };
+        }
+
+        // SAFETY: If the iterator has been advanced, the advanced elements have been copied to
+        // the beginning of the buffer and `len` has been adjusted accordingly.
+        //
+        // - `ptr` is guaranteed to point to the start of the backing buffer.
+        // - `cap` is either the original capacity or, after shrinking the buffer, equal to `len`.
+        // - `alloc` is guaranteed to be unchanged since `into_iter` has been called on the original
+        //   `Vec`.
+        unsafe { Vec::from_raw_parts(ptr, len, cap) }
+    }
+}
+
 impl<T, A> Iterator for IntoIter<T, A>
 where
     A: Allocator,


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
