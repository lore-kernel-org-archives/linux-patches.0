Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF6B3382DA;
	Fri,  9 Oct 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557604; cv=none; b=utrSec4v6BJ080Wq0Ib3F6BzjPgzlj4j0jyBgbWTC9NTmWASzZgcciUIt5pksKsd5zbu1g2XvcruXVAJmkwbTUSb7cjV0hh+cVJhbvPW+dKOf0p7KQ86/ORrRk9q/XNecQJ7+paxWU1wd8m9k/bbTuf3+VvmtlgxkNczcfgGTKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557604; c=relaxed/simple;
	bh=zGnJJP9w3ryWic8A51CjcyQNGSzKH7WoDMJaMhxx4XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ3K+029f6xMjsiYyL2vduTRacdmO2aCan5rGhXi4GhfbuBev0nD2Tg9GlB/+qyqmcaSbbsKATu8oGbxiJLfRxNDdvgIrYSVmbLigO2W9e3Plstmjx1Saois3MY6MC2Nof4+xn/LelyGa7FqMnet2l2J9QfQ3abgwFPIaqGxeFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MyzmnEWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MyzmnEWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672111F000FF;
	Fri,  9 Oct 2026 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557603;
	bh=53gX5M7xhjpE5SyLNFFEzKK+q3fHY+HzrY9r2edFD8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyzmnEWGsgrX36ASBc0A27BUvKv4FXaTYk71tM86uAGMSgNIEy/i5em6L+Kyp6gyk
	 WvML91r8clzOUk8YpaZKli+HytTbScideop/q97qP9zAJfcpStAIv7eFK6k1Vov0bT
	 HP0OUL/f79m+8kB07h7SEnYG+CGnxm6ZZA9TR9xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.2 417/428] rust: irq: pass RegistrationInner as cookie to request_irq
Date: Fri,  9 Oct 2026 16:12:34 +0200
Message-ID: <20261009140955.394178741@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

With commit ba268514ea14 ("rust: devres: fix race condition due to
nesting"), Devres::new() returns Result<Self> by value instead of
initializing in-place via PinInit. Because request_irq() is called
inside Devres::new(), registration.inner is still uninitialized when the
IRQ is enabled, so accessing registration.inner.device() in the IRQ
callback can read uninitialized memory.

Fix this by storing the Device and handler pointer in RegistrationInner
and passing RegistrationInner as the IRQ cookie after its fields are
initialized.

This is not needed in mainline because commit 98c63ce4d760 ("rust: irq:
make Registration compatible with lifetime-bound drivers") removed
Devres from irq::Registration and moved request_irq() after all fields
are initialized.

Fixes: 29e16fcd67ee ("rust: irq: add &Device<Bound> argument to irq callbacks")
Fixes: ba268514ea14 ("rust: devres: fix race condition due to nesting")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/irq/request.rs |   89 +++++++++++++++++++++++++++------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

--- a/rust/kernel/irq/request.rs
+++ b/rust/kernel/irq/request.rs
@@ -14,7 +14,7 @@ use crate::error::to_result;
 use crate::irq::flags::Flags;
 use crate::prelude::*;
 use crate::str::CStr;
-use crate::sync::Arc;
+use crate::sync::{aref::ARef, Arc};
 
 /// The value that can be returned from a [`Handler`] or a [`ThreadedHandler`].
 #[repr(u32)]
@@ -54,13 +54,18 @@ impl<T: ?Sized + Handler, A: Allocator +
 /// # Invariants
 ///
 /// - `self.irq` is the same as the one passed to `request_{threaded}_irq`.
-/// - `cookie` was passed to `request_{threaded}_irq` as the cookie. It is guaranteed to be unique
+/// - `&self` was passed to `request_{threaded}_irq` as the cookie. It is guaranteed to be unique
 ///   by the type system, since each call to `new` will return a different instance of
 ///   `Registration`.
+/// - `self.handler` points to a valid instance of the handler `T` that lives at least until
+///   `Self::drop` completes.
 #[pin_data(PinnedDrop)]
 struct RegistrationInner {
     irq: u32,
-    cookie: *mut c_void,
+    dev: ARef<Device>,
+    handler: *const c_void,
+    #[pin]
+    _pin: PhantomPinned,
 }
 
 impl RegistrationInner {
@@ -77,18 +82,22 @@ impl PinnedDrop for RegistrationInner {
         //
         // Safe as per the invariants of `RegistrationInner` and:
         //
-        // - The containing struct is `!Unpin` and was initialized using
+        // - `RegistrationInner` is `!Unpin` and was initialized using
         // pin-init, so it occupied the same memory location for the entirety of
         // its lifetime.
         //
         // Notice that this will block until all handlers finish executing,
         // i.e.: at no point will &self be invalid while the handler is running.
-        unsafe { bindings::free_irq(self.irq, self.cookie) };
+        unsafe {
+            bindings::free_irq(
+                self.irq,
+                core::ptr::from_mut::<Self>(self.get_unchecked_mut()).cast::<c_void>(),
+            )
+        };
     }
 }
 
-// SAFETY: We only use `inner` on drop, which called at most once with no
-// concurrent access.
+// SAFETY: `RegistrationInner` has no interior mutability and `handler` points to a `Sync` handler.
 unsafe impl Sync for RegistrationInner {}
 
 // SAFETY: It is safe to send `RegistrationInner` across threads.
@@ -179,7 +188,7 @@ impl<'a> IrqRequest<'a> {
 ///
 /// # Invariants
 ///
-/// * We own an irq handler whose cookie is a pointer to `Self`.
+/// * We own an irq handler whose cookie is a pointer to `Self::inner`.
 #[pin_data]
 pub struct Registration<T: Handler> {
     #[pin]
@@ -206,10 +215,13 @@ impl<T: Handler> Registration<T> {
             handler <- handler,
             inner <- Devres::new(
                 request.dev,
-                try_pin_init!(RegistrationInner {
-                    // INVARIANT: `this` is a valid pointer to the `Registration` instance
-                    cookie: this.as_ptr().cast::<c_void>(),
-                    irq: {
+                try_pin_init!(&inner_this in RegistrationInner {
+                    irq: request.irq,
+                    dev: request.dev.into(),
+                    // SAFETY: `this` is a valid pointer to the `Registration` instance.
+                    handler: unsafe { &raw const (*this.as_ptr()).handler }.cast(),
+                    _pin: PhantomPinned,
+                    _: {
                         // SAFETY:
                         // - The callbacks are valid for use with request_irq.
                         // - If this succeeds, the slot is guaranteed to be valid until the
@@ -224,11 +236,10 @@ impl<T: Handler> Registration<T> {
                                 Some(handle_irq_callback::<T>),
                                 flags.into_inner(),
                                 name.as_char_ptr(),
-                                this.as_ptr().cast::<c_void>(),
+                                inner_this.as_ptr().cast::<c_void>(),
                             )
                         })?;
-                        request.irq
-                    }
+                    },
                 })
             ),
             _pin: PhantomPinned,
@@ -261,13 +272,15 @@ impl<T: Handler> Registration<T> {
 ///
 /// This function should be only used as the callback in `request_irq`.
 unsafe extern "C" fn handle_irq_callback<T: Handler>(_irq: i32, ptr: *mut c_void) -> c_uint {
-    // SAFETY: `ptr` is a pointer to `Registration<T>` set in `Registration::new`
-    let registration = unsafe { &*(ptr as *const Registration<T>) };
+    // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `Registration::new`
+    let inner = unsafe { &*(ptr as *const RegistrationInner) };
+    // SAFETY: `inner.handler` is a pointer to `T` set in `Registration::new`
+    let handler = unsafe { &*inner.handler.cast::<T>() };
     // SAFETY: The irq callback is removed before the device is unbound, so the fact that the irq
     // callback is running implies that the device has not yet been unbound.
-    let device = unsafe { registration.inner.device().as_bound() };
+    let device = unsafe { inner.dev.as_bound() };
 
-    T::handle(&registration.handler, device) as c_uint
+    T::handle(handler, device) as c_uint
 }
 
 /// The value that can be returned from [`ThreadedHandler::handle`].
@@ -396,7 +409,7 @@ impl<T: ?Sized + ThreadedHandler, A: All
 ///
 /// # Invariants
 ///
-/// * We own an irq handler whose cookie is a pointer to `Self`.
+/// * We own an irq handler whose cookie is a pointer to `Self::inner`.
 #[pin_data]
 pub struct ThreadedRegistration<T: ThreadedHandler> {
     #[pin]
@@ -423,10 +436,13 @@ impl<T: ThreadedHandler> ThreadedRegistr
             handler <- handler,
             inner <- Devres::new(
                 request.dev,
-                try_pin_init!(RegistrationInner {
-                    // INVARIANT: `this` is a valid pointer to the `ThreadedRegistration` instance.
-                    cookie: this.as_ptr().cast::<c_void>(),
-                    irq: {
+                try_pin_init!(&inner_this in RegistrationInner {
+                    irq: request.irq,
+                    dev: request.dev.into(),
+                    // SAFETY: `this` is a valid pointer to the `ThreadedRegistration` instance.
+                    handler: unsafe { &raw const (*this.as_ptr()).handler }.cast(),
+                    _pin: PhantomPinned,
+                    _: {
                         // SAFETY:
                         // - The callbacks are valid for use with request_threaded_irq.
                         // - If this succeeds, the slot is guaranteed to be valid until the
@@ -442,11 +458,10 @@ impl<T: ThreadedHandler> ThreadedRegistr
                                 Some(thread_fn_callback::<T>),
                                 flags.into_inner(),
                                 name.as_char_ptr(),
-                                this.as_ptr().cast::<c_void>(),
+                                inner_this.as_ptr().cast::<c_void>(),
                             )
                         })?;
-                        request.irq
-                    }
+                    },
                 })
             ),
             _pin: PhantomPinned,
@@ -482,24 +497,28 @@ unsafe extern "C" fn handle_threaded_irq
     _irq: i32,
     ptr: *mut c_void,
 ) -> c_uint {
-    // SAFETY: `ptr` is a pointer to `ThreadedRegistration<T>` set in `ThreadedRegistration::new`
-    let registration = unsafe { &*(ptr as *const ThreadedRegistration<T>) };
+    // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `ThreadedRegistration::new`
+    let inner = unsafe { &*(ptr as *const RegistrationInner) };
+    // SAFETY: `inner.handler` is a pointer to `T` set in `ThreadedRegistration::new`
+    let handler = unsafe { &*inner.handler.cast::<T>() };
     // SAFETY: The irq callback is removed before the device is unbound, so the fact that the irq
     // callback is running implies that the device has not yet been unbound.
-    let device = unsafe { registration.inner.device().as_bound() };
+    let device = unsafe { inner.dev.as_bound() };
 
-    T::handle(&registration.handler, device) as c_uint
+    T::handle(handler, device) as c_uint
 }
 
 /// # Safety
 ///
 /// This function should be only used as the callback in `request_threaded_irq`.
 unsafe extern "C" fn thread_fn_callback<T: ThreadedHandler>(_irq: i32, ptr: *mut c_void) -> c_uint {
-    // SAFETY: `ptr` is a pointer to `ThreadedRegistration<T>` set in `ThreadedRegistration::new`
-    let registration = unsafe { &*(ptr as *const ThreadedRegistration<T>) };
+    // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `ThreadedRegistration::new`
+    let inner = unsafe { &*(ptr as *const RegistrationInner) };
+    // SAFETY: `inner.handler` is a pointer to `T` set in `ThreadedRegistration::new`
+    let handler = unsafe { &*inner.handler.cast::<T>() };
     // SAFETY: The irq callback is removed before the device is unbound, so the fact that the irq
     // callback is running implies that the device has not yet been unbound.
-    let device = unsafe { registration.inner.device().as_bound() };
+    let device = unsafe { inner.dev.as_bound() };
 
-    T::handle_threaded(&registration.handler, device) as c_uint
+    T::handle_threaded(handler, device) as c_uint
 }


