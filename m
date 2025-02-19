Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A82B1C5F29;
	Wed, 19 Feb 2025 08:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953938; cv=none; b=CSiGlFAM3/4FLLPUG3Fm3ft5K9CWj4b0YV9yS1E9Hr6MqmMhvN2AKJ/6k0CATjWuAUd9YYJwg3p54f1935zOan67Y7YU6HY39i2406rFEEJCzSJULG2uRPdAckcspo9JS/ePWxVwAc/R838VAjMCM5w0zlJHXHf7ai1tJrl9dLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953938; c=relaxed/simple;
	bh=YBaqfexwn2jVIX0DkPwvZPdOkKF9+zwpXvzw8RJ72vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7G1MMVVN/WWDY/8yiocYJ3t2PFQDNSrGqckmUE7l5W8sJzA6xdselq+o7cqQj4X+PUADgfMY0pn2EChRuIOjd95pdxYWNIXV0dZllfbt6bXo7CLtZguGgeKTrV2w4RmuNInqYk+FCepEisEK1EFVdmD7pZbNh4DdRLIRmXrLRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NN3fu56s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NN3fu56s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2645C4CED1;
	Wed, 19 Feb 2025 08:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953938;
	bh=YBaqfexwn2jVIX0DkPwvZPdOkKF9+zwpXvzw8RJ72vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN3fu56s92SXp4OIYVYiqO9t8EdjMIuSOIWNpY8tC9mwyGRdkJ6bshGNhtR2ETJza
	 yCFPrqzBYThI7BsO97LuX9Io4B1dwJm6/QA+r6xieuR3/1aMmzTcJyMXihvL+IxxHq
	 5uFTblCXeA2aBJCPPPXJZe2cteEX9706KR0nivDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/274] perf/x86/intel: Clean up PEBS-via-PT on hybrid
Date: Wed, 19 Feb 2025 09:24:59 +0100
Message-ID: <20250219082611.286747977@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 99c590da0ae24..810d8c889f507 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4923,11 +4923,6 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
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
@@ -5005,9 +5000,6 @@ static bool init_hybrid_pmu(int cpu)
 
 	pr_info("%s PMU driver: ", pmu->name);
 
-	if (pmu->intel_cap.pebs_output_pt_available)
-		pr_cont("PEBS-via-PT ");
-
 	pr_cont("\n");
 
 	x86_pmu_show_pmu_cap(&pmu->pmu);
@@ -6362,11 +6354,9 @@ static __always_inline int intel_pmu_init_hybrid(enum hybrid_pmu_type pmus)
 		pmu->intel_cap.capabilities = x86_pmu.intel_cap.capabilities;
 		if (pmu->pmu_type & hybrid_small_tiny) {
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
index 6ba6549f26fac..cb0eca7347899 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2544,7 +2544,15 @@ void __init intel_ds_init(void)
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



