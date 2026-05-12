Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A373955C0;
	Tue, 12 May 2026 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608250; cv=none; b=S3+LkNt6T3xzStAy6vuqxSUQLbB1HaJUTGMnh9EqiH1hGp7dkLSuLgljoafH0ZQVWpeyrsmHpOcmeZ25QnNMPVT+DHz12vUMz+8yhyZBOJutB3dOG3MX9V9TZ6DyypwV5rNAIjJsdmjoRWLmvtU8jLVh3AX93/f0ECVh8ixrCls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608250; c=relaxed/simple;
	bh=oDxLSXcLv1GN7kCk+12CZZo+TjCh/xKqJl60RzhgEK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNEBJnsYsnnDdiwxeOtatkis9wy8AcBa+tzu95UC4AiTGzN48/jG7BgGvtTqP9Lu3dZca89INrnxMG65zpnqsbHqEjpmA8Nrkz0Kj6hYJabESLzlrLBOrnEC1LV3B5x0Yz0K4lnNNa0DT8R3LIfGdWdNeU+DaJ2lA6WNErlCkIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljxSqcAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljxSqcAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0EBC2BCF5;
	Tue, 12 May 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608250;
	bh=oDxLSXcLv1GN7kCk+12CZZo+TjCh/xKqJl60RzhgEK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljxSqcAslOEhLvxhoCl2iOcRqCyEYlfV5fXy2RUAI+F+7Ci60MclD6hsMsHVnsx4f
	 M9+GxLv2gjE0BlsBpcj4XIjNUa2UqRTAv/UyPRSNWmLtc+NCzQHKNLxnP2m/5crBpP
	 er+nxJFUgtJsGNGzsbPWFl6rUFhEwYz3l5i4SUm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, Gary Guo" <gary@garyguo.net>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.12 204/206] rust: pin-init: fix incorrect accessor reference lifetime
Date: Tue, 12 May 2026 19:40:56 +0200
Message-ID: <20260512173937.196814135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

This is caused by `&mut (*$slot).$ident`, which actually allows arbitrary
lifetime, so this is effectively `'static`.

Fix it by adding `let_binding` method on `DropGuard` to shorten lifetime.
This results in exactly what we want for these accessors. The safety and
invariant comments of `DropGuard` have been reworked; instead of reasoning
about what caller can do with the guard, express it in a way that the
ownership is transferred to the guard and `forget` takes it back, so the
unsafe operations within the `DropGuard` can be more easily justified.

Assisted-by: Claude:claude-3-opus
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/__internal.rs |   28 ++++++++----
 rust/kernel/init/macros.rs     |   91 ++++++++++++++++++++++++-----------------
 2 files changed, 73 insertions(+), 46 deletions(-)

--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -189,32 +189,42 @@ impl<T> StackInit<T> {
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
+    /// The ownership is only relinquished if the guard is forgotten via [`core::mem::forget`].
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
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -1232,27 +1232,33 @@ macro_rules! __init_internal {
         // return when an error/panic occurs.
         // We also use the `data` to require the correct trait (`Init` or `PinInit`) for `$field`.
         unsafe { $data.$field(::core::ptr::addr_of_mut!((*$slot).$field), init)? };
-        // NOTE: the field accessor ensures that the initialized field is properly aligned.
+        // NOTE: this ensures that the initialized field is properly aligned.
         // Unaligned fields will cause the compiler to emit E0793. We do not support
         // unaligned fields since `Init::__init` requires an aligned pointer; the call to
         // `ptr::write` below has the same requirement.
-        #[allow(unused_variables, unused_assignments)]
-        // SAFETY:
-        // - the project function does the correct field projection,
-        // - the field has been initialized,
-        // - the reference is only valid until the end of the initializer.
-        let $field = $crate::macros::paste!(unsafe { $data.[< __project_ $field >](&mut (*$slot).$field) });
+        // SAFETY: the field has been initialized.
+        let _ = unsafe { &mut (*$slot).$field };
 
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
         // We use `paste!` to create new hygiene for `$field`.
         ::kernel::macros::paste! {
-            // SAFETY: We forget the guard later when initialization has succeeded.
-            let [< __ $field _guard >] = unsafe {
+            // SAFETY:
+            // - `addr_of_mut!((*$slot).$field)` is valid.
+            // - `(*$slot).$field` has been initialized above.
+            // - We only need the ownership to the pointee back when initialization has
+            //   succeeded, where we `forget` the guard.
+            let mut [< __ $field _guard >] = unsafe {
                 $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
             };
 
+            // NOTE: The reference is derived from the guard so that it only lives as long as
+            // the guard does and cannot escape the scope.
+            #[allow(unused_variables)]
+            // SAFETY: the project function does the correct field projection.
+            let $field = unsafe { $data.[< __project_ $field >]([< __ $field _guard >].let_binding()) };
+
             $crate::__init_internal!(init_slot($use_data):
                 @data($data),
                 @slot($slot),
@@ -1275,27 +1281,30 @@ macro_rules! __init_internal {
         // return when an error/panic occurs.
         unsafe { $crate::init::Init::__init(init, ::core::ptr::addr_of_mut!((*$slot).$field))? };
 
-        // NOTE: the field accessor ensures that the initialized field is properly aligned.
+        // NOTE: this ensures that the initialized field is properly aligned.
         // Unaligned fields will cause the compiler to emit E0793. We do not support
         // unaligned fields since `Init::__init` requires an aligned pointer; the call to
         // `ptr::write` below has the same requirement.
-        #[allow(unused_variables, unused_assignments)]
-        // SAFETY:
-        // - the field is not structurally pinned, since the line above must compile,
-        // - the field has been initialized,
-        // - the reference is only valid until the end of the initializer.
-        let $field = unsafe { &mut (*$slot).$field };
+        // SAFETY: the field has been initialized.
+        let _ = unsafe { &mut (*$slot).$field };
 
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
         // We use `paste!` to create new hygiene for `$field`.
         ::kernel::macros::paste! {
-            // SAFETY: We forget the guard later when initialization has succeeded.
-            let [< __ $field _guard >] = unsafe {
+            // SAFETY:
+            // - `addr_of_mut!((*$slot).$field)` is valid.
+            // - `(*$slot).$field` has been initialized above.
+            // - We only need the ownership to the pointee back when initialization has
+            //   succeeded, where we `forget` the guard.
+            let mut [< __ $field _guard >] = unsafe {
                 $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
             };
 
+            #[allow(unused_variables)]
+            let $field = [< __ $field _guard >].let_binding();
+
             $crate::__init_internal!(init_slot():
                 @data($data),
                 @slot($slot),
@@ -1319,28 +1328,30 @@ macro_rules! __init_internal {
             unsafe { ::core::ptr::write(::core::ptr::addr_of_mut!((*$slot).$field), $field) };
         }
 
-        // NOTE: the field accessor ensures that the initialized field is properly aligned.
+        // NOTE: this ensures that the initialized field is properly aligned.
         // Unaligned fields will cause the compiler to emit E0793. We do not support
         // unaligned fields since `Init::__init` requires an aligned pointer; the call to
         // `ptr::write` below has the same requirement.
-        #[allow(unused_variables, unused_assignments)]
-        // SAFETY:
-        // - the field is not structurally pinned, since no `use_data` was required to create this
-        //   initializer,
-        // - the field has been initialized,
-        // - the reference is only valid until the end of the initializer.
-        let $field = unsafe { &mut (*$slot).$field };
+        // SAFETY: the field has been initialized.
+        let _ = unsafe { &mut (*$slot).$field };
 
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
         // We use `paste!` to create new hygiene for `$field`.
         ::kernel::macros::paste! {
-            // SAFETY: We forget the guard later when initialization has succeeded.
-            let [< __ $field _guard >] = unsafe {
+            // SAFETY:
+            // - `addr_of_mut!((*$slot).$field)` is valid.
+            // - `(*$slot).$field` has been initialized above.
+            // - We only need the ownership to the pointee back when initialization has
+            //   succeeded, where we `forget` the guard.
+            let mut [< __ $field _guard >] = unsafe {
                 $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
             };
 
+            #[allow(unused_variables)]
+            let $field = [< __ $field _guard >].let_binding();
+
             $crate::__init_internal!(init_slot():
                 @data($data),
                 @slot($slot),
@@ -1363,27 +1374,33 @@ macro_rules! __init_internal {
             // SAFETY: The memory at `slot` is uninitialized.
             unsafe { ::core::ptr::write(::core::ptr::addr_of_mut!((*$slot).$field), $field) };
         }
-        // NOTE: the field accessor ensures that the initialized field is properly aligned.
+        // NOTE: this ensures that the initialized field is properly aligned.
         // Unaligned fields will cause the compiler to emit E0793. We do not support
         // unaligned fields since `Init::__init` requires an aligned pointer; the call to
         // `ptr::write` below has the same requirement.
-        #[allow(unused_variables, unused_assignments)]
-        // SAFETY:
-        // - the project function does the correct field projection,
-        // - the field has been initialized,
-        // - the reference is only valid until the end of the initializer.
-        let $field = $crate::macros::paste!(unsafe { $data.[< __project_ $field >](&mut (*$slot).$field) });
+        // SAFETY: the field has been initialized.
+        let _ = unsafe { &mut (*$slot).$field };
 
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
         // We use `paste!` to create new hygiene for `$field`.
         $crate::macros::paste! {
-            // SAFETY: We forget the guard later when initialization has succeeded.
-            let [< __ $field _guard >] = unsafe {
+            // SAFETY:
+            // - `addr_of_mut!((*$slot).$field)` is valid.
+            // - `(*$slot).$field` has been initialized above.
+            // - We only need the ownership to the pointee back when initialization has
+            //   succeeded, where we `forget` the guard.
+            let mut [< __ $field _guard >] = unsafe {
                 $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
             };
 
+            // NOTE: The reference is derived from the guard so that it only lives as long as
+            // the guard does and cannot escape the scope.
+            #[allow(unused_variables)]
+            // SAFETY: the project function does the correct field projection.
+            let $field = unsafe { $data.[< __project_ $field >]([< __ $field _guard >].let_binding()) };
+
             $crate::__init_internal!(init_slot($use_data):
                 @data($data),
                 @slot($slot),


