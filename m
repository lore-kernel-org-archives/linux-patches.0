Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B939281F;
	Sat, 12 Sep 2026 13:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219182; cv=none; b=eHjm+pcTz/g91FA1XfMd0ZDQlcc0P2VRbcHD9y+0zy7sl9XPIjYOiHZr7ZpQwrVoZVFX00dKyWJGtK9eZncSZ8c0e2O8MvhfBQUayE150UJFXor81miCYXog//uCmaeZD/J8cDJlXndsmOlpXPPjoOm3EFL+8dKXt1JhSRbAgww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219182; c=relaxed/simple;
	bh=P76xQAD2fqivL4UI2YwWkV9SGvSmOAldjDSuFNjTIUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lF6eWEjY3K2bCjDK3EApLwxC7SaYWA052zCWuufzUn11L5HXQ0cwy5mGtbJP+DMT207A0fs7N8dfi07fj6gbSgA7iWZpA2JS2k2aW98F+eteSodxRw285hb5EwrrSugjr7k2SOzso2PyGikpMUC/QIu8SaNrchprhzra0jHCXyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjXtLXrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjXtLXrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F941F000FF;
	Sat, 12 Sep 2026 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219177;
	bh=kUulLtnWZ8Xn8ARIHkBkj/4dF8v+DSUo9iIDs/LAtzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjXtLXrKa69tVadD+jS2b0Xf5Nj7XrleDPhU33FxbjdOrv83kKQBt5LfpC4PF9ow9
	 IyAqjSswfFtpQh7vZ249csJgCTFlqmFhkTGee5h+QlFFhzh97AhBcLdERg2bDRPI9t
	 9nxfqvGo8zusyrX02y+ljTuQNt0EnaSHZOtEeGU8=
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
Subject: [PATCH 6.12 1255/1376] net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue
Date: Sat, 12 Sep 2026 09:01:21 +0200
Message-ID: <20260912065635.511957166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 43b0343a7cd0c..53b348b83c913 100644
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



