Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75C626ADD;
	Mon, 24 Feb 2025 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408298; cv=none; b=OYBygjr4rOLGvFYXyWP+Eb53yuJY0ikVzK1xJiZLjeac5vKINVMlbURkqAaP8k6Eoyh55Z0tfybDiwhffJUQO9kFCgiQqz4XlHTnx8qjF6z9ASv9/2n7GBodHmxEwwLpdOzqVW2ps4FpHO6BenknG+H56PuAe1FgxpL1rjYQCIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408298; c=relaxed/simple;
	bh=+m3TmeDlGMDNSCwtBGYo50cwn0TSCqHMhMtFeQRQEOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdqDYXgStZe1sOEADRLTlv1z8GU4y4wuhzZVQb/yEf0E485BHsIynlrltVfVE8k7g7QqVRYItw11LTqrAyyDB62mR/hOBYyaAz76tt7Qfb4LmY445ilMl8hbQwW1nHt0gHqiBWIV7HK4rFbQ1BifE6g6weqN2ck5yWSgXSRBmtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvAXB7ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvAXB7ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D65C4CEE6;
	Mon, 24 Feb 2025 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408298;
	bh=+m3TmeDlGMDNSCwtBGYo50cwn0TSCqHMhMtFeQRQEOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvAXB7ty85bpYn3oR/umoJjNr98Z7nyVRGXJmmEaeLJ5yhgOgp/YTefaBrg/KQk9+
	 DFydh9Gz+0NlnNYvLsSBUuGpQn1mkBndE0cjOdXwc4nXfTgPW6m1rvL6ZdAWEL8/u3
	 MfEBs/7vDcuLy7QzE/hn7I5m/o6veboTYstA+3yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?= <mankku@gmail.com>,
	Janne Karhunen <janne.karhunen@gmail.com>,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/154] KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active w/o VID
Date: Mon, 24 Feb 2025 15:33:36 +0100
Message-ID: <20250224142607.753637865@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit 04bc93cf49d16d01753b95ddb5d4f230b809a991 ]

If KVM emulates an EOI for L1's virtual APIC while L2 is active, defer
updating GUEST_INTERUPT_STATUS.SVI, i.e. the VMCS's cache of the highest
in-service IRQ, until L1 is active, as vmcs01, not vmcs02, needs to track
vISR.  The missed SVI update for vmcs01 can result in L1 interrupts being
incorrectly blocked, e.g. if there is a pending interrupt with lower
priority than the interrupt that was EOI'd.

This bug only affects use cases where L1's vAPIC is effectively passed
through to L2, e.g. in a pKVM scenario where L2 is L1's depriveleged host,
as KVM will only emulate an EOI for L1's vAPIC if Virtual Interrupt
Delivery (VID) is disabled in vmc12, and L1 isn't intercepting L2 accesses
to its (virtual) APIC page (or if x2APIC is enabled, the EOI MSR).

WARN() if KVM updates L1's ISR while L2 is active with VID enabled, as an
EOI from L2 is supposed to affect L2's vAPIC, but still defer the update,
to try to keep L1 alive.  Specifically, KVM forwards all APICv-related
VM-Exits to L1 via nested_vmx_l1_wants_exit():

	case EXIT_REASON_APIC_ACCESS:
	case EXIT_REASON_APIC_WRITE:
	case EXIT_REASON_EOI_INDUCED:
		/*
		 * The controls for "virtualize APIC accesses," "APIC-
		 * register virtualization," and "virtual-interrupt
		 * delivery" only come from vmcs12.
		 */
		return true;

Fixes: c7c9c56ca26f ("x86, apicv: add virtual interrupt delivery support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/kvm/20230312180048.1778187-1-jason.cj.chen@intel.com
Reported-by: Markku Ahvenjärvi <mankku@gmail.com>
Closes: https://lore.kernel.org/all/20240920080012.74405-1-mankku@gmail.com
Cc: Janne Karhunen <janne.karhunen@gmail.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: drop request, handle in VMX, write changelog]
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20241128000010.4051275-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c      | 11 +++++++++++
 arch/x86/kvm/lapic.h      |  1 +
 arch/x86/kvm/vmx/nested.c |  5 +++++
 arch/x86/kvm/vmx/vmx.c    | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 5 files changed, 39 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 375bbb9600d3c..1a8148dec4afe 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -816,6 +816,17 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	}
 }
 
+void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
+		return;
+
+	kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
+}
+EXPORT_SYMBOL_GPL(kvm_apic_update_hwapic_isr);
+
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	/* This may race with setting of irr in __apic_accept_irq() and
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index fc4bd36d44cfc..3aa599db77968 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -120,6 +120,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
+void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 931a7361c30f2..22bee8a711442 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5043,6 +5043,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_hwapic_isr) {
+		vmx->nested.update_vmcs01_hwapic_isr = false;
+		kvm_apic_update_hwapic_isr(vcpu);
+	}
+
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f06d443ec3c68..1af30e3472cdd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6858,6 +6858,27 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 	u16 status;
 	u8 old;
 
+	/*
+	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
+	 * is only relevant for if and only if Virtual Interrupt Delivery is
+	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
+	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
+	 * VM-Exit, otherwise L1 with run with a stale SVI.
+	 */
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
+		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
+		 * Note, userspace can stuff state while L2 is active; assert
+		 * that VID is disabled if and only if the vCPU is in KVM_RUN
+		 * to avoid false positives if userspace is setting APIC state.
+		 */
+		WARN_ON_ONCE(vcpu->wants_to_run &&
+			     nested_cpu_has_vid(get_vmcs12(vcpu)));
+		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
+		return;
+	}
+
 	if (max_isr == -1)
 		max_isr = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20be..41bf59bbc6426 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -176,6 +176,7 @@ struct nested_vmx {
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
+	bool update_vmcs01_hwapic_isr;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.39.5



