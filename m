Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427A715887F;
	Tue,  9 Jul 2024 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524140; cv=none; b=TA9kiKW2Ku9DoPhyp3DFt7YzejYRGqKLPmLQc+iErrVyn9fc1s86KtA1nrd73zpUC9vgALLL4Gel5TBddDg92OtuyR1oBwCElda6VTG385juk8mxt6rCv9SNxoJda3ZVLD5UQ1lWHBAgMQYR75gHhnUfaM/HCC88z39hfCDghMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524140; c=relaxed/simple;
	bh=pqKzPmVaHPACEY9Ft1kttSLf6FlLM32yMjffFPglmiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bez0Z+LB0eomwYSGevXrH/zKAedD+iE2lTgMmum+j/le7GZwXOXyVIyxRS86YQX5hrO3TUlPglD9xXlU7Qcpjyxd0gVOSXN5+OTj+AcXtDqU0e5ZXJYfSgcQBDv4soW34fujlQePQifqV/nsVDoptrtikFX5hWIVES9xP3AWpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtFg9cg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtFg9cg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97A8C3277B;
	Tue,  9 Jul 2024 11:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524140;
	bh=pqKzPmVaHPACEY9Ft1kttSLf6FlLM32yMjffFPglmiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtFg9cg3ldyug3CQjQIxMvvFIO5gRZnEePKQ1r1bDseIxliIsTPgsvuZDyTCMDwKN
	 GZzDyqTX3Sv6KdmC2k00ts5qLkF9CrlQjTSUs6Vd+/UeBdq2rJXRbaNIxxes+XH65c
	 +5Fq1ideG7+tNzmns/pLuoRqv5lLuBw19MPQjAcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com
Subject: [PATCH 6.9 083/197] vhost_task: Handle SIGKILL by flushing work and exiting
Date: Tue,  9 Jul 2024 13:08:57 +0200
Message-ID: <20240709110712.179597685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit db5247d9bf5c6ade9fd70b4e4897441e0269b233 ]

Instead of lingering until the device is closed, this has us handle
SIGKILL by:

1. marking the worker as killed so we no longer try to use it with
   new virtqueues and new flush operations.
2. setting the virtqueue to worker mapping so no new works are queued.
3. running all the exiting works.

Suggested-by: Edward Adam Davis <eadavis@qq.com>
Reported-and-tested-by: syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com
Message-Id: <tencent_546DA49414E876EEBECF2C78D26D242EE50A@qq.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20240316004707.45557-9-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c            | 54 +++++++++++++++++++++++++++++---
 drivers/vhost/vhost.h            |  2 ++
 include/linux/sched/vhost_task.h |  3 +-
 kernel/vhost_task.c              | 53 ++++++++++++++++++++-----------
 4 files changed, 88 insertions(+), 24 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5580b24934015..1740a5f1f35e7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -285,7 +285,7 @@ static void __vhost_worker_flush(struct vhost_worker *worker)
 {
 	struct vhost_flush_struct flush;
 
-	if (!worker->attachment_cnt)
+	if (!worker->attachment_cnt || worker->killed)
 		return;
 
 	init_completion(&flush.wait_event);
@@ -400,7 +400,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	__vhost_vq_meta_reset(vq);
 }
 
-static bool vhost_worker(void *data)
+static bool vhost_run_work_list(void *data)
 {
 	struct vhost_worker *worker = data;
 	struct vhost_work *work, *work_next;
@@ -425,6 +425,40 @@ static bool vhost_worker(void *data)
 	return !!node;
 }
 
+static void vhost_worker_killed(void *data)
+{
+	struct vhost_worker *worker = data;
+	struct vhost_dev *dev = worker->dev;
+	struct vhost_virtqueue *vq;
+	int i, attach_cnt = 0;
+
+	mutex_lock(&worker->mutex);
+	worker->killed = true;
+
+	for (i = 0; i < dev->nvqs; i++) {
+		vq = dev->vqs[i];
+
+		mutex_lock(&vq->mutex);
+		if (worker ==
+		    rcu_dereference_check(vq->worker,
+					  lockdep_is_held(&vq->mutex))) {
+			rcu_assign_pointer(vq->worker, NULL);
+			attach_cnt++;
+		}
+		mutex_unlock(&vq->mutex);
+	}
+
+	worker->attachment_cnt -= attach_cnt;
+	if (attach_cnt)
+		synchronize_rcu();
+	/*
+	 * Finish vhost_worker_flush calls and any other works that snuck in
+	 * before the synchronize_rcu.
+	 */
+	vhost_run_work_list(worker);
+	mutex_unlock(&worker->mutex);
+}
+
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
 	kfree(vq->indirect);
@@ -639,9 +673,11 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 	if (!worker)
 		return NULL;
 
+	worker->dev = dev;
 	snprintf(name, sizeof(name), "vhost-%d", current->pid);
 
-	vtsk = vhost_task_create(vhost_worker, worker, name);
+	vtsk = vhost_task_create(vhost_run_work_list, vhost_worker_killed,
+				 worker, name);
 	if (!vtsk)
 		goto free_worker;
 
@@ -673,6 +709,11 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	struct vhost_worker *old_worker;
 
 	mutex_lock(&worker->mutex);
+	if (worker->killed) {
+		mutex_unlock(&worker->mutex);
+		return;
+	}
+
 	mutex_lock(&vq->mutex);
 
 	old_worker = rcu_dereference_check(vq->worker,
@@ -693,6 +734,11 @@ static void __vhost_vq_attach_worker(struct vhost_virtqueue *vq,
 	 * device wide flushes which doesn't use RCU for execution.
 	 */
 	mutex_lock(&old_worker->mutex);
+	if (old_worker->killed) {
+		mutex_unlock(&old_worker->mutex);
+		return;
+	}
+
 	/*
 	 * We don't want to call synchronize_rcu for every vq during setup
 	 * because it will slow down VM startup. If we haven't done
@@ -770,7 +816,7 @@ static int vhost_free_worker(struct vhost_dev *dev,
 		return -ENODEV;
 
 	mutex_lock(&worker->mutex);
-	if (worker->attachment_cnt) {
+	if (worker->attachment_cnt || worker->killed) {
 		mutex_unlock(&worker->mutex);
 		return -EBUSY;
 	}
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 9e942fcda5c3f..dc94e6a7d3c22 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -28,12 +28,14 @@ struct vhost_work {
 
 struct vhost_worker {
 	struct vhost_task	*vtsk;
+	struct vhost_dev	*dev;
 	/* Used to serialize device wide flushing with worker swapping. */
 	struct mutex		mutex;
 	struct llist_head	work_list;
 	u64			kcov_handle;
 	u32			id;
 	int			attachment_cnt;
+	bool			killed;
 };
 
 /* Poll a file (eventfd or socket) */
diff --git a/include/linux/sched/vhost_task.h b/include/linux/sched/vhost_task.h
index bc60243d43b36..25446c5d35081 100644
--- a/include/linux/sched/vhost_task.h
+++ b/include/linux/sched/vhost_task.h
@@ -4,7 +4,8 @@
 
 struct vhost_task;
 
-struct vhost_task *vhost_task_create(bool (*fn)(void *), void *arg,
+struct vhost_task *vhost_task_create(bool (*fn)(void *),
+				     void (*handle_kill)(void *), void *arg,
 				     const char *name);
 void vhost_task_start(struct vhost_task *vtsk);
 void vhost_task_stop(struct vhost_task *vtsk);
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index da35e5b7f0473..8800f5acc0071 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -10,38 +10,32 @@
 
 enum vhost_task_flags {
 	VHOST_TASK_FLAGS_STOP,
+	VHOST_TASK_FLAGS_KILLED,
 };
 
 struct vhost_task {
 	bool (*fn)(void *data);
+	void (*handle_sigkill)(void *data);
 	void *data;
 	struct completion exited;
 	unsigned long flags;
 	struct task_struct *task;
+	/* serialize SIGKILL and vhost_task_stop calls */
+	struct mutex exit_mutex;
 };
 
 static int vhost_task_fn(void *data)
 {
 	struct vhost_task *vtsk = data;
-	bool dead = false;
 
 	for (;;) {
 		bool did_work;
 
-		if (!dead && signal_pending(current)) {
+		if (signal_pending(current)) {
 			struct ksignal ksig;
-			/*
-			 * Calling get_signal will block in SIGSTOP,
-			 * or clear fatal_signal_pending, but remember
-			 * what was set.
-			 *
-			 * This thread won't actually exit until all
-			 * of the file descriptors are closed, and
-			 * the release function is called.
-			 */
-			dead = get_signal(&ksig);
-			if (dead)
-				clear_thread_flag(TIF_SIGPENDING);
+
+			if (get_signal(&ksig))
+				break;
 		}
 
 		/* mb paired w/ vhost_task_stop */
@@ -57,7 +51,19 @@ static int vhost_task_fn(void *data)
 			schedule();
 	}
 
+	mutex_lock(&vtsk->exit_mutex);
+	/*
+	 * If a vhost_task_stop and SIGKILL race, we can ignore the SIGKILL.
+	 * When the vhost layer has called vhost_task_stop it's already stopped
+	 * new work and flushed.
+	 */
+	if (!test_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags)) {
+		set_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags);
+		vtsk->handle_sigkill(vtsk->data);
+	}
+	mutex_unlock(&vtsk->exit_mutex);
 	complete(&vtsk->exited);
+
 	do_exit(0);
 }
 
@@ -78,12 +84,17 @@ EXPORT_SYMBOL_GPL(vhost_task_wake);
  * @vtsk: vhost_task to stop
  *
  * vhost_task_fn ensures the worker thread exits after
- * VHOST_TASK_FLAGS_SOP becomes true.
+ * VHOST_TASK_FLAGS_STOP becomes true.
  */
 void vhost_task_stop(struct vhost_task *vtsk)
 {
-	set_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags);
-	vhost_task_wake(vtsk);
+	mutex_lock(&vtsk->exit_mutex);
+	if (!test_bit(VHOST_TASK_FLAGS_KILLED, &vtsk->flags)) {
+		set_bit(VHOST_TASK_FLAGS_STOP, &vtsk->flags);
+		vhost_task_wake(vtsk);
+	}
+	mutex_unlock(&vtsk->exit_mutex);
+
 	/*
 	 * Make sure vhost_task_fn is no longer accessing the vhost_task before
 	 * freeing it below.
@@ -96,14 +107,16 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
 /**
  * vhost_task_create - create a copy of a task to be used by the kernel
  * @fn: vhost worker function
- * @arg: data to be passed to fn
+ * @handle_sigkill: vhost function to handle when we are killed
+ * @arg: data to be passed to fn and handled_kill
  * @name: the thread's name
  *
  * This returns a specialized task for use by the vhost layer or NULL on
  * failure. The returned task is inactive, and the caller must fire it up
  * through vhost_task_start().
  */
-struct vhost_task *vhost_task_create(bool (*fn)(void *), void *arg,
+struct vhost_task *vhost_task_create(bool (*fn)(void *),
+				     void (*handle_sigkill)(void *), void *arg,
 				     const char *name)
 {
 	struct kernel_clone_args args = {
@@ -122,8 +135,10 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *), void *arg,
 	if (!vtsk)
 		return NULL;
 	init_completion(&vtsk->exited);
+	mutex_init(&vtsk->exit_mutex);
 	vtsk->data = arg;
 	vtsk->fn = fn;
+	vtsk->handle_sigkill = handle_sigkill;
 
 	args.fn_arg = vtsk;
 
-- 
2.43.0



