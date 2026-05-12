Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D834BA33;
	Tue, 12 May 2026 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609720; cv=none; b=Zuyu4S5LVkB4buyIP3hCYW2T8C/sK22K5+pg156sM9vYVhzmx5d2QiWm0UuvGoOKl8xvejUXGNHgD/LoI+eUPIBSU+Tjop2ePlZ1wZCR1xiab4i9zReKMyWSXF4J64xHLaE3Sp/hi7gTiYlRf7n9XZEFo/A7qWiFFwqkd3duoeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609720; c=relaxed/simple;
	bh=gUVfHEItOYUzJ0rjkdn0PMnJihyAC/NlGp+JLqLAMT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeAQppANQFqGZ3Vp+cRU4cV41zPdoN83IkH2FAGg7Xy/NlWQbRZAuNnro6D0v33U73VEdQ463VWvH1M5woXRTHHMqTvOynFMDk0D4M3aeETRPW2ugogi/nlHDo2Stn2tPMuvuVeO9tzxCgzZxQjiepFnIzcNstgMpxM3RoboUig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWxTaP72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWxTaP72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66458C2BCB0;
	Tue, 12 May 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609720;
	bh=gUVfHEItOYUzJ0rjkdn0PMnJihyAC/NlGp+JLqLAMT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWxTaP729lSTiLwk8aBEVhg9hReKTvDDoPoKACfGRhtCKSpVv1eNmoofLWXzar10y
	 BOKeBjPFsYACpDMewbAp9Cr9xtF/5HWxK/sjR1/7boPs578IOflbRZ+Chnoo9BNNFM
	 xKIc9UjJ72wvfbEXxRl2pkcoNIK5wLmWdr6a2nIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Gary Guo" <gary@garyguo.net>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 7.0 306/307] rust: pin-init: fix incorrect accessor reference lifetime
Date: Tue, 12 May 2026 19:41:41 +0200
Message-ID: <20260512173946.593966190@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

commit 68bf102226cf2199dc609b67c1e847cad4de4b57 upstream

When a field has been initialized, `init!`/`pin_init!` create a reference
or pinned reference to the field so it can be accessed later during the
initialization of other fields. However, the reference it created is
incorrectly `&'static` rather than just the scope of the initializer.

This means that you can do

    init!(Foo {
        a: 1,
        _: {
            let b: &'static u32 = a;
        }
    })

which is unsound.

This is caused by `&mut (*#slot).#ident`, which actually allows arbitrary
lifetime, so this is effectively `'static`. Somewhat ironically, the safety
justification of creating the accessor is.. "SAFETY: TODO".

Fix it by adding `let_binding` method on `DropGuard` to shorten lifetime.
This results exactly what we want for these accessors. The safety and
invariant comments of `DropGuard` have been reworked; instead of reasoning
about what caller can do with the guard, express it in a way that the
ownership is transferred to the guard and `forget` takes it back, so the
unsafe operations within the `DropGuard` can be more easily justified.

Fixes: db96c5103ae6 ("add references to previously initialized fields")
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/pin-init/internal/src/init.rs |  106 ++++++++++++++++---------------------
 rust/pin-init/src/__internal.rs    |   28 ++++++---
 2 files changed, 66 insertions(+), 68 deletions(-)

--- a/rust/pin-init/internal/src/init.rs
+++ b/rust/pin-init/internal/src/init.rs
@@ -243,18 +243,6 @@ fn init_fields(
                 });
                 // Again span for better diagnostics
                 let write = quote_spanned!(ident.span()=> ::core::ptr::write);
-                let accessor = if pinned {
-                    let project_ident = format_ident!("__project_{ident}");
-                    quote! {
-                        // SAFETY: TODO
-                        unsafe { #data.#project_ident(&mut (*#slot).#ident) }
-                    }
-                } else {
-                    quote! {
-                        // SAFETY: TODO
-                        unsafe { &mut (*#slot).#ident }
-                    }
-                };
                 quote! {
                     #(#attrs)*
                     {
@@ -262,51 +250,31 @@ fn init_fields(
                         // SAFETY: TODO
                         unsafe { #write(::core::ptr::addr_of_mut!((*#slot).#ident), #value_ident) };
                     }
-                    #(#cfgs)*
-                    #[allow(unused_variables)]
-                    let #ident = #accessor;
                 }
             }
             InitializerKind::Init { ident, value, .. } => {
                 // Again span for better diagnostics
                 let init = format_ident!("init", span = value.span());
-                // NOTE: the field accessor ensures that the initialized field is properly aligned.
-                // Unaligned fields will cause the compiler to emit E0793. We do not support
-                // unaligned fields since `Init::__init` requires an aligned pointer; the call to
-                // `ptr::write` below has the same requirement.
-                let (value_init, accessor) = if pinned {
-                    let project_ident = format_ident!("__project_{ident}");
-                    (
-                        quote! {
-                            // SAFETY:
-                            // - `slot` is valid, because we are inside of an initializer closure, we
-                            //   return when an error/panic occurs.
-                            // - We also use `#data` to require the correct trait (`Init` or `PinInit`)
-                            //   for `#ident`.
-                            unsafe { #data.#ident(::core::ptr::addr_of_mut!((*#slot).#ident), #init)? };
-                        },
-                        quote! {
-                            // SAFETY: TODO
-                            unsafe { #data.#project_ident(&mut (*#slot).#ident) }
-                        },
-                    )
+                let value_init = if pinned {
+                    quote! {
+                        // SAFETY:
+                        // - `slot` is valid, because we are inside of an initializer closure, we
+                        //   return when an error/panic occurs.
+                        // - We also use `#data` to require the correct trait (`Init` or `PinInit`)
+                        //   for `#ident`.
+                        unsafe { #data.#ident(::core::ptr::addr_of_mut!((*#slot).#ident), #init)? };
+                    }
                 } else {
-                    (
-                        quote! {
-                            // SAFETY: `slot` is valid, because we are inside of an initializer
-                            // closure, we return when an error/panic occurs.
-                            unsafe {
-                                ::pin_init::Init::__init(
-                                    #init,
-                                    ::core::ptr::addr_of_mut!((*#slot).#ident),
-                                )?
-                            };
-                        },
-                        quote! {
-                            // SAFETY: TODO
-                            unsafe { &mut (*#slot).#ident }
-                        },
-                    )
+                    quote! {
+                        // SAFETY: `slot` is valid, because we are inside of an initializer
+                        // closure, we return when an error/panic occurs.
+                        unsafe {
+                            ::pin_init::Init::__init(
+                                #init,
+                                ::core::ptr::addr_of_mut!((*#slot).#ident),
+                            )?
+                        };
+                    }
                 };
                 quote! {
                     #(#attrs)*
@@ -314,9 +282,6 @@ fn init_fields(
                         let #init = #value;
                         #value_init
                     }
-                    #(#cfgs)*
-                    #[allow(unused_variables)]
-                    let #ident = #accessor;
                 }
             }
             InitializerKind::Code { block: value, .. } => quote! {
@@ -329,18 +294,41 @@ fn init_fields(
         if let Some(ident) = kind.ident() {
             // `mixed_site` ensures that the guard is not accessible to the user-controlled code.
             let guard = format_ident!("__{ident}_guard", span = Span::mixed_site());
+
+            // NOTE: The reference is derived from the guard so that it only lives as long as the
+            // guard does and cannot escape the scope. If it's created via `&mut (*#slot).#ident`
+            // like the unaligned field guard, it will become effectively `'static`.
+            let accessor = if pinned {
+                let project_ident = format_ident!("__project_{ident}");
+                quote! {
+                    // SAFETY: the initialization is pinned.
+                    unsafe { #data.#project_ident(#guard.let_binding()) }
+                }
+            } else {
+                quote! {
+                    #guard.let_binding()
+                }
+            };
+
             res.extend(quote! {
                 #(#cfgs)*
-                // Create the drop guard:
+                // Create the drop guard.
                 //
-                // We rely on macro hygiene to make it impossible for users to access this local
-                // variable.
-                // SAFETY: We forget the guard later when initialization has succeeded.
-                let #guard = unsafe {
+                // SAFETY:
+                // - `&raw mut (*slot).#ident` is valid.
+                // - `make_field_check` checks that `&raw mut (*slot).#ident` is properly aligned.
+                // - `(*slot).#ident` has been initialized above.
+                // - We only need the ownership to the pointee back when initialization has
+                //   succeeded, where we `forget` the guard.
+                let mut #guard = unsafe {
                     ::pin_init::__internal::DropGuard::new(
                         ::core::ptr::addr_of_mut!((*slot).#ident)
                     )
                 };
+
+                #(#cfgs)*
+                #[allow(unused_variables)]
+                let #ident = #accessor;
             });
             guards.push(guard);
             guard_attrs.push(cfgs);
--- a/rust/pin-init/src/__internal.rs
+++ b/rust/pin-init/src/__internal.rs
@@ -238,32 +238,42 @@ fn stack_init_reuse() {
 /// When a value of this type is dropped, it drops a `T`.
 ///
 /// Can be forgotten to prevent the drop.
+///
+/// # Invariants
+///
+/// - `ptr` is valid and properly aligned.
+/// - `*ptr` is initialized and owned by this guard.
 pub struct DropGuard<T: ?Sized> {
     ptr: *mut T,
 }
 
 impl<T: ?Sized> DropGuard<T> {
-    /// Creates a new [`DropGuard<T>`]. It will [`ptr::drop_in_place`] `ptr` when it gets dropped.
+    /// Creates a drop guard and transfer the ownership of the pointer content.
     ///
-    /// # Safety
+    /// The ownership is only relinguished if the guard is forgotten via [`core::mem::forget`].
     ///
-    /// `ptr` must be a valid pointer.
+    /// # Safety
     ///
-    /// It is the callers responsibility that `self` will only get dropped if the pointee of `ptr`:
-    /// - has not been dropped,
-    /// - is not accessible by any other means,
-    /// - will not be dropped by any other means.
+    /// - `ptr` is valid and properly aligned.
+    /// - `*ptr` is initialized, and the ownership is transferred to this guard.
     #[inline]
     pub unsafe fn new(ptr: *mut T) -> Self {
+        // INVARIANT: By safety requirement.
         Self { ptr }
     }
+
+    /// Create a let binding for accessor use.
+    #[inline]
+    pub fn let_binding(&mut self) -> &mut T {
+        // SAFETY: Per type invariant.
+        unsafe { &mut *self.ptr }
+    }
 }
 
 impl<T: ?Sized> Drop for DropGuard<T> {
     #[inline]
     fn drop(&mut self) {
-        // SAFETY: A `DropGuard` can only be constructed using the unsafe `new` function
-        // ensuring that this operation is safe.
+        // SAFETY: `self.ptr` is valid, properly aligned and `*self.ptr` is owned by this guard.
         unsafe { ptr::drop_in_place(self.ptr) }
     }
 }


