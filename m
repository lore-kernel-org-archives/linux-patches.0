Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992461684BE;
	Wed, 20 May 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299721; cv=none; b=VGtbRYW8I852guyYJt2K4SihNMnhxUiACmyB+1NQiOFwTdXEjRRAOKQrhAuqDgvqCQshRCkOxj2s8Q9n4T70ybYWSKlPluH4QVkcIPGCyQxdM8Vk0qssbok+1I2Z55wjU77wB98J8yg9XdPlN3tz8henaeFRP3twV3T5at9t1/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299721; c=relaxed/simple;
	bh=46s7SEVn5HJjpETEpt15TKkhMawQ6EUV7VQhTiu52pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwXUpj6ST/5wIZoZHQ4B4s1r9d1kqwYtypUJ2bXtnVETGlUxCTAaql/e2YfuqcWKvaTdS/O1WeMZF934aIlh7DwMzwvtEAkk2xPqJEqaB2Fwmcapfdez3CAeTGP6bwVjJlDH53HZ8J1Dk31yBP/qmosjWNI/dbDJqEhclN0mvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qChvUZbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qChvUZbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4751F000E9;
	Wed, 20 May 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299719;
	bh=7wbXXvAf6Z/g9f81aQXvpL7dPDiSipuB89js93U0mbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qChvUZbvf+VMgHDHBzWB44/b3ZXpDVLBBRQz9tnmK1MZnQBGpZVEaHHKbjLYl4qr/
	 slxzAzcsfOfT3egTsPx79jdzC+jAuztkJV265vvNF3mQYVln0X/Js7vjZxH/Ciq+f5
	 G9FkyEdO4c64ZntQ2b8RGPawRQp6IxU3uPWQhZB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 878/957] sched/fair: Revert force wakeup preemption
Date: Wed, 20 May 2026 18:22:41 +0200
Message-ID: <20260520162153.606016702@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 15257cc2f905dbf5813c0bfdd3c15885f28093c4 ]

This agressively bypasses run_to_parity and slice protection with the
assumpiton that this is what waker wants but there is no garantee that
the wakee will be the next to run. It is a better choice to use
yield_to_task or WF_SYNC in such case.

This increases the number of resched and preemption because a task becomes
quickly "ineligible" when it runs; We update the task vruntime periodically
and before the task exhausted its slice or at least quantum.

Example:
2 tasks A and B wake up simultaneously with lag = 0. Both are
eligible. Task A runs 1st and wakes up task C. Scheduler updates task
A's vruntime which becomes greater than average runtime as all others
have a lag == 0 and didn't run yet. Now task A is ineligible because
it received more runtime than the other task but it has not yet
exhausted its slice nor a min quantum. We force preemption, disable
protection but Task B will run 1st not task C.

Sidenote, DELAY_ZERO increases this effect by clearing positive lag at
wake up.

Fixes: e837456fdca8 ("sched/fair: Reimplement NEXT_BUDDY to align with EEVDF goals")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260123102858.52428-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 58f535cc64215..7e0e2044d840b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8943,16 +8943,6 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	if ((wake_flags & WF_FORK) || pse->sched_delayed)
 		return;
 
-	/*
-	 * If @p potentially is completing work required by current then
-	 * consider preemption.
-	 *
-	 * Reschedule if waker is no longer eligible. */
-	if (in_task() && !entity_eligible(cfs_rq, se)) {
-		preempt_action = PREEMPT_WAKEUP_RESCHED;
-		goto preempt;
-	}
-
 	/* Prefer picking wakee soon if appropriate. */
 	if (sched_feat(NEXT_BUDDY) &&
 	    set_preempt_buddy(cfs_rq, wake_flags, pse, se)) {
-- 
2.53.0



