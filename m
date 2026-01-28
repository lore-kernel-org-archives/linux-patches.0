Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AC213B7A3;
	Wed, 28 Jan 2026 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614286; cv=none; b=oTwfnrjYj/2DlQN9iVlQhQugGb/T4z1Dfhly79SadcDhPNGe7a8pKD0l9poDgV+gYNZj8e46dD4ExJ8URLtQHlpG6AwfAvboxZDNIF3NgSfnNq8SOSTfTmJydr5X729Q8IKTAp0wQCQQgHW2JVVYy4ipxZyOETTROpH4197gtgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614286; c=relaxed/simple;
	bh=RSFgrDwGq8SiGLkrbj6qifFmkcwlZBzF1cCPYaFhcOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg6c8RvdtnsfcablZ50F9ZFwRh6vYlbXF+mmz52816fkbNJ3gX2Xa0HZW+OPz0quu3P8Ux65Xlbr+1LYVJ6aREtPylM0oixq8QvFp8CP56TRZSd4NptRNOOWbshoMj1uqR4C9f+xP8wWZe7dlXBTeIVM85bbXvJC9UP5bPhuNuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okNQtb0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okNQtb0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3518C4CEF1;
	Wed, 28 Jan 2026 15:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614286;
	bh=RSFgrDwGq8SiGLkrbj6qifFmkcwlZBzF1cCPYaFhcOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okNQtb0AJU+Nt6CoeGcnfssbdeo2Relhb2NwlTc+WMK652b0+A0Tn7QXQIFH9jsUk
	 xW9M5yS4kMnNZYzc1vMeJH08b5mg5E6lBtxsiWdjLRR4W8eoBXU7hxL+VUTEkldt/A
	 4GIXJRmvpw2Pum3TnqNwfnoFQr+iKOyl3Raoopes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 090/254] io_uring: move local task_work in exit cancel loop
Date: Wed, 28 Jan 2026 16:21:06 +0100
Message-ID: <20260128145348.067899369@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ming Lei <ming.lei@redhat.com>

commit da579f05ef0faada3559e7faddf761c75cdf85e1 upstream.

With IORING_SETUP_DEFER_TASKRUN, task work is queued to ctx->work_llist
(local work) rather than the fallback list. During io_ring_exit_work(),
io_move_task_work_from_local() was called once before the cancel loop,
moving work from work_llist to fallback_llist.

However, task work can be added to work_llist during the cancel loop
itself. There are two cases:

1) io_kill_timeouts() is called from io_uring_try_cancel_requests() to
cancel pending timeouts, and it adds task work via io_req_queue_tw_complete()
for each cancelled timeout:

2) URING_CMD requests like ublk can be completed via
io_uring_cmd_complete_in_task() from ublk_queue_rq() during canceling,
given ublk request queue is only quiesced when canceling the 1st uring_cmd.

Since io_allowed_defer_tw_run() returns false in io_ring_exit_work()
(kworker != submitter_task), io_run_local_work() is never invoked,
and the work_llist entries are never processed. This causes
io_uring_try_cancel_requests() to loop indefinitely, resulting in
100% CPU usage in kworker threads.

Fix this by moving io_move_task_work_from_local() inside the cancel
loop, ensuring any work on work_llist is moved to fallback before
each cancel attempt.

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3191,11 +3191,11 @@ static __cold void io_ring_exit_work(str
 			mutex_unlock(&ctx->uring_lock);
 		}
 
-		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-			io_move_task_work_from_local(ctx);
-
-		while (io_uring_try_cancel_requests(ctx, NULL, true))
+		do {
+			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+				io_move_task_work_from_local(ctx);
 			cond_resched();
+		} while (io_uring_try_cancel_requests(ctx, NULL, true));
 
 		if (ctx->sq_data) {
 			struct io_sq_data *sqd = ctx->sq_data;


