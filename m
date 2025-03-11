Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781D025E805;
	Tue, 11 Mar 2025 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707251; cv=none; b=S0XULtbcoMyVISqcjSE27MoRUwGC17B0WcbFTBIUNNgUQzU8im0kzzSEIz2MsdHKYV5OaaJVystqwcatgBAdP/VrAFiZ2icvommAnLRvzRMKPq8Xi5a79wuWAgxGpwygpxdL7bUMyk8SvukLsSAZkxuRwMgUpgeeoiCQ4jA423o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707251; c=relaxed/simple;
	bh=S4G2baEqlExgq7VCVfPT6UBPyF0N/+Fq148k648ohIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5pg3kgJjiiTEie+GPKp8bM4mVT/HGtjV1DQdQeQE7NTYOtJwGE6ingmS3IXr2VENIhnT3sTeOrbsbn/2hzYFFSqMrfe8qKfV017VbSeI2KwfPJwURJziNIc4VAVmmekOgZVQpmEXenqmnT1bIuTKjpOFbhiHcgVmfbxXeyernI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzzZo8VE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzzZo8VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF284C4CEE9;
	Tue, 11 Mar 2025 15:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707251;
	bh=S4G2baEqlExgq7VCVfPT6UBPyF0N/+Fq148k648ohIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzzZo8VECPpsx217EGxso7ddsoT99TNwAMKUl73cus2RQCJMgy4tq8HDpZ4KH4IOY
	 PtpKTIu5hYshMaMc/1iDR1iAF2hCfN2lkjdL0dhS4xDy3BfBF7Tj9pnk1RBprO5WYR
	 oDP2PkPcJjNAfqDpXQ5x8rNHUC+cXfaI5ECwhMfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/462] batman-adv: Drop unmanaged ELP metric worker
Date: Tue, 11 Mar 2025 15:59:52 +0100
Message-ID: <20250311145811.242744346@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 8c8ecc98f5c65947b0070a24bac11e12e47cc65d ]

The ELP worker needs to calculate new metric values for all neighbors
"reachable" over an interface. Some of the used metric sources require
locks which might need to sleep. This sleep is incompatible with the RCU
list iterator used for the recorded neighbors. The initial approach to work
around of this problem was to queue another work item per neighbor and then
run this in a new context.

Even when this solved the RCU vs might_sleep() conflict, it has a major
problems: Nothing was stopping the work item in case it is not needed
anymore - for example because one of the related interfaces was removed or
the batman-adv module was unloaded - resulting in potential invalid memory
accesses.

Directly canceling the metric worker also has various problems:

* cancel_work_sync for a to-be-deactivated interface is called with
  rtnl_lock held. But the code in the ELP metric worker also tries to use
  rtnl_lock() - which will never return in this case. This also means that
  cancel_work_sync would never return because it is waiting for the worker
  to finish.
* iterating over the neighbor list for the to-be-deactivated interface is
  currently done using the RCU specific methods. Which means that it is
  possible to miss items when iterating over it without the associated
  spinlock - a behaviour which is acceptable for a periodic metric check
  but not for a cleanup routine (which must "stop" all still running
  workers)

The better approch is to get rid of the per interface neighbor metric
worker and handle everything in the interface worker. The original problems
are solved by:

* creating a list of neighbors which require new metric information inside
  the RCU protected context, gathering the metric according to the new list
  outside the RCU protected context
* only use rcu_trylock inside metric gathering code to avoid a deadlock
  when the cancel_delayed_work_sync is called in the interface removal code
  (which is called with the rtnl_lock held)

Cc: stable@vger.kernel.org
Fixes: c833484e5f38 ("batman-adv: ELP - compute the metric based on the estimated throughput")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v.c     |  2 --
 net/batman-adv/bat_v_elp.c | 71 ++++++++++++++++++++++++++------------
 net/batman-adv/bat_v_elp.h |  2 --
 net/batman-adv/types.h     |  3 --
 4 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index e91d2c0720c4c..6dc39fc0350e6 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -116,8 +116,6 @@ static void
 batadv_v_hardif_neigh_init(struct batadv_hardif_neigh_node *hardif_neigh)
 {
 	ewma_throughput_init(&hardif_neigh->bat_v.throughput);
-	INIT_WORK(&hardif_neigh->bat_v.metric_work,
-		  batadv_v_elp_throughput_metric_update);
 }
 
 #ifdef CONFIG_BATMAN_ADV_DEBUGFS
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 81b9dfec7151a..eacf53161304a 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
@@ -27,6 +28,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -42,6 +44,18 @@
 #include "routing.h"
 #include "send.h"
 
+/**
+ * struct batadv_v_metric_queue_entry - list of hardif neighbors which require
+ *  and metric update
+ */
+struct batadv_v_metric_queue_entry {
+	/** @hardif_neigh: hardif neighbor scheduled for metric update */
+	struct batadv_hardif_neigh_node *hardif_neigh;
+
+	/** @list: list node for metric_queue */
+	struct list_head list;
+};
+
 /**
  * batadv_v_elp_start_timer() - restart timer for ELP periodic work
  * @hard_iface: the interface for which the timer has to be reset
@@ -138,10 +152,17 @@ static bool batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh,
 		goto default_throughput;
 	}
 
+	/* only use rtnl_trylock because the elp worker will be cancelled while
+	 * the rntl_lock is held. the cancel_delayed_work_sync() would otherwise
+	 * wait forever when the elp work_item was started and it is then also
+	 * trying to rtnl_lock
+	 */
+	if (!rtnl_trylock())
+		return false;
+
 	/* if not a wifi interface, check if this device provides data via
 	 * ethtool (e.g. an Ethernet adapter)
 	 */
-	rtnl_lock();
 	ret = __ethtool_get_link_ksettings(hard_iface->net_dev, &link_settings);
 	rtnl_unlock();
 	if (ret == 0) {
@@ -176,31 +197,19 @@ static bool batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh,
 /**
  * batadv_v_elp_throughput_metric_update() - worker updating the throughput
  *  metric of a single hop neighbour
- * @work: the work queue item
+ * @neigh: the neighbour to probe
  */
-void batadv_v_elp_throughput_metric_update(struct work_struct *work)
+static void
+batadv_v_elp_throughput_metric_update(struct batadv_hardif_neigh_node *neigh)
 {
-	struct batadv_hardif_neigh_node_bat_v *neigh_bat_v;
-	struct batadv_hardif_neigh_node *neigh;
 	u32 throughput;
 	bool valid;
 
-	neigh_bat_v = container_of(work, struct batadv_hardif_neigh_node_bat_v,
-				   metric_work);
-	neigh = container_of(neigh_bat_v, struct batadv_hardif_neigh_node,
-			     bat_v);
-
 	valid = batadv_v_elp_get_throughput(neigh, &throughput);
 	if (!valid)
-		goto put_neigh;
+		return;
 
 	ewma_throughput_add(&neigh->bat_v.throughput, throughput);
-
-put_neigh:
-	/* decrement refcounter to balance increment performed before scheduling
-	 * this task
-	 */
-	batadv_hardif_neigh_put(neigh);
 }
 
 /**
@@ -274,14 +283,16 @@ batadv_v_elp_wifi_neigh_probe(struct batadv_hardif_neigh_node *neigh)
  */
 static void batadv_v_elp_periodic_work(struct work_struct *work)
 {
+	struct batadv_v_metric_queue_entry *metric_entry;
+	struct batadv_v_metric_queue_entry *metric_safe;
 	struct batadv_hardif_neigh_node *hardif_neigh;
 	struct batadv_hard_iface *hard_iface;
 	struct batadv_hard_iface_bat_v *bat_v;
 	struct batadv_elp_packet *elp_packet;
+	struct list_head metric_queue;
 	struct batadv_priv *bat_priv;
 	struct sk_buff *skb;
 	u32 elp_interval;
-	bool ret;
 
 	bat_v = container_of(work, struct batadv_hard_iface_bat_v, elp_wq.work);
 	hard_iface = container_of(bat_v, struct batadv_hard_iface, bat_v);
@@ -317,6 +328,8 @@ static void batadv_v_elp_periodic_work(struct work_struct *work)
 
 	atomic_inc(&hard_iface->bat_v.elp_seqno);
 
+	INIT_LIST_HEAD(&metric_queue);
+
 	/* The throughput metric is updated on each sent packet. This way, if a
 	 * node is dead and no longer sends packets, batman-adv is still able to
 	 * react timely to its death.
@@ -341,16 +354,28 @@ static void batadv_v_elp_periodic_work(struct work_struct *work)
 
 		/* Reading the estimated throughput from cfg80211 is a task that
 		 * may sleep and that is not allowed in an rcu protected
-		 * context. Therefore schedule a task for that.
+		 * context. Therefore add it to metric_queue and process it
+		 * outside rcu protected context.
 		 */
-		ret = queue_work(batadv_event_workqueue,
-				 &hardif_neigh->bat_v.metric_work);
-
-		if (!ret)
+		metric_entry = kzalloc(sizeof(*metric_entry), GFP_ATOMIC);
+		if (!metric_entry) {
 			batadv_hardif_neigh_put(hardif_neigh);
+			continue;
+		}
+
+		metric_entry->hardif_neigh = hardif_neigh;
+		list_add(&metric_entry->list, &metric_queue);
 	}
 	rcu_read_unlock();
 
+	list_for_each_entry_safe(metric_entry, metric_safe, &metric_queue, list) {
+		batadv_v_elp_throughput_metric_update(metric_entry->hardif_neigh);
+
+		batadv_hardif_neigh_put(metric_entry->hardif_neigh);
+		list_del(&metric_entry->list);
+		kfree(metric_entry);
+	}
+
 restart_timer:
 	batadv_v_elp_start_timer(hard_iface);
 out:
diff --git a/net/batman-adv/bat_v_elp.h b/net/batman-adv/bat_v_elp.h
index 4358d436be2a8..f814f87f3a6a4 100644
--- a/net/batman-adv/bat_v_elp.h
+++ b/net/batman-adv/bat_v_elp.h
@@ -10,7 +10,6 @@
 #include "main.h"
 
 #include <linux/skbuff.h>
-#include <linux/workqueue.h>
 
 int batadv_v_elp_iface_enable(struct batadv_hard_iface *hard_iface);
 void batadv_v_elp_iface_disable(struct batadv_hard_iface *hard_iface);
@@ -19,6 +18,5 @@ void batadv_v_elp_iface_activate(struct batadv_hard_iface *primary_iface,
 void batadv_v_elp_primary_iface_set(struct batadv_hard_iface *primary_iface);
 int batadv_v_elp_packet_recv(struct sk_buff *skb,
 			     struct batadv_hard_iface *if_incoming);
-void batadv_v_elp_throughput_metric_update(struct work_struct *work);
 
 #endif /* _NET_BATMAN_ADV_BAT_V_ELP_H_ */
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 7d47fe7534c18..cc3334afbdd05 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -606,9 +606,6 @@ struct batadv_hardif_neigh_node_bat_v {
 	 *  neighbor
 	 */
 	unsigned long last_unicast_tx;
-
-	/** @metric_work: work queue callback item for metric update */
-	struct work_struct metric_work;
 };
 
 /**
-- 
2.39.5



