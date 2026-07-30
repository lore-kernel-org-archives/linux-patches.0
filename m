Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34A14119F8;
	Thu, 30 Jul 2026 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423536; cv=none; b=DhOtwZam9VG2BP+rv37B0MMGFVY++iwx6d7qfL6Rq1F0M/NKYq9TVZqWlPPtlHMBl+FwKjQtcFTYAqm6aO4efjniPWG/25H0ZOJjNEvfYTsMoWxTWhPz+MbpKU2ytdmRkhgjg731MmtTGvpoDYFAeOLYhHqw+UgaeEgx32FlkDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423536; c=relaxed/simple;
	bh=y+LjNubACOPtuiYRaE2v9BAB8s35YJVFY3tg8tKPG3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQJSe6HkIGuVAUex24fyaJhEWnaKYmLLXiyU6LoXQ3OWu/qPlVfwu09+7x4aRQgJzcSipV/CszLDZCaypBH49zDvTYXUJzt9IPiJ0SKWlvbll+goSlN/WMV6xKDyBSMheDmjbCwww2rs83Zu9FNX5mhAfE6XAo+kNjRqTrcc6Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GvT76Gf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GvT76Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3FC1F000E9;
	Thu, 30 Jul 2026 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423534;
	bh=xxeekYy7shK8NPbsUqNpl4irMUslTEXrohtYbU9uby4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GvT76GfkcQMztkgVr/61Ca5kVCFpCEhvfknIrSu+wu2sTCmpaIBjXSMNgCioPjrs
	 WwmYhfL1NSGuhmoFlCMydZNAyPdE21VEDRpPzI72BX4DOfjltINN5S3TD9FGCb+4UV
	 SJ9f+0nnTMVH7Zp/Pbdt2dDxvMYvsJvrCCrWQGAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/675] net: plumb drop reasons to __dev_queue_xmit()
Date: Thu, 30 Jul 2026 16:06:04 +0200
Message-ID: <20260730141445.846025887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 6860b467f569 ("xfrm: propagate -EINPROGRESS from validate_xmit_xfrm()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 83 ++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8dee703a0916ed..246d654551ae56 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4702,9 +4702,10 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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
@@ -4773,59 +4774,61 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
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



