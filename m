Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08B7DA9E;
	Thu, 15 Aug 2024 13:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729730; cv=none; b=nTtz+SLKIqeVxRx0mj9aKXY/qMbIy+omd7Wnnbd/h9740p5wbCdVIFxAKleUuPwLcptMvmalDhIV7FY9BCbh1c1Tr64aBsSz0S2PAqgY0sqYdfHT8Jtneyxv1oLTYyxtjwBObbxTCn68ixNAUoAm/oyb4w7ROrJ3q96JPyAYotM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729730; c=relaxed/simple;
	bh=63uSHxT13Q12G1YQTVBzdkG5bvFTGrCMfZ1Te67CdmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqHzSaloFVgclx8cjtxmX5P59zQzfMmDloYjREbH783MSvkZPwGd627XuBKXpbBRLduLlg3J7ErLS4g6aKIczdx9U8rpeLOBwqRNV6GTEziSuSvj/DvSKrYjs5252tFTYKzi3U4yIrRY7TeXSkqsa1jrGeK04J7EoJ3UAVFiwbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y69+E0CZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y69+E0CZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA7BC32786;
	Thu, 15 Aug 2024 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729729;
	bh=63uSHxT13Q12G1YQTVBzdkG5bvFTGrCMfZ1Te67CdmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y69+E0CZiI0w3OnQ7DjoLf1hUu83y9lhpLkJKqjQDm8buo1w62meffLL3nzGAuPHy
	 2wQ8PALdV7zydhVvIoPbD7RgoW8MpCh84V2i0B/8lOc2BwGVJbHAc3qvV7dWrTn27j
	 1OEdTLPL7No6gKNyS0kuwjiWjOoFkFgGpOff/XUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 189/484] task_work: Introduce task_work_cancel() again
Date: Thu, 15 Aug 2024 15:20:47 +0200
Message-ID: <20240815131948.713980005@linuxfoundation.org>
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
@@ -120,6 +120,30 @@ task_work_cancel_func(struct task_struct
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


