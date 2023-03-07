Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88898BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1804C433D2;
	Tue,  7 Mar 2023 18:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214990;
	bh=e/Pre2imnpWXGVk6zzLY2qTyBv+tmMkJDbggQiyPIfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+zB58my8QWDvVl224/KuilYX6l0K9FIsCG+29d3x5WEGk312e9AwjNenaz03DILU
	 c9hsjgYTGIzxQBUzbVqeeri528mLgqjDcOFQvD6zQFuoLUM+XOx+nqs5ZrSy1WXslj
	 +Cm02jkc5PmBgPqPb3szHfFXWYiODEr/HjngZOCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/567] rcu-tasks: Improve comments explaining tasks_rcu_exit_srcu purpose
Date: Tue,  7 Mar 2023 17:57:04 +0100
Message-Id: <20230307165909.700070962@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit e4e1e8089c5fd948da12cb9f4adc93821036945f ]

Make sure we don't need to look again into the depths of git blame in
order not to miss a subtle part about how rcu-tasks is dealing with
exiting tasks.

Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Suggested-by: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 28319d6dc5e2 ("rcu-tasks: Fix synchronize_rcu_tasks() VS zap_pid_ns_processes()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 4bd07cc3c0eab..d937bacf27b68 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -451,11 +451,21 @@ static void rcu_tasks_pertask(struct task_struct *t, struct list_head *hop)
 static void rcu_tasks_postscan(struct list_head *hop)
 {
 	/*
-	 * Wait for tasks that are in the process of exiting.  This
-	 * does only part of the job, ensuring that all tasks that were
-	 * previously exiting reach the point where they have disabled
-	 * preemption, allowing the later synchronize_rcu() to finish
-	 * the job.
+	 * Exiting tasks may escape the tasklist scan. Those are vulnerable
+	 * until their final schedule() with TASK_DEAD state. To cope with
+	 * this, divide the fragile exit path part in two intersecting
+	 * read side critical sections:
+	 *
+	 * 1) An _SRCU_ read side starting before calling exit_notify(),
+	 *    which may remove the task from the tasklist, and ending after
+	 *    the final preempt_disable() call in do_exit().
+	 *
+	 * 2) An _RCU_ read side starting with the final preempt_disable()
+	 *    call in do_exit() and ending with the final call to schedule()
+	 *    with TASK_DEAD state.
+	 *
+	 * This handles the part 1). And postgp will handle part 2) with a
+	 * call to synchronize_rcu().
 	 */
 	synchronize_srcu(&tasks_rcu_exit_srcu);
 }
@@ -522,7 +532,10 @@ static void rcu_tasks_postgp(struct rcu_tasks *rtp)
 	 *
 	 * In addition, this synchronize_rcu() waits for exiting tasks
 	 * to complete their final preempt_disable() region of execution,
-	 * cleaning up after the synchronize_srcu() above.
+	 * cleaning up after synchronize_srcu(&tasks_rcu_exit_srcu),
+	 * enforcing the whole region before tasklist removal until
+	 * the final schedule() with TASK_DEAD state to be an RCU TASKS
+	 * read side critical section.
 	 */
 	synchronize_rcu();
 }
@@ -612,7 +625,11 @@ void show_rcu_tasks_classic_gp_kthread(void)
 EXPORT_SYMBOL_GPL(show_rcu_tasks_classic_gp_kthread);
 #endif // !defined(CONFIG_TINY_RCU)
 
-/* Do the srcu_read_lock() for the above synchronize_srcu().  */
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
 void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 {
 	preempt_disable();
@@ -620,7 +637,11 @@ void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 	preempt_enable();
 }
 
-/* Do the srcu_read_unlock() for the above synchronize_srcu().  */
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
 void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
 {
 	struct task_struct *t = current;
-- 
2.39.2



