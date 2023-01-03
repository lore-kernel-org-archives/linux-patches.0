Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7593138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0891DC433EF;
	Tue,  3 Jan 2023 08:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733685;
	bh=WrITttZLO5V+0lo8B9AbuyeYnmdsLHKoPkvbSKiHbxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QctnJ+BnKUVPEzv/nY0LVaQeNDrvEUemjFY81SpItc8DftckxcVSHmgPW5NIzyqPc
	 mhwnKcvQ66O6SsQdtJI8KoPsHcFrZgkrG/xlErbBqTbqsbIyjFRMhPNmQRwvhBdQBj
	 CSriWrYzRan3p4pne68p3/B44m+LY71TMwjDMRew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 01/63] kernel: provide create_io_thread() helper
Date: Tue,  3 Jan 2023 09:13:31 +0100
Message-Id: <20230103081308.640079585@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cc440e8738e5c875297ac0e90316745093be7e28 ]

Provide a generic helper for setting up an io_uring worker. Returns a
task_struct so that the caller can do whatever setup is needed, then call
wake_up_new_task() to kick it into gear.

Add a kernel_clone_args member, io_thread, which tells copy_process() to
mark the task with PF_IO_WORKER.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/task.h |    2 ++
 kernel/fork.c              |   30 ++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -31,6 +31,7 @@ struct kernel_clone_args {
 	/* Number of elements in *set_tid */
 	size_t set_tid_size;
 	int cgroup;
+	int io_thread;
 	struct cgroup *cgrp;
 	struct css_set *cset;
 };
@@ -85,6 +86,7 @@ extern void exit_files(struct task_struc
 extern void exit_itimers(struct task_struct *);
 
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
+struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1949,6 +1949,8 @@ static __latent_entropy struct task_stru
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	if (args->io_thread)
+		p->flags |= PF_IO_WORKER;
 
 	/*
 	 * This _must_ happen before we call free_task(), i.e. before we jump
@@ -2416,6 +2418,34 @@ struct mm_struct *copy_init_mm(void)
 }
 
 /*
+ * This is like kernel_clone(), but shaved down and tailored to just
+ * creating io_uring workers. It returns a created task, or an error pointer.
+ * The returned task is inactive, and the caller must fire it up through
+ * wake_up_new_task(p). All signals are blocked in the created task.
+ */
+struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
+{
+	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
+				CLONE_IO;
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.stack		= (unsigned long)fn,
+		.stack_size	= (unsigned long)arg,
+		.io_thread	= 1,
+	};
+	struct task_struct *tsk;
+
+	tsk = copy_process(NULL, 0, node, &args);
+	if (!IS_ERR(tsk)) {
+		sigfillset(&tsk->blocked);
+		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
+	}
+	return tsk;
+}
+
+/*
  *  Ok, this is the main fork-routine.
  *
  * It copies the process, and if successful kick-starts


