Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827070;
	b=yeq0RniYIYtz63eQbBCdIDwMbHG4TTEcnGzZQ/TOB0A5xb5VrNmR6IedIhYPd7XNoX4q
	 PBYh/q602D/+gyYrNy34qV0S9CIgHYAR5ahhaDhWoM0168UtRXPhfmWeMYHERPRaVwcXb
	 rswrnd+UR83kUjDUWaw5H8igqz6ww1nb/LqW2cDaKy4PCjPyilwGccfUOGrmaeTp0u/So
	 B2jMGH3Rcwfmw/UwLuHCOvPwQTtMfPz8tJlW5EvM2Fa7crWkwDilpIl5gFLCc1t9WyQU/
	 36Pe0bkIxoVx/DPSUbf8if3y1QfRcMCp3VS24M4w1UOOxW08DmGCQovk6mdcJeXBhUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KC6FrlnIenHFRNv81VOrF+DK3DbOSgIeNDpm7wSDUNM=;
	b=dKCjk+WgMV2i2nDeOdksQa6B9Dbz4Z7sYvNcSW2CNlzlFJr+XDLx/xHQqvyfctrO6RZK
	 BOxo+TUEdZXJAZ1QUETTIuEVzSoZxIXF4IqfbT87C9otEiu2Xa9uFJrYWGFhxNaatbIrH
	 2U0wJjdQWC6MZqVuEa+DoneF1vNe8DAhtLmlw5QkKf72jLMrf2DTsWIiPNkDUp/mZ5TWG
	 z5LszsbKXa8faT8geXPBqR9rqxMQPE//usvBqKw2wDnl2i5ESkJTdQYLSrOnt/t+6Eo6M
	 8wDdXRWRMxTvyR++AiT/M1oooDe+nJXl0Ka1aIpm3mtc1LQGSRnA8B+FZCypzslFZKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNlp2NmM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2626606A862;
	Wed,  4 Nov 2026 21:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNlp2NmM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2004C1F000C1;
	Wed,  4 Nov 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827069;
	bh=KC6FrlnIenHFRNv81VOrF+DK3DbOSgIeNDpm7wSDUNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNlp2NmMhLcV98I+saCS+2kCfdBYjv555rssZUJ/co4Dn4bbBDW/te3B/ZetMJdwy
	 jLvcLODwbVHBDdsVhg91B13ZCZIF/ZNbLSnftiscsnBFIPwIxQRFFHvhTQsfbYMiFL
	 te9N8APov4AEwbZmHk9CLTBsCfPZiZomo7TeFkFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 139/547] cgroup: serialize migrations of newly forked processes
Date: Wed,  4 Nov 2026 16:05:23 -0500
Message-ID: <20261104211042.124993317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit bf6fbf46b5ff68c4eebad5aa52309eb124f4509c ]

With favordynmods enabled, a cgroup.procs migration takes the target
threadgroup's cgroup_threadgroup_rwsem for writing. A process fork holds
the forking threadgroup's semaphore for reading. These are different
semaphores when fork creates a new process.

copy_process() publishes the child's PID before cgroup_post_fork() links
the child to its css_set. A writer can find the child in that interval,
take its uncontended semaphore, and migrate it while child->cgroups still
points to init_css_set and child->cg_list is empty. Migration links the
node into init_css_set.mg_tasks. cgroup_post_fork() then adds the same
node to the intended css_set as though it were unlinked, corrupting both
task lists and their css_set ownership.

This regresses the fork/migration race fixed by commit b12b533fa523
("cgroups: add lock for child->cgroups in cgroup_post_fork()") and
restored again in 2012 after the lock had been removed. The old task_lock
protection was later superseded by global css_set and cgroup threadgroup
locking. The change identified by the Fixes tag narrowed only the migration
side back to a per-threadgroup lock, recreating the different-process
exclusion failure.

Take the new threadgroup's semaphore for reading before the child becomes
visible and hold it through cgroup_post_fork(). Use a nested lock subclass
because fork already holds the parent's semaphore. CLONE_THREAD children
share the parent's signal_struct and remain covered by the existing lock.
Migrations of unrelated, fully initialized threadgroups remain concurrent.

An AI coding assistant was used to identify and reproduce the regression
and to develop and test this fix.

Fixes: 0568f89d4fb8 ("cgroup: replace global percpu_rwsem with per threadgroup resem when writing to cgroup.procs")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca59..42cc77dfa1c8a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6844,6 +6844,31 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 	return cgrp;
 }
 
+/*
+ * A new threadgroup gets its own cgroup_threadgroup_rwsem.  Once its PID is
+ * visible, a cgroup.procs writer can find the child and lock that rwsem even
+ * though cgroup_post_fork() has not linked the child to its css_set yet.
+ *
+ * cgroup_can_fork() already holds the global read lock, which keeps
+ * cgroup_enable_per_threadgroup_rwsem stable.  Lock the child's rwsem as a
+ * nested instance until cgroup_post_fork() finishes.  Threads share their
+ * parent's signal_struct and are covered by the existing read lock.
+ */
+static void cgroup_fork_child_lock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		down_read_nested(&child->signal->cgroup_threadgroup_rwsem,
+				 SINGLE_DEPTH_NESTING);
+}
+
+static void cgroup_fork_child_unlock(struct task_struct *child)
+{
+	if (cgroup_enable_per_threadgroup_rwsem &&
+	    child->signal != current->signal)
+		up_read(&child->signal->cgroup_threadgroup_rwsem);
+}
+
 /**
  * cgroup_css_set_fork - find or create a css_set for a child process
  * @kargs: the arguments passed to create the child process
@@ -7009,6 +7034,7 @@ int cgroup_can_fork(struct task_struct *child, struct kernel_clone_args *kargs)
 			goto out_revert;
 	} while_each_subsys_mask();
 
+	cgroup_fork_child_lock(child);
 	return 0;
 
 out_revert:
@@ -7043,6 +7069,7 @@ void cgroup_cancel_fork(struct task_struct *child,
 		if (ss->cancel_fork)
 			ss->cancel_fork(child, kargs->cset);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
@@ -7140,6 +7167,7 @@ void cgroup_post_fork(struct task_struct *child,
 	if (unlikely(kill))
 		do_send_sig_info(SIGKILL, SEND_SIG_NOINFO, child, PIDTYPE_TGID);
 
+	cgroup_fork_child_unlock(child);
 	cgroup_css_set_put_fork(kargs);
 }
 
-- 
2.53.0



