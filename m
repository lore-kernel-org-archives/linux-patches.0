Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E191F09B3;
	Fri, 21 Nov 2025 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731723; cv=none; b=so3nMiHW9N6GzEuD0uqa273cjpIFZgHiqYqHOBlWAbT4+GwOSrnZxwqPuvDjMFAPtZtFKJO05DRCM3fvXNVmqy9pb/DJenAi0X/vi2lEU5F3YhlOdZzb8IYXdZUyidPgWBQjL4tm2qfk7ZiHc0iJIEP/2UeWTMFaK4sAcUTV6Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731723; c=relaxed/simple;
	bh=j2WGYaTGiJvyeqcBkhl98kC3ROE6+2UHjCu8H4Uemyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zi0s3U7nJe3NDRZKW2RUp2N4NxrvVI1U+a49xZ7rVHZStXwQkWnGgNrAIVbOvYA1l3YHiGpA9jibSkcVi1BUN8bYoh2vjbl4fXNZR4fcBjGq3KqX8F++cDQoo7riasWofgp6EYeAjX505R7xWsKaxjLoBvCW1tJsTaeFNprbvuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaMDLmUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaMDLmUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578BAC4CEF1;
	Fri, 21 Nov 2025 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731723;
	bh=j2WGYaTGiJvyeqcBkhl98kC3ROE6+2UHjCu8H4Uemyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaMDLmUQ3OqOYiKJmgy/YDFYf3bCT0Gj4IaT6szupnsX/Am7R4i6IeokL+zk3h466
	 lqOhguTSY0ZoqhfoxflO7vo+K1E4OMXdgZeHhUQkLDIzqE7Fvm2HnZjKJDEjEkWn9F
	 e7PP8OBNxQxXRfo1rQfWavWoYiQMahh4hAltxcro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/185] net_sched: limit try_bulk_dequeue_skb() batches
Date: Fri, 21 Nov 2025 14:11:26 +0100
Message-ID: <20251121130146.006830274@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0345552a653ce5542affeb69ac5aa52177a5199b ]

After commit 100dfa74cad9 ("inet: dev_queue_xmit() llist adoption")
I started seeing many qdisc requeues on IDPF under high TX workload.

$ tc -s qd sh dev eth1 handle 1: ; sleep 1; tc -s qd sh dev eth1 handle 1:
qdisc mq 1: root
 Sent 43534617319319 bytes 268186451819 pkt (dropped 0, overlimits 0 requeues 3532840114)
 backlog 1056Kb 6675p requeues 3532840114
qdisc mq 1: root
 Sent 43554665866695 bytes 268309964788 pkt (dropped 0, overlimits 0 requeues 3537737653)
 backlog 781164b 4822p requeues 3537737653

This is caused by try_bulk_dequeue_skb() being only limited by BQL budget.

perf record -C120-239 -e qdisc:qdisc_dequeue sleep 1 ; perf script
...
 netperf 75332 [146]  2711.138269: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1292 skbaddr=0xff378005a1e9f200
 netperf 75332 [146]  2711.138953: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1213 skbaddr=0xff378004d607a500
 netperf 75330 [144]  2711.139631: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1233 skbaddr=0xff3780046be20100
 netperf 75333 [147]  2711.140356: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1093 skbaddr=0xff37800514845b00
 netperf 75337 [151]  2711.141037: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1353 skbaddr=0xff37800460753300
 netperf 75337 [151]  2711.141877: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1367 skbaddr=0xff378004e72c7b00
 netperf 75330 [144]  2711.142643: qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x80150000 parent=0x10013 txq_state=0x0 packets=1202 skbaddr=0xff3780045bd60000
...

This is bad because :

1) Large batches hold one victim cpu for a very long time.

2) Driver often hit their own TX ring limit (all slots are used).

3) We call dev_requeue_skb()

4) Requeues are using a FIFO (q->gso_skb), breaking qdisc ability to
   implement FQ or priority scheduling.

5) dequeue_skb() gets packets from q->gso_skb one skb at a time
   with no xmit_more support. This is causing many spinlock games
   between the qdisc and the device driver.

Requeues were supposed to be very rare, lets keep them this way.

Limit batch sizes to /proc/sys/net/core/dev_weight (default 64) as
__qdisc_run() was designed to use.

Fixes: 5772e9a3463b ("qdisc: bulk dequeue support for qdiscs with TCQ_F_ONETXQUEUE")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20251109161215.2574081-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 8874ae6680952..d27383c54b70b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -179,9 +179,10 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 static void try_bulk_dequeue_skb(struct Qdisc *q,
 				 struct sk_buff *skb,
 				 const struct netdev_queue *txq,
-				 int *packets)
+				 int *packets, int budget)
 {
 	int bytelimit = qdisc_avail_bulklimit(txq) - skb->len;
+	int cnt = 0;
 
 	while (bytelimit > 0) {
 		struct sk_buff *nskb = q->dequeue(q);
@@ -192,8 +193,10 @@ static void try_bulk_dequeue_skb(struct Qdisc *q,
 		bytelimit -= nskb->len; /* covers GSO len */
 		skb->next = nskb;
 		skb = nskb;
-		(*packets)++; /* GSO counts as one pkt */
+		if (++cnt >= budget)
+			break;
 	}
+	(*packets) += cnt;
 	skb_mark_not_on_list(skb);
 }
 
@@ -227,7 +230,7 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
  * A requeued skb (via q->gso_skb) can also be a SKB list.
  */
 static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
-				   int *packets)
+				   int *packets, int budget)
 {
 	const struct netdev_queue *txq = q->dev_queue;
 	struct sk_buff *skb = NULL;
@@ -294,7 +297,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	if (skb) {
 bulk:
 		if (qdisc_may_bulk(q))
-			try_bulk_dequeue_skb(q, skb, txq, packets);
+			try_bulk_dequeue_skb(q, skb, txq, packets, budget);
 		else
 			try_bulk_dequeue_skb_slow(q, skb, packets);
 	}
@@ -386,7 +389,7 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
  *				>0 - queue is not empty.
  *
  */
-static inline bool qdisc_restart(struct Qdisc *q, int *packets)
+static inline bool qdisc_restart(struct Qdisc *q, int *packets, int budget)
 {
 	spinlock_t *root_lock = NULL;
 	struct netdev_queue *txq;
@@ -395,7 +398,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 	bool validate;
 
 	/* Dequeue packet */
-	skb = dequeue_skb(q, &validate, packets);
+	skb = dequeue_skb(q, &validate, packets, budget);
 	if (unlikely(!skb))
 		return false;
 
@@ -413,7 +416,7 @@ void __qdisc_run(struct Qdisc *q)
 	int quota = READ_ONCE(net_hotdata.dev_tx_weight);
 	int packets;
 
-	while (qdisc_restart(q, &packets)) {
+	while (qdisc_restart(q, &packets, quota)) {
 		quota -= packets;
 		if (quota <= 0) {
 			if (q->flags & TCQ_F_NOLOCK)
-- 
2.51.0



