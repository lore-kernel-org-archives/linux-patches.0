Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7EA1FDE31;
	Sat, 17 Oct 2026 16:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256147; cv=none; b=lM2G0OIgoXuv74RBkZhxooUnzmuwpxZpAHwDhur6l7vlWJ2QqS7LlxHcwnJk/edTHYyMRfK2YfJXDBTXZ5vjcWFoDDXFG4bIlHc3i0KTWfNdg1LmsSF1RVT8N7mUcKkSXD0sqvq/LCm4PySY9dnqYt1IgCHrn+yGpYmcH29NCe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256147; c=relaxed/simple;
	bh=xqjJTTpVhptsLAMHocCiSAgtCDrFiZRd17bBu9aEzKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyTajJU9xJStnzKZNDJshO0Ax4mj6hhnNdhh1hvNUAskqABgNB2yGDvwqG9EA7FLWTbUl3yVQyEMF8ggfudSACw8Yua7nD4JYK9l+RCtmZhZKFj+avkcc1pUZ5So4HLiyfSwaF9jdhTWvtb6rPvfZkw8GYhRaDTfpGSYyhvW0XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNYlRBrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNYlRBrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925591F000C4;
	Sat, 17 Oct 2026 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256146;
	bh=KCYn15wKCOhicCetKs2N2EwRRb9LW+yn0r00bQ1/ZiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNYlRBrHHwDpcjPiX2OdngipZsS0MVzQxCBHgTKg4/nueZ8XKbzlVHMDQj5FP2nIk
	 KFOsIQ9ChhCXtvXHPLUjkUhGmvYX/d9qtqMmeYlZTJkjGV5OW6RBRk21lIYFcZ9h6O
	 wrPYNfkVfJKYz8MCkEGDsCzXXryd4ChqXILt8RcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0140/1674] perf: Supply task information to sched_task()
Date: Sat, 17 Oct 2026 17:40:12 +0200
Message-ID: <20261017160434.751245907@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit d57e94f5b891925e4f2796266eba31edd5a01903 ]

To save/restore LBR call stack data in system-wide mode, the task_struct
information is required.

Extend the parameters of sched_task() to supply task_struct information.

When schedule in, the LBR call stack data for new task will be restored.
When schedule out, the LBR call stack data for old task will be saved.
Only need to pass the required task_struct information.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250314172700.438923-4-kan.liang@linux.intel.com

[Backport to 6.6: retain task_ctx_sched_out(ctx, EVENT_ALL), since
this tree does not have the additional PMU argument used upstream.
Keep the sched_task task argument throughout the existing callbacks
so 36bb85cf36ca can apply without further changes.]

Stable-dep-of: 36bb85cf36ca ("perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c    |  8 ++++++--
 arch/s390/kernel/perf_pai_crypto.c |  3 ++-
 arch/s390/kernel/perf_pai_ext.c    |  3 ++-
 arch/x86/events/amd/brs.c          |  3 ++-
 arch/x86/events/amd/lbr.c          |  3 ++-
 arch/x86/events/core.c             |  5 +++--
 arch/x86/events/intel/core.c       |  4 ++--
 arch/x86/events/intel/lbr.c        |  3 ++-
 arch/x86/events/perf_event.h       | 14 +++++++++-----
 include/linux/perf_event.h         |  2 +-
 kernel/events/core.c               | 20 +++++++++++---------
 11 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 4bb84dc4393fc..fafb0343afd5e 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -132,7 +132,10 @@ static unsigned long ebb_switch_in(bool ebb, struct cpu_hw_events *cpuhw)
 
 static inline void power_pmu_bhrb_enable(struct perf_event *event) {}
 static inline void power_pmu_bhrb_disable(struct perf_event *event) {}
-static void power_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in) {}
+static void power_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx,
+				 struct task_struct *task, bool sched_in)
+{
+}
 static inline void power_pmu_bhrb_read(struct perf_event *event, struct cpu_hw_events *cpuhw) {}
 static void pmao_restore_workaround(bool ebb) { }
 #endif /* CONFIG_PPC32 */
@@ -451,7 +454,8 @@ static void power_pmu_bhrb_disable(struct perf_event *event)
 /* Called from ctxsw to prevent one process's branch entries to
  * mingle with the other process's entries during context switch.
  */
-static void power_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+static void power_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx,
+				 struct task_struct *task, bool sched_in)
 {
 	if (!ppmu->bhrb_nr)
 		return;
diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 044fba8332b22..b24ee5fbf9581 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -378,7 +378,8 @@ static int paicrypt_push_sample(void)
 /* Called on schedule-in and schedule-out. No access to event structure,
  * but for sampling only event CRYPTO_ALL is allowed.
  */
-static void paicrypt_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+static void paicrypt_sched_task(struct perf_event_pmu_context *pmu_ctx,
+				struct task_struct *task, bool sched_in)
 {
 	/* We started with a clean page on event installation. So read out
 	 * results on schedule_out and if page was dirty, clear values.
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 089bd3104b394..3b6f18675ab40 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -467,7 +467,8 @@ static int paiext_push_sample(void)
 /* Called on schedule-in and schedule-out. No access to event structure,
  * but for sampling only event NNPA_ALL is allowed.
  */
-static void paiext_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+static void paiext_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			      struct task_struct *task, bool sched_in)
 {
 	/* We started with a clean page on event installation. So read out
 	 * results on schedule_out and if page was dirty, clear values.
diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 01fcd43522bca..d752242ecc0d7 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -381,7 +381,8 @@ static void amd_brs_poison_buffer(void)
  * On ctxswin, sched_in = true, called after the PMU has started
  * On ctxswout, sched_in = false, called before the PMU is stopped
  */
-void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			    struct task_struct *task, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index 0788c11febf6a..0c1e7f0a613c7 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -376,7 +376,8 @@ void amd_pmu_lbr_del(struct perf_event *event)
 	perf_sched_cb_dec(event->pmu);
 }
 
-void amd_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+void amd_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			    struct task_struct *task, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 1519ab15a5449..497a1c20277f2 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2626,9 +2626,10 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
-static void x86_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+static void x86_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			       struct task_struct *task, bool sched_in)
 {
-	static_call_cond(x86_pmu_sched_task)(pmu_ctx, sched_in);
+	static_call_cond(x86_pmu_sched_task)(pmu_ctx, task, sched_in);
 }
 
 static void x86_pmu_swap_task_ctx(struct perf_event_pmu_context *prev_epc,
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 43e65e4c4ebe2..508053d378ae5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4963,10 +4963,10 @@ static void intel_pmu_cpu_dead(int cpu)
 }
 
 static void intel_pmu_sched_task(struct perf_event_pmu_context *pmu_ctx,
-				 bool sched_in)
+				 struct task_struct *task, bool sched_in)
 {
 	intel_pmu_pebs_sched_task(pmu_ctx, sched_in);
-	intel_pmu_lbr_sched_task(pmu_ctx, sched_in);
+	intel_pmu_lbr_sched_task(pmu_ctx, task, sched_in);
 }
 
 static void intel_pmu_swap_task_ctx(struct perf_event_pmu_context *prev_epc,
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 3e904ba942784..dc4e0804b9008 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -538,7 +538,8 @@ void intel_pmu_lbr_swap_task_ctx(struct perf_event_pmu_context *prev_epc,
 	     task_context_opt(next_ctx_data)->lbr_callstack_users);
 }
 
-void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			      struct task_struct *task, bool sched_in)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	void *task_ctx;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 9837e8d0deb39..06a3ad387bb16 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -816,7 +816,7 @@ struct x86_pmu {
 
 	void		(*check_microcode)(void);
 	void		(*sched_task)(struct perf_event_pmu_context *pmu_ctx,
-				      bool sched_in);
+				      struct task_struct *task, bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
@@ -1310,7 +1310,8 @@ void amd_pmu_lbr_reset(void);
 void amd_pmu_lbr_read(void);
 void amd_pmu_lbr_add(struct perf_event *event);
 void amd_pmu_lbr_del(struct perf_event *event);
-void amd_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in);
+void amd_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			    struct task_struct *task, bool sched_in);
 void amd_pmu_lbr_enable_all(void);
 void amd_pmu_lbr_disable_all(void);
 int amd_pmu_lbr_hw_config(struct perf_event *event);
@@ -1351,7 +1352,8 @@ static inline void amd_pmu_brs_del(struct perf_event *event)
 	perf_sched_cb_dec(event->pmu);
 }
 
-void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in);
+void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			    struct task_struct *task, bool sched_in);
 #else
 static inline int amd_brs_init(void)
 {
@@ -1376,7 +1378,8 @@ static inline void amd_pmu_brs_del(struct perf_event *event)
 {
 }
 
-static inline void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in)
+static inline void amd_pmu_brs_sched_task(struct perf_event_pmu_context *pmu_ctx,
+					  struct task_struct *task, bool sched_in)
 {
 }
 
@@ -1558,7 +1561,8 @@ void intel_ds_init(void);
 void intel_pmu_lbr_swap_task_ctx(struct perf_event_pmu_context *prev_epc,
 				 struct perf_event_pmu_context *next_epc);
 
-void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx, bool sched_in);
+void intel_pmu_lbr_sched_task(struct perf_event_pmu_context *pmu_ctx,
+			      struct task_struct *task, bool sched_in);
 
 u64 lbr_from_signext_quirk_wr(u64 val);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3fdc58cc57831..58746c090859b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -453,7 +453,7 @@ struct pmu {
 	 * context-switches callback
 	 */
 	void (*sched_task)		(struct perf_event_pmu_context *pmu_ctx,
-					bool sched_in);
+					 struct task_struct *task, bool sched_in);
 
 	/*
 	 * Kmem cache of PMU specific data
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 95743e6c5b0cb..7cb8cb1f0f68e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3524,7 +3524,8 @@ static void perf_event_swap_task_ctx_data(struct perf_event_context *prev_ctx,
 	}
 }
 
-static void perf_ctx_sched_task_cb(struct perf_event_context *ctx, bool sched_in)
+static void perf_ctx_sched_task_cb(struct perf_event_context *ctx,
+				   struct task_struct *task, bool sched_in)
 {
 	struct perf_event_pmu_context *pmu_ctx;
 	struct perf_cpu_pmu_context *cpc;
@@ -3533,7 +3534,7 @@ static void perf_ctx_sched_task_cb(struct perf_event_context *ctx, bool sched_in
 		cpc = this_cpu_ptr(pmu_ctx->pmu->cpu_pmu_context);
 
 		if (cpc->sched_cb_usage && pmu_ctx->pmu->sched_task)
-			pmu_ctx->pmu->sched_task(pmu_ctx, sched_in);
+			pmu_ctx->pmu->sched_task(pmu_ctx, task, sched_in);
 	}
 }
 
@@ -3591,7 +3592,7 @@ perf_event_context_sched_out(struct task_struct *task, struct task_struct *next)
 			WRITE_ONCE(ctx->task, next);
 			WRITE_ONCE(next_ctx->task, task);
 
-			perf_ctx_sched_task_cb(ctx, false);
+			perf_ctx_sched_task_cb(ctx, task, false);
 			perf_event_swap_task_ctx_data(ctx, next_ctx);
 
 			perf_ctx_enable(ctx, false);
@@ -3621,7 +3622,7 @@ perf_event_context_sched_out(struct task_struct *task, struct task_struct *next)
 		perf_ctx_disable(ctx, false);
 
 inside_switch:
-		perf_ctx_sched_task_cb(ctx, false);
+		perf_ctx_sched_task_cb(ctx, task, false);
 		task_ctx_sched_out(ctx, EVENT_ALL);
 
 		perf_ctx_enable(ctx, false);
@@ -3663,7 +3664,8 @@ void perf_sched_cb_inc(struct pmu *pmu)
  * PEBS requires this to provide PID/TID information. This requires we flush
  * all queued PEBS records before we context switch to a new task.
  */
-static void __perf_pmu_sched_task(struct perf_cpu_pmu_context *cpc, bool sched_in)
+static void __perf_pmu_sched_task(struct perf_cpu_pmu_context *cpc,
+				  struct task_struct *task, bool sched_in)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	struct pmu *pmu;
@@ -3677,7 +3679,7 @@ static void __perf_pmu_sched_task(struct perf_cpu_pmu_context *cpc, bool sched_i
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(pmu);
 
-	pmu->sched_task(cpc->task_epc, sched_in);
+	pmu->sched_task(cpc->task_epc, task, sched_in);
 
 	perf_pmu_enable(pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
@@ -3695,7 +3697,7 @@ static void perf_pmu_sched_task(struct task_struct *prev,
 		return;
 
 	list_for_each_entry(cpc, this_cpu_ptr(&sched_cb_list), sched_cb_entry)
-		__perf_pmu_sched_task(cpc, sched_in);
+		__perf_pmu_sched_task(cpc, sched_in ? next : prev, sched_in);
 }
 
 static void perf_event_switch(struct task_struct *task,
@@ -3999,7 +4001,7 @@ static void perf_event_context_sched_in(struct task_struct *task)
 		perf_ctx_lock(cpuctx, ctx);
 		perf_ctx_disable(ctx, false);
 
-		perf_ctx_sched_task_cb(ctx, true);
+		perf_ctx_sched_task_cb(ctx, task, true);
 
 		perf_ctx_enable(ctx, false);
 		perf_ctx_unlock(cpuctx, ctx);
@@ -4030,7 +4032,7 @@ static void perf_event_context_sched_in(struct task_struct *task)
 
 	perf_event_sched_in(cpuctx, ctx);
 
-	perf_ctx_sched_task_cb(cpuctx->task_ctx, true);
+	perf_ctx_sched_task_cb(cpuctx->task_ctx, task, true);
 
 	if (!RB_EMPTY_ROOT(&ctx->pinned_groups.tree))
 		perf_ctx_enable(&cpuctx->ctx, false);
-- 
2.53.0



