Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B2D38F658;
	Sat, 17 Oct 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259952; cv=none; b=cVqiWPsQUFh2gB1NAAM/Al4/Aqs29+PslSBAlxenkP1hxEmW7UCEuFUOubX4nsKdE7HhleYmHpU5C1YipA/+wOQgRH9GKSmXAZuGTde3Ay1VIaQjel3pvWBGfoGFqjCtpIBOKGXTpkE88mbE9DeSiquI7uNGnLjTJl4I/Dx8+Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259952; c=relaxed/simple;
	bh=0d69J5Z6V7w7RGme+QgXyEi07DgzgPRLPMBecll2ros=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgVCdn3BsIFFygDDxsvTXHPfrgH8T0UIWCgzutAXWTwfVIySJbI1w1pZbmiXG9u1C15JawxWIDzFlvCMIL9tQzR/J3eCyd/B3JjSGPgB3R87k51NSoVedMMq5fWMye1USCM62/htiYNqFxPOEfMj9wdTLcawBFkWtxsWTI0EuAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V41wflgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V41wflgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B31E1F000C4;
	Sat, 17 Oct 2026 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259951;
	bh=haW225Fw1Ugv1IZID5Z6ybpDftA3zkpC1An385GkSBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V41wflgJ07IGL5cq1HAYqA4N0g5HnjP0yXi5i/ptQ9usjKm9oR70yMnCrsYv1lNOF
	 fuLLmmthXHLy7syTcgFbir0PBML52gCZWLQq7NMwBbdjNz9sBW2c2kYDVmWkWClLCi
	 NhhZlPMc16EbpdGh2Oaw6RKtwXqoPHFVdl7sL9hg=
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
Subject: [PATCH 6.6 1384/1674] net: sched: fix 32-bit backlog wrap in gred, bfifo and plug enqueue
Date: Sat, 17 Oct 2026 18:00:56 +0200
Message-ID: <20261017160506.688406287@linuxfoundation.org>
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
index ded0eac944068..f3c5e22eb5294 100644
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
index fa7a1b69c0f35..4f44a268286fa 100644
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
index 35f49edf63dbf..6638343ca671a 100644
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



