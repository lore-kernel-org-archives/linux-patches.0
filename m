Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A367D1A6192;
	Tue, 30 Jul 2024 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358964; cv=none; b=PrqQCODdGkBgNcaRnN/z+KhVvK7tvWJGRTpMZWAw+4i3bNmYAuPkEWhoxbPaB/h7RslUcKaYtmVU0PeLHVcv0ToxZd3e9ZfP96G1KTA+6Uz1BK9x+hgf73/J4BwH3RDmbmytuR8Pxxju+Vmn0jN++W6xmds31C9hrP5EW0jqRY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358964; c=relaxed/simple;
	bh=OYz34V+aBG480dW1uXr5NT1oKL4dfC4kQoWhZ8NQ//U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTN1pgrTeO7gMLKf9CxkJw94U+avCpZpDYIL615NbiOvcFdqLi28k0X+1tJ9CygXorQ9atzHQ5svr6vzMGPoDf68JhocZMVpHueD2VeyIZskF4QRb+tALBAOuolmj930jhudVcCDTvdvcDmYo0OmVXcWnixStIgde09wUqwtJlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDMhfIUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDMhfIUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F2C32782;
	Tue, 30 Jul 2024 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358964;
	bh=OYz34V+aBG480dW1uXr5NT1oKL4dfC4kQoWhZ8NQ//U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDMhfIUmSpGO0UUuLZ7LfMnOJB+GTYmEyDbIhM1JcWdtYsJtoaH85p9kWhBX+62iV
	 WaOKgPrpbRSTHvGHhe83SYEXmoEUfodRNqX2KTWyXclYSEvOAfZ6YQchACT/Y9cLFY
	 fEeTLyH5fAcgt7YGdl0WFDHoeet2Y/WReouQKnYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 394/568] task_work: Introduce task_work_cancel() again
Date: Tue, 30 Jul 2024 17:48:21 +0200
Message-ID: <20240730151655.262908073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
@@ -31,6 +31,7 @@ int task_work_add(struct task_struct *ta
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
 struct callback_head *task_work_cancel_func(struct task_struct *, task_work_func_t);
+bool task_work_cancel(struct task_struct *task, struct callback_head *cb);
 void task_work_run(void);
 
 static inline void exit_task_work(struct task_struct *task)
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -136,6 +136,30 @@ task_work_cancel_func(struct task_struct
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


