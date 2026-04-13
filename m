Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AB323E342;
	Mon, 13 Apr 2026 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098789; cv=none; b=OnPZRDscG3LJ53InRJdrHey6Suysn8p6k42uUuIkPS/7tYqUT0JMxwZ2QXDo6+0zmc+E5FsCahQcNNbGA/Rzvyx528Y4Fu6sWrCj4//DRkJnfo+wfpar0Y/6I4+JRb2YJRm7VtIQ0vK7z0vPQ/ku+xt3gGisPEELQmuV2w3Dq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098789; c=relaxed/simple;
	bh=areeWVfemIUJ1/1QQlukiTpTAiLDsiX8KyPuFmLI054=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufVZt+7RdsBU0VMWa53eiEjQbggx5P+vJ+DR1oQAC6WkE/3rvt5jTSQ+hSeVgzhYlqKJCBoRSuoKe03/MDq2fkXZx/zA7TVqxKBgUup2AynN1HL7w7CYc4wITdHpTWsryRfVq/dTDXIWSjAmYgyNLVmCvOB8cOPqGxZpsY9gfAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ8JLryR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ8JLryR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAA4C2BCB0;
	Mon, 13 Apr 2026 16:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098789;
	bh=areeWVfemIUJ1/1QQlukiTpTAiLDsiX8KyPuFmLI054=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ8JLryRahrN6VHY+6hndviSmPE7ReoqQwMyDGwvdlz8lb2YKSxqxdOoXvErtWRXd
	 dfzBe6HJGeY8Glz7WV8sKtjBwx3korbU/z82V6O/ZmhNcdbyw33bN9ein0Vt4ltKeM
	 Ha/7RfW2Ordfx2aWpEYeJK3ohLFdUy156cNbaB4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingye Zhao <zhaoqingye@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 089/491] cgroup: fix race between task migration and iteration
Date: Mon, 13 Apr 2026 17:55:34 +0200
Message-ID: <20260413155822.377838845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingye Zhao <zhaoqingye@honor.com>

commit 5ee01f1a7343d6a3547b6802ca2d4cdce0edacb1 upstream.

When a task is migrated out of a css_set, cgroup_migrate_add_task()
first moves it from cset->tasks to cset->mg_tasks via:

    list_move_tail(&task->cg_list, &cset->mg_tasks);

If a css_task_iter currently has it->task_pos pointing to this task,
css_set_move_task() calls css_task_iter_skip() to keep the iterator
valid. However, since the task has already been moved to ->mg_tasks,
the iterator is advanced relative to the mg_tasks list instead of the
original tasks list. As a result, remaining tasks on cset->tasks, as
well as tasks queued on cset->mg_tasks, can be skipped by iteration.

Fix this by calling css_set_skip_task_iters() before unlinking
task->cg_list from cset->tasks. This advances all active iterators to
the next task on cset->tasks, so iteration continues correctly even
when a task is concurrently being migrated.

This race is hard to hit in practice without instrumentation, but it
can be reproduced by artificially slowing down cgroup_procs_show().
For example, on an Android device a temporary
/sys/kernel/cgroup/cgroup_test knob can be added to inject a delay
into cgroup_procs_show(), and then:

  1) Spawn three long-running tasks (PIDs 101, 102, 103).
  2) Create a test cgroup and move the tasks into it.
  3) Enable a large delay via /sys/kernel/cgroup/cgroup_test.
  4) In one shell, read cgroup.procs from the test cgroup.
  5) Within the delay window, in another shell migrate PID 102 by
     writing it to a different cgroup.procs file.

Under this setup, cgroup.procs can intermittently show only PID 101
while skipping PID 103. Once the migration completes, reading the
file again shows all tasks as expected.

Note that this change does not allow removing the existing
css_set_skip_task_iters() call in css_set_move_task(). The new call
in cgroup_migrate_add_task() only handles iterators that are racing
with migration while the task is still on cset->tasks. Iterators may
also start after the task has been moved to cset->mg_tasks. If we
dropped css_set_skip_task_iters() from css_set_move_task(), such
iterators could keep task_pos pointing to a migrating task, causing
css_task_iter_advance() to malfunction on the destination css_set,
up to and including crashes or infinite loops.

The race window between migration and iteration is very small, and
css_task_iter is not on a hot path. In the worst case, when an
iterator is positioned on the first thread of the migrating process,
cgroup_migrate_add_task() may have to skip multiple tasks via
css_set_skip_task_iters(). However, this only happens when migration
and iteration actually race, so the performance impact is negligible
compared to the correctness fix provided here.

Fixes: b636fd38dc40 ("cgroup: Implement css_task_iter_skip()")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Qingye Zhao <zhaoqingye@honor.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2413,6 +2413,7 @@ static void cgroup_migrate_add_task(stru
 
 	mgctx->tset.nr_tasks++;
 
+	css_set_skip_task_iters(cset, task);
 	list_move_tail(&task->cg_list, &cset->mg_tasks);
 	if (list_empty(&cset->mg_node))
 		list_add_tail(&cset->mg_node,


