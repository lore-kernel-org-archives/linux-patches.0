Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BE1CAA7D;
	Mon,  2 Jun 2025 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875082; cv=none; b=HbmE1lGn7arLTqLwAt0QkI6PH8FL751i5FQF7+gW6qF0ylzqp7FgVoyhCapL8rx2pzcZHXyVv2wr3XddC4xs/AQZG0ENBeHWOXigBRCZnWoTi/QsI8TepdKVE9wurF7y1iKoSL8BDti+MHk9jYzqVRcyTgRy8lXjhIO754KdGew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875082; c=relaxed/simple;
	bh=XcmhcZjFmWcKfPIUnHYOmT3/9UQMVnxXa3Cx1yP3FUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI5ylxzUx1VO5KoS2tV9vdDLkj5hwfIe+JQDQFf6QT/jUB0/eMi23IEoA4ypPq6cR3zN+H/bElGcOb+8FPGOubUqSYiQ+XY5FutyXmdISgRNEl2xdMbEZR+IiX1qnvGe04ZPZr/jsqjSkxBlWNI1gn9LVqbyJxIvPBgHbWlXPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XABslzKC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XABslzKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E907BC4CEEB;
	Mon,  2 Jun 2025 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875082;
	bh=XcmhcZjFmWcKfPIUnHYOmT3/9UQMVnxXa3Cx1yP3FUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XABslzKC98Fd8jp2eLGu7IkpMM+sYZQrCwmACcCHUexvqth3UweFHYdQf1IIRWh0b
	 rJuAu691MEgcYgZgyLoBIpGzET22G+5PJP48lvV11G56oCJsuSB0mg/gEWrYYKvMhD
	 zavFI4TgNp94zcNZNlwbSifBs9e0uh88DDevluJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/270] net_sched: qfq: Fix double list add in class with netem as child qdisc
Date: Mon,  2 Jun 2025 15:45:07 +0200
Message-ID: <20250602134308.107151554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit f139f37dcdf34b67f5bf92bc8e0f7f6b3ac63aa4 ]

As described in Gerrard's report [1], there are use cases where a netem
child qdisc will make the parent qdisc's enqueue callback reentrant.
In the case of qfq, there won't be a UAF, but the code will add the same
classifier to the list twice, which will cause memory corruption.

This patch checks whether the class was already added to the agg->active
list (cl_is_active) before doing the addition to cater for the reentrant
case.

[1] https://lore.kernel.org/netdev/CAHcdcOm+03OD2j6R0=YHKqmy=VgJ8xEOKuP6c7mSgnp-TEJJbw@mail.gmail.com/

Fixes: 37d9cf1a3ce3 ("sched: Fix detection of empty queues in child qdiscs")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20250425220710.3964791-5-victor@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index ebf9f473c9392..1ee15db5fcc8c 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -204,6 +204,11 @@ struct qfq_sched {
  */
 enum update_reason {enqueue, requeue};
 
+static bool cl_is_active(struct qfq_class *cl)
+{
+	return !list_empty(&cl->alist);
+}
+
 static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 {
 	struct qfq_sched *q = qdisc_priv(sch);
@@ -1222,7 +1227,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct qfq_class *cl;
 	struct qfq_aggregate *agg;
 	int err = 0;
-	bool first;
 
 	cl = qfq_classify(skb, sch, &err);
 	if (cl == NULL) {
@@ -1244,7 +1248,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	gso_segs = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		pr_debug("qfq_enqueue: enqueue failed %d\n", err);
@@ -1261,8 +1264,8 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	++sch->q.qlen;
 
 	agg = cl->agg;
-	/* if the queue was not empty, then done here */
-	if (!first) {
+	/* if the class is active, then done here */
+	if (cl_is_active(cl)) {
 		if (unlikely(skb == cl->qdisc->ops->peek(cl->qdisc)) &&
 		    list_first_entry(&agg->active, struct qfq_class, alist)
 		    == cl && cl->deficit < len)
-- 
2.39.5



