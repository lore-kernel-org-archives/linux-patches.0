Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9344ABBB4;
	Thu, 17 Sep 2026 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660030; cv=none; b=jsF4t7VgyHJ84SVSOeYfOlYfEUViSkW1Nzy9ECe9o+0QXdUmfvaYzDts9AaNrvXhoOL+q/p/6UZUnOkfvdrP+ZJdK+HeK4Vx1QF7nR4Z2yJpyVcCJ/5nn7Zzl0GHuIbvvbxYdafcr7jcVOn+PkjuM1iA8ExOfDZrWdJRjIp5uQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660030; c=relaxed/simple;
	bh=9BY6yw/eO3rOkLMzml4STwqb2p6WsiRJVuKYvamluFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EexTJRM7+W6haA1LnqFKI00tN0Hr9Gqa4g3N52mP1svfzWsJTGwU7ozcRLIJevL2cOWvlvQ5uCn6R99TkNzZrDpxt/WqXGgGb7ACQT2rfNlmaf3N1MCRzFtae1ep9iuXkRC6nFx8I+UgdosFDTEuSjw8vfYGFv/PWdREvc1RpLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0juazh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0juazh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402111F000FF;
	Thu, 17 Sep 2026 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660023;
	bh=gDiWmkWrrNTONpvV23S3ypHIMRJ2pyRvB9Q2lenzm3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C0juazh6AGjhhNNX26E75U+A8mwABhhW/tLL5z9nAvXfvRBuy07+kBRh+UzvLkaZY
	 b9ZW+VGljMPpa7vu/r7lGpF5Gd1uZvim2LjEWrR8xJPCx2EH5aa4beRL1Mj9cO8kwv
	 RPU0puP4YE0kKFEc7/DXLtlV9HdtTcw8w2esj7Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 415/733] perf/x86/intel: Prevent drain_pebs() reentry
Date: Thu, 17 Sep 2026 16:12:03 +0100
Message-ID: <20260917151402.124716010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5116b15438a21..24c1f40595449 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3125,6 +3125,27 @@ static void intel_pmu_del_event(struct perf_event *event)
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
@@ -3316,16 +3337,13 @@ static void intel_pmu_read_event(struct perf_event *event)
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
@@ -3334,10 +3352,7 @@ static void intel_pmu_read_event(struct perf_event *event)
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
index e71cca7bbe77b..3dcd7dfc92b1c 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1242,8 +1242,11 @@ int intel_pmu_drain_bts_buffer(void)
 
 void intel_pmu_drain_pebs_buffer(void)
 {
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 
+	WARN_ON_ONCE(cpuc->enabled);
+
 	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
@@ -1877,8 +1880,11 @@ static void intel_pmu_pebs_via_pt_enable(struct perf_event *event)
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
 
 static void __intel_pmu_pebs_enable(struct perf_event *event)
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index a8afea8d38f0c..680220d311a71 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1644,6 +1644,9 @@ static __always_inline void __intel_pmu_lbr_disable(void)
 	wrmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
+extern int __intel_pmu_quiesce(void);
+extern void __intel_pmu_resume(int pmu_enabled);
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
-- 
2.53.0



