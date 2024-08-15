Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D122772A;
	Thu, 15 Aug 2024 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732314; cv=none; b=tnjZoL0usswWu1xPAJ/jQSBUpdweXGroWOvgyoz2sCB4HNpOk7FZBB8JLJSwofkTLVipKpITPkyBWddPAGVuOjfMViM/J9NmcIXKtwWbzzG6nuv6D2MGx2fKJLRUEGGrDZwnhORoXVoA9MvkeLOxuWlvk9Jx5U8CribcGdkt2B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732314; c=relaxed/simple;
	bh=MzF0FVwVZRNJlMM+Y+smcHnTKZPgRqXru9DMd3zx+44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFEs2md3bBI4FItFNTILiuIc7suw2xD497EaiwpoKDV+PLcNuvkjlYCx3rjmNcXNdK2oCa21v0TNImUnmg6QFtsJ1dEjAHTUyplipsPqivm/YeWTbGN/oyUuu3WjouTDWri1jVNfzQRRaYf7koqepojlFfH0iemLnCYPazG1YXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGgk2Hsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGgk2Hsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3ADC32786;
	Thu, 15 Aug 2024 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732314;
	bh=MzF0FVwVZRNJlMM+Y+smcHnTKZPgRqXru9DMd3zx+44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGgk2Hshfet3ga1XJc1PiE17SnNWvZm03/WI/G1XiP0YwhCgjqtQQShIyG4MBGZ+y
	 ZcMGj6d6SKuka9kyzJZ3LKijww6eNmYhD5hBFZCtzq8L10Po5u3U5syVTxATH+UnSi
	 dIacXnx1dGrP/wjRKeJzmh0fVQS1Z3VxKtvmRKUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 141/352] task_work: Introduce task_work_cancel() again
Date: Thu, 15 Aug 2024 15:23:27 +0200
Message-ID: <20240815131924.709749252@linuxfoundation.org>
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

commit f409530e4db9dd11b88cb7703c97c8f326ff6566 upstream.

Re-introduce task_work_cancel(), this time to cancel an actual callback
and not *any* callback pointing to a given function. This is going to be
needed for perf events event freeing.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240621091601.18227-3-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/task_work.h |    1 +
 kernel/task_work.c        |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -25,6 +25,7 @@ int task_work_add(struct task_struct *ta
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
 struct callback_head *task_work_cancel_func(struct task_struct *, task_work_func_t);
+bool task_work_cancel(struct task_struct *task, struct callback_head *cb);
 void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -117,6 +117,30 @@ task_work_cancel_func(struct task_struct
 	return task_work_cancel_match(task, task_work_func_match, func);
 }
 
+static bool task_work_match(struct callback_head *cb, void *data)
+{
+	return cb == data;
+}
+
+/**
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @cb: the callback to remove if queued
+ *
+ * Remove a callback from a task's queue if queued.
+ *
+ * RETURNS:
+ * True if the callback was queued and got cancelled, false otherwise.
+ */
+bool task_work_cancel(struct task_struct *task, struct callback_head *cb)
+{
+	struct callback_head *ret;
+
+	ret = task_work_cancel_match(task, task_work_match, cb);
+
+	return ret == cb;
+}
+
 /**
  * task_work_run - execute the works added by task_work_add()
  *


