Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5B03112C1;
	Sat, 30 May 2026 18:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164501; cv=none; b=Sx+cYde1/IIO+z7JjvJ1UQPD1hlK6CkYAGofPpNGyRF/Ta2uSEbgaJuKYA2jQjapHrk3YYLQnF5ScDlxNdqdRg42dRN+L3nx4ln/WfOpvds5UXQIg57mEQn/GUDLx8R8WClhWN9a5RuWyCzXsxTs9RU944s5EPiAvGiM4VZoDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164501; c=relaxed/simple;
	bh=cKC1JEvLRxC/Jh5HfbzMt1fE2BPC1x8YNvIJggsdjXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjNaGN8awRnr4/rkaLDGx+koKEKvqwrLc51VFs2Sxg4RCm+xlb0yj1QaKiqUdoeey4J2UB0cEFtDA/m7z9yHvs1leJtP0PWxV/hws1eswG5h4DdbneUXA+1+GAWqLO4qS/M09CH6JOgZxUwcDf3Y7q4CYr+uiBzJGd7k9LDZJA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKeB38HG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKeB38HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759AC1F00893;
	Sat, 30 May 2026 18:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164500;
	bh=4/GPdMaruGSPn7PrUz0Kw04o6jfksCIBpUPYfsM/0JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKeB38HGvpkVeKTkTQ8NVtUvtgdLgfdT3T55TwZCvhf/RvQHs7CZqOkPQ7OkGQ4AW
	 RSSpV4Xi9toil+hTElGojRDCdixe8t5qydb42I0AnylZz5XnT3Mb9qeV1UqInF0Dq6
	 nzZonIjnREycMmvD68yHkCCaRNUlFHP7PKcVjqOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 556/776] net/sched: taprio: stop going through private ops for dequeue and peek
Date: Sat, 30 May 2026 18:04:30 +0200
Message-ID: <20260530160254.513618074@linuxfoundation.org>
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

[ Upstream commit 25becba6290bc34e369a0e1a76db9ca88bad87aa ]

Since commit 13511704f8d7 ("net: taprio offload: enforce qdisc to netdev
queue mapping"), taprio_dequeue_soft() and taprio_peek_soft() are de
facto the only implementations for Qdisc_ops :: dequeue and Qdisc_ops ::
peek that taprio provides.

This is because in full offload mode, __dev_queue_xmit() will select a
txq->qdisc which is never root taprio qdisc. So if nothing is enqueued
in the root qdisc, it will never be run and nothing will get dequeued
from it.

Therefore, we can remove the private indirection from taprio, and always
point Qdisc_ops :: dequeue to taprio_dequeue_soft (now simply named
taprio_dequeue) and Qdisc_ops :: peek to taprio_peek_soft (now simply
named taprio_peek).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 105425b1969c ("net/sched: taprio: fix use-after-free in advance_sched() on schedule switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 58 +++++++++---------------------------------
 1 file changed, 12 insertions(+), 46 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 44b971ef343ce..9c86c8ade4853 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -78,8 +78,6 @@ struct taprio_sched {
 	struct sched_gate_list __rcu *admin_sched;
 	struct hrtimer advance_timer;
 	struct list_head taprio_list;
-	struct sk_buff *(*dequeue)(struct Qdisc *sch);
-	struct sk_buff *(*peek)(struct Qdisc *sch);
 	u32 txtime_delay;
 };
 
@@ -491,7 +489,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
 
-static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
+static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -500,6 +498,11 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
+		return NULL;
+	}
+
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
@@ -535,20 +538,6 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *sch)
 	return NULL;
 }
 
-static struct sk_buff *taprio_peek_offload(struct Qdisc *sch)
-{
-	WARN_ONCE(1, "Trying to peek into the root of a taprio qdisc configured with full offload\n");
-
-	return NULL;
-}
-
-static struct sk_buff *taprio_peek(struct Qdisc *sch)
-{
-	struct taprio_sched *q = qdisc_priv(sch);
-
-	return q->peek(sch);
-}
-
 static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 {
 	atomic_set(&entry->budget,
@@ -556,7 +545,7 @@ static void taprio_set_budget(struct taprio_sched *q, struct sched_entry *entry)
 			     atomic64_read(&q->picos_per_byte)));
 }
 
-static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
+static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
@@ -565,6 +554,11 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 	u32 gate_mask;
 	int i;
 
+	if (unlikely(FULL_OFFLOAD_IS_ENABLED(q->flags))) {
+		WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
+		return NULL;
+	}
+
 	rcu_read_lock();
 	entry = rcu_dereference(q->current_entry);
 	/* if there's no entry, it means that the schedule didn't
@@ -644,20 +638,6 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 	return skb;
 }
 
-static struct sk_buff *taprio_dequeue_offload(struct Qdisc *sch)
-{
-	WARN_ONCE(1, "Trying to dequeue from the root of a taprio qdisc configured with full offload\n");
-
-	return NULL;
-}
-
-static struct sk_buff *taprio_dequeue(struct Qdisc *sch)
-{
-	struct taprio_sched *q = qdisc_priv(sch);
-
-	return q->dequeue(sch);
-}
-
 static bool should_restart_cycle(const struct sched_gate_list *oper,
 				 const struct sched_entry *entry)
 {
@@ -1572,17 +1552,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 		q->advance_timer.function = advance_sched;
 	}
 
-	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
-		q->dequeue = taprio_dequeue_offload;
-		q->peek = taprio_peek_offload;
-	} else {
-		/* Be sure to always keep the function pointers
-		 * in a consistent state.
-		 */
-		q->dequeue = taprio_dequeue_soft;
-		q->peek = taprio_peek_soft;
-	}
-
 	err = taprio_get_start_time(sch, new_admin, &start);
 	if (err < 0) {
 		NL_SET_ERR_MSG(extack, "Internal error: failed get start time");
@@ -1698,9 +1667,6 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	hrtimer_init(&q->advance_timer, CLOCK_TAI, HRTIMER_MODE_ABS);
 	q->advance_timer.function = advance_sched;
 
-	q->dequeue = taprio_dequeue_soft;
-	q->peek = taprio_peek_soft;
-
 	q->root = sch;
 
 	/* We only support static clockids. Use an invalid value as default
-- 
2.53.0



