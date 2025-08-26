Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CB329D26A;
	Tue, 26 Aug 2025 11:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208692; cv=none; b=Jp4jAjpJvgdrzhOE8Vja4vPVwFq6CUADqdH0WBQrI2Adj7RcC9s9TRDwy1TwFtJmz5uPCO4yRFYE2VZ38hHxaPobLqwMW/dU4JR2VrT2kak/P4TudXXwrMW0YZgbuI+0Xho4ZEemi0kgOVYAdku7t5uNxF3y+CcMubTd0WIAaZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208692; c=relaxed/simple;
	bh=j3AONzOvK1YDmmEx2oHeocH/D03t0fU0+XlEJxRR7FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0+0kJt+9b/DFjAwq++ISryPYkbJdYcOAGJjm4Bj5ulp/9E2cJRxh1SXUYlUYXSouNH6f8s0eheeNW2lILh9PNtl1Aogw7cAtelWIxSnnXEpo/Q4bKDK6cIWjfdV5ax2MxI3Cfr/xPLrEZ91rz26e1pCxEbQbeJtSAy/H/V6kM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RY73WWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RY73WWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBB5C4CEF1;
	Tue, 26 Aug 2025 11:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208691;
	bh=j3AONzOvK1YDmmEx2oHeocH/D03t0fU0+XlEJxRR7FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RY73WWLVn14MCQ8tf7IqKzVLx0KfDGxMRPux5QMBEvTr2qnxtQWGq8mqARWRo1KF
	 nFkxSaKgGkgDvHwR4A2DakJeluIzE7S/yE9vyZkltKfLIjB5xg/lqM4OktPVXJMR7R
	 FPanUJlZsMU0605LW6vxe6KQFw+LO0J9vl7FrlBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Keith Busch <kbusch@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Delva <adelva@google.com>
Subject: [PATCH 6.12 178/322] kvm: retry nx_huge_page_recovery_thread creation
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826110920.258061084@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

commit 916b7f42b3b3b539a71c204a9b49fdc4ca92cd82 upstream.

A VMM may send a non-fatal signal to its threads, including vCPU tasks,
at any time, and thus may signal vCPU tasks during KVM_RUN.  If a vCPU
task receives the signal while its trying to spawn the huge page recovery
vhost task, then KVM_RUN will fail due to copy_process() returning
-ERESTARTNOINTR.

Rework call_once() to mark the call complete if and only if the called
function succeeds, and plumb the function's true error code back to the
call_once() invoker.  This provides userspace with the correct, non-fatal
error code so that the VMM doesn't terminate the VM on -ENOMEM, and allows
subsequent KVM_RUN a succeed by virtue of retrying creation of the NX huge
page task.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
[implemented the kvm user side]
Signed-off-by: Keith Busch <kbusch@kernel.org>
Message-ID: <20250227230631.303431-3-kbusch@meta.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alistair Delva <adelva@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c    |   10 ++++------
 include/linux/call_once.h |   43 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7578,7 +7578,7 @@ static bool kvm_nx_huge_page_recovery_wo
 	return true;
 }
 
-static void kvm_mmu_start_lpage_recovery(struct once *once)
+static int kvm_mmu_start_lpage_recovery(struct once *once)
 {
 	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
 	struct kvm *kvm = container_of(ka, struct kvm, arch);
@@ -7590,12 +7590,13 @@ static void kvm_mmu_start_lpage_recovery
 				      kvm, "kvm-nx-lpage-recovery");
 
 	if (IS_ERR(nx_thread))
-		return;
+		return PTR_ERR(nx_thread);
 
 	vhost_task_start(nx_thread);
 
 	/* Make the task visible only once it is fully started. */
 	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
+	return 0;
 }
 
 int kvm_mmu_post_init_vm(struct kvm *kvm)
@@ -7603,10 +7604,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
 
-	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
-	if (!kvm->arch.nx_huge_page_recovery_thread)
-		return -ENOMEM;
-	return 0;
+	return call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 }
 
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
--- a/include/linux/call_once.h
+++ b/include/linux/call_once.h
@@ -26,20 +26,41 @@ do {									\
 	__once_init((once), #once, &__key);				\
 } while (0)
 
-static inline void call_once(struct once *once, void (*cb)(struct once *))
+/*
+ * call_once - Ensure a function has been called exactly once
+ *
+ * @once: Tracking struct
+ * @cb: Function to be called
+ *
+ * If @once has never completed successfully before, call @cb and, if
+ * it returns a zero or positive value, mark @once as completed.  Return
+ * the value returned by @cb
+ *
+ * If @once has completed succesfully before, return 0.
+ *
+ * The call to @cb is implicitly surrounded by a mutex, though for
+ * efficiency the * function avoids taking it after the first call.
+ */
+static inline int call_once(struct once *once, int (*cb)(struct once *))
 {
-        /* Pairs with atomic_set_release() below.  */
-        if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
-                return;
+	int r, state;
 
-        guard(mutex)(&once->lock);
-        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
-        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
-                return;
+	/* Pairs with atomic_set_release() below.  */
+	if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
+		return 0;
 
-        atomic_set(&once->state, ONCE_RUNNING);
-        cb(once);
-        atomic_set_release(&once->state, ONCE_COMPLETED);
+	guard(mutex)(&once->lock);
+	state = atomic_read(&once->state);
+	if (unlikely(state != ONCE_NOT_STARTED))
+		return WARN_ON_ONCE(state != ONCE_COMPLETED) ? -EINVAL : 0;
+
+	atomic_set(&once->state, ONCE_RUNNING);
+	r = cb(once);
+	if (r < 0)
+		atomic_set(&once->state, ONCE_NOT_STARTED);
+	else
+		atomic_set_release(&once->state, ONCE_COMPLETED);
+	return r;
 }
 
 #endif /* _LINUX_CALL_ONCE_H */


