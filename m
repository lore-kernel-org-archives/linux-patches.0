Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D00326B0BA;
	Thu, 13 Feb 2025 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459165; cv=none; b=ldVkHLPxH/ui9ZUrSlIyVgRUAEWZqqi2Twgksi6+JoPsDzH0xo86hol0rL0/v2s9o+Kb8e3QyWLmU0DxEt/nccm4BQoo6Q53L7rjaZeS9R4z0aqZ4stQd3qe2f2UB6kB/K4BwgTxYeP5l1/1CMrzRg1j62YouTH6F8Yy77ppDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459165; c=relaxed/simple;
	bh=biYTaYFh9t1FKHe9RZ5U+1N0gCfkc0xlBYFUdcOEehw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb/eVbiU4TXwCC3ed4cgyGFfeg6WcgtILLsQFsjgzbHbbqJrjTvJ3xrHtjydQzG2blY0qTo5lgtwwBnIK9OLKeLEXX1AVAsdb/aGj9q1FRDH4l0N2Qv2x5/5nbua5WlFKVQks+gk/iqhu9TCaUBI7rArH/1yc+W3GKAtywj4HRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKZnwTA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKZnwTA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947C9C4CED1;
	Thu, 13 Feb 2025 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459165;
	bh=biYTaYFh9t1FKHe9RZ5U+1N0gCfkc0xlBYFUdcOEehw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKZnwTA89x1ojSuLKQHKlrJeM40Im+oXWWbxpcGOjKEz5EeS2iYWxzW02mzi8jt9r
	 orstJS75iMbQeSoub8b6RKj0wZNyPcL7cayH1Oo8b5yEalq5sgaz+v9bUS0ElyDqBQ
	 pPgYVjUaeT48iPl5luRSaRwG/vyiP/Z8HHotrGgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alyssa Ross <hi@alyssa.is>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.13 170/443] kvm: defer huge page recovery vhost task to later
Date: Thu, 13 Feb 2025 15:25:35 +0100
Message-ID: <20250213142447.163954450@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 931656b9e2ff7029aee0b36e17780621948a6ac1 upstream.

Some libraries want to ensure they are single threaded before forking,
so making the kernel's kvm huge page recovery process a vhost task of
the user process breaks those. The minijail library used by crosvm is
one such affected application.

Defer the task to after the first VM_RUN call, which occurs after the
parent process has forked all its jailed processes. This needs to happen
only once for the kvm instance, so introduce some general-purpose
infrastructure for that, too.  It's similar in concept to pthread_once;
except it is actually usable, because the callback takes a parameter.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Message-ID: <20250123153543.2769928-1-kbusch@meta.com>
[Move call_once API to include/linux. - Paolo]
Cc: stable@vger.kernel.org
Fixes: d96c77bd4eeb ("KVM: x86: switch hugepage recovery thread to vhost_task")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu/mmu.c          |   18 +++++++++++-----
 arch/x86/kvm/x86.c              |    7 +++++-
 include/linux/call_once.h       |   45 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/call_once.h

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <linux/hyperv.h>
 #include <linux/kfifo.h>
 #include <linux/sched/vhost_task.h>
+#include <linux/call_once.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -1445,6 +1446,7 @@ struct kvm_arch {
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct vhost_task *nx_huge_page_recovery_thread;
 	u64 nx_huge_page_last;
+	struct once nx_once;
 
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7411,20 +7411,28 @@ static bool kvm_nx_huge_page_recovery_wo
 	return true;
 }
 
-int kvm_mmu_post_init_vm(struct kvm *kvm)
+static void kvm_mmu_start_lpage_recovery(struct once *once)
 {
-	if (nx_hugepage_mitigation_hard_disabled)
-		return 0;
+	struct kvm_arch *ka = container_of(once, struct kvm_arch, nx_once);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
 
 	kvm->arch.nx_huge_page_last = get_jiffies_64();
 	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
 		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
 		kvm, "kvm-nx-lpage-recovery");
 
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+}
+
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
+	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 	if (!kvm->arch.nx_huge_page_recovery_thread)
 		return -ENOMEM;
-
-	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
 	return 0;
 }
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 	struct kvm_run *kvm_run = vcpu->run;
 	int r;
 
+	r = kvm_mmu_post_init_vm(vcpu->kvm);
+	if (r)
+		return r;
+
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
@@ -12742,7 +12746,8 @@ out:
 
 int kvm_arch_post_init_vm(struct kvm *kvm)
 {
-	return kvm_mmu_post_init_vm(kvm);
+	once_init(&kvm->arch.nx_once);
+	return 0;
 }
 
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
--- /dev/null
+++ b/include/linux/call_once.h
@@ -0,0 +1,45 @@
+#ifndef _LINUX_CALL_ONCE_H
+#define _LINUX_CALL_ONCE_H
+
+#include <linux/types.h>
+#include <linux/mutex.h>
+
+#define ONCE_NOT_STARTED 0
+#define ONCE_RUNNING     1
+#define ONCE_COMPLETED   2
+
+struct once {
+        atomic_t state;
+        struct mutex lock;
+};
+
+static inline void __once_init(struct once *once, const char *name,
+			       struct lock_class_key *key)
+{
+        atomic_set(&once->state, ONCE_NOT_STARTED);
+        __mutex_init(&once->lock, name, key);
+}
+
+#define once_init(once)							\
+do {									\
+	static struct lock_class_key __key;				\
+	__once_init((once), #once, &__key);				\
+} while (0)
+
+static inline void call_once(struct once *once, void (*cb)(struct once *))
+{
+        /* Pairs with atomic_set_release() below.  */
+        if (atomic_read_acquire(&once->state) == ONCE_COMPLETED)
+                return;
+
+        guard(mutex)(&once->lock);
+        WARN_ON(atomic_read(&once->state) == ONCE_RUNNING);
+        if (atomic_read(&once->state) != ONCE_NOT_STARTED)
+                return;
+
+        atomic_set(&once->state, ONCE_RUNNING);
+        cb(once);
+        atomic_set_release(&once->state, ONCE_COMPLETED);
+}
+
+#endif /* _LINUX_CALL_ONCE_H */


