Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11E2387583;
	Tue, 10 Mar 2026 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141268; cv=none; b=mhJ4WPVvmgoKe+iRFx74mH4afgOUOs5FJFrR8SZuUPrXT5kght7idO3EGukenhdKuGYXb+cnhmyG2/X6ivTefWI8eZGFVerWj+kizn+7Yox6Xnz9mHbLmI5aXfTVOX0uhWgdhST/goHMYXuRyMPjsKWi2FWqxjS9Fzu7LOFjc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141268; c=relaxed/simple;
	bh=sQkr+Mtaon79MOYSB1Ym15KzgUNDlhTRlx5xmUf8CXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXIrhOqxswfE4V29B2yoYYpy1/8D1pYsf1LussD3t/mY23ue2/6mT1SRSoJS5pi/sESghcp3E3nr3PPBroUPbwgQnf6dI3VmNjw2ya4NnvNrDBw6fgSo4mDZ6VLySAlQ9yxSk+ARNUu6+dYSevymozoQWVbNY7ahtBfAFt9XxUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sVdJBGX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVdJBGX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0266C2BC86;
	Tue, 10 Mar 2026 11:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141268;
	bh=sQkr+Mtaon79MOYSB1Ym15KzgUNDlhTRlx5xmUf8CXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVdJBGX3ig7xcXb3FeP/b7gPGxC8Y0K/cXbCsLgKmVV8gGvuraUnobw3crk2Tmxq2
	 eLhkh/XJKdtO/p/G4cKu20cgeNtt59/xV02sq3iedjdjkADZlSIJOmrvLDgYBF16p4
	 GaFAPLjQU3gRKkEaiblv873vYzMwxiN4wJZ1aMLtEf3jvY0lwRBMGuSVWWWOLfesXa
	 DrDw/yvAwahyXgM54TCY645GUn6c3XpOiilqQEtixfdYUH2Jzbdvwd8DhTRXq9P/Zo
	 Qj6+Qd++ToJMncNz2B/K6Z6FmvUQJMFGzf/+ntJo9YL82EqKWYDokRwta9kaXOd+bB
	 /kU2rFinUrgNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Bruno Goncalves <bgoncalv@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 270/311] sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting
Date: Tue, 10 Mar 2026 07:05:17 -0400
Message-ID: <8fec82d11600f8fdfc8143892611e03e6b3e1e20.1773140655.git.sashal@kernel.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit d658686a1331db3bb108ca079d76deb3208ed949 ]

Running stress-ng --schedpolicy 0 on an RT kernel on a big machine
might lead to the following WARNINGs (edited).

 sched: DL de-boosted task PID 22725: REPLENISH flag missing

 WARNING: CPU: 93 PID: 0 at kernel/sched/deadline.c:239 dequeue_task_dl+0x15c/0x1f8
 ... (running_bw underflow)
 Call trace:
  dequeue_task_dl+0x15c/0x1f8 (P)
  dequeue_task+0x80/0x168
  deactivate_task+0x24/0x50
  push_dl_task+0x264/0x2e0
  dl_task_timer+0x1b0/0x228
  __hrtimer_run_queues+0x188/0x378
  hrtimer_interrupt+0xfc/0x260
  ...

The problem is that when a SCHED_DEADLINE task (lock holder) is
changed to a lower priority class via sched_setscheduler(), it may
fail to properly inherit the parameters of potential DEADLINE donors
if it didn't already inherit them in the past (shorter deadline than
donor's at that time). This might lead to bandwidth accounting
corruption, as enqueue_task_dl() won't recognize the lock holder as
boosted.

The scenario occurs when:
1. A DEADLINE task (donor) blocks on a PI mutex held by another
   DEADLINE task (holder), but the holder doesn't inherit parameters
   (e.g., it already has a shorter deadline)
2. sched_setscheduler() changes the holder from DEADLINE to a lower
   class while still holding the mutex
3. The holder should now inherit DEADLINE parameters from the donor
   and be enqueued with ENQUEUE_REPLENISH, but this doesn't happen

Fix the issue by introducing __setscheduler_dl_pi(), which detects when
a DEADLINE (proper or boosted) task gets setscheduled to a lower
priority class. In case, the function makes the task inherit DEADLINE
parameters of the donoer (pi_se) and sets ENQUEUE_REPLENISH flag to
ensure proper bandwidth accounting during the next enqueue operation.

Fixes: 2279f540ea7d ("sched/deadline: Fix priority inheritance with multiple scheduling classes")
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260302-upstream-fix-deadline-piboost-b4-v3-1-6ba32184a9e0@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/syscalls.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index 6f10db3646e7f..cadb0e9fe19b9 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -284,6 +284,35 @@ static bool check_same_owner(struct task_struct *p)
 		uid_eq(cred->euid, pcred->uid));
 }
 
+#ifdef CONFIG_RT_MUTEXES
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+			      struct task_struct *p,
+			      struct sched_change_ctx *scope)
+{
+	/*
+	 * In case a DEADLINE task (either proper or boosted) gets
+	 * setscheduled to a lower priority class, check if it neeeds to
+	 * inherit parameters from a potential pi_task. In that case make
+	 * sure replenishment happens with the next enqueue.
+	 */
+
+	if (dl_prio(newprio) && !dl_policy(policy)) {
+		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+
+		if (pi_task) {
+			p->dl.pi_se = pi_task->dl.pi_se;
+			scope->flags |= ENQUEUE_REPLENISH;
+		}
+	}
+}
+#else /* !CONFIG_RT_MUTEXES */
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+			      struct task_struct *p,
+			      struct sched_change_ctx *scope)
+{
+}
+#endif /* !CONFIG_RT_MUTEXES */
+
 #ifdef CONFIG_UCLAMP_TASK
 
 static int uclamp_validate(struct task_struct *p,
@@ -655,6 +684,7 @@ int __sched_setscheduler(struct task_struct *p,
 			__setscheduler_params(p, attr);
 			p->sched_class = next_class;
 			p->prio = newprio;
+			__setscheduler_dl_pi(newprio, policy, p, scope);
 		}
 		__setscheduler_uclamp(p, attr);
 
-- 
2.51.0

