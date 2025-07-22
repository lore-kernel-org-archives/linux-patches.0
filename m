Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA8E2EAB69;
	Tue, 22 Jul 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193779; cv=none; b=B2XrJCH7UFq3LPhtfUDXj9IOmRVaP+YD5ZKn1PSFJYNnvgeBHxb+Iw/QAJSqNeFnNXYH62boKcTND9Hfb9ULmUx+Ix1qV4UFPF8l1dy0tK7GbVUTWyzWLuBLPrbry1t1QsOru4pMqwsZe1v7zejtkpr2vNxbc4kCOwqP1Pce3Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193779; c=relaxed/simple;
	bh=TSzan+PDCy02PuGG+Crw22/WUiL9v2cJkzvw1Xc2mLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VICDnjrJfXgPVPcZP2L82TI0nXLl3fqj61uaK05RPTIeZxLbes44wI7vZX1ViWJyL/4SXsVpF1ihfe1bV4jYFbeXLeOkLHuWQ88Tv9RHo4L5hRqpM4K7xl3xVrCFwLftSAAErsAbATwfk45vb1gnryE+MWbPYJV0Ip43oSFGujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxD78bKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxD78bKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2A9C4CEEB;
	Tue, 22 Jul 2025 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193779;
	bh=TSzan+PDCy02PuGG+Crw22/WUiL9v2cJkzvw1Xc2mLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxD78bKiC5dtgDCZA66g4isqJwxz/PznrLtX6wWd/JTNSzRg6dOBdE0YRokpPvzXF
	 NMK/BaVd5gtWSt9oNdXd9fgxonebijGEqUa2GbNkPOSEb0GxoXO3UW7av2O7LoqJWE
	 e4QhdUMhrMMzDtSFh6crB+FgPSsXW/3UPnzOChWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wood <david@davidtw.co>,
	Wesley Wiser <wwiser@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 173/187] rust: use `#[used(compiler)]` to fix build and `modpost` with Rust >= 1.89.0
Date: Tue, 22 Jul 2025 15:45:43 +0200
Message-ID: <20250722134352.214605714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 7498159226772d66f150dd406be462d75964a366 upstream.

Starting with Rust 1.89.0 (expected 2025-08-07), the Rust compiler fails
to build the `rusttest` target due to undefined references such as:

    kernel...-cgu.0:(.text....+0x116): undefined reference to
    `rust_helper_kunit_get_current_test'

Moreover, tooling like `modpost` gets confused:

    WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/gpu/drm/nova/nova.o
    ERROR: modpost: missing MODULE_LICENSE() in drivers/gpu/nova-core/nova_core.o

The reason behind both issues is that the Rust compiler will now [1]
treat `#[used]` as `#[used(linker)]` instead of `#[used(compiler)]`
for our targets. This means that the retain section flag (`R`,
`SHF_GNU_RETAIN`) will be used and that they will be marked as `unique`
too, with different IDs. In turn, that means we end up with undefined
references that did not get discarded in `rusttest` and that multiple
`.modinfo` sections are generated, which confuse tooling like `modpost`
because they only expect one.

Thus start using `#[used(compiler)]` to keep the previous behavior
and to be explicit about what we want. Sadly, it is an unstable feature
(`used_with_arg`) [2] -- we will talk to upstream Rust about it. The good
news is that it has been available for a long time (Rust >= 1.60) [3].

The changes should also be fine for previous Rust versions, since they
behave the same way as before [4].

Alternatively, we could use `#[no_mangle]` or `#[export_name = ...]`
since those still behave like `#[used(compiler)]`, but of course it is
not really what we want to express, and it requires other changes to
avoid symbol conflicts.

Cc: David Wood <david@davidtw.co>
Cc: Wesley Wiser <wwiser@gmail.com>
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/140872 [1]
Link: https://github.com/rust-lang/rust/issues/93798 [2]
Link: https://github.com/rust-lang/rust/pull/91504 [3]
Link: https://godbolt.org/z/sxzWTMfzW [4]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Link: https://lore.kernel.org/r/20250712160103.1244945-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile           |    1 +
 rust/kernel/firmware.rs |    2 +-
 rust/kernel/kunit.rs    |    2 +-
 rust/kernel/lib.rs      |    2 ++
 rust/macros/module.rs   |   10 +++++-----
 scripts/Makefile.build  |    2 +-
 6 files changed, 11 insertions(+), 8 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -194,6 +194,7 @@ quiet_cmd_rustdoc_test = RUSTDOC T $<
 	RUST_MODFILE=test.rs \
 	OBJTREE=$(abspath $(objtree)) \
 	$(RUSTDOC) --test $(rust_common_flags) \
+		-Zcrate-attr='feature(used_with_arg)' \
 		@$(objtree)/include/generated/rustc_cfg \
 		$(rustc_target_flags) $(rustdoc_test_target_flags) \
 		$(rustdoc_test_quiet) \
--- a/rust/kernel/firmware.rs
+++ b/rust/kernel/firmware.rs
@@ -202,7 +202,7 @@ macro_rules! module_firmware {
             };
 
             #[link_section = ".modinfo"]
-            #[used]
+            #[used(compiler)]
             static __MODULE_FIRMWARE: [u8; $($builder)*::create(__MODULE_FIRMWARE_PREFIX)
                 .build_length()] = $($builder)*::create(__MODULE_FIRMWARE_PREFIX).build();
         };
--- a/rust/kernel/kunit.rs
+++ b/rust/kernel/kunit.rs
@@ -278,7 +278,7 @@ macro_rules! kunit_unsafe_test_suite {
                     is_init: false,
                 };
 
-            #[used]
+            #[used(compiler)]
             #[allow(unused_unsafe)]
             #[cfg_attr(not(target_os = "macos"), link_section = ".kunit_test_suites")]
             static mut KUNIT_TEST_SUITE_ENTRY: *const ::kernel::bindings::kunit_suite =
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -26,6 +26,8 @@
 #![feature(const_mut_refs)]
 #![feature(const_ptr_write)]
 #![feature(const_refs_to_cell)]
+// To be determined.
+#![feature(used_with_arg)]
 
 // Ensure conditional compilation based on the kernel configuration works;
 // otherwise we may silently break things like initcall handling.
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -57,7 +57,7 @@ impl<'a> ModInfoBuilder<'a> {
                 {cfg}
                 #[doc(hidden)]
                 #[cfg_attr(not(target_os = \"macos\"), link_section = \".modinfo\")]
-                #[used]
+                #[used(compiler)]
                 pub static __{module}_{counter}: [u8; {length}] = *{string};
             ",
             cfg = if builtin {
@@ -247,7 +247,7 @@ pub(crate) fn module(ts: TokenStream) ->
                     // key or a new section. For the moment, keep it simple.
                     #[cfg(MODULE)]
                     #[doc(hidden)]
-                    #[used]
+                    #[used(compiler)]
                     static __IS_RUST_MODULE: () = ();
 
                     static mut __MOD: core::mem::MaybeUninit<{type_}> =
@@ -271,7 +271,7 @@ pub(crate) fn module(ts: TokenStream) ->
 
                     #[cfg(MODULE)]
                     #[doc(hidden)]
-                    #[used]
+                    #[used(compiler)]
                     #[link_section = \".init.data\"]
                     static __UNIQUE_ID___addressable_init_module: unsafe extern \"C\" fn() -> i32 = init_module;
 
@@ -291,7 +291,7 @@ pub(crate) fn module(ts: TokenStream) ->
 
                     #[cfg(MODULE)]
                     #[doc(hidden)]
-                    #[used]
+                    #[used(compiler)]
                     #[link_section = \".exit.data\"]
                     static __UNIQUE_ID___addressable_cleanup_module: extern \"C\" fn() = cleanup_module;
 
@@ -301,7 +301,7 @@ pub(crate) fn module(ts: TokenStream) ->
                     #[cfg(not(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS))]
                     #[doc(hidden)]
                     #[link_section = \"{initcall_section}\"]
-                    #[used]
+                    #[used(compiler)]
                     pub static __{name}_initcall: extern \"C\" fn() -> kernel::ffi::c_int = __{name}_init;
 
                     #[cfg(not(MODULE))]
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -222,7 +222,7 @@ $(obj)/%.lst: $(obj)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
-rust_allowed_features := asm_const,asm_goto,arbitrary_self_types,lint_reasons,raw_ref_op
+rust_allowed_features := asm_const,asm_goto,arbitrary_self_types,lint_reasons,raw_ref_op,used_with_arg
 
 # `--out-dir` is required to avoid temporaries being created by `rustc` in the
 # current working directory, which may be not accessible in the out-of-tree


