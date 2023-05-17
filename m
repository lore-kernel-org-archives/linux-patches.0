Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B4449B1
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:30 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-9659dfe60bcso69353066b.1
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355489; x=1686947489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1m2NIZThmeCBayz0liS/tGETC/9gj7ELeSxPKaC6Yh8=;
        b=BnGU93/l6zgPX74n1BWhPYto1+DmrAaRJmje1ktjtxvvMVe5/ufxtkwfhHuGWoWdhk
         sTD0ze0cB+pBIMUh0eC20QGkHMtXngl1qheah8sXtY3xJUm4p2C/jy+3agGa/nXWMaBI
         cjXQYFgEMFGWjq0AK5WF2hb3rxsDq2qWXzEhoziYVq2kaalDDx9UX4nj4NQFwlvAumU+
         X8d+B3yeLFzGBO3Z8qQeVsV6ID5+4q96aaX8eg1fnDPAsOkB3kNDdNSo2o+kmZH4J8aw
         91bpLwB4E7EfRot8PStAuoblk4n4X2GSjicq/7i8QVuKgUhHDcQKGNJycsRIbr49laKs
         oJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355489; x=1686947489;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1m2NIZThmeCBayz0liS/tGETC/9gj7ELeSxPKaC6Yh8=;
        b=JKwqCuP62BaTFXlzCVmE3uIvZIZppwe+SxJrh15k3SJX0pjkjXhKeFP4w1peHCKHwR
         AarSr54C5UYg5n3oM1hCel5xsgkF3CCHPVMMsoPNuYs5ZqejBrifhFBPs+9ZR6mbq572
         T/z0r3lYPcDosHaGNRqHF3ZrQMp1DUrTnxI+Q9SftC582REQ0xvGN1Wsuc4zLMIFNt0A
         UNFOkI4FTfUiwUkzvSax6WIjqwA0strUS+2K4dbMekPLvjj/kHPryD1pM6hXDYs0Ua40
         A3HRFCNhvvp19czCl/CGxxiNxWQ4iazrCfQjvNcjLlj2OerRMWKHABPpqiTJIjYQnHTL
         Uyzg==
X-Gm-Message-State: AC+VfDz3fVtXSBBMlfrK0ojgffF7lr9UA0weea0RsOaYgqnLCMGPcSEM
	MfclRsKBPS/zrYobb80Sj2RASD7Ob32ZUhk=
X-Google-Smtp-Source: ACHHUZ6sg88Il3pJwgEPwAiDSK3Ct7Xt3RuoovGGygDfZP0R/TVVkjhn15R+rZzdr/rlqagjcoaYfOdz6TWU5JQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:2bf5:b0:94e:dcd5:2429 with SMTP
 id gv53-20020a1709072bf500b0094edcd52429mr1413196ejc.3.1684355488912; Wed, 17
 May 2023 13:31:28 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:15 +0000
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517203119.3160435-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-4-aliceryhl@google.com>
Subject: [PATCH v1 3/7] rust: sync: add `Arc::{from_raw, into_raw}`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
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
---
 rust/kernel/lib.rs      |  1 +
 rust/kernel/sync/arc.rs | 44 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index cdf9fe999328..82854c86e65d 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -22,6 +22,7 @@
 #![feature(generic_associated_types)]
 #![feature(new_uninit)]
 #![feature(pin_macro)]
+#![feature(ptr_metadata)]
 #![feature(receiver_trait)]
 #![feature(unsize)]
 
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index e6d206242465..7c55a9178dfb 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -210,6 +210,50 @@ impl<T: ?Sized> Arc<T> {
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
+        // SAFETY: The safety requirement ensures that the pointer is valid.
+        let val_align = core::mem::align_of_val(unsafe { &*ptr });
+        let refcount_size = core::mem::size_of::<Opaque<bindings::refcount_t>>();
+
+        // Use the `repr(C)` algorithm to compute the offset of `data` in `ArcInner`.
+        //
+        // Pseudo-code for the `#[repr(C)]` algorithm can be found here:
+        // <https://doc.rust-lang.org/reference/type-layout.html#reprc-structs>
+        let mut val_offset = refcount_size;
+        let val_misalign = val_offset % val_align;
+        if val_misalign > 0 {
+            val_offset += val_align - val_misalign;
+        }
+
+        // This preserves the metadata in the pointer, if any.
+        let metadata = core::ptr::metadata(ptr as *const ArcInner<T>);
+        let ptr = (ptr as *mut u8).wrapping_sub(val_offset) as *mut ();
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
2.40.1.606.ga4b1b128d6-goog

