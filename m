Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7656D21079
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:50:52 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-96fe843f61eso65719866b.2
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 06:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685627450; x=1688219450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FuSvyE3H/lsB/N9LBubh06h32izpsOqcuowYerHxhqc=;
        b=FyvVJlD2CGIUJvNbQZbNEYbMCpjM2wfkXCGCXQdGdxbllqs61y+dOimrUiXITslDnr
         L0xzV3vfgwdACLzxRZt2w/DUr0I0hVp38FptQFQB6p9HI8WTeYEqxuLkrzz5udg311TU
         P31I2p4lYUs39xALew33gD26gaTMk5tNQ6oSCPSJoYX0pP5ep3b5P0RNsM1r1kT4n/fe
         iI4kk5O3HoJfozo7oHD16yShr/tg4SPDVzuEmF1fYUSe19h8vKIorMgbuPFZHd/uKeEN
         9035Iz0htSCg+0b9FgqdQzj12QUgODRxB+tsT3VI3//m07btmf13UfCNEU/ZNeURTvpq
         Knhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685627450; x=1688219450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FuSvyE3H/lsB/N9LBubh06h32izpsOqcuowYerHxhqc=;
        b=WsGgwDvRxHMmNTI1MBdckBaJH5Oe2MKowDgQTjiks2ZQ7TvX1Tvo5oVN/t31nIT2kQ
         9iuSrlcllyhWmuIjQv0KRBP8AbO7zJjmdGGLNcpPvRI3/rg3LPbv8fUE2hI62aGL6v4e
         lfZQInhxh5XwRb3i36EDYOEumfEwaupmKp2LBeLCRaQJlugu558KAk8vSbQHPGXTtuP1
         c60BNJNUK7dK3oiuXXneN5hRomLQ7Et37PcQ/+O2my8cYamvIovSzcatF0xQuYprhd5P
         arhsPG1/fkW1ikllt1kvY21yDN0GLFQoNwS3oBsDErMzWBRJgKgKgQChD8lzM2WDjDky
         6gcw==
X-Gm-Message-State: AC+VfDyob2y72segc5igeTtuR7mu/O5O3aqUK8s+l7D+jrmSM2z12lge
	RwO8aqyWQVTSClZT/3EYfg+hwkn9VI52HX0=
X-Google-Smtp-Source: ACHHUZ6TR3gcEhy6cUHWUaknBY4LOpR/0VQfiptgYOtwdk6sQS7UXBw3mwnxPT2zlqGTkevpuGugbzKDFTYvcnc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:270c:b0:96f:ddeb:9e8c with SMTP
 id w12-20020a170907270c00b0096fddeb9e8cmr3366915ejk.6.1685627450568; Thu, 01
 Jun 2023 06:50:50 -0700 (PDT)
Date: Thu,  1 Jun 2023 13:49:39 +0000
In-Reply-To: <20230601134946.3887870-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230601134946.3887870-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601134946.3887870-2-aliceryhl@google.com>
Subject: [PATCH v2 1/8] rust: workqueue: add low-level workqueue bindings
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

Co-developed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/bindings/bindings_helper.h |   1 +
 rust/kernel/lib.rs              |   1 +
 rust/kernel/workqueue.rs        | 107 ++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)
 create mode 100644 rust/kernel/workqueue.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 50e7a76d5455..ae2e8f018268 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -10,6 +10,7 @@
 #include <linux/refcount.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
+#include <linux/workqueue.h>
 
 /* `bindgen` gets confused at certain things. */
 const gfp_t BINDINGS_GFP_KERNEL = GFP_KERNEL;
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 85b261209977..eaded02ffb01 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -43,6 +43,7 @@
 pub mod sync;
 pub mod task;
 pub mod types;
+pub mod workqueue;
 
 #[doc(hidden)]
 pub use bindings;
diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
new file mode 100644
index 000000000000..9c630840039b
--- /dev/null
+++ b/rust/kernel/workqueue.rs
@@ -0,0 +1,107 @@
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
+    ///
+    /// The work item will be submitted using `WORK_CPU_UNBOUND`.
+    pub fn enqueue<W, const ID: u64>(&self, w: W) -> W::EnqueueOutput
+    where
+        W: RawWorkItem<ID> + Send + 'static,
+    {
+        let queue_ptr = self.0.get();
+
+        // SAFETY: We only return `false` if the `work_struct` is already in a workqueue. The other
+        // `__enqueue` requirements are not relevant since `W` is `Send` and static.
+        //
+        // The call to `bindings::queue_work_on` will dereference the provided raw pointer, which
+        // is ok because `__enqueue` guarantees that the pointer is valid for the duration of this
+        // closure.
+        //
+        // Furthermore, if the C workqueue code accesses the pointer after this call to
+        // `__enqueue`, then the work item was successfully enqueued, and `bindings::queue_work_on`
+        // will have returned true. In this case, `__enqueue` promises that the raw pointer will
+        // stay valid until we call the function pointer in the `work_struct`, so the access is ok.
+        unsafe {
+            w.__enqueue(move |work_ptr| {
+                bindings::queue_work_on(bindings::WORK_CPU_UNBOUND as _, queue_ptr, work_ptr)
+            })
+        }
+    }
+}
+
+/// A raw work item.
+///
+/// This is the low-level trait that is designed for being as general as possible.
+///
+/// The `ID` parameter to this trait exists so that a single type can provide multiple
+/// implementations of this trait. For example, if a struct has multiple `work_struct` fields, then
+/// you will implement this trait once for each field, using a different id for each field. The
+/// actual value of the id is not important as long as you use different ids for different fields
+/// of the same struct. (Fields of different structs need not use different ids.)
+///
+/// Note that the id is used only to select the right method to call during compilation. It wont be
+/// part of the final executable.
+///
+/// # Safety
+///
+/// Implementers must ensure that any pointers passed to a `queue_work_on` closure by `__enqueue`
+/// remain valid for the duration specified in the documentation for `__enqueue`.
+pub unsafe trait RawWorkItem<const ID: u64> {
+    /// The return type of [`Queue::enqueue`].
+    type EnqueueOutput;
+
+    /// Enqueues this work item on a queue using the provided `queue_work_on` method.
+    ///
+    /// # Guarantees
+    ///
+    /// If this method calls the provided closure, then the raw pointer is guaranteed to point at a
+    /// valid `work_struct` for the duration of the call to the closure. If the closure returns
+    /// true, then it is further guaranteed that the pointer remains valid until someone calls the
+    /// function pointer stored in the `work_struct`.
+    ///
+    /// # Safety
+    ///
+    /// The provided closure may only return `false` if the `work_struct` is already in a workqueue.
+    ///
+    /// If the work item type is annotated with any lifetimes, then you must not call the function
+    /// pointer after any such lifetime expires. (Never calling the function pointer is okay.)
+    ///
+    /// If the work item type is not [`Send`], then the function pointer must be called on the same
+    /// thread as the call to `__enqueue`.
+    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
+    where
+        F: FnOnce(*mut bindings::work_struct) -> bool;
+}
-- 
2.41.0.rc0.172.g3f132b7071-goog

