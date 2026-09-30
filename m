Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DDC519E1E;
	Wed, 30 Sep 2026 17:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789083; cv=none; b=iVt36UTVyOiuam4cCzliSyXsFd/609YymZeaHwP8aku1mBDnroftbBnQCFOYedqmR3rjR8rvQRPMdpBh+q5lVWCfezKIkXGB4nY/6hAxobrg9iAkBQEmaqd3P7IOT6cYkU8gVbSUl0snL07UQRsJ8lRf+u2cfZD6R4a7HZLJDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789083; c=relaxed/simple;
	bh=t9rQy1eWlK+ZUXT0gT2sOJvupaXxnQ/1EhuYN+b4yCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDSxh8NZs3dIhPbFFu+zqGooqLklMRUjWlMnHUANbxNoiWY4d7Jd9xkEV0X4iZ989lvg4NcapqNpWtsloow3BYog5Sk85ErIK3gr+8pXBcLu9gfnBjP6J6WJXnIhdM2ESlac6AbkJpwk45fFKhBN3v3VCAoJH8MEC7p9llZN3vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj0x2c/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj0x2c/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572B21F000FF;
	Wed, 30 Sep 2026 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789081;
	bh=xK92rSSjlrdJaKBtX7YvvlJR77TKthWsP8Gi9vbEUUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qj0x2c/WzAtncZ9uJfBD0DAlpLhkxus4DSRR7vUhFcAPpnOV6zWzDvy/87OE6YgjS
	 iu4qrkcCHa/eEVJ7GjKbNF+neMsV79fu8J2i6z9+sNX+O5btPRUACvrrxvd8ox8+R9
	 CqXn9Q2WzZoaWXaBtejsjPybDfcfvxtu05GVgtEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Like Xu <likexu@tencent.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/877] KVM: x86/pmu: Move Intel PMU global MSRs to intel_is_valid_msr()
Date: Wed, 30 Sep 2026 17:20:19 +0200
Message-ID: <20260930152421.342699140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index a26e8f5ad7901..a0efe59aa0794 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -614,14 +614,6 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
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
index a5edc623166ac..4f6fa564028f8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -154,6 +154,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
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



