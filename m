Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E978917AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A7C433C7;
	Wed,  9 Aug 2023 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580256;
	bh=mVaMurqfNZT9mxKIFQ1nvunouZFvg8lVaG5Ps+splQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/dT1GviH7amcuKl5iyINPE+7sibJQc2UGSjGX+ZEQx7gVT1zPEyafaCphuigIKBP
	 MTE9oPPXzh1G5t053+h7qLDsoNXN3ydLUbtTzYpq5D1IiuiHOd6z5RRqpjv1yHFE9G
	 fWzScgX2ktH6sgvxdVULJSG7kZO7WQ5NEEzR/kiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lion <nnamrec@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 4.19 284/323] net/sched: sch_qfq: account for stab overhead in qfq_enqueue
Date: Wed,  9 Aug 2023 12:42:02 +0200
Message-ID: <20230809103711.047560584@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

commit 3e337087c3b5805fe0b8a46ba622a962880b5d64 upstream.

Lion says:
-------
In the QFQ scheduler a similar issue to CVE-2023-31436
persists.

Consider the following code in net/sched/sch_qfq.c:

static int qfq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
                struct sk_buff **to_free)
{
     unsigned int len = qdisc_pkt_len(skb), gso_segs;

    // ...

     if (unlikely(cl->agg->lmax < len)) {
         pr_debug("qfq: increasing maxpkt from %u to %u for class %u",
              cl->agg->lmax, len, cl->common.classid);
         err = qfq_change_agg(sch, cl, cl->agg->class_weight, len);
         if (err) {
             cl->qstats.drops++;
             return qdisc_drop(skb, sch, to_free);
         }

    // ...

     }

Similarly to CVE-2023-31436, "lmax" is increased without any bounds
checks according to the packet length "len". Usually this would not
impose a problem because packet sizes are naturally limited.

This is however not the actual packet length, rather the
"qdisc_pkt_len(skb)" which might apply size transformations according to
"struct qdisc_size_table" as created by "qdisc_get_stab()" in
net/sched/sch_api.c if the TCA_STAB option was set when modifying the qdisc.

A user may choose virtually any size using such a table.

As a result the same issue as in CVE-2023-31436 can occur, allowing heap
out-of-bounds read / writes in the kmalloc-8192 cache.
-------

We can create the issue with the following commands:

tc qdisc add dev $DEV root handle 1: stab mtu 2048 tsize 512 mpu 0 \
overhead 999999999 linklayer ethernet qfq
tc class add dev $DEV parent 1: classid 1:1 htb rate 6mbit burst 15k
tc filter add dev $DEV parent 1: matchall classid 1:1
ping -I $DEV 1.1.1.2

This is caused by incorrectly assuming that qdisc_pkt_len() returns a
length within the QFQ_MIN_LMAX < len < QFQ_MAX_LMAX.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Reported-by: Lion <nnamrec@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_qfq.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -387,8 +387,13 @@ static int qfq_change_agg(struct Qdisc *
 			   u32 lmax)
 {
 	struct qfq_sched *q = qdisc_priv(sch);
-	struct qfq_aggregate *new_agg = qfq_find_agg(q, lmax, weight);
+	struct qfq_aggregate *new_agg;
 
+	/* 'lmax' can range from [QFQ_MIN_LMAX, pktlen + stab overhead] */
+	if (lmax > (1UL << QFQ_MTU_SHIFT))
+		return -EINVAL;
+
+	new_agg = qfq_find_agg(q, lmax, weight);
 	if (new_agg == NULL) { /* create new aggregate */
 		new_agg = kzalloc(sizeof(*new_agg), GFP_ATOMIC);
 		if (new_agg == NULL)


