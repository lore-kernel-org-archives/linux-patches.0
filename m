Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0687734B197;
	Tue, 10 Mar 2026 11:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140791; cv=none; b=ZQlCIMDmcCa1pqWErQlL+ZaLPnEXeAS4GqIC9alDLtBHJXIJyi9Azf9fWZIHJ7jHf49bWw7glMk0kxfuIY4r/Z1J9RUKX7Za/+WsyU1E5ShaxHnuy8gldTnvo5qWbgskLUGN+tqRGUDJD9hYCdlt/9nby6omAFxRko52Skz7/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140791; c=relaxed/simple;
	bh=uFLHSw5xNXtDuMf94kDjxMt843OkwJ3ijIVnedLinHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I88gYg9ZNA6bpQwhV6QgphB4wZI+15+W8pszLizdY7/maMPoSnbxHiFXTECuHvhYVOK2XxVmgy2AZFnIVVl8SDUqQYETvntH3QhHJWMjgnmzNqdRe2DGwEQNcqH7KbCxgtiLRTXj9gY4qhsvWZlpm5V+RlKwqcmbMWsjUVlb5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHSDxBH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHSDxBH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3D7C19423;
	Tue, 10 Mar 2026 11:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140790;
	bh=uFLHSw5xNXtDuMf94kDjxMt843OkwJ3ijIVnedLinHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHSDxBH3iAzg/NKQoNJ4aNSAuIWWgb0Fh10OuMBtJ9sFZi5ulFcnTY7kuXdRfkU6r
	 XAr5WMSytv6EVPTxPPdi5BtekLAVPSftJ10NiQKTohRM2ufs7PpRwIsSs8z6XMZIo+
	 er6mcq8iQQxL1G4GAQBitGfIe2cCARyWMNf1/zFhYsQRo+5CWyaCMNIZC5kjmnPoGq
	 Ac1DSoLyQixt9fwHEXqgZJAl3ukLJ/l2nAA8JTRMv/aq/WTw87e6x390tgJegBY3tH
	 JfVodpaDvKIY5CDPYC5pbl0wIr8c7NYdm79NLYKLbua7d0vuopKLwrfNKqlw3ijLKr
	 AJ9cLzizBjjZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 027/311] sched/fair: Only set slice protection at pick time
Date: Tue, 10 Mar 2026 07:01:14 -0400
Message-ID: <82f64b69140f2677f1cc5c5c479db2605d035066.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bcd74b2ffdd0a2233adbf26b65c62fc69a809c8e ]

We should not (re)set slice protection in the sched_change pattern
which calls put_prev_task() / set_next_task().

Fixes: 63304558ba5d ("sched/eevdf: Curb wakeup-preemption")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Link: https://patch.msgid.link/20260219080624.561421378%40infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 436dec8927232..6f66d4f0540ea 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5488,7 +5488,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 }
 
 static void
-set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, bool first)
 {
 	clear_buddies(cfs_rq, se);
 
@@ -5503,7 +5503,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__dequeue_entity(cfs_rq, se);
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 
-		set_protect_slice(cfs_rq, se);
+		if (first)
+			set_protect_slice(cfs_rq, se);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
@@ -9016,13 +9017,13 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
 				pse = parent_entity(pse);
 			}
 			if (se_depth >= pse_depth) {
-				set_next_entity(cfs_rq_of(se), se);
+				set_next_entity(cfs_rq_of(se), se, true);
 				se = parent_entity(se);
 			}
 		}
 
 		put_prev_entity(cfs_rq, pse);
-		set_next_entity(cfs_rq, se);
+		set_next_entity(cfs_rq, se, true);
 
 		__set_next_task_fair(rq, p, true);
 	}
@@ -13621,7 +13622,7 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		set_next_entity(cfs_rq, se);
+		set_next_entity(cfs_rq, se, first);
 		/* ensure bandwidth has been allocated on our new cfs_rq */
 		account_cfs_rq_runtime(cfs_rq, 0);
 	}
-- 
2.51.0

