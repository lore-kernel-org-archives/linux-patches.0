Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061473;
	b=YF9+iKcffCF4orAE6lorwMk/wvZFcsooDWu9ZvD6TgXzpTV6qVXhBiNyUKnYme0tRq1k
	 o+QfRwc/JRvWW5LgMGCDbYmyrcTNGbsZKFxCexRKYEmcE7wx4D5elQQOCWbP/0fTiEsQM
	 HwYYX904u+nBQsMAOkLKAWLasCv7/wOi7utXfqz5f/JPdVIlIZKR67THVvfwFdFlJtFg+
	 9OkmrjNxmc1C1Q0wPsUCvdjjmv1ZIoeJRv4+ihkvlo77wVeXIMh+rF/SG5GOzPIyO2moi
	 oGDncu6M6+1ZJrRYeqN9r5wFx8aw6JPZmOdPxfKTp3gysxA+xg79iDVHa+pZl+0pZfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JFrhwcKVOT5cC3LTigtohMhhDaSUPa2I430G7L1r+/o=;
	b=0YTo0rFv5R9k7MLWTKVCzFSYS8czIU280lWh3tPw2wNC7/adiwmOw29tcvTj1/FK7k6a
	 YeryZu7/o2SWP0OlUVqq9XhVlI4kfTyYYdxxxzrz8x0iisCUsIfclaSbEUmaudK2x59w+
	 rvL2lI2XdihLfSr/iv/qKKuxHjEFecqogWd64k/CWNCyHKVNUb5JScf2eYi+xo6k5fG3T
	 m8jahrUypXD2bDzmlrFkkP6E1WCiuC43Q0uV9F3/ZBRkGvCpVcJvI+8ZMKc1mz+9202Ti
	 csmqbh0E9+/Ueq+CZDuijNKNmuIliMbapCAzu4aTc2IdO1HG1KR6Vv2e2VzDjcHWAvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbiasvMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D89606A331;
	Sat,  7 Nov 2026 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbiasvMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3794F1F0089F;
	Sat,  7 Nov 2026 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061472;
	bh=JFrhwcKVOT5cC3LTigtohMhhDaSUPa2I430G7L1r+/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbiasvMs6Se82p6qy0PmrGQ0Q9J6A6JIz0gYjQtZ+cuXA0aIKPdAXB/f7bcOC16D2
	 alFP68APnSem+uhkYX/s8Zv2XND+37knqAVfw3GWvEME5hC0/+jbFzSjXckdFJDKPK
	 j47mGfAM+Crb3Tt6JeiHP/si4E+nprmjJT2otm1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0572/1536] net/sched: fix packet reordering on requeue
Date: Sat,  7 Nov 2026 08:43:08 -0500
Message-ID: <20261107135013.634598955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@mandelbit.com>

commit 14368b9aa1017fee35d2589be7b17e0485c0f93e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -142,8 +142,11 @@ static inline void qdisc_enqueue_skb_bad
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
+	struct sk_buff_head requeue;
 	spinlock_t *lock = NULL;
 
+	__skb_queue_head_init(&requeue);
+
 	if (q->flags & TCQ_F_NOLOCK) {
 		lock = qdisc_lock(q);
 		spin_lock(lock);
@@ -152,7 +155,7 @@ static inline void dev_requeue_skb(struc
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
-		__skb_queue_tail(&q->gso_skb, skb);
+		__skb_queue_tail(&requeue, skb);
 
 		/* it's still part of the queue */
 		if (qdisc_is_percpu_stats(q)) {
@@ -168,6 +171,11 @@ static inline void dev_requeue_skb(struc
 		skb = next;
 	}
 
+	/* the skbs may come from the head of gso_skb, so put them back there:
+	 * appending them would let the ones still parked overtake them
+	 */
+	skb_queue_splice(&requeue, &q->gso_skb);
+
 	if (lock) {
 		spin_unlock(lock);
 		set_bit(__QDISC_STATE_MISSED, &q->state);


