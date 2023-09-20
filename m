Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5410F23752
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7575EC433C9;
	Wed, 20 Sep 2023 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210917;
	bh=fAvYvPccKgkK9/ajbQyTKPaM4r6F2CdZtqREvEgswjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZzGUmxutiYi/YXX6tYgkKE7xHoLl01N4tm+gxDBIgkZJPLzHmWwYc/Cbs0u7/zO+
	 tcQ8drd+mBqKI+RF6smuWwt4sEpiUuWPNqBS7HhPGx1QbgqDA07siRMO3aoftvzZq3
	 yVp0bTf1c1t9WTGD+UG0V+pXS9LYRHQTOb77SV6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hu Chunyu <chuhu@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Wander Lairson Costa <wander@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/139] kernel/fork: beware of __put_task_struct() calling context
Date: Wed, 20 Sep 2023 13:28:59 +0200
Message-ID: <20230920112835.775198983@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit d243b34459cea30cfe5f3a9b2feb44e7daff9938 ]

Under PREEMPT_RT, __put_task_struct() indirectly acquires sleeping
locks. Therefore, it can't be called from an non-preemptible context.

One practical example is splat inside inactive_task_timer(), which is
called in a interrupt context:

  CPU: 1 PID: 2848 Comm: life Kdump: loaded Tainted: G W ---------
   Hardware name: HP ProLiant DL388p Gen8, BIOS P70 07/15/2012
   Call Trace:
   dump_stack_lvl+0x57/0x7d
   mark_lock_irq.cold+0x33/0xba
   mark_lock+0x1e7/0x400
   mark_usage+0x11d/0x140
   __lock_acquire+0x30d/0x930
   lock_acquire.part.0+0x9c/0x210
   rt_spin_lock+0x27/0xe0
   refill_obj_stock+0x3d/0x3a0
   kmem_cache_free+0x357/0x560
   inactive_task_timer+0x1ad/0x340
   __run_hrtimer+0x8a/0x1a0
   __hrtimer_run_queues+0x91/0x130
   hrtimer_interrupt+0x10f/0x220
   __sysvec_apic_timer_interrupt+0x7b/0xd0
   sysvec_apic_timer_interrupt+0x4f/0xd0
   asm_sysvec_apic_timer_interrupt+0x12/0x20
   RIP: 0033:0x7fff196bf6f5

Instead of calling __put_task_struct() directly, we defer it using
call_rcu(). A more natural approach would use a workqueue, but since
in PREEMPT_RT, we can't allocate dynamic memory from atomic context,
the code would become more complex because we would need to put the
work_struct instance in the task_struct and initialize it when we
allocate a new task_struct.

The issue is reproducible with stress-ng:

  while true; do
      stress-ng --sched deadline --sched-period 1000000000 \
	      --sched-runtime 800000000 --sched-deadline \
	      1000000000 --mmapfork 23 -t 20
  done

Reported-by: Hu Chunyu <chuhu@redhat.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Valentin Schneider <vschneid@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230614122323.37957-2-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task.h | 28 +++++++++++++++++++++++++++-
 kernel/fork.c              |  8 ++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 357e0068497c1..7291fb6399d2a 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -112,10 +112,36 @@ static inline struct task_struct *get_task_struct(struct task_struct *t)
 }
 
 extern void __put_task_struct(struct task_struct *t);
+extern void __put_task_struct_rcu_cb(struct rcu_head *rhp);
 
 static inline void put_task_struct(struct task_struct *t)
 {
-	if (refcount_dec_and_test(&t->usage))
+	if (!refcount_dec_and_test(&t->usage))
+		return;
+
+	/*
+	 * under PREEMPT_RT, we can't call put_task_struct
+	 * in atomic context because it will indirectly
+	 * acquire sleeping locks.
+	 *
+	 * call_rcu() will schedule delayed_put_task_struct_rcu()
+	 * to be called in process context.
+	 *
+	 * __put_task_struct() is called when
+	 * refcount_dec_and_test(&t->usage) succeeds.
+	 *
+	 * This means that it can't "conflict" with
+	 * put_task_struct_rcu_user() which abuses ->rcu the same
+	 * way; rcu_users has a reference so task->usage can't be
+	 * zero after rcu_users 1 -> 0 transition.
+	 *
+	 * delayed_free_task() also uses ->rcu, but it is only called
+	 * when it fails to fork a process. Therefore, there is no
+	 * way it can conflict with put_task_struct().
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
+		call_rcu(&t->rcu, __put_task_struct_rcu_cb);
+	else
 		__put_task_struct(t);
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 41950ff90aa34..85617928041cf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -852,6 +852,14 @@ void __put_task_struct(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(__put_task_struct);
 
+void __put_task_struct_rcu_cb(struct rcu_head *rhp)
+{
+	struct task_struct *task = container_of(rhp, struct task_struct, rcu);
+
+	__put_task_struct(task);
+}
+EXPORT_SYMBOL_GPL(__put_task_struct_rcu_cb);
+
 void __init __weak arch_task_cache_init(void) { }
 
 /*
-- 
2.40.1



