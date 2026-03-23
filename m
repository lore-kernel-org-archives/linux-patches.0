Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB973AF66E;
	Mon, 23 Mar 2026 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276935; cv=none; b=lXoUOAJniZmZ8Nbn/LaxH8YkY0xY0ixJfproXzNBfUk/iOU6KbUw/amR/8/bILw3I7aUnkRsyU87JtDpFb0GA6uOMoJOoT/hJL51RB6AVk09crWBmeFuSbPRT7/1meTd8Rl2y91KDg+uZUk3tKFx91dxAPEfiYyB3UuS8n2UN2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276935; c=relaxed/simple;
	bh=hvSe/m4dgFKFUAHRPnyXoDgDdY981ekarFdfde10g0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyGnqZdd05HoF2RBVxNC2UyY7eAbzOvCt7KtQWB2s9jFamFYvXZBrd5rY2i/+NYZIx4kVGGqj6b7wFySY69yNUhNwUJEcNVuykIQZtNqhP1wpoIJ2OLzA7M39aCZcrMkPNPXLuYVlkDnkKYfLRrdMbXwjzqyiVqT4NDttms6dQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GdpfY5O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdpfY5O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C55C4CEF7;
	Mon, 23 Mar 2026 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276934;
	bh=hvSe/m4dgFKFUAHRPnyXoDgDdY981ekarFdfde10g0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdpfY5O+N50EFQoEKb5M/h1cbVJ762T83qiyq+1/fXQ8m6kMWEaV+OuHvuHAOCtse
	 LeFvZkf/raTPpihIGtbehuSIaSMGFdO2GvZ2h1jpIDEh/I25eSbh6I5pn77BtZdZuj
	 8UiZm6JWsS9a4NNE11I6WC9ZIfJ+AKMfc0e01Nyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/460] KVM: x86: Quirk initialization of feature MSRs to KVMs max configuration
Date: Mon, 23 Mar 2026 14:44:16 +0100
Message-ID: <20260323134532.875161744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

[ Upstream commit dcb988cdac85bad177de86fbf409524eda4f9467 ]

Add a quirk to control KVM's misguided initialization of select feature
MSRs to KVM's max configuration, as enabling features by default violates
KVM's approach of letting userspace own the vCPU model, and is actively
problematic for MSRs that are conditionally supported, as the vCPU will
end up with an MSR value that userspace can't restore.  E.g. if the vCPU
is configured with PDCM=0, userspace will save and attempt to restore a
non-zero PERF_CAPABILITIES, thanks to KVM's meddling.

Link: https://lore.kernel.org/r/20240802185511.305849-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: e2ffe85b6d2b ("KVM: x86: Introduce KVM_X86_QUIRK_VMCS12_ALLOW_FREEZE_IN_SMM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/api.rst  |   22 ++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/include/uapi/asm/kvm.h |    1 +
 arch/x86/kvm/svm/svm.c          |    4 +++-
 arch/x86/kvm/vmx/vmx.c          |    9 ++++++---
 arch/x86/kvm/x86.c              |    8 +++++---
 6 files changed, 39 insertions(+), 8 deletions(-)

--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8107,6 +8107,28 @@ KVM_X86_QUIRK_SLOT_ZAP_ALL          By d
                                     or moved memslot isn't reachable, i.e KVM
                                     _may_ invalidate only SPTEs related to the
                                     memslot.
+
+KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
+                                    vCPU's MSR_IA32_PERF_CAPABILITIES (0x345),
+                                    MSR_IA32_ARCH_CAPABILITIES (0x10a),
+                                    MSR_PLATFORM_INFO (0xce), and all VMX MSRs
+                                    (0x480..0x492) to the maximal capabilities
+                                    supported by KVM.  KVM also sets
+                                    MSR_IA32_UCODE_REV (0x8b) to an arbitrary
+                                    value (which is different for Intel vs.
+                                    AMD).  Lastly, when guest CPUID is set (by
+                                    userspace), KVM modifies select VMX MSR
+                                    fields to force consistency between guest
+                                    CPUID and L2's effective ISA.  When this
+                                    quirk is disabled, KVM zeroes the vCPU's MSR
+                                    values (with two exceptions, see below),
+                                    i.e. treats the feature MSRs like CPUID
+                                    leaves and gives userspace full control of
+                                    the vCPU model definition.  This quirk does
+                                    not affect VMX MSRs CR0/CR4_FIXED1 (0x487
+                                    and 0x489), as KVM does now allow them to
+                                    be set by userspace (KVM sets them based on
+                                    guest CPUID, for safety purposes).
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2385,7 +2385,8 @@ int memslot_rmap_alloc(struct kvm_memory
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS |	\
-	 KVM_X86_QUIRK_SLOT_ZAP_ALL)
+	 KVM_X86_QUIRK_SLOT_ZAP_ALL |		\
+	 KVM_X86_QUIRK_STUFF_FEATURE_MSRS)
 
 /*
  * KVM previously used a u32 field in kvm_run to indicate the hypercall was
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -440,6 +440,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
+#define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1389,7 +1389,9 @@ static void __svm_vcpu_reset(struct kvm_
 	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
 	svm_init_osvw(vcpu);
-	vcpu->arch.microcode_version = 0x01000065;
+
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+		vcpu->arch.microcode_version = 0x01000065;
 	svm->tsc_ratio_msr = kvm_caps.default_tsc_scaling_ratio;
 
 	svm->nmi_masked = false;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4562,7 +4562,8 @@ vmx_adjust_secondary_exec_control(struct
 	 * Update the nested MSR settings so that a nested VMM can/can't set
 	 * controls for features that are/aren't exposed to the guest.
 	 */
-	if (nested) {
+	if (nested &&
+	    kvm_check_has_quirk(vmx->vcpu.kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
 		/*
 		 * All features that can be added or removed to VMX MSRs must
 		 * be supported in the first place for nested virtualization.
@@ -4853,7 +4854,8 @@ static void __vmx_vcpu_reset(struct kvm_
 
 	init_vmcs(vmx);
 
-	if (nested)
+	if (nested &&
+	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
 
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
@@ -4866,7 +4868,8 @@ static void __vmx_vcpu_reset(struct kvm_
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 #endif
 
-	vcpu->arch.microcode_version = 0x100000000ULL;
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
+		vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
 
 	/*
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12383,9 +12383,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 
 	kvm_async_pf_hash_reset(vcpu);
 
-	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
-	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
-	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS)) {
+		vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+		vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
+		vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
+	}
 	kvm_pmu_init(vcpu);
 
 	vcpu->arch.pending_external_vector = -1;


