Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794744AB98;
	Tue, 21 Jul 2026 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668817; cv=none; b=SdZItsxKSAKh9C3UOiL1yIiIuu8rSQ7DfzWkk1xf2n+kfBpTNBrk//isafgHROkwGJlsZ9fb9p7psR2NLU/iBPcITjGfGbRL9xSzYMINPCumXqdzL/VmHZpOorgJ6fjIT7d9qBfqyywAGFFN6gZlDE7etR8F51I3jtNbVcCRch8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668817; c=relaxed/simple;
	bh=9VbHSIGbRF1hxe0gZ3/CEpWyzzqZemHnESWtudBhwlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzitYDqJsMQaf85SZBgP25eqrB8/1u/M7nbGhkCldYc2DsZxhCAR9ZhyZkpZR4TLi/Cv0GIJn7lpVpnLrW7sY7e8svaRweUm9pbWN9NiVh+BZLyyWAYrf1rTun1gMMOSakYV6Ij7HTUSYs9QBQjDspAKSLmty58emiPOqApXmiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZx7pOg3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZx7pOg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889F71F000E9;
	Tue, 21 Jul 2026 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668816;
	bh=XhH+A8Mfz/8fmp6OxRdyeabrhaq7B1KtBd7OnLSYDrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZx7pOg3aKXkuSA3lzk8oP7XQVJ7zGYOZIMDtJxKaO/2LB9Pu0cRk4IXGM2mr4beq
	 AA6pwLkuykni/hiGladyxpSlgzIsAD1St9D3cB/nIrBtr9ABBkn+7vIjFku24B8hZn
	 rmIwK++cbiESmvhLr8ml/Cq4ARMOJ7C8jfJ6f+hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0318/1067] net/sched: sch_drr: annotate data-races around cl->deficit
Date: Tue, 21 Jul 2026 17:15:19 +0200
Message-ID: <20260721152431.705948234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c67b104fd7982162885c5e43057ca761006748e2 ]

drr_dump_class_stats() runs without qdisc spinlock held.

Add missing READ_ONCE()/WRITE_ONCE() annotations around cl->deficit.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519094618.2632073-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 3aee041c7bdbaa..f6048a2eddce4e 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -269,7 +269,7 @@ static int drr_dump_class_stats(struct Qdisc *sch, unsigned long arg,
 
 	memset(&xstats, 0, sizeof(xstats));
 	if (qlen)
-		xstats.deficit = cl->deficit;
+		xstats.deficit = READ_ONCE(cl->deficit);
 
 	if (gnet_stats_copy_basic(d, NULL, &cl->bstats, true) < 0 ||
 	    gnet_stats_copy_rate_est(d, &cl->rate_est) < 0 ||
@@ -361,7 +361,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		cl->deficit = cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->quantum);
 	}
 
 	sch->qstats.backlog += len;
@@ -388,7 +388,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 
 		len = qdisc_pkt_len(skb);
 		if (len <= cl->deficit) {
-			cl->deficit -= len;
+			WRITE_ONCE(cl->deficit, cl->deficit - len);
 			skb = qdisc_dequeue_peeked(cl->qdisc);
 			if (unlikely(skb == NULL))
 				goto out;
@@ -402,7 +402,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		cl->deficit += cl->quantum;
+		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



