Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057992;
	b=FK74qde9lGH0qd0hDirotwmtxZ1CLXec2mJRF+QC2cCFvI30+jHiAe6+mQ/dQh/dJ/d2
	 F5QZKSsQZu/o5vRqKIOfQr9bEEMcId48AUPZuZ799ujFEZXAor1u5S5fi0/QJb/0BDy41
	 klgHrX9GtNGIWyBCu14RP+HrMbePvGg6uc24PSC2D73e7MPQnk4lLX4+lWIFj011SJ68P
	 Xaeicygo3LplKlc1HbW0fx0ZGifhlMHHhBDFj4/TMs/ZnfzHjznWfgN1WDdl/nPBT2Scx
	 AcjY/2f6kPuLRK7Tq3O6fpHC8zoU+8lAVXkvEoHl2bU6TWPMOT/ojS8gFB+KhhCgy3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7tzTCvxo+RBSPmDNFJOvnOS3AakgqGIPfgmIOoiimak=;
	b=cI4VaRI79j5nvqgNZ179maJdqrEYe4KH7tWvS/UZRRuX3tLNpHCeaODxSxhcT45aM1Y4
	 ePt+C98DURc5nrbksVK4mtJAy14NZL0IbvI/lnIumitm5EKAR5EVwwBbfy7BE8Mlbu+/F
	 sc/ad10pBG8TkzhFxNwta96MSEaZiS999AWGrVFysX096rzFkHdWuStWQ207YeIllfehd
	 0J+/kAnI3TB14CC/obIyUEUSX7sNlZzqWoWfUWcq8IPnhU2+P8aETOAV7clfflwytSko/
	 4GFhp5YpHf9p1ikiH453rKx26KX37ZpxE793rm2exLj9a2C2ZyR0Yt5viRNOhQCtA6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BO6B5KSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222AE606A320;
	Thu, 19 Nov 2026 03:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BO6B5KSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6791F000C4;
	Thu, 19 Nov 2026 03:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057992;
	bh=7tzTCvxo+RBSPmDNFJOvnOS3AakgqGIPfgmIOoiimak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BO6B5KSgB+xWWiy563RPAW9sdg58RPys32EB65b37+AFU+18KdvATqGJbb3CSgLFk
	 DkhdHj7V8Iz+YW7kZtgEuPyWijWm9t77U8V1c10ZYI21SIOsibvTkK6/sy+cFORUGQ
	 WtQvAgZm/ahmEWBWQjpLrCEEwiY2A7lQvdJQyIX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0327/1848] net/sched: fix packet reordering on requeue
Date: Wed, 18 Nov 2026 15:39:25 +0100
Message-ID: <20261118145925.796462662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

[ Upstream commit 14368b9aa1017fee35d2589be7b17e0485c0f93e ]

dev_requeue_skb() appends requeued skbs to the tail of q->gso_skb, while
dequeue_skb() takes them back one at a time from the head. If the driver
returns NETDEV_TX_BUSY again for the first of them, it moves behind the
skbs still parked there and is sent after them.

This showed up as heavy TCP reordering while benchmarking over veth,
which returns NETDEV_TX_BUSY whenever its ring is full since
commit dc82a33297fc ("veth: apply qdisc backpressure on full ptr_ring to reduce TX drops").

Requeue the skbs at the head of gso_skb, keeping their order. With 4 TCP
streams over a veth pair with a pfifo qdisc, this removes about 1.3M
out-of-order segments and 15-37k retransmits per 15 seconds, and raises
throughput from about 40 to 76 Gbit/s.

Fixes: a53851e2c321 ("net: sched: explicit locking in gso_cpu fallback")
Fixes: 9540d977618c ("net: sched: fix skb leak in dev_requeue_skb()")
Cc: stable@vger.kernel.org
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://patch.msgid.link/20261026153113.3275494-1-antonio@mandelbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adjusted dev_requeue_skb() context to preserve the existing unlock-and-reschedule sequence. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 43ef80f11a9d7..af066995f811a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -139,8 +139,11 @@ static inline void qdisc_enqueue_skb_bad_txq(struct Qdisc *q,
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
+	struct sk_buff_head requeue;
 	spinlock_t *lock = NULL;
 
+	__skb_queue_head_init(&requeue);
+
 	if (q->flags & TCQ_F_NOLOCK) {
 		lock = qdisc_lock(q);
 		spin_lock(lock);
@@ -149,7 +152,7 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
-		__skb_queue_tail(&q->gso_skb, skb);
+		__skb_queue_tail(&requeue, skb);
 
 		/* it's still part of the queue */
 		if (qdisc_is_percpu_stats(q)) {
@@ -164,6 +167,12 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 
 		skb = next;
 	}
+
+	/* the skbs may come from the head of gso_skb, so put them back there:
+	 * appending them would let the ones still parked overtake them
+	 */
+	skb_queue_splice(&requeue, &q->gso_skb);
+
 	if (lock)
 		spin_unlock(lock);
 	__netif_schedule(q);
-- 
2.53.0



