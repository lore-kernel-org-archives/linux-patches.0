Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0314431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3148FC433D2;
	Wed, 15 Mar 2023 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882598;
	bh=g8hFL0OgZIqd0O5DyB5K/9JIPChpqrAsXzWtVUfKOHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSGLAyc04sEkmFJpnH2uSNbp8KHiRDLiiHGUs1NsjsWTnZ6RbgQB2PVbxZ0Uw2dcN
	 +qHkJ8n4S7Keo+BsiCZtqpMBLk4VRLMH/A4gwiIs7aU9qmG7+nSIvQxrD3Onm2MPsJ
	 Sel/oB1hbLfl/0v8r2kSnaYGKTMb7bmBQuCX1P3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Xuewen Yan <xuewen.yan@unisoc.com>
Subject: [PATCH 4.19 38/39] cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date: Wed, 15 Mar 2023 13:12:52 +0100
Message-Id: <20230315115722.652817372@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejun Heo <tj@kernel.org>

commit 4f7e7236435ca0abe005c674ebd6892c6e83aeb3 upstream.

Bringing up a CPU may involve creating and destroying tasks which requires
read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
cpus_read_lock(). However, cpuset's ->attach(), which may be called with
thredagroup_rwsem write-locked, also wants to disable CPU hotplug and
acquires cpus_read_lock(), leading to a deadlock.

Fix it by guaranteeing that ->attach() is always called with CPU hotplug
disabled and removing cpus_read_lock() call from cpuset_attach().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-and-tested-by: Imran Khan <imran.f.khan@oracle.com>
Reported-and-tested-by: Xuewen Yan <xuewen.yan@unisoc.com>
Fixes: 05c7b7a92cc8 ("cgroup/cpuset: Fix a race between cpuset_attach() and cpu hotplug")
Cc: stable@vger.kernel.org # v5.17+
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/cgroup/cpuset.c |    7 +------
 2 files changed, 45 insertions(+), 11 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2210,6 +2210,45 @@ int task_cgroup_path(struct task_struct
 EXPORT_SYMBOL_GPL(task_cgroup_path);
 
 /**
+ * cgroup_attach_lock - Lock for ->attach()
+ * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem
+ *
+ * cgroup migration sometimes needs to stabilize threadgroups against forks and
+ * exits by write-locking cgroup_threadgroup_rwsem. However, some ->attach()
+ * implementations (e.g. cpuset), also need to disable CPU hotplug.
+ * Unfortunately, letting ->attach() operations acquire cpus_read_lock() can
+ * lead to deadlocks.
+ *
+ * Bringing up a CPU may involve creating and destroying tasks which requires
+ * read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
+ * cpus_read_lock(). If we call an ->attach() which acquires the cpus lock while
+ * write-locking threadgroup_rwsem, the locking order is reversed and we end up
+ * waiting for an on-going CPU hotplug operation which in turn is waiting for
+ * the threadgroup_rwsem to be released to create new tasks. For more details:
+ *
+ *   http://lkml.kernel.org/r/20220711174629.uehfmqegcwn2lqzu@wubuntu
+ *
+ * Resolve the situation by always acquiring cpus_read_lock() before optionally
+ * write-locking cgroup_threadgroup_rwsem. This allows ->attach() to assume that
+ * CPU hotplug is disabled on entry.
+ */
+static void cgroup_attach_lock(void)
+{
+	get_online_cpus();
+	percpu_down_write(&cgroup_threadgroup_rwsem);
+}
+
+/**
+ * cgroup_attach_unlock - Undo cgroup_attach_lock()
+ * @lock_threadgroup: whether to up_write cgroup_threadgroup_rwsem
+ */
+static void cgroup_attach_unlock(void)
+{
+	percpu_up_write(&cgroup_threadgroup_rwsem);
+	put_online_cpus();
+}
+
+/**
  * cgroup_migrate_add_task - add a migration target task to a migration context
  * @task: target task
  * @mgctx: target migration context
@@ -2694,7 +2733,7 @@ struct task_struct *cgroup_procs_write_s
 	if (kstrtoint(strstrip(buf), 0, &pid) || pid < 0)
 		return ERR_PTR(-EINVAL);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	rcu_read_lock();
 	if (pid) {
@@ -2725,7 +2764,7 @@ struct task_struct *cgroup_procs_write_s
 	goto out_unlock_rcu;
 
 out_unlock_threadgroup:
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 out_unlock_rcu:
 	rcu_read_unlock();
 	return tsk;
@@ -2740,7 +2779,7 @@ void cgroup_procs_write_finish(struct ta
 	/* release reference from cgroup_procs_write_start() */
 	put_task_struct(task);
 
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	for_each_subsys(ss, ssid)
 		if (ss->post_attach)
 			ss->post_attach();
@@ -2799,7 +2838,7 @@ static int cgroup_update_dfl_csses(struc
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	percpu_down_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_lock();
 
 	/* look up all csses currently attached to @cgrp's subtree */
 	spin_lock_irq(&css_set_lock);
@@ -2830,7 +2869,7 @@ static int cgroup_update_dfl_csses(struc
 	ret = cgroup_migrate_execute(&mgctx);
 out_finish:
 	cgroup_migrate_finish(&mgctx);
-	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cgroup_attach_unlock();
 	return ret;
 }
 
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1528,13 +1528,9 @@ static void cpuset_attach(struct cgroup_
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
+	lockdep_assert_cpus_held();     /* see cgroup_attach_lock() */
 	mutex_lock(&cpuset_mutex);
 
-	/*
-	 * It should hold cpus lock because a cpu offline event can
-	 * cause set_cpus_allowed_ptr() failed.
-	 */
-	get_online_cpus();
 	/* prepare for attach */
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1553,7 +1549,6 @@ static void cpuset_attach(struct cgroup_
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
 	}
-       put_online_cpus();
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may


