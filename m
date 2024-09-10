Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A01217BB01;
	Tue, 10 Sep 2024 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961708; cv=none; b=uO8ZVJWLpwoOPcAazn0I6NRwCFITe5deixKVCz76xWKp1B6a/trB6PTTG8175Ch3SlSF27CS2Xcn22KMRzde6pqLVmyStBBaYjdFcQW5zakCScVODbQP3D0yhrKSA14++aSl1BPpmzeODWI70hRDmO6bDUmTDwZ0jxrDWlkjww4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961708; c=relaxed/simple;
	bh=C01R6YXnuhXtvcSjAvgSc3whoGn4l0+OxFcQpr5p0Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otNjwtLYKd8U+QrX+OBD24/HAlNmkzlNE0z83ga+P/Uij3m5K/Gt+iofKPU0G+aFq8mAKmepzVILYDQX5Ktf6zUXLHuRkCzEdFWLNGGM8C/vzS8hxUtF5M4Qydsb2c8MKYOzxKUxi8iqk+AkqITWGUoWGyCZNHCRJzq5ViOrxII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGt6jzwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGt6jzwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002C1C4CEC3;
	Tue, 10 Sep 2024 09:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961708;
	bh=C01R6YXnuhXtvcSjAvgSc3whoGn4l0+OxFcQpr5p0Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGt6jzwU3r/Fji+dB0Lx6z/CQ/18GtAZxrQK2/vOtJ4CByKAuOChj3L/tFBqYg+lY
	 0JcQB+wxjMmwa5kaMcI/dRNtZaqAszZM+vt+eoR7zVjdjjBNP9dDV8e6Ck3nUpy414
	 qTEoVaECKTSi1PahRzmM6OoQr5UZPjOAL5JXs950=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Tycho Andersen <tandersen@netflix.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 135/375] seccomp: release task filters when the task exits
Date: Tue, 10 Sep 2024 11:28:52 +0200
Message-ID: <20240910092626.977719241@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Vagin <avagin@google.com>

[ Upstream commit bfafe5efa9754ebc991750da0bcca2a6694f3ed3 ]

Previously, seccomp filters were released in release_task(), which
required the process to exit and its zombie to be collected. However,
exited threads/processes can't trigger any seccomp events, making it
more logical to release filters upon task exits.

This adjustment simplifies scenarios where a parent is tracing its child
process. The parent process can now handle all events from a seccomp
listening descriptor and then call wait to collect a child zombie.

seccomp_filter_release takes the siglock to avoid races with
seccomp_sync_threads. There was an idea to bypass taking the lock by
checking PF_EXITING, but it can be set without holding siglock if
threads have SIGNAL_GROUP_EXIT. This means it can happen concurently
with seccomp_filter_release.

This change also fixes another minor problem. Suppose that a group
leader installs the new filter without SECCOMP_FILTER_FLAG_TSYNC, exits,
and becomes a zombie. Without this change, SECCOMP_FILTER_FLAG_TSYNC
from any other thread can never succeed, seccomp_can_sync_threads() will
check a zombie leader and is_ancestor() will fail.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
Link: https://lore.kernel.org/r/20240628021014.231976-3-avagin@google.com
Reviewed-by: Tycho Andersen <tandersen@netflix.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/exit.c    |  3 ++-
 kernel/seccomp.c | 23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 81fcee45d630..be81342caf1b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -277,7 +277,6 @@ void release_task(struct task_struct *p)
 	}
 
 	write_unlock_irq(&tasklist_lock);
-	seccomp_filter_release(p);
 	proc_flush_pid(thread_pid);
 	put_pid(thread_pid);
 	release_thread(p);
@@ -834,6 +833,8 @@ void __noreturn do_exit(long code)
 	io_uring_files_cancel();
 	exit_signals(tsk);  /* sets PF_EXITING */
 
+	seccomp_filter_release(tsk);
+
 	acct_update_integrals(tsk);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e30b60b57614..b02337e95664 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -502,6 +502,9 @@ static inline pid_t seccomp_can_sync_threads(void)
 		/* Skip current, since it is initiating the sync. */
 		if (thread == caller)
 			continue;
+		/* Skip exited threads. */
+		if (thread->flags & PF_EXITING)
+			continue;
 
 		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
 		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
@@ -563,18 +566,21 @@ static void __seccomp_filter_release(struct seccomp_filter *orig)
  * @tsk: task the filter should be released from.
  *
  * This function should only be called when the task is exiting as
- * it detaches it from its filter tree. As such, READ_ONCE() and
- * barriers are not needed here, as would normally be needed.
+ * it detaches it from its filter tree. PF_EXITING has to be set
+ * for the task.
  */
 void seccomp_filter_release(struct task_struct *tsk)
 {
-	struct seccomp_filter *orig = tsk->seccomp.filter;
+	struct seccomp_filter *orig;
 
-	/* We are effectively holding the siglock by not having any sighand. */
-	WARN_ON(tsk->sighand != NULL);
+	if (WARN_ON((tsk->flags & PF_EXITING) == 0))
+		return;
 
+	spin_lock_irq(&tsk->sighand->siglock);
+	orig = tsk->seccomp.filter;
 	/* Detach task from its filter tree. */
 	tsk->seccomp.filter = NULL;
+	spin_unlock_irq(&tsk->sighand->siglock);
 	__seccomp_filter_release(orig);
 }
 
@@ -602,6 +608,13 @@ static inline void seccomp_sync_threads(unsigned long flags)
 		if (thread == caller)
 			continue;
 
+		/*
+		 * Skip exited threads. seccomp_filter_release could have
+		 * been already called for this task.
+		 */
+		if (thread->flags & PF_EXITING)
+			continue;
+
 		/* Get a task reference for the new leaf node. */
 		get_seccomp_filter(caller);
 
-- 
2.43.0



