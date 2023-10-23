Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA1814A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFBDmiKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7DDC433C7;
	Mon, 23 Oct 2023 11:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058971;
	bh=2poGV2HlnzEkYALeEmU1slHSdYL5wQ59aDehi+wFPqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFBDmiKMnr1YeadAqrsuAziIzK237hBqG52i7nB+/o9iFh8hUckTQjsfkbzxTaCBL
	 qvbrT7GkQV2q/W8PDRJbH4F4P7mA0hOv0QgHTb9iXmdjmEqDdSCqXe2JyumBXkofI2
	 DSA8vXnSMcgbzywv/OrrWtd/Rb0aNzzpKPMe5p7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kagan <rkagan@amazon.de>,
	Like Xu <likexu@tencent.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.5 020/241] KVM: x86/pmu: Truncate counter value to allowed width on write
Date: Mon, 23 Oct 2023 12:53:26 +0200
Message-ID: <20231023104834.421583525@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kagan <rkagan@amazon.de>

commit b29a2acd36dd7a33c63f260df738fb96baa3d4f8 upstream.

Performance counters are defined to have width less than 64 bits.  The
vPMU code maintains the counters in u64 variables but assumes the value
to fit within the defined width.  However, for Intel non-full-width
counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
truncated to 32 bits and then sign-extended to full 64 bits.  If a
negative value is set, it's sign-extended to 64 bits, but then in
kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
previous value for overflow detection.

That previous value is not truncated, so it always evaluates bigger than
the truncated new one, and a PMI is injected.  If the PMI handler writes
a negative counter value itself, the vCPU never quits the PMI loop.

Turns out that Linux PMI handler actually does write the counter with
the value just read with RDPMC, so when no full-width support is exposed
via MSR_IA32_PERF_CAPABILITIES, and the guest initializes the counter to
a negative value, it locks up.

This has been observed in the field, for example, when the guest configures
atop to use perfevents and runs two instances of it simultaneously.

To address the problem, maintain the invariant that the counter value
always fits in the defined bit width, by truncating the received value
in the respective set_msr methods.  For better readability, factor the
out into a helper function, pmc_write_counter(), shared by vmx and svm
parts.

Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Cc: stable@vger.kernel.org
Signed-off-by: Roman Kagan <rkagan@amazon.de>
Link: https://lore.kernel.org/all/20230504120042.785651-1-rkagan@amazon.de
Tested-by: Like Xu <likexu@tencent.com>
[sean: tweak changelog, s/set/write in the helper]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/pmu.h           |    6 ++++++
 arch/x86/kvm/svm/pmu.c       |    2 +-
 arch/x86/kvm/vmx/pmu_intel.c |    4 ++--
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -74,6 +74,12 @@ static inline u64 pmc_read_counter(struc
 	return counter & pmc_bitmask(pmc);
 }
 
+static inline void pmc_write_counter(struct kvm_pmc *pmc, u64 val)
+{
+	pmc->counter += val - pmc_read_counter(pmc);
+	pmc->counter &= pmc_bitmask(pmc);
+}
+
 static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
 {
 	if (pmc->perf_event) {
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -160,7 +160,7 @@ static int amd_pmu_set_msr(struct kvm_vc
 	/* MSR_PERFCTRn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
-		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_write_counter(pmc, data);
 		pmc_update_sample_period(pmc);
 		return 0;
 	}
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -406,11 +406,11 @@ static int intel_pmu_set_msr(struct kvm_
 			if (!msr_info->host_initiated &&
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
-			pmc->counter += data - pmc_read_counter(pmc);
+			pmc_write_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
-			pmc->counter += data - pmc_read_counter(pmc);
+			pmc_write_counter(pmc, data);
 			pmc_update_sample_period(pmc);
 			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {


