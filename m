Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207128;
	b=BZ2yEWUsgxfoZXxrlZjY8/fRlSqOxkDXx6L9EJ31Dt/pimdKjwhoyd3wiZjkkvGCMouT
	 uToaqqndcLzeeoKIpqVqKXmqFaKwFh8kdy35+lsDN6UT1MenQHse7EsPQIC/DTG0ZyuHk
	 al5DfCixninjGvTJdawiSQnnOV62jRPF3QPtzGdKzCee8uFIBJmSwApVECR9rBCLi1lCs
	 ObyQyIwPd5BDD144LpFZqYlRUIuBPdfZHT234VWZ+u3lbB2IF4IymgNHfjDWDkxiu9syh
	 aVglE1z9L9nMWTpEisoG0XdMX5MI5KjqncRHFWrXSTmK3v3EwJKBHkAKVDtgOmHfUGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iTKouuMYXwMjdps9isSrJ5Z2Rn4TKanPvKHn9qVQEzs=;
	b=Vl6Dh5IYI7u9BK9+vdzHChqoiPnu1rgeBPunTjtqp/D+nswW4jnFfgYcrVb5rLxhSLLq
	 +1sQkFBj7L0kzZ5XifUDQ40uRKVWd/FHY4JcUtLFjtFTH+f37q3tScqc1VTgzOPm0+vQx
	 7y/bB4p1CqfAjEhnqC0/Q2ma1R4XjgU0NNKd3PmnWe25bRyLhzLwaV1y1CU1is85PeCsu
	 qZdh5GV2a3sGxXyJx4TGLHnq3hVLRguAd/OqNla4PVXTQYIby6setEE2W3HZE3b+S6WqW
	 HA3xGuIkqlBMH3YoFvzWAM3a4Erz/WsqmVXr6uilFcQ/zrqLuwhGn+Pdc/4U8cPKfIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htkGoIHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE0F606A31E;
	Wed, 28 Oct 2026 17:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htkGoIHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A1B1F01825;
	Wed, 28 Oct 2026 17:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207127;
	bh=iTKouuMYXwMjdps9isSrJ5Z2Rn4TKanPvKHn9qVQEzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htkGoIHkv735n2g9tcCcJCqwkTn1TEFj5A9w+R4ndj5ZvyE1OHUGf6Sr4RoimuyO9
	 DF4LKnN7EVgKQy4qV6UHsq7bg+TqT+xBxIQihd4tYKYW/pe89EYe1toH6mXI5udUGI
	 RqQIwg8N2Cw7IPTuG5kHjQjKPOms4rsPeTv24ZTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 34/38] fork: release the files of a failed fork after sched_cancel_fork()
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028165941.262001995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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
@@ -1685,6 +1685,7 @@ static int copy_files(u64 clone_flags, s
 
 	if (clone_flags & CLONE_FILES) {
 		atomic_inc(&oldf->count);
+		tsk->files = oldf;
 		return 0;
 	}
 
@@ -2208,6 +2209,8 @@ __latent_entropy struct task_struct *cop
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
+	/* Set by copy_files(), exit_files() on the error path skips NULL. */
+	p->files = NULL;
 	spin_lock_init(&p->alloc_lock);
 
 	init_sigpending(&p->pending);
@@ -2311,7 +2314,7 @@ __latent_entropy struct task_struct *cop
 			 (args->umh ? COPY_FS_UMH : 0) |
 			 (args->idle ? COPY_FS_IDLE : 0));
 	if (retval)
-		goto bad_fork_cleanup_files;
+		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_fs;
@@ -2625,8 +2628,6 @@ bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
 	exit_fs(p); /* blocking */
-bad_fork_cleanup_files:
-	exit_files(p); /* blocking */
 bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_security:
@@ -2637,6 +2638,8 @@ bad_fork_cleanup_perf:
 	perf_event_free_task(p);
 bad_fork_sched_cancel_fork:
 	sched_cancel_fork(p);
+	/* ->release() of a file may need scx_fork_rwsem for write. */
+	exit_files(p); /* blocking */
 bad_fork_cleanup_policy:
 	lockdep_free_task(p);
 #ifdef CONFIG_NUMA


