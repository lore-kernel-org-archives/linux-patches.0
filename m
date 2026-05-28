Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB432459D1;
	Thu, 28 May 2026 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999356; cv=none; b=KslEJhuVJ7oI6rBn5S6u7OLIm1OeflqSgWZJBFQ+ggYhyjaLunSoLJmpU3RrGkTmQZc3NLDPfGxnjCr23fHxEpr/gCXWfWtHgbeYFhQJPSRv9ALoL1TC7bq/Lh52HrX37PPCtaR66AKBMYcZ1jYsko4xnIIr9SUG85ZPf1iqkBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999356; c=relaxed/simple;
	bh=6StoS9tEkMGdRMIj4TGtU6kINVdgM6Mv5PqHwr5zsmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM8udl4oNAeTBJp3bsYXZPus3qwGwESJGcMVV3ed3P4GxlDfdb9RxLahAat7oDB5FFcNRw+QNLLx65NYzGKVeXTdYCqZ+5WwJ3rCDTAH41i1kxNOgCY2IOs6qZZhCio6/D6fY1+iYTviGvCMe3w2zwu+4hsG535+9iHxRgaBK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rC9wwi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rC9wwi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7E21F000E9;
	Thu, 28 May 2026 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999355;
	bh=NuIW7DmizVeOmwJUANzM8/K0H9yh+RAWsja2tnDF4DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rC9wwi3xKNUPFJgrixmLcHSfT5ybso5dN04cctD3fmMhNJWf0adwV5TQupAlkrGx
	 3r2cLwzrL2DnGl+HuQmnQGr6lEpjOeUs1qv8HTEemHj/ogRRUescjlSVozIla0tRGu
	 n8F95K5tOr14o3vumJToboonG5dTHFQb1oADdu3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Goncalves <bgoncalv@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/377] sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting
Date: Thu, 28 May 2026 21:44:05 +0200
Message-ID: <20260528194638.598682429@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index d2bcedc10152f..77b663a5dfb2b 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -322,6 +322,35 @@ static bool check_same_owner(struct task_struct *p)
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
@@ -693,6 +722,7 @@ int __sched_setscheduler(struct task_struct *p,
 			__setscheduler_params(p, attr);
 			p->sched_class = next_class;
 			p->prio = newprio;
+			__setscheduler_dl_pi(newprio, policy, p, scope);
 		}
 		__setscheduler_uclamp(p, attr);
 		check_class_changing(rq, p, prev_class);
-- 
2.53.0



