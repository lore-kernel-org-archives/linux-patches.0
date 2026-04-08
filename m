Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296A72727F3;
	Wed,  8 Apr 2026 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674361; cv=none; b=AxIO0+FJmRWq1NJg138sA6RKQSBcbGn0HjizUklQnfLvpA0b4HIrMkEp8wJ2XIK2lCeRvjZhHgudA8ON+H29Dl/hlfZcLrKg7T0v03S9gOGuGXgoGyWKsOepZ1h3v6cTsN/FT/81osnwVqW8mfvWuvESrOYFFqDH9M2iQk/Fmq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674361; c=relaxed/simple;
	bh=5g/GOeBGjNOhKMMi6cnBpqwtYS4QP2h4Lzx8WaqM3VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3x3ku+XwQOFeWQLIoxSkP/1HJ6dlhwzUmW7Blk8oJ/OZGt2b56KjYsQsBul3b6IJudffl0tPXeIXwwc67uLO0uyzkeRZHB96ON+1E4wvkIGqCzwzInXu4M/GU7T1l9JGwnC9a7CabWfGKYfMQorpknBxK3hGkG6MF0OHanjI1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ14nG38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ14nG38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0FBC19421;
	Wed,  8 Apr 2026 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674361;
	bh=5g/GOeBGjNOhKMMi6cnBpqwtYS4QP2h4Lzx8WaqM3VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQ14nG387hbxadfPTIUzmFn2AY/NFWlKASrAQ91Er+v/RuIA44CObnFWv/tsdPX2F
	 f5C6EXp6VUkEHPHVufnE7oQ7Z/zqmZ4o5im75NTryXp5gTdGS82TO7Tom2ATxGIhNd
	 cKEjlu0RdniRbuYeBJ3XBseJ4n4Op45rRNJ8NS4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/311] cgroup: Fix cgroup_drain_dying() testing the wrong condition
Date: Wed,  8 Apr 2026 20:00:35 +0200
Message-ID: <20260408175940.725507528@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4c56a8ac6869855866de0bb368a4189739e1d24f ]

cgroup_drain_dying() was using cgroup_is_populated() to test whether there are
dying tasks to wait for. cgroup_is_populated() tests nr_populated_csets,
nr_populated_domain_children and nr_populated_threaded_children, but
cgroup_drain_dying() only needs to care about this cgroup's own tasks - whether
there are children is cgroup_destroy_locked()'s concern.

This caused hangs during shutdown. When systemd tried to rmdir a cgroup that had
no direct tasks but had a populated child, cgroup_drain_dying() would enter its
wait loop because cgroup_is_populated() was true from
nr_populated_domain_children. The task iterator found nothing to wait for, yet
the populated state never cleared because it was driven by live tasks in the
child cgroup.

Fix it by using cgroup_has_tasks() which only tests nr_populated_csets.

v3: Fix cgroup_is_populated() -> cgroup_has_tasks() (Sebastian).

v2: https://lore.kernel.org/r/20260323200205.1063629-1-tj@kernel.org

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: 1b164b876c36 ("cgroup: Wait for dying tasks to leave on rmdir")
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 257d1ddea1ada..9370100764904 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6229,20 +6229,22 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
  * cgroup_drain_dying - wait for dying tasks to leave before rmdir
  * @cgrp: the cgroup being removed
  *
- * The PF_EXITING filter in css_task_iter_advance() hides exiting tasks from
- * cgroup.procs so that userspace (e.g. systemd) doesn't see tasks that have
- * already been reaped via waitpid(). However, the populated counter
- * (nr_populated_csets) is only decremented when the task later passes through
+ * cgroup.procs and cgroup.threads use css_task_iter which filters out
+ * PF_EXITING tasks so that userspace doesn't see tasks that have already been
+ * reaped via waitpid(). However, cgroup_has_tasks() - which tests whether the
+ * cgroup has non-empty css_sets - is only updated when dying tasks pass through
  * cgroup_task_dead() in finish_task_switch(). This creates a window where
- * cgroup.procs appears empty but cgroup_is_populated() is still true, causing
- * rmdir to fail with -EBUSY.
+ * cgroup.procs reads empty but cgroup_has_tasks() is still true, making rmdir
+ * fail with -EBUSY from cgroup_destroy_locked() even though userspace sees no
+ * tasks.
+ *
+ * This function aligns cgroup_has_tasks() with what userspace can observe. If
+ * cgroup_has_tasks() but the task iterator sees nothing (all remaining tasks are
+ * PF_EXITING), we wait for cgroup_task_dead() to finish processing them. As the
+ * window between PF_EXITING and cgroup_task_dead() is short, the wait is brief.
  *
- * This function bridges that gap. If the cgroup is populated but all remaining
- * tasks have PF_EXITING set, we wait for cgroup_task_dead() to process them.
- * Tasks are removed from the cgroup's css_set in cgroup_task_dead() called from
- * finish_task_switch(). As the window between PF_EXITING and cgroup_task_dead()
- * is short, the number of PF_EXITING tasks on the list is small and the wait
- * is brief.
+ * This function only concerns itself with this cgroup's own dying tasks.
+ * Whether the cgroup has children is cgroup_destroy_locked()'s problem.
  *
  * Each cgroup_task_dead() kicks the waitqueue via cset->cgrp_links, and we
  * retry the full check from scratch.
@@ -6258,7 +6260,7 @@ static int cgroup_drain_dying(struct cgroup *cgrp)
 
 	lockdep_assert_held(&cgroup_mutex);
 retry:
-	if (!cgroup_is_populated(cgrp))
+	if (!cgroup_has_tasks(cgrp))
 		return 0;
 
 	/* Same iterator as cgroup.threads - if any task is visible, it's busy */
@@ -6273,15 +6275,15 @@ static int cgroup_drain_dying(struct cgroup *cgrp)
 	 * All remaining tasks are PF_EXITING and will pass through
 	 * cgroup_task_dead() shortly. Wait for a kick and retry.
 	 *
-	 * cgroup_is_populated() can't transition from false to true while
-	 * we're holding cgroup_mutex, but the true to false transition
-	 * happens under css_set_lock (via cgroup_task_dead()). We must
-	 * retest and prepare_to_wait() under css_set_lock. Otherwise, the
-	 * transition can happen between our first test and
-	 * prepare_to_wait(), and we sleep with no one to wake us.
+	 * cgroup_has_tasks() can't transition from false to true while we're
+	 * holding cgroup_mutex, but the true to false transition happens
+	 * under css_set_lock (via cgroup_task_dead()). We must retest and
+	 * prepare_to_wait() under css_set_lock. Otherwise, the transition
+	 * can happen between our first test and prepare_to_wait(), and we
+	 * sleep with no one to wake us.
 	 */
 	spin_lock_irq(&css_set_lock);
-	if (!cgroup_is_populated(cgrp)) {
+	if (!cgroup_has_tasks(cgrp)) {
 		spin_unlock_irq(&css_set_lock);
 		return 0;
 	}
-- 
2.53.0



