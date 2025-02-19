Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDBF1EEA2A;
	Wed, 19 Feb 2025 08:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954849; cv=none; b=VNbfx8c+TDn0t3TYD5B8dWjHiopFJXOyeY2nM8PBWg9aRu35F7YTZ7//oWfUPtLVHeSbnCENye+RNDwsjNwMLyG4hW8P6n2CpiBHkhEZSUwQlQTSyXAq9r2UDAs8+GQHI2i2Zsf9Ui3h+QvKC0nmzfCxlZQJk/E7MlYXLIQvrHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954849; c=relaxed/simple;
	bh=oJsJ6U5FU3Qlzqhoh6f9NCbIGrvhfyJ08EL+NWLF5Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ2DYN4WL3fm3jPQCAHc5kkP+Xoy+pHuzWyCOtP2r0CyZvy+zfwto7NBxdw5v6vZkB2wJKfAxFJsHa7O/AU8gKgPE75pp0ZkPi0y4zNpYHP+vz8HB+20LmomdtsJg9jm6XKd1gN1FbQuCB2m68xl5aAjDzJfpKQWNsGnnR7Lj+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHO1kJao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHO1kJao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B254DC4CEE6;
	Wed, 19 Feb 2025 08:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954849;
	bh=oJsJ6U5FU3Qlzqhoh6f9NCbIGrvhfyJ08EL+NWLF5Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHO1kJaohLdqval8Kk6kAe56EbpVOuomglrWEJXm33ZfXca6zSNVjWVlh/CgxCyC6
	 36RIDearLBV8nmI4i8aFkEWSbRCAfixdD3KEaVsgGEWjMcEKh+eNGfptsmwVhKwaXf
	 zLsBD40Xdo0taZekcKcwXmaV7EjO2BJimfW/cLLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/230] sched_ext: Use SCX_CALL_OP_TASK in task_tick_scx
Date: Wed, 19 Feb 2025 09:26:11 +0100
Message-ID: <20250219082603.827357661@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 45e7461fd4c94..b88fa640325e5 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3447,7 +3447,7 @@ static void task_tick_scx(struct rq *rq, struct task_struct *curr, int queued)
 		curr->scx.slice = 0;
 		touch_core_sched(rq, curr);
 	} else if (SCX_HAS_OP(tick)) {
-		SCX_CALL_OP(SCX_KF_REST, tick, curr);
+		SCX_CALL_OP_TASK(SCX_KF_REST, tick, curr);
 	}
 
 	if (!curr->scx.slice)
@@ -3594,7 +3594,7 @@ static void scx_ops_disable_task(struct task_struct *p)
 	WARN_ON_ONCE(scx_get_task_state(p) != SCX_TASK_ENABLED);
 
 	if (SCX_HAS_OP(disable))
-		SCX_CALL_OP(SCX_KF_REST, disable, p);
+		SCX_CALL_OP_TASK(SCX_KF_REST, disable, p);
 	scx_set_task_state(p, SCX_TASK_READY);
 }
 
@@ -3623,7 +3623,7 @@ static void scx_ops_exit_task(struct task_struct *p)
 	}
 
 	if (SCX_HAS_OP(exit_task))
-		SCX_CALL_OP(SCX_KF_REST, exit_task, p, &args);
+		SCX_CALL_OP_TASK(SCX_KF_REST, exit_task, p, &args);
 	scx_set_task_state(p, SCX_TASK_NONE);
 }
 
-- 
2.39.5



