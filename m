Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060571FB3F0;
	Wed,  6 Nov 2024 12:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897616; cv=none; b=jCiM+rnT+B7kZN2grMWUMaL6ivouFD8XRxUJSdi4uhthftE6IwV9l529/LYSUpdghvDv3MnzY6v1J1w5I/va1XhFrHzyoIzgUisHtL6ITBd69tjWbdL51B7cxuwgmrlSqweKpfqk+a+MVT5UZfvnmgIijBoM0QB+VWsbhgGbNOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897616; c=relaxed/simple;
	bh=kNTV8q8dnHhnUmprChwULAo+Z/YC0XeDG2klDh5PmoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MywPtNgpzIbdqOdmsDcDgGGWNEWx1DlbFcgiK4PiJUf9EtFFYXzEEfuKNHl9LWw9axuny0vUYroH9tpBL7nANyDj/vAzxImOpwubf099yCNA7xY4IfMMzrCldXd45DryhH4rFNVMhngooETvq/5YJIm3LUvnR+zuWHQetzqOqA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TId8D0sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TId8D0sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D209C4CECD;
	Wed,  6 Nov 2024 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897615;
	bh=kNTV8q8dnHhnUmprChwULAo+Z/YC0XeDG2klDh5PmoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TId8D0sr7F7C3UJJlI+nxREIgsY051xK79XfYz4zZ3/0FOCLZXkt1MHRnvXgtuBZL
	 gAPtO9nmMI3cpZ7EqUo7t49zL2DePa3vGYzvt4TPW0ayYw6RZ/fbmQKXU6UO68dveh
	 U7cXZ40MPouOZ6UH9keCKzszhkk7mGmwHcRJyB4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/151] rcu-tasks: Add data to eliminate RCU-tasks/do_exit() deadlocks
Date: Wed,  6 Nov 2024 13:04:25 +0100
Message-ID: <20241106120310.971166110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit bfe93930ea1ea3c6c115a7d44af6e4fea609067e ]

Holding a mutex across synchronize_rcu_tasks() and acquiring
that same mutex in code called from do_exit() after its call to
exit_tasks_rcu_start() but before its call to exit_tasks_rcu_stop()
results in deadlock.  This is by design, because tasks that are far
enough into do_exit() are no longer present on the tasks list, making
it a bit difficult for RCU Tasks to find them, let alone wait on them
to do a voluntary context switch.  However, such deadlocks are becoming
more frequent.  In addition, lockdep currently does not detect such
deadlocks and they can be difficult to reproduce.

In addition, if a task voluntarily context switches during that time
(for example, if it blocks acquiring a mutex), then this task is in an
RCU Tasks quiescent state.  And with some adjustments, RCU Tasks could
just as well take advantage of that fact.

This commit therefore adds the data structures that will be needed
to rely on these quiescent states and to eliminate these deadlocks.

Link: https://lore.kernel.org/all/20240118021842.290665-1-chenzhongjin@huawei.com/

Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reported-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: fd70e9f1d85f ("rcu-tasks: Fix access non-existent percpu rtpcp variable in rcu_tasks_need_gpcb()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 2 ++
 kernel/rcu/tasks.h    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 77f01ac385f7a..3d83cc397eac1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -854,6 +854,8 @@ struct task_struct {
 	u8				rcu_tasks_idx;
 	int				rcu_tasks_idle_cpu;
 	struct list_head		rcu_tasks_holdout_list;
+	int				rcu_tasks_exit_cpu;
+	struct list_head		rcu_tasks_exit_list;
 #endif /* #ifdef CONFIG_TASKS_RCU */
 
 #ifdef CONFIG_TASKS_TRACE_RCU
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 90425d0ec09cf..7ac3c8af075fc 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -32,6 +32,7 @@ typedef void (*postgp_func_t)(struct rcu_tasks *rtp);
  * @rtp_irq_work: IRQ work queue for deferred wakeups.
  * @barrier_q_head: RCU callback for barrier operation.
  * @rtp_blkd_tasks: List of tasks blocked as readers.
+ * @rtp_exit_list: List of tasks in the latter portion of do_exit().
  * @cpu: CPU number corresponding to this entry.
  * @rtpp: Pointer to the rcu_tasks structure.
  */
@@ -46,6 +47,7 @@ struct rcu_tasks_percpu {
 	struct irq_work rtp_irq_work;
 	struct rcu_head barrier_q_head;
 	struct list_head rtp_blkd_tasks;
+	struct list_head rtp_exit_list;
 	int cpu;
 	struct rcu_tasks *rtpp;
 };
-- 
2.43.0



