Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBE03F7867;
	Tue, 31 Mar 2026 16:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976107; cv=none; b=Q3EyuVsqz/1s+4x07T7Go2eGTygZt0hz4sCqEFzEL0lAiNQnro1DmTZfgwi+7UPgXWHdFMMd1hp5dH40DfEb54EPSa3EqpLPDZCRCnKJXrh82+8F/WJ4ZckmnEzYQVP+92zdhDodYKSsrYRwWq7Br9KDUKSFgxt5qvso5NOHGwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976107; c=relaxed/simple;
	bh=MAehULrpugo1tRvlGQnzCjc6QqFwfu1NK+rU8IBIqGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsxICe90bnRkxp+accnvF873XGhLpxNHzo49jl91cQ3K36ioDXZXoMDBXOiwS0kveaevqApdzxVX75C+mcjraEtNzWmyDtOqPn9MUxtI1gnt1QIa+C/87xk6Zlc6K9h+zF0Izc2GGizhsQ3Db/gAi3cvAfRtS9E6w4eA8R5VivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6p7mCuc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6p7mCuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86336C19423;
	Tue, 31 Mar 2026 16:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976106;
	bh=MAehULrpugo1tRvlGQnzCjc6QqFwfu1NK+rU8IBIqGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6p7mCucTwwrwXwS5249JckU194oJfJ6TeEnaYxHvFTslrUc4y9ffTn1t+VqzB4jB
	 I16WIVOHO+VBZ1LKcrt81o/cFLP1VCvW/LP2UIbDovVt4cCbAfzspNeGMfETd8Ktis
	 CqvYRXuhRPNAGKI+ngLXqFatwiHEgUtQQ871jv+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>
Subject: [PATCH 6.12 208/244] rust: pin-init: add references to previously initialized fields
Date: Tue, 31 Mar 2026 18:22:38 +0200
Message-ID: <20260331161749.436709449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Benno Lossin <lossin@kernel.org>

commit 42415d163e5df6db799c7de6262d707e402c2c7e upstream.

After initializing a field in an initializer macro, create a variable
holding a reference that points at that field. The type is either
`Pin<&mut T>` or `&mut T` depending on the field's structural pinning
kind.

[ Applied fixes to devres and rust_driver_pci sample - Benno]
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Benno Lossin <lossin@kernel.org>
[ Removed the devres changes, because devres is not present in 6.12.y and
  earlier. Also adjusted paths in the macro to account for the fact that
  pin-init is part of the kernel crate in 6.12.y and earlier. - Benno ]
Signed-off-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/macros.rs |  149 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 115 insertions(+), 34 deletions(-)

--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -985,38 +985,56 @@ macro_rules! __pin_data {
         @pinned($($(#[$($p_attr:tt)*])* $pvis:vis $p_field:ident : $p_type:ty),* $(,)?),
         @not_pinned($($(#[$($attr:tt)*])* $fvis:vis $field:ident : $type:ty),* $(,)?),
     ) => {
-        // For every field, we create a projection function according to its projection type. If a
-        // field is structurally pinned, then it must be initialized via `PinInit`, if it is not
-        // structurally pinned, then it can be initialized via `Init`.
-        //
-        // The functions are `unsafe` to prevent accidentally calling them.
-        #[allow(dead_code)]
-        #[expect(clippy::missing_safety_doc)]
-        impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
-        where $($whr)*
-        {
-            $(
-                $(#[$($p_attr)*])*
-                $pvis unsafe fn $p_field<E>(
-                    self,
-                    slot: *mut $p_type,
-                    init: impl $crate::init::PinInit<$p_type, E>,
-                ) -> ::core::result::Result<(), E> {
-                    // SAFETY: TODO.
-                    unsafe { $crate::init::PinInit::__pinned_init(init, slot) }
-                }
-            )*
-            $(
-                $(#[$($attr)*])*
-                $fvis unsafe fn $field<E>(
-                    self,
-                    slot: *mut $type,
-                    init: impl $crate::init::Init<$type, E>,
-                ) -> ::core::result::Result<(), E> {
-                    // SAFETY: TODO.
-                    unsafe { $crate::init::Init::__init(init, slot) }
-                }
-            )*
+        $crate::macros::paste! {
+            // For every field, we create a projection function according to its projection type. If a
+            // field is structurally pinned, then it must be initialized via `PinInit`, if it is not
+            // structurally pinned, then it can be initialized via `Init`.
+            //
+            // The functions are `unsafe` to prevent accidentally calling them.
+            #[allow(dead_code, non_snake_case)]
+            #[expect(clippy::missing_safety_doc)]
+            impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
+            where $($whr)*
+            {
+                $(
+                    $(#[$($p_attr)*])*
+                    $pvis unsafe fn $p_field<E>(
+                        self,
+                        slot: *mut $p_type,
+                        init: impl $crate::init::PinInit<$p_type, E>,
+                    ) -> ::core::result::Result<(), E> {
+                        // SAFETY: TODO.
+                        unsafe { $crate::init::PinInit::__pinned_init(init, slot) }
+                    }
+
+                    $(#[$($p_attr)*])*
+                    $pvis unsafe fn [<__project_ $p_field>]<'__slot>(
+                        self,
+                        slot: &'__slot mut $p_type,
+                    ) -> ::core::pin::Pin<&'__slot mut $p_type> {
+                        unsafe { ::core::pin::Pin::new_unchecked(slot) }
+                    }
+                )*
+                $(
+                    $(#[$($attr)*])*
+                    $fvis unsafe fn $field<E>(
+                        self,
+                        slot: *mut $type,
+                        init: impl $crate::init::Init<$type, E>,
+                    ) -> ::core::result::Result<(), E> {
+                        // SAFETY: TODO.
+                        unsafe { $crate::init::Init::__init(init, slot) }
+                    }
+
+                    $(#[$($attr)*])*
+                    $fvis unsafe fn [<__project_ $field>]<'__slot>(
+                        self,
+                        slot: &'__slot mut $type,
+                    ) -> &'__slot mut $type {
+                        slot
+                    }
+                )*
+            }
         }
     };
 }
@@ -1213,6 +1231,13 @@ macro_rules! __init_internal {
         // return when an error/panic occurs.
         // We also use the `data` to require the correct trait (`Init` or `PinInit`) for `$field`.
         unsafe { $data.$field(::core::ptr::addr_of_mut!((*$slot).$field), init)? };
+        // SAFETY:
+        // - the project function does the correct field projection,
+        // - the field has been initialized,
+        // - the reference is only valid until the end of the initializer.
+        #[allow(unused_variables, unused_assignments)]
+        let $field = $crate::macros::paste!(unsafe { $data.[< __project_ $field >](&mut (*$slot).$field) });
+
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
@@ -1244,6 +1269,14 @@ macro_rules! __init_internal {
         // SAFETY: `slot` is valid, because we are inside of an initializer closure, we
         // return when an error/panic occurs.
         unsafe { $crate::init::Init::__init(init, ::core::ptr::addr_of_mut!((*$slot).$field))? };
+
+        // SAFETY:
+        // - the field is not structurally pinned, since the line above must compile,
+        // - the field has been initialized,
+        // - the reference is only valid until the end of the initializer.
+        #[allow(unused_variables, unused_assignments)]
+        let $field = unsafe { &mut (*$slot).$field };
+
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
@@ -1262,7 +1295,7 @@ macro_rules! __init_internal {
             );
         }
     };
-    (init_slot($($use_data:ident)?):
+    (init_slot(): // No `use_data`, so all fields are not structurally pinned
         @data($data:ident),
         @slot($slot:ident),
         @guards($($guards:ident,)*),
@@ -1276,6 +1309,15 @@ macro_rules! __init_internal {
             // SAFETY: The memory at `slot` is uninitialized.
             unsafe { ::core::ptr::write(::core::ptr::addr_of_mut!((*$slot).$field), $field) };
         }
+
+        #[allow(unused_variables, unused_assignments)]
+        // SAFETY:
+        // - the field is not structurally pinned, since no `use_data` was required to create this
+        //   initializer,
+        // - the field has been initialized,
+        // - the reference is only valid until the end of the initializer.
+        let $field = unsafe { &mut (*$slot).$field };
+
         // Create the drop guard:
         //
         // We rely on macro hygiene to make it impossible for users to access this local variable.
@@ -1286,7 +1328,46 @@ macro_rules! __init_internal {
                 $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
             };
 
-            $crate::__init_internal!(init_slot($($use_data)?):
+            $crate::__init_internal!(init_slot():
+                @data($data),
+                @slot($slot),
+                @guards([< __ $field _guard >], $($guards,)*),
+                @munch_fields($($rest)*),
+            );
+        }
+    };
+    (init_slot($use_data:ident):
+        @data($data:ident),
+        @slot($slot:ident),
+        @guards($($guards:ident,)*),
+        // Init by-value.
+        @munch_fields($field:ident $(: $val:expr)?, $($rest:tt)*),
+    ) => {
+        {
+            $(let $field = $val;)?
+            // Initialize the field.
+            //
+            // SAFETY: The memory at `slot` is uninitialized.
+            unsafe { ::core::ptr::write(::core::ptr::addr_of_mut!((*$slot).$field), $field) };
+        }
+        // SAFETY:
+        // - the project function does the correct field projection,
+        // - the field has been initialized,
+        // - the reference is only valid until the end of the initializer.
+        #[allow(unused_variables, unused_assignments)]
+        let $field = $crate::macros::paste!(unsafe { $data.[< __project_ $field >](&mut (*$slot).$field) });
+
+        // Create the drop guard:
+        //
+        // We rely on macro hygiene to make it impossible for users to access this local variable.
+        // We use `paste!` to create new hygiene for `$field`.
+        $crate::macros::paste! {
+            // SAFETY: We forget the guard later when initialization has succeeded.
+            let [< __ $field _guard >] = unsafe {
+                $crate::init::__internal::DropGuard::new(::core::ptr::addr_of_mut!((*$slot).$field))
+            };
+
+            $crate::__init_internal!(init_slot($use_data):
                 @data($data),
                 @slot($slot),
                 @guards([< __ $field _guard >], $($guards,)*),


