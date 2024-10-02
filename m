Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE51D0B87;
	Wed,  2 Oct 2024 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875906; cv=none; b=hi40JxaM1MhJOwz+uqneChhVcGFSAUvgs/+NkNZxknKqayjnVDC27J8H/7KKZunHHxpd+5qN+Bs/N4jS8JH2dTXvDQ3bnRAf1GoUzpDqW2KYByin9sICm8+dj79bcRcp7tg4HIhxRkhF/HQMPFYSqv44BgIqX/MpKUn09z/7w0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875906; c=relaxed/simple;
	bh=kUvUDoGBs4TBGfwJF9iWwR5AuEXv+n2rOEGKWADvsA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snbH0CI8Fw+1RuDOEZqp3mWLJhG2T26vS0Xn7JLzl8dN3xZWeedRozMwWxL21ey0INpNAzJcRjS68CVkIArqrqtJxIASEOZ61oNApZVYJtwyeIhQ+hu1TUGMgMSAGjFF8QATPPafny/xNC6a62gB1taYeWzfCHX/TxRIR+G3bVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7LTUFPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7LTUFPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE5CC4CECE;
	Wed,  2 Oct 2024 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875905;
	bh=kUvUDoGBs4TBGfwJF9iWwR5AuEXv+n2rOEGKWADvsA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7LTUFPC7l/raB4yCk7lBB1+l1QX/yf/pYs02faKtnrMx74Z4hMJG3VT3Vkrz2RkM
	 k4Si9l0BvSaT/hYQDqHzE9//AjsgbrJw+5vQ/i63C1vLxGUoDzyYCfP11DTdLiFrKe
	 MFvY0dCgbiWoXhtl7eEvIKbjuupdlht051EUHt1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Don <joshdon@google.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 254/695] sched/fair: Make SCHED_IDLE entity be preempted in strict hierarchy
Date: Wed,  2 Oct 2024 14:54:12 +0200
Message-ID: <20241002125832.586420546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit faa42d29419def58d3c3e5b14ad4037f0af3b496 ]

Consider the following cgroup:

                       root
                        |
             ------------------------
             |                      |
       normal_cgroup            idle_cgroup
             |                      |
   SCHED_IDLE task_A           SCHED_NORMAL task_B

According to the cgroup hierarchy, A should preempt B. But current
check_preempt_wakeup_fair() treats cgroup se and task separately, so B
will preempt A unexpectedly.
Unify the wakeup logic by {c,p}se_is_idle only. This makes SCHED_IDLE of
a task a relative policy that is effective only within its own cgroup,
similar to the behavior of NICE.

Also fix se_is_idle() definition when !CONFIG_FAIR_GROUP_SCHED.

Fixes: 304000390f88 ("sched: Cgroup SCHED_IDLE support")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Josh Don <joshdon@google.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20240626023505.1332596-1-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9057584ec06de..82ff874953b55 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -511,7 +511,7 @@ static int cfs_rq_is_idle(struct cfs_rq *cfs_rq)
 
 static int se_is_idle(struct sched_entity *se)
 {
-	return 0;
+	return task_has_idle_policy(task_of(se));
 }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
@@ -8381,16 +8381,7 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	if (test_tsk_need_resched(curr))
 		return;
 
-	/* Idle tasks are by definition preempted by non-idle tasks. */
-	if (unlikely(task_has_idle_policy(curr)) &&
-	    likely(!task_has_idle_policy(p)))
-		goto preempt;
-
-	/*
-	 * Batch and idle tasks do not preempt non-idle tasks (their preemption
-	 * is driven by the tick):
-	 */
-	if (unlikely(p->policy != SCHED_NORMAL) || !sched_feat(WAKEUP_PREEMPTION))
+	if (!sched_feat(WAKEUP_PREEMPTION))
 		return;
 
 	find_matching_se(&se, &pse);
@@ -8400,7 +8391,7 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	pse_is_idle = se_is_idle(pse);
 
 	/*
-	 * Preempt an idle group in favor of a non-idle group (and don't preempt
+	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
 	 * in the inverse case).
 	 */
 	if (cse_is_idle && !pse_is_idle)
@@ -8408,9 +8399,14 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	if (cse_is_idle != pse_is_idle)
 		return;
 
+	/*
+	 * BATCH and IDLE tasks do not preempt others.
+	 */
+	if (unlikely(p->policy != SCHED_NORMAL))
+		return;
+
 	cfs_rq = cfs_rq_of(se);
 	update_curr(cfs_rq);
-
 	/*
 	 * XXX pick_eevdf(cfs_rq) != se ?
 	 */
-- 
2.43.0



