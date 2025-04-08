Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5068B265CDF;
	Tue,  8 Apr 2025 12:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113745; cv=none; b=HU8Q/TU+VkZ9ALQpUsCm6AvwRzKBAjwCGxXAk0M0Kg80wr+DHpitH7I5QYnRQnIeCFz8Ha9NNBcURHyrdN/kDDKaHInPMjVP/zGDLRaZYS2abhq2k3hJxmDL4Jsx4RlKQukEhP13N9TUvFoS8argjeuwv9tuakU4VdkBegObk/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113745; c=relaxed/simple;
	bh=thtcaGhXTW3/Zx1DXXm7yf5BNDkCNvtEpIbmWZtUIks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iatpmX+zUvk8O6BAMkrQ678ZHqvQl0FK+NZekQx46ti7gPVwHCtE8ynBPeRT/0B5SsK68sL0561AlKR2utEnzBLCZwubSUsQ7V5gR2I00ZiPHTx+27oWmDlvyFwzlOPfATwzPd2/q8IBpYC6t7qFf9ODhElRJSBLPWiqM4efkGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvJq8Y52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvJq8Y52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6432C4CEE5;
	Tue,  8 Apr 2025 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113745;
	bh=thtcaGhXTW3/Zx1DXXm7yf5BNDkCNvtEpIbmWZtUIks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvJq8Y52qcKTSPErQKQDyaqQWnYV4MHJCao3BdxUjkk5SiaYlhHvsEvrO4OObRZ0D
	 59eT9XdZa09VYEbm0ydszcy38RnyiS/KRFzimNvIAfL0IQs8gEZvSnNSaL0RM0MODv
	 LEvLM2iq94qqeichWs+PZvhjh3DHqv69SjyhrbDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.6 241/268] perf/x86/intel: Avoid disable PMU if !cpuc->enabled in sample read
Date: Tue,  8 Apr 2025 12:50:52 +0200
Message-ID: <20250408104835.088676731@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit f9bdf1f953392c9edd69a7f884f78c0390127029 upstream.

The WARN_ON(this_cpu_read(cpu_hw_events.enabled)) in the
intel_pmu_save_and_restart_reload() is triggered, when sampling read
topdown events.

In a NMI handler, the cpu_hw_events.enabled is set and used to indicate
the status of core PMU. The generic pmu->pmu_disable_count, updated in
the perf_pmu_disable/enable pair, is not touched.
However, the perf_pmu_disable/enable pair is invoked when sampling read
in a NMI handler. The cpuc->enabled is mistakenly set by the
perf_pmu_enable().

Avoid disabling PMU if the core PMU is already disabled.
Merge the logic together.

Fixes: 7b2c05a15d29 ("perf/x86/intel: Generic support for hardware TopDown metrics")
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250121152303.3128733-2-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   41 +++++++++++++++++++++++------------------
 arch/x86/events/intel/ds.c   |   11 +----------
 arch/x86/events/perf_event.h |    2 +-
 3 files changed, 25 insertions(+), 29 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2720,28 +2720,33 @@ static u64 adl_update_topdown_event(stru
 
 DEFINE_STATIC_CALL(intel_pmu_update_topdown_event, x86_perf_event_update);
 
-static void intel_pmu_read_topdown_event(struct perf_event *event)
+static void intel_pmu_read_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	if (event->hw.flags & (PERF_X86_EVENT_AUTO_RELOAD | PERF_X86_EVENT_TOPDOWN)) {
+		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+		bool pmu_enabled = cpuc->enabled;
+
+		/* Only need to call update_topdown_event() once for group read. */
+		if (is_metric_event(event) && (cpuc->txn_flags & PERF_PMU_TXN_READ))
+			return;
+
+		cpuc->enabled = 0;
+		if (pmu_enabled)
+			intel_pmu_disable_all();
+
+		if (is_topdown_event(event))
+			static_call(intel_pmu_update_topdown_event)(event);
+		else
+			intel_pmu_drain_pebs_buffer();
+
+		cpuc->enabled = pmu_enabled;
+		if (pmu_enabled)
+			intel_pmu_enable_all(0);
 
-	/* Only need to call update_topdown_event() once for group read. */
-	if ((cpuc->txn_flags & PERF_PMU_TXN_READ) &&
-	    !is_slots_event(event))
 		return;
+	}
 
-	perf_pmu_disable(event->pmu);
-	static_call(intel_pmu_update_topdown_event)(event);
-	perf_pmu_enable(event->pmu);
-}
-
-static void intel_pmu_read_event(struct perf_event *event)
-{
-	if (event->hw.flags & PERF_X86_EVENT_AUTO_RELOAD)
-		intel_pmu_auto_reload_read(event);
-	else if (is_topdown_count(event))
-		intel_pmu_read_topdown_event(event);
-	else
-		x86_perf_event_update(event);
+	x86_perf_event_update(event);
 }
 
 static void intel_pmu_enable_fixed(struct perf_event *event)
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -843,7 +843,7 @@ unlock:
 	return 1;
 }
 
-static inline void intel_pmu_drain_pebs_buffer(void)
+void intel_pmu_drain_pebs_buffer(void)
 {
 	struct perf_sample_data data;
 
@@ -1965,15 +1965,6 @@ get_next_pebs_record_by_bit(void *base,
 	return NULL;
 }
 
-void intel_pmu_auto_reload_read(struct perf_event *event)
-{
-	WARN_ON(!(event->hw.flags & PERF_X86_EVENT_AUTO_RELOAD));
-
-	perf_pmu_disable(event->pmu);
-	intel_pmu_drain_pebs_buffer();
-	perf_pmu_enable(event->pmu);
-}
-
 /*
  * Special variant of intel_pmu_save_and_restart() for auto-reload.
  */
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1540,7 +1540,7 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_pmu_pebs_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in);
 
-void intel_pmu_auto_reload_read(struct perf_event *event);
+void intel_pmu_drain_pebs_buffer(void);
 
 void intel_pmu_store_pebs_lbrs(struct lbr_entry *lbr);
 


