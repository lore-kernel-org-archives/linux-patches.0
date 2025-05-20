Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D7C242D79;
	Tue, 20 May 2025 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749714; cv=none; b=a+DphHEYhNbllE5MeDJpmrXDzzvuAVBzcQ3nIrlbzOmsL86oe5RYrFAjCrVJ/j8jtdtymqjN+rUYCdUdhMCGQ1cTxFUAG7qbt+bH3x6CHtdTVYqtkYqTkSFeDi164jvTSqr06rPeLe5QgLCCbcoJP1lSf3KzS8T8iL9uFkWC7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749714; c=relaxed/simple;
	bh=e+sK+wRGAemWV5Mlb6+QXbF137Ih5XUej35L62862Zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVhpJcUZMM9yX1NF2YRrOVNzQhUNI7z8uwywpklY1esRwxPKS1f558R7KAJuEDMSUJC5hdbNzyJWIVp+zdO1UAr1Gi0kzGyAXEdVx0pBH+aoxQW08gaeZUO3Zc4ATZEizv49+RAGh5xSsDSysYW7dpIphbsWHgB0qGCqG3LP8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfSbewni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfSbewni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C93C4CEE9;
	Tue, 20 May 2025 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749714;
	bh=e+sK+wRGAemWV5Mlb6+QXbF137Ih5XUej35L62862Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfSbewni5qRfIMysStgAfbW/wlSOeI4+8HhtsmVRTGt1Br8UlPP1wIsMrXICwkJHL
	 NP9/bhLq5j+G9Zm3i+xC8wDzKwsgWUoI19guNK/JEJYyO5HFN5IZIC09OjPw0Qsjzt
	 J6Rjh29iBX3jkM0PCLJTRAMr8b1/UIgnSmwXufQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will <willsroot@protonmail.com>,
	Savy <savy@syst3mfailure.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/117] net_sched: Flush gso_skb list too during ->change()
Date: Tue, 20 May 2025 15:50:01 +0200
Message-ID: <20250520125805.426455223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 2d3cbfd6d54a2c39ce3244f33f85c595844bd7b8 ]

Previously, when reducing a qdisc's limit via the ->change() operation, only
the main skb queue was trimmed, potentially leaving packets in the gso_skb
list. This could result in NULL pointer dereference when we only check
sch->limit against sch->q.qlen.

This patch introduces a new helper, qdisc_dequeue_internal(), which ensures
both the gso_skb list and the main queue are properly flushed when trimming
excess packets. All relevant qdiscs (codel, fq, fq_codel, fq_pie, hhf, pie)
are updated to use this helper in their ->change() routines.

Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Fixes: 10239edf86f1 ("net-qdisc-hhf: Heavy-Hitter Filter (HHF) qdisc")
Fixes: d4b36210c2e6 ("net: pkt_sched: PIE AQM scheme")
Reported-by: Will <willsroot@protonmail.com>
Reported-by: Savy <savy@syst3mfailure.io>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 15 +++++++++++++++
 net/sched/sch_codel.c     |  2 +-
 net/sched/sch_fq.c        |  2 +-
 net/sched/sch_fq_codel.c  |  2 +-
 net/sched/sch_fq_pie.c    |  2 +-
 net/sched/sch_hhf.c       |  2 +-
 net/sched/sch_pie.c       |  2 +-
 7 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 4ec2a948ae3db..3287988a6a987 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1029,6 +1029,21 @@ static inline struct sk_buff *__qdisc_dequeue_head(struct qdisc_skb_head *qh)
 	return skb;
 }
 
+static inline struct sk_buff *qdisc_dequeue_internal(struct Qdisc *sch, bool direct)
+{
+	struct sk_buff *skb;
+
+	skb = __skb_dequeue(&sch->gso_skb);
+	if (skb) {
+		sch->q.qlen--;
+		return skb;
+	}
+	if (direct)
+		return __qdisc_dequeue_head(&sch->q);
+	else
+		return sch->dequeue(sch);
+}
+
 static inline struct sk_buff *qdisc_dequeue_head(struct Qdisc *sch)
 {
 	struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 5f2e068157456..63c02040b426a 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -168,7 +168,7 @@ static int codel_change(struct Qdisc *sch, struct nlattr *opt,
 
 	qlen = sch->q.qlen;
 	while (sch->q.qlen > sch->limit) {
-		struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, true);
 
 		dropped += qdisc_pkt_len(skb);
 		qdisc_qstats_backlog_dec(sch, skb);
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index f59a2cb2c803d..91f5ef6be0f23 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -901,7 +901,7 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 		sch_tree_lock(sch);
 	}
 	while (sch->q.qlen > sch->limit) {
-		struct sk_buff *skb = fq_dequeue(sch);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, false);
 
 		if (!skb)
 			break;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 9330923a624c0..47b5a056165cb 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -431,7 +431,7 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 
 	while (sch->q.qlen > sch->limit ||
 	       q->memory_usage > q->memory_limit) {
-		struct sk_buff *skb = fq_codel_dequeue(sch);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, false);
 
 		q->cstats.drop_len += qdisc_pkt_len(skb);
 		rtnl_kfree_skbs(skb, skb);
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index 68e6acd0f130d..607c580d75e4b 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -357,7 +357,7 @@ static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
 
 	/* Drop excess packets if new limit is lower */
 	while (sch->q.qlen > sch->limit) {
-		struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, false);
 
 		len_dropped += qdisc_pkt_len(skb);
 		num_dropped += 1;
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index d26cd436cbe31..83fc44f20e31c 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -560,7 +560,7 @@ static int hhf_change(struct Qdisc *sch, struct nlattr *opt,
 	qlen = sch->q.qlen;
 	prev_backlog = sch->qstats.backlog;
 	while (sch->q.qlen > sch->limit) {
-		struct sk_buff *skb = hhf_dequeue(sch);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, false);
 
 		rtnl_kfree_skbs(skb, skb);
 	}
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 2da6250ec3463..48c5ab8ec143c 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -190,7 +190,7 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	/* Drop excess packets if new limit is lower */
 	qlen = sch->q.qlen;
 	while (sch->q.qlen > sch->limit) {
-		struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
+		struct sk_buff *skb = qdisc_dequeue_internal(sch, true);
 
 		dropped += qdisc_pkt_len(skb);
 		qdisc_qstats_backlog_dec(sch, skb);
-- 
2.39.5



