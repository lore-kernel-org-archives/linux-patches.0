Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1150C13AA5F;
	Fri,  6 Dec 2024 15:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498087; cv=none; b=mh5dot3wnC4PUQBWVtfziGtM5hxbBO7WaB9gH81f8xEJJCY7lMD3qq/wEjytnoU7rfZAaT51FOFZfxTWWXK47WnWinw6/A6DAoxRBBsslD6AHxBR37HIb+mUKAWEARIo9UXa16Lg+efjsIDW2zoxtsfRdvlakwRu5775ypyz12M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498087; c=relaxed/simple;
	bh=2mI3+2QjBqGNuB/fG5vta9S9jfABsjULoQvC+BFmsQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ+HqVhWVqru+5bAy5LEAvtSCpfgGe2Ir9lcR6wBOYfq6tB/jihZEs43YaOpFUTgDo9P15MWgZVCJCx/dZDaXHWM1b+Ierr0XedNTjGvcSf42K5FgkCh+eVZSMbbiolrWkp8DUL8X9XD1xeJC6bBzxsWeHXQq3U0BNK7CMfTJEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehejB4wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehejB4wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756DEC4CED1;
	Fri,  6 Dec 2024 15:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498086;
	bh=2mI3+2QjBqGNuB/fG5vta9S9jfABsjULoQvC+BFmsQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehejB4wtA+eCYYN8w8hiTJQ9mWyqhUK3740pHpjKA8BPwkBNvaysjJ3wL19ZyMtoy
	 CJS0rKZQdm3zwd4SrZH+unqEXrshpsceksnsKoP6W+2fm0D1nz6WU4ZFfhb5b7WEt6
	 p5xFCajK3OpivoFuT9OtWgYYhTV8+1RbzadDEd3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 481/676] KVM: arm64: Get rid of userspace_irqchip_in_use
Date: Fri,  6 Dec 2024 15:35:00 +0100
Message-ID: <20241206143712.149320914@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Raghavendra Rao Ananta <rananta@google.com>

commit 38d7aacca09230fdb98a34194fec2af597e8e20d upstream.

Improper use of userspace_irqchip_in_use led to syzbot hitting the
following WARN_ON() in kvm_timer_update_irq():

WARNING: CPU: 0 PID: 3281 at arch/arm64/kvm/arch_timer.c:459
kvm_timer_update_irq+0x21c/0x394
Call trace:
  kvm_timer_update_irq+0x21c/0x394 arch/arm64/kvm/arch_timer.c:459
  kvm_timer_vcpu_reset+0x158/0x684 arch/arm64/kvm/arch_timer.c:968
  kvm_reset_vcpu+0x3b4/0x560 arch/arm64/kvm/reset.c:264
  kvm_vcpu_set_target arch/arm64/kvm/arm.c:1553 [inline]
  kvm_arch_vcpu_ioctl_vcpu_init arch/arm64/kvm/arm.c:1573 [inline]
  kvm_arch_vcpu_ioctl+0x112c/0x1b3c arch/arm64/kvm/arm.c:1695
  kvm_vcpu_ioctl+0x4ec/0xf74 virt/kvm/kvm_main.c:4658
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl fs/ioctl.c:893 [inline]
  __arm64_sys_ioctl+0x108/0x184 fs/ioctl.c:893
  __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
  invoke_syscall+0x78/0x1b8 arch/arm64/kernel/syscall.c:49
  el0_svc_common+0xe8/0x1b0 arch/arm64/kernel/syscall.c:132
  do_el0_svc+0x40/0x50 arch/arm64/kernel/syscall.c:151
  el0_svc+0x54/0x14c arch/arm64/kernel/entry-common.c:712
  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The following sequence led to the scenario:
 - Userspace creates a VM and a vCPU.
 - The vCPU is initialized with KVM_ARM_VCPU_PMU_V3 during
   KVM_ARM_VCPU_INIT.
 - Without any other setup, such as vGIC or vPMU, userspace issues
   KVM_RUN on the vCPU. Since the vPMU is requested, but not setup,
   kvm_arm_pmu_v3_enable() fails in kvm_arch_vcpu_run_pid_change().
   As a result, KVM_RUN returns after enabling the timer, but before
   incrementing 'userspace_irqchip_in_use':
   kvm_arch_vcpu_run_pid_change()
       ret = kvm_arm_pmu_v3_enable()
           if (!vcpu->arch.pmu.created)
               return -EINVAL;
       if (ret)
           return ret;
       [...]
       if (!irqchip_in_kernel(kvm))
           static_branch_inc(&userspace_irqchip_in_use);
 - Userspace ignores the error and issues KVM_ARM_VCPU_INIT again.
   Since the timer is already enabled, control moves through the
   following flow, ultimately hitting the WARN_ON():
   kvm_timer_vcpu_reset()
       if (timer->enabled)
          kvm_timer_update_irq()
              if (!userspace_irqchip())
                  ret = kvm_vgic_inject_irq()
                      ret = vgic_lazy_init()
                          if (unlikely(!vgic_initialized(kvm)))
                              if (kvm->arch.vgic.vgic_model !=
                                  KVM_DEV_TYPE_ARM_VGIC_V2)
                                      return -EBUSY;
                  WARN_ON(ret);

Theoretically, since userspace_irqchip_in_use's functionality can be
simply replaced by '!irqchip_in_kernel()', get rid of the static key
to avoid the mismanagement, which also helps with the syzbot issue.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    2 --
 arch/arm64/kvm/arch_timer.c       |    3 +--
 arch/arm64/kvm/arm.c              |   18 +++---------------
 3 files changed, 4 insertions(+), 19 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -72,8 +72,6 @@ enum kvm_mode kvm_get_mode(void);
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 #endif
 
-DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
-
 extern unsigned int __ro_after_init kvm_sve_max_vl;
 int __init kvm_arm_init_sve(void);
 
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -206,8 +206,7 @@ void get_timer_map(struct kvm_vcpu *vcpu
 
 static inline bool userspace_irqchip(struct kvm *kvm)
 {
-	return static_branch_unlikely(&userspace_irqchip_in_use) &&
-		unlikely(!irqchip_in_kernel(kvm));
+	return unlikely(!irqchip_in_kernel(kvm));
 }
 
 static void soft_timer_start(struct hrtimer *hrt, u64 ns)
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -57,7 +57,6 @@ DECLARE_KVM_NVHE_PER_CPU(struct kvm_cpu_
 static bool vgic_present, kvm_arm_initialised;
 
 static DEFINE_PER_CPU(unsigned char, kvm_hyp_initialized);
-DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 bool is_kvm_arm_initialised(void)
 {
@@ -401,9 +400,6 @@ void kvm_arch_vcpu_postcreate(struct kvm
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		static_branch_dec(&userspace_irqchip_in_use);
-
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
@@ -627,14 +623,6 @@ int kvm_arch_vcpu_run_pid_change(struct
 			return ret;
 	}
 
-	if (!irqchip_in_kernel(kvm)) {
-		/*
-		 * Tell the rest of the code that there are userspace irqchip
-		 * VMs in the wild.
-		 */
-		static_branch_inc(&userspace_irqchip_in_use);
-	}
-
 	/*
 	 * Initialize traps for protected VMs.
 	 * NOTE: Move to run in EL2 directly, rather than via a hypercall, once
@@ -856,7 +844,7 @@ static bool kvm_vcpu_exit_request(struct
 	 * state gets updated in kvm_timer_update_run and
 	 * kvm_pmu_update_run below).
 	 */
-	if (static_branch_unlikely(&userspace_irqchip_in_use)) {
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
 		if (kvm_timer_should_notify_user(vcpu) ||
 		    kvm_pmu_should_notify_user(vcpu)) {
 			*ret = -EINTR;
@@ -975,7 +963,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
-			if (static_branch_unlikely(&userspace_irqchip_in_use))
+			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			local_irq_enable();
@@ -1021,7 +1009,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		 * we don't want vtimer interrupts to race with syncing the
 		 * timer virtual interrupt state.
 		 */
-		if (static_branch_unlikely(&userspace_irqchip_in_use))
+		if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 			kvm_timer_sync_user(vcpu);
 
 		kvm_arch_vcpu_ctxsync_fp(vcpu);


