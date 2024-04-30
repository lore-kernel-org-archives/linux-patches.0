Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDFC12C487;
	Tue, 30 Apr 2024 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474327; cv=none; b=m9VM14qtI+l2Az0eGH0F/G5eM05LZv9WKR2am0+Oe98wN922C1RrJgq7ezCL3rsCK3hUPQ6gg3ySH6abPqdQ90ZbkTcdFNQgrnny7TMkK3QoFNBi+SCdBEVHNfMqowEs7xAah3DFXlATJe+T2X5XrdyFGd9tXuUoEsPpip0Sc/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474327; c=relaxed/simple;
	bh=C5xIJH3WtbaMjGskFKiG69gyq7wNCB8b0kvUYGocuCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fumERIf2m1MA3kmSnXvnjCckb/SJDa3COs6ztbE56GaNiHVeAJf2a+OrJaSz/QUfmRBOo6uz2oocOVfE7rmK+TZVBKU+EELClSO2Tu3mf8xGHgIvWXQA28erl5DFrrU/I7HihdXf/KCa/mQsUssuIlSiB1kyYnQ57KNKgS7j92Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ec20zXfF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ec20zXfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B03C2BBFC;
	Tue, 30 Apr 2024 10:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474326;
	bh=C5xIJH3WtbaMjGskFKiG69gyq7wNCB8b0kvUYGocuCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ec20zXfF2J2Oe6p7o1xcf/2Y9rv05yEf53eXqx3lKeTFmA70vX5CswgrON9wsVKWv
	 7qKE2A0EagOb6MMoUVAieON/A8nv9fSagnklvPOWTatwGjYBzEkrKXO6LrV2RdrW3q
	 TOPOQ9wq3jD0qkqdaDa7CdqSSadhJo4wCui0LZSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 124/228] KVM: x86/pmu: Zero out PMU metadata on AMD if PMU is disabled
Date: Tue, 30 Apr 2024 12:38:22 +0200
Message-ID: <20240430103107.385297493@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 87cc6c8809ad8..38512954ec267 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -741,6 +741,8 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
 	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
 		return;
 
@@ -750,8 +752,22 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
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
index 315c7c2ba89b1..600a021ae958b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -491,19 +491,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
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
@@ -515,8 +502,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
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



