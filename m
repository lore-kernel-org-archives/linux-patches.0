Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52D1B393D;
	Sun,  9 Mar 2025 09:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513856; cv=none; b=Y7222DmHANTbZPUvx4DhyhagC27apf9BZOawg9vAI5qEvddEwDPFCVSVPRlVJwlUegJnM85LfZILpDEP8kVsDFpfhwE9H4QimIV59vUma9j1iXPnGJxsuRp+CFFQEhe0G0sxzVHPUqNIQdctaRwteejJK6C7diTc5prNheKCVTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513856; c=relaxed/simple;
	bh=QTnS0JVouNfv92gsV1GhBHMAMDQd8Ad/4J6wC+dZMKs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=fBk7dQwqs6HrkhIzRdHtVmpO0rCZHeIEal/SAQV5o7yZUB072BnbQAsAnL7Ft6bVfnALucC6f3hrzExcPxkpx1MldB00pcB1GXJ70auA6f8Sfa3D09fyUEeZp9TI/UZVNR6HGUdKPClViBv1e/mHlQrd+sdWOf6KymWfaiGtWFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxNwUffv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxNwUffv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D02C4CEE5;
	Sun,  9 Mar 2025 09:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513856;
	bh=QTnS0JVouNfv92gsV1GhBHMAMDQd8Ad/4J6wC+dZMKs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=BxNwUffvf4lzaVJsCpFH3V3f296iCEFzzLGs/XguTogUL/fpPc220hPtpfelO1c6+
	 JvFRAuEKAqFDyicnor0D3bh3BNDFBO5K/1woiC1RH807hnOM5Mvew+13FoO9H6XZBl
	 czUDlWO/VnBnJ5vpvOB/H+ES/d/7NrvRrMIfWlOI=
Subject: Patch "rust: types: avoid repetition in `{As,From}Bytes` impls" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:52 +0100
In-Reply-To: <20250307225008.779961-4-ojeda@kernel.org>
Message-ID: <2025030952-plod-estrogen-06b2@gregkh>
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

    rust: types: avoid repetition in `{As,From}Bytes` impls

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-types-avoid-repetition-in-as-from-bytes-impls.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121458-greg=kroah.com@vger.kernel.org Fri Mar  7 23:50:48 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:10 +0100
Subject: rust: types: avoid repetition in `{As,From}Bytes` impls
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-4-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 567cdff53e71de56ae67eaf4309db38778b7bcd3 upstream.

In order to provide `// SAFETY` comments for every `unsafe impl`, we would
need to repeat them, which is not very useful and would be harder to read.

We could perhaps allow the lint (ideally within a small module), but we
can take the chance to avoid the repetition of the `impl`s themselves
too by using a small local macro, like in other places where we have
had to do this sort of thing.

Thus add the straightforward `impl_{from,as}bytes!` macros and use them
to implement `FromBytes`.

This, in turn, will allow us in the next patch to place a `// SAFETY`
comment that defers to the actual invocation of the macro.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-4-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/types.rs |   68 ++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -481,21 +481,22 @@ pub enum Either<L, R> {
 /// All bit-patterns must be valid for this type. This type must not have interior mutability.
 pub unsafe trait FromBytes {}
 
-// SAFETY: All bit patterns are acceptable values of the types below.
-unsafe impl FromBytes for u8 {}
-unsafe impl FromBytes for u16 {}
-unsafe impl FromBytes for u32 {}
-unsafe impl FromBytes for u64 {}
-unsafe impl FromBytes for usize {}
-unsafe impl FromBytes for i8 {}
-unsafe impl FromBytes for i16 {}
-unsafe impl FromBytes for i32 {}
-unsafe impl FromBytes for i64 {}
-unsafe impl FromBytes for isize {}
-// SAFETY: If all bit patterns are acceptable for individual values in an array, then all bit
-// patterns are also acceptable for arrays of that type.
-unsafe impl<T: FromBytes> FromBytes for [T] {}
-unsafe impl<T: FromBytes, const N: usize> FromBytes for [T; N] {}
+macro_rules! impl_frombytes {
+    ($($({$($generics:tt)*})? $t:ty, )*) => {
+        $(unsafe impl$($($generics)*)? FromBytes for $t {})*
+    };
+}
+
+impl_frombytes! {
+    // SAFETY: All bit patterns are acceptable values of the types below.
+    u8, u16, u32, u64, usize,
+    i8, i16, i32, i64, isize,
+
+    // SAFETY: If all bit patterns are acceptable for individual values in an array, then all bit
+    // patterns are also acceptable for arrays of that type.
+    {<T: FromBytes>} [T],
+    {<T: FromBytes, const N: usize>} [T; N],
+}
 
 /// Types that can be viewed as an immutable slice of initialized bytes.
 ///
@@ -514,21 +515,22 @@ unsafe impl<T: FromBytes, const N: usize
 /// mutability.
 pub unsafe trait AsBytes {}
 
-// SAFETY: Instances of the following types have no uninitialized portions.
-unsafe impl AsBytes for u8 {}
-unsafe impl AsBytes for u16 {}
-unsafe impl AsBytes for u32 {}
-unsafe impl AsBytes for u64 {}
-unsafe impl AsBytes for usize {}
-unsafe impl AsBytes for i8 {}
-unsafe impl AsBytes for i16 {}
-unsafe impl AsBytes for i32 {}
-unsafe impl AsBytes for i64 {}
-unsafe impl AsBytes for isize {}
-unsafe impl AsBytes for bool {}
-unsafe impl AsBytes for char {}
-unsafe impl AsBytes for str {}
-// SAFETY: If individual values in an array have no uninitialized portions, then the array itself
-// does not have any uninitialized portions either.
-unsafe impl<T: AsBytes> AsBytes for [T] {}
-unsafe impl<T: AsBytes, const N: usize> AsBytes for [T; N] {}
+macro_rules! impl_asbytes {
+    ($($({$($generics:tt)*})? $t:ty, )*) => {
+        $(unsafe impl$($($generics)*)? AsBytes for $t {})*
+    };
+}
+
+impl_asbytes! {
+    // SAFETY: Instances of the following types have no uninitialized portions.
+    u8, u16, u32, u64, usize,
+    i8, i16, i32, i64, isize,
+    bool,
+    char,
+    str,
+
+    // SAFETY: If individual values in an array have no uninitialized portions, then the array
+    // itself does not have any uninitialized portions either.
+    {<T: AsBytes>} [T],
+    {<T: AsBytes, const N: usize>} [T; N],
+}


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
