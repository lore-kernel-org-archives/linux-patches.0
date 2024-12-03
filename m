Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751721F8913;
	Tue,  3 Dec 2024 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242214; cv=none; b=Zrb6zcJn4juuvKwDmW0JV/Bgb1Ce0KRriRDX8v9XBIKlvF+5xzzYMYFkRZeHS56hO9yLtOW+nwCsYyh9drBLSue7eQqfGiv+IjrGgxjTlTosyCP6+3fflpUPXvnPN/idM/xyTdWMHeEEHuIhCDbT6mZO0eu/Hl4X0Ur6QFVdIBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242214; c=relaxed/simple;
	bh=i6K0ZAIAKWTxoM9kM68WeFRrl02/8Eq6E3pIm3QXYIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4dZ+pqQiSz0nMbBWdTvMsq97KTkLPyoCMlauk+gkK2hT4yy3MbBaZrTu1iH576xjP3f1D6t4ctjWQyvfMsUYyx/2xUTUdJ68i4NCumzhJ2aTvJKjrv9ERAty3fwy7X/NuCVHq1Vwjwa6jgWAFxkcI6TMPujgqSLSDgVl9QzNEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veGx6I78; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veGx6I78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BC1C4CED6;
	Tue,  3 Dec 2024 16:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242214;
	bh=i6K0ZAIAKWTxoM9kM68WeFRrl02/8Eq6E3pIm3QXYIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veGx6I78nBDYsDr6Tnfmq3ngETel94gtei54ggA9MiFxAMGYoRy4Pxoz3Sv5c8UfH
	 7J2tFwccZkc1LVoRMJKAiVoiHCMmMk41H65NpJEoc4dOi3P5HKXoYb0S2YUFz10yh6
	 NjM0sfuwib/I2v+LzyyMpWj8VyRdMMJENvpSwp74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 640/826] KVM: x86: switch hugepage recovery thread to vhost_task
Date: Tue,  3 Dec 2024 15:46:07 +0100
Message-ID: <20241203144808.716802723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit d96c77bd4eeba469bddbbb14323d2191684da82a upstream.

kvm_vm_create_worker_thread() is meant to be used for kthreads that
can consume significant amounts of CPU time on behalf of a VM or in
response to how the VM behaves (for example how it accesses its memory).
Therefore it wants to charge the CPU time consumed by that work to
the VM's container.

However, because of these threads, cgroups which have kvm instances
inside never complete freezing.  This can be trivially reproduced:

  root@test ~# mkdir /sys/fs/cgroup/test
  root@test ~# echo $$ > /sys/fs/cgroup/test/cgroup.procs
  root@test ~# qemu-system-x86_64 -nographic -enable-kvm

and in another terminal:

  root@test ~# echo 1 > /sys/fs/cgroup/test/cgroup.freeze
  root@test ~# cat /sys/fs/cgroup/test/cgroup.events
  populated 1
  frozen 0

The cgroup freezing happens in the signal delivery path but
kvm_nx_huge_page_recovery_worker, while joining non-root cgroups, never
calls into the signal delivery path and thus never gets frozen. Because
the cgroup freezer determines whether a given cgroup is frozen by
comparing the number of frozen threads to the total number of threads
in the cgroup, the cgroup never becomes frozen and users waiting for
the state transition may hang indefinitely.

Since the worker kthread is tied to a user process, it's better if
it behaves similarly to user tasks as much as possible, including
being able to send SIGSTOP and SIGCONT.  In fact, vhost_task is all
that kvm_vm_create_worker_thread() wanted to be and more: not only it
inherits the userspace process's cgroups, it has other niceties like
being parented properly in the process tree.  Use it instead of the
homegrown alternative.

Incidentally, the new code is also better behaved when you flip recovery
back and forth to disabled and back to enabled.  If your recovery period
is 1 minute, it will run the next recovery after 1 minute independent
of how many times you flipped the parameter.

(Commit message based on emails from Tejun).

Reported-by: Tejun Heo <tj@kernel.org>
Reported-by: Luca Boccassi <bluca@debian.org>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Luca Boccassi <bluca@debian.org>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    4 +
 arch/x86/kvm/Kconfig            |    1 
 arch/x86/kvm/mmu/mmu.c          |   68 ++++++++++++--------------
 include/linux/kvm_host.h        |    6 --
 virt/kvm/kvm_main.c             |  103 ----------------------------------------
 5 files changed, 35 insertions(+), 147 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
 #include <linux/kfifo.h>
+#include <linux/sched/vhost_task.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -1443,7 +1444,8 @@ struct kvm_arch {
 	bool sgx_provisioning_allowed;
 
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
-	struct task_struct *nx_huge_page_recovery_thread;
+	struct vhost_task *nx_huge_page_recovery_thread;
+	u64 nx_huge_page_last;
 
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM_X86
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_READONLY_MEM
+	select VHOST_TASK
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7281,7 +7281,7 @@ static int set_nx_huge_pages(const char
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
+			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7427,7 +7427,7 @@ static int set_nx_huge_pages_recovery_pa
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
+			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7530,62 +7530,56 @@ static void kvm_recover_nx_huge_pages(st
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static long get_nx_huge_page_recovery_timeout(u64 start_time)
+static void kvm_nx_huge_page_recovery_worker_kill(void *data)
 {
-	bool enabled;
-	uint period;
-
-	enabled = calc_nx_huge_pages_recovery_period(&period);
-
-	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
-		       : MAX_SCHEDULE_TIMEOUT;
 }
 
-static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
+static bool kvm_nx_huge_page_recovery_worker(void *data)
 {
-	u64 start_time;
+	struct kvm *kvm = data;
+	bool enabled;
+	uint period;
 	long remaining_time;
 
-	while (true) {
-		start_time = get_jiffies_64();
-		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		while (!kthread_should_stop() && remaining_time > 0) {
-			schedule_timeout(remaining_time);
-			remaining_time = get_nx_huge_page_recovery_timeout(start_time);
-			set_current_state(TASK_INTERRUPTIBLE);
-		}
-
-		set_current_state(TASK_RUNNING);
-
-		if (kthread_should_stop())
-			return 0;
+	enabled = calc_nx_huge_pages_recovery_period(&period);
+	if (!enabled)
+		return false;
 
-		kvm_recover_nx_huge_pages(kvm);
+	remaining_time = kvm->arch.nx_huge_page_last + msecs_to_jiffies(period)
+		- get_jiffies_64();
+	if (remaining_time > 0) {
+		schedule_timeout(remaining_time);
+		/* check for signals and come back */
+		return true;
 	}
+
+	__set_current_state(TASK_RUNNING);
+	kvm_recover_nx_huge_pages(kvm);
+	kvm->arch.nx_huge_page_last = get_jiffies_64();
+	return true;
 }
 
 int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
-	int err;
-
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
 
-	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
-					  "kvm-nx-lpage-recovery",
-					  &kvm->arch.nx_huge_page_recovery_thread);
-	if (!err)
-		kthread_unpark(kvm->arch.nx_huge_page_recovery_thread);
+	kvm->arch.nx_huge_page_last = get_jiffies_64();
+	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
+		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
+		kvm, "kvm-nx-lpage-recovery");
 
-	return err;
+	if (!kvm->arch.nx_huge_page_recovery_thread)
+		return -ENOMEM;
+
+	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+	return 0;
 }
 
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
 	if (kvm->arch.nx_huge_page_recovery_thread)
-		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
+		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2382,12 +2382,6 @@ static inline int kvm_arch_vcpu_run_pid_
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
 
-typedef int (*kvm_vm_thread_fn_t)(struct kvm *kvm, uintptr_t data);
-
-int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
-				uintptr_t data, const char *name,
-				struct task_struct **thread_ptr);
-
 #ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
 static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 {
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6561,106 +6561,3 @@ void kvm_exit(void)
 	kvm_irqfd_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-
-struct kvm_vm_worker_thread_context {
-	struct kvm *kvm;
-	struct task_struct *parent;
-	struct completion init_done;
-	kvm_vm_thread_fn_t thread_fn;
-	uintptr_t data;
-	int err;
-};
-
-static int kvm_vm_worker_thread(void *context)
-{
-	/*
-	 * The init_context is allocated on the stack of the parent thread, so
-	 * we have to locally copy anything that is needed beyond initialization
-	 */
-	struct kvm_vm_worker_thread_context *init_context = context;
-	struct task_struct *parent;
-	struct kvm *kvm = init_context->kvm;
-	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
-	uintptr_t data = init_context->data;
-	int err;
-
-	err = kthread_park(current);
-	/* kthread_park(current) is never supposed to return an error */
-	WARN_ON(err != 0);
-	if (err)
-		goto init_complete;
-
-	err = cgroup_attach_task_all(init_context->parent, current);
-	if (err) {
-		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
-			__func__, err);
-		goto init_complete;
-	}
-
-	set_user_nice(current, task_nice(init_context->parent));
-
-init_complete:
-	init_context->err = err;
-	complete(&init_context->init_done);
-	init_context = NULL;
-
-	if (err)
-		goto out;
-
-	/* Wait to be woken up by the spawner before proceeding. */
-	kthread_parkme();
-
-	if (!kthread_should_stop())
-		err = thread_fn(kvm, data);
-
-out:
-	/*
-	 * Move kthread back to its original cgroup to prevent it lingering in
-	 * the cgroup of the VM process, after the latter finishes its
-	 * execution.
-	 *
-	 * kthread_stop() waits on the 'exited' completion condition which is
-	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
-	 * kthread is removed from the cgroup in the cgroup_exit() which is
-	 * called after the exit_mm(). This causes the kthread_stop() to return
-	 * before the kthread actually quits the cgroup.
-	 */
-	rcu_read_lock();
-	parent = rcu_dereference(current->real_parent);
-	get_task_struct(parent);
-	rcu_read_unlock();
-	cgroup_attach_task_all(parent, current);
-	put_task_struct(parent);
-
-	return err;
-}
-
-int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
-				uintptr_t data, const char *name,
-				struct task_struct **thread_ptr)
-{
-	struct kvm_vm_worker_thread_context init_context = {};
-	struct task_struct *thread;
-
-	*thread_ptr = NULL;
-	init_context.kvm = kvm;
-	init_context.parent = current;
-	init_context.thread_fn = thread_fn;
-	init_context.data = data;
-	init_completion(&init_context.init_done);
-
-	thread = kthread_run(kvm_vm_worker_thread, &init_context,
-			     "%s-%d", name, task_pid_nr(current));
-	if (IS_ERR(thread))
-		return PTR_ERR(thread);
-
-	/* kthread_run is never supposed to return NULL */
-	WARN_ON(thread == NULL);
-
-	wait_for_completion(&init_context.init_done);
-
-	if (!init_context.err)
-		*thread_ptr = thread;
-
-	return init_context.err;
-}


