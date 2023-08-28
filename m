Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD4511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F2DC433C8;
	Mon, 28 Aug 2023 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218059;
	bh=n3zhZi0UxC8uflUIW16Q8LNc/PjpVRhk+f3bHfJC5ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN21o7naSKsptrpDbVFW0gscXOGy/qYORxObWevAI0Cfq3AQ7hx0eHklFIADbrybv
	 A94Rz5/vdJIALcfxoJf7SFOIOTw1aE8JUf3JlebYLP6qhHpdZZMK7qs+uOwgYbh07z
	 F0Nl8X8A6lnYCHQU44axNUht2wEEBxwe6sd3wHIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Qais Yousef (Google)" <qyousef@layalina.io>,
	Juri Lelli <juri.lelli@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.4 081/129] sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
Date: Mon, 28 Aug 2023 12:12:40 +0200
Message-ID: <20230828101200.036838363@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

commit 6c24849f5515e4966d94fa5279bdff4acf2e9489 upstream.

Qais reported that iterating over all tasks when rebuilding root domains
for finding out which ones are DEADLINE and need their bandwidth
correctly restored on such root domains can be a costly operation (10+
ms delays on suspend-resume).

To fix the problem keep track of the number of DEADLINE tasks belonging
to each cpuset and then use this information (followup patch) to only
perform the above iteration if DEADLINE tasks are actually present in
the cpuset for which a corresponding root domain is being rebuilt.

Reported-by: Qais Yousef (Google) <qyousef@layalina.io>
Link: https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef@layalina.io/
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpuset.h  |    4 ++++
 kernel/cgroup/cgroup.c  |    4 ++++
 kernel/cgroup/cpuset.c  |   25 +++++++++++++++++++++++++
 kernel/sched/deadline.c |   14 ++++++++++++++
 4 files changed, 47 insertions(+)

--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -71,6 +71,8 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
+extern void inc_dl_tasks_cs(struct task_struct *task);
+extern void dec_dl_tasks_cs(struct task_struct *task);
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
@@ -189,6 +191,8 @@ static inline void cpuset_update_active_
 
 static inline void cpuset_wait_for_hotplug(void) { }
 
+static inline void inc_dl_tasks_cs(struct task_struct *task) { }
+static inline void dec_dl_tasks_cs(struct task_struct *task) { }
 static inline void cpuset_lock(void) { }
 static inline void cpuset_unlock(void) { }
 
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -57,6 +57,7 @@
 #include <linux/file.h>
 #include <linux/fs_parser.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/deadline.h>
 #include <linux/psi.h>
 #include <net/sock.h>
 
@@ -6696,6 +6697,9 @@ void cgroup_exit(struct task_struct *tsk
 	list_add_tail(&tsk->cg_list, &cset->dying_tasks);
 	cset->nr_tasks--;
 
+	if (dl_task(tsk))
+		dec_dl_tasks_cs(tsk);
+
 	WARN_ON_ONCE(cgroup_task_frozen(tsk));
 	if (unlikely(!(tsk->flags & PF_KTHREAD) &&
 		     test_bit(CGRP_FREEZE, &task_dfl_cgroup(tsk)->flags)))
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -193,6 +193,12 @@ struct cpuset {
 	int use_parent_ecpus;
 	int child_ecpus_count;
 
+	/*
+	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
+	 * know when to rebuild associated root domain bandwidth information.
+	 */
+	int nr_deadline_tasks;
+
 	/* Invalid partition error code, not lock protected */
 	enum prs_errcode prs_err;
 
@@ -245,6 +251,20 @@ static inline struct cpuset *parent_cs(s
 	return css_cs(cs->css.parent);
 }
 
+void inc_dl_tasks_cs(struct task_struct *p)
+{
+	struct cpuset *cs = task_cs(p);
+
+	cs->nr_deadline_tasks++;
+}
+
+void dec_dl_tasks_cs(struct task_struct *p)
+{
+	struct cpuset *cs = task_cs(p);
+
+	cs->nr_deadline_tasks--;
+}
+
 /* bits in struct cpuset flags field */
 typedef enum {
 	CS_ONLINE,
@@ -2499,6 +2519,11 @@ static int cpuset_can_attach(struct cgro
 		ret = security_task_setscheduler(task);
 		if (ret)
 			goto out_unlock;
+
+		if (dl_task(task)) {
+			cs->nr_deadline_tasks++;
+			cpuset_attach_old_cs->nr_deadline_tasks--;
+		}
 	}
 
 	/*
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -16,6 +16,8 @@
  *                    Fabio Checconi <fchecconi@gmail.com>
  */
 
+#include <linux/cpuset.h>
+
 /*
  * Default limits for DL period; on the top end we guard against small util
  * tasks still getting ridiculously long effective runtimes, on the bottom end we
@@ -2596,6 +2598,12 @@ static void switched_from_dl(struct rq *
 	if (task_on_rq_queued(p) && p->dl.dl_runtime)
 		task_non_contending(p);
 
+	/*
+	 * In case a task is setscheduled out from SCHED_DEADLINE we need to
+	 * keep track of that on its cpuset (for correct bandwidth tracking).
+	 */
+	dec_dl_tasks_cs(p);
+
 	if (!task_on_rq_queued(p)) {
 		/*
 		 * Inactive timer is armed. However, p is leaving DEADLINE and
@@ -2636,6 +2644,12 @@ static void switched_to_dl(struct rq *rq
 	if (hrtimer_try_to_cancel(&p->dl.inactive_timer) == 1)
 		put_task_struct(p);
 
+	/*
+	 * In case a task is setscheduled to SCHED_DEADLINE we need to keep
+	 * track of that on its cpuset (for correct bandwidth tracking).
+	 */
+	inc_dl_tasks_cs(p);
+
 	/* If p is not queued we will update its parameters at next wakeup. */
 	if (!task_on_rq_queued(p)) {
 		add_rq_bw(&p->dl, &rq->dl);


