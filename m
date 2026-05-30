Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311D114A62B;
	Sat, 30 May 2026 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161639; cv=none; b=drizlvrBgK/ubEk4GCWK/k8CuWVpKv86RmIXJwr2zW4U9YPORUlgLNsQSCUzoMO3IYZBDv7mft6WBTN/bpeAyMQY2xJoTV/SihhSZtF2Sdumw07JaAEHZfTf1MEpPyi2bD5ZXejM6NIHHBSIW43xhzdhpZ5f9+AiIzhWfPnoTYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161639; c=relaxed/simple;
	bh=LvqubEgZ7jP09zT8wYQ9U9136QYKPdhd3Gh6aI+2P68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmnQXJz+FUBaRKJa1sUTu4um3TllJUNkZFqZgHMOZtyQ1gal6m79vihrmWv2cDjufwsuS/wZZExP2nl6U8e/xkztozEML6TuPh7E0/tZE2KOdXgAj1UPLP4nydprQhhCYvaWR4f/AOoyODGiIiGX4pUdrVSwPrx7MdAJIaoR3LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quLUJ0lK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quLUJ0lK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765F31F00893;
	Sat, 30 May 2026 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161638;
	bh=AZUTv+N0NeNhh2VbesiEdKDdW2XLAFSjtx6HUIvhNw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quLUJ0lK2eLHFqDJ5LP4M3bxajoWVvOGPyxhizWlg5+g6LfiJdUzqKKHSXK2PivcH
	 /9wpOKQp+JzB/82S2b7gttUxHR8UJXeovtPPPuBF7f3uR8V5nTl3VzBnjuMyAUAy8Z
	 fnDxuhjoev6uVSZjpsEhmAvGpmYx1zhfiqqHxDnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 683/969] net/sched: taprio: refactor one skb dequeue from TXQ to separate function
Date: Sat, 30 May 2026 18:03:27 +0200
Message-ID: <20260530160319.365911839@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 92f966674f6a257eddfa60a85f9b6741d6087ccb ]

Future changes will refactor the TXQ selection procedure, and a lot of
stuff will become messy, the indentation of the bulk of the dequeue
procedure would increase, etc.

Break out the bulk of the function into a new one, which knows the TXQ
(child qdisc) we should perform a dequeue from.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 121 +++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 58 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index aad95b084ae36..10e1a420d4495 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -551,6 +551,66 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
+static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
+					       struct sched_entry *entry,
+					       u32 gate_mask)
+{
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	struct Qdisc *child = q->qdiscs[txq];
+	struct sk_buff *skb;
+	ktime_t guard;
+	int prio;
+	int len;
+	u8 tc;
+
+	if (unlikely(!child))
+		return NULL;
+
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
+		skb = child->ops->dequeue(child);
+		if (!skb)
+			return NULL;
+		goto skb_found;
+	}
+
+	skb = child->ops->peek(child);
+	if (!skb)
+		return NULL;
+
+	prio = skb->priority;
+	tc = netdev_get_prio_tc_map(dev, prio);
+
+	if (!(gate_mask & BIT(tc)))
+		return NULL;
+
+	len = qdisc_pkt_len(skb);
+	guard = ktime_add_ns(taprio_get_time(q), length_to_duration(q, len));
+
+	/* In the case that there's no gate entry, there's no
+	 * guard band ...
+	 */
+	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
+	    ktime_after(guard, entry->close_time))
+		return NULL;
+
+	/* ... and no budget. */
+	if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
+	    atomic_sub_return(len, &entry->budget) < 0)
+		return NULL;
+
+	skb = child->ops->dequeue(child);
+	if (unlikely(!skb))
+		return NULL;
+
+skb_found:
+	qdisc_bstats_update(sch, skb);
+	qdisc_qstats_backlog_dec(sch, skb);
+	sch->q.qlen--;
+
+	return skb;
+}
+
 /* Will not be called in the full offload case, since the TX queues are
  * attached to the Qdisc created using qdisc_create_dflt()
  */
@@ -576,64 +636,9 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 		goto done;
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-		ktime_t guard;
-		int prio;
-		int len;
-		u8 tc;
-
-		if (unlikely(!child))
-			continue;
-
-		if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-			skb = child->ops->dequeue(child);
-			if (!skb)
-				continue;
-			goto skb_found;
-		}
-
-		skb = child->ops->peek(child);
-		if (!skb)
-			continue;
-
-		prio = skb->priority;
-		tc = netdev_get_prio_tc_map(dev, prio);
-
-		if (!(gate_mask & BIT(tc))) {
-			skb = NULL;
-			continue;
-		}
-
-		len = qdisc_pkt_len(skb);
-		guard = ktime_add_ns(taprio_get_time(q),
-				     length_to_duration(q, len));
-
-		/* In the case that there's no gate entry, there's no
-		 * guard band ...
-		 */
-		if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-		    ktime_after(guard, entry->close_time)) {
-			skb = NULL;
-			continue;
-		}
-
-		/* ... and no budget. */
-		if (gate_mask != TAPRIO_ALL_GATES_OPEN &&
-		    atomic_sub_return(len, &entry->budget) < 0) {
-			skb = NULL;
-			continue;
-		}
-
-		skb = child->ops->dequeue(child);
-		if (unlikely(!skb))
-			continue;
-
-skb_found:
-		qdisc_bstats_update(sch, skb);
-		qdisc_qstats_backlog_dec(sch, skb);
-		sch->q.qlen--;
-
-		goto done;
+		skb = taprio_dequeue_from_txq(sch, i, entry, gate_mask);
+		if (skb)
+			goto done;
 	}
 
 done:
-- 
2.53.0



