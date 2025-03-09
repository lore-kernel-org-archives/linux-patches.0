Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714051FB3;
	Sun,  9 Mar 2025 09:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513684; cv=none; b=XTEuRCE13XfikLo9/vT2Oc5RdZD55FIsN1pm9mM+XqSrcLdFdPJ8I/2W/gKxuCol9IPeI2ROS2qXUpEo3P2RUAeVnvhuIEoSBEx/5r8CXmm8XxDPI53rX1ZfgD23SMURhzcUKKIEa7QnyvY5GUjZvpGznWTRb3/8oRGAMd9NiKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513684; c=relaxed/simple;
	bh=GaaRUjoh8u1eQb/nJ0PGXQG8zTX/sqOFZFWkK08Hj/0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=o33UznybOCR2aDslXvUeS07NPMRgb4WSjvnOTfN5ob4nELq+8eExnpS/wAt1do6R1fu/2nP+CVbHFezNNBiiskraqSnz2JN72zEW0cxkdT6n7W66WxFpS/K/XqVpAwvAbnsZsepdpXhz0LYz1dBX0zA3quaDYxkTqmy4/uB1Nrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLl8OrMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLl8OrMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF11C4CEE5;
	Sun,  9 Mar 2025 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513683;
	bh=GaaRUjoh8u1eQb/nJ0PGXQG8zTX/sqOFZFWkK08Hj/0=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=HLl8OrMD7i5bzMVCSDyldbaAXpqVNObR772m66QK43xPoQW0C/30GO75T4hCUfTrM
	 lqaeoVeZOhtIN6ssras17SN0EH1Abx0aiohlqddOk8Bac/IfzC8BR9TDSMXVssGdrq
	 npTpWYMXWqtyy4C5CIdQyWUFLkN2IYDo36xZV4/U=
Subject: Patch "Documentation: rust: add coding guidelines on lints" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:47 +0100
In-Reply-To: <20250307225008.779961-16-ojeda@kernel.org>
Message-ID: <2025030947-mutable-extending-0de3@gregkh>
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

    Documentation: rust: add coding guidelines on lints

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     documentation-rust-add-coding-guidelines-on-lints.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121470-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:23 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:22 +0100
Subject: Documentation: rust: add coding guidelines on lints
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-16-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 139d396572ec4ba6e8cc5c02f5c8d5d1139be4b7 upstream.

In the C side, disabling diagnostics locally, i.e. within the source code,
is rare (at least in the kernel). Sometimes warnings are manipulated
via the flags at the translation unit level, but that is about it.

In Rust, it is easier to change locally the "level" of lints
(e.g. allowing them locally). In turn, this means it is easier to
globally enable more lints that may trigger a few false positives here
and there that need to be allowed locally, but that generally can spot
issues or bugs.

Thus document this.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-17-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/coding-guidelines.rst |   38 +++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -227,3 +227,41 @@ The equivalent in Rust may look like (ig
 That is, the equivalent of ``GPIO_LINE_DIRECTION_IN`` would be referred to as
 ``gpio::LineDirection::In``. In particular, it should not be named
 ``gpio::gpio_line_direction::GPIO_LINE_DIRECTION_IN``.
+
+
+Lints
+-----
+
+In Rust, it is possible to ``allow`` particular warnings (diagnostics, lints)
+locally, making the compiler ignore instances of a given warning within a given
+function, module, block, etc.
+
+It is similar to ``#pragma GCC diagnostic push`` + ``ignored`` + ``pop`` in C
+[#]_:
+
+.. code-block:: c
+
+	#pragma GCC diagnostic push
+	#pragma GCC diagnostic ignored "-Wunused-function"
+	static void f(void) {}
+	#pragma GCC diagnostic pop
+
+.. [#] In this particular case, the kernel's ``__{always,maybe}_unused``
+       attributes (C23's ``[[maybe_unused]]``) may be used; however, the example
+       is meant to reflect the equivalent lint in Rust discussed afterwards.
+
+But way less verbose:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn f() {}
+
+By that virtue, it makes it possible to comfortably enable more diagnostics by
+default (i.e. outside ``W=`` levels). In particular, those that may have some
+false positives but that are otherwise quite useful to keep enabled to catch
+potential mistakes.
+
+For more information about diagnostics in Rust, please see:
+
+	https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html


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
