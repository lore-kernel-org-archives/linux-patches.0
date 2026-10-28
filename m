Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216331;
	b=lWRXV3XPq858qc8hM8IWe+4Xhj81j2Rn7PuX2Xm4rNFzkuCwjZvhku4ev+TNer1z/cUz
	 TxawpEwL0Rl7XBFEDx5D9TVojnmqc70XVNYvTCYw6QwalucCHjYJsDO/JjxjTdm27NG6v
	 dwOSvNK4K10qi7VgyWEU3yghi0ZznIPN/8BLvAvG+sPPlhYEsXhdCD2iwnncsJKp+r8vZ
	 FIMfwE5VwN1dBdJ+8A9IIscWLWjNJNXfSNfnbs6UTXWJvkihM1sqe75u7IYBUXNS/MlwE
	 hjPnaHN7R0hZ4rJQ9pDDvtwCVUy3p786GNDCMm0bBaiL+rbhXdzgXiKgVpGIZPepBxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Osp7STGqAWO0Y9AgJ2Ohvu7XhdLn68Pvdc9bC0jV3cI=;
	b=yr2/GQ0OzGWNpej8oY9elHVh0IzZxARLa6x4dSRM6mQFkFQlGKfwqPDuUFRk+llSKyeo
	 zP4+sMA1Md1hMo6kwYCSPJP9yMmV+ozy9e39F7YmMTLpctMk3j08x1MODVjiTFjjmQPph
	 5Y2pNu9vIKAcAZjSsUnQDHjj2kyOR0Sg7LwElyMlBClZWAbOEQSuTxB8YJVOo3mI0xIbA
	 K7WYL8N4c6FixjvxgYA9pB6Ix+DFONiRS8xzlSVTtPXCkAGxkLtCygAMJPvQY6DzFZpgR
	 Dmt7JzIOPSxEMgm1pTx3QifNwG3Ch9dlVfHR49ZHbqMyKikY1pLKjHQMnh1vQUHdXNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Nt/JDYTs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0873C606A31D;
	Wed, 28 Oct 2026 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nt/JDYTs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBD1F01825;
	Wed, 28 Oct 2026 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216330;
	bh=Osp7STGqAWO0Y9AgJ2Ohvu7XhdLn68Pvdc9bC0jV3cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nt/JDYTs6FuOsDAWT1Dux8DDxKOfXOITPu+JYGKJ8Pz9ZBX/bokF+Ene0/+OF67mV
	 6IEdJ6Pzi61Xlq2xdYEawBo5FgXfiIBNJ3C/ZVOm9hzG5Au3F36ib9D3ggguKCg4hN
	 N2eZB71wW0vL8lC0Cjt49Ym8mLEUE1zZryqA5o9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1522/1887] net_sched: sch_fifo: implement lockless __fifo_dump()
Date: Wed, 28 Oct 2026 18:00:18 +0100
Message-ID: <20261028170534.100259784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 01daf66b791e1ddd1a4aae2a65ea65fa1d4a96ef ]

Instead of relying on RTNL, __fifo_dump() can use READ_ONCE()
annotations, paired with WRITE_ONCE() ones in __fifo_init().

Also add missing READ_ONCE(sh->limit) in bfifo_enqueue(),
pfifo_enqueue() and pfifo_tail_enqueue().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4c660ee8c809 ("net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fifo.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index af5f2ab69b8d2..739432c4d8d39 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -19,7 +19,8 @@
 static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
-	if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <= sch->limit))
+	if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <=
+		   READ_ONCE(sch->limit)))
 		return qdisc_enqueue_tail(skb, sch);
 
 	return qdisc_drop(skb, sch, to_free);
@@ -28,7 +29,7 @@ static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 static int pfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
-	if (likely(sch->q.qlen < sch->limit))
+	if (likely(sch->q.qlen < READ_ONCE(sch->limit)))
 		return qdisc_enqueue_tail(skb, sch);
 
 	return qdisc_drop(skb, sch, to_free);
@@ -42,7 +43,7 @@ static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	if (unlikely(READ_ONCE(sch->limit) == 0))
 		return qdisc_drop(skb, sch, to_free);
 
-	if (likely(sch->q.qlen < sch->limit))
+	if (likely(sch->q.qlen < READ_ONCE(sch->limit)))
 		return qdisc_enqueue_tail(skb, sch);
 
 	prev_backlog = sch->qstats.backlog;
@@ -108,14 +109,14 @@ static int __fifo_init(struct Qdisc *sch, struct nlattr *opt,
 		if (is_bfifo)
 			limit *= psched_mtu(qdisc_dev(sch));
 
-		sch->limit = limit;
+		WRITE_ONCE(sch->limit, limit);
 	} else {
 		struct tc_fifo_qopt *ctl = nla_data(opt);
 
 		if (nla_len(opt) < sizeof(*ctl))
 			return -EINVAL;
 
-		sch->limit = ctl->limit;
+		WRITE_ONCE(sch->limit, ctl->limit);
 	}
 
 	if (is_bfifo)
@@ -157,7 +158,7 @@ static void fifo_destroy(struct Qdisc *sch)
 
 static int __fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
-	struct tc_fifo_qopt opt = { .limit = sch->limit };
+	struct tc_fifo_qopt opt = { .limit = READ_ONCE(sch->limit) };
 
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
2.53.0



