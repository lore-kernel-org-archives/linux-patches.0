Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06432182B3
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:38:37 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-993d7ca4607so225440366b.1
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068316; x=1691660316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MBgmP0PJ2iUxFozvmmmYwZcxD6aJZ5z3cAsE+Xf1as4=;
        b=ZW2z8hOF1WRo80QrafK0JkXI57zkP9C7rM4fPyaa1AxBIiYredVLSA46iO2WpKHuUc
         +geNJaQzzi4cADrIqii2oBP5uLE/koheH+H1dMZyW8g5P9DFudIKPnlIzlwxlbWP54xt
         x6BbXLcZAVMRHMd+S6GmIEOg64evUP91Wj0dubwkkXgIVikM48pkRssOCeOwdeiI6bvT
         Jd1XfA7QMJ5YTREszwAJD9SPurKXk6nAfSemFpFTVlt9+TveOlmzcZxNfHAc1HQzr5pc
         s+HBC/OZwUOw33LF1YhiwJbMowsX/6i0a4QjDkKySJUXnHVTvlV6uJVuyzYybavzJcs7
         a3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068316; x=1691660316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBgmP0PJ2iUxFozvmmmYwZcxD6aJZ5z3cAsE+Xf1as4=;
        b=BoSbC9yem5ffmRY6NsNNXLyHsuWNz7yVBTOOBfN09oknnAb2Yi9uADbCmml4VLSXyU
         DavfrDcM8tG+55B4bRL83AOPo6YIw/FXL5L54TT+TJ8po8xn06FoOJOp7qa5j/qceDkL
         LD+yc3adaNR7CzuDDbjFfVyrjHQlIw43eztnoXVovFNwPvYrFbn4ZMLBjZAvgEu35NGs
         ChF5kzF1gqSRK0BJlNjZK36wplWPjPhQgVAD54WxD8zTKyBcJQ0mSnxTtWLSpI8NPKeD
         32R7nIvqiCRqJODPcbEURf+qTXZP6nZk7bWmjhguS8k2QK3hf+Ir3UDCi2a5vHdTjZGN
         yQFw==
X-Gm-Message-State: ABy/qLae3DJbkWjrfrQgfDPS+eU8EJhzZ5K5cXGkl1f0REkQoDEj0JKc
	LvWdgR5r/M2V7Oa/RpkEYToQiaAWa4Js2L4=
X-Google-Smtp-Source: APBJJlHRkdAxXDJOzU6GNe5HqX7AK0yIjF3AgFRk6eKq/3smS8Hc+PazHrra3a28syJBLWIV2m+lLAmY5hhiBQU=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:a047:b0:98e:4e80:f0e3 with SMTP
 id gz7-20020a170907a04700b0098e4e80f0e3mr50726ejc.9.1689068316182; Tue, 11
 Jul 2023 02:38:36 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:32:56 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-3-aliceryhl@google.com>
Subject: [PATCH v3 2/9] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
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
---
v2 -> v3:
 * Use `transmute_copy` to convert metadata.
 * Use `add` instead of `wrapping_add`.
 * Dropped Reviewed-by from Martin and Benno due to changes.

 rust/kernel/lib.rs      |  1 +
 rust/kernel/sync/arc.rs | 49 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 788914fd935f..6963d11092c4 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -17,6 +17,7 @@
 #![feature(const_refs_to_cell)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
+#![feature(ptr_metadata)]
 #![feature(receiver_trait)]
 #![feature(unsize)]
 
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index a89843cacaad..4046b534e53b 100644
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
 
@@ -212,6 +212,51 @@ unsafe fn from_inner(inner: NonNull<ArcInner<T>>) -> Self {
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
+    /// This code relies on the `repr(C)` layout of structs as described in
+    /// <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must have been returned by a previous call to [`Arc::into_raw`]. Additionally, it
+    /// can only be called once for each previous call to [`Arc::into_raw`].
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
2.41.0.255.g8b1d071c50-goog

