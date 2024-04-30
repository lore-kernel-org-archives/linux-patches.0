Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E300C12CD90;
	Tue, 30 Apr 2024 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475443; cv=none; b=Zs6XcclImXk7m+MYWRWRYbigz7wdosjoapupPfa7lFUiHtEjL9POBAupGX+L8ftbHAAjSVIdyzeVyQebX8J3IDeB0UmgIa4bipFp3cxbEYaJrl6xNSW9E4U6w6V9v/4ThRmt4WhaSvAWkfNnjTPYlH4qaIAahcY8bGXijjes07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475443; c=relaxed/simple;
	bh=kJpBOzvmxtbZOl9SZ/bJnquaxGEkVz/CX+2LeMKd8mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDz/NdifvHRcyM78+ory9oxnU+hri+16MEtHhIJ23AmuwvZ9z90hsqT+eK20/vPiArmMgOVvb3jcgQn8TrwKoXzZs0n5nKWuZSFgP9+1ra76SP3IBs8gYR+J3j9rNXkmIKgE0DjRrd4ewcgqL5hlhrg1ss+2IqA+1S49lfNwvn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCOr9QgQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCOr9QgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB48C2BBFC;
	Tue, 30 Apr 2024 11:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475442;
	bh=kJpBOzvmxtbZOl9SZ/bJnquaxGEkVz/CX+2LeMKd8mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCOr9QgQDRnMezZ4hw5Nhjl4tZhSbSmbUaZHYv65U+vjadEwX2fOt+mggYPnDAT1b
	 qLTv3FBGbD585Y1UFqwSVK8Td6gSODjyHzeS1iOLiYaWEqRbvwtVo/XJyJpYpskLZw
	 FACSoUkncW5RflJMd4yyH+oDc5HjQeIRSel5rTFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/186] KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
Date: Tue, 30 Apr 2024 12:39:08 +0200
Message-ID: <20240430103100.820071742@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit f933b88e20150f15787390e2a1754a7e412754ed ]

Move the purging of common PMU metadata from intel_pmu_refresh() to
kvm_pmu_refresh(), and invoke the vendor refresh() hook if and only if
the VM is supposed to have a vPMU.

KVM already denies access to the PMU based on kvm->arch.enable_pmu, as
get_gp_pmc_amd() returns NULL for all PMCs in that case, i.e. KVM already
violates AMD's architecture by not virtualizing a PMU (kernels have long
since learned to not panic when the PMU is unavailable).  But configuring
the PMU as if it were enabled causes unwanted side effects, e.g. calls to
kvm_pmu_trigger_event() waste an absurd number of cycles due to the
all_valid_pmc_idx bitmap being non-zero.

Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
Reported-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Closes: https://lore.kernel.org/all/20231109180646.2963718-2-khorenko@virtuozzo.com
Link: https://lore.kernel.org/r/20231110022857.1273836-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: de120e1d692d ("KVM: x86/pmu: Set enable bits for GP counters in PERF_GLOBAL_CTRL at "RESET"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c           | 20 ++++++++++++++++++--
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++--------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index dc8e8e907cfbf..fa6f5cd70d4c8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -691,6 +691,8 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
 		return;
 
@@ -700,8 +702,22 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 	 */
 	kvm_pmu_reset(vcpu);
 
-	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
-	static_call(kvm_x86_pmu_refresh)(vcpu);
+	pmu->version = 0;
+	pmu->nr_arch_gp_counters = 0;
+	pmu->nr_arch_fixed_counters = 0;
+	pmu->counter_bitmask[KVM_PMC_GP] = 0;
+	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
+	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
+	pmu->global_ctrl_mask = ~0ull;
+	pmu->global_status_mask = ~0ull;
+	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
+	pmu->pebs_data_cfg_mask = ~0ull;
+	bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+
+	if (vcpu->kvm->arch.enable_pmu)
+		static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1549461fa42b7..48a2f77f62ef3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -493,19 +493,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	u64 counter_mask;
 	int i;
 
-	pmu->nr_arch_gp_counters = 0;
-	pmu->nr_arch_fixed_counters = 0;
-	pmu->counter_bitmask[KVM_PMC_GP] = 0;
-	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
-	pmu->version = 0;
-	pmu->reserved_bits = 0xffffffff00200000ull;
-	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
-	pmu->global_ctrl_mask = ~0ull;
-	pmu->global_status_mask = ~0ull;
-	pmu->fixed_ctr_ctrl_mask = ~0ull;
-	pmu->pebs_enable_mask = ~0ull;
-	pmu->pebs_data_cfg_mask = ~0ull;
-
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
 
 	/*
@@ -517,8 +504,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		return;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry)
 		return;
+
 	eax.full = entry->eax;
 	edx.full = entry->edx;
 
-- 
2.43.0



