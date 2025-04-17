Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27142571B4;
	Thu, 17 Apr 2025 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912459; cv=none; b=P6JuxsRDCSDoRh0QNTdvZfStukMFyOEV08RsX9UCdV270T9ZBFFdAt6mQN0P3RV7/5B63pUERuKXCJrxaZ77aH0QYYZRjzTQAd97MFtY4lo1pdOUu+3RH6657zn4f9hQmwt0lvnldTUFx8Ykz5DuKhCSZCTKc2qfmlBQiFczpuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912459; c=relaxed/simple;
	bh=0+ZT+/lQye5Y77KJRT5en1YbQH6Wi7rkci33b8EF+H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBS34HVWiAePfkmo2PWRgXwVk0RzYCOQpXUQ5yF5EoCIy5+DDSiwvXRrIAhcz7hYBhBG43NM2MtNq3mJy+P5SSkZXV4B834pFhVfaToR71Q+KRufMnwM6OlmVccck39qYF+xvRRSrKA98GhW0pGHChG1Ty0RHlJs3oE7Ym+DhQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVvDLUMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVvDLUMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E7C4CEE4;
	Thu, 17 Apr 2025 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912459;
	bh=0+ZT+/lQye5Y77KJRT5en1YbQH6Wi7rkci33b8EF+H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVvDLUMpkhtacFuMguMWkWgL2coN5UqgCGgyeqji1AaplFVGofSdgny/D/+ijlGd0
	 Wo/Uu0BB7l3moRIMbXNcBLB8AMFNJzk1pY4IeLXrsPqeiUJsHO1E2w6wk8UjIbF43J
	 ZxIEfQMpgvD554c8ZRklXetTA9o+VDmo/vTl30lY=
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
Subject: [PATCH 6.14 018/449] codel: remove sch->q.qlen check before qdisc_tree_reduce_backlog()
Date: Thu, 17 Apr 2025 19:45:06 +0200
Message-ID: <20250417175118.723781891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 81189d02fee76..12dd71139da39 100644
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
index 799f5397ad4c1..6c9029f71e88d 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -315,10 +315,8 @@ static struct sk_buff *fq_codel_dequeue(struct Qdisc *sch)
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



