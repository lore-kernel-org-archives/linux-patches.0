Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DB33C2762;
	Sat, 30 May 2026 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164553; cv=none; b=NFJQsTa6chB/WTR7klweKlG8z3mI2qIzjVFidLvnIQuigMYoqNO0VVZwz9RObTS6WCU6oMJI0EcSPrSu4k3P7x4UYkhVJLc3yibvl2nI/5jb0N1NsKuw9aF9nGnt3DVQo6I/7mDSh22ukqecMubARKwY+FVB32tIrf0uYQ9nltI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164553; c=relaxed/simple;
	bh=Kg5tFDKEzMhm3UPAg1btpSbvqSMSMw9B6thPXNU+W/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf2GQA9dwoLI+yfwilFy05c69eRemOxISgz1RRSl9tT3HWOPDP/hoY927nwamNQnato0NnRwiGf4mNjbb04XYBoQqZGi6Sprz1LGEqnvJabNrDquW5Irb34qELAxUo8ILNsA/dSnOOXP92VVOf94ieafSDaHIly35S7/vVlmPeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dY465IXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dY465IXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813041F00898;
	Sat, 30 May 2026 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164551;
	bh=uyk9lg7f0QhaKbS7syCdpZavC9JtFOcSuZH1bsByaIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY465IXcSwcELKsco76H4di8LUSEGThNXUgaiMdgqiLyGqJ5S0ry7Pb8+GVG+K2dr
	 TQc+JKhlf1YJLaUwNBYGK7q0QCaHe8xEaBwHYsCY+NCcW0lCxGlJlmbB4RCflocncQ
	 9AhuvmarfzULrFvo7uRMoSL+mOf2hNtFpwh0qIg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 559/776] net/sched: taprio: refactor one skb dequeue from TXQ to separate function
Date: Sat, 30 May 2026 18:04:33 +0200
Message-ID: <20260530160254.587102560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a4501854e4b2..185f0bd7ed407 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -541,6 +541,66 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
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
@@ -566,64 +626,9 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
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



