Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C6B2F656A;
	Fri, 21 Nov 2025 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731155; cv=none; b=HT/bau4mN5ZjM7Dg5ydXiDuDpXhrE+WUm7Sd/6LjxjHqXF+27PYxiLEpM9JYmwmjsH3ynurUNG1jCgszwJkJQJDzJ1BWDzF6xr4r39imRXzEv0G7tzelwKaoYykdkiFRWSO6ZmEq2Skdd/WY/XkgGxLQsbq1lNccLDkubHAw64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731155; c=relaxed/simple;
	bh=DrsKRLZj9LgGoHGOY8b25xLbMwO8JxbvfglJotJwhNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZcEQ0FrfG0VdQtTB12Uh75sIWXoF+h9zZ93gNlj2YMEDsudJ8dBPz4MXgVPkKYu74IReXEleXddJjcGcjkVvAJ0zxmWF1CytS+fT8Uhp/ZFRfrnNcv2Byr3GWi+4OG3V0RJdYgl0WpdbyIWuA7iI+rpcuD3Yz+3jfD/q2HoprE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhQ2FcWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhQ2FcWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F98C4CEF1;
	Fri, 21 Nov 2025 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731155;
	bh=DrsKRLZj9LgGoHGOY8b25xLbMwO8JxbvfglJotJwhNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhQ2FcWSUfovTkT40XoNEDPBvzIqr1NEp13+awGsKIdSphlWUbukfU87QRbAj2dB2
	 LvdcqSF1fVhDZgrs3NyU9TGkwlT56pa2xdu+Eayqk0HO1geLJzBFdYbp1AnKXtsDMW
	 FZT9u3oP441Nau8BTn5JMz0dx6Eg5vwINfqC9Dcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 082/247] net_sched: limit try_bulk_dequeue_skb() batches
Date: Fri, 21 Nov 2025 14:10:29 +0100
Message-ID: <20251121130157.539944486@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1e008a228ebdf..7dee9748a56be 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -180,9 +180,10 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
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
@@ -193,8 +194,10 @@ static void try_bulk_dequeue_skb(struct Qdisc *q,
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
 
@@ -228,7 +231,7 @@ static void try_bulk_dequeue_skb_slow(struct Qdisc *q,
  * A requeued skb (via q->gso_skb) can also be a SKB list.
  */
 static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
-				   int *packets)
+				   int *packets, int budget)
 {
 	const struct netdev_queue *txq = q->dev_queue;
 	struct sk_buff *skb = NULL;
@@ -295,7 +298,7 @@ static struct sk_buff *dequeue_skb(struct Qdisc *q, bool *validate,
 	if (skb) {
 bulk:
 		if (qdisc_may_bulk(q))
-			try_bulk_dequeue_skb(q, skb, txq, packets);
+			try_bulk_dequeue_skb(q, skb, txq, packets, budget);
 		else
 			try_bulk_dequeue_skb_slow(q, skb, packets);
 	}
@@ -387,7 +390,7 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
  *				>0 - queue is not empty.
  *
  */
-static inline bool qdisc_restart(struct Qdisc *q, int *packets)
+static inline bool qdisc_restart(struct Qdisc *q, int *packets, int budget)
 {
 	spinlock_t *root_lock = NULL;
 	struct netdev_queue *txq;
@@ -396,7 +399,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 	bool validate;
 
 	/* Dequeue packet */
-	skb = dequeue_skb(q, &validate, packets);
+	skb = dequeue_skb(q, &validate, packets, budget);
 	if (unlikely(!skb))
 		return false;
 
@@ -414,7 +417,7 @@ void __qdisc_run(struct Qdisc *q)
 	int quota = READ_ONCE(net_hotdata.dev_tx_weight);
 	int packets;
 
-	while (qdisc_restart(q, &packets)) {
+	while (qdisc_restart(q, &packets, quota)) {
 		quota -= packets;
 		if (quota <= 0) {
 			if (q->flags & TCQ_F_NOLOCK)
-- 
2.51.0



