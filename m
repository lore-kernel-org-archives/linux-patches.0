Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1442E2DAFD8;
	Fri, 17 Oct 2025 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714865; cv=none; b=gDvR71yAWMsK5dC+RXB15xdwvERSUaJ69HD8mhMdvyxUgbFBVa9YX7wHVb8vLl71mEnmBTsvUo1XleEy2XQfClqaFT/HuU9QICwpwksrz7sAp6Uv83Cjna1spKw/WTMYoL9MvQba7JW547sMxxhUTEV+Ol38o9acFTBdVXYd+xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714865; c=relaxed/simple;
	bh=trJU0tbtha9Yf5wW3mxClFppf2FeXzenQAcb//MaJPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX0gRX/SVasXb8Jn2GKgMTYaHPwQyZD0G9wad0LrcUqocq3a0O4WZn1iwe+eaV6vRT9LJ8/jUAlTpzBuUt791wWGCqWEUHV/JWjoPQ81Qpitmv1M4WB+M6I4/KQmm4DoGfFuqbHwUWKhmrlPYi/pDSXJ9+O0nHjj+pz24VqOmDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9qSxi7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9qSxi7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B73C4CEE7;
	Fri, 17 Oct 2025 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714864;
	bh=trJU0tbtha9Yf5wW3mxClFppf2FeXzenQAcb//MaJPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9qSxi7zg53XIRSDVX+Nlm9sn9IIg0873oU+VKMTuClp2shmgcYG4KR6LjL9vueSj
	 czl4E6xBvjk88mZS3XOBqqZXYt4mUvuQ1gm8Ulfny3Am9JGQzECoDsEP6lZ+OJFPxL
	 eROLUoNls4GWZ/N65+tNR0Bos6AS4NfBLPk4hwgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.17 016/371] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
Date: Fri, 17 Oct 2025 16:49:51 +0200
Message-ID: <20251017145202.386121992@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 68e61f6fd65610e73b17882f86fedfd784d99229 upstream.

Emulate PERF_CNTR_GLOBAL_STATUS_SET when PerfMonV2 is enumerated to the
guest, as the MSR is supposed to exist in all AMD v2 PMUs.

Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
Cc: stable@vger.kernel.org
Cc: Sandipan Das <sandipan.das@amd.com>
Link: https://lore.kernel.org/r/20250711172746.1579423-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kvm/pmu.c               |    5 +++++
 arch/x86/kvm/svm/pmu.c           |    1 +
 arch/x86/kvm/x86.c               |    2 ++
 4 files changed, 9 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -733,6 +733,7 @@
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
 #define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
 #define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET	0xc0000303
 
 /* AMD Hardware Feedback Support MSRs */
 #define MSR_AMD_WORKLOAD_CLASS_CONFIG		0xc0000500
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -650,6 +650,7 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcp
 		msr_info->data = pmu->global_ctrl;
 		break;
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		break;
@@ -711,6 +712,10 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcp
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
 		break;
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
+		if (!msr_info->host_initiated)
+			pmu->global_status |= data & ~pmu->global_status_rsvd;
+		break;
 	default:
 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 		return kvm_pmu_call(set_msr)(vcpu, msr_info);
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -113,6 +113,7 @@ static bool amd_is_valid_msr(struct kvm_
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 		return pmu->version > 1;
 	default:
 		if (msr > MSR_F15H_PERF_CTR5 &&
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -367,6 +367,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
 	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
 	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR,
+	MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET,
 };
 
 static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
@@ -7359,6 +7360,7 @@ static void kvm_probe_msr_to_save(u32 ms
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
+	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
 		if (!kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
 			return;
 		break;


