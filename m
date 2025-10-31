Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B49534D387;
	Fri, 31 Oct 2025 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919314; cv=none; b=chpXPROzncY52rGx8EcOfbCcxG7YSITguYP7otUlyBHylfgF2ZU6m6P0YcY4fqTGYmO3YRujajHnaMJM1diBuctJ2E9NyRKWHznQnWffiPsMjU8yvE94Smfa01sewFK6Y7lfiuiQXjAi31kiev52q3OkGpyGvufevQg5Zg+t1xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919314; c=relaxed/simple;
	bh=AmQCYmpB+20MPMFImT37agnPb+Fmzai7aFXuUMrhPDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkIOGrrhOh0m+FtF3JnCWTrAslnQfdsUMQshVvbhN3OiF0KA3jlEsg6RqlopYDoe68Ok6/52FbjAQm9SsrFJWB3eqrQg5aUHHpodljyavELfxoeo1aBQuFvU7cVsgHl6SKB6wc+x94GugDsGQjsAxe2Rv29T/RvwEZj2v4jafJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhbGcXUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhbGcXUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720FCC4CEE7;
	Fri, 31 Oct 2025 14:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919313;
	bh=AmQCYmpB+20MPMFImT37agnPb+Fmzai7aFXuUMrhPDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhbGcXUKXrDfzHuPGO5Uc9yBTqtzKftKGfcr9ZRiyz7prUV8DZkBRmVVPtIpI4Zwt
	 YCtkiMIZPmfZ73y3c0QtkN1D3wlAlcAEN/L132D+6NfwmUzKg/nWOW+VhQeh5sOi4S
	 6Lue9YUenX3yLAuOYLGZtgZ9isHi1jzAfXwao578=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 01/32] net/sched: sch_qfq: Fix null-deref in agg_dequeue
Date: Fri, 31 Oct 2025 15:00:55 +0100
Message-ID: <20251031140042.425168412@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit dd831ac8221e691e9e918585b1003c7071df0379 upstream.

To prevent a potential crash in agg_dequeue (net/sched/sch_qfq.c)
when cl->qdisc->ops->peek(cl->qdisc) returns NULL, we check the return
value before using it, similar to the existing approach in sch_hfsc.c.

To avoid code duplication, the following changes are made:

1. Changed qdisc_warn_nonwc(include/net/pkt_sched.h) into a static
inline function.

2. Moved qdisc_peek_len from net/sched/sch_hfsc.c to
include/net/pkt_sched.h so that sch_qfq can reuse it.

3. Applied qdisc_peek_len in agg_dequeue to avoid crashing.

Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250705212143.3982664-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/pkt_sched.h |   25 ++++++++++++++++++++++++-
 net/sched/sch_api.c     |   10 ----------
 net/sched/sch_hfsc.c    |   16 ----------------
 net/sched/sch_qfq.c     |    2 +-
 4 files changed, 25 insertions(+), 28 deletions(-)

--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -112,7 +112,6 @@ struct qdisc_rate_table *qdisc_get_rtab(
 					struct netlink_ext_ack *extack);
 void qdisc_put_rtab(struct qdisc_rate_table *tab);
 void qdisc_put_stab(struct qdisc_size_table *tab);
-void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
 bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		     struct net_device *dev, struct netdev_queue *txq,
 		     spinlock_t *root_lock, bool validate);
@@ -306,4 +305,28 @@ static inline bool tc_qdisc_stats_dump(s
 	return true;
 }
 
+static inline void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
+{
+	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
+		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
+			txt, qdisc->ops->id, qdisc->handle >> 16);
+		qdisc->flags |= TCQ_F_WARN_NONWC;
+	}
+}
+
+static inline unsigned int qdisc_peek_len(struct Qdisc *sch)
+{
+	struct sk_buff *skb;
+	unsigned int len;
+
+	skb = sch->ops->peek(sch);
+	if (unlikely(skb == NULL)) {
+		qdisc_warn_nonwc("qdisc_peek_len", sch);
+		return 0;
+	}
+	len = qdisc_pkt_len(skb);
+
+	return len;
+}
+
 #endif
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -599,16 +599,6 @@ out:
 	qdisc_skb_cb(skb)->pkt_len = pkt_len;
 }
 
-void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
-{
-	if (!(qdisc->flags & TCQ_F_WARN_NONWC)) {
-		pr_warn("%s: %s qdisc %X: is non-work-conserving?\n",
-			txt, qdisc->ops->id, qdisc->handle >> 16);
-		qdisc->flags |= TCQ_F_WARN_NONWC;
-	}
-}
-EXPORT_SYMBOL(qdisc_warn_nonwc);
-
 static enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer)
 {
 	struct qdisc_watchdog *wd = container_of(timer, struct qdisc_watchdog,
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -835,22 +835,6 @@ update_vf(struct hfsc_class *cl, unsigne
 	}
 }
 
-static unsigned int
-qdisc_peek_len(struct Qdisc *sch)
-{
-	struct sk_buff *skb;
-	unsigned int len;
-
-	skb = sch->ops->peek(sch);
-	if (unlikely(skb == NULL)) {
-		qdisc_warn_nonwc("qdisc_peek_len", sch);
-		return 0;
-	}
-	len = qdisc_pkt_len(skb);
-
-	return len;
-}
-
 static void
 hfsc_adjust_levels(struct hfsc_class *cl)
 {
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1002,7 +1002,7 @@ static struct sk_buff *agg_dequeue(struc
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
 		list_del_init(&cl->alist);
-	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
+	else if (cl->deficit < qdisc_peek_len(cl->qdisc)) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
 	}


