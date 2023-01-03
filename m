Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F2820E4
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76264C433D2;
	Tue,  3 Jan 2023 08:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733853;
	bh=esacNnzxQRb2jx2AjNkz5pWbeR/+vKrJ/+xrTrO08Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3+i1jNrZobbG1YI0zZGuPIx8oCj8aSIJCYKegbY43yNLXETLFJJzoynmxBBynWUj
	 krGkzc9ruY9skLeflSI5ZM2CngrDwEOJj28/Hu/SutFZIQSdkgcCw+Og6g6r7sImVR
	 7vQwaiIM5Z1ftJotY3kBjzaSAqDOW1poZZO5E4hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 44/63] task_work: remove legacy TWA_SIGNAL path
Date: Tue,  3 Jan 2023 09:14:14 +0100
Message-Id: <20230103081311.234865543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 03941ccfda161c2680147fa5ab92aead2a79cac1 ]

All archs now support TIF_NOTIFY_SIGNAL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/task_work.c |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,34 +5,6 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
-/*
- * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
- * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
- * shared for threads, and can cause contention on sighand->lock. Even for
- * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
- * or IRQ disabling is involved for notification (or running) purposes.
- */
-static void task_work_notify_signal(struct task_struct *task)
-{
-#if defined(TIF_NOTIFY_SIGNAL)
-	set_notify_signal(task);
-#else
-	unsigned long flags;
-
-	/*
-	 * Only grab the sighand lock if we don't already have some
-	 * task_work pending. This pairs with the smp_store_mb()
-	 * in get_signal(), see comment there.
-	 */
-	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
-	    lock_task_sighand(task, &flags)) {
-		task->jobctl |= JOBCTL_TASK_WORK;
-		signal_wake_up(task, 0);
-		unlock_task_sighand(task, &flags);
-	}
-#endif
-}
-
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -76,7 +48,7 @@ int task_work_add(struct task_struct *ta
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		task_work_notify_signal(task);
+		set_notify_signal(task);
 		break;
 	default:
 		WARN_ON_ONCE(1);


