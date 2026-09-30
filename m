Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE751597D;
	Wed, 30 Sep 2026 16:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787401; cv=none; b=mg/UyJEGi6GHcPJ+U1aRtw71op31x6EJ/pDet7iG4s5VTjuzHDWp6FXgNPUIc+MWXlpcoFqtiyyBr/bq+cb1j3He/W3yfEzI7icXr/i59bvZWPMHuvZrnPmcz2vbMxqtOSMis4+vWakU9MDawjvgkbu5En/csQIiWxwW+1MNbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787401; c=relaxed/simple;
	bh=+GRSgCutGiAfGOEu3tmJCvIOQiLKROV9avJ126MGl/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p57nMUOsJGoS5haSwL1MTPm8S1RccWlwVE/y7IWQW9inJUA0zaaUC9yhkPNz9FEqkDPRuzXEChdkN23pRylhDyM7WkCeNsvrbWYeDHhrEQclfRLFpchhp1fX8sayyYI1vhsAOksRIKmXdcCEFxmZHl548NRkTtBLyBzHznRINtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBGGbX1X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBGGbX1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AD51F000FF;
	Wed, 30 Sep 2026 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787399;
	bh=uLTcV1uyhaj3LRnR1MMoQCMZeCeXEVL4Q/LenuB+4d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBGGbX1XxlpZic3S99VXje0sD/7GJq5pFvFsWKVZ6WQuf2pe3TuPxaXMEQGfwTi84
	 +Hv4cChYjPMXKGUgxHKBJXcZ+nOCPvxtjTRaLfonUog+ByQUMSAMYc7KyxVz7JqcqB
	 jQS/Ld+xOTzTOSo3ks41fv4gGU0sVxMbPI3/et5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kris Pan <kris.pan@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 218/457] net: flush skb_defer_nodes in dev_cpu_dead()
Date: Wed, 30 Sep 2026 17:25:23 +0200
Message-ID: <20260930152350.755123317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 06e3f54e8b22040ada01a28343badf1990b4dd7d ]

When a CPU goes offline, dev_cpu_dead() drains its softnet queues
(completion_queue, output_queue, poll_list, process_queue, and
input_pkt_queue), but leaves net_hotdata.skb_defer_nodes untouched.

If oldcpu goes offline while holding pending skbs in its
skb_defer_nodes lists (e.g. below the sysctl_skb_defer_max >> 1 IPI
threshold, or if the IPI races with CPU teardown), those skbs remain
stranded until oldcpu is brought back online. If any of these skbs
hold page_pool fragments, page_pool_destroy() will stall indefinitely
waiting for inflight pages to be returned when a netdev or driver is
torn down while oldcpu is offline.

Additionally, if smp_call_function_single_async() fails in
kick_defer_list_purge() because the target CPU went offline, reset
defer_ipi_scheduled to 0 so future IPI kicks are not blocked when the
CPU comes back online.

Also, if oldcpu was the last online CPU on its NUMA node, drain that
node's slot across all CPUs so no skbs deferred from that node remain
stranded on idle remote CPUs (or if the node itself is subsequently
offlined).

Finally, in skb_attempt_defer_free(), re-check cpu_online(cpu) and
whether the caller migrated CPUs after llist_add(), flushing the node
list if so, to close the preemption TOCTOU race against CPU/node
teardown.

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Fixes: 5628f3fe3b16 ("net: add NUMA awareness to skb_attempt_defer_free()")
Closes: https://lore.kernel.org/netdev/20260916003430.3612956-1-kris.pan@intel.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kris Pan <kris.pan@intel.com>
Link: https://patch.msgid.link/20260923130318.607255-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c    | 47 +++++++++++++++++++++++++++++++++++------------
 net/core/dev.h    |  2 ++
 net/core/skbuff.c | 12 +++++++++---
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a48958a3f76c1..55e1f4045d2c6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5370,7 +5370,8 @@ void kick_defer_list_purge(unsigned int cpu)
 		backlog_unlock_irq_restore(sd, flags);
 
 	} else if (!cmpxchg(&sd->defer_ipi_scheduled, 0, 1)) {
-		smp_call_function_single_async(cpu, &sd->defer_csd);
+		if (smp_call_function_single_async(cpu, &sd->defer_csd))
+			WRITE_ONCE(sd->defer_ipi_scheduled, 0);
 	}
 }
 
@@ -6894,25 +6895,35 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 }
 EXPORT_SYMBOL(napi_complete_done);
 
-static void skb_defer_free_flush(void)
+static void __skb_defer_free_flush(struct skb_defer_node *sdn, int budget)
 {
 	struct llist_node *free_list;
 	struct sk_buff *skb, *next;
+
+	if (llist_empty(&sdn->defer_list))
+		return;
+	atomic_long_set(&sdn->defer_count, 0);
+	free_list = llist_del_all(&sdn->defer_list);
+
+	llist_for_each_entry_safe(skb, next, free_list, ll_node) {
+		prefetch(next);
+		napi_consume_skb(skb, budget);
+	}
+}
+
+void skb_defer_node_flush(struct skb_defer_node *sdn)
+{
+	__skb_defer_free_flush(sdn, 0);
+}
+
+static void skb_defer_free_flush(void)
+{
 	struct skb_defer_node *sdn;
 	int node;
 
 	for_each_node(node) {
 		sdn = this_cpu_ptr(net_hotdata.skb_defer_nodes) + node;
-
-		if (llist_empty(&sdn->defer_list))
-			continue;
-		atomic_long_set(&sdn->defer_count, 0);
-		free_list = llist_del_all(&sdn->defer_list);
-
-		llist_for_each_entry_safe(skb, next, free_list, ll_node) {
-			prefetch(next);
-			napi_consume_skb(skb, 1);
-		}
+		__skb_defer_free_flush(sdn, 1);
 	}
 }
 
@@ -12773,6 +12784,7 @@ static int dev_cpu_dead(unsigned int oldcpu)
 	struct sk_buff **list_skb;
 	struct sk_buff *skb;
 	unsigned int cpu;
+	int node;
 	struct softnet_data *sd, *oldsd, *remsd = NULL;
 
 	local_irq_disable();
@@ -12833,6 +12845,17 @@ static int dev_cpu_dead(unsigned int oldcpu)
 		rps_input_queue_head_incr(oldsd);
 	}
 
+	for_each_node(node)
+		skb_defer_node_flush(per_cpu_ptr(net_hotdata.skb_defer_nodes,
+						 oldcpu) + node);
+	node = cpu_to_node(oldcpu);
+	if (node_possible(node) &&
+	    !cpumask_intersects(cpumask_of_node(node), cpu_online_mask)) {
+		for_each_possible_cpu(cpu)
+			skb_defer_node_flush(per_cpu_ptr(net_hotdata.skb_defer_nodes,
+							 cpu) + node);
+	}
+
 	return 0;
 }
 
diff --git a/net/core/dev.h b/net/core/dev.h
index b757faead4d1a..04fb0e9a571e0 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -399,6 +399,8 @@ static inline void napi_assert_will_not_race(const struct napi_struct *napi)
 	WARN_ON(READ_ONCE(napi->list_owner) != -1);
 }
 
+struct skb_defer_node;
+void skb_defer_node_flush(struct skb_defer_node *sdn);
 void kick_defer_list_purge(unsigned int cpu);
 
 int dev_set_hwtstamp_phylib(struct net_device *dev,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 89ee7907e4996..39102b3660034 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -7348,8 +7348,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 	struct skb_defer_node *sdn;
 	unsigned long defer_count;
 	unsigned int defer_max;
+	int cpu, my_cpu;
 	bool kick;
-	int cpu;
 
 	if (static_branch_unlikely(&skb_defer_disable_key))
 		goto nodefer;
@@ -7359,7 +7359,8 @@ void skb_attempt_defer_free(struct sk_buff *skb)
 		goto nodefer;
 
 	cpu = skb->alloc_cpu;
-	if (cpu == raw_smp_processor_id() ||
+	my_cpu = raw_smp_processor_id();
+	if (cpu == my_cpu ||
 	    WARN_ON_ONCE(cpu >= nr_cpu_ids) ||
 	    !cpu_online(cpu)) {
 nodefer:	kfree_skb_napi_cache(skb);
@@ -7370,7 +7371,7 @@ nodefer:	kfree_skb_napi_cache(skb);
 	DEBUG_NET_WARN_ON_ONCE(skb->destructor);
 	DEBUG_NET_WARN_ON_ONCE(skb_nfct(skb));
 
-	sdn = per_cpu_ptr(net_hotdata.skb_defer_nodes, cpu) + numa_node_id();
+	sdn = per_cpu_ptr(net_hotdata.skb_defer_nodes, cpu) + cpu_to_node(my_cpu);
 
 	defer_max = READ_ONCE(net_hotdata.sysctl_skb_defer_max);
 	defer_count = atomic_long_inc_return(&sdn->defer_count);
@@ -7380,6 +7381,11 @@ nodefer:	kfree_skb_napi_cache(skb);
 
 	llist_add(&skb->ll_node, &sdn->defer_list);
 
+	if (unlikely(!cpu_online(cpu) || my_cpu != raw_smp_processor_id())) {
+		skb_defer_node_flush(sdn);
+		return;
+	}
+
 	/* Send an IPI every time queue reaches half capacity. */
 	kick = (defer_count - 1) == (defer_max >> 1);
 
-- 
2.53.0



