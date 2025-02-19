Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FCC1DDC11;
	Wed, 19 Feb 2025 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954007; cv=none; b=mbcpcg209/+I79WY51CH+YrZrRKA/fddTPt3k8OiFUE/d2x8q2/R59yMLCKWWjBYU7M3QqQZfoOhqF8woHsHeyTI2hx97rjWQWnGM+Es7qZyLcjkQQ3PnqWEwWd7vZcGpxCS1XLr4VSoxK3xtRW2Hi4koxoF1rpvFxk8kYflC1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954007; c=relaxed/simple;
	bh=ungeq9x7MCzVaCipC9TjlYiLD3RlDCN3VhgsXpdybNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbHz7P8RmU7/1735fY5NrobrHXTrL5QrlEVMeAcqVnE33bB+zJdiPWKq6cRWr0IZYwGxxSvol6OqJWQ4EPtQ2jN+CGC8x/JC55XKMOjmsWExkikGSlNr3/s4L8+OSOBKSReRbifBHhxApK+roYZqvfyKvVPETMTTsBvjSuCTxCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCC6Grb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCC6Grb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2562C4CEE6;
	Wed, 19 Feb 2025 08:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954007;
	bh=ungeq9x7MCzVaCipC9TjlYiLD3RlDCN3VhgsXpdybNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCC6Grb3Jmjw3YqNR8rQwLpUzofPqEdfJTDnED1xI7niv+cGA7oavC2xqp6eAxaq4
	 vkQNKZkZ97+31hpe0h5RYrqBqxDeqjb0GP+4uTIR/iXWjDtHZCeSdGTNtYJmAaeb1Y
	 Emb1ZRRasu3ctzyEPtjHhwPxiUHf11Q4dQpE4KNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/274] sched_ext: Use SCX_CALL_OP_TASK in task_tick_scx
Date: Wed, 19 Feb 2025 09:25:19 +0100
Message-ID: <20250219082612.166305633@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit f5717c93a1b999970f3a64d771a1a9ee68cc37d0 ]

Now when we use scx_bpf_task_cgroup() in ops.tick() to get the cgroup of
the current task, the following error will occur:

scx_foo[3795244] triggered exit kind 1024:
  runtime error (called on a task not being operated on)

The reason is that we are using SCX_CALL_OP() instead of SCX_CALL_OP_TASK()
when calling ops.tick(), which triggers the error during the subsequent
scx_kf_allowed_on_arg_tasks() check.

SCX_CALL_OP_TASK() was first introduced in commit 36454023f50b ("sched_ext:
Track tasks that are subjects of the in-flight SCX operation") to ensure
task's rq lock is held when accessing task's sched_group. Since ops.tick()
is marked as SCX_KF_TERMINAL and task_tick_scx() is protected by the rq
lock, we can use SCX_CALL_OP_TASK() to avoid the above issue. Similarly,
the same changes should be made for ops.disable() and ops.exit_task(), as
they are also protected by task_rq_lock() and it's safe to access the
task's task_group.

Fixes: 36454023f50b ("sched_ext: Track tasks that are subjects of the in-flight SCX operation")
Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 37dc02b89cb5b..f48a8bf7a71c6 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3855,7 +3855,7 @@ static void task_tick_scx(struct rq *rq, struct task_struct *curr, int queued)
 		curr->scx.slice = 0;
 		touch_core_sched(rq, curr);
 	} else if (SCX_HAS_OP(tick)) {
-		SCX_CALL_OP(SCX_KF_REST, tick, curr);
+		SCX_CALL_OP_TASK(SCX_KF_REST, tick, curr);
 	}
 
 	if (!curr->scx.slice)
@@ -4002,7 +4002,7 @@ static void scx_ops_disable_task(struct task_struct *p)
 	WARN_ON_ONCE(scx_get_task_state(p) != SCX_TASK_ENABLED);
 
 	if (SCX_HAS_OP(disable))
-		SCX_CALL_OP(SCX_KF_REST, disable, p);
+		SCX_CALL_OP_TASK(SCX_KF_REST, disable, p);
 	scx_set_task_state(p, SCX_TASK_READY);
 }
 
@@ -4031,7 +4031,7 @@ static void scx_ops_exit_task(struct task_struct *p)
 	}
 
 	if (SCX_HAS_OP(exit_task))
-		SCX_CALL_OP(SCX_KF_REST, exit_task, p, &args);
+		SCX_CALL_OP_TASK(SCX_KF_REST, exit_task, p, &args);
 	scx_set_task_state(p, SCX_TASK_NONE);
 }
 
-- 
2.39.5



