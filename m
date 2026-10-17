Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3CD38F658;
	Sat, 17 Oct 2026 17:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259949; cv=none; b=AEQwwlS1VrbxDNunA14Q3GJPElnQEAFetC58NuUAl77STDgV+Gp4sAu38YeooiEkh/7/1CQxvNVxX+zxjuzJp3PzAfV6YV0IkM3NGa6MgH4EQyyQJ6h+WWa5k+MdJDhGLFKXNHz6OjrA8bvfFIsZS/ee4QZIVKDqFhdA+28hHNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259949; c=relaxed/simple;
	bh=Tnmq1YtsIsn1nYpZ2zvxqqeE83jYxycdo3fwfRs/ZbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKG1y0M/3UOCvj6hvYFxxpfkOTqwWMLdK4WejlFpith5N9m5P2zesiAh5Sf4j5fHWyd3fT6G7o/6fUjb+pApKw/tazURrQUuebCT3dRCtnQ/hvC425bZHoS5EMH7Yk8RkIGzedO7O/bjE/09xEWsIneDxgUnImL1tzOisSmtuUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mg8oCQEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg8oCQEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A681F000C5;
	Sat, 17 Oct 2026 17:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259948;
	bh=BMZMrrqwR/tJz653VVJfV1a/SeJQ+TtgYg5POzh3lTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mg8oCQEutCsRMjelEgvJlebnM9pV0cqHUMjqGRU2Kx3Y/4WuRY8yQmrEJsu03XFEB
	 V7h17znKpipkxHGax8xWVFphMfH+QVKw0As6egPdeMOgMtw6oZ/ifZWLgiqTX8HXjI
	 oairkpAGV4G15zyTaASL7kOSw9pl43j8cKCAK6+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1383/1674] net_sched: sch_fifo: implement lockless __fifo_dump()
Date: Sat, 17 Oct 2026 18:00:55 +0200
Message-ID: <20261017160506.661804869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/sched/sch_fifo.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index 1080d89f91780..ded0eac944068 100644
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
@@ -38,11 +39,12 @@ static int pfifo_tail_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			      struct sk_buff **to_free)
 {
 	unsigned int prev_backlog;
+	u32 limit = READ_ONCE(sch->limit);
 
-	if (unlikely(sch->limit == 0))
+	if (unlikely(limit == 0))
 		return qdisc_drop(skb, sch, to_free);
 
-	if (likely(sch->q.qlen < sch->limit))
+	if (likely(sch->q.qlen < limit))
 		return qdisc_enqueue_tail(skb, sch);
 
 	prev_backlog = sch->qstats.backlog;
@@ -108,14 +110,14 @@ static int __fifo_init(struct Qdisc *sch, struct nlattr *opt,
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
@@ -157,7 +159,7 @@ static void fifo_destroy(struct Qdisc *sch)
 
 static int __fifo_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
-	struct tc_fifo_qopt opt = { .limit = sch->limit };
+	struct tc_fifo_qopt opt = { .limit = READ_ONCE(sch->limit) };
 
 	if (nla_put(skb, TCA_OPTIONS, sizeof(opt), &opt))
 		goto nla_put_failure;
-- 
2.53.0



