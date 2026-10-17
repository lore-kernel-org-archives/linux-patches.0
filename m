Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E03CBE80;
	Sat, 17 Oct 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260639; cv=none; b=PJ8UD5U9CtXHUnQTe2w0gWDjP5G3nCOgOKk94TWmg8KeJdylGMQOvhwt3mAFpl8Wdw4R3kEZ05WblwEg6hxGQ9L1duzuNDGqdp7CNjq56XjenFPtbVW/mazRomIykTZlftL+SeqZamrn5nbTuZT5TzkyqzvZiek7aFm8RpXiaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260639; c=relaxed/simple;
	bh=LYar7yar1PWw5K/QvmaaLbqRZAi57HEQ+KdXv2WJqTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9TegafgRS3w4op12xBFCmbw9GtCc2CO7m+1/tk7iz0eyz5YQYHOLehzHfK1GK85GtprsoajbsGK5P4Kizx9w2rm/JjNvKNkLkP563CZ6Dic7iLLWgbrHj9/pFRY+yG4clWnTRrDc4P8SR0/WjHM34o7Qp55sFj5tHlW4yfZpwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsfdHSOH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsfdHSOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8481F000C4;
	Sat, 17 Oct 2026 18:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260638;
	bh=pDyCsShIhnB1AOiA92JLflgLvbzDb5PRzhUrnA0R3xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsfdHSOHayKVmOcxQLv6u1Nv42EoSsxVBbCJHsLl54DuWHeaqGeRGlsft/gfDWoYK
	 mwTwm1AvB6vFQ01Ta4AFNTMPdkLrJ6yKqLy/JIO9BHpnPz7z60ukxs2PXt+dRMFJd6
	 wiNhwcVMuUg6ysYOrVqKX70ek/W6XZIdxAk+6FYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1611/1674] perf/x86/intel: Prevent drain_pebs() reentry
Date: Sat, 17 Oct 2026 18:04:43 +0200
Message-ID: <20261017160512.437909876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 arch/x86/events/intel/core.c | 32 ++++++++++++++++++++++++--------
 arch/x86/events/intel/ds.c   |  8 +++++++-
 arch/x86/events/perf_event.h |  3 +++
 3 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 01895323c85b3..9a87489887b85 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2526,6 +2526,27 @@ static void intel_pmu_del_event(struct perf_event *event)
 		intel_pmu_pebs_del(event);
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
@@ -2724,24 +2745,19 @@ static void intel_pmu_read_event(struct perf_event *event)
 {
 	if (event->hw.flags & (PERF_X86_EVENT_AUTO_RELOAD | PERF_X86_EVENT_TOPDOWN)) {
 		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
-		bool pmu_enabled = cpuc->enabled;
+		int pmu_enabled;
 
 		/* Only need to call update_topdown_event() once for group read. */
 		if (is_metric_event(event) && (cpuc->txn_flags & PERF_PMU_TXN_READ))
 			return;
 
-		cpuc->enabled = 0;
-		if (pmu_enabled)
-			intel_pmu_disable_all();
+		pmu_enabled = __intel_pmu_quiesce();
 
 		if (is_topdown_count(event))
 			static_call(intel_pmu_update_topdown_event)(event);
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
index 04f3b0d8f14f2..5f1867468b7c3 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -856,8 +856,11 @@ int intel_pmu_drain_bts_buffer(void)
 
 void intel_pmu_drain_pebs_buffer(void)
 {
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_sample_data data;
 
+	WARN_ON_ONCE(cpuc->enabled);
+
 	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
@@ -1338,8 +1341,11 @@ static void intel_pmu_pebs_via_pt_enable(struct perf_event *event)
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
index e1508306ed509..73fe3c65f5f53 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1478,6 +1478,9 @@ static __always_inline void __intel_pmu_lbr_disable(void)
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
+extern int __intel_pmu_quiesce(void);
+extern void __intel_pmu_resume(int pmu_enabled);
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
-- 
2.53.0



