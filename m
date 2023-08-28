Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D6C11C8D
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:06 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-99bfe6a531bso230305866b.1
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 03:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693219744; x=1693824544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pDP42zhivXOqcs6bhwO68yvQPwPyC5hRmGTeBYgZbjo=;
        b=7V18r85iP6wYbDoB1Q2CxxH0UUwhkNHMc2j+CCaD4bNBnGp3Upadsvuh6Gin4Ft9b+
         fxS1b8qCXpGTZKY5L7jD1GmZtORRAJvp7jnsgIGYKmSM0Gq88hmWzLdOGOMujD7umUjz
         AZZEKUdn5EAMSJBlDg9fqIuSF34asIai6XpTpwKWnBbYNjswJD+5hsw/oIP9T+2V90mb
         +D6p0YLVxp7QeIWUWIckbRYAEgjZCMPEtceRVo1reEYt6OfY/EqTJUkDRcdgaFTTq1o+
         hnAGxlBJk+Or3zqDRxBqcE9PKSiv21q/uhAvZGh6S8hW3ayWBxyfWgZ9vZMV0ISyxkPn
         jXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693219744; x=1693824544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDP42zhivXOqcs6bhwO68yvQPwPyC5hRmGTeBYgZbjo=;
        b=ehs3US3xlcRkQ3wq46X1IYmJLKpFWR+oyxgx7xUu1kcF4fGszdK6kiHIte4yy/Wc60
         GcETNUXgl/FOpUMjnb0udm/uNNSjP2aV8Fa+1zHYDZq+lAp3gYQKsAk96GxnPkOuD+0D
         zxza2xnTQ10Zu56RGkgXHUs8DjctEQuIcZZUpPvMAXa7u/MJFW/VCQcxcP+tXt9tREHr
         dANyWv8CaNgCCes2ZG9molfCJQ8TEjckai4OtX1aqN095ix024LhYZmCDzmz+azT/FIR
         vqgZyqKXH5GSIgge+A5qggyT1kTzf/egpLEEKAs1dsOebUXfAwADabv1yRcp20d7fqFC
         nW8A==
X-Gm-Message-State: AOJu0Yz6Jz4o7goyGo7qn6UFW+Y2lM9ruMjoYlyn9xJguHvSA6l033ah
	9GHLmGiD+wKBEfWNmEl2iRuIv0nti4yF5HU=
X-Google-Smtp-Source: AGHT+IEdOjPh0Uew8IdWm/tyy/0oO+3TUd+SIs77H1knmFnd3hNZemCnPFGJq1OlHiFl5RLAX9VYSyKw8p7K1Ew=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:3546:b0:9a1:c474:8e5f with SMTP
 id aa6-20020a170907354600b009a1c4748e5fmr352725ejc.8.1693219744499; Mon, 28
 Aug 2023 03:49:04 -0700 (PDT)
Date: Mon, 28 Aug 2023 10:48:01 +0000
In-Reply-To: <20230828104807.1581592-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230828104807.1581592-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230828104807.1581592-2-aliceryhl@google.com>
Subject: [PATCH v4 1/7] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>, 
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>, Andreas Hindborg <a.hindborg@samsung.com>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

These methods can be used to turn an `Arc` into a raw pointer and back,
in a way that preserves the metadata for fat pointers.

This is done using the unstable ptr_metadata feature [1]. However, it
could also be done using the unstable pointer_byte_offsets feature [2],
which is likely to have a shorter path to stabilization than
ptr_metadata.

Link: https://github.com/rust-lang/rust/issues/81513 [1]
Link: https://github.com/rust-lang/rust/issues/96283 [2]
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
---
v3 -> v4:
 * Update doc comment for `Arc::from_raw`.
 * Add Reviewed-by for Martin, Benno, and Andreas.

 rust/kernel/lib.rs      |  1 +
 rust/kernel/sync/arc.rs | 46 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index d59041ff5ff2..abeef423d3a8 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -16,6 +16,7 @@
 #![feature(coerce_unsized)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
+#![feature(ptr_metadata)]
 #![feature(receiver_trait)]
 #![feature(unsize)]
 
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 172f563976a9..cae2ff44920b 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -24,13 +24,13 @@
 };
 use alloc::boxed::Box;
 use core::{
-    alloc::AllocError,
+    alloc::{AllocError, Layout},
     fmt,
     marker::{PhantomData, Unsize},
     mem::{ManuallyDrop, MaybeUninit},
     ops::{Deref, DerefMut},
     pin::Pin,
-    ptr::NonNull,
+    ptr::{NonNull, Pointee},
 };
 use macros::pin_data;
 
@@ -212,6 +212,48 @@ unsafe fn from_inner(inner: NonNull<ArcInner<T>>) -> Self {
         }
     }
 
+    /// Convert the [`Arc`] into a raw pointer.
+    ///
+    /// The raw pointer has ownership of the refcount that this Arc object owned.
+    pub fn into_raw(self) -> *const T {
+        let ptr = self.ptr.as_ptr();
+        core::mem::forget(self);
+        // SAFETY: The pointer is valid.
+        unsafe { core::ptr::addr_of!((*ptr).data) }
+    }
+
+    /// Recreates an [`Arc`] instance previously deconstructed via [`Arc::into_raw`].
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
+    /// must not be called more than once for each previous call to [`Arc::into_raw`].
+    pub unsafe fn from_raw(ptr: *const T) -> Self {
+        let refcount_layout = Layout::new::<bindings::refcount_t>();
+        // SAFETY: The caller guarantees that the pointer is valid.
+        let val_layout = Layout::for_value(unsafe { &*ptr });
+        // SAFETY: We're computing the layout of a real struct that existed when compiling this
+        // binary, so its layout is not so large that it can trigger arithmetic overflow.
+        let val_offset = unsafe { refcount_layout.extend(val_layout).unwrap_unchecked().1 };
+
+        let metadata: <T as Pointee>::Metadata = core::ptr::metadata(ptr);
+        // SAFETY: The metadata of `T` and `ArcInner<T>` is the same because `ArcInner` is a struct
+        // with `T` as its last field.
+        //
+        // This is documented at:
+        // <https://doc.rust-lang.org/std/ptr/trait.Pointee.html>.
+        let metadata: <ArcInner<T> as Pointee>::Metadata =
+            unsafe { core::mem::transmute_copy(&metadata) };
+        // SAFETY: The pointer is in-bounds of an allocation both before and after offsetting the
+        // pointer, since it originates from a previous call to `Arc::into_raw` and is still valid.
+        let ptr = unsafe { (ptr as *mut u8).sub(val_offset) as *mut () };
+        let ptr = core::ptr::from_raw_parts_mut(ptr, metadata);
+
+        // SAFETY: By the safety requirements we know that `ptr` came from `Arc::into_raw`, so the
+        // reference count held then will be owned by the new `Arc` object.
+        unsafe { Self::from_inner(NonNull::new_unchecked(ptr)) }
+    }
+
     /// Returns an [`ArcBorrow`] from the given [`Arc`].
     ///
     /// This is useful when the argument of a function call is an [`ArcBorrow`] (e.g., in a method
-- 
2.42.0.rc1.204.g551eb34607-goog

