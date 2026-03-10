Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F0387583;
	Tue, 10 Mar 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141656; cv=none; b=FI+uglp2Yi+26dJknVBx+FDa+Zc4MfWoGaavD3SKSXeothbDdGfm5bVJi68c/uEFqnNfbCNCKa02kjlTAvtQFqum6gmbkr4INb1rH+M1am9cz+LeNvanmkuFj3Zfl2TkLqnYO0bchAk4tmIuiW1A+ivfLL/XdaV+lQC7p8Hb+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141656; c=relaxed/simple;
	bh=1bPWodLI+X4zhz61tgI8MPtO7ZrgwsDjHx5QYJTAMB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8vgVTpSDEsLs+5iPTg+zeyGHS7NtchVZWcTUmyrEBRUftqlY1l/RUoeAiXrdPB5iyU1jy3j/EH8JrxlXsE1SGR8QlN8yQlJr4MAKWGlD2vYScAJGz0Kr2noQblxI/87CrEmWnydTAr8XBn+XBbh5bnAWeGwavVrZDBc8D4arHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxV7mR+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxV7mR+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE64C19423;
	Tue, 10 Mar 2026 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141656;
	bh=1bPWodLI+X4zhz61tgI8MPtO7ZrgwsDjHx5QYJTAMB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxV7mR+qR0f9KvtwWyXg0J21sh/fEB7nfncdLV3Rr44EuLkpqhkLRT7zlZbv1Hs7W
	 T0Q5U6KS2VI9CRS4CzxCFtabWUyB2Z6WyvB/z9bGl3f8PeVFB3DJZM9hg6gDJZtAiZ
	 qv5hkfzqNPVeNyJYt00IqYRJrfIkK8tiT9Nsc+tV1veDsvygnKvJfsG96E4ndImB3b
	 H7AOg5cARnWypMEhzA0gVk4Oy7XiNpJZ04gjK6HxcIdg5ByahAbXMxXZLbP6EMjbLU
	 1mBR/DfLDsxsZTnUbi/+XIr4OVidL4rmOPdwH7wR4dcDXYIy7zixrXu1YcTvKUEasF
	 0PAwhB/vC8oKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shubhang Kaushik <shubhang@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/314] sched/fair: Only set slice protection at pick time
Date: Tue, 10 Mar 2026 07:14:42 -0400
Message-ID: <c9850d894cc206828ccbb9126e106f92439dbb34.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index c3735197c6e7c..1644ad90acdca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5477,7 +5477,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 }
 
 static void
-set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
+set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, bool first)
 {
 	clear_buddies(cfs_rq, se);
 
@@ -5492,7 +5492,8 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__dequeue_entity(cfs_rq, se);
 		update_load_avg(cfs_rq, se, UPDATE_TG);
 
-		set_protect_slice(cfs_rq, se);
+		if (first)
+			set_protect_slice(cfs_rq, se);
 	}
 
 	update_stats_curr_start(cfs_rq, se);
@@ -8932,13 +8933,13 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
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
@@ -13530,7 +13531,7 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
 	for_each_sched_entity(se) {
 		struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
-		set_next_entity(cfs_rq, se);
+		set_next_entity(cfs_rq, se, first);
 		/* ensure bandwidth has been allocated on our new cfs_rq */
 		account_cfs_rq_runtime(cfs_rq, 0);
 	}
-- 
2.51.0

