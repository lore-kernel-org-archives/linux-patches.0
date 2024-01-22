Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48C6745F2;
	Tue, 23 Jan 2024 02:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975458; cv=none; b=o+NqUTiMrlM0uhv32l07CUzwkOPJ2dkMqNdLg8FWE6crr4iHQ4EJCAsmThLkVFoy/01INvH4MZFPc6nTdWfVuOfTLMLbimHfa0Nhhb3rm2fQ5cDyiEwTG52A5FPa7APh4lbRb7uaErenEHg3xqixZv/Kt5XKCD4WNLPe/M3HrNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975458; c=relaxed/simple;
	bh=zKaEJDmFzjA8SRzGqj367ri58R7eAtMx2wEYzs6yNNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9lEfmF5wAGEHKjhyX1zY9Wvgrddnq4PDFlZg31zdGzbBCoc2J9e8RL54HBULUaSztfB7wDdjPu3Myw8e0EBnneI51neISB9z/j39HlleeSrReM6gyE82LBNg/xuk+7lyE7gohd4s50aBXa3TKCocitwggrmAYelPwJrg4vXvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1WfBKz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1WfBKz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C35C43390;
	Tue, 23 Jan 2024 02:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975458;
	bh=zKaEJDmFzjA8SRzGqj367ri58R7eAtMx2wEYzs6yNNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1WfBKz3e42+LVGu6P5toBixcqu6zXc7kab2/ZSp3DqRpvE7qzPn1p9GHHpZR7z/H
	 F/nPYsfixL3XiScmf12z3OTiEgRlpyDletve6fg6jlCmLuz9iiy16uhltCB2KTXZLH
	 L+9FPu/rveiBuqBYvGA+w6nR8G5vY08hODNSX34M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 390/583] io_uring: ensure local task_work is run on wait timeout
Date: Mon, 22 Jan 2024 15:57:21 -0800
Message-ID: <20240122235823.919922980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 6ff1407e24e6fdfa4a16ba9ba551e3d253a26391 upstream.

A previous commit added an earlier break condition here, which is fine if
we're using non-local task_work as it'll be run on return to userspace.
However, if DEFER_TASKRUN is used, then we could be leaving local
task_work that is ready to process in the ctx list until next time that
we enter the kernel to wait for events.

Move the break condition to _after_ we have run task_work.

Cc: stable@vger.kernel.org
Fixes: 846072f16eed ("io_uring: mimimise io_cqring_wait_schedule")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2630,8 +2630,6 @@ static int io_cqring_wait(struct io_ring
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, 0);
 
-		if (ret < 0)
-			break;
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
@@ -2641,6 +2639,18 @@ static int io_cqring_wait(struct io_ring
 		if (!llist_empty(&ctx->work_llist))
 			io_run_local_work(ctx);
 
+		/*
+		 * Non-local task_work will be run on exit to userspace, but
+		 * if we're using DEFER_TASKRUN, then we could have waited
+		 * with a timeout for a number of requests. If the timeout
+		 * hits, we could have some requests ready to process. Ensure
+		 * this break is _after_ we have run task_work, to avoid
+		 * deferring running potentially pending requests until the
+		 * next time we wait for events.
+		 */
+		if (ret < 0)
+			break;
+
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */


