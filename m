Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7773647A6C;
	Tue, 14 May 2024 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686590; cv=none; b=jPrDWu6DFZju9UMjUCuXMrV/qhncBaPBgU/adQBqpgsjrkhon7uv+H8coXWpzZZoRWars5ERexvzGfAmFpjCW6Cg62YEZI3lkPjzi4NDXQl5om3QK8S7yz3tHmA8AfE5C0YgEnQ6bZTvJhE6C56HZzBE6sFuU53GhSPk09/JQFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686590; c=relaxed/simple;
	bh=euW6YYcjyLpPf+/r72ROwP1soKHVfh3v+Rwsg+owjpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPpx/j9o5OYrHaaaiCZqXLug9Oio2YxtjBd2XwwCf5dPoB/BJ4oP3yxBmzxQs5zcTwvIA32c6WZOH1SitlpJstJxcsM0v3fOD3ruDCYu1uz9PD09Um72QI1Mlk5uNtgb1xqA+okiQxG9mh58kR+7hKHXZS5wJExxBrX9PsJNpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxSj2PO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxSj2PO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFEC5C2BD10;
	Tue, 14 May 2024 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686590;
	bh=euW6YYcjyLpPf+/r72ROwP1soKHVfh3v+Rwsg+owjpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxSj2PO4gmQ78HneinjXyou0JD5ifomHpyKdw6By9rMZuzd2YlQ9CShPjnXxwt9FY
	 CXDcwFux+HFBqz6R7YcWxJ19gFYjFsmsAj0Dwgj0Uh+/so293I307QV+Q+d5mS8HTq
	 dOih6So3vM/Z8Rd4UnWDUnba0QGKv0iSI/vgwSyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 191/236] rust: macros: fix soundness issue in `module!` macro
Date: Tue, 14 May 2024 12:19:13 +0200
Message-ID: <20240514101027.612238591@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benno Lossin <benno.lossin@proton.me>

commit 7044dcff8301b29269016ebd17df27c4736140d2 upstream.

The `module!` macro creates glue code that are called by C to initialize
the Rust modules using the `Module::init` function. Part of this glue
code are the local functions `__init` and `__exit` that are used to
initialize/destroy the Rust module.

These functions are safe and also visible to the Rust mod in which the
`module!` macro is invoked. This means that they can be called by other
safe Rust code. But since they contain `unsafe` blocks that rely on only
being called at the right time, this is a soundness issue.

Wrap these generated functions inside of two private modules, this
guarantees that the public functions cannot be called from the outside.
Make the safe functions `unsafe` and add SAFETY comments.

Cc: stable@vger.kernel.org
Reported-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/629
Fixes: 1fbde52bde73 ("rust: add `macros` crate")
Signed-off-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Link: https://lore.kernel.org/r/20240401185222.12015-1-benno.lossin@proton.me
[ Moved `THIS_MODULE` out of the private-in-private modules since it
  should remain public, as Dirk Behme noticed [1]. Capitalized comments,
  avoided newline in non-list SAFETY comments and reworded to add
  Reported-by and newline. ]
Link: https://rust-for-linux.zulipchat.com/#narrow/stream/291565-Help/topic/x/near/433512583 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/macros/module.rs |  190 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 115 insertions(+), 75 deletions(-)

--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -179,17 +179,6 @@ pub(crate) fn module(ts: TokenStream) ->
             /// Used by the printing macros, e.g. [`info!`].
             const __LOG_PREFIX: &[u8] = b\"{name}\\0\";
 
-            /// The \"Rust loadable module\" mark.
-            //
-            // This may be best done another way later on, e.g. as a new modinfo
-            // key or a new section. For the moment, keep it simple.
-            #[cfg(MODULE)]
-            #[doc(hidden)]
-            #[used]
-            static __IS_RUST_MODULE: () = ();
-
-            static mut __MOD: Option<{type_}> = None;
-
             // SAFETY: `__this_module` is constructed by the kernel at load time and will not be
             // freed until the module is unloaded.
             #[cfg(MODULE)]
@@ -201,81 +190,132 @@ pub(crate) fn module(ts: TokenStream) ->
                 kernel::ThisModule::from_ptr(core::ptr::null_mut())
             }};
 
-            // Loadable modules need to export the `{{init,cleanup}}_module` identifiers.
-            /// # Safety
-            ///
-            /// This function must not be called after module initialization, because it may be
-            /// freed after that completes.
-            #[cfg(MODULE)]
-            #[doc(hidden)]
-            #[no_mangle]
-            #[link_section = \".init.text\"]
-            pub unsafe extern \"C\" fn init_module() -> core::ffi::c_int {{
-                __init()
-            }}
-
-            #[cfg(MODULE)]
-            #[doc(hidden)]
-            #[no_mangle]
-            pub extern \"C\" fn cleanup_module() {{
-                __exit()
-            }}
+            // Double nested modules, since then nobody can access the public items inside.
+            mod __module_init {{
+                mod __module_init {{
+                    use super::super::{type_};
+
+                    /// The \"Rust loadable module\" mark.
+                    //
+                    // This may be best done another way later on, e.g. as a new modinfo
+                    // key or a new section. For the moment, keep it simple.
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[used]
+                    static __IS_RUST_MODULE: () = ();
+
+                    static mut __MOD: Option<{type_}> = None;
+
+                    // Loadable modules need to export the `{{init,cleanup}}_module` identifiers.
+                    /// # Safety
+                    ///
+                    /// This function must not be called after module initialization, because it may be
+                    /// freed after that completes.
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[no_mangle]
+                    #[link_section = \".init.text\"]
+                    pub unsafe extern \"C\" fn init_module() -> core::ffi::c_int {{
+                        // SAFETY: This function is inaccessible to the outside due to the double
+                        // module wrapping it. It is called exactly once by the C side via its
+                        // unique name.
+                        unsafe {{ __init() }}
+                    }}
 
-            // Built-in modules are initialized through an initcall pointer
-            // and the identifiers need to be unique.
-            #[cfg(not(MODULE))]
-            #[cfg(not(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS))]
-            #[doc(hidden)]
-            #[link_section = \"{initcall_section}\"]
-            #[used]
-            pub static __{name}_initcall: extern \"C\" fn() -> core::ffi::c_int = __{name}_init;
+                    #[cfg(MODULE)]
+                    #[doc(hidden)]
+                    #[no_mangle]
+                    pub extern \"C\" fn cleanup_module() {{
+                        // SAFETY:
+                        // - This function is inaccessible to the outside due to the double
+                        //   module wrapping it. It is called exactly once by the C side via its
+                        //   unique name,
+                        // - furthermore it is only called after `init_module` has returned `0`
+                        //   (which delegates to `__init`).
+                        unsafe {{ __exit() }}
+                    }}
 
-            #[cfg(not(MODULE))]
-            #[cfg(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS)]
-            core::arch::global_asm!(
-                r#\".section \"{initcall_section}\", \"a\"
-                __{name}_initcall:
-                    .long   __{name}_init - .
-                    .previous
-                \"#
-            );
+                    // Built-in modules are initialized through an initcall pointer
+                    // and the identifiers need to be unique.
+                    #[cfg(not(MODULE))]
+                    #[cfg(not(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS))]
+                    #[doc(hidden)]
+                    #[link_section = \"{initcall_section}\"]
+                    #[used]
+                    pub static __{name}_initcall: extern \"C\" fn() -> core::ffi::c_int = __{name}_init;
+
+                    #[cfg(not(MODULE))]
+                    #[cfg(CONFIG_HAVE_ARCH_PREL32_RELOCATIONS)]
+                    core::arch::global_asm!(
+                        r#\".section \"{initcall_section}\", \"a\"
+                        __{name}_initcall:
+                            .long   __{name}_init - .
+                            .previous
+                        \"#
+                    );
+
+                    #[cfg(not(MODULE))]
+                    #[doc(hidden)]
+                    #[no_mangle]
+                    pub extern \"C\" fn __{name}_init() -> core::ffi::c_int {{
+                        // SAFETY: This function is inaccessible to the outside due to the double
+                        // module wrapping it. It is called exactly once by the C side via its
+                        // placement above in the initcall section.
+                        unsafe {{ __init() }}
+                    }}
 
-            #[cfg(not(MODULE))]
-            #[doc(hidden)]
-            #[no_mangle]
-            pub extern \"C\" fn __{name}_init() -> core::ffi::c_int {{
-                __init()
-            }}
+                    #[cfg(not(MODULE))]
+                    #[doc(hidden)]
+                    #[no_mangle]
+                    pub extern \"C\" fn __{name}_exit() {{
+                        // SAFETY:
+                        // - This function is inaccessible to the outside due to the double
+                        //   module wrapping it. It is called exactly once by the C side via its
+                        //   unique name,
+                        // - furthermore it is only called after `__{name}_init` has returned `0`
+                        //   (which delegates to `__init`).
+                        unsafe {{ __exit() }}
+                    }}
 
-            #[cfg(not(MODULE))]
-            #[doc(hidden)]
-            #[no_mangle]
-            pub extern \"C\" fn __{name}_exit() {{
-                __exit()
-            }}
+                    /// # Safety
+                    ///
+                    /// This function must only be called once.
+                    unsafe fn __init() -> core::ffi::c_int {{
+                        match <{type_} as kernel::Module>::init(&super::super::THIS_MODULE) {{
+                            Ok(m) => {{
+                                // SAFETY: No data race, since `__MOD` can only be accessed by this
+                                // module and there only `__init` and `__exit` access it. These
+                                // functions are only called once and `__exit` cannot be called
+                                // before or during `__init`.
+                                unsafe {{
+                                    __MOD = Some(m);
+                                }}
+                                return 0;
+                            }}
+                            Err(e) => {{
+                                return e.to_errno();
+                            }}
+                        }}
+                    }}
 
-            fn __init() -> core::ffi::c_int {{
-                match <{type_} as kernel::Module>::init(&THIS_MODULE) {{
-                    Ok(m) => {{
+                    /// # Safety
+                    ///
+                    /// This function must
+                    /// - only be called once,
+                    /// - be called after `__init` has been called and returned `0`.
+                    unsafe fn __exit() {{
+                        // SAFETY: No data race, since `__MOD` can only be accessed by this module
+                        // and there only `__init` and `__exit` access it. These functions are only
+                        // called once and `__init` was already called.
                         unsafe {{
-                            __MOD = Some(m);
+                            // Invokes `drop()` on `__MOD`, which should be used for cleanup.
+                            __MOD = None;
                         }}
-                        return 0;
-                    }}
-                    Err(e) => {{
-                        return e.to_errno();
                     }}
-                }}
-            }}
 
-            fn __exit() {{
-                unsafe {{
-                    // Invokes `drop()` on `__MOD`, which should be used for cleanup.
-                    __MOD = None;
+                    {modinfo}
                 }}
             }}
-
-            {modinfo}
         ",
         type_ = info.type_,
         name = info.name,


