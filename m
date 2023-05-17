Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0ED449B0
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:27 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b8f324b3ef8so1513086276.0
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355486; x=1686947486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=32ue7WltCbe1aj9V+bmg5YyP4ANtZIJoj0Bg0fkgpuM=;
        b=RBwReH9ogtwVoE1XQ/ZI6UfWivhfBXI3WmrFbmj7DoEuSLsn8C1nmPiQsBycA+2F43
         62buFxLbt/L8aBnfdSpk2jL6Nw7xsYt+5rZnyqeCudDzwy/Nx1sPcTQM0R/OoQOW+zsL
         oGBOurlBS6d9N5xkh7hwEjNk77U0euEAONsRWMRySBg3+XH0WhdK9tms5MnFg9qttraz
         HO1bLTR98+8tyOkgi9P84RD+c5JBS5CuIzVRZltEVWkxtTx3wZsdq03GOa6unp6OQ05q
         QyLTOQyAnjJ+pdcGBsZLcPNnBcb0PPIAyGbWw0aiAQtLUU8KbW6DNenHPCUxrsxUtyi0
         Hqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355486; x=1686947486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=32ue7WltCbe1aj9V+bmg5YyP4ANtZIJoj0Bg0fkgpuM=;
        b=eUDuZKzjqyOqKVS/sV3GnZRCyId1fuPj45D34eXtMzOUZ0NmhELwDVZcPwqhz64yFO
         DHv1vmhkXEgQo2d/15P8zICtr0EaVeDgw0sA7S+U/sULX5LVvTDuQq+kvDAiwDyafr6C
         +TNXb5mdJFhZQRDs4biE4w/Fe/Iv6JguDHApIHOb62tiPnaJTUaL0PwOGTg2hNrsztbw
         vaJ3hYcvdkraNpzYE/9nGVI1hJ7vUmQZCiPZy0RNDa5W69JQEywpTZcqzN1HSdluRLX1
         i0vShofrB1iiHovqDH7Fv1f8PQKUd9F7O8wqsNGHt/wJc97rPSPu8HbJ2LXXC4EldM4D
         ikqg==
X-Gm-Message-State: AC+VfDydOdTSdboSjTvL6rnnBnpdfOeGf6lXYvk58dJDXyhVMzmCOcrR
	S0gsFSu3WwhTrDmq9KoEPMKtEI3EMR0H9wE=
X-Google-Smtp-Source: ACHHUZ6RHxBeKrUroNjdZ2ZB+PTJF0LE4tcVfcVUy5jna3YNoBBT1semjmIoNvW2b6szsAHPU0ICmT8nNCDxk24=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:182:0:b0:ba8:58c8:38f7 with SMTP id
 124-20020a250182000000b00ba858c838f7mr2038208ybb.11.1684355486248; Wed, 17
 May 2023 13:31:26 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:14 +0000
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517203119.3160435-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-3-aliceryhl@google.com>
Subject: [PATCH v1 2/7] rust: add offset_of! macro
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

This macro is used to compute the offset of a field in a struct.

This commit enables two unstable features that are necessary for using
the macro in a constant. However, this is not a problem as the macro
will become available from the Rust standard library soon [1]. The
unstable features can be disabled again once that happens.

The macro in this patch does not support sub-fields. That is, you cannot
write `offset_of!(MyStruct, field.sub_field)` to get the offset of
`sub_field` with `field`'s type being a struct with a field called
`sub_field`. This is because `field` might be a `Box<SubStruct>`, which
means that you would be trying to compute the offset to something in an
entirely different allocation. There's no easy way to fix the current
macro to support subfields, but the version being added to the standard
library should support it, so the limitation is temporary and not a big
deal.

Link: https://github.com/rust-lang/rust/issues/106655 [1]
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/lib.rs     | 35 +++++++++++++++++++++++++++++++++++
 scripts/Makefile.build |  2 +-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index c718524056a6..cdf9fe999328 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -14,6 +14,8 @@
 #![no_std]
 #![feature(allocator_api)]
 #![feature(coerce_unsized)]
+#![feature(const_ptr_offset_from)]
+#![feature(const_refs_to_cell)]
 #![feature(core_ffi_c)]
 #![feature(dispatch_from_dyn)]
 #![feature(explicit_generic_args_with_impl_trait)]
@@ -102,3 +104,36 @@ fn panic(info: &core::panic::PanicInfo<'_>) -> ! {
     // instead of `!`. See <https://github.com/rust-lang/rust-bindgen/issues/2094>.
     loop {}
 }
+
+/// Calculates the offset of a field from the beginning of the struct it belongs to.
+///
+/// # Examples
+///
+/// ```
+/// #[repr(C)]
+/// struct Test {
+///     a: u64,
+///     b: u32,
+/// }
+///
+/// assert_eq!(kernel::offset_of!(Test, b), 8);
+/// ```
+#[macro_export]
+macro_rules! offset_of {
+    ($type:ty, $field:ident) => {{
+        let tmp = ::core::mem::MaybeUninit::<$type>::uninit();
+        let outer = tmp.as_ptr();
+        // To avoid warnings when nesting `unsafe` blocks.
+        #[allow(unused_unsafe)]
+        // SAFETY: The pointer is valid and aligned, just not initialised; `addr_of` ensures that
+        // we don't actually read from `outer` (which would be UB) nor create an intermediate
+        // reference.
+        let inner = unsafe { ::core::ptr::addr_of!((*outer).$field) } as *const u8;
+        // To avoid warnings when nesting `unsafe` blocks.
+        #[allow(unused_unsafe)]
+        // SAFETY: The two pointers are within the same allocation block.
+        unsafe {
+            inner.offset_from(outer as *const u8) as usize
+        }
+    }};
+}
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9f94fc83f086..ec583d13dde2 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -277,7 +277,7 @@ $(obj)/%.lst: $(src)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
-rust_allowed_features := core_ffi_c,explicit_generic_args_with_impl_trait,new_uninit,pin_macro
+rust_allowed_features := const_ptr_offset_from,const_refs_to_cell,core_ffi_c,explicit_generic_args_with_impl_trait,new_uninit,pin_macro
 
 rust_common_cmd = \
 	RUST_MODFILE=$(modfile) $(RUSTC_OR_CLIPPY) $(rust_flags) \
-- 
2.40.1.606.ga4b1b128d6-goog

