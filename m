Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD971B414A;
	Wed,  7 May 2025 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643647; cv=none; b=f9tsT2HJsOo9DES2Zs0QMdFl5rlMypuP1+CTZ4g8Yp56y6BMYgCVk2DD9AxRztjrsNFlCcwzYo/82DQ7tS8v139yT4TVTbyn34nZZ+0HoRH3kQ4JE9bMI2n8V21oNlRu3CRFgAS99vNIQM63IYVF/MA21dpA80s0r28APnKHPsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643647; c=relaxed/simple;
	bh=RC5SRQiA3kRHsa1MdDraq93o4UW89BFwPHzsxIuNHUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSZI3G4hdLdLIpqYDJpjIVxy1LNCzoVGDi0vQ5bXM1/lQnABxxWNiy0eVyMD+HMu3t8U9A6Kg/xOYJzzy1PIyJJQcutOXAYN1QhDzTfmiEamBEpepVZAQR6hDGjTs05X4+HKO45UeYSxHTWm24Z1oq6kxRd75c9xfoAbESXezYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I9AiYen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I9AiYen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF649C4CEE2;
	Wed,  7 May 2025 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643647;
	bh=RC5SRQiA3kRHsa1MdDraq93o4UW89BFwPHzsxIuNHUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I9AiYenaCYE70ajF+sexJVLvO1J36vObQqQFk++LOUQzh7wYJoNhtxvMUeSMiJCe
	 xRTfkP1K9eWRuMRYbpq43SoEGEjL7UMaqIzH6Q/s7iJof+ey7CnzK19ZhIi3RIk5tw
	 Vjg4g74VF4hTQTofiSz7FbfvxJlgu10u6YEyLXoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/97] net_sched: qfq: Fix double list add in class with netem as child qdisc
Date: Wed,  7 May 2025 20:39:28 +0200
Message-ID: <20250507183809.132882146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ed01634af82c2..e6743e17408b2 100644
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
@@ -1216,7 +1221,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct qfq_class *cl;
 	struct qfq_aggregate *agg;
 	int err = 0;
-	bool first;
 
 	cl = qfq_classify(skb, sch, &err);
 	if (cl == NULL) {
@@ -1238,7 +1242,6 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 	gso_segs = skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
-	first = !cl->qdisc->q.qlen;
 	err = qdisc_enqueue(skb, cl->qdisc, to_free);
 	if (unlikely(err != NET_XMIT_SUCCESS)) {
 		pr_debug("qfq_enqueue: enqueue failed %d\n", err);
@@ -1254,8 +1257,8 @@ static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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



