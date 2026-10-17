Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4473C345F;
	Sat, 17 Oct 2026 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258375; cv=none; b=KkIkxtYHeYxRKSE2taoJ5QLoH4sNtiQqOvAGHmFQGpThZIG0WD+fuYvOLKA/zIHG2H0jfN9DL8vN+8aDP2Ju8I/cJ3ao5QwGkJ0Z5g6yEkjdMgnic8pz9OCDKypyJJOwEcpr1/kl72zrQgo6EEpM5iRqL33dqjXmgRQ4Mbqt1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258375; c=relaxed/simple;
	bh=R+oq6uNgMo1lg0qg/IO19lXPLhVOpNRDH9qQx33vE/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGaHJOqpAERqQFuw5eEwCjBWY/S0hfEeRcxjVBo7GEYmJQGjgOSkHOwHVw7licE+VxlVgwzhrZBhp1yWHno0rNg0v2cGQAESP1D9Xs5eJIM3DPbunSOsqcrmp8NnHmXh4GjMbM8/2lKddQ9iZwWWJGuA0ehyB2afpgyjPvThy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWmn94k7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWmn94k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33111F000C5;
	Sat, 17 Oct 2026 17:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258374;
	bh=zvTJf2AjeSiLIgPSf7o8YltnhAwmfwXtcIgGgfYBvpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWmn94k7gazZQLnJuDL7PyQgMhUWpq0S44kn7q3VQ3rKkYgdbu26FaF42R81Va33s
	 uFOezsU1kTzcDHFIsGk1UCaLKyaUoToaIpUy1Na/kDYNTDD5Bwc5Kb/G0lZHoYGBYe
	 SMwu/vsNBSuVC1BNOl6yqsGpbunx5FmEzHvrO3JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Goncalves <bgoncalv@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0863/1674] sched/deadline: Fix missing ENQUEUE_REPLENISH during PI de-boosting
Date: Sat, 17 Oct 2026 17:52:15 +0200
Message-ID: <20261017160453.267909470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/sched/core.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ed3fcf41bb0f4..91852abd66a0b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7536,6 +7536,35 @@ static void __setscheduler_params(struct task_struct *p,
 	set_load_weight(p, true);
 }
 
+#ifdef CONFIG_RT_MUTEXES
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+					struct task_struct *p,
+					int *queue_flags)
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
+			*queue_flags |= ENQUEUE_REPLENISH;
+		}
+	}
+}
+#else /* !CONFIG_RT_MUTEXES */
+static inline void __setscheduler_dl_pi(int newprio, int policy,
+					struct task_struct *p,
+					int *queue_flags)
+{
+}
+#endif /* !CONFIG_RT_MUTEXES */
+
 /*
  * Check the target process has a UID that matches the current process's:
  */
@@ -7804,6 +7833,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	if (!(attr->sched_flags & SCHED_FLAG_KEEP_PARAMS)) {
 		__setscheduler_params(p, attr);
 		__setscheduler_prio(p, newprio);
+		__setscheduler_dl_pi(newprio, policy, p, &queue_flags);
 	}
 	__setscheduler_uclamp(p, attr);
 
-- 
2.53.0



