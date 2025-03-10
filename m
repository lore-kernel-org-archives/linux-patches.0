Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1914417C225;
	Mon, 10 Mar 2025 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627064; cv=none; b=kRzYTk/9lyI7bDSPzBOyhHhyrDppiHHIimNVgT0LF7RYWzx67T3Y6Bat6zDJr5Af+dgMV+PRYbXx0G0UlWpRQpWUm7NrvKCQ5vKtxyvrp1fsKMfKBZ6iE8oVAqw/+afZ1LUCQg10oRC+D1XKN63zeaotl5if2pEKbQsw1w5sqJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627064; c=relaxed/simple;
	bh=zYS2pgcHe7ve3LfQjBpfk5pfSofZlRQNyvljRjJg1g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBkhJeVC1n6EZMjxKQzQwJ+vt/+Xn0RuTDQcxPsfBCHcpJXRGJiYOWzBmxzO3CEkTofJpto03RlV6Zz6dhCyZFFnkDa7/w+myvfiVKfUaN7IHhLX3FVw3ZPdidxQr2PQt/C6wOOs6cJkEUOwPogQA2NeMaxJQIAjdlDjWf7SS40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wu8lqwJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wu8lqwJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C63C4CEE5;
	Mon, 10 Mar 2025 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627064;
	bh=zYS2pgcHe7ve3LfQjBpfk5pfSofZlRQNyvljRjJg1g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wu8lqwJRq2dT/Y2v7ofQIce0nKkJPjFkIr/OB5ZtoOuhXr/BIqgzPw3YN1Rb/zorG
	 3FvXJc714obd2hacKFtyMxHC3NBpTZPyF9ECpqwniq3H95nioarmpwi5swr68HyaZH
	 CyW8fMMcAoEgsWRmTkBvCM+4UVXiA1HOwlGqHrPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6.13 176/207] KVM: x86: Snapshot the hosts DEBUGCTL in common x86
Date: Mon, 10 Mar 2025 18:06:09 +0100
Message-ID: <20250310170454.787700921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit fb71c795935652fa20eaf9517ca9547f5af99a76 upstream.

Move KVM's snapshot of DEBUGCTL to kvm_vcpu_arch and take the snapshot in
common x86, so that SVM can also use the snapshot.

Opportunistically change the field to a u64.  While bits 63:32 are reserved
on AMD, not mentioned at all in Intel's SDM, and managed as an "unsigned
long" by the kernel, DEBUGCTL is an MSR and therefore a 64-bit value.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx/vmx.c          |    8 ++------
 arch/x86/kvm/vmx/vmx.h          |    2 --
 arch/x86/kvm/x86.c              |    1 +
 4 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -761,6 +761,7 @@ struct kvm_vcpu_arch {
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
+	u64 host_debugctl;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	bool load_eoi_exitmap_pending;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1514,16 +1514,12 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu
  */
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
 		shrink_ple_window(vcpu);
 
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
-
-	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
 void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -7469,8 +7465,8 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
-	if (vmx->host_debugctlmsr)
-		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 #ifndef CONFIG_X86_64
 	/*
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -337,8 +337,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	unsigned long host_debugctlmsr;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4976,6 +4976,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
+	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {


