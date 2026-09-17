Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570934F5DF8;
	Thu, 17 Sep 2026 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666082; cv=none; b=MyNE6RT9UYIF9lz4H1WNCpdywTSZ9BEWSGfdUrXVfU3qP/DUSQ4wEtXCIRsyt8b9KE8ty0Wu8ps2pUv9cs+QZ7Fsa1OEN1gTvO3m1dqWJDWaX2lxLyFHYzYKco7pg4iohW5Bp//3CbakcHvtL/jlVo8Z7qoNF+7qhSKsvLRVY/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666082; c=relaxed/simple;
	bh=O8v3idIMLLu2mxGn3FXLm62wFlqUZD8elOVJI8HvWXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nunn3LokPm90vE+qtVj2JfhDHpmQEOtJVOqkazZO/qM7Rkcx3RYgN+yqzPEhhlFuGagjq9kV1s1GcrV67yo0cD5dlX+w9h4u8lT7tQtbQLbusFe9MT3iYnuD7KpqfQYybC3zpYLdaRSc9qGmXsnL6+e2Jn56Te5CpnykmNi7ic0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9VFnyKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9VFnyKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A571F000FF;
	Thu, 17 Sep 2026 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666081;
	bh=zNs3XU3DGZABD77Ziwbi/QO6rIqbQmkTmu8lGZO6GRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9VFnyKl42vDwsuDUhs4QN7Dyzfrc0Dq1RUq8uSs5dVNRg5Gb02VzW+1SuhclRWPq
	 Drw58lUPG7L9TGQdwcOkjTQ+wjs1ncrYVQimIDABBA1o3lqbgEWe2JUE4xyWdZBr34
	 twObu/WGoM/IwuXg/1GPstsYJQwMQ1SqcNYhXs1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0918/1250] perf/x86/intel: Prevent drain_pebs() reentry
Date: Thu, 17 Sep 2026 16:11:53 +0100
Message-ID: <20260917151616.886455682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit a56c03a397e2cd0c4cf8da96dcd6214f7d0e7d8c ]

The PEBS buffer is shared by all events on a CPU, so drain_pebs() must
not be reentered. If so, one instance may observe stale buffer state and
potentially access out-of-bound memory.

Most invocations happen in NMI context, which naturally prevents reentry.
However, drain_pebs() is also reachable from process context via
intel_pmu_drain_pebs_buffer().

In those paths, the PMU is often already disabled, but not guaranteed.
For example, __intel_pmu_pebs_disable() only disables the target counter,
so other active counters can still raise a PMI and interrupt an in-flight
drain_pebs(). Here is an example,

__perf_addr_filters_adjust()
  perf_event_stop()
    __perf_event_stop()
      x86_pmu_stop() (event->pmu->stop)
        intel_pmu_disable_event()
          intel_pmu_pebs_disable()
            __intel_pmu_pebs_disable()
              intel_pmu_drain_large_pebs()
                intel_pmu_drain_pebs_buffer()

Introduce __intel_pmu_quiesce() and __intel_pmu_resume() helpers and
use them in intel_pmu_drain_large_pebs() to disable the full PMU
around the intel_pmu_drain_pebs_buffer() call, preventing reentry.

Also add a warning in intel_pmu_drain_pebs_buffer() when the full PMU is
not disabled.

Fixes: b752ea0c28e3 ("perf/x86/intel/ds: Flush PEBS DS when changing PEBS_DATA_CFG")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260813064346.335458-1-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 33 ++++++++++++++++++++++++---------
 arch/x86/events/intel/ds.c   |  8 +++++++-
 arch/x86/events/perf_event.h |  3 +++
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 024b5ac58489c..4dacbf664b303 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2621,6 +2621,27 @@ static void intel_pmu_del_event(struct perf_event *event)
 		this_cpu_ptr(&cpu_hw_events)->n_late_setup--;
 }
 
+int __intel_pmu_quiesce(void)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	int pmu_enabled = cpuc->enabled;
+
+	cpuc->enabled = 0;
+	if (pmu_enabled)
+		intel_pmu_disable_all();
+
+	return pmu_enabled;
+}
+
+void __intel_pmu_resume(int pmu_enabled)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+	cpuc->enabled = pmu_enabled;
+	if (pmu_enabled)
+		intel_pmu_enable_all(0);
+}
+
 static int icl_set_topdown_event_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -2812,16 +2833,13 @@ static void intel_pmu_read_event(struct perf_event *event)
 	if (event->hw.flags & (PERF_X86_EVENT_AUTO_RELOAD | PERF_X86_EVENT_TOPDOWN) ||
 	    is_pebs_counter_event_group(event)) {
 		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-		bool pmu_enabled = cpuc->enabled;
+		int pmu_enabled;
 
 		/* Only need to call update_topdown_event() once for group read. */
 		if (is_metric_event(event) && (cpuc->txn_flags & PERF_PMU_TXN_READ))
 			return;
 
-		cpuc->enabled = 0;
-		if (pmu_enabled)
-			intel_pmu_disable_all();
-
+		pmu_enabled = __intel_pmu_quiesce();
 		/*
 		 * If the PEBS counters snapshotting is enabled,
 		 * the topdown event is available in PEBS records.
@@ -2830,10 +2848,7 @@ static void intel_pmu_read_event(struct perf_event *event)
 			static_call(intel_pmu_update_topdown_event)(event, NULL);
 		else
 			intel_pmu_drain_pebs_buffer();
-
-		cpuc->enabled = pmu_enabled;
-		if (pmu_enabled)
-			intel_pmu_enable_all(0);
+		__intel_pmu_resume(pmu_enabled);
 
 		return;
 	}
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index cab7c4d2e99bd..711e8a6f46a3a 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -961,8 +961,11 @@ int intel_pmu_drain_bts_buffer(void)
 
 void intel_pmu_drain_pebs_buffer(void)
 {
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 
+	WARN_ON_ONCE(cpuc->enabled);
+
 	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
@@ -1528,8 +1531,11 @@ static void intel_pmu_pebs_via_pt_enable(struct perf_event *event)
 static inline void intel_pmu_drain_large_pebs(struct cpu_hw_events *cpuc)
 {
 	if (cpuc->n_pebs == cpuc->n_large_pebs &&
-	    cpuc->n_pebs != cpuc->n_pebs_via_pt)
+	    cpuc->n_pebs != cpuc->n_pebs_via_pt) {
+		int enabled = __intel_pmu_quiesce();
 		intel_pmu_drain_pebs_buffer();
+		__intel_pmu_resume(enabled);
+	}
 }
 
 void intel_pmu_pebs_enable(struct perf_event *event)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index da6f5cad665cf..fc9e6640e322b 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1612,6 +1612,9 @@ static __always_inline void __intel_pmu_lbr_disable(void)
 	wrmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
+extern int __intel_pmu_quiesce(void);
+extern void __intel_pmu_resume(int pmu_enabled);
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
-- 
2.53.0



