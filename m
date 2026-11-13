Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590538;
	b=j5KJu2NFKXiJ/MW0FmGZFO2ee8r5XVoJJwp9yKEKk1wfJCh7n7S3XAiujCLol62JZA37
	 bgBqeGCzgMo6ZJ60/5z2cCGBKec7ezDBwWbttlwR7glV6D155kGtc8jaZQQcG7DICuoap
	 QYhnPpDHUBvBmaWUk9+jM9/KZG5qiDTXl/GLdMS8UEdQPim+BqRngcB59pDXpzubZi/O4
	 FJZXOmmQljY79zNrXJHuf902sfRJvKffNLgbb5L/0TiIOqNPP6Bfc8hfyHcw3t+hjqrku
	 R0nkDledvnuy0+QCvn9NpeeROLYAVhHWIk1PYF7R7OmZbdu4Mm3tl/aQZR2Z+gnYvxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eL0jiTQb6d9KYErEIJp+T/gIJRhme9ZwWWl6Q66Us50=;
	b=bWMPt0vrQ4t7xIAGWtKybvBZ2YZ09qukSS+ZNSGI8ALCfqia4MKRMgTZHFxIN20f986p
	 n4tmvTXcoa98gjz6MNhRCKB7v4hgY5oXmvmTp01yQbieLNH+QgCUZDJkTYB8DGWlu+bbx
	 omC6BhapA0fL3HeAAeUQKTy5q8FpFZeONcmFflFe3MPt96HpN1JODpMW835tn1mi4nLco
	 SrqLn04xhsLB2HS1HUVRAv17vRBnflKAPZ4aBzDzlpI1RyWrJq9YrpC+WvENMuC+xyEJd
	 vawcINzxokESQQpVftpNV3j61aLsu3twcFsagMaTmU333j0iMUjgqsXKNJ+/uz5l//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdSBy1mD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1EB6074B07;
	Fri, 13 Nov 2026 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdSBy1mD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5111F000CA;
	Fri, 13 Nov 2026 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590538;
	bh=eL0jiTQb6d9KYErEIJp+T/gIJRhme9ZwWWl6Q66Us50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdSBy1mDdMM/Bng+qXPpW3TJIW4F5crCh8Luy4sjEZuz4lwOC9FsvJ8nsT1kMxOf5
	 EfVDMNR241stYgvxUQ+1wmykITeMtL278j2Lt6V9vXizP7X/WBt1dTUvtjeGxeEpNb
	 jlP5Xz1/J8MpE9IttCc9VwA7v3b39PR1Z9Jpbe88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Blaszczyk <michalblk@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 479/686] sched_ext: Reset runnable_at when a task leaves its scheduler
Date: Fri, 13 Nov 2026 10:50:12 -0500
Message-ID: <20261113153837.187693223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Blaszczyk <michalblk@google.com>

[ Upstream commit 993e8fbfecbbf284b9644c6f10741b28fb914094 ]

The watchdog measures how long a task has been waiting from
p->scx.runnable_at, which set_task_runnable() resets when the task becomes
runnable after it last ran. ops_dequeue() never asks for a reset, as the
dequeue of a waiting task is temporary, e.g. for a migration or an
attribute change.

Leaving the scheduler isn't temporary. A task which is switched out of
SCHED_EXT while it's waiting keeps its runnable_at. When it's switched back
and becomes runnable, its wait appears to have started before it left, and
the time it spent in another class counts towards the timeout. If the
watchdog checks before the task runs, it aborts the scheduler:

  sched_ext: class_switch_stall: runner[418] failed to run for 3.010s

Here, the task waited for a few milliseconds before it was switched to
SCHED_OTHER, slept outside of SCHED_EXT for three seconds, and was charged
for all of it as soon as it woke up on SCHED_EXT again.

The same happens when scx_sub_enable_workfn() hands a waiting task over to
a new sub-scheduler, which can then be blamed for time the task waited
under the parent. scx_rehome_task() isn't affected, as it moves the task
through SCX_TASK_INIT, which resets runnable_at. The stale runnable_at also
skews the default core-sched ordering in scx_prio_less().

Reset runnable_at in scx_disable_task(), when the task leaves the control
of its scheduler.

Fixes: 8a010b81b3a5 ("sched_ext: Implement runnable task stall watchdog")
Cc: stable@vger.kernel.org # v6.12+
Assisted-by: LLM
Signed-off-by: Michal Blaszczyk <michalblk@google.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ michalblk: applied to kernel/sched/ext.c; adjusted context ]
Signed-off-by: Michal Blaszczyk <michalblk@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 78f15ddc0aa5a..3117d1ef869c5 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1438,7 +1438,11 @@ static void ops_dequeue(struct rq *rq, struct task_struct *p, u64 deq_flags)
 	struct scx_sched *sch = scx_root;
 	unsigned long opss;
 
-	/* dequeue is always temporary, don't reset runnable_at */
+	/*
+	 * Don't reset runnable_at. If @p is waiting, the wait continues across
+	 * temporary dequeues, e.g. for a migration or an attribute change.
+	 * scx_disable_task() ends it if @p leaves its scheduler.
+	 */
 	clr_task_runnable(p, false);
 
 	/* acquire ensures that we see the preceding updates on QUEUED */
@@ -2959,6 +2963,14 @@ static void scx_disable_task(struct task_struct *p)
 	if (SCX_HAS_OP(sch, disable))
 		SCX_CALL_OP_TASK(sch, SCX_KF_REST, disable, rq, p);
 	scx_set_task_state(p, SCX_TASK_READY);
+
+	/*
+	 * If @p is runnable but not running, its wait started at runnable_at,
+	 * which ops_dequeue() didn't reset. Leaving @sch ends the wait. Reset
+	 * runnable_at the next time @p is enqueued on SCX, so that the watchdog
+	 * doesn't count the time @p spends elsewhere.
+	 */
+	p->scx.flags |= SCX_TASK_RESET_RUNNABLE_AT;
 }
 
 static void scx_exit_task(struct task_struct *p)
-- 
2.53.0



