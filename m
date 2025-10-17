Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A92745E;
	Fri, 17 Oct 2025 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713942; cv=none; b=cE7OGcFGMG5T8TdTsHBGwoWQzgJ2OqNR8j8HqCwOQ8mJtO+dfUSOzrxo+4MQuXX6WK8Ulu0j/sI70S2SUoL2YWFD+r1hFXNbRDDOyeUZCNWjfcQ2pxUwLPjNxqTvUdrV/GcKukR+zmK6Emp5W7HRuQFNGGZ8iQoVhIQCB+EH9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713942; c=relaxed/simple;
	bh=JXUBHKIzoiHphxfahWqIl7GT/hWFipRe9O9dwN5fuOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOJkNWSFw6Dzi1RsVIoqHb33/fJcwfrhCP/aIi/IrEoMs929jIGv8rizOm+mi3lO9H3f1d219O1GW2/5HuSnLr2jLKfIDLpJvQ83BnzL5BATWB5LE8YG1GnlRoTqgGUPDfn/nzKHuVJEBrA/nQ7jLzVxWwKmMpAj02qwSy8EpJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+eVRBBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+eVRBBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011B0C4CEFE;
	Fri, 17 Oct 2025 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713942;
	bh=JXUBHKIzoiHphxfahWqIl7GT/hWFipRe9O9dwN5fuOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+eVRBBlF8bZzpOKlB0FSKF52cc7E26dRpEzm+1UHrqwHyyQXVmeeTtEUVORaONFJ
	 hTlHtO4EOFgsB88ppl3JZz5v9a7FDaF+SIXbedZrksVZLaMINvHNBgL7lX6hzj/0vR
	 yqdC9JS2JcptYdZfi3lRp2u6PRD5W9qlRSOMT3Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/201] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
Date: Fri, 17 Oct 2025 16:53:54 +0200
Message-ID: <20251017145141.097999552@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 68e61f6fd65610e73b17882f86fedfd784d99229 ]

Emulate PERF_CNTR_GLOBAL_STATUS_SET when PerfMonV2 is enumerated to the
guest, as the MSR is supposed to exist in all AMD v2 PMUs.

Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
Cc: stable@vger.kernel.org
Cc: Sandipan Das <sandipan.das@amd.com>
Link: https://lore.kernel.org/r/20250711172746.1579423-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[ changed global_status_rsvd field to global_status_mask ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kvm/pmu.c               |    5 +++++
 arch/x86/kvm/svm/pmu.c           |    1 +
 arch/x86/kvm/x86.c               |    2 ++
 4 files changed, 9 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -661,6 +661,7 @@
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
 #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET	0xc0000303
 
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -588,6 +588,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcp
 		msr_info->data = pmu->global_ctrl;
 		break;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		break;
@@ -649,6 +650,10 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcp
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
+		if (!msr_info->host_initiated)
+			pmu->global_status |= data & ~pmu->global_status_mask;
+		break;
 	default:
 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -117,6 +117,7 @@ static bool amd_is_valid_msr(struct kvm_
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 		return pmu->version > 1;
 	default:
 		if (msr > MSR_F15H_PERF_CTR5 &&
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1495,6 +1495,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
 	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
 	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
@@ -7194,6 +7195,7 @@ static void kvm_probe_msr_to_save(u32 ms
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 		if (!kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
 			return;
 		break;


