Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8324F3AAF6D;
	Mon, 17 Aug 2026 15:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979609; cv=none; b=qf4PougTLsV2n/2wNpme+Vomc8SDcijam2BEo4nkqULk5eUmKZjImfrB3Fqca+EMUZ9qhcNT8iGngDJvQh0A2qoACQaJkKwqnSUTUVRud146j9xr2o82HvG2Jc8w16E5zujnTbx08uF8LcGJA1tbaY751OEX3D5iD6q5T1mj+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979609; c=relaxed/simple;
	bh=vri2e3H8srvjU8vXClKR8nNjPsyW6GjVyae4uj7OvZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RflO+8qna0I/fJm7Bo60hna+rOycb1Xzhlz4+ZHuochFrmz/V7SnW+N9uqpz9Xr/h098T+DB/w+GXhO4hXIMu1aUiQTKh67mgF6D1UQuBRrFMp3HhdJrMGofem4EIhlHVaH/9ZNGhbk+ap6J/nfM308TA4Vf3pmVp9y6x34/+o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/1gTDGg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/1gTDGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAECF1F000E9;
	Mon, 17 Aug 2026 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979608;
	bh=vYQGcUGBIbUj0qI//KRpFoAeti9rRya8PeJuLfZgmIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/1gTDGgkr2ZebEImovtg8Eiq1nTTFZBtzchzsdHvaQ776gfOAB7rKsNr3LPeL7se
	 YQWTnp+UdojjzrpszIpn3cO99r93n/sMczv3EgTiPjhI17VszSkOdZBpJwiju2N+fQ
	 ZVv5uv+Ye3rat5Fk8x/eOSeuGDIgnkLsDamW/8D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/609] RISC-V: KVM: Serialize virtual interrupt pending state updates
Date: Mon, 17 Aug 2026 15:29:42 +0200
Message-ID: <20260817132553.759575774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Bo <xb@ultrarisc.com>

commit d024a0a7879e6f37c0152aacf6d8e37b214a1738 upstream.

KVM RISC-V tracks guest local interrupt state with two bitmaps:

  - irqs_pending: interrupts that should be visible to the guest
  - irqs_pending_mask: interrupts whose pending state changed

The current code updates those bitmaps with independent atomic bitops
and assumes a multiple-producer, single-consumer protocol. That model
does not actually hold.

kvm_riscv_vcpu_sync_interrupts() is not a pure consumer. When the guest
changes guest-visible HVIP state, sync_interrupts() writes both
irqs_pending and irqs_pending_mask to reflect the new guest state back
into KVM state. As a result, irqs_pending and irqs_pending_mask form a
single logical state transition, but they are not updated atomically as
a pair.

This allows a race where a newly injected interrupt is lost. For
example:

  CPU0                              CPU1
  ----                              ----
  kvm_riscv_vcpu_set_interrupt(VS_SOFT)
    set_bit(VS_SOFT, irqs_pending)
                                    kvm_riscv_vcpu_sync_interrupts()
                                      sees guest-cleared HVIP.VSSIP
                                      sets irqs_pending_mask
                                      clear_bit(IRQ_VS_SOFT, irqs_pending)
    set_bit(VS_SOFT, irqs_pending_mask)
    kvm_vcpu_kick()

After that interleaving, a later flush can update HVIP without VSSIP
even though a new virtual interrupt was injected. In practice, the
guest can remain blocked in WFI with work pending.

The same pending/mask protocol is shared by VS soft interrupts, PMU
overflow delivery, and AIA high interrupt synchronization, so the race
is not limited to one interrupt source.

Fix this by serializing all updates to irqs_pending and irqs_pending_mask
with a per-vCPU raw spinlock. This keeps the pending bit and the dirty
mask as one state transition across:

  - set/unset interrupt
  - guest HVIP sync
  - interrupt flush to guest CSR state
  - vCPU reset
  - AIA CSR writes that clear dirty state

Use non-atomic bitmap operations while holding the lock. Hold the lock
across the AIA sync, flush, and pending checks as well, so both bitmap
words share the same serialization domain.

This intentionally replaces the existing lockless protocol instead of
trying to repair it with additional barriers. The problem is not memory
ordering on a single field; it is that two separate bitmaps encode one
shared state machine while both producers and sync paths can modify
them. A per-vCPU raw spinlock keeps the fix small, local, and suitable
for backporting.

Fixes: cce69aff689e ("RISC-V: KVM: Implement VCPU interrupts and requests handling")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260715020359.1521354-2-xb@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>

[ bo: Adapt to the scalar interrupt state in 6.1.y and its CSR one-reg
  helpers in vcpu.c. Drop AIA and PMU overflow handling, which are not
  present in this tree. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_host.h | 10 ++--
 arch/riscv/kvm/vcpu.c             | 78 ++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 28 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index dbbf43d5262348..dc5e553e136992 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -192,12 +192,12 @@ struct kvm_vcpu_arch {
 	/*
 	 * VCPU interrupts
 	 *
-	 * We have a lockless approach for tracking pending VCPU interrupts
-	 * implemented using atomic bitops. The irqs_pending bitmap represent
-	 * pending interrupts whereas irqs_pending_mask represent bits changed
-	 * in irqs_pending. Our approach is modeled around multiple producer
-	 * and single consumer problem where the consumer is the VCPU itself.
+	 * The irqs_pending field represents pending interrupts whereas
+	 * irqs_pending_mask represents bits changed in irqs_pending. Updates
+	 * to these fields are serialized so vcpu interrupt sync/flush cannot
+	 * drop a newly injected interrupt while syncing guest-visible HVIP.
 	 */
+	raw_spinlock_t irqs_pending_lock;
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 5174ef54ad1d9e..c6afbf0a9916fb 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -112,6 +112,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+	unsigned long flags;
 	bool loaded;
 
 	/**
@@ -134,8 +135,10 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_timer_reset(vcpu);
 
-	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
-	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	vcpu->arch.irqs_pending = 0;
+	vcpu->arch.irqs_pending_mask = 0;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	vcpu->arch.hfence_head = 0;
 	vcpu->arch.hfence_tail = 0;
@@ -173,6 +176,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Setup VCPU hfence queue */
 	spin_lock_init(&vcpu->arch.hfence_lock);
+	raw_spin_lock_init(&vcpu->arch.irqs_pending_lock);
 
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
 	cntx = &vcpu->arch.guest_reset_context;
@@ -444,7 +448,7 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
 					    KVM_REG_SIZE_MASK |
 					    KVM_REG_RISCV_CSR);
-	unsigned long reg_val;
+	unsigned long flags, reg_val;
 
 	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
 		return -EINVAL;
@@ -461,8 +465,11 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 
 	((unsigned long *)csr)[reg_num] = reg_val;
 
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
-		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+		vcpu->arch.irqs_pending_mask = 0;
+		raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
+	}
 
 	return 0;
 }
@@ -679,19 +686,26 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	unsigned long mask, val;
+	unsigned long flags;
 
-	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
-		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
-		val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+
+	mask = vcpu->arch.irqs_pending_mask;
+	if (mask) {
+		vcpu->arch.irqs_pending_mask = 0;
+		val = vcpu->arch.irqs_pending & mask;
 
 		csr->hvip &= ~mask;
 		csr->hvip |= val;
 	}
+
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 }
 
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 {
 	unsigned long hvip;
+	unsigned long flags;
 	struct kvm_vcpu_arch *v = &vcpu->arch;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
@@ -700,32 +714,40 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 
 	/* Sync-up HVIP.VSSIP bit changes does by Guest */
 	hvip = csr_read(CSR_HVIP);
+
+	raw_spin_lock_irqsave(&v->irqs_pending_lock, flags);
+
 	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
 		if (hvip & (1UL << IRQ_VS_SOFT)) {
-			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      &v->irqs_pending_mask))
-				set_bit(IRQ_VS_SOFT, &v->irqs_pending);
+			if (!__test_and_set_bit(IRQ_VS_SOFT,
+						&v->irqs_pending_mask))
+				__set_bit(IRQ_VS_SOFT, &v->irqs_pending);
 		} else {
-			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      &v->irqs_pending_mask))
-				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
+			if (!__test_and_set_bit(IRQ_VS_SOFT,
+						&v->irqs_pending_mask))
+				__clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
 		}
 	}
 
+	raw_spin_unlock_irqrestore(&v->irqs_pending_lock, flags);
+
 	/* Sync-up timer CSRs */
 	kvm_riscv_vcpu_timer_sync(vcpu);
 }
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
+	unsigned long flags;
+
 	if (irq != IRQ_VS_SOFT &&
 	    irq != IRQ_VS_TIMER &&
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	set_bit(irq, &vcpu->arch.irqs_pending);
-	smp_mb__before_atomic();
-	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	__set_bit(irq, &vcpu->arch.irqs_pending);
+	__set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	kvm_vcpu_kick(vcpu);
 
@@ -734,24 +756,34 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
+	unsigned long flags;
+
 	if (irq != IRQ_VS_SOFT &&
 	    irq != IRQ_VS_TIMER &&
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	clear_bit(irq, &vcpu->arch.irqs_pending);
-	smp_mb__before_atomic();
-	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	__clear_bit(irq, &vcpu->arch.irqs_pending);
+	__set_bit(irq, &vcpu->arch.irqs_pending_mask);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	return 0;
 }
 
 bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
 {
-	unsigned long ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
-			    << VSIP_TO_HVIP_SHIFT) & mask;
+	unsigned long flags;
+	unsigned long ie;
+	bool ret;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
+	      << VSIP_TO_HVIP_SHIFT) & mask;
+	ret = vcpu->arch.irqs_pending & ie;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
-	return (READ_ONCE(vcpu->arch.irqs_pending) & ie) ? true : false;
+	return ret;
 }
 
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
-- 
2.53.0



