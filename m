Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591285;
	b=HluSZhfoUWZhfCXGvBJLYmYzfU4Es4ss+MqgxT11hXF1P5ilO6SEQwWQhw0Qv3a/Vn/A
	 u2EPcDAtV5z23U1NLv0J1Zx1JIoJVW9h7+KgpVQT+W+WzwGGf0FVEBkYKNwY3zYe+F675
	 WNc7ghUUxKuohOqW3eWHNb5aQKGw8k7Oegu/5s+pcm8y3PCd8ioxm5knJqdJPJMIDGxXG
	 SHjWhqs2O3H9/0VO1dJi+6xDeRxSF7iwccmqO65fp18s9uKutRk3SMpSDiRe1ZURF40CA
	 MP+Wm8t420qMO9QJCfg529RCpmqNmkss0apvZ61TBgxe6TTLTQIalBQ1eWnrlj7bzvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KND6a4y7mWoO8I6LXo3R/8oYKXz9mMUv+mGMME6LenU=;
	b=x4tItbw4Uf6kHGnG6Sy7jen5Tox38SMPwq82DLvkgO3+8nBtWNez7DqDRTp6T2M8WzA3
	 SWgQzuew9pFH1exHWRW4f9UzLuc65M4Nni8O/OK89U1kJE6NLyEUyV1g0r073xYELL+p5
	 E90lKbtjJzvod04V44Egw6ZIkwY5k7i/0N4sJO/jB7897wjNkQfZZWMYxM6wcWdx6IZX3
	 9gnvxQAfwB/mDj37ry/K556uZ1QTcV2/OWSQVK53/VTYf/asLxRLPNmuKHfb7xnXSsd6A
	 GqnlBorljARHwlSe1QSVzybc6j+IQChxrigtNGmfUot4DQAWHKsx/s2CEeqaxvt8P8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgKPm61M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBB96077D4B;
	Fri, 13 Nov 2026 17:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NgKPm61M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4121F000C4;
	Fri, 13 Nov 2026 17:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591285;
	bh=KND6a4y7mWoO8I6LXo3R/8oYKXz9mMUv+mGMME6LenU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgKPm61MOD+kKdC4nsbBscXz0h3eRku5k1OhJ86/8MGFUZtJLdSFRWzMEz9nIekvn
	 A9PQYhI0vTec+nfvO42+CwUpj80Oa6LnpyjZ9J4pAi7DVILM4yDMV0119UvYl5222P
	 csXpenmJgx9bRnrs06+luAt9GDc4JIseoOu5Xmig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Blaszczyk <michalblk@google.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/670] sched_ext: Reset runnable_at when a task leaves its scheduler
Date: Fri, 13 Nov 2026 10:49:28 -0500
Message-ID: <20261113153825.444881850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ michalblk: applied to kernel/sched/ext.c, where the function is
  scx_ops_disable_task() and has no @sch; adjusted the comments and
  context accordingly ]
Signed-off-by: Michal Blaszczyk <michalblk@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index b18c3b4763b79..7a4b23e48cc6f 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2173,7 +2173,11 @@ static void ops_dequeue(struct task_struct *p, u64 deq_flags)
 {
 	unsigned long opss;
 
-	/* dequeue is always temporary, don't reset runnable_at */
+	/*
+	 * Don't reset runnable_at. If @p is waiting, the wait continues across
+	 * temporary dequeues, e.g. for a migration or an attribute change.
+	 * scx_ops_disable_task() ends it if @p leaves its scheduler.
+	 */
 	clr_task_runnable(p, false);
 
 	/* acquire ensures that we see the preceding updates on QUEUED */
@@ -3794,6 +3798,14 @@ static void scx_ops_disable_task(struct task_struct *p)
 	if (SCX_HAS_OP(disable))
 		SCX_CALL_OP_TASK(SCX_KF_REST, disable, p);
 	scx_set_task_state(p, SCX_TASK_READY);
+
+	/*
+	 * If @p is runnable but not running, its wait started at runnable_at,
+	 * which ops_dequeue() didn't reset. Leaving the BPF scheduler ends the
+	 * wait. Reset runnable_at the next time @p is enqueued on SCX, so that
+	 * the watchdog doesn't count the time @p spends elsewhere.
+	 */
+	p->scx.flags |= SCX_TASK_RESET_RUNNABLE_AT;
 }
 
 static void scx_ops_exit_task(struct task_struct *p)
-- 
2.53.0



