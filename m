Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205B91F37D4;
	Fri, 31 Oct 2025 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919562; cv=none; b=LMVIIgrYW1b7JaKWlZDHjF5hdn/3q+1d5pnuSNssq2BROF79RICN/pC5SgC1ljc0gZXN47JyaWPv6K/yRw7Ff2vGZIcVNmYksiqfKYWgtzP946nq3EDNXfGmKGeFky6bcQGa3t1hxbjx7K4BnbTJg2PGOtcjAVfVgkPf2JqtLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919562; c=relaxed/simple;
	bh=pkTkTVrRitfuWQwRgADNhM+pRBEm8qUV4Vz0urAy5kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZLexjVKAMivC8JWH26oWcrXPSfarujk19RESOG3NBCwhoWUF2kSbzCK5RuTn9N8dHBrRWpnAK9piU9Nb7k4gNuURjJ2FcWf8Zk4yd++mNJ/VCmC7b6qI5mR3IKQvpHQv65rPBGfUgX5w3EwyhWniIIIVBFymUbnbXYzMwi37sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXZAjWgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXZAjWgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD69C4CEE7;
	Fri, 31 Oct 2025 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919562;
	bh=pkTkTVrRitfuWQwRgADNhM+pRBEm8qUV4Vz0urAy5kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXZAjWgutHswh56GFEC1mtOxjAbUrEOUe7EuE1eeS6bwl8MawMO9vsI2h1/AHVCQ1
	 5ZKmW+28H4ozsoJQbwnaBOzscIULZe2ToeGLg5nN4rXNhw8dAL5KSIUEJZVl/xSuTZ
	 dwhiGfNU+lhwPT5/vRO82cVkkI1xOUxeVtiyje98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 02/35] sched_ext: Put event_stats_cpu in struct scx_sched_pcpu
Date: Fri, 31 Oct 2025 15:01:10 +0100
Message-ID: <20251031140043.622407214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit bcb7c2305682c77a8bfdbfe37106b314ac10110f ]

scx_sched.event_stats_cpu is the percpu counters that are used to track
stats. Introduce struct scx_sched_pcpu and move the counters inside. This
will ease adding more per-cpu fields. No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: efeeaac9ae97 ("sched_ext: Sync error_irq_work before freeing scx_sched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c          | 18 +++++++++---------
 kernel/sched/ext_internal.h | 17 ++++++++++-------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 8ecde1abb4e28..46029050b170f 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -630,7 +630,7 @@ static struct task_struct *scx_task_iter_next_locked(struct scx_task_iter *iter)
  * This can be used when preemption is not disabled.
  */
 #define scx_add_event(sch, name, cnt) do {					\
-	this_cpu_add((sch)->event_stats_cpu->name, (cnt));			\
+	this_cpu_add((sch)->pcpu->event_stats.name, (cnt));			\
 	trace_sched_ext_event(#name, (cnt));					\
 } while(0)
 
@@ -643,7 +643,7 @@ static struct task_struct *scx_task_iter_next_locked(struct scx_task_iter *iter)
  * This should be used only when preemption is disabled.
  */
 #define __scx_add_event(sch, name, cnt) do {					\
-	__this_cpu_add((sch)->event_stats_cpu->name, (cnt));			\
+	__this_cpu_add((sch)->pcpu->event_stats.name, (cnt));			\
 	trace_sched_ext_event(#name, cnt);					\
 } while(0)
 
@@ -3538,7 +3538,7 @@ static void scx_sched_free_rcu_work(struct work_struct *work)
 	int node;
 
 	kthread_stop(sch->helper->task);
-	free_percpu(sch->event_stats_cpu);
+	free_percpu(sch->pcpu);
 
 	for_each_node_state(node, N_POSSIBLE)
 		kfree(sch->global_dsqs[node]);
@@ -4439,13 +4439,13 @@ static struct scx_sched *scx_alloc_and_add_sched(struct sched_ext_ops *ops)
 		sch->global_dsqs[node] = dsq;
 	}
 
-	sch->event_stats_cpu = alloc_percpu(struct scx_event_stats);
-	if (!sch->event_stats_cpu)
+	sch->pcpu = alloc_percpu(struct scx_sched_pcpu);
+	if (!sch->pcpu)
 		goto err_free_gdsqs;
 
 	sch->helper = kthread_run_worker(0, "sched_ext_helper");
 	if (!sch->helper)
-		goto err_free_event_stats;
+		goto err_free_pcpu;
 	sched_set_fifo(sch->helper->task);
 
 	atomic_set(&sch->exit_kind, SCX_EXIT_NONE);
@@ -4463,8 +4463,8 @@ static struct scx_sched *scx_alloc_and_add_sched(struct sched_ext_ops *ops)
 
 err_stop_helper:
 	kthread_stop(sch->helper->task);
-err_free_event_stats:
-	free_percpu(sch->event_stats_cpu);
+err_free_pcpu:
+	free_percpu(sch->pcpu);
 err_free_gdsqs:
 	for_each_node_state(node, N_POSSIBLE)
 		kfree(sch->global_dsqs[node]);
@@ -6490,7 +6490,7 @@ static void scx_read_events(struct scx_sched *sch, struct scx_event_stats *event
 	/* Aggregate per-CPU event counters into @events. */
 	memset(events, 0, sizeof(*events));
 	for_each_possible_cpu(cpu) {
-		e_cpu = per_cpu_ptr(sch->event_stats_cpu, cpu);
+		e_cpu = &per_cpu_ptr(sch->pcpu, cpu)->event_stats;
 		scx_agg_event(events, e_cpu, SCX_EV_SELECT_CPU_FALLBACK);
 		scx_agg_event(events, e_cpu, SCX_EV_DISPATCH_LOCAL_DSQ_OFFLINE);
 		scx_agg_event(events, e_cpu, SCX_EV_DISPATCH_KEEP_LAST);
diff --git a/kernel/sched/ext_internal.h b/kernel/sched/ext_internal.h
index 76690ede8700f..af4c054fb6f85 100644
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -846,6 +846,15 @@ struct scx_event_stats {
 	s64		SCX_EV_BYPASS_ACTIVATE;
 };
 
+struct scx_sched_pcpu {
+	/*
+	 * The event counters are in a per-CPU variable to minimize the
+	 * accounting overhead. A system-wide view on the event counter is
+	 * constructed when requested by scx_bpf_events().
+	 */
+	struct scx_event_stats	event_stats;
+};
+
 struct scx_sched {
 	struct sched_ext_ops	ops;
 	DECLARE_BITMAP(has_op, SCX_OPI_END);
@@ -860,13 +869,7 @@ struct scx_sched {
 	 */
 	struct rhashtable	dsq_hash;
 	struct scx_dispatch_q	**global_dsqs;
-
-	/*
-	 * The event counters are in a per-CPU variable to minimize the
-	 * accounting overhead. A system-wide view on the event counter is
-	 * constructed when requested by scx_bpf_events().
-	 */
-	struct scx_event_stats __percpu *event_stats_cpu;
+	struct scx_sched_pcpu __percpu *pcpu;
 
 	bool			warned_zero_slice;
 
-- 
2.51.0



