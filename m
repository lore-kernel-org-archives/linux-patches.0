Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C223DB;
	Tue, 23 Jan 2024 00:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969842; cv=none; b=gZua7uJnTomwx5KLEX3zSfisWClXlWFQmYRpOBV5Ygik/DEosTqhP8EUFOfLlfxehEv6Nn8GR7mufQbSn6/1DbbEclqnW+2IxPPjdeqKVMrg32zn9LsTWjXr4klG0r7u+IjfLg6yKq8ddoqTGCgS3i5kdLNUtCGiy+nSXb5jOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969842; c=relaxed/simple;
	bh=KCUbabQrJFXUHPGR2VPyzRYA3V75BBNeaVLaP1C3SiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2JbNyyuc101pzL4Lb27hKX+WpTn9fWJQnDz3pDnQWJ7fN5tD58gKij99AFsynmVH4rYbH7buaVlFnqY2eDkUwJ4+0EUR6//8lSZHyqTbC2DWdkAeB5jK6yUSVqk+/JiHMhPJghDV47N82T9WkFtN1TV8+8IT7sfPUrh4HKakx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccDeXIFx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccDeXIFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E263C433F1;
	Tue, 23 Jan 2024 00:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969842;
	bh=KCUbabQrJFXUHPGR2VPyzRYA3V75BBNeaVLaP1C3SiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccDeXIFxAkwDD/aV5J22sfTOkZGPg3dVD9MyPCL0UTiE9yDOTp8vXjYzxphMBjMse
	 qvAW66OcENGpwpU/OdEFwa7e4pcrya26tILoW0VxytuR50L42Tia6XWBPZn6K+uvrZ
	 K9yGNlqYFnV4+Y1NbXRaoVSRaQ/1v09R7ClOvXM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.7 474/641] KVM: x86/pmu: Move PMU reset logic to common x86 code
Date: Mon, 22 Jan 2024 15:56:18 -0800
Message-ID: <20240122235832.897381361@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit cbb359d81a2695bb5e63ec9de06fcbef28518891 upstream.

Move the common (or at least "ignored") aspects of resetting the vPMU to
common x86 code, along with the stop/release helpers that are no used only
by the common pmu.c.

There is no need to manually handle fixed counters as all_valid_pmc_idx
tracks both fixed and general purpose counters, and resetting the vPMU is
far from a hot path, i.e. the extra bit of overhead to the PMC from the
index is a non-issue.

Zero fixed_ctr_ctrl in common code even though it's Intel specific.
Ensuring it's zero doesn't harm AMD/SVM in any way, and stopping the fixed
counters via all_valid_pmc_idx, but not clearing the associated control
bits, would be odd/confusing.

Make the .reset() hook optional as SVM no longer needs vendor specific
handling.

Cc: stable@vger.kernel.org
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://lore.kernel.org/r/20231103230541.352265-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |    2 -
 arch/x86/kvm/pmu.c                     |   40 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/pmu.h                     |   18 --------------
 arch/x86/kvm/svm/pmu.c                 |   16 -------------
 arch/x86/kvm/vmx/pmu_intel.c           |   20 ----------------
 5 files changed, 40 insertions(+), 56 deletions(-)

--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -22,7 +22,7 @@ KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
 KVM_X86_PMU_OP(refresh)
 KVM_X86_PMU_OP(init)
-KVM_X86_PMU_OP(reset)
+KVM_X86_PMU_OP_OPTIONAL(reset)
 KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
 KVM_X86_PMU_OP_OPTIONAL(cleanup)
 
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -250,6 +250,24 @@ static bool pmc_resume_counter(struct kv
 	return true;
 }
 
+static void pmc_release_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+		pmc->current_config = 0;
+		pmc_to_pmu(pmc)->event_count--;
+	}
+}
+
+static void pmc_stop_counter(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event) {
+		pmc->counter = pmc_read_counter(pmc);
+		pmc_release_perf_event(pmc);
+	}
+}
+
 static int filter_cmp(const void *pa, const void *pb, u64 mask)
 {
 	u64 a = *(u64 *)pa & mask;
@@ -654,7 +672,27 @@ void kvm_pmu_refresh(struct kvm_vcpu *vc
 
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	static_call(kvm_x86_pmu_reset)(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
+		if (!pmc)
+			continue;
+
+		pmc_stop_counter(pmc);
+		pmc->counter = 0;
+
+		if (pmc_is_gp(pmc))
+			pmc->eventsel = 0;
+	}
+
+	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
+
+	static_call_cond(kvm_x86_pmu_reset)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -80,24 +80,6 @@ static inline void pmc_write_counter(str
 	pmc->counter &= pmc_bitmask(pmc);
 }
 
-static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		perf_event_release_kernel(pmc->perf_event);
-		pmc->perf_event = NULL;
-		pmc->current_config = 0;
-		pmc_to_pmu(pmc)->event_count--;
-	}
-}
-
-static inline void pmc_stop_counter(struct kvm_pmc *pmc)
-{
-	if (pmc->perf_event) {
-		pmc->counter = pmc_read_counter(pmc);
-		pmc_release_perf_event(pmc);
-	}
-}
-
 static inline bool pmc_is_gp(struct kvm_pmc *pmc)
 {
 	return pmc->type == KVM_PMC_GP;
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -233,21 +233,6 @@ static void amd_pmu_init(struct kvm_vcpu
 	}
 }
 
-static void amd_pmu_reset(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	int i;
-
-	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
-		struct kvm_pmc *pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	pmu->global_ctrl = pmu->global_status = 0;
-}
-
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.hw_event_available = amd_hw_event_available,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
@@ -259,7 +244,6 @@ struct kvm_pmu_ops amd_pmu_ops __initdat
 	.set_msr = amd_pmu_set_msr,
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
-	.reset = amd_pmu_reset,
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_AMD_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -632,26 +632,6 @@ static void intel_pmu_init(struct kvm_vc
 
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *pmc = NULL;
-	int i;
-
-	for (i = 0; i < KVM_INTEL_PMC_MAX_GENERIC; i++) {
-		pmc = &pmu->gp_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = pmc->eventsel = 0;
-	}
-
-	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
-		pmc = &pmu->fixed_counters[i];
-
-		pmc_stop_counter(pmc);
-		pmc->counter = pmc->prev_counter = 0;
-	}
-
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
-
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
 


