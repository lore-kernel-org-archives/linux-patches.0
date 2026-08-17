Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D0F3EC807;
	Mon, 17 Aug 2026 13:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973886; cv=none; b=FXiNgbbqVPQxh+kv/0AuilON/NiQqL5mU9iKCDZ/BOBACjAnUayuTVMtz00j35GYKGXSa/BEEKc4tSS9DzDqu6zKxAj5N44YVw0mrQuHwBz2FYE25Otfp3En5AeYKtlUANgXK2PDTLjfC700fZ3b2DgMOtjYa3QWXBuAbr/IoZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973886; c=relaxed/simple;
	bh=5VFXzqE+9XyJ0Z+NPJAq6bqdgP7VolW/jR6GYctA7e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wre8v8iuraJ8gKQt/FwqYDW8iEobeiBwfXlQTbomV30mdzMZ1quNMUOhIQPtjtwn75tEUgOM4CfJGDeDG6tCtPGyLaGxo0lcFctRxUB7dFGzSxT9yOe16VCda1mTlzEfnpcA0+cqDgGA1FOJltZAL1AsRJfw+HNpJuJZxKTyWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/CUhaf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/CUhaf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2EB1F00AC4;
	Mon, 17 Aug 2026 13:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973883;
	bh=DZvL9+ZQ8xuQe4jGWabrccU7kyJTQWjN74nLTSWrHrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/CUhaf52skaMYQBkoZEcd/HS3wAYd15tEz2XG0cJaSen22IhSPBjLwoiAR4uw5rZ
	 cRHAgRijh3JKy3enSoUJbvqZ4Lxe4hewbc979CG1ECbOniYPePaSMJw9z/pAyMjc+b
	 g6C42DkwFQxg8nRusvnG8UArCj3ec0995YqSCN1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 015/271] sched_ext: Dont enable non-ext tasks in the sub-sched task loops
Date: Mon, 17 Aug 2026 15:29:00 +0200
Message-ID: <20260817132537.401150740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 5cdc928598095b2c7d5f265e5f21eadd1634bfbe ]

Root enable and scx_post_fork() enable a task only if it's on the ext class.
Tasks on other classes, possible under an SCX_OPS_SWITCH_PARTIAL root, are
left READY and enabled by switching_to_scx() when they switch over. The sub
enable-commit pass and the sub-disable re-home loop enable unconditionally,
so a fair-class READY task in the subtree becomes ENABLED while not on
sched_ext. A later switch to SCHED_EXT then trips the task state validation
WARN (ENABLED with the previous state not READY) and calls ops.enable() a
second time.

Gate scx_enable_task() on the task's class in both loops.

Fixes: 337ec00b1d9c ("sched_ext: Implement cgroup sub-sched enabling and disabling")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index a8c4f665d173c..40df1be44a6d5 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5874,15 +5874,22 @@ static void scx_sub_disable(struct scx_sched *sch)
 			/*
 			 * $p is initialized for $parent and still attached to
 			 * @sch. Disable and exit for @sch, switch over to
-			 * $parent, override the state to READY to account for
-			 * $p having already been initialized, and then enable.
+			 * $parent and override the state to READY to account
+			 * for $p having already been initialized.
 			 */
 			scx_disable_and_exit_task(sch, p);
 			scx_set_task_state(p, SCX_TASK_INIT_BEGIN);
 			scx_set_task_state(p, SCX_TASK_INIT);
 			scx_set_task_sched(p, parent);
 			scx_set_task_state(p, SCX_TASK_READY);
-			scx_enable_task(parent, p);
+
+			/*
+			 * A task on a non-ext class, possible under an
+			 * %SCX_OPS_SWITCH_PARTIAL root, stays READY and is
+			 * enabled by switching_to_scx() if it switches over.
+			 */
+			if (p->sched_class == &ext_sched_class)
+				scx_enable_task(parent, p);
 		}
 
 		task_rq_unlock(rq, p, &rf);
@@ -7377,10 +7384,14 @@ static void scx_sub_enable_workfn(struct kthread_work *work)
 
 			/*
 			 * $p is now only initialized for @sch and READY, which
-			 * is what we want. Assign it to @sch and enable.
+			 * is what we want. Assign it to @sch and, if it's on
+			 * the ext class, enable. A non-ext task, possible under
+			 * an %SCX_OPS_SWITCH_PARTIAL root, stays READY and is
+			 * enabled by switching_to_scx() if it switches over.
 			 */
 			scx_set_task_sched(p, sch);
-			scx_enable_task(sch, p);
+			if (p->sched_class == &ext_sched_class)
+				scx_enable_task(sch, p);
 
 			p->scx.flags &= ~SCX_TASK_SUB_INIT;
 		}
-- 
2.53.0



