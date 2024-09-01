Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2AE18593A;
	Sun,  1 Sep 2024 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209064; cv=none; b=pPt3PrbqRr//KkVMPKpQsoaufrO2K9MSF5Gh/vjFNzJDPXBXyUNmNb8p0jRF6WNVJfq/C1NOnVM9u78vBW1gQWTuFNUWfx+Fd37ptB9emI29UgOw4P/J4EdaPdBi6j3DF2g7zMOIZ6hoqKLIU52MdHQh/t2b6Tk1sDmQUdv+alc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209064; c=relaxed/simple;
	bh=tNzovmimcYdjAjVyUQnlHcCKn6C3nFaSUSjkng34XJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcBdW27SHj+brPaikeQN9OygF3mLlrdT5iVmjdVJD13QMAjs2Ijj+Iw8vAQTr0e3s9K3qFHXbm1paP5KML16myyrADTdHc64jOtTG/M/HO+GBzUMaOMZbpf9l1d68BjJXQFiEu9QOgnn/HkbQ2Fkj7PjcUslXMcD3ku1N6mBSxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k81WcC2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k81WcC2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5216AC4CECA;
	Sun,  1 Sep 2024 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209064;
	bh=tNzovmimcYdjAjVyUQnlHcCKn6C3nFaSUSjkng34XJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k81WcC2/lb+KkEtm6FffJmRsI+1PdpORXrSJz/Wq65BPPL0EdBFH3LiIoFzqr+EJ9
	 mkToYKnltBwiy+CtvkHgivIBETD4MQ7s/ft+YpkT/y/u+iCewRyl7bnqfj9WfZlnt5
	 jkiAAEmG1pgjbFeNeqMIkudA+8NwCpa0+a7jW7dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Budimir Markovic <markovicbudimir@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/134] netem: fix return value if duplicate enqueue fails
Date: Sun,  1 Sep 2024 18:17:17 +0200
Message-ID: <20240901160813.522208256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit c07ff8592d57ed258afee5a5e04991a48dbaf382 ]

There is a bug in netem_enqueue() introduced by
commit 5845f706388a ("net: netem: fix skb length BUG_ON in __skb_to_sgvec")
that can lead to a use-after-free.

This commit made netem_enqueue() always return NET_XMIT_SUCCESS
when a packet is duplicated, which can cause the parent qdisc's q.qlen
to be mistakenly incremented. When this happens qlen_notify() may be
skipped on the parent during destruction, leaving a dangling pointer
for some classful qdiscs like DRR.

There are two ways for the bug happen:

- If the duplicated packet is dropped by rootq->enqueue() and then
  the original packet is also dropped.
- If rootq->enqueue() sends the duplicated packet to a different qdisc
  and the original packet is dropped.

In both cases NET_XMIT_SUCCESS is returned even though no packets
are enqueued at the netem qdisc.

The fix is to defer the enqueue of the duplicate packet until after
the original packet has been guaranteed to return NET_XMIT_SUCCESS.

Fixes: 5845f706388a ("net: netem: fix skb length BUG_ON in __skb_to_sgvec")
Reported-by: Budimir Markovic <markovicbudimir@gmail.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240819175753.5151-1-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 47 ++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 265a02b6ad099..591ca93e2a01d 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -437,12 +437,10 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	struct netem_sched_data *q = qdisc_priv(sch);
 	/* We don't fill cb now as skb_unshare() may invalidate it */
 	struct netem_skb_cb *cb;
-	struct sk_buff *skb2;
+	struct sk_buff *skb2 = NULL;
 	struct sk_buff *segs = NULL;
 	unsigned int prev_len = qdisc_pkt_len(skb);
 	int count = 1;
-	int rc = NET_XMIT_SUCCESS;
-	int rc_drop = NET_XMIT_DROP;
 
 	/* Do not fool qdisc_drop_all() */
 	skb->prev = NULL;
@@ -471,19 +469,11 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		skb_orphan_partial(skb);
 
 	/*
-	 * If we need to duplicate packet, then re-insert at top of the
-	 * qdisc tree, since parent queuer expects that only one
-	 * skb will be queued.
+	 * If we need to duplicate packet, then clone it before
+	 * original is modified.
 	 */
-	if (count > 1 && (skb2 = skb_clone(skb, GFP_ATOMIC)) != NULL) {
-		struct Qdisc *rootq = qdisc_root_bh(sch);
-		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
-
-		q->duplicate = 0;
-		rootq->enqueue(skb2, rootq, to_free);
-		q->duplicate = dupsave;
-		rc_drop = NET_XMIT_SUCCESS;
-	}
+	if (count > 1)
+		skb2 = skb_clone(skb, GFP_ATOMIC);
 
 	/*
 	 * Randomized packet corruption.
@@ -495,7 +485,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		if (skb_is_gso(skb)) {
 			skb = netem_segment(skb, sch, to_free);
 			if (!skb)
-				return rc_drop;
+				goto finish_segs;
+
 			segs = skb->next;
 			skb_mark_not_on_list(skb);
 			qdisc_skb_cb(skb)->pkt_len = skb->len;
@@ -521,7 +512,24 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		/* re-link segs, so that qdisc_drop_all() frees them all */
 		skb->next = segs;
 		qdisc_drop_all(skb, sch, to_free);
-		return rc_drop;
+		if (skb2)
+			__qdisc_drop(skb2, to_free);
+		return NET_XMIT_DROP;
+	}
+
+	/*
+	 * If doing duplication then re-insert at top of the
+	 * qdisc tree, since parent queuer expects that only one
+	 * skb will be queued.
+	 */
+	if (skb2) {
+		struct Qdisc *rootq = qdisc_root_bh(sch);
+		u32 dupsave = q->duplicate; /* prevent duplicating a dup... */
+
+		q->duplicate = 0;
+		rootq->enqueue(skb2, rootq, to_free);
+		q->duplicate = dupsave;
+		skb2 = NULL;
 	}
 
 	qdisc_qstats_backlog_inc(sch, skb);
@@ -592,9 +600,12 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	}
 
 finish_segs:
+	if (skb2)
+		__qdisc_drop(skb2, to_free);
+
 	if (segs) {
 		unsigned int len, last_len;
-		int nb;
+		int rc, nb;
 
 		len = skb ? skb->len : 0;
 		nb = skb ? 1 : 0;
-- 
2.43.0



