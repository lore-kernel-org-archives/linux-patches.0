Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0B524B19;
	Wed, 23 Sep 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173423; cv=none; b=fcyQN3p407V+J/TZo2+ZXqFbPYGcTXfV+P1NdE1Qwe7eWBwFz3FzMQEX48ing8D9NB1au1WffoHH5pX7lsDDLLQHCyUTQnUfRs7T71+ZlVPqpwsZNLDOg//IaaKcLIn6gSAMlNeDRjOhNk6Qcre3BjlzCbon/kU9KKZ8C11wyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173423; c=relaxed/simple;
	bh=F4B/KkBD+Em0z+e7AdTetUMMXf3YyCUGnZqJ2KsOWxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sz5Mxlc1bWLnGVzD1Dj4hmi2fEwK0ucv4y5kcyDjCXvMxheCstPsjCtIfutDpYHew4CT9RZWotaAiXp4J0MckH3WrfX0jeICWKGWxJpTD5IovvhW8v5vnNYnNaEzy9hyg5sVL6gjfte19aYVcbEOT5NjE16WqMzN96NlS+D35sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yug5sDk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yug5sDk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE901F000FF;
	Wed, 23 Sep 2026 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173422;
	bh=In2ssANMxVZbAVdRBNNN8SmptQG5lq0t/+Zh0AtXi+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yug5sDk5or24cSVqdXPwFwPF8H8Y8I3UdLgBC1ypY4uvDaFd4jfdoA1T7+U2U260Z
	 0enpCKlRJPg43Vrj5MiMtgy9nMyIUeflZotOgZy5Qm7hSo+52hbbj5jSKkT5DWiSlL
	 ptQUBtkNqpb7RavSUJrT9DRc8MCWEYxCVloCyIko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noah Elias Feldt <N.Feldt@mittwald.de>,
	Salvatore Bonaccorso <carnil@debian.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 241/438] cgroup: Avoid iteration of dying tasks with zero refcount
Date: Wed, 23 Sep 2026 16:04:22 +0200
Message-ID: <20260923140651.019913467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

commit 057dac23d329d5c5ed62352f2659a39fd46c6d4a upstream.

The commit 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from
cgroup_task_release() to cgroup_task_free()") extended the lifetime of
tasks on the dying_tasks list.
The iterators have provision to go through dying_tasks because of
dying threadgroup leaders or explicit CSS_TASK_ITER_WITH_DEAD, however,
it was expected that such tasks can obtain a new reference (that is
possible before cgroup_task_release()/put_task_struct_rcu_user()).
The tasks after cgroup_task_release() and before cgroup_task_free()
are subject to race when they may or may not have ->usage count > 0.

The race window is between css_task_iter_next() invocations
when css_set_lock is released and we may arrive at a new ->task_pos.
The iterator should not attempt to resurrect tasks whose ->usage count
dropped to zero. (When that happens, __put_task_struct_rcu_cb() is
already imminent and the returned task_struct would could be used
after free.)

As for the fix, we cannot simply check the signal->live count of a task
on the dying list because that won't distinguish regular zombies waiting
to be reaped from RCU remnant tasks that are going to be free'd.
Therefore add an extra check to rule out ->usage==0 tasks from any
iteration.

The repeat: loop in css_task_iter_advance() doesn't consider ->usage
count, so add a new loop to css_task_iter_next() to skip de-used tasks
on the dying_list.

Rough illustration of the possible race

  R (reader of cgroup.procs)         T (thread)                       L (group leader)
  ---------------------------------  -------------------------------- --------------------------------
                                                                      L exits, signal->live > 0
                                                                      cgroup_task_dead(L)
                                                                        css_set_skip_task_iters() // skips only cset->tasks
                                                                        list_add_tail(&L->cg_list, &cset->dying_tasks)
  css_task_iter_next()
    take css_set_lock
    css_task_iter_advance()
      leader && signal->live != 0
      => it->task_pos = &L->cg_list
    release css_set_lock
                                     T exits
                                     --signal->live == 0
				     cgroup_task_dead(T) // css_set_lock
                                     release_task(T)
                                       cgroup_task_release(T)
                                       release_task(L) // zap_leader
                                         cgroup_task_release(L)
                                         put_task_struct_rcu_user(L)
                                         ...RCU...
                                         put_task_struct(L)
                                           L->usage = 0
                                           /* L still on dying_tasks */
                                           ...RCU...
                                           __put_task_struct(L)
  css_task_iter_next() // another iteration
    take css_set_lock
    it->task_pos = &L->cg_list
    get_task_struct(L)
      => addition on 0
    drop css_set_lock
                                           cgroup_task_free(L)
                                             css_set_skip_task_iters() // dying skip comes too late
                                           free_task(L)
  cgroup_procs_show()
    task_pid_vnr(L)

Fixes: 260fbcb92bbea ("cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgroup_task_free()")
Cc: stable@vger.kernel.org # v6.19+
Link: https://lists.debian.org/debian-kernel/2026/08/msg00220.html
Reported-by: Noah Elias Feldt <N.Feldt@mittwald.de>
Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5228,10 +5228,13 @@ struct task_struct *css_task_iter_next(s
 	if (it->flags & CSS_TASK_ITER_SKIPPED)
 		css_task_iter_advance(it);
 
-	if (it->task_pos) {
+	while (it->task_pos && !it->cur_task) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);
-		get_task_struct(it->cur_task);
+		/* a task on dying_tasks with zero refcount is only valid for
+		 * RCU readers, not even interesting for
+		 * CSS_TASK_ITER_WITH_DEAD, find another one */
+		it->cur_task = tryget_task_struct(it->cur_task);
 		css_task_iter_advance(it);
 	}
 


