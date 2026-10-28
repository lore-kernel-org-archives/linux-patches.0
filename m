Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208087;
	b=x63UjjV2QfeAbDfZgn+x3dEW93WNER48in87vGl0+ic8hTOF2VgpI2j4i798+RuFU1WE
	 95KQxcdf/DpS8r77X0FmRcrnuZ9TVKNLpWoonJIkeYuZL7aUXehjN2gcoo1WehiATgXGs
	 ILbKAWbGvC3woi7gwQ/ATLCdfvbuB3n0QxnoaZBN2fktQVzrbpvVsuNnP3+smHVzysPXl
	 D+aNoI7xgvyfiZTmxH+tf86cljc5RfBNqHJFqlcy2CYJFM0mk82XeXAWzuOZ0jgXmhy6b
	 h1WCMnQJNEqS8KuGtfIvG1M3fBE0NpoVDtLoroNBVmOMJ9UkZnw4TD/mFPmqoy57FAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WcSUhhye/BoWLE6VWtyf5+x+qLv6CWZ+XZ/CvPeL07Q=;
	b=UU1THS+lqr5RDa7oOp/hqZOL0hyxAiiG6T3tLmLNTMUVJS6bR8DD5arCXvHAgKMlasxs
	 JNWlbdwYWxQmk5+UA8Q2iCd0xAKp2JQe9yC/UduUwwCCTd1M5wQHCILdzRTv1N4nS37+o
	 TYdczOnYaBKajLtRfq0IlftoqODNQnuIL2JigU1bP8IbJ7fDOCwPR+n80DfsGkgoq9Srg
	 L4JVXyc/WBL/qWzGtoxYX+B/EItyKmnEwRNx1rPpNvxT3hC44JUcTO0YZqy2XmJW6bGbC
	 Tc6bcbVjH2k+PMXJL3wdPAO4bazTW7L9hBsl9+ut9QBHsEwacWOdV6OPICM8d1hxdRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDoAlGkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7A5606A31A;
	Wed, 28 Oct 2026 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zDoAlGkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D546F1F01825;
	Wed, 28 Oct 2026 17:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208086;
	bh=WcSUhhye/BoWLE6VWtyf5+x+qLv6CWZ+XZ/CvPeL07Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zDoAlGkIdpo6a5hOVL5Mfm+dh3cSWz8NcmLcXbLH2sfPjhTPfHcnL99f7Wbgfkxl0
	 RYXbpxbeF7MQQJBlr+q1NC0zXGlGYyKnd5WCoB9Km71hNTt4KsRM7BD9FVchxsuuxG
	 SbAJi51e05B+DHnLuLt7cSrdsKsMunlVsMFm/cRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 244/247] fork: release the files of a failed fork after sched_cancel_fork()
Date: Wed, 28 Oct 2026 18:00:47 +0100
Message-ID: <20261028165953.199400067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 296a98c1fa50778c3b31eebed1a3f903f9684349 upstream.

Reorder copy_process() cleanup so sched_fork() taking scx_fork_rwsem
scx_pre_fork() is safe and isn't held around exiting files. Right now, a
fork that fails while another thread closed the bpf link fd will
deadlock against its own read side. It also blocks every fork on the
system:

    copy_process()                  holds scx_fork_rwsem for read
      exit_files()
        close_files()
          filp_close_sync()
            bpf_scx_unreg()
              kthread_flush_work()  waits for the disable work
                scx_root_disable()
                  percpu_down_write(&scx_fork_rwsem)

Simply release the child's files after sched_cancel_fork() dropped the
lock. The task starts out as a copy of its parent so p->files points to
the parent's table until copy_files() replaces it. exit_files() must not
run for a fork that failed before that. Clear p->files up front so
exit_files() is a no-op for those and make copy_files() set it
explicitly for CLONE_FILES.

Reported-by: Chris Mason <mason@kernel.org>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-7-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1814,6 +1814,7 @@ static int copy_files(unsigned long clon
 
 	if (clone_flags & CLONE_FILES) {
 		atomic_inc(&oldf->count);
+		tsk->files = oldf;
 		return 0;
 	}
 
@@ -2305,6 +2306,8 @@ __latent_entropy struct task_struct *cop
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
+	/* Set by copy_files(), exit_files() on the error path skips NULL. */
+	p->files = NULL;
 	spin_lock_init(&p->alloc_lock);
 
 	init_sigpending(&p->pending);
@@ -2402,7 +2405,7 @@ __latent_entropy struct task_struct *cop
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p);
 	if (retval)
-		goto bad_fork_cleanup_files;
+		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_fs;
@@ -2681,8 +2684,6 @@ bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
 	exit_fs(p); /* blocking */
-bad_fork_cleanup_files:
-	exit_files(p); /* blocking */
 bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_security:
@@ -2693,6 +2694,8 @@ bad_fork_cleanup_perf:
 	perf_event_free_task(p);
 bad_fork_sched_cancel_fork:
 	sched_cancel_fork(p);
+	/* ->release() of a file may need scx_fork_rwsem for write. */
+	exit_files(p); /* blocking */
 bad_fork_cleanup_policy:
 	lockdep_free_task(p);
 #ifdef CONFIG_NUMA


