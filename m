Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ABA2586FB;
	Thu, 17 Apr 2025 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915097; cv=none; b=sBF2mGTMG+VlvfMLnFpZnMO3Gm5y7TwJXzXPrG+T1oYWhFmoecIQ6bsf7fdl77EEXjeolVvhKPeXLy9R7IXlhYsy9B9d4kJVjA/ukIWGjKECtMGfOKq1f1xxGnprVZrb4+WCBJTdUgtg88TVnVP6cc0RsVHX/tzJA88X6t4I8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915097; c=relaxed/simple;
	bh=t1V0pVJQodvGSW5iWjQxHMmBjV9WOiD1nGco0c1AKuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSzw/oeysfUY/FrMxDHoJGN43iTYXcztaYCLmHyCYgfeAUrilnVz7bXkErZg1MDx5seFIdHy8MovYBWFhZuJ0yyWfwVYhJz5GTqGivDj0MBZN8JmEFXp1damGMC+bMleCN1rObx0wvSlLaFwXFtesxObeB7+DKgcgrJ6awnDCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkF7Kpz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkF7Kpz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282A2C4CEE7;
	Thu, 17 Apr 2025 18:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915097;
	bh=t1V0pVJQodvGSW5iWjQxHMmBjV9WOiD1nGco0c1AKuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkF7Kpz8KlI3pBDEiw1WMXkyHEWiThNCjeUMQgEl5K82pBGUuxm1sx8bGfthuPIui
	 05kBpx92wuNWlBtfoQMme1wg0QC1P3rNAn1x1hFJ9ZqBSem953kCAN3gpZIwbQme4M
	 GQMEd3yNO5RsHWZuIw+dVhfNo8yFmNiG/g/fotYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/393] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
Date: Thu, 17 Apr 2025 19:47:07 +0200
Message-ID: <20250417175108.328249117@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 342debc12183b51773b3345ba267e9263bdfaaef ]

After making all ->qlen_notify() callbacks idempotent, now it is safe to
remove the check of qlen!=0 from both fq_codel_dequeue() and
codel_qdisc_dequeue().

Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Fixes: 76e3cc126bb2 ("codel: Controlled Delay AQM")
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250403211636.166257-1-xiyou.wangcong@gmail.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c    | 5 +----
 net/sched/sch_fq_codel.c | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 3e8d4fe4d91e3..e1f6e7618debd 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -65,10 +65,7 @@ static struct sk_buff *codel_qdisc_dequeue(struct Qdisc *sch)
 			    &q->stats, qdisc_pkt_len, codel_get_enqueue_time,
 			    drop_func, dequeue_func);
 
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->stats.drop_count && sch->q.qlen) {
+	if (q->stats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->stats.drop_count, q->stats.drop_len);
 		q->stats.drop_count = 0;
 		q->stats.drop_len = 0;
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 4f908c11ba952..778f6e5966be8 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -314,10 +314,8 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
 	}
 	qdisc_bstats_update(sch, skb);
 	flow->deficit -= qdisc_pkt_len(skb);
-	/* We cant call qdisc_tree_reduce_backlog() if our qlen is 0,
-	 * or HTB crashes. Defer it for next round.
-	 */
-	if (q->cstats.drop_count && sch->q.qlen) {
+
+	if (q->cstats.drop_count) {
 		qdisc_tree_reduce_backlog(sch, q->cstats.drop_count,
 					  q->cstats.drop_len);
 		q->cstats.drop_count = 0;
-- 
2.39.5



