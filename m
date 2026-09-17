Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889B63A48E9;
	Thu, 17 Sep 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667513; cv=none; b=WBqD2kxOnxbJL74mML5+eyC35LMWWPApK81ZfDW/wGloJxun1BJ8tqAIuVuKWA17LYavRxE6H8dW3GhvgAOmZotl9TyLmgECLATav0axOCyQXFSvK18OgiKWgUvlt3n6gax72ShfZetOnnOCpqM1H7f11kCbXIbuwWSy16SL9q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667513; c=relaxed/simple;
	bh=Fwn+9eL5q/zaXWIEJz5S9hUzT9oBsIRihAWt+7BGWKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5fVLQnA9NzWk3tRglSMGUNj3W5Meno+apkAaz/WWJisxwAp50V8ypDy0N1in0O6r3P29FRcNJ2omgJf447Zmxkt4tjEybDSaPRVRlGjv6SVOZnRbQA8QaWjqn8tU0AezpH9vK+Jrr+bwIMgx5JUpcalh1qQKNrM89bjLurCSG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhzjIhPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhzjIhPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26331F000FF;
	Thu, 17 Sep 2026 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667512;
	bh=xYEH+l7I4MDIdvBhUJGhYq59RiIFNujcllOc7vNK9jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhzjIhPpyEfxMTu6dBcLAiJBQO4Rzgn25e6kyO2xbuGISgI1TUAiPxakT8qg6TN5B
	 /wr5oUWT7uvwJ3V5Fp/sCsfrkvFRVPJYgibuzN9KtPtb5tHVBMilrGB/lJJXwVHX1b
	 XJEyOapBhWvvKz1NnK1hzHfDXKZbtl49pL9jaZm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0117/1102] net/sched: sch_drr: make cl->quantum lockless
Date: Thu, 17 Sep 2026 16:01:00 +0100
Message-ID: <20260917151542.445318592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4d880b85089e12a5f2e8e2fee386310cec5b99a ]

cl->quantum does not need to be protected by RTNL or qdisc spinlock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260519094618.2632073-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_drr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 44686fd1c2749..faafb29056259 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -97,10 +97,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 			}
 		}
 
-		sch_tree_lock(sch);
 		if (tb[TCA_DRR_QUANTUM])
-			cl->quantum = quantum;
-		sch_tree_unlock(sch);
+			WRITE_ONCE(cl->quantum, quantum);
 
 		return 0;
 	}
@@ -251,7 +249,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
+	if (nla_put_u32(skb, TCA_DRR_QUANTUM, READ_ONCE(cl->quantum)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -362,7 +360,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -403,7 +401,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



