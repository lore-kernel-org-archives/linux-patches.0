Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E7B2512D6;
	Wed,  5 Mar 2025 18:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198171; cv=none; b=L85KXixzJPzdNA9NjYop+WIz+4Ex9mTfA/ebMC4JQm7N5V46DQACppExJmTzHUhKLqABfIVzI1Kf+OnW2na9QiY29tkI64+0c7/YOXwarvXscyMq9GZwbNtrSAs8SKpFl6IPsKOWznE/O4mHpIfIfbYEu2NkWu88AFVhN0XMSXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198171; c=relaxed/simple;
	bh=vFKhiTn4PG/Xkvt4lpQznJ5KLahtMBho8I0OF4CE1hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twonOZwGAEu/uBs4yR50vryR7rXLJiR6AI7T8f/E2AbOvbir5SbJI+nXU/NlbjN8KDuiyy9XfFUcUX/OiAj3ZmCr4tUhiET24CCE9Btl10P5CpnRVl5BPUYrsLjnoPqstL9JJ0RH0gp4vAw+CA/dPQmufKGJVFWBMcH/tWy9tng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NfkdEAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NfkdEAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40F5C4CED1;
	Wed,  5 Mar 2025 18:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198171;
	bh=vFKhiTn4PG/Xkvt4lpQznJ5KLahtMBho8I0OF4CE1hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NfkdEAzqUfSzRAyAh9fc44LvNcWE/s2k3fm4aTpbuPihp3CaUcjEqkeu4e2/2Pib
	 GmkRmRdyztwDhGc5xyYORkDE5T1AIo/d6bE0i5R1OLXZ/29MK+wq7ytI7lDCyZTPrI
	 Ql/USWn6BNrIatL6Pip5CHdrBjZSKnz+KlHyGYdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 089/150] KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2
Date: Wed,  5 Mar 2025 18:48:38 +0100
Message-ID: <20250305174507.389227946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

commit fa808ed4e199ed17d878eb75b110bda30dd52434 upstream.

Vladimir reports that a race condition to attach a VMID to a stage-2 MMU
sometimes results in a vCPU entering the guest with a VMID of 0:

| CPU1                                            |   CPU2
|                                                 |
|                                                 | kvm_arch_vcpu_ioctl_run
|                                                 |   vcpu_load             <= load VTTBR_EL2
|                                                 |                            kvm_vmid->id = 0
|                                                 |
| kvm_arch_vcpu_ioctl_run                         |
|   vcpu_load             <= load VTTBR_EL2       |
|                            with kvm_vmid->id = 0|
|   kvm_arm_vmid_update   <= allocates fresh      |
|                            kvm_vmid->id and     |
|                            reload VTTBR_EL2     |
|                                                 |
|                                                 |   kvm_arm_vmid_update <= observes that kvm_vmid->id
|                                                 |                          already allocated,
|                                                 |                          skips reload VTTBR_EL2

Oh yeah, it's as bad as it looks. Remember that VHE loads the stage-2
MMU eagerly but a VMID only gets attached to the MMU later on in the
KVM_RUN loop.

Even in the "best case" where VTTBR_EL2 correctly gets reprogrammed
before entering the EL1&0 regime, there is a period of time where
hardware is configured with VMID 0. That's completely insane. So, rather
than decorating the 'late' binding with another hack, just allocate the
damn thing up front.

Attaching a VMID from vcpu_load() is still rollover safe since
(surprise!) it'll always get called after a vCPU was preempted.

Excuse me while I go find a brown paper bag.

Cc: stable@vger.kernel.org
Fixes: 934bf871f011 ("KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()")
Reported-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250219220737.130842-1-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    2 +-
 arch/arm64/kvm/arm.c              |   22 ++++++++++------------
 arch/arm64/kvm/vmid.c             |   11 +++--------
 3 files changed, 14 insertions(+), 21 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1243,7 +1243,7 @@ int kvm_arm_pvtime_has_attr(struct kvm_v
 extern unsigned int __ro_after_init kvm_arm_vmid_bits;
 int __init kvm_arm_vmid_alloc_init(void);
 void __init kvm_arm_vmid_alloc_free(void);
-bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
 void kvm_arm_vmid_clear_active(void);
 
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -581,6 +581,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
+	 * Ensure a VMID is allocated for the MMU before programming VTTBR_EL2,
+	 * which happens eagerly in VHE.
+	 *
+	 * Also, the VMID allocator only preserves VMIDs that are active at the
+	 * time of rollover, so KVM might need to grab a new VMID for the MMU if
+	 * this is called from kvm_sched_in().
+	 */
+	kvm_arm_vmid_update(&mmu->vmid);
+
+	/*
 	 * We guarantee that both TLBs and I-cache are private to each
 	 * vcpu. If detecting that a vcpu from the same VM has
 	 * previously run on the same physical CPU, call into the
@@ -1155,18 +1165,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 		 */
 		preempt_disable();
 
-		/*
-		 * The VMID allocator only tracks active VMIDs per
-		 * physical CPU, and therefore the VMID allocated may not be
-		 * preserved on VMID roll-over if the task was preempted,
-		 * making a thread's VMID inactive. So we need to call
-		 * kvm_arm_vmid_update() in non-premptible context.
-		 */
-		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
-		    has_vhe())
-			__load_stage2(vcpu->arch.hw_mmu,
-				      vcpu->arch.hw_mmu->arch);
-
 		kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -135,11 +135,10 @@ void kvm_arm_vmid_clear_active(void)
 	atomic64_set(this_cpu_ptr(&active_vmids), VMID_ACTIVE_INVALID);
 }
 
-bool kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
 {
 	unsigned long flags;
 	u64 vmid, old_active_vmid;
-	bool updated = false;
 
 	vmid = atomic64_read(&kvm_vmid->id);
 
@@ -157,21 +156,17 @@ bool kvm_arm_vmid_update(struct kvm_vmid
 	if (old_active_vmid != 0 && vmid_gen_match(vmid) &&
 	    0 != atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
 					  old_active_vmid, vmid))
-		return false;
+		return;
 
 	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
 
 	/* Check that our VMID belongs to the current generation. */
 	vmid = atomic64_read(&kvm_vmid->id);
-	if (!vmid_gen_match(vmid)) {
+	if (!vmid_gen_match(vmid))
 		vmid = new_vmid(kvm_vmid);
-		updated = true;
-	}
 
 	atomic64_set(this_cpu_ptr(&active_vmids), vmid);
 	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
-
-	return updated;
 }
 
 /*


