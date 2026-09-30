Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA08F4F5E18;
	Wed, 30 Sep 2026 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792764; cv=none; b=lIYZwbmugmq/pCRnsdm8XJF0rZ3WSZS3JMnyGhJlXrzmVxHtCDg6ay76e9xDntvyzB1+MxsbCPmq+K9btIBdOpfrhAskEAB5eFMjbxqWrV6pRUEXiYipoiroUIUn2iTDG16QNI0u7eSOXL15irLyT9vz828GokzDdjCCZSOmVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792764; c=relaxed/simple;
	bh=Z5Ca4WrDvAPjxAqzCvNkPEzNLKJN9rHI4LX+THGs4Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAOoOlKpci6AmuwO840vzE/OK6dUyvS0YkLOrYQWzJlLudzwbo3Thsm04/7x8DluJvqX+u939CSSMl6Zzybw6Amdky5ifh3lCutpfzuKixu6m37EZm80HYL7S8iXahEn/Nb3MpOhqk8WJTDU8u/YknX1yNLy3/oJTyXwzaYqtYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOL4aytf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOL4aytf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8921F000FF;
	Wed, 30 Sep 2026 18:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792763;
	bh=rqwRFvqziEhBSbbXGI42kJEuAoyTdD6Q6hlO0ze9Mec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOL4aytf9gzp8kEojMYyZqiMfVelk3ZVobFwA25peGu1Wx2ioz0JBYnuKVCMPNM3s
	 cupemrpj2x/9T5EFz/QnJdNq2Dadg7WzOGgOgJwb1k+3pmrGqE4GTFQUDzW5CrQTh+
	 cjCgRl/TATm4k8QzAE+wsvxhM2ho75IYZ0Bnjui0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Like Xu <likexu@tencent.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/395] KVM: x86/pmu: Move Intel PMU global MSRs to intel_is_valid_msr()
Date: Wed, 30 Sep 2026 17:24:40 +0200
Message-ID: <20260930152341.012375936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 79a71cc2568f4b5d42284da2aa26f3b4f47ce01b ]

Commit c85cdc1cc1ea ("KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and
friends to common x86") moved the existence check for the following Intel
PMU MSRs to kvm_pmu_is_valid_msr():
 - MSR_CORE_PERF_GLOBAL_STATUS
 - MSR_CORE_PERF_GLOBAL_CTRL
 - MSR_CORE_PERF_GLOBAL_OVF_CTRL

That commit deemed these MSRs valid whenever pmu->version > 1. It intended
to share the check with AMD PerfMonV2 because both vendor implementations
require version 2 or greater for global PMU controls.  However, as noted in
the commit message, AMD uses different MSR indices for its global PMU
registers.

Commit 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
subsequently added AMD PerfMonV2 support and set pmu->version = 2.  Because
kvm_pmu_is_valid_msr() validated the Intel MSRs whenever pmu->version > 1,
KVM incorrectly permitted AMD guests with PerfMonV2 to access these Intel
MSRs without a #GP.

Move the validation of these Intel MSRs to intel_is_valid_msr() and remove
the common switch statement from kvm_pmu_is_valid_msr(). AMD already
validates its own global PMU MSRs in amd_is_valid_msr().

Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Link: https://patch.msgid.link/20260902184711.138538-1-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c           | 8 --------
 arch/x86/kvm/vmx/pmu_intel.c | 3 +++
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 487ad19a236e3..31b2b75156dbf 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -710,14 +710,6 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
-	switch (msr) {
-	case MSR_CORE_PERF_GLOBAL_STATUS:
-	case MSR_CORE_PERF_GLOBAL_CTRL:
-	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		return kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu));
-	default:
-		break;
-	}
 	return kvm_pmu_call(msr_idx_to_pmc)(vcpu, msr) ||
 	       kvm_pmu_call(is_valid_msr)(vcpu, msr);
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 333d7c573d40a..a9d21a97c9621 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -190,6 +190,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	int ret;
 
 	switch (msr) {
+	case MSR_CORE_PERF_GLOBAL_STATUS:
+	case MSR_CORE_PERF_GLOBAL_CTRL:
+	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		return kvm_pmu_has_perf_global_ctrl(pmu);
 	case MSR_IA32_PEBS_ENABLE:
-- 
2.53.0



