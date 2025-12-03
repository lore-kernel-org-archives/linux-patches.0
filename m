Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775963002B6;
	Wed,  3 Dec 2025 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775858; cv=none; b=Vsa6oZs4caCkz20fXmYM07DD9UfKE2ReIjZPrEUa8Xp3cqbc2GDdeIPjrV1vVqg78dQkigpM2sL1laG7ROJUV1iAWyuxWEXiXwF8hunwoX9dCcRFIvk/06sO292YPk9sE1U8OQYCHm1tessgk+Cb/r7uOzLnwUzctx3U5ED7LVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775858; c=relaxed/simple;
	bh=xtY1PryIlibNqyK3Wtd2Ac362e2aLzCenUw0qbhF4W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcxloM28Jrb7ZcWc0ufMdZqVhIbKyqONK9CLXJSiviij5vS3pRV6XswPYLiZhC9RWqT9aWa2yhXpAkDFhbMRz72K3YqCgPeqx0qvupQLXRIvsj5pJ3nuAQ370QZQOli49Pd3DKuw7RMlTSpeUHgCrrhJNtWMVKeYcay8jL9ybvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCJoyE7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCJoyE7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7A9C4CEF5;
	Wed,  3 Dec 2025 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775857;
	bh=xtY1PryIlibNqyK3Wtd2Ac362e2aLzCenUw0qbhF4W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCJoyE7KhDr6zeVUz0ykHCGn/Ib0gZrJAkg2sr7JCG1IizI8ez7Ockbih9JmwwhUk
	 1nhwrnALYjlZHi3VsAsNpZo8j7qum14D/j87oAaDqRAokqvIzptuvlLP55bHi+DUG5
	 wWXMHhAYksaj2dzMXmeHYpMAuMlZ+HLGgQJc9p0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 001/300] net/sched: sch_qfq: Fix null-deref in agg_dequeue
Date: Wed,  3 Dec 2025 16:23:25 +0100
Message-ID: <20251203152400.507656899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
@@ -114,7 +114,6 @@ struct qdisc_rate_table *qdisc_get_rtab(
 					struct netlink_ext_ack *extack);
 void qdisc_put_rtab(struct qdisc_rate_table *tab);
 void qdisc_put_stab(struct qdisc_size_table *tab);
-void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc);
 bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		     struct net_device *dev, struct netdev_queue *txq,
 		     spinlock_t *root_lock, bool validate);
@@ -190,4 +189,28 @@ static inline void skb_txtime_consumed(s
 	skb->tstamp = ktime_set(0, 0);
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
@@ -595,16 +595,6 @@ out:
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
@@ -836,22 +836,6 @@ update_vf(struct hfsc_class *cl, unsigne
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
@@ -1007,7 +1007,7 @@ static struct sk_buff *agg_dequeue(struc
 
 	if (cl->qdisc->q.qlen == 0) /* no more packets, remove from list */
 		list_del_init(&cl->alist);
-	else if (cl->deficit < qdisc_pkt_len(cl->qdisc->ops->peek(cl->qdisc))) {
+	else if (cl->deficit < qdisc_peek_len(cl->qdisc)) {
 		cl->deficit += agg->lmax;
 		list_move_tail(&cl->alist, &agg->active);
 	}


