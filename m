Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7AD17C21C;
	Mon, 24 Feb 2025 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408940; cv=none; b=OrJWpTQlCMGTBJVThJZriyHjG24toHekZ/mxrFE6PWKErArodo4LWBVOjeLL5rrGAAioK8hEEx8uh9BuW5DQDfnjRawk5I0jSF3t5rgovPNvWeLf9PcdG/fs++E2RWrJ4bqH+AL1tVzjCgPRQaJWN8BCRWgFbTSvrqirWa76U00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408940; c=relaxed/simple;
	bh=8+r6g/hmS7v0uBx3maRpE87+Bs0TGETn8sXpC7mbmMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBUZe9EKoRNy1u8ne1CKYxS5BP/PSErBrVK9IwlTFdvJdBltf5yoeKb8LmZd28yw5hDN+jw/g+U6IpTbF3pBoKwi8AMz/nPOhFEL0RajwbmBWCn6vWREfxYko4B58UXTg8zbTVht3Cy7VvF5u6g46596z7G1I5fE8ZOpqOogJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dN+QJZDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dN+QJZDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7ACC4CEE6;
	Mon, 24 Feb 2025 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408940;
	bh=8+r6g/hmS7v0uBx3maRpE87+Bs0TGETn8sXpC7mbmMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dN+QJZDb5j/x3hUlmz9v1U/LtKItqWzxTGWW28gfIZwZZl6h4aNy5GAFxIc4xGRDy
	 goUuEP9DSTzau7bqXeyYc2Ba2OBpH21X6wkEv8Yv54WSer50mhDR+OTXc7Fe4gKQXh
	 Yo7BRTNqw6COjtklXFb75ZEIZnJSmGLk8NSCkwmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.13 049/138] rust: finish using custom FFI integer types
Date: Mon, 24 Feb 2025 15:34:39 +0100
Message-ID: <20250224142606.405070283@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 rust/kernel/device.rs           |    4 ++--
 rust/kernel/miscdevice.rs       |    8 ++------
 rust/kernel/security.rs         |    2 +-
 rust/kernel/seq_file.rs         |    2 +-
 samples/rust/rust_print_main.rs |    2 +-
 6 files changed, 8 insertions(+), 12 deletions(-)

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
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -173,10 +173,10 @@ impl Device {
         #[cfg(CONFIG_PRINTK)]
         unsafe {
             bindings::_dev_printk(
-                klevel as *const _ as *const core::ffi::c_char,
+                klevel as *const _ as *const crate::ffi::c_char,
                 self.as_raw(),
                 c_str!("%pA").as_char_ptr(),
-                &msg as *const _ as *const core::ffi::c_void,
+                &msg as *const _ as *const crate::ffi::c_void,
             )
         };
     }
--- a/rust/kernel/miscdevice.rs
+++ b/rust/kernel/miscdevice.rs
@@ -11,16 +11,12 @@
 use crate::{
     bindings,
     error::{to_result, Error, Result, VTABLE_DEFAULT_ERROR},
+    ffi::{c_int, c_long, c_uint, c_ulong},
     prelude::*,
     str::CStr,
     types::{ForeignOwnable, Opaque},
 };
-use core::{
-    ffi::{c_int, c_long, c_uint, c_ulong},
-    marker::PhantomData,
-    mem::MaybeUninit,
-    pin::Pin,
-};
+use core::{marker::PhantomData, mem::MaybeUninit, pin::Pin};
 
 /// Options for creating a misc device.
 #[derive(Copy, Clone)]
--- a/rust/kernel/security.rs
+++ b/rust/kernel/security.rs
@@ -19,7 +19,7 @@ use crate::{
 /// successful call to `security_secid_to_secctx`, that has not yet been destroyed by calling
 /// `security_release_secctx`.
 pub struct SecurityCtx {
-    secdata: *mut core::ffi::c_char,
+    secdata: *mut crate::ffi::c_char,
     seclen: usize,
 }
 
--- a/rust/kernel/seq_file.rs
+++ b/rust/kernel/seq_file.rs
@@ -36,7 +36,7 @@ impl SeqFile {
             bindings::seq_printf(
                 self.inner.get(),
                 c_str!("%pA").as_char_ptr(),
-                &args as *const _ as *const core::ffi::c_void,
+                &args as *const _ as *const crate::ffi::c_void,
             );
         }
     }
--- a/samples/rust/rust_print_main.rs
+++ b/samples/rust/rust_print_main.rs
@@ -83,7 +83,7 @@ impl Drop for RustPrint {
 }
 
 mod trace {
-    use core::ffi::c_int;
+    use kernel::ffi::c_int;
 
     kernel::declare_trace! {
         /// # Safety


