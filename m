Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10619332ECC;
	Mon, 29 Dec 2025 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025908; cv=none; b=NUHK+lDe8VJkV0EvuGKufkaH3wkIYXi3573LhZs3xyz84KSw2w9ePrH51xzNGuDbIrZ7hr98PAQ3jjIg22SfkzB1V7qiAWHYA5mfPkia0iNEV5tf8Lw8nffNgvofWV+Jk9cRoQuPUBUJswbxAMtjyNImxos7qX3UYv2r+7dyb9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025908; c=relaxed/simple;
	bh=7I1nPr+7pdPtScBOuJBnmQjlM2i7vRB+yxzpG9wzfjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grOFqgNLlpSTQE9BZlxE119pIVZsn/wPcyd+JtkQDqGxkMURYwar8xaRhbkZOd2PFVI6HEgUs9/U8nfhnoksLG5DJ6Wq0txK0ADkZxhPoHruLUrMiIkDvezG+efvVWO9YGqpMC0pAyglyc3YsZX7Ha6VZ+D5Z6QhaQmuXu7pyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXkzXeZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXkzXeZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC07C4CEF7;
	Mon, 29 Dec 2025 16:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025907;
	bh=7I1nPr+7pdPtScBOuJBnmQjlM2i7vRB+yxzpG9wzfjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXkzXeZ5Hn5KMgx92RS1dmNCtrkl8SgUGdUG2PxUAhNwiCrJ+fm0WZVo0MiGHCvoL
	 UPh8IiJVZaIdCmSHV1HLm5dphp/uu0c2aoWFkwc1TDYd7CJc8Uq3J8m+Td3cKvXlYT
	 M0/x8S88z8TFAcYp2Ef4JxUWhgdPSVKpCk8A7AUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhao <yan.y.zhao@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 348/430] KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered by the TDX-Module
Date: Mon, 29 Dec 2025 17:12:30 +0100
Message-ID: <20251229160737.133230723@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit c0711f8c610e1634ed54fb04da1e82252730306a upstream.

Set all user-return MSRs to their post-TD-exit value when preparing to run
a TDX vCPU to ensure the value that KVM expects to be loaded after running
the vCPU is indeed the value that's loaded in hardware.  If the TDX-Module
doesn't actually enter the guest, i.e. doesn't do VM-Enter, then it won't
"restore" VMM state, i.e. won't clobber user-return MSRs to their expected
post-run values, in which case simply updating KVM's "cached" value will
effectively corrupt the cache due to hardware still holding the original
value.

In theory, KVM could conditionally update the current user-return value if
and only if tdh_vp_enter() succeeds, but in practice "success" doesn't
guarantee the TDX-Module actually entered the guest, e.g. if the TDX-Module
synthesizes an EPT Violation because it suspects a zero-step attack.

Force-load the expected values instead of trying to decipher whether or
not the TDX-Module restored/clobbered MSRs, as the risk doesn't justify
the benefits.  Effectively avoiding four WRMSRs once per run loop (even if
the vCPU is scheduled out, user-return MSRs only need to be reloaded if
the CPU exits to userspace or runs a non-TDX vCPU) is likely in the noise
when amortized over all entries, given the cost of running a TDX vCPU.
E.g. the cost of the WRMSRs is somewhere between ~300 and ~500 cycles,
whereas the cost of a _single_ roundtrip to/from a TDX guest is thousands
of cycles.

Fixes: e0b4f31a3c65 ("KVM: TDX: restore user ret MSRs")
Cc: stable@vger.kernel.org
Cc: Yan Zhao <yan.y.zhao@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20251030191528.3380553-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 
 arch/x86/kvm/vmx/tdx.c          |   56 ++++++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.h          |    1 
 arch/x86/kvm/x86.c              |    9 ------
 4 files changed, 23 insertions(+), 44 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2387,7 +2387,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, uns
 int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
-void kvm_user_return_msr_update_cache(unsigned int index, u64 val);
 u64 kvm_get_user_return_msr(unsigned int slot);
 
 static inline bool kvm_is_supported_user_return_msr(u32 msr)
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -763,25 +763,6 @@ static bool tdx_protected_apic_has_inter
 	return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
 }
 
-/*
- * Compared to vmx_prepare_switch_to_guest(), there is not much to do
- * as SEAMCALL/SEAMRET calls take care of most of save and restore.
- */
-void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vt *vt = to_vt(vcpu);
-
-	if (vt->guest_state_loaded)
-		return;
-
-	if (likely(is_64bit_mm(current->mm)))
-		vt->msr_host_kernel_gs_base = current->thread.gsbase;
-	else
-		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
-
-	vt->guest_state_loaded = true;
-}
-
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -795,19 +776,38 @@ static struct tdx_uret_msr tdx_uret_msrs
 	{.msr = MSR_TSC_AUX,},
 };
 
-static void tdx_user_return_msr_update_cache(void)
+void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_vt *vt = to_vt(vcpu);
 	int i;
 
+	if (vt->guest_state_loaded)
+		return;
+
+	if (likely(is_64bit_mm(current->mm)))
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
+	else
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+
+	vt->guest_state_loaded = true;
+
+	/*
+	 * Explicitly set user-return MSRs that are clobbered by the TDX-Module
+	 * if VP.ENTER succeeds, i.e. on TD-Exit, with the values that would be
+	 * written by the TDX-Module.  Don't rely on the TDX-Module to actually
+	 * clobber the MSRs, as the contract is poorly defined and not upheld.
+	 * E.g. the TDX-Module will synthesize an EPT Violation without doing
+	 * VM-Enter if it suspects a zero-step attack, and never "restore" VMM
+	 * state.
+	 */
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
-		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
-						 tdx_uret_msrs[i].defval);
+		kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
+					tdx_uret_msrs[i].defval, -1ull);
 }
 
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vt *vt = to_vt(vcpu);
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (!vt->guest_state_loaded)
 		return;
@@ -815,11 +815,6 @@ static void tdx_prepare_switch_to_host(s
 	++vcpu->stat.host_state_reload;
 	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
-	if (tdx->guest_entered) {
-		tdx_user_return_msr_update_cache();
-		tdx->guest_entered = false;
-	}
-
 	vt->guest_state_loaded = false;
 }
 
@@ -1059,7 +1054,6 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 	tdx_load_host_xsave_state(vcpu);
-	tdx->guest_entered = true;
 
 	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
 
@@ -3447,10 +3441,6 @@ static int __init __tdx_bringup(void)
 		/*
 		 * Check if MSRs (tdx_uret_msrs) can be saved/restored
 		 * before returning to user space.
-		 *
-		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
-		 * because the registration is done at vcpu runtime by
-		 * tdx_user_return_msr_update_cache().
 		 */
 		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
 		if (tdx_uret_msrs[i].slot == -1) {
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -67,7 +67,6 @@ struct vcpu_tdx {
 	u64 vp_enter_ret;
 
 	enum vcpu_tdx_state state;
-	bool guest_entered;
 
 	u64 map_gpa_next;
 	u64 map_gpa_end;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -681,15 +681,6 @@ int kvm_set_user_return_msr(unsigned slo
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_user_return_msr);
 
-void kvm_user_return_msr_update_cache(unsigned int slot, u64 value)
-{
-	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
-
-	msrs->values[slot].curr = value;
-	kvm_user_return_register_notifier(msrs);
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_user_return_msr_update_cache);
-
 u64 kvm_get_user_return_msr(unsigned int slot)
 {
 	return this_cpu_ptr(user_return_msrs)->values[slot].curr;


