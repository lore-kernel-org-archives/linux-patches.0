Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5051A76BB;
	Tue, 30 Jul 2024 17:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360073; cv=none; b=CJvD/ZTDXofUxiuBTF+wWIYM7LGLuEyNlG7ClX28dadAbUgUh5QdAjCEuLqSM86KHuKqXnTelU5vmRQc2thjNUAfNRwIgp+510msBdFMfR4eGWO7pfYvepLaWNU5PPSPFaNy7Rzeeuq8wI9Rhk02gh9FOYbccL0MaaNElfElr5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360073; c=relaxed/simple;
	bh=T2oZ7DP78vjR2DklgO8PMK9+F7jEXAhQQiJEgb9YM24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7CHOlC1FhMzM1iX4Lsg02sGwVOdl5GxeURvfO36+TMFlx4WlO9lA3pdjbsfPBQGlDeUcrA/CoLkrrwohYERn/nTXZ8uQimUBzLKAILoOAOPdFKzWrn8FSTEIxtwoIkH78ZoiQ41pLqzDBahsEh13zOrycacHdq4UdWOuYJEURE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebhIrSal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebhIrSal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7E8C32782;
	Tue, 30 Jul 2024 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360073;
	bh=T2oZ7DP78vjR2DklgO8PMK9+F7jEXAhQQiJEgb9YM24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebhIrSalNJG5dOs7MOYQXNfN8l3xsfwzxf/javr4eDO45l722QQYWo7JZAnseZFsZ
	 csOf1uzqJVc9qDA2GWmFRcwhX1XMTxlOZ1EQA0q5LP7HgwtdRta88JtlC2PK5Y52Xo
	 FMXgEv6YtQBPWjxmA2J1jaq7O5zMHtWNvbi/LtFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 587/809] task_work: s/task_work_cancel()/task_work_cancel_func()/
Date: Tue, 30 Jul 2024 17:47:43 +0200
Message-ID: <20240730151748.016045188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
@@ -30,7 +30,7 @@ int task_work_add(struct task_struct *ta
 
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
-struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
+struct callback_head *task_work_cancel_func(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1337,7 +1337,7 @@ static int irq_thread(void *data)
 	 * synchronize_hardirq(). So neither IRQTF_RUNTHREAD nor the
 	 * oneshot mask bit can be set.
 	 */
-	task_work_cancel(current, irq_thread_dtor);
+	task_work_cancel_func(current, irq_thread_dtor);
 	return 0;
 }
 
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -120,9 +120,9 @@ static bool task_work_func_match(struct
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
@@ -131,7 +131,7 @@ static bool task_work_func_match(struct
  * The found work or NULL if not found.
  */
 struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+task_work_cancel_func(struct task_struct *task, task_work_func_t func)
 {
 	return task_work_cancel_match(task, task_work_func_match, func);
 }
@@ -168,7 +168,7 @@ void task_work_run(void)
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


