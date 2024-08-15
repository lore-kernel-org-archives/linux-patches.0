Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D8A7DA9E;
	Thu, 15 Aug 2024 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729726; cv=none; b=qMBf/HsoaTwzaCFvpPn1XYAiKcLruJdBQC3qJbUHZez1zm/XFKV+Nb1HoqbqpV5+GjV4p/YZ2Jq9yIKomIVlXSYRLkVCAWvMqBb5+ShvsGAOQiSidVASzAcunV9tWSHXpU/BX3YKZ5QCGMvM1+6Z9RPkdU05iLcVx/OOYYpq8Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729726; c=relaxed/simple;
	bh=tUA4HSJ/fCeJr8Y68NozHG+Y/vGog+mcst38qenhz/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXAzLh6jglVDgTWsItUWRKLoKqD/VYxaows32IFCAC1vAuEFyH1aldXjYZTzli2aDJG3HYScKWZet3+CDuhTANE0C2Cx5vC4a0ULY9gAcU8mD0DGcRFGagA+MetGo4irHFFnw2vStGyGKdwy6bxB6VKYMUBVMcUP5VsmZVfzl8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAoFJ5d4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAoFJ5d4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B61C32786;
	Thu, 15 Aug 2024 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729726;
	bh=tUA4HSJ/fCeJr8Y68NozHG+Y/vGog+mcst38qenhz/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAoFJ5d4uDasbC0ovZpNg647j8ff6Nku5QHKaTKI2zSPnFmmsGyE3VaaiCE/gYN/3
	 JHVM+7wWtJu7YW2xtqQMBmvmuFkeaA9AgRGyWopsTYVhrvQB1CNELoRMEw0J+EuHZr
	 EkpBEePCY+3cVjbTS7uNRDG3hlew1KuNlb9V+hjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 188/484] task_work: s/task_work_cancel()/task_work_cancel_func()/
Date: Thu, 15 Aug 2024 15:20:46 +0200
Message-ID: <20240815131948.676491732@linuxfoundation.org>
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
@@ -1330,7 +1330,7 @@ static int irq_thread(void *data)
 	 * synchronize_hardirq(). So neither IRQTF_RUNTHREAD nor the
 	 * oneshot mask bit can be set.
 	 */
-	task_work_cancel(current, irq_thread_dtor);
+	task_work_cancel_func(current, irq_thread_dtor);
 	return 0;
 }
 
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -104,9 +104,9 @@ static bool task_work_func_match(struct
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
@@ -115,7 +115,7 @@ static bool task_work_func_match(struct
  * The found work or NULL if not found.
  */
 struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+task_work_cancel_func(struct task_struct *task, task_work_func_t func)
 {
 	return task_work_cancel_match(task, task_work_func_match, func);
 }
@@ -152,7 +152,7 @@ void task_work_run(void)
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


