Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40F431F98D;
	Sat, 30 May 2026 18:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164538; cv=none; b=Dn1PKaM6VVfKwu9awUI0V2QWdZ5yBfEYHDI+Q6oDE1yUHSR4OAnv1WcoiziRgk6B7yCj1Qc4SUBts4RAreDloeUPhNe2CkrE4ExyVLoT/0xdjyc7DNzIRsV9qFv9kTOjr9NVprDntXAYwraKVysYqFEwBKODBRAybDmrBj6ystA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164538; c=relaxed/simple;
	bh=KzZ2BcT/GczkJzSNT/0L2PhDIDTsFC9goJDtRoBhq/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KM6vpZDf1q9aH2UxGoFtezfFumps5kb5sllu0mIXBcGWvlD6q7BswlUPL7nEyGNdea3dIvxQH4ZBBXrUkKN08teYaAlCFrX1mmFE6RBT2ER6Bj4lh79uSe6OYqGYmLnjVxybZ2q/cuv8CAABo6u8vO4frmp8U/L8HYIyJhfAWy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBJO7dFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBJO7dFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82AF1F00893;
	Sat, 30 May 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164537;
	bh=b4xFceBtOxLWNWj6S/UJf3Vm51h/ORr+jdixdxmSkcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBJO7dFe1DVVLbisrNf1x/WZ+CRUREhanqtdyuyY5IxCVBa25GX2E35fjhFgFFjnJ
	 6rsauyD0qHD0gETK9/pjDQFzD1a/oYLfTVY4mermH7iyGdPaRED4OghdOH3cThOarf
	 2EkEv+9RhLkir6hhny2zJIiWjRiwUU2iY7/9BhPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/776] net/sched: taprio: replace safety precautions with comments
Date: Sat, 30 May 2026 18:04:31 +0200
Message-ID: <20260530160254.538641648@linuxfoundation.org>
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

[ Upstream commit 2c08a4f898d0a8e08f431709a1ae728a6fddaabd ]

The WARN_ON_ONCE() checks introduced in commit 13511704f8d7 ("net:
taprio offload: enforce qdisc to netdev queue mapping") take a small
toll on performance, but otherwise, the conditions are never expected to
happen. Replace them with comments, such that the information is still
conveyed to developers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9c86c8ade4853..8924b439c459d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -432,6 +432,9 @@ static int taprio_enqueue_one(struct sk_buff *skb, struct Qdisc *sch,
 	return qdisc_enqueue(skb, child, to_free);
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			  struct sk_buff **to_free)
 {
@@ -439,11 +442,6 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct Qdisc *child;
 	int queue;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to enqueue skb into the root of a taprio qdisc configured with full offload\n");
-		return qdisc_drop(skb, sch, to_free);
-	}
-
 	queue = skb_get_queue_mapping(skb);
 
 	child = q->qdiscs[queue];
@@ -489,6 +487,9 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -498,11 +499,6 @@ static struct sk_buff *taprio_peek(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
-		return NULL;
-	}
-
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
@@ -545,6 +541,9 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
+/* Will not be called in the full offload case, since the TX queues are
+ * attached to the Qdisc created using qdisc_create_dflt()
+ */
 static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -554,11 +553,6 @@ static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
-	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
-		WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
-		return NULL;
-	}
-
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	/* if there's no entry, it means that the schedule didn't
-- 
2.53.0



