Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840C017A2E8;
	Mon, 10 Mar 2025 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629690; cv=none; b=nF1nSDoZXx+j0GeX2eqEzvCjxfFiD+TUIRkgdH7aGYNSCj3V2KvLROzzbmOi2FBTc5QIoHe8LT1Nbf7AO3JU614KChmj/n11F8oW7t/JvfE7VYZT416RMyaRn7LWQk3afrzDf4UmCBWVcBU81UJ/Za9uG3mcOpx/UZDnZ2nbqXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629690; c=relaxed/simple;
	bh=uzMkZrCKJ0jdDLPkq9PKM1e5diS/uK1oym2Ebg3wEvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2sqmcEoWZCQoLOpZXQb4IuKmVCFeEX+xxeAlWGSYJvQRksLST2fyJUMCauCpTYB3jPXiYtycDjlTFLMh34Sglf/+vDNBUtRODllRRCDUiCSc6OIiab95LcUBtvSogLmHWMBYn0GpkHzSG9g9DCpwdO3KqThqha9Zm9GkcBmo/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lp4C+W8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lp4C+W8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A200BC4CEE5;
	Mon, 10 Mar 2025 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629690;
	bh=uzMkZrCKJ0jdDLPkq9PKM1e5diS/uK1oym2Ebg3wEvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lp4C+W8b7/WwyyzADnXp6kGqhPlSiz0O2CuZO8tgfFYjn5kX2TAPhAG9mZpWhUm+W
	 yH/rWSciTKYGxf1AmMdGazlI0kqokGuAyJsdfbqwQJkbE8RKFsiUJpCpYiUgptUxHP
	 eZHFYNwMSLlZykcF9D/jsBG6onXQVh4ws5MRnSUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 5.15 380/620] cgroup: fix race between fork and cgroup.kill
Date: Mon, 10 Mar 2025 18:03:46 +0100
Message-ID: <20250310170600.593265455@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

commit b69bb476dee99d564d65d418e9a20acca6f32c3f upstream.

Tejun reported the following race between fork() and cgroup.kill at [1].

Tejun:
  I was looking at cgroup.kill implementation and wondering whether there
  could be a race window. So, __cgroup_kill() does the following:

   k1. Set CGRP_KILL.
   k2. Iterate tasks and deliver SIGKILL.
   k3. Clear CGRP_KILL.

  The copy_process() does the following:

   c1. Copy a bunch of stuff.
   c2. Grab siglock.
   c3. Check fatal_signal_pending().
   c4. Commit to forking.
   c5. Release siglock.
   c6. Call cgroup_post_fork() which puts the task on the css_set and tests
       CGRP_KILL.

  The intention seems to be that either a forking task gets SIGKILL and
  terminates on c3 or it sees CGRP_KILL on c6 and kills the child. However, I
  don't see what guarantees that k3 can't happen before c6. ie. After a
  forking task passes c5, k2 can take place and then before the forking task
  reaches c6, k3 can happen. Then, nobody would send SIGKILL to the child.
  What am I missing?

This is indeed a race. One way to fix this race is by taking
cgroup_threadgroup_rwsem in write mode in __cgroup_kill() as the fork()
side takes cgroup_threadgroup_rwsem in read mode from cgroup_can_fork()
to cgroup_post_fork(). However that would be heavy handed as this adds
one more potential stall scenario for cgroup.kill which is usually
called under extreme situation like memory pressure.

To fix this race, let's maintain a sequence number per cgroup which gets
incremented on __cgroup_kill() call. On the fork() side, the
cgroup_can_fork() will cache the sequence number locally and recheck it
against the cgroup's sequence number at cgroup_post_fork() site. If the
sequence numbers mismatch, it means __cgroup_kill() can been called and
we should send SIGKILL to the newly created task.

Reported-by: Tejun Heo <tj@kernel.org>
Closes: https://lore.kernel.org/all/Z5QHE2Qn-QZ6M-KW@slm.duckdns.org/ [1]
Fixes: 661ee6280931 ("cgroup: introduce cgroup.kill")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    6 +++---
 include/linux/sched/task.h  |    1 +
 kernel/cgroup/cgroup.c      |   20 ++++++++++++--------
 3 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -71,9 +71,6 @@ enum {
 
 	/* Cgroup is frozen. */
 	CGRP_FROZEN,
-
-	/* Control group has to be killed. */
-	CGRP_KILL,
 };
 
 /* cgroup_root->flags */
@@ -407,6 +404,9 @@ struct cgroup {
 
 	int nr_threaded_children;	/* # of live threaded child cgroups */
 
+	/* sequence number for cgroup.kill, serialized by css_set_lock. */
+	unsigned int kill_seq;
+
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct cgroup_file procs_file;	/* handle for "cgroup.procs" */
 	struct cgroup_file events_file;	/* handle for "cgroup.events" */
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -34,6 +34,7 @@ struct kernel_clone_args {
 	int io_thread;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+	unsigned int kill_seq;
 };
 
 /*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3818,7 +3818,7 @@ static void __cgroup_kill(struct cgroup
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
-	set_bit(CGRP_KILL, &cgrp->flags);
+	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
 	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
@@ -3834,10 +3834,6 @@ static void __cgroup_kill(struct cgroup
 		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
-
-	spin_lock_irq(&css_set_lock);
-	clear_bit(CGRP_KILL, &cgrp->flags);
-	spin_unlock_irq(&css_set_lock);
 }
 
 static void cgroup_kill(struct cgroup *cgrp)
@@ -6202,6 +6198,10 @@ static int cgroup_css_set_fork(struct ke
 	spin_lock_irq(&css_set_lock);
 	cset = task_css_set(current);
 	get_css_set(cset);
+	if (kargs->cgrp)
+		kargs->kill_seq = kargs->cgrp->kill_seq;
+	else
+		kargs->kill_seq = cset->dfl_cgrp->kill_seq;
 	spin_unlock_irq(&css_set_lock);
 
 	if (!(kargs->flags & CLONE_INTO_CGROUP)) {
@@ -6369,6 +6369,7 @@ void cgroup_post_fork(struct task_struct
 		      struct kernel_clone_args *kargs)
 	__releases(&cgroup_threadgroup_rwsem) __releases(&cgroup_mutex)
 {
+	unsigned int cgrp_kill_seq = 0;
 	unsigned long cgrp_flags = 0;
 	bool kill = false;
 	struct cgroup_subsys *ss;
@@ -6382,10 +6383,13 @@ void cgroup_post_fork(struct task_struct
 
 	/* init tasks are special, only link regular threads */
 	if (likely(child->pid)) {
-		if (kargs->cgrp)
+		if (kargs->cgrp) {
 			cgrp_flags = kargs->cgrp->flags;
-		else
+			cgrp_kill_seq = kargs->cgrp->kill_seq;
+		} else {
 			cgrp_flags = cset->dfl_cgrp->flags;
+			cgrp_kill_seq = cset->dfl_cgrp->kill_seq;
+		}
 
 		WARN_ON_ONCE(!list_empty(&child->cg_list));
 		cset->nr_tasks++;
@@ -6420,7 +6424,7 @@ void cgroup_post_fork(struct task_struct
 		 * child down right after we finished preparing it for
 		 * userspace.
 		 */
-		kill = test_bit(CGRP_KILL, &cgrp_flags);
+		kill = kargs->kill_seq != cgrp_kill_seq;
 	}
 
 	spin_unlock_irq(&css_set_lock);


