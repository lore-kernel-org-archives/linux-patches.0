Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E81C1D0DE6;
	Wed,  2 Oct 2024 14:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879611; cv=none; b=jCAO12lFD6ObfQq5TUM8zIDfBUKn+7yDaaGMTb2l+uaCTgx2IdvkNhpPQrTHHqZGMbPyV0Mno++4sn/dSN8/WWFYEg1bl286Jg1nfUC910kU/dagaX+C1Uh/HYn9iZEJLEjSPpIN0puZA3hgkDrRTaUIfZ+NmzjEH9gsNqhjCNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879611; c=relaxed/simple;
	bh=uCdy9OUnVxkUBseNU9QUBEli1q2X0DS/Ph09M/U8lZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IePvYuxpFNJoU5GYvgP4sbXuo4waR2xag3+GRcA5vYZ2e4RzCqg4iTGT3EtQd4dMRf3td2ciL2GbzrEQm0sCW3wYOv4CAlp6mm1HjKNraIDg+aXXem6Eh0/e7Hj6fjIFygoycZN+6wZq7f/opAbf4i8T+//PJwwYOkxhAfaATRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIx+wXAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIx+wXAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1AFC4CEC2;
	Wed,  2 Oct 2024 14:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879611;
	bh=uCdy9OUnVxkUBseNU9QUBEli1q2X0DS/Ph09M/U8lZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIx+wXAJ6SVP0FOD3scWzgS3qlqovSgrRcsQgHHcoMhqNyBhpBiU4x23xdsJ4gvKz
	 Kp1sDeiaEXezxFOL3gknZiCdSjDYarx8wtZrmmUEsyu0XLWdfWX00EhK/TPuTlG2Oi
	 91hM9imn9oseLTH9qIkPbErmHWkUZ3TBQKlpYaX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Don <joshdon@google.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/538] sched/fair: Make SCHED_IDLE entity be preempted in strict hierarchy
Date: Wed,  2 Oct 2024 14:56:58 +0200
Message-ID: <20241002125759.321708549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b2e1009e5706e..5fc0d9cc9d9d7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -533,7 +533,7 @@ static int cfs_rq_is_idle(struct cfs_rq *cfs_rq)
 
 static int se_is_idle(struct sched_entity *se)
 {
-	return 0;
+	return task_has_idle_policy(task_of(se));
 }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
@@ -8209,16 +8209,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
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
@@ -8228,7 +8219,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	pse_is_idle = se_is_idle(pse);
 
 	/*
-	 * Preempt an idle group in favor of a non-idle group (and don't preempt
+	 * Preempt an idle entity in favor of a non-idle entity (and don't preempt
 	 * in the inverse case).
 	 */
 	if (cse_is_idle && !pse_is_idle)
@@ -8236,9 +8227,14 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
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



