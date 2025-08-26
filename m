Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6289537F8;
	Tue, 26 Aug 2025 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212662; cv=none; b=HVsJehFB3ZDCS3o/upR2IMCbIu2T26aBf8ukHcaDFEngyeQHtVUazxGrY8QUinxvZFSP6pIFS74+0qMVnnAfVbU/L/nKJptQmrW90u10rHRmQmo+Ah9RrksTg30E86LRyTQrXHmt4q3SAaNoO9oeZRLoCV2k7NhuEWDUnUXIjXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212662; c=relaxed/simple;
	bh=SpHUL0XY8UhsR2rRTYoabyVcUHZhzOgk8rIBRL/6KP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+M0/RNIBkNLTp7sCvF/0vaS3MpQe92X3ybCJeMSBqNFtnlptCeDw1VqzRw485zm/qtSZ4h45VNVzSDYXn2KHLgY7i1dkJ3+tOWj98FFK0g7pPuaJtx/kgQIpwAXQ0rGDeG6bP3dicjeFaokujJiJ0RgTo6Q6c0yHRhGfw9BI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2llZnaTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2llZnaTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780D6C4CEF1;
	Tue, 26 Aug 2025 12:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212661;
	bh=SpHUL0XY8UhsR2rRTYoabyVcUHZhzOgk8rIBRL/6KP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2llZnaTViwPOF1t/WX+4ERakF/E9iLrKu64hS7F0jKPfpSrxohNiqzB7DRCT7itcl
	 pFeLXNxcd8ci3iIhX/3aIJ7S9T/QN9tjVq0ITbAzs2tg8xAwkspB7ZI7+BmZJgOgwQ
	 Uy8ou7CDwMmAcjn/rdvrmOYNlCkuDYzPd1kkd4NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/587] KVM: VMX: Preserve hosts DEBUGCTLMSR_FREEZE_IN_SMM while running the guest
Date: Tue, 26 Aug 2025 13:03:22 +0200
Message-ID: <20250826110954.292467491@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 6b1dd26544d045f6a79e8c73572c0c0db3ef3c1a ]

Set/clear DEBUGCTLMSR_FREEZE_IN_SMM in GUEST_IA32_DEBUGCTL based on the
host's pre-VM-Enter value, i.e. preserve the host's FREEZE_IN_SMM setting
while running the guest.  When running with the "default treatment of SMIs"
in effect (the only mode KVM supports), SMIs do not generate a VM-Exit that
is visible to host (non-SMM) software, and instead transitions directly
from VMX non-root to SMM.  And critically, DEBUGCTL isn't context switched
by hardware on SMI or RSM, i.e. SMM will run with whatever value was
resident in hardware at the time of the SMI.

Failure to preserve FREEZE_IN_SMM results in the PMU unexpectedly counting
events while the CPU is executing in SMM, which can pollute profiling and
potentially leak information into the guest.

Check for changes in FREEZE_IN_SMM prior to every entry into KVM's inner
run loop, as the bit can be toggled in IRQ context via IPI callback (SMP
function call), by way of /sys/devices/cpu/freeze_on_smi.

Add a field in kvm_x86_ops to communicate which DEBUGCTL bits need to be
preserved, as FREEZE_IN_SMM is only supported and defined for Intel CPUs,
i.e. explicitly checking FREEZE_IN_SMM in common x86 is at best weird, and
at worst could lead to undesirable behavior in the future if AMD CPUs ever
happened to pick up a collision with the bit.

Exempt TDX vCPUs, i.e. protected guests, from the check, as the TDX Module
owns and controls GUEST_IA32_DEBUGCTL.

WARN in SVM if KVM_RUN_LOAD_DEBUGCTL is set, mostly to document that the
lack of handling isn't a KVM bug (TDX already WARNs on any run_flag).

Lastly, explicitly reload GUEST_IA32_DEBUGCTL on a VM-Fail that is missed
by KVM but detected by hardware, i.e. in nested_vmx_restore_host_state().
Doing so avoids the need to track host_debugctl on a per-VMCS basis, as
GUEST_IA32_DEBUGCTL is unconditionally written by prepare_vmcs02() and
load_vmcs12_host_state().  For the VM-Fail case, even though KVM won't
have actually entered the guest, vcpu_enter_guest() will have run with
vmcs02 active and thus could result in vmcs01 being run with a stale value.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250610232010.162191-9-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: move vmx/main.c change to vmx/vmx.c]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/vmx/nested.c       |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  5 +++++
 arch/x86/kvm/vmx/vmx.h          | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              | 14 ++++++++++++--
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7373b22c02a7..813887324d52 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1553,6 +1553,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
 	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
+	KVM_RUN_LOAD_DEBUGCTL		= BIT(2),
 };
 
 struct kvm_x86_ops {
@@ -1580,6 +1581,12 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
+	/*
+	 * Mask of DEBUGCTL bits that are owned by the host, i.e. that need to
+	 * match the host's value even while the guest is active.
+	 */
+	const u64 HOST_OWNED_DEBUGCTL;
+
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ce39ffbcefb..d2fa192d7ce7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4688,6 +4688,9 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 			WARN_ON(kvm_set_dr(vcpu, 7, vmcs_readl(GUEST_DR7)));
 	}
 
+	/* Reload DEBUGCTL to ensure vmcs01 has a fresh FREEZE_IN_SMM value. */
+	vmx_reload_guest_debugctl(vcpu);
+
 	/*
 	 * Note that calling vmx_set_{efer,cr0,cr4} is important as they
 	 * handle a variety of side effects to KVM's software model.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d0973bd7853c..9b1f22bcb716 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7399,6 +7399,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
 		set_debugreg(vcpu->arch.dr6, 6);
 
+	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
+		vmx_reload_guest_debugctl(vcpu);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
@@ -8326,6 +8329,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.HOST_OWNED_DEBUGCTL = DEBUGCTLMSR_FREEZE_IN_SMM,
+
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 769e70fd142c..5d73d3e570d7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -434,12 +434,25 @@ bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
 
 static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
 {
+	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
+
+	val |= vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
 	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
 }
 
 static inline u64 vmx_guest_debugctl_read(void)
 {
-	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
+}
+
+static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
+{
+	u64 val = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
+		return;
+
+	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbb2e70e3031..fc2cafc33b37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10518,7 +10518,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
-	u64 run_flags;
+	u64 run_flags, debug_ctl;
 
 	bool req_immediate_exit = false;
 
@@ -10777,7 +10777,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
-	vcpu->arch.host_debugctl = get_debugctlmsr();
+	/*
+	 * Refresh the host DEBUGCTL snapshot after disabling IRQs, as DEBUGCTL
+	 * can be modified in IRQ context, e.g. via SMP function calls.  Inform
+	 * vendor code if any host-owned bits were changed, e.g. so that the
+	 * value loaded into hardware while running the guest can be updated.
+	 */
+	debug_ctl = get_debugctlmsr();
+	if ((debug_ctl ^ vcpu->arch.host_debugctl) & kvm_x86_ops.HOST_OWNED_DEBUGCTL &&
+	    !vcpu->arch.guest_state_protected)
+		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
+	vcpu->arch.host_debugctl = debug_ctl;
 
 	guest_timing_enter_irqoff();
 
-- 
2.50.1



