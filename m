Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E1C1C5485;
	Wed, 19 Feb 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957529; cv=none; b=E+hai2/8NwJzKwcow405m+V2fY+cnfmHLQPEG2gkB7ERbawA9GToyhtadhin7PW4ZauVvUOu0G1cVeTildU8+bm3iyhooTDU1AKlYfAzmrOhyz3uWls0wD0poRFxmA4OAcbPxLrxd4UCOpelYzPPIAc1Sqaw7MlJUUO2C5cijkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957529; c=relaxed/simple;
	bh=x1YmXfBoLYu3Lv4gSApinXDWumbynjQK0Ic6QW/tWmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zoou6yla7jQt0DRViCzkZgsxZpSF7Yj3e2gFHZOL4ptgDttUb1MCco5svFWTOWtRwvdXHuyuwf7kN4zMOYnTlXue+03rGJInpL5fitqnPeCDoB8Dv7Ybzad9OIQu7YNzvs6RKSPWe0THObI4Wveym8OCCcjn6kRD/Lc6hXmMeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ8eWXWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ8eWXWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA11FC4CEF0;
	Wed, 19 Feb 2025 09:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957529;
	bh=x1YmXfBoLYu3Lv4gSApinXDWumbynjQK0Ic6QW/tWmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZ8eWXWR+xRYG8eRGYtBECFuUhO7Z7ZfLCPMZfDBYMTnO/lIniuIzcHzLuVOr0Fuv
	 AUavOQnzTlFpkdOT9vrjHREd7hmJSs3CE97ZxTqTu+j+KpZHmM+ULBohI6M+k4ZgFO
	 DSkhoqocbXUyM8RykqP/DmJUlX+WAun9nonS6BJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 6.1 525/578] cgroup: fix race between fork and cgroup.kill
Date: Wed, 19 Feb 2025 09:28:49 +0100
Message-ID: <20250219082713.624915189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,6 +421,9 @@ struct cgroup {
 
 	int nr_threaded_children;	/* # of live threaded child cgroups */
 
+	/* sequence number for cgroup.kill, serialized by css_set_lock. */
+	unsigned int kill_seq;
+
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct cgroup_file procs_file;	/* handle for "cgroup.procs" */
 	struct cgroup_file events_file;	/* handle for "cgroup.events" */
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -38,6 +38,7 @@ struct kernel_clone_args {
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+	unsigned int kill_seq;
 };
 
 /*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3952,7 +3952,7 @@ static void __cgroup_kill(struct cgroup
 	lockdep_assert_held(&cgroup_mutex);
 
 	spin_lock_irq(&css_set_lock);
-	set_bit(CGRP_KILL, &cgrp->flags);
+	cgrp->kill_seq++;
 	spin_unlock_irq(&css_set_lock);
 
 	css_task_iter_start(&cgrp->self, CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED, &it);
@@ -3968,10 +3968,6 @@ static void __cgroup_kill(struct cgroup
 		send_sig(SIGKILL, task, 0);
 	}
 	css_task_iter_end(&it);
-
-	spin_lock_irq(&css_set_lock);
-	clear_bit(CGRP_KILL, &cgrp->flags);
-	spin_unlock_irq(&css_set_lock);
 }
 
 static void cgroup_kill(struct cgroup *cgrp)
@@ -6409,6 +6405,10 @@ static int cgroup_css_set_fork(struct ke
 	spin_lock_irq(&css_set_lock);
 	cset = task_css_set(current);
 	get_css_set(cset);
+	if (kargs->cgrp)
+		kargs->kill_seq = kargs->cgrp->kill_seq;
+	else
+		kargs->kill_seq = cset->dfl_cgrp->kill_seq;
 	spin_unlock_irq(&css_set_lock);
 
 	if (!(kargs->flags & CLONE_INTO_CGROUP)) {
@@ -6592,6 +6592,7 @@ void cgroup_post_fork(struct task_struct
 		      struct kernel_clone_args *kargs)
 	__releases(&cgroup_threadgroup_rwsem) __releases(&cgroup_mutex)
 {
+	unsigned int cgrp_kill_seq = 0;
 	unsigned long cgrp_flags = 0;
 	bool kill = false;
 	struct cgroup_subsys *ss;
@@ -6605,10 +6606,13 @@ void cgroup_post_fork(struct task_struct
 
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
@@ -6643,7 +6647,7 @@ void cgroup_post_fork(struct task_struct
 		 * child down right after we finished preparing it for
 		 * userspace.
 		 */
-		kill = test_bit(CGRP_KILL, &cgrp_flags);
+		kill = kargs->kill_seq != cgrp_kill_seq;
 	}
 
 	spin_unlock_irq(&css_set_lock);


