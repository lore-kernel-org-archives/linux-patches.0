Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BF6134AC;
	Mon, 12 Aug 2024 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479818; cv=none; b=mx/jZrUU6fXdQjobXs0kDCmdWJ4/IbdxnN6L3mqP26S+PiJb80G5SgRjg5NLJmSn6QRCyVeFD2hGSMclDgdVfeCzwywlepsj8Ml4+DJ/dZ7Fc3o5fd95kHptRxr9fqOCd0644cDt6fu20t8oGp81SRGhQq+XuQh9FCOpr+d2QhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479818; c=relaxed/simple;
	bh=7xuWhto3db4S6jrzgA4wqtdrPXvfiVkFYI4Ee6O7vxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDsvfyTA3jh5q8FBR6cGAgIrBNz955mJy2eowAAmqiJ3DVAAAUivEJ5hUP5goILCGm/smub4vXFEGBTRQQSlE/5lHJSlimL6mevqlcYLZgooPc52La0x71dIjA/RcZRIK9m+S3Opx0BDPePkUtu649sz9sV67ywzGsqyNWEb4t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L75X64GD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L75X64GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACAEC32782;
	Mon, 12 Aug 2024 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479817;
	bh=7xuWhto3db4S6jrzgA4wqtdrPXvfiVkFYI4Ee6O7vxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L75X64GDacsxcS+kb4aCC7DqEookxJ/C+DCuUcKDLqCIvIOWUuwVgerfX1SKfoYfI
	 nLh5Qmr9WcWF1oXXRMa0XOmEG6PhO8Jn1kyz5LBor1R7fL61ZAQSpZ0rWfXnwjnWFf
	 EJj2KB+SVN12QjajBYCROo9mdwfA2dYowJC75dmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 011/263] perf/x86/intel: Support the PEBS event mask
Date: Mon, 12 Aug 2024 18:00:12 +0200
Message-ID: <20240812160146.969678503@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit a23eb2fc1d818cdac9b31f032842d55483a6a040 ]

The current perf assumes that the counters that support PEBS are
contiguous. But it's not guaranteed with the new leaf 0x23 introduced.
The counters are enumerated with a counter mask. There may be holes in
the counter mask for future platforms or in a virtualization
environment.

Store the PEBS event mask rather than the maximum number of PEBS
counters in the x86 PMU structures.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lkml.kernel.org/r/20240626143545.480761-2-kan.liang@linux.intel.com
Stable-dep-of: f73cefa3b72e ("perf/x86: Fix smp_processor_id()-in-preemptible warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c    |  8 ++++----
 arch/x86/events/intel/ds.c      | 15 ++++++++-------
 arch/x86/events/perf_event.h    | 15 +++++++++++++--
 arch/x86/include/asm/intel_ds.h |  1 +
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 101a21fe9c213..2175ca2fdba47 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4728,7 +4728,7 @@ static void intel_pmu_check_hybrid_pmus(struct x86_hybrid_pmu *pmu)
 {
 	intel_pmu_check_num_counters(&pmu->num_counters, &pmu->num_counters_fixed,
 				     &pmu->intel_ctrl, (1ULL << pmu->num_counters_fixed) - 1);
-	pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
+	pmu->pebs_events_mask = intel_pmu_pebs_mask(GENMASK_ULL(pmu->num_counters - 1, 0));
 	pmu->unconstrained = (struct event_constraint)
 			     __EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
 						0, pmu->num_counters, 0, 0);
@@ -6070,7 +6070,7 @@ static __always_inline int intel_pmu_init_hybrid(enum hybrid_pmu_type pmus)
 
 		pmu->num_counters = x86_pmu.num_counters;
 		pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
-		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
+		pmu->pebs_events_mask = intel_pmu_pebs_mask(GENMASK_ULL(pmu->num_counters - 1, 0));
 		pmu->unconstrained = (struct event_constraint)
 				     __EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
 							0, pmu->num_counters, 0, 0);
@@ -6193,7 +6193,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_maskl		= ebx.full;
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
-	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_events_mask	= intel_pmu_pebs_mask(GENMASK_ULL(x86_pmu.num_counters - 1, 0));
 	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
@@ -6826,7 +6826,7 @@ __init int intel_pmu_init(void)
 			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
 		}
 
-		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
+		pmu->pebs_events_mask = intel_pmu_pebs_mask(GENMASK_ULL(pmu->num_counters - 1, 0));
 		pmu->unconstrained = (struct event_constraint)
 					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
 							   0, pmu->num_counters, 0, 0);
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 80a4f712217b7..87d3feb9f8fe8 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1137,7 +1137,7 @@ void intel_pmu_pebs_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sche
 static inline void pebs_update_threshold(struct cpu_hw_events *cpuc)
 {
 	struct debug_store *ds = cpuc->ds;
-	int max_pebs_events = hybrid(cpuc->pmu, max_pebs_events);
+	int max_pebs_events = intel_pmu_max_num_pebs(cpuc->pmu);
 	int num_counters_fixed = hybrid(cpuc->pmu, num_counters_fixed);
 	u64 threshold;
 	int reserved;
@@ -2161,6 +2161,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 	void *base, *at, *top;
 	short counts[INTEL_PMC_IDX_FIXED + MAX_FIXED_PEBS_EVENTS] = {};
 	short error[INTEL_PMC_IDX_FIXED + MAX_FIXED_PEBS_EVENTS] = {};
+	int max_pebs_events = intel_pmu_max_num_pebs(NULL);
 	int bit, i, size;
 	u64 mask;
 
@@ -2172,8 +2173,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	mask = (1ULL << x86_pmu.max_pebs_events) - 1;
-	size = x86_pmu.max_pebs_events;
+	mask = x86_pmu.pebs_events_mask;
+	size = max_pebs_events;
 	if (x86_pmu.flags & PMU_FL_PEBS_ALL) {
 		mask |= ((1ULL << x86_pmu.num_counters_fixed) - 1) << INTEL_PMC_IDX_FIXED;
 		size = INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed;
@@ -2212,8 +2213,9 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
 			pebs_status = p->status = cpuc->pebs_enabled;
 
 		bit = find_first_bit((unsigned long *)&pebs_status,
-					x86_pmu.max_pebs_events);
-		if (bit >= x86_pmu.max_pebs_events)
+				     max_pebs_events);
+
+		if (!(x86_pmu.pebs_events_mask & (1 << bit)))
 			continue;
 
 		/*
@@ -2271,7 +2273,6 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
 {
 	short counts[INTEL_PMC_IDX_FIXED + MAX_FIXED_PEBS_EVENTS] = {};
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-	int max_pebs_events = hybrid(cpuc->pmu, max_pebs_events);
 	int num_counters_fixed = hybrid(cpuc->pmu, num_counters_fixed);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event;
@@ -2287,7 +2288,7 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	mask = ((1ULL << max_pebs_events) - 1) |
+	mask = hybrid(cpuc->pmu, pebs_events_mask) |
 	       (((1ULL << num_counters_fixed) - 1) << INTEL_PMC_IDX_FIXED);
 	size = INTEL_PMC_IDX_FIXED + num_counters_fixed;
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 72b022a1e16c5..a7ba2868018ca 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -684,7 +684,7 @@ struct x86_hybrid_pmu {
 	cpumask_t			supported_cpus;
 	union perf_capabilities		intel_cap;
 	u64				intel_ctrl;
-	int				max_pebs_events;
+	u64				pebs_events_mask;
 	int				num_counters;
 	int				num_counters_fixed;
 	struct event_constraint		unconstrained;
@@ -852,7 +852,7 @@ struct x86_pmu {
 			pebs_ept		:1;
 	int		pebs_record_size;
 	int		pebs_buffer_size;
-	int		max_pebs_events;
+	u64		pebs_events_mask;
 	void		(*drain_pebs)(struct pt_regs *regs, struct perf_sample_data *data);
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
@@ -1661,6 +1661,17 @@ static inline int is_ht_workaround_enabled(void)
 	return !!(x86_pmu.flags & PMU_FL_EXCL_ENABLED);
 }
 
+static inline u64 intel_pmu_pebs_mask(u64 cntr_mask)
+{
+	return MAX_PEBS_EVENTS_MASK & cntr_mask;
+}
+
+static inline int intel_pmu_max_num_pebs(struct pmu *pmu)
+{
+	static_assert(MAX_PEBS_EVENTS == 32);
+	return fls((u32)hybrid(pmu, pebs_events_mask));
+}
+
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/include/asm/intel_ds.h b/arch/x86/include/asm/intel_ds.h
index 2f9eeb5c3069a..5dbeac48a5b93 100644
--- a/arch/x86/include/asm/intel_ds.h
+++ b/arch/x86/include/asm/intel_ds.h
@@ -9,6 +9,7 @@
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS_FMT4	8
 #define MAX_PEBS_EVENTS		32
+#define MAX_PEBS_EVENTS_MASK	GENMASK_ULL(MAX_PEBS_EVENTS - 1, 0)
 #define MAX_FIXED_PEBS_EVENTS	16
 
 /*
-- 
2.43.0



