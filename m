Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03B8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C7CC433C8;
	Sun, 16 Jul 2023 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540977;
	bh=TWu0evTuPxw936WiDTsRfIjShbqTRbY34OcOiEIALVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNol2IlHsxOExcSCE6tJirKi4a6x25P5Nknjk1KLBXMpFuiAsHapwXHz8N/0EDsmX
	 aPWhKNPr/djNXJs8b+RdmEAl79LJ52Crd89A1J8eDxZf+Ua46nRmDKFzBIgX9uSrOa
	 KKz8uS+EF3Xs95c1xIGWkw4jz8dP7yqYg2da14wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 528/591] io_uring: wait interruptibly for request completions on exit
Date: Sun, 16 Jul 2023 21:51:07 +0200
Message-ID: <20230716194937.532775800@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

commit 4826c59453b3b4677d6bf72814e7ababdea86949 upstream.

WHen the ring exits, cleanup is done and the final cancelation and
waiting on completions is done by io_ring_exit_work. That function is
invoked by kworker, which doesn't take any signals. Because of that, it
doesn't really matter if we wait for completions in TASK_INTERRUPTIBLE
or TASK_UNINTERRUPTIBLE state. However, it does matter to the hung task
detection checker!

Normally we expect cancelations and completions to happen rather
quickly. Some test cases, however, will exit the ring and park the
owning task stopped (eg via SIGSTOP). If the owning task needs to run
task_work to complete requests, then io_ring_exit_work won't make any
progress until the task is runnable again. Hence io_ring_exit_work can
trigger the hung task detection, which is particularly problematic if
panic-on-hung-task is enabled.

As the ring exit doesn't take signals to begin with, have it wait
interruptibly rather than uninterruptibly. io_uring has a separate
stuck-exit warning that triggers independently anyway, so we're not
really missing anything by making this switch.

Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/r/b0e4aaef-7088-56ce-244c-976edeac0e66@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2748,7 +2748,18 @@ static __cold void io_ring_exit_work(str
 			/* there is little hope left, don't run it too often */
 			interval = HZ * 60;
 		}
-	} while (!wait_for_completion_timeout(&ctx->ref_comp, interval));
+		/*
+		 * This is really an uninterruptible wait, as it has to be
+		 * complete. But it's also run from a kworker, which doesn't
+		 * take signals, so it's fine to make it interruptible. This
+		 * avoids scenarios where we knowingly can wait much longer
+		 * on completions, for example if someone does a SIGSTOP on
+		 * a task that needs to finish task_work to make this loop
+		 * complete. That's a synthetic situation that should not
+		 * cause a stuck task backtrace, and hence a potential panic
+		 * on stuck tasks if that is enabled.
+		 */
+	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
 
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
@@ -2772,7 +2783,12 @@ static __cold void io_ring_exit_work(str
 			continue;
 
 		mutex_unlock(&ctx->uring_lock);
-		wait_for_completion(&exit.completion);
+		/*
+		 * See comment above for
+		 * wait_for_completion_interruptible_timeout() on why this
+		 * wait is marked as interruptible.
+		 */
+		wait_for_completion_interruptible(&exit.completion);
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);


