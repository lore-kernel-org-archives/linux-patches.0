Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C7022ACDC;
	Mon, 10 Mar 2025 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628101; cv=none; b=BMRk5igpp1rGkqEKdxH8jfhB/XeRWZZPi9l7sqJPWgFi1yWdAdxxGBu9QjnD1HcpW0JBqjndKxh5Oh1sdqunoemGN6Fv0VvHTVJ7gEjAKXvnaFKoXlhi88fil+Bmt63GIJQSctBrpCPxtIm4fafxg44fkUcd5PuMYtBwYFtoWps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628101; c=relaxed/simple;
	bh=MMijPqEatBXA56C1c00THIC2fro/VMdqQD/JzReOBL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL4iP4hi/gTDKKoGKCOR9bd2F227xKP5+hMfDn1JFQsF+WZuqtHG08He/mchHSjsWN/akzdUAxTjK9qfbP7eA0k4jHphQEhYeVo8CiFIBtoj4+/Lrim3Q3/ytO365XMmrtlohnLQ72Wk6wUzp2n3Sbu9jpRwnFqwWxn9MR+tRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCG4x1/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCG4x1/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DFBC4CEEC;
	Mon, 10 Mar 2025 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628101;
	bh=MMijPqEatBXA56C1c00THIC2fro/VMdqQD/JzReOBL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCG4x1/uEc2YxoyKLLvyA9FoA80OKdKV5AFGQ9LKHPZgXG23wAol4GYU67CbReaO2
	 lriugxFEVFZewlsBBKcNf1LCXAGK4vqgustH7cVOEX7j8vfaIw7UZ3llFBsn7Vqbjf
	 1eXSNn8907kIxxFyagZ9RhzNKF1l1IkE4LWsJrps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zecheng Li <zecheng@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.6 087/145] sched/fair: Fix potential memory corruption in child_cfs_rq_on_list
Date: Mon, 10 Mar 2025 18:06:21 +0100
Message-ID: <20250310170438.269160517@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zecheng Li <zecheng@google.com>

[ Upstream commit 3b4035ddbfc8e4521f85569998a7569668cccf51 ]

child_cfs_rq_on_list attempts to convert a 'prev' pointer to a cfs_rq.
This 'prev' pointer can originate from struct rq's leaf_cfs_rq_list,
making the conversion invalid and potentially leading to memory
corruption. Depending on the relative positions of leaf_cfs_rq_list and
the task group (tg) pointer within the struct, this can cause a memory
fault or access garbage data.

The issue arises in list_add_leaf_cfs_rq, where both
cfs_rq->leaf_cfs_rq_list and rq->leaf_cfs_rq_list are added to the same
leaf list. Also, rq->tmp_alone_branch can be set to rq->leaf_cfs_rq_list.

This adds a check `if (prev == &rq->leaf_cfs_rq_list)` after the main
conditional in child_cfs_rq_on_list. This ensures that the container_of
operation will convert a correct cfs_rq struct.

This check is sufficient because only cfs_rqs on the same CPU are added
to the list, so verifying the 'prev' pointer against the current rq's list
head is enough.

Fixes a potential memory corruption issue that due to current struct
layout might not be manifesting as a crash but could lead to unpredictable
behavior when the layout changes.

Fixes: fdaba61ef8a2 ("sched/fair: Ensure that the CFS parent is added after unthrottling")
Signed-off-by: Zecheng Li <zecheng@google.com>
Reviewed-and-tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20250304214031.2882646-1-zecheng@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 726fa69c4d88b..2808dbdd03847 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4118,15 +4118,17 @@ static inline bool child_cfs_rq_on_list(struct cfs_rq *cfs_rq)
 {
 	struct cfs_rq *prev_cfs_rq;
 	struct list_head *prev;
+	struct rq *rq = rq_of(cfs_rq);
 
 	if (cfs_rq->on_list) {
 		prev = cfs_rq->leaf_cfs_rq_list.prev;
 	} else {
-		struct rq *rq = rq_of(cfs_rq);
-
 		prev = rq->tmp_alone_branch;
 	}
 
+	if (prev == &rq->leaf_cfs_rq_list)
+		return false;
+
 	prev_cfs_rq = container_of(prev, struct cfs_rq, leaf_cfs_rq_list);
 
 	return (prev_cfs_rq->tg->parent == cfs_rq->tg);
-- 
2.39.5



