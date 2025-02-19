Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E731F5854;
	Wed, 19 Feb 2025 08:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954795; cv=none; b=tK91HtIOrdH1HFfAuRLRM6A4Xj5RVufz8w707dzGgurcVDKgIPyTwDfBSy6BIrg30BFZ7wfgW4ESvxPAHjM8y5Z6zM10RwJht3OXyUk+44ScxFCnqcdghMIzn1p6VMCnbJBjloH4KvzR41l6e5TWaR1Lj6BQ13jY7sHmEzhWC1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954795; c=relaxed/simple;
	bh=k5BEWrtIUnKzD4ugrz9BPrMqiaI98k8NjveABX/YPcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob9qX7kdwn3NsWPc/Yx3VRuZVIPkTSO+q0FjfDPPTXbvW1MJSw8IMiD5BsIa9p2qowwjJIF4ngO3vRse/hOAST5PChU7YgvszhWlowEQSCVK4gXRJsYzBvh90OWAHfSU/ilFGs5+EofKUzOAjujSVfoM4hgpoKfg3p6+8kY/bHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6YENkfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6YENkfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9550C4CEE7;
	Wed, 19 Feb 2025 08:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954795;
	bh=k5BEWrtIUnKzD4ugrz9BPrMqiaI98k8NjveABX/YPcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6YENkfzwQltQEB+qOvZnKpZzqmZ0s3l1Ds5y38dKdlR7ezs0vLGRLvRBtpBg3aQa
	 B+guEbohYkUexC9VwtxtiNxBdPwdIwEkxvKXL7H++U9kL1uugKmyU5wQXCDzQ9jp9T
	 cgouQdmJLwHLpcmFvxUuO9FMiEnXFav8eHBOolcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/230] perf/x86/intel: Clean up PEBS-via-PT on hybrid
Date: Wed, 19 Feb 2025 09:25:56 +0100
Message-ID: <20250219082603.240160811@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 0a5561501397e2bbd0fb0e300eb489f72a90597a ]

The PEBS-via-PT feature is exposed for the e-core of some hybrid
platforms, e.g., ADL and MTL. But it never works.

$ dmesg | grep PEBS
[    1.793888] core: cpu_atom PMU driver: PEBS-via-PT

$ perf record -c 1000 -e '{intel_pt/branch=0/,
cpu_atom/cpu-cycles,aux-output/pp}' -C8
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument)
for event (cpu_atom/cpu-cycles,aux-output/pp).
"dmesg | grep -i perf" may provide additional information.

The "PEBS-via-PT" is printed if the corresponding bit of per-PMU
capabilities is set. Since the feature is supported by the e-core HW,
perf sets the bit for e-core. However, for Intel PT, if a feature is not
supported on all CPUs, it is not supported at all. The PEBS-via-PT event
cannot be created successfully.

The PEBS-via-PT is no longer enumerated on the latest hybrid platform. It
will be deprecated on future platforms with Arch PEBS. Let's remove it
from the existing hybrid platforms.

Fixes: d9977c43bff8 ("perf/x86: Register hybrid PMUs")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250129154820.3755948-2-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 10 ----------
 arch/x86/events/intel/ds.c   | 10 +++++++++-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index f558be868a50b..412b8ecce522f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4901,11 +4901,6 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 	else
 		pmu->intel_ctrl &= ~(1ULL << GLOBAL_CTRL_EN_PERF_METRICS);
 
-	if (pmu->intel_cap.pebs_output_pt_available)
-		pmu->pmu.capabilities |= PERF_PMU_CAP_AUX_OUTPUT;
-	else
-		pmu->pmu.capabilities &= ~PERF_PMU_CAP_AUX_OUTPUT;
-
 	intel_pmu_check_event_constraints(pmu->event_constraints,
 					  pmu->cntr_mask64,
 					  pmu->fixed_cntr_mask64,
@@ -4974,9 +4969,6 @@ static bool init_hybrid_pmu(int cpu)
 
 	pr_info("%s PMU driver: ", pmu->name);
 
-	if (pmu->intel_cap.pebs_output_pt_available)
-		pr_cont("PEBS-via-PT ");
-
 	pr_cont("\n");
 
 	x86_pmu_show_pmu_cap(&pmu->pmu);
@@ -6284,11 +6276,9 @@ static __always_inline int intel_pmu_init_hybrid(enum hybrid_pmu_type pmus)
 		pmu->intel_cap.capabilities = x86_pmu.intel_cap.capabilities;
 		if (pmu->pmu_type & hybrid_small) {
 			pmu->intel_cap.perf_metrics = 0;
-			pmu->intel_cap.pebs_output_pt_available = 1;
 			pmu->mid_ack = true;
 		} else if (pmu->pmu_type & hybrid_big) {
 			pmu->intel_cap.perf_metrics = 1;
-			pmu->intel_cap.pebs_output_pt_available = 0;
 			pmu->late_ack = true;
 		}
 	}
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 19a9fd974e3e1..b6303b0224531 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2523,7 +2523,15 @@ void __init intel_ds_init(void)
 			}
 			pr_cont("PEBS fmt4%c%s, ", pebs_type, pebs_qual);
 
-			if (!is_hybrid() && x86_pmu.intel_cap.pebs_output_pt_available) {
+			/*
+			 * The PEBS-via-PT is not supported on hybrid platforms,
+			 * because not all CPUs of a hybrid machine support it.
+			 * The global x86_pmu.intel_cap, which only contains the
+			 * common capabilities, is used to check the availability
+			 * of the feature. The per-PMU pebs_output_pt_available
+			 * in a hybrid machine should be ignored.
+			 */
+			if (x86_pmu.intel_cap.pebs_output_pt_available) {
 				pr_cont("PEBS-via-PT, ");
 				x86_get_pmu(smp_processor_id())->capabilities |= PERF_PMU_CAP_AUX_OUTPUT;
 			}
-- 
2.39.5



