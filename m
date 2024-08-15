Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555F7210FB;
	Thu, 15 Aug 2024 14:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732311; cv=none; b=APlrJxyTqP1P2+9aHPao1XL+yc55+rbWYmZWTGTpS4BI2oeG7iBOTl3TgV3gp6M6C0cQxVut3V7g3jHyFMzauG6XDVwIB4luIzJfQJ0ZlI1AJZkaKOZbEnhd9MzL22+pMqZYH8cp7VI5+HAO0yS2G6L31HHgQNtYC4haKpj2xkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732311; c=relaxed/simple;
	bh=E43/fLbzkgk1R6PKSBnI1nup9ifA/MhOsbQpzHKJj/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ul0rQKsQ8v6kreHD5f+tpoYH7nQJx6e9r/hQzFGxh0T6SvPY0uh5jISlExXYEJ8x3+EhrSzVp+HMo9F0cyFAj5mNP/B2N2hmOHqdqjVBWl7W3SFMSm/GnDDrQxdvD3S4RjAZtA0bSO7VRMs//N6C+tOQ1G2SyW8dqsuQqplBNb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUVcjTJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUVcjTJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A93C32786;
	Thu, 15 Aug 2024 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732311;
	bh=E43/fLbzkgk1R6PKSBnI1nup9ifA/MhOsbQpzHKJj/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUVcjTJQm6LSSEFDnv38QEBabIAKKRqXKZI49n8qeSr5RemzeX+VRabUCHPdQTpAF
	 E8/CuVWGtMmQXaPx3w5ysOIa+peF3+tIU2Sw0FPiUNk26ZEvrd1iXq6oz2CEutcdLA
	 R76jPPmH7zkYoP7jJg+N6kMMMTzC2tIEpDgbmaCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 140/352] task_work: s/task_work_cancel()/task_work_cancel_func()/
Date: Thu, 15 Aug 2024 15:23:26 +0200
Message-ID: <20240815131924.671692602@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit 68cbd415dd4b9c5b9df69f0f091879e56bf5907a upstream.

A proper task_work_cancel() API that actually cancels a callback and not
*any* callback pointing to a given function is going to be needed for
perf events event freeing. Do the appropriate rename to prepare for
that.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240621091601.18227-2-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/task_work.h |    2 +-
 kernel/irq/manage.c       |    2 +-
 kernel/task_work.c        |   10 +++++-----
 security/keys/keyctl.c    |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -24,7 +24,7 @@ int task_work_add(struct task_struct *ta
 
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
-struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
+struct callback_head *task_work_cancel_func(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1230,7 +1230,7 @@ static int irq_thread(void *data)
 	 * synchronize_hardirq(). So neither IRQTF_RUNTHREAD nor the
 	 * oneshot mask bit can be set.
 	 */
-	task_work_cancel(current, irq_thread_dtor);
+	task_work_cancel_func(current, irq_thread_dtor);
 	return 0;
 }
 
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -101,9 +101,9 @@ static bool task_work_func_match(struct
 }
 
 /**
- * task_work_cancel - cancel a pending work added by task_work_add()
- * @task: the task which should execute the work
- * @func: identifies the work to remove
+ * task_work_cancel_func - cancel a pending work matching a function added by task_work_add()
+ * @task: the task which should execute the func's work
+ * @func: identifies the func to match with a work to remove
  *
  * Find the last queued pending work with ->func == @func and remove
  * it from queue.
@@ -112,7 +112,7 @@ static bool task_work_func_match(struct
  * The found work or NULL if not found.
  */
 struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+task_work_cancel_func(struct task_struct *task, task_work_func_t func)
 {
 	return task_work_cancel_match(task, task_work_func_match, func);
 }
@@ -149,7 +149,7 @@ void task_work_run(void)
 		if (!work)
 			break;
 		/*
-		 * Synchronize with task_work_cancel(). It can not remove
+		 * Synchronize with task_work_cancel_match(). It can not remove
 		 * the first entry == work, cmpxchg(task_works) must fail.
 		 * But it can remove another entry from the ->next list.
 		 */
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1694,7 +1694,7 @@ long keyctl_session_to_parent(void)
 		goto unlock;
 
 	/* cancel an already pending keyring replacement */
-	oldwork = task_work_cancel(parent, key_change_session_keyring);
+	oldwork = task_work_cancel_func(parent, key_change_session_keyring);
 
 	/* the replacement session keyring is applied just prior to userspace
 	 * restarting */


