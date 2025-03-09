Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9B1AC43A;
	Sun,  9 Mar 2025 09:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513791; cv=none; b=aBFQI4mgAU7Pgsj+5U5+IHiACRxPiITbfQufrZqetjkybjc40AuXDEikb1xg9hNtALlfNCboqUnf5fwaaS534u3CzFW3PLqCMv9LlvQS8xG6/ilfVeOoSMvkqXoGhRXX2SwasE+DETJTGoEXlB3Qnlbz4vBA5AdIOjmKSZ5BWHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513791; c=relaxed/simple;
	bh=cYrdrpeijB3PJoz13sXKVlPGHvvOpwQK2bhAitmKrH4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=VTbJlQR19oWZkW8mXALHvlGsHGYNQFF9YICNcqdUyv8s0CNqwXbDiupUefkAauL2KlkWlTmeKAFLrJKfpNx3fJoYevM/hAZUvQzUokeRtdK73yexQz5tAVQX1RUH5fy0KNNphzsu37O9o+QsQcdjpTjme1rcxzjGIpOSbpEO394=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxatSspH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxatSspH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BA2C4CEE5;
	Sun,  9 Mar 2025 09:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513791;
	bh=cYrdrpeijB3PJoz13sXKVlPGHvvOpwQK2bhAitmKrH4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=FxatSspH/TJ6SfDZdnnBRnEtjzYqoiyZ48cwZaCrTVgw97289VcX/AGWIQCd32TTQ
	 Ibaa/ys788yUhawbGrnmgRal/r7/fRbZ8ehsolG6Nh4DMKd5IJXjU5OojxeN5HhERB
	 q43+lObLwrcgzhZPBdsv4VyhjTbHMIkrd9mrsC0Y=
Subject: Patch "rust: enable Clippy's `check-private-items`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:50 +0100
In-Reply-To: <20250307225008.779961-15-ojeda@kernel.org>
Message-ID: <2025030950-aim-spur-1611@gregkh>
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

    rust: enable Clippy's `check-private-items`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-enable-clippy-s-check-private-items.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121469-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:20 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:21 +0100
Subject: rust: enable Clippy's `check-private-items`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-15-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 624063b9ac97f40cadca32a896aafeb28b1220fd upstream.

In Rust 1.76.0, Clippy added the `check-private-items` lint configuration
option. When turned on (the default is off), it makes several lints
check private items as well.

In our case, it affects two lints we have enabled [1]:
`missing_safety_doc` and `unnecessary_safety_doc`.

It also seems to affect the new `too_long_first_doc_paragraph` lint [2],
even though the documentation does not mention it.

Thus allow the few instances remaining we currently hit and enable
the lint.

Link: https://doc.rust-lang.org/nightly/clippy/lint_configuration.html#check-private-items [1]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [2]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-16-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml                   |    2 ++
 rust/kernel/init.rs            |    1 +
 rust/kernel/init/__internal.rs |    2 ++
 rust/kernel/init/macros.rs     |    1 +
 rust/kernel/print.rs           |    1 +
 5 files changed, 7 insertions(+)

--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+check-private-items = true
+
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -125,6 +125,7 @@
 //! use core::{ptr::addr_of_mut, marker::PhantomPinned, pin::Pin};
 //! # mod bindings {
 //! #     #![allow(non_camel_case_types)]
+//! #     #![allow(clippy::missing_safety_doc)]
 //! #     pub struct foo;
 //! #     pub unsafe fn init_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -54,6 +54,7 @@ where
 pub unsafe trait HasPinData {
     type PinData: PinData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __pin_data() -> Self::PinData;
 }
 
@@ -83,6 +84,7 @@ pub unsafe trait PinData: Copy {
 pub unsafe trait HasInitData {
     type InitData: InitData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __init_data() -> Self::InitData;
 }
 
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -989,6 +989,7 @@ macro_rules! __pin_data {
         //
         // The functions are `unsafe` to prevent accidentally calling them.
         #[allow(dead_code)]
+        #[allow(clippy::missing_safety_doc)]
         impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
         where $($whr)*
         {
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -14,6 +14,7 @@ use core::{
 use crate::str::RawFormatter;
 
 // Called from `vsprintf` with format specifier `%pA`.
+#[allow(clippy::missing_safety_doc)]
 #[no_mangle]
 unsafe extern "C" fn rust_fmt_argument(
     buf: *mut c_char,


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
