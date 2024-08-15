Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955521A00CE;
	Thu, 15 Aug 2024 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729955; cv=none; b=lBjk862iwBhhrXmCKXoOBHx5k1iBBo0g4LMKIzB0gtM0VbEQiC7aMMIfREQwVxYMShCGa6dkLq9xJ015dwcj5WwWZ77gPsdYORQgSrFME9+Hhnauh8IM7FRIz0jD5+U1DjQTDUfbvnmrqWRjGFwPJpd1GjQPyluDRcwKbgL2EsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729955; c=relaxed/simple;
	bh=rr8N4lwjqwTEnsFktUwaGqPZuruSFZjUCXkaKRNjlPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYsnHsCy+ROrs1yOfZ+hdUjtJnJz3se0thXO07rPSHdeAj86rpngEQOOp15hd8oxODqxKFX6Ycy5WkjSW7UU04k47n2CjGkXzWwXbPe0mw6M4CgaoKPLYb35cxfsxYrf96HvB6HI+oW5h6zHvtw1g+NSzW5Wv1ULOp61AkuUI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ax55UNf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ax55UNf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EEDC32786;
	Thu, 15 Aug 2024 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729955;
	bh=rr8N4lwjqwTEnsFktUwaGqPZuruSFZjUCXkaKRNjlPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ax55UNf2Vm/8sww1dSjJxKv7bylUvAqXBSIKiNgnJKR4T/X0rMXqNOUJC0zfVDEEp
	 gzFdlJh6GqNM3vSPDRIWoK64cUSbieRD+AkIdgoc1TjJVWKNH6aUy1aIJgBzb17v7+
	 G5lvXRMBG/kt33Rwblq2UDBkw89GvyRPfd+VKPDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 259/484] kernel: rerun task_work while freezing in get_signal()
Date: Thu, 15 Aug 2024 15:21:57 +0200
Message-ID: <20240815131951.406775863@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 943ad0b62e3c21f324c4884caa6cb4a871bca05c upstream.

io_uring can asynchronously add a task_work while the task is getting
freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
do_freezer_trap(), and since the get_signal()'s relock loop doesn't
retry task_work, the task will spin there not being able to sleep
until the freezing is cancelled / the task is killed / etc.

Run task_works in the freezer path. Keep the patch small and simple
so it can be easily back ported, but we might need to do some cleaning
after and look if there are other places with similar problems.

Cc: stable@vger.kernel.org
Link: https://github.com/systemd/systemd/issues/33626
Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Julian Orth <ju.orth@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/89ed3a52933370deaaf61a0a620a6ac91f1e754d.1720634146.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/signal.h |    6 ++++++
 kernel/signal.c              |    8 ++++++++
 2 files changed, 14 insertions(+)

--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -347,6 +347,12 @@ extern void sigqueue_free(struct sigqueu
 extern int send_sigqueue(struct sigqueue *, struct pid *, enum pid_type);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 
+static inline void clear_notify_signal(void)
+{
+	clear_thread_flag(TIF_NOTIFY_SIGNAL);
+	smp_mb__after_atomic();
+}
+
 static inline int restart_syscall(void)
 {
 	set_tsk_thread_flag(current, TIF_SIGPENDING);
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2579,6 +2579,14 @@ static void do_freezer_trap(void)
 	spin_unlock_irq(&current->sighand->siglock);
 	cgroup_enter_frozen();
 	freezable_schedule();
+
+	/*
+	 * We could've been woken by task_work, run it to clear
+	 * TIF_NOTIFY_SIGNAL. The caller will retry if necessary.
+	 */
+	clear_notify_signal();
+	if (unlikely(READ_ONCE(current->task_works)))
+		task_work_run();
 }
 
 static int ptrace_signal(int signr, kernel_siginfo_t *info)


