Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5EA4EFFA6;
	Thu, 17 Sep 2026 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660240; cv=none; b=B7SSRQolxJaKzTih9l51b7/400Ni8xn4V1l3CAOylXK0GgAGu66SQe+DEEeAicBdavtVD0++6vUA885n4eBIa+EdsduZmXr1xdPv769QKLmLoQ49ZT2knN1wbziqrR658AmYQwhTEtduybeOVbDViPrLIkO7EbIItKHdtSuTbEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660240; c=relaxed/simple;
	bh=Tr3D46roHtK1hwrOSJTvu7LoDHwnBGPHSaDQY/SxBAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeAlSux9rTLOnH1BSTLPQiw4gS3JQ+CKJ4uVfLQqQ+nxtt9M3R/V32uelCUjv7d5xW+RTB/h8GQLFu/9G/qOkp6myYZ2HFmcFge43Uv/nX3Mc97w5oHItf0Zgz3DEXMSDgVXnuRZ5wppjuezTpzOQ11p80hhlNCKdx396npzcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUIXjExU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUIXjExU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451271F00893;
	Thu, 17 Sep 2026 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660232;
	bh=4a5s8EPa2BOMXdMOGYIHZCoh2vMq22VAdkxgZTsmB50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUIXjExU+J55d109BGnmWItLQ6UTt4vvYH40VOYmJfGLPEG6WbDYauhW8H23oAOsU
	 tfNYswBntZqPvoTD5yCtUjyly9aJUePvqrPNUhsGkwBd+jKSLS+SwDCuZKHNkkTB3M
	 kTV2nuPmNVS5YFuuK07cGNms2gdhb+SOMbz7R1Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0aee5e8066eddbbe7397@syzkaller.appspotmail.com,
	syzbot+e8b3520b53e78e90034e@syzkaller.appspotmail.com,
	Daehyeon Ko <4ncienth@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 522/733] exit: hold a reference to thread_pid across proc_flush_pid
Date: Thu, 17 Sep 2026 16:13:50 +0100
Message-ID: <20260917151405.173309432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit cdd812d0683dee14ead02c9eded568685e61b23f upstream.

Commit 0a36bad01731 ("release_task: kill the no longer needed
get/put_pid(thread_pid)") removed the reference around proc_flush_pid().
It assumed that free_pids(post.pids) at the end of release_task() would
keep thread_pid alive until then.

That assumption is wrong.  __change_pid() only records a detached PID in
post.pids when pid_has_task() is false for every PIDTYPE.  If another task
still uses the exiting task's PID as its process group or session ID,
__unhash_process() removes the exiting task's PIDTYPE_PID link but leaves
the PID out of post.pids.  release_task() therefore holds no reference to
it after dropping tasklist_lock.

The other task can then remove the remaining PIDTYPE links.  Its
free_pids() call schedules delayed_put_pid(), and the RCU callback can free
the PID before the first release_task() reaches proc_flush_pid().

An unprivileged reproducer races wait4(-1) against setsid() to trigger this
ordering.  Three of three fresh v7.2 KASAN boots reported:

    BUG: KASAN: slab-use-after-free in
    proc_invalidate_siblings_dcache+0x3e2/0x3f0
    Read of size 8 by task h7_pid_reaper/1921

    Call Trace:
     proc_invalidate_siblings_dcache
     release_task
     wait_consider_task
     __do_wait
     do_wait
     kernel_wait4

    Freed by task 0:
     kmem_cache_free
     put_pid
     delayed_put_pid
     rcu_core

    Last potentially related work creation:
     __call_rcu_common
     free_pids
     ksys_setsid

KASAN identified a 144-byte object from the pid cache and located the bad
read 80 bytes into the freed object, matching pid->inodes.  With an
explicit reference, three of three fresh boots completed without a KASAN
report.  The concurrent RCU callback dropped its reference while
proc_flush_pid() was protected, and the balancing put_pid() performed the
final free afterward.

Take a reference before __unhash_process() clears p->thread_pid and release
it after proc_flush_pid() completes.

A tested source reproducer is available privately on request.  No
controlled read or write, information leak, or privilege escalation is
claimed.  The mainline patch applies directly to v6.19.y and newer;
v6.16.y through v6.18.y need a context-adjusted backport.

Fixes: 0a36bad01731 ("release_task: kill the no longer needed get/put_pid(thread_pid)")
Reported-by: syzbot+0aee5e8066eddbbe7397@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0aee5e8066eddbbe7397
Reported-by: syzbot+e8b3520b53e78e90034e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=e8b3520b53e78e90034e
Cc: stable@vger.kernel.org # see patch description, needs adjustments for 6.16.y-6.18.y
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20260831001221.3755948-1-4ncienth@gmail.com
Acked-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -262,8 +262,11 @@ repeat:
 	pidfs_exit(p);
 	cgroup_task_release(p);
 
-	/* Retrieve @thread_pid before __unhash_process() may set it to NULL. */
-	thread_pid = task_pid(p);
+	/*
+	 * Pin @thread_pid before __unhash_process() clears it. The last
+	 * PIDTYPE detach can otherwise free it before proc_flush_pid().
+	 */
+	thread_pid = get_pid(task_pid(p));
 
 	write_lock_irq(&tasklist_lock);
 	ptrace_release_task(p);
@@ -292,8 +295,8 @@ repeat:
 	}
 
 	write_unlock_irq(&tasklist_lock);
-	/* @thread_pid can't go away until free_pids() below */
 	proc_flush_pid(thread_pid);
+	put_pid(thread_pid);
 	exit_cred_namespaces(p);
 	add_device_randomness(&p->se.sum_exec_runtime,
 			      sizeof(p->se.sum_exec_runtime));


