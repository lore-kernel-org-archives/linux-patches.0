Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEFA36F40C;
	Wed, 20 May 2026 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294762; cv=none; b=qDKLUyIgc3ogHTadj5NNVRlMvLY7gKplxO7gxTH9emHlfe4mpHBX7O5fPuxMTYZQvZvyiJ6m0sGrbl14maU/y5LnuhUnAEfwE1ghPoYZP4rVSrq/8qGxMyB2V4CZLr/Rht1jWgoYunnqB6RJWWr4zmSYDnAARPUZaXYKGxHqijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294762; c=relaxed/simple;
	bh=q8tMPjJDYaZhi2B9h2MMVEDG633mmYCKjgo2QlxpOBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXY0KBVb5nz7ZhEAk/BmLjkslhXMFoiiuFxnBa3/KMm1Bc3Ho+zIzGdCKhlYdDEwNMCH9lrpH9Y9EfcFmLUUeBOYVesl7ebWvWg7HTamUJ8JJmRBcCixi5KRRYUjLoD+X9tyUnRU2GXj8JGNm/axwdwvQ+oS/BJe71hm+46nSCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywyB02eM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywyB02eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A741F000E9;
	Wed, 20 May 2026 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294761;
	bh=n3QY+Ii7GbmC/k5dj4pzWYwTi61flhF6iTx51eMR8CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywyB02eMwIcG6LqO43AZPe4bVU2mLwhXYWNVPyF9v1dFbjYIMOqlMFzKrFv459KoT
	 j62Ph070RMe6RckoOcUobiq1HkbPYGTFF8rI5B/4QZTyAZJzi/8GOhDjnV4ivWqA20
	 JEI5cCyIwvwc1E2x+HWs1e2mqBsD0snE2I3NmNFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0161/1146] net: plumb drop reasons to __dev_queue_xmit()
Date: Wed, 20 May 2026 18:06:51 +0200
Message-ID: <20260520162151.938922737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 045f977dd4ebdd3ad8e96cf684917adfc5805adb ]

Add drop reasons to __dev_queue_xmit():

- SKB_DROP_REASON_DEV_READY : device is not UP.

- SKB_DROP_REASON_RECURSION_LIMIT : recursion limit on virtual device is hit.

Also add an unlikely() for the SKB_DROP_REASON_DEV_READY case,
and reduce indentation level.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260312201824.203093-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 83 ++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 831129f2a69b5..0f45825bbed2f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4761,9 +4761,10 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 {
 	struct net_device *dev = skb->dev;
 	struct netdev_queue *txq = NULL;
-	struct Qdisc *q;
-	int rc = -ENOMEM;
+	enum skb_drop_reason reason;
+	int cpu, rc = -ENOMEM;
 	bool again = false;
+	struct Qdisc *q;
 
 	skb_reset_mac_header(skb);
 	skb_assert_len(skb);
@@ -4832,59 +4833,61 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	 * Check this and shot the lock. It is not prone from deadlocks.
 	 *Either shot noqueue qdisc, it is even simpler 8)
 	 */
-	if (dev->flags & IFF_UP) {
-		int cpu = smp_processor_id(); /* ok because BHs are off */
+	if (unlikely(!(dev->flags & IFF_UP))) {
+		reason = SKB_DROP_REASON_DEV_READY;
+		goto drop;
+	}
 
-		if (!netif_tx_owned(txq, cpu)) {
-			bool is_list = false;
+	cpu = smp_processor_id(); /* ok because BHs are off */
 
-			if (dev_xmit_recursion())
-				goto recursion_alert;
+	if (likely(!netif_tx_owned(txq, cpu))) {
+		bool is_list = false;
 
-			skb = validate_xmit_skb(skb, dev, &again);
-			if (!skb)
-				goto out;
+		if (dev_xmit_recursion())
+			goto recursion_alert;
 
-			HARD_TX_LOCK(dev, txq, cpu);
+		skb = validate_xmit_skb(skb, dev, &again);
+		if (!skb)
+			goto out;
 
-			if (!netif_xmit_stopped(txq)) {
-				is_list = !!skb->next;
+		HARD_TX_LOCK(dev, txq, cpu);
 
-				dev_xmit_recursion_inc();
-				skb = dev_hard_start_xmit(skb, dev, txq, &rc);
-				dev_xmit_recursion_dec();
+		if (!netif_xmit_stopped(txq)) {
+			is_list = !!skb->next;
 
-				/* GSO segments a single SKB into
-				 * a list of frames. TCP expects error
-				 * to mean none of the data was sent.
-				 */
-				if (is_list)
-					rc = NETDEV_TX_OK;
-			}
-			HARD_TX_UNLOCK(dev, txq);
-			if (!skb) /* xmit completed */
-				goto out;
+			dev_xmit_recursion_inc();
+			skb = dev_hard_start_xmit(skb, dev, txq, &rc);
+			dev_xmit_recursion_dec();
 
-			net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
-					     dev->name);
-			/* NETDEV_TX_BUSY or queue was stopped */
-			if (!is_list)
-				rc = -ENETDOWN;
-		} else {
-			/* Recursion is detected! It is possible,
-			 * unfortunately
+			/* GSO segments a single SKB into a list of frames.
+			 * TCP expects error to mean none of the data was sent.
 			 */
-recursion_alert:
-			net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
-					     dev->name);
-			rc = -ENETDOWN;
+			if (is_list)
+				rc = NETDEV_TX_OK;
 		}
+		HARD_TX_UNLOCK(dev, txq);
+		if (!skb) /* xmit completed */
+			goto out;
+
+		net_crit_ratelimited("Virtual device %s asks to queue packet!\n",
+				     dev->name);
+		/* NETDEV_TX_BUSY or queue was stopped */
+		if (!is_list)
+			rc = -ENETDOWN;
+	} else {
+		/* Recursion is detected! It is possible unfortunately. */
+recursion_alert:
+		net_crit_ratelimited("Dead loop on virtual device %s, fix it urgently!\n",
+				     dev->name);
+		rc = -ENETDOWN;
 	}
 
+	reason = SKB_DROP_REASON_RECURSION_LIMIT;
+drop:
 	rcu_read_unlock_bh();
 
 	dev_core_stats_tx_dropped_inc(dev);
-	kfree_skb_list(skb);
+	kfree_skb_list_reason(skb, reason);
 	return rc;
 out:
 	rcu_read_unlock_bh();
-- 
2.53.0



