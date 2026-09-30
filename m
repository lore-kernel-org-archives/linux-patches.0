Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9224F796E;
	Wed, 30 Sep 2026 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784188; cv=none; b=blpmJGetNCYT4Y/l+6jApHxdqjVF3M6LWdXR3nbl/mOS+WIdsrZwf/m0HEZCg4/JxzeiodjF7Jq0z3ZoT0ZYJZPQTGOXTyqObQJc3JxLAFo20v99qIcg00cBYVfWKiGS6UtqqP3LkwGpX9PkXG4n8dor4FnTtx1GWtM/5sOtuzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784188; c=relaxed/simple;
	bh=jAwGsY2axYr9HLmHzcuQSZH+swdKd62ma4hRoAVBuh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3sS4A7dmziFb50DhfJ/4NXoft/LgatLLyDRMRMxMgghM/9k6DqpJiUNC7ywyDgHW6SfiCnBbGFtKsD1xjJquPHdPRyA/GQNHRh/Da9LR+2xwXXMgbBS7CJgcm+5NWe/FcJMA0R1Pg5SkjtV9cAjCb1oMAOat8sXmBQBcYG1gis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v03v39Fm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v03v39Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFF61F00893;
	Wed, 30 Sep 2026 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784184;
	bh=rW0ecCxr3UvoBJxgwJ7HhD+tL7+HBL49FNN7cQWdGlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v03v39Fmrgsqrz3QQfvZJGiiwR7htKFyZVh+RIH4tV9KQT0tWBTJlmO1GDYRTU6xE
	 jRvhbvwQVGhd2Iq+FBlEesazjGjCm2pBxR6+a6in391jlKJn4LPrpwir3MGwYFeBLZ
	 PK1vPZTY9I368XQbMH9tIFyQw5xnud3B5DLDl3ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/982] net/sched: sch_drr: make cl->quantum lockless
Date: Wed, 30 Sep 2026 17:13:20 +0200
Message-ID: <20260930152418.171753543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index f6048a2eddce4..437b09acef123 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -98,10 +98,8 @@ static int drr_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 			}
 		}
 
-		sch_tree_lock(sch);
 		if (tb[TCA_DRR_QUANTUM])
-			cl->quantum = quantum;
-		sch_tree_unlock(sch);
+			WRITE_ONCE(cl->quantum, quantum);
 
 		return 0;
 	}
@@ -250,7 +248,7 @@ static int drr_dump_class(struct Qdisc *sch, unsigned long arg,
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
-	if (nla_put_u32(skb, TCA_DRR_QUANTUM, cl->quantum))
+	if (nla_put_u32(skb, TCA_DRR_QUANTUM, READ_ONCE(cl->quantum)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -361,7 +359,7 @@ static int drr_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 
 	if (!cl_is_active(cl)) {
 		list_add_tail(&cl->alist, &q->active);
-		WRITE_ONCE(cl->deficit, cl->quantum);
+		WRITE_ONCE(cl->deficit, READ_ONCE(cl->quantum));
 	}
 
 	sch->qstats.backlog += len;
@@ -402,7 +400,7 @@ static struct sk_buff *drr_dequeue(struct Qdisc *sch)
 			return skb;
 		}
 
-		WRITE_ONCE(cl->deficit, cl->deficit + cl->quantum);
+		WRITE_ONCE(cl->deficit, cl->deficit + READ_ONCE(cl->quantum));
 		list_move_tail(&cl->alist, &q->active);
 	}
 out:
-- 
2.53.0



