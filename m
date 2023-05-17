Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44261449B3
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:25 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-510db794925so707193a12.1
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355483; x=1686947483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q2MUmGAiEMdaaQsAAxoPHDCIZoeH9n1n1GaPuiAfzA=;
        b=zKAfePblS1nd8XT33ZnJ95+8xGVLMDUS4gyMSoEOyKiGtcCNCMO8kBMGgXG8J58EN5
         HBlHGHGxQq2LEu9iNG+/RWs0ZqlG6Ek4QFwFjHg5+7YBUlFGo26Al3txqchhePqZn6Zl
         uyUTm7AR2QS+S2vtY+gm2LUM+RnnPpXFmn816h8Qw3A4HKo5eNyn1aa9yq/G9Z4VoLGh
         8AhujsdNZPagkjKj0YBFqoq+gvCPaAnE8YNM4V3kfXMge+g2bau9E8rXexTcirMqSBKo
         rFb31MR76JCgHdloKxoYVbWL3y5K/8HEYE0Bzuc64gmIsw+AodoRLJQSWZslY7lWy0RG
         VIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355483; x=1686947483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q2MUmGAiEMdaaQsAAxoPHDCIZoeH9n1n1GaPuiAfzA=;
        b=du9Qllg86E9Qy8PNNcpGf2eYSLZ8Q3aIS9pp5ard3Xbnr0Bk3DI0qrEGuhgqP4EBDQ
         PoR5q2aFHTYqcVVV1tVz5FExvDqAfGrRT2597D3moEDQbcKemCX7KAKDZpcOQKKLSOF9
         L/0fE88avXNZ/wJN9eETyrzHl42koYKBMaIQCI3J9NrTSUiOl/cU2QzAUVKTJufNByE1
         rUpBfvFHAoTTPOJfE5/HsNzdJe7fQKdhRxX9kZuE68ostZf2HUrIJRn70djVCLbD6mL9
         y50NUgUJNtasQxMvV5IX/iUT2MSKKzNeA+yo9LoCS5UdqdLsPe0zTLrhOELS/Fprb/lP
         qWlQ==
X-Gm-Message-State: AC+VfDx03ByN3tqvHBm2LIHHB84E0oxTkc1kNSoe2VjT1QJ/Nvexh1Zb
	ERdgCKBba9WZEiC+GRQ76K20d0K4qSYjzLI=
X-Google-Smtp-Source: ACHHUZ5HBFQWszLoGBLcaNy0DdhkYrWYan90ySkcSdsC2yKoTJ0iZRVUU36MhwoE+D7Z2+HOBM5F516rsgf3jlw=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cd4b:0:b0:504:e957:2926 with SMTP id
 d11-20020a50cd4b000000b00504e9572926mr1473278edj.1.1684355483536; Wed, 17 May
 2023 13:31:23 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:13 +0000
In-Reply-To: <20230517203119.3160435-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230517203119.3160435-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-2-aliceryhl@google.com>
Subject: [PATCH v1 1/7] rust: workqueue: add low-level workqueue bindings
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Define basic low-level bindings to a kernel workqueue. The API defined
here can only be used unsafely. Later commits will provide safe
wrappers.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/lib.rs       |  1 +
 rust/kernel/workqueue.rs | 99 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 rust/kernel/workqueue.rs

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 676995d4e460..c718524056a6 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -47,6 +47,7 @@ pub mod str;
 pub mod sync;
 pub mod task;
 pub mod types;
+pub mod workqueue;
 
 #[doc(hidden)]
 pub use bindings;
diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
new file mode 100644
index 000000000000..e66b6b50dfae
--- /dev/null
+++ b/rust/kernel/workqueue.rs
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Work queues.
+//!
+//! C header: [`include/linux/workqueue.h`](../../../../include/linux/workqueue.h)
+
+use crate::{bindings, types::Opaque};
+
+/// A kernel work queue.
+///
+/// Wraps the kernel's C `struct workqueue_struct`.
+///
+/// It allows work items to be queued to run on thread pools managed by the kernel. Several are
+/// always available, for example, `system`, `system_highpri`, `system_long`, etc.
+#[repr(transparent)]
+pub struct Queue(Opaque<bindings::workqueue_struct>);
+
+// SAFETY: Kernel workqueues are usable from any thread.
+unsafe impl Send for Queue {}
+unsafe impl Sync for Queue {}
+
+impl Queue {
+    /// Use the provided `struct workqueue_struct` with Rust.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that the provided raw pointer is not dangling, that it points at a
+    /// valid workqueue, and that it remains valid until the end of 'a.
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::workqueue_struct) -> &'a Queue {
+        // SAFETY: The `Queue` type is `#[repr(transparent)]`, so the pointer cast is valid. The
+        // caller promises that the pointer is not dangling.
+        unsafe { &*(ptr as *const Queue) }
+    }
+
+    /// Enqueues a work item.
+    ///
+    /// This may fail if the work item is already enqueued in a workqueue.
+    pub fn enqueue<T: WorkItem + Send + 'static>(&self, w: T) -> T::EnqueueOutput {
+        let queue_ptr = self.0.get();
+
+        // SAFETY: There are two cases.
+        //
+        //  1. If `queue_work_on` returns false, then we failed to push the work item to the queue.
+        //     In this case, we don't touch the work item again.
+        //
+        //  2. If `queue_work_on` returns true, then we pushed the work item to the queue. The work
+        //     queue will call the function pointer in the `work_struct` at some point in the
+        //     future. We require `T` to be static, so the type has no lifetimes annotated on it.
+        //     We require `T` to be send, so there are no thread-safety issues to take care of.
+        //
+        // In either case we follow the safety requirements of `__enqueue`.
+        unsafe {
+            w.__enqueue(move |work_ptr| {
+                bindings::queue_work_on(bindings::WORK_CPU_UNBOUND as _, queue_ptr, work_ptr)
+            })
+        }
+    }
+}
+
+/// A work item.
+///
+/// This is the low-level trait that is designed for being as general as possible.
+///
+/// # Safety
+///
+/// Implementers must ensure that `__enqueue` behaves as documented.
+pub unsafe trait WorkItem {
+    /// The return type of [`Queue::enqueue`].
+    type EnqueueOutput;
+
+    /// Enqueues this work item on a queue using the provided `queue_work_on` method.
+    ///
+    /// # Safety
+    ///
+    /// Calling this method guarantees that the provided closure will be called with a raw pointer
+    /// to a `struct work_struct`. The closure should behave in the following way:
+    ///
+    ///  1. If the `struct work_struct` cannot be pushed to a workqueue because its already in one,
+    ///     then the closure should return `false`. It may not access the pointer after returning
+    ///     `false`.
+    ///  2. If the `struct work_struct` is successfully added to a workqueue, then the closure
+    ///     should return `true`. When the workqueue executes the work item, it will do so by
+    ///     calling the function pointer stored in the `struct work_struct`. The work item ensures
+    ///     that the raw pointer remains valid until that happens.
+    ///
+    /// This method may not have any other failure cases than the closure returning `false`. The
+    /// output type should reflect this, but it may also be an infallible type if the work item
+    /// statically ensures that pushing the `struct work_struct` will succeed.
+    ///
+    /// If the work item type is annotated with any lifetimes, then the workqueue must call the
+    /// function pointer before any such lifetime expires. (Or it may forget the work item and
+    /// never call the function pointer at all.)
+    ///
+    /// If the work item type is not [`Send`], then the work item must be executed on the same
+    /// thread as the call to `__enqueue`.
+    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool;
+}
-- 
2.40.1.606.ga4b1b128d6-goog

