Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827012;
	b=iwoRfthx5rb7rav9ZeMEUPaTthi56Sm8sV2gOOGBpfSNSPeuRRHCSu7u7FsGqSiLvP3U
	 X5LASawCUTH+MAKyY00/YYUrIPjVFNZjqvGGsEHxQPY0uIgq1Mqctc3MHZbxtAk0lLYCc
	 y8th4ZguWsaXPnIf1eqdPLIN4Zdc1pD5NZb6eExAbBLjBVKSFCKD/rVlIboRLA6UgLBjO
	 x/8KBLPaPnfX/7N1+k3TEp9nOAjShDCe/RH06lybNo1dUvYJi5NfATMcRdQXM9GKMnImd
	 wWgg3wa2Mq8phKlc7ZmULFRt6vJP99kIxWQ6nQE9UVDSHsE0Rpvv0LrnBapD2Oga6gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26pMoOynK+dPFfQsSKDiZCVO+yf7sNmxRWrZguAlraA=;
	b=kbZGs29JdXyqI6O8YWgBeLJ2EcQMndI2UxgswExMOhT10jlxbQvamYksxx3kvb/vYnrg
	 tGeJ4Uh/3+1uPjhu8EzeiqzDHS0tJosg27LRQ/8ShwbACgWWFwLfw6VZYPnzfHOcRQGSO
	 EkCiGrbslgzl+aqYsprBeFBuqAPRs+0/0SCdd5kkYuQwISF65ype2R2kdyFuzHq4gklmm
	 FtL0pDC0UFM7oNsQvDiyC+dtd62s80Z4Uo7tSqgBlPIWONxeU8B8dae8LsZeIrqHIH685
	 fU0mNxlg484g6oteQua36LIz9C1jLlsq11kjt6AgiDHrr1JTFUBolcKL/ll5ym1VAqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0JWZoqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFFA6074930;
	Wed,  4 Nov 2026 21:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J0JWZoqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AAC1F0093A;
	Wed,  4 Nov 2026 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827011;
	bh=26pMoOynK+dPFfQsSKDiZCVO+yf7sNmxRWrZguAlraA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0JWZoqnFlxliLZIqnmgWk7Ggbo4YAwkMvPi9oppxVkxfexzNLTC2BRFD3+Wwpcs3
	 tpBLwUJ30SBHaA9SCwE+Y0rOBwPTdrxgh7+dHOZjuygKD/6bmt0VxKVOTS7fqF6GvY
	 +kWdwGRbE0kZ2lC5tjUtG7z4C/q9Q43ZD2/77axc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 102/547] net/sched: fix packet reordering on requeue
Date: Wed,  4 Nov 2026 16:04:46 -0500
Message-ID: <20261104211041.118918326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,8 +168,11 @@ static inline void qdisc_enqueue_skb_bad
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
+	struct sk_buff_head requeue;
 	spinlock_t *lock = NULL;
 
+	__skb_queue_head_init(&requeue);
+
 	if (q->flags & TCQ_F_NOLOCK) {
 		lock = qdisc_lock(q);
 		spin_lock(lock);
@@ -178,7 +181,7 @@ static inline void dev_requeue_skb(struc
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
-		__skb_queue_tail(&q->gso_skb, skb);
+		__skb_queue_tail(&requeue, skb);
 
 		/* it's still part of the queue */
 		if (qdisc_is_percpu_stats(q)) {
@@ -194,6 +197,11 @@ static inline void dev_requeue_skb(struc
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


