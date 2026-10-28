Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207375;
	b=pLbygmqRb8rOO6PAv/iKUU/spHmghFOaZE9HoAe/BKTK6+z+IGfrE0sZPFZYufklSUvv
	 bf8HNUso8xqLGUxqNNNWTiE/6jnO+0/c3DIqtcRjn+JvwiqN4uGyrzDWS41lLjriu4pzO
	 Evl+PyjATWO4eQHUQF0WOJciBsnj1hOAt8xXlHho8KJVvwlMm3SsH1U4+w365x6lGJ832
	 SDrXArQ8B/RiwK1z+IZpqiSBAaKe1yEUNJdrnPXA/u5cjB1YK1V5+t5NbM3H71aEFmD0U
	 2VMsKsaDWZeAfWdO3ELdQpoySIjlCGy5n6EsXGLD6n4CGA3bdWTkGNs0rBQ5BQxbjFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SP5k3tTI0nsp/OqqqXrsXGRuVL0i3MAG2z2STSjezss=;
	b=BcVjRKLEiiXQY1tTvQPJ68WSI85Z0VwfFDWOIdEQX5lnAfk/yXNqGX3aWaAbepxU6Mxc
	 KLnM3H3XRfJIVz5GREZVadZgByVxwXQxqPnqJRNv8LU7zslbgxpWQqVJT2P84hMW4wUe5
	 xbAhvBOa4HRbMPC62b+f8Uv+lCoEQk4iKGFNi0DmDImxPGacuTBl4jNAPjLX8Ur/EAGqs
	 DId7t67n7S1J20Jis/VIRMre9XMocjL6N3Glfp9g+9cG0rDDNvCaldFH5m+QWTXHMhIqp
	 2JhVcnBqbQFE0hJMj8ptMEM9xfuF32af1lcF9qtWt0WMs9atnTAq00k4NfmPh430qEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE8gqQZD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C03606A31C;
	Wed, 28 Oct 2026 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE8gqQZD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93BB1F01828;
	Wed, 28 Oct 2026 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207374;
	bh=SP5k3tTI0nsp/OqqqXrsXGRuVL0i3MAG2z2STSjezss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oE8gqQZDk/F3K51dshQBdMe5VTBchbtvdunEhuqoek5ae8LSzKIn6jEsL29JVX4qw
	 3UwMBsX1POyZLsol3KVrGpWtK5ZPnK9WllhuNI2puwes0pWUhErUJpK8IXtYQfIg6/
	 Et2ZT5p8uH5/fodV/yQcdyOnQH0CG/w9HCo4A7zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 84/88] fork: release the files of a failed fork after sched_cancel_fork()
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028165944.090505432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1658,6 +1658,7 @@ static int copy_files(u64 clone_flags, s
 
 	if (clone_flags & CLONE_FILES) {
 		atomic_inc(&oldf->count);
+		tsk->files = oldf;
 		return 0;
 	}
 
@@ -2181,6 +2182,8 @@ __latent_entropy struct task_struct *cop
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
+	/* Set by copy_files(), exit_files() on the error path skips NULL. */
+	p->files = NULL;
 	spin_lock_init(&p->alloc_lock);
 
 	init_sigpending(&p->pending);
@@ -2282,7 +2285,7 @@ __latent_entropy struct task_struct *cop
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p);
 	if (retval)
-		goto bad_fork_cleanup_files;
+		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_fs;
@@ -2596,8 +2599,6 @@ bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
 	exit_fs(p); /* blocking */
-bad_fork_cleanup_files:
-	exit_files(p); /* blocking */
 bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_security:
@@ -2608,6 +2609,8 @@ bad_fork_cleanup_perf:
 	perf_event_free_task(p);
 bad_fork_sched_cancel_fork:
 	sched_cancel_fork(p);
+	/* ->release() of a file may need scx_fork_rwsem for write. */
+	exit_files(p); /* blocking */
 bad_fork_cleanup_policy:
 	lockdep_free_task(p);
 #ifdef CONFIG_NUMA


