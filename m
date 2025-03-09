Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84602158A13;
	Sun,  9 Mar 2025 21:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741554149; cv=none; b=FolclERGRNveWlze0XvFLvWqbDTXt8IdrrzQHQ5GO72/1FWKcopilgsbXsLHH+Qn+GGtStxc2n+YrRAbWjwhxj77cEL6qww1IyueMUEQ1grquUZjfnA9+1lm1yWRjfgl7cRf3X2Hy5YHvoP4bY3smyGCOLMui/ARH5mJfIIOzwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741554149; c=relaxed/simple;
	bh=z2Ozz3AlozyXKhFgFB1QbWDTdAFyGKYCYY/MtVuhd64=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=TLwFUOnkDlXDKUtl1M8ueAcREaBJSYSB/wD1Wr2hU2VZKdxS6MdsOh0CaHfzRcte+hmeOsor7YUC5tNZoadoyVJroFnJRh3g22yFpHW6L71sTs2ttlbMYAtHno5uG6SWVL2UHkDDpAKak7lNLiMqVbOpstLSd8a+2p3gOAFc9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6gSdueK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6gSdueK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A58EC4CEE3;
	Sun,  9 Mar 2025 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741554148;
	bh=z2Ozz3AlozyXKhFgFB1QbWDTdAFyGKYCYY/MtVuhd64=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=M6gSdueKDwqxK6rc6T/zjJm0oiDszedUiBlYTdQqhFjmG8VWrsM2P18xrH+k2N8Bm
	 742dOa1XitVzeCnsdRuAqoDOqX93TxkRA7d8b53e5oR5Dq1Y2JiBQpKB2yJY8XVUNT
	 zEYTS0nZhkhub574BrxnkdIXp1vxRkXbylbziHdk=
Subject: Patch "rust: finish using custom FFI integer types" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gregkh@linuxfoundation.org,hi@alyssa.is,jfalempe@redhat.com,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 22:02:26 +0100
In-Reply-To: <20250309204217.1553389-2-ojeda@kernel.org>
Message-ID: <2025030926-crying-enactment-5341@gregkh>
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

    rust: finish using custom FFI integer types

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-finish-using-custom-ffi-integer-types.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121622-greg=kroah.com@vger.kernel.org Sun Mar  9 21:42:38 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Sun,  9 Mar 2025 21:42:16 +0100
Subject: rust: finish using custom FFI integer types
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250309204217.1553389-2-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 27c7518e7f1ccaaa43eb5f25dc362779d2dc2ccb upstream.

In the last kernel cycle we migrated most of the `core::ffi` cases in
commit d072acda4862 ("rust: use custom FFI integer types"):

    Currently FFI integer types are defined in libcore. This commit
    creates the `ffi` crate and asks bindgen to use that crate for FFI
    integer types instead of `core::ffi`.

    This commit is preparatory and no type changes are made in this
    commit yet.

Finish now the few remaining/new cases so that we perform the actual
remapping in the next commit as planned.

Acked-by: Jocelyn Falempe <jfalempe@redhat.com> # drm
Link: https://lore.kernel.org/rust-for-linux/CANiq72m_rg42SvZK=bF2f0yEoBLVA33UBhiAsv8THhVu=G2dPA@mail.gmail.com/
Link: https://lore.kernel.org/all/cc9253fa-9d5f-460b-9841-94948fb6580c@redhat.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -931,7 +931,7 @@ impl QrImage<'_> {
 /// They must remain valid for the duration of the function call.
 #[no_mangle]
 pub unsafe extern "C" fn drm_panic_qr_generate(
-    url: *const i8,
+    url: *const kernel::ffi::c_char,
     data: *mut u8,
     data_len: usize,
     data_size: usize,


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-map-long-to-isize-and-char-to-u8.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-finish-using-custom-ffi-integer-types.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
