Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17DB449B2
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:37 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-510d1c71b8fso1158246a12.2
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355496; x=1686947496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fgvSQEdS5WExED0wIm07QH2swg26Pv/48bDvBCAkvT4=;
        b=maslnMdSIs3sxQ2nroKBfN5UKh7kzcmPZXZKPZDG1mkKjMNiq6Sx3RzKw8XFHAGe8n
         k3L3evQ/vtn8IacWG3XJzNd3ZOCiYjPUvMND8SKlIZIqq+vCf7BNkYCXgdmUs0g5kPVU
         d/Le0ssyJh4Qjjsn+BSRp/efSWewRGUBrPjvyG2/rayWOXYLwdbdLCoa5e4ybdYOmH4w
         yj27QUvsyLFi1cMCuK4Lo3P7ovUq8+2rHG/Zk1MnPBV6fs3TlGhGROs3nCeC59C7yH4f
         nVr/1CgiWZ0VdY/fJCmgJsisAiB8JlHKt6vTHrXTBZ+RaGeYu6jYNhR/3GcuckYueYEI
         pD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355496; x=1686947496;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fgvSQEdS5WExED0wIm07QH2swg26Pv/48bDvBCAkvT4=;
        b=kykxqqcbMgPCTJbwDur2raIRKbhve8FQ6ovC5Dp9klkKEVMafb4KotXmd4OLWWBMU5
         D2KQv/bfyTENdTvwzIZkNT6BdJRbe0+BagjUAwASghUukGrWVXBr3HlyagfdLKmUJYB3
         jdn1WqfHtcBmH4XL4DZj6TwaUGHsG2jZ5zGsw+lKQ4d+qSJ4gESzsJiVMBroOvj8Mvu7
         uEFruLCeaKV4BwgZ7bnm/b5yOxn0BzrvtapN1T+0YjAlIk0Bj2KrK82/f/VNhUjxbvRs
         TZcRO/4Noi0T+da8U+LUChVfnm5+LJnJlvJNJIIAto3CBSmD4h297IWj4gtlU+oS6jMd
         75vA==
X-Gm-Message-State: AC+VfDx2Vo3zB2qljqAUeF1NwogVFtm7q7DPWuza5yZejPKN7Lj0KpNP
	xzvUcyvsR0BaG4zBpdECwxMnBy2Wjm98SKA=
X-Google-Smtp-Source: ACHHUZ7dvXwdh77XBCdrNE6xAN72hdaASCLaqBrTsulwaPM7VU8R5rXG7v3fyKtw8n4XpaNyBrGDs6oVKyV7Llw=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:75c3:b0:94a:4c68:c1aa with SMTP
 id jl3-20020a17090775c300b0094a4c68c1aamr16788766ejc.7.1684355496096; Wed, 17
 May 2023 13:31:36 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:18 +0000
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517203119.3160435-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-7-aliceryhl@google.com>
Subject: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This commit introduces `ArcWorkItem`, `BoxWorkItem`, and
`define_work_adapter_newtype!` that make it possible to use the
workqueue without any unsafe code whatsoever.

The `ArcWorkItem` and `BoxWorkItem` traits are used when a struct has a
single `work_struct` field.

The `define_work_adapter_newtype!` macro is used when a struct has
multiple `work_struct` fields. For each `work_struct` field, a newtype
struct is defined that wraps `Arc<TheStruct>`, and pushing an instance
of the newtype to a workqueue will enqueue it using the associated
`work_struct` field. The newtypes are matched with `work_struct` fields
by having the T in `Work<T>` be the newtype.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/workqueue.rs | 332 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 331 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 7509618af252..007005ddcaf0 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -4,8 +4,9 @@
 //!
 //! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
 
-use crate::{bindings, prelude::*, types::Opaque};
+use crate::{bindings, prelude::*, sync::Arc, types::Opaque};
 use core::marker::{PhantomData, PhantomPinned};
+use core::result::Result;
 
 /// A kernel work queue.
 ///
@@ -279,6 +280,335 @@ macro_rules! impl_has_work {
     )*};
 }
 
+/// Declares that [`Arc<Self>`] should implement [`WorkItem`].
+///
+/// # Examples
+///
+/// The example below will make [`Arc<MyStruct>`] implement the [`WorkItem`] trait so that you can
+/// enqueue it in a workqueue.
+///
+/// ```
+/// use kernel::sync::Arc;
+///
+/// struct MyStruct {
+///     work_field: Work<Arc<MyStruct>>,
+/// }
+///
+/// kernel::impl_has_work! {
+///     impl HasWork<Arc<MyStruct>> for MyStruct { self.work_field }
+/// }
+///
+/// impl ArcWorkItem for MyStruct {
+///     fn run(self: Arc<Self>) {
+///         pr_info!("Executing MyStruct on a workqueue.");
+///     }
+/// }
+/// ```
+///
+/// [`Arc<Self>`]: crate::sync::Arc
+/// [`Arc<MyStruct>`]: crate::sync::Arc
+pub trait ArcWorkItem {
+    /// Called when this work item is executed.
+    fn run(self: Arc<Self>);
+}
+
+unsafe impl<T> WorkItem for Arc<T>
+where
+    T: ArcWorkItem + HasWork<Self> + ?Sized,
+{
+    type EnqueueOutput = Result<(), Self>;
+
+    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool,
+    {
+        let ptr = Arc::into_raw(self);
+
+        // Using `get_work_offset` here for object-safety.
+        //
+        // SAFETY: The pointer is valid since we just got it from `into_raw`.
+        let off = unsafe { (&*ptr).get_work_offset() };
+
+        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
+        // `Work<Self>` in the same allocation.
+        let work_ptr = unsafe { (ptr as *const u8).add(off) as *const Work<Self> };
+        // SAFETY: The pointer is not dangling.
+        let work_ptr = unsafe { Work::raw_get(work_ptr) };
+
+        match (queue_work_on)(work_ptr) {
+            true => Ok(()),
+            // SAFETY: The work queue has not taken ownership of the pointer.
+            false => Err(unsafe { Arc::from_raw(ptr) }),
+        }
+    }
+}
+
+// Let `Work<Arc<T>>` be usable with types that are `ArcWorkItem`.
+//
+// We do not allow unsized types here. The `Work<Arc<T>>` field should always specify the actual
+// concrete type stored in the `Arc`.
+//
+// SAFETY: The `Work<Arc<T>>` field must be initialized with this `run` method because the `Work`
+// struct prevents you from initializing it in any other way. The `__enqueue` trait uses the
+// same `Work<Arc<T>>` field because `HasWork` promises to always return the same field.
+unsafe impl<T> WorkItemAdapter for Arc<T>
+where
+    T: ArcWorkItem + HasWork<Self> + Sized,
+{
+    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
+        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<Self>`.
+        let ptr = ptr as *mut Work<Self>;
+        // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+        let ptr = unsafe { T::work_container_of(ptr) };
+        // SAFETY: This pointer comes from `Arc::into_raw` and we've been given back ownership.
+        let arc = unsafe { Arc::from_raw(ptr) };
+
+        arc.run();
+    }
+}
+
+/// Declares that [`Pin`]`<`[`Box`]`<Self>>` should implement [`WorkItem`].
+///
+/// # Examples
+///
+/// The example below will make [`Pin`]`<`[`Box`]`<MyStruct>>` implement the [`WorkItem`] trait so
+/// that you can enqueue it in a workqueue.
+///
+/// ```
+/// struct MyStruct {
+///     work_field: Work<Pin<Box<MyStruct>>>,
+/// }
+///
+/// kernel::impl_has_work! {
+///     impl HasWork<Pin<Box<MyStruct>>> for MyStruct { self.work_field }
+/// }
+///
+/// impl BoxWorkItem for MyStruct {
+///     fn run(self: Pin<Box<MyStruct>>) {
+///         pr_info!("Executing MyStruct on a workqueue.");
+///     }
+/// }
+/// ```
+///
+/// [`Box`]: alloc::boxed::Box
+/// [`Pin`]: core::pin::Pin
+pub trait BoxWorkItem {
+    /// Called when this work item is executed.
+    fn run(self: Pin<Box<Self>>);
+}
+
+unsafe impl<T> WorkItem for Pin<Box<T>>
+where
+    T: BoxWorkItem + HasWork<Self> + ?Sized,
+{
+    // When a box is in a workqueue, the workqueue has exclusive ownership of the box. Therefore,
+    // it's not possible to enqueue a box while it is in a workqueue.
+    type EnqueueOutput = ();
+
+    unsafe fn __enqueue<F>(self, queue_work_on: F)
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool,
+    {
+        // SAFETY: We will not used the contents in an unpinned manner.
+        let ptr = unsafe { Box::into_raw(Pin::into_inner_unchecked(self)) };
+
+        // Using `get_work_offset` here for object-safety.
+        //
+        // SAFETY: The pointer is valid since we just got it from `into_raw`.
+        let off = unsafe { (&*ptr).get_work_offset() };
+
+        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
+        // `Work<Self>` in the same allocation.
+        let work_ptr = unsafe { (ptr as *mut u8).add(off) as *mut Work<Self> };
+        // SAFETY: The pointer is not dangling.
+        let work_ptr = unsafe { Work::raw_get(work_ptr) };
+
+        match (queue_work_on)(work_ptr) {
+            true => {}
+            // SAFETY: This method requires exclusive ownership of the box, so it cannot be in a
+            // workqueue.
+            false => unsafe { core::hint::unreachable_unchecked() },
+        }
+    }
+}
+
+// Let `Work<Pin<Box<T>>>` be usable with types that are `BoxWorkItem`.
+//
+// We do not allow unsized types here. The `Work<Pin<Box<T>>>` field should always specify the actual
+// concrete type stored in the `Box`.
+//
+// SAFETY: The `Work<Pin<Box<T>>>` field must be initialized with this run method because the `Work`
+// struct prevents you from initializing it in any other way. The `__enqueue` trait uses the
+// same `Work<Pin<Box<T>>>` field because `HasWork` promises to always return the same field.
+unsafe impl<T> WorkItemAdapter for Pin<Box<T>>
+where
+    T: BoxWorkItem + HasWork<Self> + Sized,
+{
+    unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
+        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<Self>`.
+        let ptr = ptr as *mut Work<Self>;
+        // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+        let ptr = unsafe { T::work_container_of(ptr) };
+        // SAFETY: This pointer comes from `Box::into_raw` and we've been given back ownership.
+        // The box was originally pinned, so pinning it again is ok.
+        let boxed = unsafe { Pin::new_unchecked(Box::from_raw(ptr)) };
+
+        boxed.run();
+    }
+}
+
+/// Helper macro for structs with several `Work` fields that can be in several queues at once.
+///
+/// For each `Work` field in your type `T`, a newtype struct that wraps an `Arc<T>` or
+/// `Pin<Box<T>>` should be defined.
+///
+/// # Examples
+///
+/// ```
+/// struct MyStruct {
+///     work1: Work<MyStructWork1>,
+///     work2: Work<MyStructWork2>,
+/// }
+///
+/// impl_has_work! {
+///     impl HasWork<MyStructWork1> for MyStruct { self.work1 }
+///     impl HasWork<MyStructWork2> for MyStruct { self.work2 }
+/// }
+///
+/// define_work_adapter_newtype! {
+///     struct MyStructWork1(Arc<MyStruct>);
+///     struct MyStructWork2(Arc<MyStruct>);
+/// }
+///
+/// impl MyStructWork1 {
+///     fn run(self) {
+///         // ...
+///     }
+/// }
+///
+/// impl MyStructWork2 {
+///     fn run(self) {
+///         // ...
+///     }
+/// }
+/// ```
+///
+/// This will let you push a `MyStructWork1(arc)` or `MyStructWork2(arc)` to a work queue. The [`Arc`]
+/// can be in two work queues at the same time, and the `run` method on the wrapper type is called
+/// when the work item is called.
+///
+/// [`Arc`]: crate::sync::Arc
+#[macro_export]
+macro_rules! define_work_adapter_newtype {
+    (
+        $(#[$outer:meta])*
+        $pub:vis struct $name:ident(
+            $(#[$innermeta:meta])*
+            $fpub:vis Arc<$inner:ty> $(,)?
+        );
+        $($rest:tt)*
+    ) => {
+        $(#[$outer])*
+        $pub struct $name($(#[$innermeta])* $fpub $crate::sync::Arc<$inner>);
+
+        unsafe impl $crate::workqueue::WorkItem for $name {
+            type EnqueueOutput = ::core::result::Result<(), $name>;
+
+            unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+            where
+                F: ::core::ops::FnOnce(*mut $crate::bindings::work_struct) -> bool,
+            {
+                let ptr = $crate::sync::Arc::into_raw(self.0);
+
+                // SAFETY: The pointer is not dangling since we just got it from Arc::into_raw.
+                let work_ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::raw_get_work(ptr.cast_mut()) };
+
+                // SAFETY: The pointer is not dangling.
+                let work_ptr = unsafe { $crate::workqueue::Work::raw_get(work_ptr) };
+
+                match (queue_work_on)(work_ptr) {
+                    true => Ok(()),
+                    // SAFETY: The work queue has not taken ownership of the pointer.
+                    false => Err($name(unsafe { $crate::sync::Arc::from_raw(ptr) })),
+                }
+            }
+        }
+
+        unsafe impl $crate::workqueue::WorkItemAdapter for $name {
+            unsafe extern "C" fn run(ptr: *mut $crate::bindings::work_struct) {
+                // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<Self>`.
+                let ptr = ptr as *mut $crate::workqueue::Work<Self>;
+                // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+                let ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::work_container_of(ptr) };
+                // SAFETY: This pointer comes from `Arc::into_raw` and we've been given back ownership.
+                let arc = unsafe { $crate::sync::Arc::from_raw(ptr) };
+
+                $name::run($name(arc));
+            }
+        }
+
+        define_work_adapter_newtype! { $($rest)* }
+    };
+
+    (
+        $(#[$outer:meta])*
+        $pub:vis struct $name:ident(
+            $(#[$innermeta:meta])*
+            $fpub:vis Pin<Box<$inner:ty>> $(,)?
+        );
+        $($rest:tt)*
+    ) => {
+        $(#[$outer])*
+        $pub struct $name($(#[$innermeta])* $fpub ::core::pin::Pin<::alloc::boxed::Box<$inner>>);
+
+        unsafe impl $crate::workqueue::WorkItem for $name {
+            type EnqueueOutput = ();
+
+            unsafe fn __enqueue<F>(self, queue_work_on: F)
+            where
+                F: ::core::ops::FnOnce(*mut $crate::bindings::work_struct) -> bool,
+            {
+                // SAFETY: We will not used the contents in an unpinned manner.
+                let boxed = unsafe { ::core::pin::Pin::into_inner_unchecked(self.0) };
+                let ptr = ::alloc::boxed::Box::into_raw(boxed);
+
+                // SAFETY: The pointer is not dangling since we just got it from Box::into_raw.
+                let work_ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::raw_get_work(ptr) };
+
+                // SAFETY: The pointer is not dangling.
+                let work_ptr = unsafe { $crate::workqueue::Work::raw_get(work_ptr) };
+
+                match (queue_work_on)(work_ptr) {
+                    true => {},
+                    // SAFETY: This method requires exclusive ownership of the box, so it cannot be in a
+                    // workqueue.
+                    false => unsafe { ::core::hint::unreachable_unchecked() },
+                }
+            }
+        }
+
+        unsafe impl $crate::workqueue::WorkItemAdapter for $name {
+            unsafe extern "C" fn run(ptr: *mut $crate::bindings::work_struct) {
+                // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<Self>`.
+                let ptr = ptr as *mut $crate::workqueue::Work<Self>;
+                // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
+                let ptr = unsafe { <$inner as $crate::workqueue::HasWork::<$name>>::work_container_of(ptr) };
+                // SAFETY: This pointer comes from `Box::into_raw` and we've been given back ownership.
+                let boxed = unsafe { ::alloc::boxed::Box::from_raw(ptr) };
+                // SAFETY: The box was originally pinned, so pinning it again is ok.
+                let boxed = unsafe { ::core::pin::Pin::new_unchecked(boxed) };
+
+                $name::run($name(boxed));
+            }
+        }
+
+        define_work_adapter_newtype! { $($rest)* }
+    };
+
+    // After processing the last definition, we call ourselves with no input.
+    () => {};
+}
+
 /// Returns the system work queue (`system_wq`).
 ///
 /// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU multi-threaded. There are
-- 
2.40.1.606.ga4b1b128d6-goog

