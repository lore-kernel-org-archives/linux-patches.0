Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C43414DED;
	Thu,  2 Jul 2026 16:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009537; cv=none; b=iLNjTNOJlreJe+KAAonGwfcQrn5QPhstjk9KiJMEeKxCRVubXczlK9zcjlTpXI2lvp2N6QY7+gXz1p71YNrA+BX0JinCohKvjK4jy9q9ImE77SuFhu/+kxGeWBpoFjs5zm4iY4VSwDx36mEzWqLL69UQxy03w6BUQXGVyAigjGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009537; c=relaxed/simple;
	bh=egyWQCcLfekNqUrJ7fe3r/NrVf/EBW85z8JCQvcejHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+XX4/ORKubQE0lYG8qDW92JMQ1SeI1kLkeAgMb0Cxz/8Jtw+poEcWvQAalaFC+2+5lyIrajqktdvF84/PpkMV09YwNcXf+Iliyc7r5VUCRZbdq4pCWYRZb7/oYBc+YgZuAJAzJ3de+zGCrGPCvZ/HobROAwz4jljrMAtqUB0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY+tkBNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY+tkBNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023E51F000E9;
	Thu,  2 Jul 2026 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009531;
	bh=vdfwFih3jY3ArGy2ZhUe8bAyK+TKzNybHGgAer0dvj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PY+tkBNfXQgVQxBoh3p1iRTqaQSwonJq+5OBU86UFzSqPChg7mDcbf/t5YQe0OIxI
	 SNHcqYEHztw1eXrbrPw0YZxffMKL4RAyWOEGXw6NHlQi2jv1D7O4qXOY8Qe5OVGoVy
	 lO48EE5ncYEpQsqHUlr4hmjLGbuZ9BWrD/m7sKpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/96] batman-adv: tp_meter: prevent parallel modifications of last_recv
Date: Thu,  2 Jul 2026 18:19:42 +0200
Message-ID: <20260702155110.035435467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 6dde0cfcb36e4d5b3de35b75696937478441eed4 upstream.

When last_recv is updated to store the last receive sequence number, it is
assuming that nothing is modifying in parallel while:

* check for outdated packets is done
* out of order check is performed (and packets are stored in out-of-order
  queue)
* the out-of-order queue was searched for closed gaps
* sequence number for next ack is calculated

Nothing of that was actually protected. It could therefore happen that the
last_recv was updated multiple times in parallel and the final sequence
number was calculated with deltas which had no connection to the sequence
number they were added to.

Lock this whole region with the same lock which was already used to protect
the unacked (out-of-order) list.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Switch to pre-splitted tp_vars structure names ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 22 +++++++++++++---------
 net/batman-adv/types.h    |  2 +-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 91392e48514d64..c01ff6e72b5da5 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1303,6 +1303,7 @@ static int batadv_tp_send_ack(struct batadv_priv *bat_priv, const u8 *dst,
  */
 static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
 					  const struct sk_buff *skb)
+	__must_hold(&tp_vars->unacked_lock)
 {
 	const struct batadv_icmp_tp_packet *icmp;
 	struct batadv_tp_unacked *un, *new;
@@ -1319,12 +1320,11 @@ static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
 	payload_len = skb->len - sizeof(struct batadv_unicast_packet);
 	new->len = payload_len;
 
-	spin_lock_bh(&tp_vars->unacked_lock);
 	/* if the list is empty immediately attach this new object */
 	if (list_empty(&tp_vars->unacked_list)) {
 		list_add(&new->list, &tp_vars->unacked_list);
 		tp_vars->unacked_count++;
-		goto out;
+		return true;
 	}
 
 	/* otherwise loop over the list and either drop the packet because this
@@ -1373,9 +1373,6 @@ static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
 		tp_vars->unacked_count--;
 	}
 
-out:
-	spin_unlock_bh(&tp_vars->unacked_lock);
-
 	return true;
 }
 
@@ -1385,6 +1382,7 @@ static bool batadv_tp_handle_out_of_order(struct batadv_tp_vars *tp_vars,
  * @tp_vars: the private data of the current TP meter session
  */
 static void batadv_tp_ack_unordered(struct batadv_tp_vars *tp_vars)
+	__must_hold(&tp_vars->unacked_lock)
 {
 	struct batadv_tp_unacked *un, *safe;
 	u32 to_ack;
@@ -1392,7 +1390,6 @@ static void batadv_tp_ack_unordered(struct batadv_tp_vars *tp_vars)
 	/* go through the unacked packet list and possibly ACK them as
 	 * well
 	 */
-	spin_lock_bh(&tp_vars->unacked_lock);
 	list_for_each_entry_safe(un, safe, &tp_vars->unacked_list, list) {
 		/* the list is ordered, therefore it is possible to stop as soon
 		 * there is a gap between the last acked seqno and the seqno of
@@ -1410,7 +1407,6 @@ static void batadv_tp_ack_unordered(struct batadv_tp_vars *tp_vars)
 		kfree(un);
 		tp_vars->unacked_count--;
 	}
-	spin_unlock_bh(&tp_vars->unacked_lock);
 }
 
 /**
@@ -1489,6 +1485,7 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 	const struct batadv_icmp_tp_packet *icmp;
 	struct batadv_tp_vars *tp_vars;
 	size_t packet_size;
+	u32 to_ack;
 	u32 seqno;
 
 	icmp = (struct batadv_icmp_tp_packet *)skb->data;
@@ -1517,6 +1514,8 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 		WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 	}
 
+	spin_lock_bh(&tp_vars->unacked_lock);
+
 	/* if the packet is a duplicate, it may be the case that an ACK has been
 	 * lost. Resend the ACK
 	 */
@@ -1528,8 +1527,10 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 		/* exit immediately (and do not send any ACK) if the packet has
 		 * not been enqueued correctly
 		 */
-		if (!batadv_tp_handle_out_of_order(tp_vars, skb))
+		if (!batadv_tp_handle_out_of_order(tp_vars, skb)) {
+			spin_unlock_bh(&tp_vars->unacked_lock);
 			goto out;
+		}
 
 		/* send a duplicate ACK */
 		goto send_ack;
@@ -1543,11 +1544,14 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 	batadv_tp_ack_unordered(tp_vars);
 
 send_ack:
+	to_ack = tp_vars->last_recv;
+	spin_unlock_bh(&tp_vars->unacked_lock);
+
 	/* send the ACK. If the received packet was out of order, the ACK that
 	 * is going to be sent is a duplicate (the sender will count them and
 	 * possibly enter Fast Retransmit as soon as it has reached 3)
 	 */
-	batadv_tp_send_ack(bat_priv, icmp->orig, tp_vars->last_recv,
+	batadv_tp_send_ack(bat_priv, icmp->orig, to_ack,
 			   icmp->timestamp, icmp->session, icmp->uid);
 out:
 	if (likely(tp_vars))
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index b12b0851df6e7e..437d651a1cffe3 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1505,7 +1505,7 @@ struct batadv_tp_vars {
 	/** @unacked_list: list of unacked packets (meta-info only) */
 	struct list_head unacked_list;
 
-	/** @unacked_lock: protect unacked_list */
+	/** @unacked_lock: protect unacked_list + &batadv_tp_receiver.last_recv */
 	spinlock_t unacked_lock;
 
 	/** @unacked_count: number of unacked entries */
-- 
2.53.0



