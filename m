Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9E346FC8;
	Fri, 21 Nov 2025 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733630; cv=none; b=bGwxY4wRlCmR+7Qzf5feS/cl3Ic9Zxrni3MiRnZWCXI+XPnFQRjDwY/+91Erfdv6NNRB7OcqB4blN/E/nDq3w5hn1ACAPl70i2VbHUTW8Fs2nzbu31AIyR8VDq7SbOpTEv5qTJB6FafRTiCcDlPpts7JBfzC7WpltiATP+kgp+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733630; c=relaxed/simple;
	bh=GE5NRIwWV1nwAvwvxHCCFcpFbpCUmVl38u2AQlqVrNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fp3X6jOhgZZDpIV4GOcaFrokiR4nYw7ORCuzGbw7fgeRK8JenWk1nqxxz2uIuq827oQvRyNt0h6VoLrJyBG8BkLnOyZIK8aG6iZAPO7cpcSQS1mcId2SdHO1mgYGGa9m/cEUvg966V9Dcj149La+GNiqbcrJixahhWNVUOTozuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zznMkqpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zznMkqpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EF2C4CEF1;
	Fri, 21 Nov 2025 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733630;
	bh=GE5NRIwWV1nwAvwvxHCCFcpFbpCUmVl38u2AQlqVrNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zznMkqpWC4m47HqZGmgVmziXZ8/CN01bSdzlZzDHAURLnoXjoY9oRuMnXszYifzG7
	 EAejKYtxdJGOPioIObBmOxZx4uLHo8+ztUqirXwprLjXfM+eb0oK8rvD4892z9yd9T
	 3Rc1+I76ThscEXrNZlKZKNwRYhfEYu868uMXA1Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	kernel test robot <oliver.sang@intel.com>,
	Shakeel Butt <shakeelb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Greg Thelen <gthelen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 527/529] mm: memcg: optimize parent iteration in memcg_rstat_updated()
Date: Fri, 21 Nov 2025 14:13:46 +0100
Message-ID: <20251121130249.796622277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Yosry Ahmed <yosryahmed@google.com>

commit 9cee7e8ef3e31ca25b40ca52b8585dc6935deff2 upstream.

In memcg_rstat_updated(), we iterate the memcg being updated and its
parents to update memcg->vmstats_percpu->stats_updates in the fast path
(i.e. no atomic updates). According to my math, this is 3 memory loads
(and potentially 3 cache misses) per memcg:
- Load the address of memcg->vmstats_percpu.
- Load vmstats_percpu->stats_updates (based on some percpu calculation).
- Load the address of the parent memcg.

Avoid most of the cache misses by caching a pointer from each struct
memcg_vmstats_percpu to its parent on the corresponding CPU. In this
case, for the first memcg we have 2 memory loads (same as above):
- Load the address of memcg->vmstats_percpu.
- Load vmstats_percpu->stats_updates (based on some percpu calculation).

Then for each additional memcg, we need a single load to get the
parent's stats_updates directly. This reduces the number of loads from
O(3N) to O(2+N) -- where N is the number of memcgs we need to iterate.

Additionally, stash a pointer to memcg->vmstats in each struct
memcg_vmstats_percpu such that we can access the atomic counter that all
CPUs fold into, memcg->vmstats->stats_updates.
memcg_should_flush_stats() is changed to memcg_vmstats_needs_flush() to
accept a struct memcg_vmstats pointer accordingly.

In struct memcg_vmstats_percpu, make sure both pointers together with
stats_updates live on the same cacheline. Finally, update
mem_cgroup_alloc() to take in a parent pointer and initialize the new
cache pointers on each CPU. The percpu loop in mem_cgroup_alloc() may
look concerning, but there are multiple similar loops in the cgroup
creation path (e.g. cgroup_rstat_init()), most of which are hidden
within alloc_percpu().

According to Oliver's testing [1], this fixes multiple 30-38%
regressions in vm-scalability, will-it-scale-tlb_flush2, and
will-it-scale-fallocate1. This comes at a cost of 2 more pointers per
CPU (<2KB on a machine with 128 CPUs).

[1] https://lore.kernel.org/lkml/ZbDJsfsZt2ITyo61@xsang-OptiPlex-9020/

[yosryahmed@google.com: fix struct memcg_vmstats_percpu size and alignment]
  Link: https://lkml.kernel.org/r/20240203044612.1234216-1-yosryahmed@google.com
Link: https://lkml.kernel.org/r/20240124100023.660032-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Fixes: 8d59d2214c23 ("mm: memcg: make stats flushing threshold per-memcg")
Tested-by: kernel test robot <oliver.sang@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202401221624.cb53a8ca-oliver.sang@intel.com
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   56 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -617,6 +617,15 @@ static inline int memcg_events_index(enu
 }
 
 struct memcg_vmstats_percpu {
+	/* Stats updates since the last flush */
+	unsigned int			stats_updates;
+
+	/* Cached pointers for fast iteration in memcg_rstat_updated() */
+	struct memcg_vmstats_percpu	*parent;
+	struct memcg_vmstats		*vmstats;
+
+	/* The above should fit a single cacheline for memcg_rstat_updated() */
+
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
 	unsigned long		events[NR_MEMCG_EVENTS];
@@ -628,10 +637,7 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
-
-	/* Stats updates since the last flush */
-	unsigned int		stats_updates;
-};
+} ____cacheline_aligned;
 
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
@@ -694,36 +700,35 @@ static void memcg_stats_unlock(void)
 }
 
 
-static bool memcg_should_flush_stats(struct mem_cgroup *memcg)
+static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic64_read(&memcg->vmstats->stats_updates) >
+	return atomic64_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	struct memcg_vmstats_percpu *statc;
 	int cpu = smp_processor_id();
-	unsigned int x;
 
 	if (!val)
 		return;
 
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
-
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		x = __this_cpu_add_return(memcg->vmstats_percpu->stats_updates,
-					  abs(val));
-
-		if (x < MEMCG_CHARGE_BATCH)
+	statc = this_cpu_ptr(memcg->vmstats_percpu);
+	for (; statc; statc = statc->parent) {
+		statc->stats_updates += abs(val);
+		if (statc->stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
 		/*
 		 * If @memcg is already flush-able, increasing stats_updates is
 		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (!memcg_should_flush_stats(memcg))
-			atomic64_add(x, &memcg->vmstats->stats_updates);
-		__this_cpu_write(memcg->vmstats_percpu->stats_updates, 0);
+		if (!memcg_vmstats_needs_flush(statc->vmstats))
+			atomic64_add(statc->stats_updates,
+				     &statc->vmstats->stats_updates);
+		statc->stats_updates = 0;
 	}
 }
 
@@ -752,7 +757,7 @@ void mem_cgroup_flush_stats(struct mem_c
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_should_flush_stats(memcg))
+	if (memcg_vmstats_needs_flush(memcg->vmstats))
 		do_flush_stats(memcg);
 }
 
@@ -766,7 +771,7 @@ void mem_cgroup_flush_stats_ratelimited(
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
+	 * Deliberately ignore memcg_vmstats_needs_flush() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats(root_mem_cgroup);
@@ -5328,10 +5333,11 @@ static void mem_cgroup_free(struct mem_c
 	__mem_cgroup_free(memcg);
 }
 
-static struct mem_cgroup *mem_cgroup_alloc(void)
+static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
+	struct memcg_vmstats_percpu *statc, *pstatc;
 	struct mem_cgroup *memcg;
-	int node;
+	int node, cpu;
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
@@ -5354,6 +5360,14 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
+	for_each_possible_cpu(cpu) {
+		if (parent)
+			pstatc = per_cpu_ptr(parent->vmstats_percpu, cpu);
+		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
+		statc->parent = parent ? pstatc : NULL;
+		statc->vmstats = memcg->vmstats;
+	}
+
 	for_each_node(node)
 		if (alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
@@ -5399,7 +5413,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	struct mem_cgroup *memcg, *old_memcg;
 
 	old_memcg = set_active_memcg(parent);
-	memcg = mem_cgroup_alloc();
+	memcg = mem_cgroup_alloc(parent);
 	set_active_memcg(old_memcg);
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);


