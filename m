Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8F7423A9A;
	Tue, 31 Mar 2026 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974677; cv=none; b=jL9NU2ejJYlL2T5KSdx7OrPcK8BgEa1nFHFaUSA+6NJTZ19cSFHWBV9w8j78Tawcj4egZ0I0j6eMECpSjae1e2rVrKTmf1FW8s+F+Rkgu0RyvgJNlMx2MKjo2O/kYcO/gLApXqWWvd8NhXbRoNO//uRcUZcqg1eAVMVfGsPr9Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974677; c=relaxed/simple;
	bh=qlOA3Og8BKTNRf5TBaEoSHLPfJ7eFEtbn63N5Ce/lz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcEvWiksGeAaqs9uY0Vf5v1HJmdjIyClP6wmT9FydcZrhCHlKPOcpV8QAto3wbvnqaI5vYtwgshCEgPgrc2GWi+CqRc6C90iKVhvPp+ozw1/e7Bi+79seGfrdx+sGKucLA1MjDFyq5MO+JWpBKba0ddFevSoAfWX2tJw+t7+XIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upMA63Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upMA63Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A90C19424;
	Tue, 31 Mar 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974677;
	bh=qlOA3Og8BKTNRf5TBaEoSHLPfJ7eFEtbn63N5Ce/lz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upMA63NiLNu0YY/m9GBuPwK3DG1IsQJ9LqncV/J2W+3taG9eec+CljbV31pk6J8Xc
	 ixrfsxF+qVkq+jUGU24I9HDBJXhvib88j3p6lp77EJO3mQ+UxfZOmhv9AEdc/cLqDG
	 bHm0XFdX4RcM+KECZKAvoZj31c9eIqMHv7oJ6C6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>
Subject: [PATCH 6.6 148/175] rust: pin-init: add references to previously initialized fields
Date: Tue, 31 Mar 2026 18:22:12 +0200
Message-ID: <20260331161735.226121984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benno Lossin <lossin@kernel.org>

[ Upstream commit 42415d163e5df6db799c7de6262d707e402c2c7e ]

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
 rust/kernel/init/macros.rs |  144 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 113 insertions(+), 31 deletions(-)

--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -964,35 +964,54 @@ macro_rules! __pin_data {
         @pinned($($(#[$($p_attr:tt)*])* $pvis:vis $p_field:ident : $p_type:ty),* $(,)?),
         @not_pinned($($(#[$($attr:tt)*])* $fvis:vis $field:ident : $type:ty),* $(,)?),
     ) => {
-        // For every field, we create a projection function according to its projection type. If a
-        // field is structurally pinned, then it must be initialized via `PinInit`, if it is not
-        // structurally pinned, then it can be initialized via `Init`.
-        //
-        // The functions are `unsafe` to prevent accidentally calling them.
-        #[allow(dead_code)]
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
@@ -1186,6 +1205,13 @@ macro_rules! __init_internal {
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
@@ -1217,6 +1243,14 @@ macro_rules! __init_internal {
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
@@ -1235,7 +1269,7 @@ macro_rules! __init_internal {
             );
         }
     };
-    (init_slot($($use_data:ident)?):
+    (init_slot(): // No `use_data`, so all fields are not structurally pinned
         @data($data:ident),
         @slot($slot:ident),
         @guards($($guards:ident,)*),
@@ -1249,6 +1283,15 @@ macro_rules! __init_internal {
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
@@ -1259,7 +1302,46 @@ macro_rules! __init_internal {
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
                 @guards([<$field>], $($guards,)*),


