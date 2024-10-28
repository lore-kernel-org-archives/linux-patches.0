Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9F82C697;
	Mon, 28 Oct 2024 06:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097593; cv=none; b=BLbsnE8yvbVjW8FigoB3o49R4tHpExtW7MZJgEMVDqbgJf0Asv+NQbKE3VDFo9oyBPUKTQ7IzqkFqiqhw7EsQMLMLg18FewOnonr3HIsi5mAk5Sx3eaEgx4im+SD2diepeShJucLRBRj36axkIDqVmQfjESzmcHJmXbc8OKKncw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097593; c=relaxed/simple;
	bh=kjzkcrsXGZazM2n4foECDYm73fGNB8AFcMfsyT8aWWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hO8qO5Ivib3OFCILWc5TF6eQtQJDBroxwaIm+XXVXYwLyPAHqDtueSl15kMrDmrjP0LC4d8+hDmzI/7QAwaXHLk48JKRNdWD8zelCSE0RujSNvVzc4Z9POrZAgEOLaFleQzW6VVFR+VVxPKvz993cr3wD7q4qu55LTBEs1KpPwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpVCN6a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpVCN6a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF965C4CEC3;
	Mon, 28 Oct 2024 06:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097593;
	bh=kjzkcrsXGZazM2n4foECDYm73fGNB8AFcMfsyT8aWWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpVCN6a/UfPVl4d1ZYK+/Dfpq3XlfdrCbqUkV0isBZsbr56GyEO5SBhU3aJzGWak4
	 LHZ0VkyUZ9/80YeLaEQYfDChPnw7qkookvEzvEXSyKkwtU35s//A6Dpp9jqrQy/taC
	 Nt9bj8gPzGR7jUCVFAyLRRhSuEiUSkP3/orynC8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/208] task_work: Add TWA_NMI_CURRENT as an additional notify mode.
Date: Mon, 28 Oct 2024 07:23:25 +0100
Message-ID: <20241028062307.276124331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 466e4d801cd438a1ab2c8a2cce1bef6b65c31bbb ]

Adding task_work from NMI context requires the following:
- The kasan_record_aux_stack() is not NMU safe and must be avoided.
- Using TWA_RESUME is NMI safe. If the NMI occurs while the CPU is in
  userland then it will continue in userland and not invoke the `work'
  callback.

Add TWA_NMI_CURRENT as an additional notify mode. In this mode skip
kasan and use irq_work in hardirq-mode to for needed interrupt. Set
TIF_NOTIFY_RESUME within the irq_work callback due to k[ac]san
instrumentation in test_and_set_bit() which does not look NMI safe in
case of a report.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240704170424.1466941-3-bigeasy@linutronix.de
Stable-dep-of: 73ab05aa46b0 ("sched/core: Disable page allocation in task_tick_mm_cid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/task_work.h |  1 +
 kernel/task_work.c        | 24 +++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 26b8a47f41fca..cf5e7e891a776 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -18,6 +18,7 @@ enum task_work_notify_mode {
 	TWA_RESUME,
 	TWA_SIGNAL,
 	TWA_SIGNAL_NO_IPI,
+	TWA_NMI_CURRENT,
 };
 
 static inline bool task_work_pending(struct task_struct *task)
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 2134ac8057a94..5c2daa7ad3f90 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -1,10 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/irq_work.h>
 #include <linux/spinlock.h>
 #include <linux/task_work.h>
 #include <linux/resume_user_mode.h>
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+static void task_work_set_notify_irq(struct irq_work *entry)
+{
+	test_and_set_tsk_thread_flag(current, TIF_NOTIFY_RESUME);
+}
+static DEFINE_PER_CPU(struct irq_work, irq_work_NMI_resume) =
+	IRQ_WORK_INIT_HARD(task_work_set_notify_irq);
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -12,7 +20,7 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
  * @notify: how to notify the targeted task
  *
  * Queue @work for task_work_run() below and notify the @task if @notify
- * is @TWA_RESUME, @TWA_SIGNAL, or @TWA_SIGNAL_NO_IPI.
+ * is @TWA_RESUME, @TWA_SIGNAL, @TWA_SIGNAL_NO_IPI or @TWA_NMI_CURRENT.
  *
  * @TWA_SIGNAL works like signals, in that the it will interrupt the targeted
  * task and run the task_work, regardless of whether the task is currently
@@ -24,6 +32,8 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
  * kernel anyway.
  * @TWA_RESUME work is run only when the task exits the kernel and returns to
  * user mode, or before entering guest mode.
+ * @TWA_NMI_CURRENT works like @TWA_RESUME, except it can only be used for the
+ * current @task and if the current context is NMI.
  *
  * Fails if the @task is exiting/exited and thus it can't process this @work.
  * Otherwise @work->func() will be called when the @task goes through one of
@@ -44,8 +54,13 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 {
 	struct callback_head *head;
 
-	/* record the work call stack in order to print it in KASAN reports */
-	kasan_record_aux_stack(work);
+	if (notify == TWA_NMI_CURRENT) {
+		if (WARN_ON_ONCE(task != current))
+			return -EINVAL;
+	} else {
+		/* record the work call stack in order to print it in KASAN reports */
+		kasan_record_aux_stack(work);
+	}
 
 	head = READ_ONCE(task->task_works);
 	do {
@@ -66,6 +81,9 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 	case TWA_SIGNAL_NO_IPI:
 		__set_notify_signal(task);
 		break;
+	case TWA_NMI_CURRENT:
+		irq_work_queue(this_cpu_ptr(&irq_work_NMI_resume));
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
-- 
2.43.0



