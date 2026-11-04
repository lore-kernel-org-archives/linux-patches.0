Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831392;
	b=ua7CnZ8+VEjbeVbGNAA7Cmi5ypt9TfbBuAgH8ZwHYwNEhNXN8Re0GchrbBR0Te8UUX4j
	 ZXdsMxcsZ9a3kMUr33rpJKUNu5fsiV3L1Q+YReAym3uzL/z+If91caFH6GSTpP5H0YWCl
	 HwT2vwhJiJro7Cii52kHYsROGhwMYODgCyUXl0rClgbQft7Emp5ycF680bGef9JIAR59a
	 4Y1iuQkQntWyPBY1ntdC8WdhY0F9lMZodNh6jiHmz7T2Hg7GArlsVheEPTQfueS9ejwPo
	 er1/U42M7rEPirFUg11HEXvnbf8rQGQSzCe3eXdZxpA0ARLa/Ys8F9yDcnfvaziwPmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PlzQKAmD6hLjjGs6wsXaWW1m0V4/ebQS/sexlc4/HZY=;
	b=ahFS5M7mWL5F8gE/qAt3/+o4CYjC92niXdtdqL/7xLZvExU00U3njSEb2KgSEdvxJNsC
	 gDaMQIcSeIpUCkM1jpddSudW6rtBz3yzacpKVbsIxRXrgLQNZJukNUR24i5eo8e3jFaBA
	 6bdnDPDb/aZo8on5gdLxzZdcyD7IPyt9AdUxgJ1ZAarHyv/GvXifEQtBhD6llyLMpqvKk
	 guG3jb6JAjWmCj1cs0QAGBNNpopaSVxcP/lgMySg7PssHwJVhr2bC/MQN+OJptXbdd/J0
	 HN4mVK7dC4/SdX5NTBZTX5GxpbQNYYAkULDSIjKVsLbO7BMw1g8Umu6ArgmHmuasuKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYgeCFEm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A70606A87A;
	Wed,  4 Nov 2026 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYgeCFEm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302581F00919;
	Wed,  4 Nov 2026 22:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831392;
	bh=PlzQKAmD6hLjjGs6wsXaWW1m0V4/ebQS/sexlc4/HZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYgeCFEmYQzWJRQzq+PULCjdcqA5TS21tZQjVuqneQrmKKoyAojbtxgrSHzUtFm+m
	 2l/BX024wvhsk2QaDKDp6zfRka9ooexw/Jd5A3z3OPkWQu2cQsZPa51lHA7DCYiIh2
	 EJDc9cJXHkeWLwMerfPwAwECmtzJ6qxJovUqcgmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0630/1005] net/sched: fix packet reordering on requeue
Date: Wed,  4 Nov 2026 16:06:03 -0500
Message-ID: <20261104211101.435107774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -143,8 +143,11 @@ static inline void qdisc_enqueue_skb_bad
 
 static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 {
+	struct sk_buff_head requeue;
 	spinlock_t *lock = NULL;
 
+	__skb_queue_head_init(&requeue);
+
 	if (q->flags & TCQ_F_NOLOCK) {
 		lock = qdisc_lock(q);
 		spin_lock(lock);
@@ -153,7 +156,7 @@ static inline void dev_requeue_skb(struc
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
-		__skb_queue_tail(&q->gso_skb, skb);
+		__skb_queue_tail(&requeue, skb);
 
 		/* it's still part of the queue */
 		if (qdisc_is_percpu_stats(q)) {
@@ -169,6 +172,11 @@ static inline void dev_requeue_skb(struc
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


