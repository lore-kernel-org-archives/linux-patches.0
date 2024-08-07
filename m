Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB1A23CE;
	Wed,  7 Aug 2024 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042886; cv=none; b=ft2gpEvniT6igGza/+mbk3lo8HSRXb5RwEKGk9KaDbOkK5t0oESWv8rDxo0I4fidarxMgEyzbML+kHRGqQgr3H5AauWL78wfyIkt7pj8aOHfVQ7Qrtdr/p8qjEi+DCHUpgZ1ts4scW43ZuPNrzoPijH/jd4vlHbT4wKgVarbQo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042886; c=relaxed/simple;
	bh=yaaibFyCEvYMpNHPT5yrzcFMTWMn9977OUlzVUTlyXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9nOQrt/6W+8lL6i6r6s3TzKPgJXjoZCzGcX6tYwcrqK6pvpDoWyjrEqZGYK9Dy1oWnYwKSe4ZlNQ/qnPcy//MCr4b15aE4NJfc/mQF0cH3BroOY4k9f3AC9aVCfp9P9H+J25NzZTsLXE1M0j+IDHGtwN5FTIiVoheXrr8EFtpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/5o9rYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/5o9rYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D66C32781;
	Wed,  7 Aug 2024 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042885;
	bh=yaaibFyCEvYMpNHPT5yrzcFMTWMn9977OUlzVUTlyXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/5o9rYn0n+yjX1vqxM/v72MiKLJrFGBSUggo5iAPCy/aKrZ0Jm6DcnzLfGDzIQJR
	 Af47G4kDqn5WRYZXX/wGy1EzmdOWdFBsspgEbvhdacUORugITwTkgfCeFFR1jcVrM2
	 rE2IjoTrVnM2G+MK9eccxL8QF7XWxXGvnEZ/P4QU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Yasin <ahmad.yasin@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 012/123] perf/x86/intel: Add a distinct name for Granite Rapids
Date: Wed,  7 Aug 2024 16:58:51 +0200
Message-ID: <20240807150021.220650648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit fa0c1c9d283b37fdb7fc1dcccbb88fc8f48a4aa4 ]

Currently, the Sapphire Rapids and Granite Rapids share the same PMU
name, sapphire_rapids. Because from the kernel’s perspective, GNR is
similar to SPR. The only key difference is that they support different
extra MSRs. The code path and the PMU name are shared.

However, from end users' perspective, they are quite different. Besides
the extra MSRs, GNR has a newer PEBS format, supports Retire Latency,
supports new CPUID enumeration architecture, doesn't required the
load-latency AUX event, has additional TMA Level 1 Architectural Events,
etc. The differences can be enumerated by CPUID or the PERF_CAPABILITIES
MSR. They weren't reflected in the model-specific kernel setup.
But it is worth to have a distinct PMU name for GNR.

Fixes: a6742cb90b56 ("perf/x86/intel: Fix the FRONTEND encoding on GNR and MTL")
Suggested-by: Ahmad Yasin <ahmad.yasin@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240708193336.1192217-3-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7f7f1c3bb1881..101a21fe9c213 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6756,12 +6756,18 @@ __init int intel_pmu_init(void)
 	case INTEL_EMERALDRAPIDS_X:
 		x86_pmu.flags |= PMU_FL_MEM_LOADS_AUX;
 		x86_pmu.extra_regs = intel_glc_extra_regs;
-		fallthrough;
+		pr_cont("Sapphire Rapids events, ");
+		name = "sapphire_rapids";
+		goto glc_common;
+
 	case INTEL_GRANITERAPIDS_X:
 	case INTEL_GRANITERAPIDS_D:
+		x86_pmu.extra_regs = intel_rwc_extra_regs;
+		pr_cont("Granite Rapids events, ");
+		name = "granite_rapids";
+
+	glc_common:
 		intel_pmu_init_glc(NULL);
-		if (!x86_pmu.extra_regs)
-			x86_pmu.extra_regs = intel_rwc_extra_regs;
 		x86_pmu.pebs_ept = 1;
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = glc_get_event_constraints;
@@ -6772,8 +6778,6 @@ __init int intel_pmu_init(void)
 		td_attr = glc_td_events_attrs;
 		tsx_attr = glc_tsx_events_attrs;
 		intel_pmu_pebs_data_source_skl(true);
-		pr_cont("Sapphire Rapids events, ");
-		name = "sapphire_rapids";
 		break;
 
 	case INTEL_ALDERLAKE:
-- 
2.43.0



