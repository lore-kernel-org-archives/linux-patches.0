Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D49C353A82;
	Fri,  9 Oct 2026 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557119; cv=none; b=MteGbFwSJWoFnX8jCi0ekajPrtGSI/hT3VgKHQa9mJEMmWLgcPFhFEW4BKhsxjJRzIuO9v3g+d0TC1wrU4SmyjMA+qQxM31AEUFT7xwttaP8eK+DxAseBKIW00SMAhDnkK8SPkYh8f0KxQpYdJKZqAe1bQyG4zOiIj1UNNbfjGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557119; c=relaxed/simple;
	bh=OgFzuLlAwWsR1d/TEDHt+1hWZy+nEm9r30jTpu8dMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJZ9F1RvFU02t883yNSCJxJ+62d6fLTmn797JCJFRckprFDKSGvc7ju5MnVSUlRUeIbZ/JosheayT7R050mTUOsiMlXBcUxOTS5nyZUXfs11jxsoLabIcnCbDlfHKjlrwbL/S4Hi9YSgyLGpxPhNHK7scjCHn6PzqQmvDHbDdas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVYxwCB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVYxwCB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C0D1F000FF;
	Fri,  9 Oct 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557118;
	bh=z1ZOrQaKkHQaHRJ0YV8/Hhisjc9rvldGnusKKDH9er0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EVYxwCB+JkTc/POxRIQ0NYCDSutBcFTANgicfwzkoJ6uVCKgd5LfaKQo6BJipOXXV
	 UO8HgZ5wLui+O1Xamc2kn51PBUk1qmsb67PbyOrfjHMem1kilwjHpgTKQoO1jrH8dn
	 W3DJRIJ3LnmdcHESRdq3k5BWZQwF7at1ljOYlSig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 349/403] rust: devres: fix race between concurrent revokers
Date: Fri,  9 Oct 2026 16:11:50 +0200
Message-ID: <20261009141000.433281831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit acc516dfa1972d31836b50abc0115216cd0fccc5 upstream.

There is a potential race condition when two paths try to revoke a
Devres concurrently.

The driver core's devres_release_all() calls Revocable::revoke() via the
release callback, while Devres::drop() calls revoke_nosync() on another
CPU.

The revoker that does not claim the is_available swap returns
immediately, but the revoker that did may still be executing
drop_in_place() on the inner data. This can cause a use-after-free when
the other revoker's caller proceeds to drop adjacent resources that
drop_in_place() still references (e.g., Devres<DmaMappedSgt> racing with
SGTable freeing the backing sg_table and pages).

Fix this by adding a Completion. The release callback signals the
Completion after revoke() finishes, and Devres::drop() waits for it when
it loses the is_available swap. This ensures the wrapped object is fully
torn down before Devres::drop() returns.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/dri-devel/20260612202841.2577C1F000E9@smtp.kernel.org/
Fixes: 05aa6fb1c21d ("rust: scatterlist: Add abstraction for sg_table")
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260628174451.2275679-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
[ Re-introduce Inner<T> for Arc<Inner<T>> as commit 9aa64d2503c6 ("rust:
  devres: embed struct devres_node directly") is not in 6.18. ]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |   56 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 16 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -13,10 +13,18 @@ use crate::{
     ffi::c_void,
     prelude::*,
     revocable::{Revocable, RevocableGuard},
-    sync::{aref::ARef, rcu, Arc},
+    sync::{aref::ARef, rcu, Arc, Completion},
     types::ForeignOwnable,
 };
 
+#[pin_data]
+struct Inner<T> {
+    #[pin]
+    data: Revocable<T>,
+    #[pin]
+    revocation: Completion,
+}
+
 /// This abstraction is meant to be used by subsystems to containerize [`Device`] bound resources to
 /// manage their lifetime.
 ///
@@ -31,6 +39,10 @@ use crate::{
 /// After the [`Devres`] has been unbound it is not possible to access the encapsulated resource
 /// anymore.
 ///
+/// When a [`Devres`] is dropped, it is guaranteed that `T` has been fully dropped by the time
+/// [`Devres::drop`] returns, even if a concurrent revocation through the release callback is in
+/// progress.
+///
 /// [`Devres`] users should make sure to simply free the corresponding backing resource in `T`'s
 /// [`Drop`] implementation.
 ///
@@ -104,7 +116,7 @@ pub struct Devres<T: Send + 'static> {
     /// Has to be stored, since Rust does not guarantee to always return the same address for a
     /// function. However, the C API uses the address as a key.
     callback: unsafe extern "C" fn(*mut c_void),
-    data: Arc<Revocable<T>>,
+    inner: Arc<Inner<T>>,
 }
 
 impl<T: Send + 'static> Devres<T> {
@@ -117,43 +129,51 @@ impl<T: Send + 'static> Devres<T> {
         Error: From<E>,
     {
         let callback = Self::devres_callback;
-        let data = Arc::pin_init(Revocable::new(data), GFP_KERNEL)?;
-        let devres_data = data.clone();
+        let inner = Arc::pin_init::<Error>(
+            try_pin_init!(Inner {
+                data <- Revocable::new(data),
+                revocation <- Completion::new(),
+            }),
+            GFP_KERNEL,
+        )?;
+        let devres_inner = inner.clone();
 
         // SAFETY:
         // - `dev.as_raw()` is a pointer to a valid bound device.
-        // - `data` is guaranteed to be a valid for the duration of the lifetime of `Self`.
+        // - `inner` is guaranteed to be a valid for the duration of the lifetime of `Self`.
         // - `devm_add_action()` is guaranteed not to call `callback` for the entire lifetime of
         //   `dev`.
         to_result(unsafe {
             bindings::devm_add_action(
                 dev.as_raw(),
                 Some(callback),
-                Arc::as_ptr(&data).cast_mut().cast(),
+                Arc::as_ptr(&inner).cast_mut().cast(),
             )
         })?;
 
         // `devm_add_action()` was successful and has consumed the reference count.
-        core::mem::forget(devres_data);
+        core::mem::forget(devres_inner);
 
         Ok(Self {
             dev: dev.into(),
             callback,
-            data,
+            inner,
         })
     }
 
     fn data(&self) -> &Revocable<T> {
-        &self.data
+        &self.inner.data
     }
 
     #[allow(clippy::missing_safety_doc)]
     unsafe extern "C" fn devres_callback(ptr: *mut kernel::ffi::c_void) {
-        // SAFETY: In `Self::new` we've passed a valid pointer of `Revocable<T>` to
-        // `devm_add_action()`, hence `ptr` must be a valid pointer to `Revocable<T>`.
-        let data = unsafe { Arc::from_raw(ptr.cast::<Revocable<T>>()) };
+        // SAFETY: In `Self::new` we've passed a valid pointer of `Inner<T>` to
+        // `devm_add_action()`, hence `ptr` must be a valid pointer to `Inner<T>`.
+        let inner = unsafe { Arc::from_raw(ptr.cast::<Inner<T>>()) };
 
-        data.revoke();
+        if inner.data.revoke() {
+            inner.revocation.complete_all();
+        }
     }
 
     fn remove_action(&self) -> bool {
@@ -165,7 +185,7 @@ impl<T: Send + 'static> Devres<T> {
             bindings::devm_remove_action_nowarn(
                 self.dev.as_raw(),
                 Some(self.callback),
-                core::ptr::from_ref(self.data()).cast_mut().cast(),
+                Arc::as_ptr(&self.inner).cast_mut().cast(),
             )
         } == 0)
     }
@@ -243,11 +263,15 @@ impl<T: Send + 'static> Drop for Devres<
         if unsafe { self.data().revoke_nosync() } {
             // We revoked `self.data` before the devres action did, hence try to remove it.
             if self.remove_action() {
-                // SAFETY: In `Self::new` we have taken an additional reference count of `self.data`
+                // SAFETY: In `Self::new` we have taken an additional reference count of `self.inner`
                 // for `devm_add_action()`. Since `remove_action()` was successful, we have to drop
                 // this additional reference count.
-                drop(unsafe { Arc::from_raw(Arc::as_ptr(&self.data)) });
+                drop(unsafe { Arc::from_raw(Arc::as_ptr(&self.inner)) });
             }
+        } else {
+            // The release callback is concurrently revoking; wait for it to finish
+            // `drop_in_place()` of the wrapped object before returning.
+            self.inner.revocation.wait_for_completion();
         }
     }
 }


