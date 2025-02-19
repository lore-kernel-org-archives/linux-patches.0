Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A7C1B6D0A;
	Wed, 19 Feb 2025 08:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955089; cv=none; b=WFQ8CpGfI8J6wjSlflTxUyaI2QyJ/bBMsdfBqMgnwVufgnyrS2jtsgvoavjpO4JwGobcyMjdcVP1grWJOd3J5UAbQjUWHLTxl2GW8zD6vOoi+vfU3i57vl1Mx8Jf5L8Awl1wh7IRQA9o1efdRyfz+K4Zo1piu7V08AEwQmrIT6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955089; c=relaxed/simple;
	bh=summufS84jqjVB77ewAkGlzpdFR5wXBoR4IElQAjDuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/5RAbv0HWqSl3TVOUf/o1oU+TCNjt1KRCXlkme/JDzVYfSxb62fiKT8tqX/UlW4d7HN3726sNhzmjEwrSxfJufOBf76+XUhgWc/MHwRi6AfYnQkEiuaOSwwULE2DW/povJ2JjOb/sPc0auq8hKTORkdmyvjjwUHjVy/BqeS4RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KKdoDQPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKdoDQPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65EDC4CED1;
	Wed, 19 Feb 2025 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955089;
	bh=summufS84jqjVB77ewAkGlzpdFR5wXBoR4IElQAjDuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKdoDQPKxZxJgvXL04MIZtJG+sVHNCwKNzat6/LvK0+cgy8Zb0TLJjVNF6Ixeg3gr
	 PUJ/W+EtdsHdKMIyfyfXGBL+dbuxytTCX229wJhEDcB2VkAvE7+Z8FZUXBcNExiQHy
	 V3rLTSYZEc8FEE0gE/3qix+c4wxqlq1y+PR00QSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.12 096/230] batman-adv: Drop unmanaged ELP metric worker
Date: Wed, 19 Feb 2025 09:26:53 +0100
Message-ID: <20250219082605.451307554@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 8c8ecc98f5c65947b0070a24bac11e12e47cc65d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v.c     |    2 -
 net/batman-adv/bat_v_elp.c |   71 ++++++++++++++++++++++++++++++---------------
 net/batman-adv/bat_v_elp.h |    2 -
 net/batman-adv/types.h     |    3 -
 4 files changed, 48 insertions(+), 30 deletions(-)

--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -113,8 +113,6 @@ static void
 batadv_v_hardif_neigh_init(struct batadv_hardif_neigh_node *hardif_neigh)
 {
 	ewma_throughput_init(&hardif_neigh->bat_v.throughput);
-	INIT_WORK(&hardif_neigh->bat_v.metric_work,
-		  batadv_v_elp_throughput_metric_update);
 }
 
 /**
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -18,6 +18,7 @@
 #include <linux/if_ether.h>
 #include <linux/jiffies.h>
 #include <linux/kref.h>
+#include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
@@ -26,6 +27,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
+#include <linux/slab.h>
 #include <linux/stddef.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -42,6 +44,18 @@
 #include "send.h"
 
 /**
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
+/**
  * batadv_v_elp_start_timer() - restart timer for ELP periodic work
  * @hard_iface: the interface for which the timer has to be reset
  */
@@ -137,10 +151,17 @@ static bool batadv_v_elp_get_throughput(
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
@@ -175,31 +196,19 @@ default_throughput:
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
@@ -273,14 +282,16 @@ batadv_v_elp_wifi_neigh_probe(struct bat
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
@@ -316,6 +327,8 @@ static void batadv_v_elp_periodic_work(s
 
 	atomic_inc(&hard_iface->bat_v.elp_seqno);
 
+	INIT_LIST_HEAD(&metric_queue);
+
 	/* The throughput metric is updated on each sent packet. This way, if a
 	 * node is dead and no longer sends packets, batman-adv is still able to
 	 * react timely to its death.
@@ -340,16 +353,28 @@ static void batadv_v_elp_periodic_work(s
 
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
--- a/net/batman-adv/bat_v_elp.h
+++ b/net/batman-adv/bat_v_elp.h
@@ -10,7 +10,6 @@
 #include "main.h"
 
 #include <linux/skbuff.h>
-#include <linux/workqueue.h>
 
 int batadv_v_elp_iface_enable(struct batadv_hard_iface *hard_iface);
 void batadv_v_elp_iface_disable(struct batadv_hard_iface *hard_iface);
@@ -19,6 +18,5 @@ void batadv_v_elp_iface_activate(struct
 void batadv_v_elp_primary_iface_set(struct batadv_hard_iface *primary_iface);
 int batadv_v_elp_packet_recv(struct sk_buff *skb,
 			     struct batadv_hard_iface *if_incoming);
-void batadv_v_elp_throughput_metric_update(struct work_struct *work);
 
 #endif /* _NET_BATMAN_ADV_BAT_V_ELP_H_ */
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -596,9 +596,6 @@ struct batadv_hardif_neigh_node_bat_v {
 	 *  neighbor
 	 */
 	unsigned long last_unicast_tx;
-
-	/** @metric_work: work queue callback item for metric update */
-	struct work_struct metric_work;
 };
 
 /**


