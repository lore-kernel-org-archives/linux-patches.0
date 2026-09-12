Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFC2EC09B;
	Sat, 12 Sep 2026 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212086; cv=none; b=e6kbNmsEoHFf2mTiupI8tLFn5eF+r3mDwoEeVJRZLunz38XXYcal9JpU2a8f2MLCUqScdlRLnxeLBtI8+U8oLaDGHHoKlWU4+eRHyBEZ2AgO+vjAmYVd5QerXRdcY8NWjyFiHHlUICwjaonFo7AjIV9hB/hv20K5EUvEgqUfPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212086; c=relaxed/simple;
	bh=qBM6M1tGkBE2kaTw86ragUnTfeL8mdABus1n/7jVXa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIj68WSMKnGlTMs/imkKw3fPF5TKRfIOR2CSRu2fyLzbR35gAb2v5Mr+bLX+8CmT1gBY58myJFV+Wlx3MFq04w7IGARcP4sYm2hEzqBuWEhMLDoE6/GzanWrG7Il7rrDbHmzOu3q4T8ab0sFtTC1agVE3gb0SbdSL9g7UsiSch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTgq46/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTgq46/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9341F00893;
	Sat, 12 Sep 2026 11:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212085;
	bh=9bohqHRl2cwMAFJJ1zRKCezqn2wqbRm95yhINvRSb30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTgq46/3ugac9cl/K++Q27qEMUDJzvHeZAn7XkbPvggXncRhSQRxvCv8E93oxQhrk
	 hJJI6bVb9oQFpOr86bByd71DT4j8Dk0tXCGrgjZ9o3eDn9Btm0X+HHMPJhvFQCmWs1
	 gx6ox4lAOVzyLuoRwMDL6k/zSf79UngccfqIonJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	vega@nebusec.ai,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1363/1518] net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue
Date: Sat, 12 Sep 2026 08:58:52 +0200
Message-ID: <20260912065654.368292546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 4c660ee8c809637909f4f7eb1017f7b9401c75c4 ]

gred_enqueue(), bfifo_enqueue() and plug_enqueue() admit a packet when the
current backlog plus the packet length fits within the queue limit:

  sch->qstats.backlog + qdisc_pkt_len(skb) <= sch->limit (gred default VQ)
  gred_backlog+qdisc_pkt_len(skb) <= q->limit  (gred configured VQ)
  sch->qstats.backlog + qdisc_pkt_len(skb) <= sch->limit (bfifo)
  sch->qstats.backlog + skb->len <= q->limit             (plug)

sch->qstats.backlog and q->backlog are u32, and qdisc_pkt_len()/skb->len
are unsigned int, so all sums are computed in 32 bits and wrap at 2^32.
Once the true backlog exceeds 4 GiB the wrapped sum becomes small and
admission keeps succeeding, so the queue grows without bound and the kernel
can be driven to OOM.

Promote the sums to u64 so admission stops once the true backlog exceeds
the limit.  The limit is u32, so the bounded queue stays below 2^32 and
the stored u32 backlog never wraps.

The bug can only be reproduced as root (albeit with ridiculous setup):
 attach a gred (or bfifo/plug) qdisc with a limit near 4 GiB,
 leaving the default VQ unconfigured (for gred), and drive >4 GiB of
 queued traffic (e.g. via a size table / stab to inflate qdisc_pkt_len,
 or sustained high-rate traffic). The u32 backlog+len sum wraps at 2^32,
 admission keeps succeeding, and the queue grows unboundedly to OOM.

Fixes: a3eb95f891d6 ("net_sched: gred: add TCA_GRED_LIMIT attribute")
Reported-by: vega@nebusec.ai
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260818095927.15901-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fifo.c | 2 +-
 net/sched/sch_gred.c | 4 ++--
 net/sched/sch_plug.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_fifo.c b/net/sched/sch_fifo.c
index e6bfd39ff3396..1b6388d50967f 100644
--- a/net/sched/sch_fifo.c
+++ b/net/sched/sch_fifo.c
@@ -19,7 +19,7 @@
 static int bfifo_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 struct sk_buff **to_free)
 {
-	if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <=
+	if (likely((u64)sch->qstats.backlog + qdisc_pkt_len(skb) <=
 		   READ_ONCE(sch->limit)))
 		return qdisc_enqueue_tail(skb, sch);
 
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 532fde548b88f..8503621289bb5 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -179,7 +179,7 @@ static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			 * if no default DP has been configured. This
 			 * allows for DP flows to be left untouched.
 			 */
-			if (likely(sch->qstats.backlog + qdisc_pkt_len(skb) <=
+			if (likely((u64)sch->qstats.backlog + qdisc_pkt_len(skb) <=
 					sch->limit))
 				return qdisc_enqueue_tail(skb, sch);
 			else
@@ -244,7 +244,7 @@ static int gred_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		break;
 	}
 
-	if (gred_backlog(t, q, sch) + qdisc_pkt_len(skb) <= q->limit) {
+	if ((u64)gred_backlog(t, q, sch) + qdisc_pkt_len(skb) <= q->limit) {
 		q->backlog += qdisc_pkt_len(skb);
 		return qdisc_enqueue_tail(skb, sch);
 	}
diff --git a/net/sched/sch_plug.c b/net/sched/sch_plug.c
index cefb65201e178..b60ddfee6a68a 100644
--- a/net/sched/sch_plug.c
+++ b/net/sched/sch_plug.c
@@ -89,7 +89,7 @@ static int plug_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 	struct plug_sched_data *q = qdisc_priv(sch);
 
-	if (likely(sch->qstats.backlog + skb->len <= q->limit)) {
+	if (likely((u64)sch->qstats.backlog + skb->len <= q->limit)) {
 		if (!q->unplug_indefinite)
 			q->pkts_current_epoch++;
 		return qdisc_enqueue_tail(skb, sch);
-- 
2.53.0



