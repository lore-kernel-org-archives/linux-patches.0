Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD6E348C6B;
	Wed, 30 Sep 2026 19:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796232; cv=none; b=oQsmnPFhGu3qbTtRv0QJqcHqABNXW/rBINbbp3A/vHgyjIopjrDorfnASkLpVWjy5Hzi8My5J9g57ex33cggBU592OCrW5698+Nm4zQfhzI3sHwYObBx1TdGaUUvlOVb4dyeRRaxpETF2WxuihbNMUfst2Ecg5GKEaMAqVVTnMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796232; c=relaxed/simple;
	bh=HMonxwBnlty5u49fVDhOcubYS9xvreDxsuwXJHvcc7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK+/ZlorM1DvH80KcWkj1i8pwTgorS9mpwlfWFxx5gQbl/KHpVAH1OUTYSAPOyrWjxnUu1McX7zOPmRxbZC60tkDkjI65ui4AvcTTNY/s/Cx61dBJRN+fW2sj3KihSXJ+Kqhed1O2k/eOgAnFkTSJZfgl+s0j5+X+Qab8/n/fW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkyYg/Fh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkyYg/Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279771F00898;
	Wed, 30 Sep 2026 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796230;
	bh=TwFvEV5XjjpBef0Cnttjj547aM9eeCq2tixUo9YC3hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkyYg/FhWxHWKnWlXXT2FD9WrJLBG8aNcP0jOL5Un7wUiwuYYusPfdKmSc5UD0C12
	 B8Gc0paIk8OLSCLYYbk+8UxJgwCAl9kzZhrZPyVejRCbHiusNc89IP1JvnQNaEcZ34
	 c6SLCaAVEGRNTPuulRRUpBF/YUHV4hjo5XnQZWVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Kijo Park <red993688@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.6 0839/1193] exec: Cleanup POSIX timers right after de_thread()
Date: Wed, 30 Sep 2026 17:25:23 +0200
Message-ID: <20260930152452.884643536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit acb03d3881818581052924a9bbbe92b8741ed448 upstream.

A per-thread CPU timer holds a reference to the PID of the thread it is
attached to and, while it is armed, its node is queued in that thread's
posix_cputimers. The task is looked up by that PID.

When a non-leader thread exec()s, de_thread() changes which task owns
that PID. pid_task(timer->it.cpu.pid, PIDTYPE_PID) then returns NULL,
but the node is still queued on tsk, which is alive. timer_lock_sighand()
takes a failed lookup to mean that the node is already dequeued, so it
has nothing to undo.

begin_new_exec() calls posix_cpu_timers_exit(me) right after
exec_task_namespaces() and that removes the leftover node, so the state
normally stays invisible. But bprm->point_of_no_return is set before
de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
exec_task_namespaces() fails, the task dies before it gets there.
exit_itimers() then frees the k_itimer while its node is still queued,
and reaping tsk later erases that freed node from the rbtree.

In short:

      the non-leader thread B           the parent

  timer_create(CLOCK_THREAD_CPUTIME_ID)
  timer_settime()
    arm_timer()            // the node is queued on B
  execve()
    de_thread(B)
      exchange_tids(B, leader)  // B's PID now belongs to the leader
      release_task(leader)
        __exit_signal(leader)
          posix_cpu_timers_exit(leader)  // cleans leader's queue, not B's
          __unhash_process(leader)  // that PID has no task anymore
    exec_mmap()
      mmap_read_lock_killable(old_mm)
                                kill(B, SIGKILL)
      // -EINTR
  get_signal()
    do_exit()
      exit_itimers()
        posix_timer_delete()
          posix_cpu_timer_del()
        posix_timer_unhash_and_free()  // freed while still queued
                                wait4()
                                  release_task(B)
                                    posix_cpu_timers_exit(B)
                                      cleanup_timerqueue()
                                        timerqueue_del()  // use-after-free

Move the POSIX timer cleanup right after de_thread() before any of the
later failure conditions brings the task into do_exit().

[ tglx: Move the cleanup right after de_thread() ]

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Kijo Park <red993688@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ao7Q8miiuLAPVnWv@v4bel
Link: https://patch.msgid.link/20260911090541.627712075@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exec.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1236,6 +1236,17 @@ void __set_task_comm(struct task_struct
 	perf_event_comm(tsk, exec);
 }
 
+static void posixtimer_exec(struct task_struct *me)
+{
+#ifdef CONFIG_POSIX_TIMERS
+	spin_lock_irq(&me->sighand->siglock);
+	posix_cpu_timers_exit(me);
+	spin_unlock_irq(&me->sighand->siglock);
+	exit_itimers(me);
+	flush_itimer_signals();
+#endif
+}
+
 /*
  * Calling this is the point of no return. None of the failures will be
  * seen by userspace since either the process is already taking a fatal
@@ -1261,6 +1272,16 @@ int begin_new_exec(struct linux_binprm *
 	retval = de_thread(me);
 	if (retval)
 		goto out;
+
+	/*
+	 * This must be done here to ensure that POSIX CPU timers which were
+	 * armed on the current task are dequeued from me::posix_cputimers.
+	 * Otherwise in case of a TID switch the deletion of the related POSIX
+	 * timer would not remove an enqueued timer because the TID lookup
+	 * of the old TID fails.
+	 */
+	posixtimer_exec(me);
+
 	/* see the comment in check_unsafe_exec() */
 	current->fs->in_exec = 0;
 	/*
@@ -1315,14 +1336,6 @@ int begin_new_exec(struct linux_binprm *
 	if (retval)
 		goto out_unlock;
 
-#ifdef CONFIG_POSIX_TIMERS
-	spin_lock_irq(&me->sighand->siglock);
-	posix_cpu_timers_exit(me);
-	spin_unlock_irq(&me->sighand->siglock);
-	exit_itimers(me);
-	flush_itimer_signals();
-#endif
-
 	/*
 	 * Make the signal table private.
 	 */


