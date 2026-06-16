Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481D638C437;
	Tue, 16 Jun 2026 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635363; cv=none; b=kkpDfc+kw/YaM/6+iWsETJDuihrTYnpR2SOBeX/ChTFcPI6+QVB78/QMZbcwDbK4UOSrFbAnGTvmwvhLxAMA39sz7J4Pi4eCoxPdDp/PgUrOBHb7+7EvCGPFATVpNjZ7tMJpxPazIp6mq7lekPwTwBsNtQiYX3lvfJs78xAznGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635363; c=relaxed/simple;
	bh=BmcW6Y8HqkEBUCAmvAO56sagcPtTuTfMh5uOW7U58oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWWI1alNsDkzhwrTTJ9XbmF5EpeYq4dV/fpFT3hxPgKXjiUAk2JSNDwe5BkU1+83xvlwSRsThbzuoVxOsGuSOJ2YrZ0N44P7CStc4LFKJPbkJmqpOsP5CS0FA77pR0GGERkxz2ElGhXxgyQKMN6fiPmaUAyPXTJPbGV8A9yirDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVwQdTJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVwQdTJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160CB1F000E9;
	Tue, 16 Jun 2026 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635361;
	bh=hDsbF2kh6ntDP36J/9coHvECNlYV8Wfz5l1Pq+6KTA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVwQdTJJfQd+rk9iVomb6X4vUHr6oHKvYeoNdtj2wgV5wYioli3mpYdNGPzwo6rLB
	 AB9KzS/YK98beV9s5AymlvWPQekUcDQWW3IRytTsk2LvUT4/jLXvCpZH5pmnqzT1in
	 mXlpt8zVwxfp+U2ELYokPck4JqgIXf9WO74xVIsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/342] batman-adv: iv: recover OGM scheduling after forward packet error
Date: Tue, 16 Jun 2026 20:25:30 +0530
Message-ID: <20260616145049.840135816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit aa3153bd139a6c48667dcd02608d3b2c80bff02c upstream.

When batadv_iv_ogm_schedule_buff() fails to allocate and queue a forward
packet for OGM transmission, the work item that drives periodic OGM
scheduling is never re-armed. This silently halts transmission of the
node's own OGMs on the affected interface — only OGMs from other peers
continue to be aggregated and forwarded.

Fix this by tracking whether batadv_iv_ogm_queue_add() (and transitively
batadv_iv_ogm_aggregate_new()) successfully scheduled a forward packet.
When scheduling fails, batadv_iv_ogm_schedule_buff() falls back to queuing
a dedicated recovery work item (reschedule_work) that fires after one
originator interval and calls batadv_iv_ogm_schedule() again.

Cc: stable@kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 76 +++++++++++++++++++++++++++----------
 net/batman-adv/types.h      |  3 ++
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 9cd2fa751c21ef..93c2c5f6facc0d 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -225,6 +225,8 @@ static void batadv_iv_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
 	hard_iface->bat_iv.ogm_buff = NULL;
 
 	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
+
+	cancel_delayed_work_sync(&hard_iface->bat_iv.reschedule_work);
 }
 
 static void batadv_iv_ogm_iface_update_mac(struct batadv_hard_iface *hard_iface)
@@ -530,8 +532,10 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
  * @if_incoming: interface where the packet was received
  * @if_outgoing: interface for which the retransmission should be considered
  * @own_packet: true if it is a self-generated ogm
+ *
+ * Return: whether forward packet was scheduled
  */
-static void batadv_iv_ogm_aggregate_new(const unsigned char *packet_buff,
+static bool batadv_iv_ogm_aggregate_new(const unsigned char *packet_buff,
 					int packet_len, unsigned long send_time,
 					bool direct_link,
 					struct batadv_hard_iface *if_incoming,
@@ -555,13 +559,13 @@ static void batadv_iv_ogm_aggregate_new(const unsigned char *packet_buff,
 
 	skb = netdev_alloc_skb_ip_align(NULL, skb_size);
 	if (!skb)
-		return;
+		return false;
 
 	forw_packet_aggr = batadv_forw_packet_alloc(if_incoming, if_outgoing,
 						    queue_left, bat_priv, skb);
 	if (!forw_packet_aggr) {
 		kfree_skb(skb);
-		return;
+		return false;
 	}
 
 	forw_packet_aggr->skb->priority = TC_PRIO_CONTROL;
@@ -583,6 +587,8 @@ static void batadv_iv_ogm_aggregate_new(const unsigned char *packet_buff,
 			  batadv_iv_send_outstanding_bat_ogm_packet);
 
 	batadv_forw_packet_ogmv1_queue(bat_priv, forw_packet_aggr, send_time);
+
+	return true;
 }
 
 /* aggregate a new packet into the existing ogm packet */
@@ -612,8 +618,10 @@ static void batadv_iv_ogm_aggregate(struct batadv_forw_packet *forw_packet_aggr,
  * @if_outgoing: interface for which the retransmission should be considered
  * @own_packet: true if it is a self-generated ogm
  * @send_time: timestamp (jiffies) when the packet is to be sent
+ *
+ * Return: whether forward packet was scheduled
  */
-static void batadv_iv_ogm_queue_add(struct batadv_priv *bat_priv,
+static bool batadv_iv_ogm_queue_add(struct batadv_priv *bat_priv,
 				    unsigned char *packet_buff,
 				    int packet_len,
 				    struct batadv_hard_iface *if_incoming,
@@ -665,14 +673,16 @@ static void batadv_iv_ogm_queue_add(struct batadv_priv *bat_priv,
 		if (!own_packet && atomic_read(&bat_priv->aggregated_ogms))
 			send_time += max_aggregation_jiffies;
 
-		batadv_iv_ogm_aggregate_new(packet_buff, packet_len,
-					    send_time, direct_link,
-					    if_incoming, if_outgoing,
-					    own_packet);
+		return batadv_iv_ogm_aggregate_new(packet_buff, packet_len,
+						   send_time, direct_link,
+						   if_incoming, if_outgoing,
+						   own_packet);
 	} else {
 		batadv_iv_ogm_aggregate(forw_packet_aggr, packet_buff,
 					packet_len, direct_link);
 		spin_unlock_bh(&bat_priv->forw_bat_list_lock);
+
+		return true;
 	}
 }
 
@@ -784,6 +794,8 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 	u32 seqno;
 	u16 tvlv_len = 0;
 	unsigned long send_time;
+	bool reschedule = false;
+	bool scheduled;
 	int ret;
 
 	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
@@ -812,11 +824,8 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 						       ogm_buff_len,
 						       BATADV_OGM_HLEN);
 		if (ret < 0) {
-			/* OGMs must be queued even when the buffer allocation for
-			 * TVLVs failed. just fall back to the non-TVLV version
-			 */
-			ret = 0;
-			*ogm_buff_len = BATADV_OGM_HLEN;
+			reschedule = true;
+			goto out;
 		}
 
 		tvlv_len = ret;
@@ -838,8 +847,11 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 		/* OGMs from secondary interfaces are only scheduled on their
 		 * respective interfaces.
 		 */
-		batadv_iv_ogm_queue_add(bat_priv, *ogm_buff, *ogm_buff_len,
-					hard_iface, hard_iface, 1, send_time);
+		scheduled = batadv_iv_ogm_queue_add(bat_priv, *ogm_buff, *ogm_buff_len,
+						    hard_iface, hard_iface, 1, send_time);
+		if (!scheduled)
+			reschedule = true;
+
 		goto out;
 	}
 
@@ -854,15 +866,28 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 		if (!kref_get_unless_zero(&tmp_hard_iface->refcount))
 			continue;
 
-		batadv_iv_ogm_queue_add(bat_priv, *ogm_buff,
-					*ogm_buff_len, hard_iface,
-					tmp_hard_iface, 1, send_time);
-
+		scheduled = batadv_iv_ogm_queue_add(bat_priv, *ogm_buff,
+						    *ogm_buff_len, hard_iface,
+						    tmp_hard_iface, 1, send_time);
 		batadv_hardif_put(tmp_hard_iface);
+
+		if (!scheduled && tmp_hard_iface == hard_iface)
+			reschedule = true;
 	}
 	rcu_read_unlock();
 
 out:
+	if (reschedule) {
+		/* there was a failure scheduling the own forward packet.
+		 * as result, the batadv_iv_send_outstanding_bat_ogm_packet()
+		 * work item is no longer scheduled. it is therefore necessary
+		 * to reschedule it manually
+		 */
+		queue_delayed_work(batadv_event_workqueue,
+				   &hard_iface->bat_iv.reschedule_work,
+				   msecs_to_jiffies(atomic_read(&bat_priv->orig_interval)));
+	}
+
 	if (primary_if)
 		batadv_hardif_put(primary_if);
 }
@@ -878,6 +903,17 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	mutex_unlock(&hard_iface->bat_iv.ogm_buff_mutex);
 }
 
+static void batadv_iv_ogm_reschedule(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct batadv_hard_iface *hard_iface;
+
+	hard_iface = container_of(delayed_work,
+				  struct batadv_hard_iface,
+				  bat_iv.reschedule_work);
+	batadv_iv_ogm_schedule(hard_iface);
+}
+
 /**
  * batadv_iv_orig_ifinfo_sum() - Get bcast_own sum for originator over interface
  * @orig_node: originator which reproadcasted the OGMs directly
@@ -2443,6 +2479,8 @@ batadv_iv_ogm_neigh_is_sob(struct batadv_neigh_node *neigh1,
 
 static void batadv_iv_iface_enabled(struct batadv_hard_iface *hard_iface)
 {
+	INIT_DELAYED_WORK(&hard_iface->bat_iv.reschedule_work, batadv_iv_ogm_reschedule);
+
 	/* begin scheduling originator messages on that interface */
 	batadv_iv_ogm_schedule(hard_iface);
 }
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index f7e5a8f7570a31..288fe330946fb4 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -83,6 +83,9 @@ struct batadv_hard_iface_bat_iv {
 	/** @ogm_seqno: OGM sequence number - used to identify each OGM */
 	atomic_t ogm_seqno;
 
+	/** @reschedule_work: recover OGM schedule after schedule error */
+	struct delayed_work reschedule_work;
+
 	/** @ogm_buff_mutex: lock protecting ogm_buff and ogm_buff_len */
 	struct mutex ogm_buff_mutex;
 };
-- 
2.53.0



