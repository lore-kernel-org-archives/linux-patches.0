Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14651384CED;
	Sat, 17 Oct 2026 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254218; cv=none; b=Hna7+juAauRFIlwBvKHtGUROzyxoLoyQCK71rB+N1U7+AMcb9lt5wzoHrO32pUA9u+XyF7tzScOidlXmlhIfaiOfvkirfnVpvfXUvuqoCbVl6/9r5kf6vno2ar01CdM6CNAEPOGp5n0+5a8PLXxRTQQjjof8Rf5r/kpAY+VTpV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254218; c=relaxed/simple;
	bh=pANSzAIR06RaA+qkndWn2vXM47mjQhYqfklTsLg1DCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaygfXXnQ3ZgAi3WrefHDO1VfNeijrd0dAhIcEh/zCa/I7ElbGrDac5B+4bFGTThgrxGXD0b2m7IM2+Y45ScWbYAHpUET4oLlrbCTjhBIn3OHxqwHEI3XwJsQ/OUPJycZTVFqmrvENrw130CZ4bXCy3tn3GDLFJMx3Ji016XBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPuPxEqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPuPxEqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294801F000C4;
	Sat, 17 Oct 2026 16:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254216;
	bh=OM3kq+SFiDDXiYxRAvecjT7WaAU6x/hiaymgRsXJlTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPuPxEqK99r9uX+R6VfChdPFDixscZo5pPgo+jSDoK3oOza/2mxxoaJoEALRfrx+p
	 mHLuU0zsWJL71Ye59Qcv8MSqhd0zBMwfCrNuOfDOoTYTRpcoO4tcWfE7aw5TSZtH5t
	 vNjU2Q7RtUpBLpwKIffHLeQ9xeSIHwVzbpkd8gpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/869] KVM: x86: Rename APIC base setters to better capture their relationship
Date: Sat, 17 Oct 2026 17:53:34 +0200
Message-ID: <20261017160046.676064583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 7d1cb7cee94ffd913cb3b70aa1c3538f195c1f23 ]

Rename kvm_set_apic_base() and kvm_lapic_set_base() to kvm_apic_set_base()
and __kvm_apic_set_base() respectively to capture that the underscores
version is a "special" variant (it exists purely to avoid recalculating
the optimized map multiple times when stuffing the RESET value).

Opportunistically add a comment explaining why kvm_lapic_reset() uses the
inner helper.  Note, KVM deliberately invokes kvm_arch_vcpu_create() while
kvm->lock is NOT held so that vCPU setup isn't serialized if userspace is
creating multiple/all vCPUs in parallel.  I.e. triggering an extra
recalculation is not limited to theoretical/rare edge cases, and so is
worth avoiding.

No functional change intended.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20241009181742.1128779-7-seanjc@google.com
Link: https://lore.kernel.org/r/20241101183555.1794700-7-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: bb365a506b1e ("KVM: x86: Unconditionally recompute CR8 intercept on PPR update")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 15 +++++++++++----
 arch/x86/kvm/lapic.h |  3 +--
 arch/x86/kvm/regs.c  |  2 +-
 arch/x86/kvm/x86.c   |  2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ea1c1728c1bf2..58af5b4b7bdbd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2608,7 +2608,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
 	return (tpr & 0xf0) >> 4;
 }
 
-void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
+static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
 {
 	u64 old_value = vcpu->arch.apic_base;
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -2656,7 +2656,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 	}
 }
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
@@ -2672,7 +2672,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 	}
 
-	kvm_lapic_set_base(vcpu, msr_info->data);
+	__kvm_apic_set_base(vcpu, msr_info->data);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
@@ -2787,7 +2787,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
 			msr_val |= MSR_IA32_APICBASE_BSP;
-		kvm_lapic_set_base(vcpu, msr_val);
+
+		/*
+		 * Use the inner helper to avoid an extra recalcuation of the
+		 * optimized APIC map if some other task has dirtied the map.
+		 * The recalculation needed for this vCPU will be done after
+		 * all APIC state has been initialized (see below).
+		 */
+		__kvm_apic_set_base(vcpu, msr_val);
 	}
 
 	if (!apic)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3aa599db77968..99c07ee76e02d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -95,7 +95,6 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
-void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
@@ -117,7 +116,7 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 
-int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
+int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/regs.c b/arch/x86/kvm/regs.c
index 26ee933ef5490..5001fe33c7f28 100644
--- a/arch/x86/kvm/regs.c
+++ b/arch/x86/kvm/regs.c
@@ -572,7 +572,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 
 	apic_base_msr.data = sregs->apic_base;
 	apic_base_msr.host_initiated = true;
-	if (kvm_set_apic_base(vcpu, &apic_base_msr))
+	if (kvm_apic_set_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
 	if (vcpu->arch.guest_state_protected)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af99fb9666132..65f5a18824266 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3454,7 +3454,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRdefType:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
-		return kvm_set_apic_base(vcpu, msr_info);
+		return kvm_apic_set_base(vcpu, msr_info);
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSC_DEADLINE:
-- 
2.53.0



