Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B7B393DCF;
	Wed, 17 Sep 2025 12:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113702; cv=none; b=rW11cds5p1XaZLV2ZrZNYwObMTF2Yc9suNS7JKcFKJxdKl5r8pMn101YGBvxHuqh7v1L4YoNL/RhzEY3+Suvuls3PhVWeXokw7qF4j+58INrwCiu3oX+speemQwAqAYB4FuUCEztHJRyc0RVpV18EWrsM07SsQNtnKX9S0K/8a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113702; c=relaxed/simple;
	bh=uULbrCLYaeZ0WX6ar1719C0fJAAQyY/193keGBzx+aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr7+X4zfYsHq6ti4vSti29VWSzvVSYQUTWjCrv7uGvtM3VeNOuCAZzRnLdV/EZQ4M0gs31P/vQ7XALXHTDNKfbzrLo3LqIFZp+bKXnreHdoOofiXtO4TRWqG2tTo6LsEprXijyvGFwnrqfGe/ExfRrJDqKrdafCfCB2o6rnyHk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqn2ftc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqn2ftc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6266DC4CEF0;
	Wed, 17 Sep 2025 12:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113701;
	bh=uULbrCLYaeZ0WX6ar1719C0fJAAQyY/193keGBzx+aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqn2ftc7twBiNvU7ZAF7aKeIARmG26tHkRJAEIrqFEsPSuI91ctj4z9t3YMIkDQJn
	 fIsQG0LQ8r80sfMfJ51dvKBikMhXikSnTGFuys7e6zDqorWmOvzSoitGSirR3ivT+P
	 vEWC4+5RrKhR2hxXCnrPwyot0+cabX5+fK1IcBS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Tahera Fahimi <taherafahimi@linux.microsoft.com>
Subject: [PATCH 6.6 027/101] rcu-tasks: Maintain lists to eliminate RCU-tasks/do_exit() deadlocks
Date: Wed, 17 Sep 2025 14:34:10 +0200
Message-ID: <20250917123337.512507812@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit 6b70399f9ef3809f6e308fd99dd78b072c1bd05c upstream.

This commit continues the elimination of deadlocks involving do_exit()
and RCU tasks by causing exit_tasks_rcu_start() to add the current
task to a per-CPU list and causing exit_tasks_rcu_stop() to remove the
current task from whatever list it is on.  These lists will be used to
track tasks that are exiting, while still accounting for any RCU-tasks
quiescent states that these tasks pass though.

[ paulmck: Apply Frederic Weisbecker feedback. ]

Link: https://lore.kernel.org/all/20240118021842.290665-1-chenzhongjin@huawei.com/

Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reported-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Yang Jihong <yangjihong1@huawei.com>
Tested-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Cc: Tahera Fahimi <taherafahimi@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -1175,25 +1175,48 @@ struct task_struct *get_rcu_tasks_gp_kth
 EXPORT_SYMBOL_GPL(get_rcu_tasks_gp_kthread);
 
 /*
- * Contribute to protect against tasklist scan blind spot while the
- * task is exiting and may be removed from the tasklist. See
- * corresponding synchronize_srcu() for further details.
+ * Protect against tasklist scan blind spot while the task is exiting and
+ * may be removed from the tasklist.  Do this by adding the task to yet
+ * another list.
+ *
+ * Note that the task will remove itself from this list, so there is no
+ * need for get_task_struct(), except in the case where rcu_tasks_pertask()
+ * adds it to the holdout list, in which case rcu_tasks_pertask() supplies
+ * the needed get_task_struct().
  */
-void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
+void exit_tasks_rcu_start(void)
 {
-	current->rcu_tasks_idx = __srcu_read_lock(&tasks_rcu_exit_srcu);
+	unsigned long flags;
+	struct rcu_tasks_percpu *rtpcp;
+	struct task_struct *t = current;
+
+	WARN_ON_ONCE(!list_empty(&t->rcu_tasks_exit_list));
+	preempt_disable();
+	rtpcp = this_cpu_ptr(rcu_tasks.rtpcpu);
+	t->rcu_tasks_exit_cpu = smp_processor_id();
+	raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
+	if (!rtpcp->rtp_exit_list.next)
+		INIT_LIST_HEAD(&rtpcp->rtp_exit_list);
+	list_add(&t->rcu_tasks_exit_list, &rtpcp->rtp_exit_list);
+	raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
+	preempt_enable();
 }
 
 /*
- * Contribute to protect against tasklist scan blind spot while the
- * task is exiting and may be removed from the tasklist. See
- * corresponding synchronize_srcu() for further details.
+ * Remove the task from the "yet another list" because do_exit() is now
+ * non-preemptible, allowing synchronize_rcu() to wait beyond this point.
  */
-void exit_tasks_rcu_stop(void) __releases(&tasks_rcu_exit_srcu)
+void exit_tasks_rcu_stop(void)
 {
+	unsigned long flags;
+	struct rcu_tasks_percpu *rtpcp;
 	struct task_struct *t = current;
 
-	__srcu_read_unlock(&tasks_rcu_exit_srcu, t->rcu_tasks_idx);
+	WARN_ON_ONCE(list_empty(&t->rcu_tasks_exit_list));
+	rtpcp = per_cpu_ptr(rcu_tasks.rtpcpu, t->rcu_tasks_exit_cpu);
+	raw_spin_lock_irqsave_rcu_node(rtpcp, flags);
+	list_del_init(&t->rcu_tasks_exit_list);
+	raw_spin_unlock_irqrestore_rcu_node(rtpcp, flags);
 }
 
 /*


