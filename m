Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398F54534A9;
	Thu, 30 Jul 2026 16:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427279; cv=none; b=d3ZWTnWLLXi6Bjylb4FjYYHvg02imFdIWukJJRCUuT+nbmcovOt/iSyfFfabMF9pZh47XovC+b890Oo9RtD9FlFMAr3lRObLR91utWLRFGJkknkNoUacCQebtI0EzCtvHqQp+xIDVheRGSlzfC5Aq4s/aUGyerq96E2kgTJimgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427279; c=relaxed/simple;
	bh=jfPrimikdWK79TLLMZMbzlhqBE2dMdlYWr3lIiSO+MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qlddt+VjIN3vv/utoXSFdW0QKC4qXMuI+OwEGx+EtJIOuJKxrMIiMKl8FtcqlxAF5xJY2KGk0cUo6/j2g9xy+SnK0z2iI6Gp6BUGViEhSc0TeG6+fPGjN8VhG+BsfLLyzyxexOti6Wpl/F5wbHY3yGdxTEREDzTNwKDsug1jfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBz8jvAS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBz8jvAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529D91F00A3D;
	Thu, 30 Jul 2026 16:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427277;
	bh=A3azS6JIjlpPzycq04uSMrBOxxIJ50D0FTjxFlkx0RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBz8jvASBYRQhdtOTkb7feJjz+ehw2+ePhCklDLDx03bBdVIUG2rKFfgdXjvAM7br
	 RWa62e2GBNjgHqrMBPPztEZZMe35hDok/Bq8ozNv0fSZGSCxvG/1kAp/GQ1w83WSk4
	 82rQSqyAVN0y2Jd0+YMpj3Da1XHumn2GgimI7VY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/484] RISC-V: KVM: Serialize virtual interrupt pending state updates
Date: Thu, 30 Jul 2026 16:10:10 +0200
Message-ID: <20260730141425.918142321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ bo: Drop IRQ_PMU_OVF handling, which is not present in 6.6.y, and
  adapt the reset and CSR helpers to their older signatures. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_host.h | 10 ++---
 arch/riscv/kvm/aia.c              | 35 +++++++++++++----
 arch/riscv/kvm/vcpu.c             | 64 ++++++++++++++++++++++---------
 arch/riscv/kvm/vcpu_onereg.c      |  8 +++-
 4 files changed, 85 insertions(+), 32 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 459e61ad7d2b68..d2d7f9b4f7c043 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -202,13 +202,13 @@ struct kvm_vcpu_arch {
 	/*
 	 * VCPU interrupts
 	 *
-	 * We have a lockless approach for tracking pending VCPU interrupts
-	 * implemented using atomic bitops. The irqs_pending bitmap represent
-	 * pending interrupts whereas irqs_pending_mask represent bits changed
-	 * in irqs_pending. Our approach is modeled around multiple producer
-	 * and single consumer problem where the consumer is the VCPU itself.
+	 * The irqs_pending bitmap represents pending interrupts whereas
+	 * irqs_pending_mask represents bits changed in irqs_pending. Updates
+	 * to these bitmaps are serialized so vcpu interrupt sync/flush cannot
+	 * drop a newly injected interrupt while syncing guest-visible HVIP.
 	 */
 #define KVM_RISCV_VCPU_NR_IRQS	64
+	raw_spinlock_t irqs_pending_lock;
 	DECLARE_BITMAP(irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
 	DECLARE_BITMAP(irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
 
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 74bb27440527b3..be133090306455 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -71,12 +71,15 @@ void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
 	unsigned long mask, val;
 
+	lockdep_assert_held(&vcpu->arch.irqs_pending_lock);
+
 	if (!kvm_riscv_aia_available())
 		return;
 
-	if (READ_ONCE(vcpu->arch.irqs_pending_mask[1])) {
-		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask[1], 0);
-		val = READ_ONCE(vcpu->arch.irqs_pending[1]) & mask;
+	mask = vcpu->arch.irqs_pending_mask[1];
+	if (mask) {
+		vcpu->arch.irqs_pending_mask[1] = 0;
+		val = vcpu->arch.irqs_pending[1] & mask;
 
 		csr->hviph &= ~mask;
 		csr->hviph |= val;
@@ -87,6 +90,8 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
 
+	lockdep_assert_held(&vcpu->arch.irqs_pending_lock);
+
 	if (kvm_riscv_aia_available())
 		csr->vsieh = csr_read(CSR_VSIEH);
 }
@@ -96,13 +101,22 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 {
 	int hgei;
 	unsigned long seip;
+#ifdef CONFIG_32BIT
+	unsigned long flags;
+	bool pending;
+#endif
 
 	if (!kvm_riscv_aia_available())
 		return false;
 
 #ifdef CONFIG_32BIT
-	if (READ_ONCE(vcpu->arch.irqs_pending[1]) &
-	    (vcpu->arch.aia_context.guest_csr.vsieh & upper_32_bits(mask)))
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	pending = vcpu->arch.irqs_pending[1] &
+		  (vcpu->arch.aia_context.guest_csr.vsieh &
+		   upper_32_bits(mask));
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
+
+	if (pending)
 		return true;
 #endif
 
@@ -190,6 +204,9 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
 			       unsigned long val)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+#ifdef CONFIG_32BIT
+	unsigned long flags;
+#endif
 
 	if (reg_num >= sizeof(struct kvm_riscv_aia_csr) / sizeof(unsigned long))
 		return -ENOENT;
@@ -198,8 +215,12 @@ int kvm_riscv_vcpu_aia_set_csr(struct kvm_vcpu *vcpu,
 		((unsigned long *)csr)[reg_num] = val;
 
 #ifdef CONFIG_32BIT
-		if (reg_num == KVM_REG_RISCV_CSR_AIA_REG(siph))
-			WRITE_ONCE(vcpu->arch.irqs_pending_mask[1], 0);
+		if (reg_num == KVM_REG_RISCV_CSR_AIA_REG(siph)) {
+			raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+			vcpu->arch.irqs_pending_mask[1] = 0;
+			raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock,
+						   flags);
+		}
 #endif
 	}
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 9584d62c96ee74..da769ecfdd1083 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -44,6 +44,7 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	unsigned long flags;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
@@ -74,8 +75,10 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_riscv_vcpu_aia_reset(vcpu);
 
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
 	bitmap_zero(vcpu->arch.irqs_pending, KVM_RISCV_VCPU_NR_IRQS);
 	bitmap_zero(vcpu->arch.irqs_pending_mask, KVM_RISCV_VCPU_NR_IRQS);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	kvm_riscv_vcpu_pmu_reset(vcpu);
 
@@ -117,6 +120,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Setup VCPU hfence queue */
 	spin_lock_init(&vcpu->arch.hfence_lock);
+	raw_spin_lock_init(&vcpu->arch.irqs_pending_lock);
 
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
 	cntx = &vcpu->arch.guest_reset_context;
@@ -323,10 +327,14 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 	unsigned long mask, val;
+	unsigned long flags;
 
-	if (READ_ONCE(vcpu->arch.irqs_pending_mask[0])) {
-		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask[0], 0);
-		val = READ_ONCE(vcpu->arch.irqs_pending[0]) & mask;
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+
+	mask = vcpu->arch.irqs_pending_mask[0];
+	if (mask) {
+		vcpu->arch.irqs_pending_mask[0] = 0;
+		val = vcpu->arch.irqs_pending[0] & mask;
 
 		csr->hvip &= ~mask;
 		csr->hvip |= val;
@@ -334,11 +342,14 @@ void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
 
 	/* Flush AIA high interrupts */
 	kvm_riscv_vcpu_aia_flush_interrupts(vcpu);
+
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 }
 
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 {
 	unsigned long hvip;
+	unsigned long flags;
 	struct kvm_vcpu_arch *v = &vcpu->arch;
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
 
@@ -347,27 +358,34 @@ void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
 
 	/* Sync-up HVIP.VSSIP bit changes does by Guest */
 	hvip = csr_read(CSR_HVIP);
+
+	raw_spin_lock_irqsave(&v->irqs_pending_lock, flags);
+
 	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
 		if (hvip & (1UL << IRQ_VS_SOFT)) {
-			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      v->irqs_pending_mask))
-				set_bit(IRQ_VS_SOFT, v->irqs_pending);
+			if (!__test_and_set_bit(IRQ_VS_SOFT,
+						v->irqs_pending_mask))
+				__set_bit(IRQ_VS_SOFT, v->irqs_pending);
 		} else {
-			if (!test_and_set_bit(IRQ_VS_SOFT,
-					      v->irqs_pending_mask))
-				clear_bit(IRQ_VS_SOFT, v->irqs_pending);
+			if (!__test_and_set_bit(IRQ_VS_SOFT,
+						v->irqs_pending_mask))
+				__clear_bit(IRQ_VS_SOFT, v->irqs_pending);
 		}
 	}
 
 	/* Sync-up AIA high interrupts */
 	kvm_riscv_vcpu_aia_sync_interrupts(vcpu);
 
+	raw_spin_unlock_irqrestore(&v->irqs_pending_lock, flags);
+
 	/* Sync-up timer CSRs */
 	kvm_riscv_vcpu_timer_sync(vcpu);
 }
 
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
+	unsigned long flags;
+
 	/*
 	 * We only allow VS-mode software, timer, and external
 	 * interrupts when irq is one of the local interrupts
@@ -379,9 +397,10 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	set_bit(irq, vcpu->arch.irqs_pending);
-	smp_mb__before_atomic();
-	set_bit(irq, vcpu->arch.irqs_pending_mask);
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	__set_bit(irq, vcpu->arch.irqs_pending);
+	__set_bit(irq, vcpu->arch.irqs_pending_mask);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	kvm_vcpu_kick(vcpu);
 
@@ -390,6 +409,8 @@ int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 {
+	unsigned long flags;
+
 	/*
 	 * We only allow VS-mode software, timer, and external
 	 * interrupts when irq is one of the local interrupts
@@ -401,26 +422,33 @@ int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
 	    irq != IRQ_VS_EXT)
 		return -EINVAL;
 
-	clear_bit(irq, vcpu->arch.irqs_pending);
-	smp_mb__before_atomic();
-	set_bit(irq, vcpu->arch.irqs_pending_mask);
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+	__clear_bit(irq, vcpu->arch.irqs_pending);
+	__set_bit(irq, vcpu->arch.irqs_pending_mask);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	return 0;
 }
 
 bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 {
+	unsigned long flags;
 	unsigned long ie;
+	bool ret;
 
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
 	ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
 		<< VSIP_TO_HVIP_SHIFT) & (unsigned long)mask;
 	ie |= vcpu->arch.guest_csr.vsie & ~IRQ_LOCAL_MASK &
 		(unsigned long)mask;
-	if (READ_ONCE(vcpu->arch.irqs_pending[0]) & ie)
-		return true;
+	ret = vcpu->arch.irqs_pending[0] & ie;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
 
 	/* Check AIA high interrupts */
-	return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
+	if (!ret)
+		ret = kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
+
+	return ret;
 }
 
 void __kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index d520b25d856167..0e5853186365e2 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -361,6 +361,7 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 					  unsigned long reg_val)
 {
 	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long flags;
 
 	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
 		return -ENOENT;
@@ -372,8 +373,11 @@ static int kvm_riscv_vcpu_general_set_csr(struct kvm_vcpu *vcpu,
 
 	((unsigned long *)csr)[reg_num] = reg_val;
 
-	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
-		WRITE_ONCE(vcpu->arch.irqs_pending_mask[0], 0);
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		raw_spin_lock_irqsave(&vcpu->arch.irqs_pending_lock, flags);
+		vcpu->arch.irqs_pending_mask[0] = 0;
+		raw_spin_unlock_irqrestore(&vcpu->arch.irqs_pending_lock, flags);
+	}
 
 	return 0;
 }
-- 
2.53.0



