Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A45B1D0BA4;
	Wed,  2 Oct 2024 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880302; cv=none; b=nhSgaUsCkyZbKBo0v0xHPgbqz0qHQuXxb3NMLC50zHLWfhb/f9neTV7DqhXzE9AW4Q2u+Pl0Js8mgBNYFrhfhCicJ5E/MTLO/pzMktZQ/Ofbw11tQnPw4ZXUUasfy8oDVXBG69F4QG4N5+D55SBzWFGTP1bDaACesdprZ+wgFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880302; c=relaxed/simple;
	bh=1oqy7Qt0y+JnXKQeQ8hRn60Mx4kEJfqhgVFut39oek4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTjK+g3g7X1isW5B/L7VX5FDkKJ9S9F876ptJSL7fC3gc6WSk6JgZhoaRc17y+0q9qtxTOwLGLFwjlTX3yLZxUypXbzwlDOIagk79Vrwf2QXJBDbTRPHR98ddJtbKJRJEwBa9ZIsGpEgB7Efksmd3Hm/babaYPKG/UI3cAhhvZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH0UHwXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH0UHwXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832D3C4CEC2;
	Wed,  2 Oct 2024 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880301;
	bh=1oqy7Qt0y+JnXKQeQ8hRn60Mx4kEJfqhgVFut39oek4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH0UHwXF8ZmT3+885l3GbotyLFiP7z04cPca2r/0kCswNdop23c0WyHdIccEuBPbR
	 z9GOopBcrL+Rr812nc2oabZakdT/rwLo6MA9QXvoP1SUH+ROO7PlRnuXblNY8Nchmz
	 bXYfU9yMhP40uQfdQ6PnWY37YSCipn/UC+BRD6yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 413/538] KVM: Use dedicated mutex to protect kvm_usage_count to avoid deadlock
Date: Wed,  2 Oct 2024 15:00:52 +0200
Message-ID: <20241002125808.735564062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 44d17459626052a2390457e550a12cb973506b2f upstream.

Use a dedicated mutex to guard kvm_usage_count to fix a potential deadlock
on x86 due to a chain of locks and SRCU synchronizations.  Translating the
below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wait on
CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due to the
fairness of r/w semaphores).

    CPU0                     CPU1                     CPU2
1   lock(&kvm->slots_lock);
2                                                     lock(&vcpu->mutex);
3                                                     lock(&kvm->srcu);
4                            lock(cpu_hotplug_lock);
5                            lock(kvm_lock);
6                            lock(&kvm->slots_lock);
7                                                     lock(cpu_hotplug_lock);
8   sync(&kvm->srcu);

Note, there are likely more potential deadlocks in KVM x86, e.g. the same
pattern of taking cpu_hotplug_lock outside of kvm_lock likely exists with
__kvmclock_cpufreq_notifier():

  cpuhp_cpufreq_online()
  |
  -> cpufreq_online()
     |
     -> cpufreq_gov_performance_limits()
        |
        -> __cpufreq_driver_target()
           |
           -> __target_index()
              |
              -> cpufreq_freq_transition_begin()
                 |
                 -> cpufreq_notify_transition()
                    |
                    -> ... __kvmclock_cpufreq_notifier()

But, actually triggering such deadlocks is beyond rare due to the
combination of dependencies and timings involved.  E.g. the cpufreq
notifier is only used on older CPUs without a constant TSC, mucking with
the NX hugepage mitigation while VMs are running is very uncommon, and
doing so while also onlining/offlining a CPU (necessary to generate
contention on cpu_hotplug_lock) would be even more unusual.

The most robust solution to the general cpu_hotplug_lock issue is likely
to switch vm_list to be an RCU-protected list, e.g. so that x86's cpufreq
notifier doesn't to take kvm_lock.  For now, settle for fixing the most
blatant deadlock, as switching to an RCU-protected list is a much more
involved change, but add a comment in locking.rst to call out that care
needs to be taken when walking holding kvm_lock and walking vm_list.

  ======================================================
  WARNING: possible circular locking dependency detected
  6.10.0-smp--c257535a0c9d-pip #330 Tainted: G S         O
  ------------------------------------------------------
  tee/35048 is trying to acquire lock:
  ff6a80eced71e0a8 (&kvm->slots_lock){+.+.}-{3:3}, at: set_nx_huge_pages+0x179/0x1e0 [kvm]

  but task is already holding lock:
  ffffffffc07abb08 (kvm_lock){+.+.}-{3:3}, at: set_nx_huge_pages+0x14a/0x1e0 [kvm]

  which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

  -> #3 (kvm_lock){+.+.}-{3:3}:
         __mutex_lock+0x6a/0xb40
         mutex_lock_nested+0x1f/0x30
         kvm_dev_ioctl+0x4fb/0xe50 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #2 (cpu_hotplug_lock){++++}-{0:0}:
         cpus_read_lock+0x2e/0xb0
         static_key_slow_inc+0x16/0x30
         kvm_lapic_set_base+0x6a/0x1c0 [kvm]
         kvm_set_apic_base+0x8f/0xe0 [kvm]
         kvm_set_msr_common+0x9ae/0xf80 [kvm]
         vmx_set_msr+0xa54/0xbe0 [kvm_intel]
         __kvm_set_msr+0xb6/0x1a0 [kvm]
         kvm_arch_vcpu_ioctl+0xeca/0x10c0 [kvm]
         kvm_vcpu_ioctl+0x485/0x5b0 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #1 (&kvm->srcu){.+.+}-{0:0}:
         __synchronize_srcu+0x44/0x1a0
         synchronize_srcu_expedited+0x21/0x30
         kvm_swap_active_memslots+0x110/0x1c0 [kvm]
         kvm_set_memslot+0x360/0x620 [kvm]
         __kvm_set_memory_region+0x27b/0x300 [kvm]
         kvm_vm_ioctl_set_memory_region+0x43/0x60 [kvm]
         kvm_vm_ioctl+0x295/0x650 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #0 (&kvm->slots_lock){+.+.}-{3:3}:
         __lock_acquire+0x15ef/0x2e30
         lock_acquire+0xe0/0x260
         __mutex_lock+0x6a/0xb40
         mutex_lock_nested+0x1f/0x30
         set_nx_huge_pages+0x179/0x1e0 [kvm]
         param_attr_store+0x93/0x100
         module_attr_store+0x22/0x40
         sysfs_kf_write+0x81/0xb0
         kernfs_fop_write_iter+0x133/0x1d0
         vfs_write+0x28d/0x380
         ksys_write+0x70/0xe0
         __x64_sys_write+0x1f/0x30
         x64_sys_call+0x281b/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

Cc: Chao Gao <chao.gao@intel.com>
Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20240830043600.127750-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/locking.rst |   32 +++++++++++++++++++++++---------
 virt/kvm/kvm_main.c                |   31 ++++++++++++++++---------------
 2 files changed, 39 insertions(+), 24 deletions(-)

--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -9,7 +9,7 @@ KVM Lock Overview
 
 The acquisition orders for mutexes are as follows:
 
-- cpus_read_lock() is taken outside kvm_lock
+- cpus_read_lock() is taken outside kvm_lock and kvm_usage_lock
 
 - kvm->lock is taken outside vcpu->mutex
 
@@ -24,6 +24,12 @@ The acquisition orders for mutexes are a
   are taken on the waiting side when modifying memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
+cpus_read_lock() vs kvm_lock:
+- Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
+  being the official ordering, as it is quite easy to unknowingly trigger
+  cpus_read_lock() while holding kvm_lock.  Use caution when walking vm_list,
+  e.g. avoid complex operations when possible.
+
 For SRCU:
 
 - ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
@@ -228,10 +234,17 @@ time it will be set using the Dirty trac
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-		- kvm_usage_count
+
+``kvm_usage_lock``
+^^^^^^^^^^^^^^^^^^
+
+:Type:		mutex
+:Arch:		any
+:Protects:	- kvm_usage_count
 		- hardware virtualization enable/disable
-:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
-		enable/disable.
+:Comment:	Exists because using kvm_lock leads to deadlock (see earlier comment
+		on cpus_read_lock() vs kvm_lock).  Note, KVM also disables CPU hotplug via
+		cpus_read_lock() when enabling/disabling virtualization.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
@@ -291,11 +304,12 @@ time it will be set using the Dirty trac
 		wakeup.
 
 ``vendor_module_lock``
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+^^^^^^^^^^^^^^^^^^^^^^
 :Type:		mutex
 :Arch:		x86
 :Protects:	loading a vendor module (kvm_amd or kvm_intel)
-:Comment:	Exists because using kvm_lock leads to deadlock.  cpu_hotplug_lock is
-    taken outside of kvm_lock, e.g. in KVM's CPU online/offline callbacks, and
-    many operations need to take cpu_hotplug_lock when loading a vendor module,
-    e.g. updating static calls.
+:Comment:	Exists because using kvm_lock leads to deadlock.  kvm_lock is taken
+    in notifiers, e.g. __kvmclock_cpufreq_notifier(), that may be invoked while
+    cpu_hotplug_lock is held, e.g. from cpufreq_boost_trigger_state(), and many
+    operations need to take cpu_hotplug_lock when loading a vendor module, e.g.
+    updating static calls.
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5174,6 +5174,7 @@ __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
+static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
 static int __hardware_enable_nolock(void)
@@ -5206,10 +5207,10 @@ static int kvm_online_cpu(unsigned int c
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	if (kvm_usage_count)
 		ret = __hardware_enable_nolock();
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	return ret;
 }
 
@@ -5229,10 +5230,10 @@ static void hardware_disable_nolock(void
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	return 0;
 }
 
@@ -5248,9 +5249,9 @@ static void hardware_disable_all_nolock(
 static void hardware_disable_all(void)
 {
 	cpus_read_lock();
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	cpus_read_unlock();
 }
 
@@ -5281,7 +5282,7 @@ static int hardware_enable_all(void)
 	 * enable hardware multiple times.
 	 */
 	cpus_read_lock();
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 
 	r = 0;
 
@@ -5295,7 +5296,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5323,13 +5324,13 @@ static int kvm_suspend(void)
 {
 	/*
 	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
+	 * callbacks, i.e. no need to acquire kvm_usage_lock to ensure the usage
+	 * count is stable.  Assert that kvm_usage_lock is not held to ensure
+	 * the system isn't suspended while KVM is enabling hardware.  Hardware
+	 * enabling can be preempted, but the task cannot be frozen until it has
+	 * dropped all locks (userspace tasks are frozen via a fake signal).
 	 */
-	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
@@ -5339,7 +5340,7 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)


