Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DEEFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290F6C433EF;
	Mon, 15 May 2023 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170101;
	bh=lYCzdL/Bs40Teo8vzvul1DOBphQV5bySYPgIEV13UXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LsEQ6Rk2VJfmyiRvsDL/UsmP3VCy+bZDibWlz9JN2t+lHQH9H0Bg3ntZJbOI+R627
	 2EAO22JemWcCtntYc7B4kf7kealcPL4B4StjF6TbpSskWfPA+FOA+2zsFyf+12t5OZ
	 EIML4kF9zo+FnqM20POUCpwEPhsS8ePEAkVDd3Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Like Xu <likexu@tencent.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/239] KVM: x86: Track supported PERF_CAPABILITIES in kvm_caps
Date: Mon, 15 May 2023 18:24:30 +0200
Message-Id: <20230515161721.794333551@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit bec46859fb9d797a21c983100b1f425bebe89747 ]

Track KVM's supported PERF_CAPABILITIES in kvm_caps instead of computing
the supported capabilities on the fly every time.  Using kvm_caps will
also allow for future cleanups as the kvm_caps values can be used
directly in common x86 code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Like Xu <likexu@tencent.com>
Message-Id: <20221006000314.73240-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 098f4c061ea1 ("KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs are available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/capabilities.h | 25 ------------------------
 arch/x86/kvm/vmx/pmu_intel.c    |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 34 +++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9599931c7d572..fc1649b5931a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2709,6 +2709,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
+		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
@@ -4888,6 +4889,7 @@ static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
 
+	kvm_caps.supported_perf_cap = 0;
 	kvm_caps.supported_xss = 0;
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 479124e49bbda..cd2ac9536c998 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -395,31 +395,6 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
-{
-	u64 perf_cap = PMU_CAP_FW_WRITES;
-	struct x86_pmu_lbr lbr;
-	u64 host_perf_cap = 0;
-
-	if (!enable_pmu)
-		return 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
-
-	x86_perf_get_lbr(&lbr);
-	if (lbr.nr)
-		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
-
-	if (vmx_pebs_supported()) {
-		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
-		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
-			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
-	}
-
-	return perf_cap;
-}
-
 static inline bool cpu_has_notify_vmexit(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10b33da9bd058..9fabfe71fd879 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -631,7 +631,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].current_config = 0;
 	}
 
-	vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();
+	vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
 	lbr_desc->records.nr = 0;
 	lbr_desc->event = NULL;
 	lbr_desc->msr_passthrough = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4c9116d223df5..8ad5992f61340 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1879,7 +1879,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	case MSR_IA32_PERF_CAPABILITIES:
-		msr->data = vmx_get_perf_capabilities();
+		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
 		return KVM_MSR_RET_INVALID;
@@ -2058,7 +2058,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
-	if ((vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT) &&
+	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
@@ -2371,14 +2371,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		if (data & PMU_CAP_LBR_FMT) {
 			if ((data & PMU_CAP_LBR_FMT) !=
-			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
+			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		if (data & PERF_CAP_PEBS_FORMAT) {
 			if ((data & PERF_CAP_PEBS_MASK) !=
-			    (vmx_get_perf_capabilities() & PERF_CAP_PEBS_MASK))
+			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
 				return 1;
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
 				return 1;
@@ -7702,6 +7702,31 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vmx_update_exception_bitmap(vcpu);
 }
 
+static u64 vmx_get_perf_capabilities(void)
+{
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	struct x86_pmu_lbr lbr;
+	u64 host_perf_cap = 0;
+
+	if (!enable_pmu)
+		return 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	x86_perf_get_lbr(&lbr);
+	if (lbr.nr)
+		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+
+	if (vmx_pebs_supported()) {
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
+			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
+	}
+
+	return perf_cap;
+}
+
 static __init void vmx_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -7724,6 +7749,7 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (!enable_pmu)
 		kvm_cpu_cap_clear(X86_FEATURE_PDCM);
+	kvm_caps.supported_perf_cap = vmx_get_perf_capabilities();
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 829d3134c1eb0..9de72586f4065 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -27,6 +27,7 @@ struct kvm_caps {
 	u64 supported_mce_cap;
 	u64 supported_xcr0;
 	u64 supported_xss;
+	u64 supported_perf_cap;
 };
 
 void kvm_spurious_fault(void);
-- 
2.39.2



