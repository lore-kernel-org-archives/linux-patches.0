Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B679A3D3336;
	Mon, 17 Aug 2026 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974597; cv=none; b=N9pA/N0IOGnAA/sSoKWiwtKgtmlk98CJZ5sX/FT5o6e4KvXgy1ekVUm000SxC8tUVgZ54IWw3L/e6TDY+JkFqj+0zROzz1FR05gUTByeoetuH7xc2vcWcxEMlKm6FlQUYAjLLzbQH+AGF9xskjuAo3PWi0xIWnmu5du7H2+VSlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974597; c=relaxed/simple;
	bh=u4jGOa4n246xbPhr1fxX27Iwo5ObmteSxVMcY5eV75c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7/y0aRFaI33RIUAQxwI7vftQCFoarhnUHbr348jjFBo+GIOPsJYNJ/sP0DJCuOyc+M4yvD0ItiFyJuw5cxOvQ6rPjgglyELWDPgs3c2wjFpO0p4fh3pixSJB/gvmCTFautOzUTrMSPMaPvpUvTj4ZNbgltT14T4JmvdHa5lpfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+oG4GGb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+oG4GGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D39A1F000E9;
	Mon, 17 Aug 2026 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974591;
	bh=ox93+peBt194ct3jnl6k3hQQLNwYML/lzoZ8yqPLGCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+oG4GGbvZK4RD4cXNyYM7v8B8z8VnSWvE6ZEh44i3AJUV8KcEYk7Nfc3AR/O1TzP
	 syjAp92MUpK15m+p+/oGlbCftgQHrpbAAFoeBQVYS+NGf8MO8o0b5Q67cf60IhGiSw
	 yrcOh14tbIC+5R53tdTWUMpooLT+fFKrC7n3Sivg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 7.1 259/271] sched/psi: Create the psimon kthread outside of cgroup_mutex
Date: Mon, 17 Aug 2026 15:33:04 +0200
Message-ID: <20260817132547.388838692@linuxfoundation.org>
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

commit fadeedd7cfc5d73d33fa3d7ac54b9b27aabd09d2 upstream.

a5b98009f16d ("sched/psi: fix race between file release and pressure write")
made pressure_write() hold cgroup_mutex across psi_trigger_create(), which
forks the psimon kthread for the first rtpoll trigger. As kthread creation
depends on the whole fork path, the commit inadvertently created a lot of
unwanted locking dependencies from cgroup_mutex.

sched_ext got hit by one: its enable path blocks forks and then grabs
cgroup_mutex, so a pressure write racing a scheduler enable deadlocks, with
every other fork piling up behind.

Fix it by splitting trigger creation so that the worker is forked with
cgroup_mutex dropped and the kernfs active reference left broken. The latter
matters because rmdir and cgroup.pressure writes drain active references
under cgroup_mutex. Publishing the trigger last keeps error reporting
synchronous and preserves the of->priv lifetime rules.

The trigger registered in the first stage pins the group's rtpoll machinery
across the unlocked window, leaving only creation races to resolve. The
catch-up poll on installation covers scheduling attempts dropped while there
was no worker.

v2: Retagged sched/psi (was cgroup).

Fixes: a5b98009f16d ("sched/psi: fix race between file release and pressure write")
Cc: stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/all/20260710100441.2653477-1-matt@readmodwrite.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Matt Fleming <mfleming@cloudflare.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/psi.h    |    4 ++
 kernel/cgroup/cgroup.c |   23 +++++++++++++++-
 kernel/sched/psi.c     |   69 +++++++++++++++++++++++++++++++++++++------------
 3 files changed, 78 insertions(+), 18 deletions(-)

--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -25,7 +25,9 @@ void psi_memstall_leave(unsigned long *f
 int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of);
+				       struct kernfs_open_file *of,
+				       bool *need_rtpoll_worker);
+int psi_trigger_create_rtpoll_worker(struct psi_group *group);
 void psi_trigger_destroy(struct psi_trigger *t);
 
 __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3961,6 +3961,7 @@ static ssize_t pressure_write(struct ker
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
 	struct psi_group *psi;
+	bool need_rtpoll_worker;
 	ssize_t ret = 0;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
@@ -3980,12 +3981,32 @@ static ssize_t pressure_write(struct ker
 	}
 
 	psi = cgroup_psi(cgrp);
-	new = psi_trigger_create(psi, buf, res, of->file, of);
+	new = psi_trigger_create(psi, buf, res, of->file, of,
+				 &need_rtpoll_worker);
 	if (IS_ERR(new)) {
 		ret = PTR_ERR(new);
 		goto out_unlock;
 	}
 
+	/*
+	 * The worker fork must run with neither cgroup_mutex nor the file's
+	 * kernfs active reference held. The latter is broken since
+	 * cgroup_kn_lock_live(). @of->priv may be released while unlocked, so
+	 * recheck before publishing @new.
+	 */
+	if (need_rtpoll_worker) {
+		cgroup_unlock();
+		ret = psi_trigger_create_rtpoll_worker(psi);
+		cgroup_lock();
+
+		if (!ret && !of->priv)
+			ret = -ENODEV;
+		if (ret) {
+			psi_trigger_destroy(new);
+			goto out_unlock;
+		}
+	}
+
 	smp_store_release(&ctx->psi.trigger, new);
 
 out_unlock:
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1298,9 +1298,44 @@ int psi_show(struct seq_file *m, struct
 	return 0;
 }
 
+/*
+ * Create @group's rtpoll worker after psi_trigger_create() reported the need
+ * for one. kthread creation depends on the whole fork path and we don't want
+ * all of that nested inside cgroup_mutex, so the caller must drop it and any
+ * other lock that forks can wait behind. If two callers race, the loser stops
+ * its never-woken kthread.
+ */
+int psi_trigger_create_rtpoll_worker(struct psi_group *group)
+{
+	struct task_struct *task;
+
+	task = kthread_create(psi_rtpoll_worker, group, "psimon");
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	scoped_guard(mutex, &group->rtpoll_trigger_lock) {
+		if (!rcu_access_pointer(group->rtpoll_task)) {
+			atomic_set(&group->rtpoll_wakeup, 0);
+			wake_up_process(task);
+			rcu_assign_pointer(group->rtpoll_task, task);
+
+			/*
+			 * Poll once to catch up on scheduling attempts dropped
+			 * while there was no rtpoll worker.
+			 */
+			psi_schedule_rtpoll_work(group, 1, true);
+			return 0;
+		}
+	}
+
+	kthread_stop(task);
+	return 0;
+}
+
 struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
 				       enum psi_res res, struct file *file,
-				       struct kernfs_open_file *of)
+				       struct kernfs_open_file *of,
+				       bool *need_rtpoll_worker)
 {
 	struct psi_trigger *t;
 	enum psi_states state;
@@ -1308,6 +1343,8 @@ struct psi_trigger *psi_trigger_create(s
 	bool privileged;
 	u32 window_us;
 
+	*need_rtpoll_worker = false;
+
 	if (static_branch_likely(&psi_disabled))
 		return ERR_PTR(-EOPNOTSUPP);
 
@@ -1368,26 +1405,14 @@ struct psi_trigger *psi_trigger_create(s
 	if (privileged) {
 		mutex_lock(&group->rtpoll_trigger_lock);
 
-		if (!rcu_access_pointer(group->rtpoll_task)) {
-			struct task_struct *task;
-
-			task = kthread_create(psi_rtpoll_worker, group, "psimon");
-			if (IS_ERR(task)) {
-				kfree(t);
-				mutex_unlock(&group->rtpoll_trigger_lock);
-				return ERR_CAST(task);
-			}
-			atomic_set(&group->rtpoll_wakeup, 0);
-			wake_up_process(task);
-			rcu_assign_pointer(group->rtpoll_task, task);
-		}
-
 		list_add(&t->node, &group->rtpoll_triggers);
 		group->rtpoll_min_period = min(group->rtpoll_min_period,
 			div_u64(t->win.size, UPDATES_PER_WINDOW));
 		group->rtpoll_nr_triggers[t->state]++;
 		group->rtpoll_states |= (1 << t->state);
 
+		*need_rtpoll_worker = !rcu_access_pointer(group->rtpoll_task);
+
 		mutex_unlock(&group->rtpoll_trigger_lock);
 	} else {
 		mutex_lock(&group->avgs_lock);
@@ -1547,6 +1572,8 @@ static ssize_t psi_write(struct file *fi
 	size_t buf_size;
 	struct seq_file *seq;
 	struct psi_trigger *new;
+	bool need_rtpoll_worker;
+	int ret;
 
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
@@ -1571,12 +1598,22 @@ static ssize_t psi_write(struct file *fi
 		return -EBUSY;
 	}
 
-	new = psi_trigger_create(&psi_system, buf, res, file, NULL);
+	new = psi_trigger_create(&psi_system, buf, res, file, NULL,
+				 &need_rtpoll_worker);
 	if (IS_ERR(new)) {
 		mutex_unlock(&seq->lock);
 		return PTR_ERR(new);
 	}
 
+	if (need_rtpoll_worker) {
+		ret = psi_trigger_create_rtpoll_worker(&psi_system);
+		if (ret) {
+			psi_trigger_destroy(new);
+			mutex_unlock(&seq->lock);
+			return ret;
+		}
+	}
+
 	smp_store_release(&seq->private, new);
 	mutex_unlock(&seq->lock);
 


