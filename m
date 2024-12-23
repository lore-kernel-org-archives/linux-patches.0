Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F611BBBEE;
	Mon, 23 Dec 2024 16:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970844; cv=none; b=ilKRVmhEQeHWhHoRcLzevQCv2yKAFjtbYyAJFqHW/cv7tdoh2Q9Pr3WsTThdowU0zwx0AEP5Z+YYnSJAYmPzwgJVEvPMT7uhmERJxBmAc/g6NweXj8oAshNINB8l9RDIiiqnLtvYk62ACRjKCZmcN0LGNhEDH+/Ig8P1qYyUQyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970844; c=relaxed/simple;
	bh=+xh5w9aZBjaKSue1qs48gHlTIXOXGaXb4BdsYXUZpPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1IFfIUqkUfyF1hulW5hn4soXM0Pm7Cj+lw5LTIMkgwRQOVOERZJ/VfFLp5nx4Tcu8jWO7Bp+nNOal2qQNa2o6rgasrOObo3NdIG1BM1BhK1lBRB1Lh6vrIeJTYa7kvbOOdx82aaQKJ42qPvTVAA3Jq0P8+4pRc1H+XN1MXSJ1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNIz63+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNIz63+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B957CC4CED7;
	Mon, 23 Dec 2024 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970844;
	bh=+xh5w9aZBjaKSue1qs48gHlTIXOXGaXb4BdsYXUZpPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNIz63+ccGlqYjD+4c0jehckyHpfSGoy6ggU3X/2rFqe6vBKibxPFM8POMPvTsMqa
	 T5OYPaViTaX3Lk3fYSEJNJ7BDHDNas8rW3VYe+3dAbhKp0K7oI5PvzDqmATMWHBKRj
	 UVxMGYDGv/i98ldOb4aIccnhxAc0ukJuq7QPiGrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will <willsroot@protonmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 67/83] io_uring: check if iowq is killed before queuing
Date: Mon, 23 Dec 2024 16:59:46 +0100
Message-ID: <20241223155356.220129272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit dbd2ca9367eb19bc5e269b8c58b0b1514ada9156 upstream.

task work can be executed after the task has gone through io_uring
termination, whether it's the final task_work run or the fallback path.
In this case, task work will find ->io_wq being already killed and
null'ed, which is a problem if it then tries to forward the request to
io_queue_iowq(). Make io_queue_iowq() fail requests in this case.

Note that it also checks PF_KTHREAD, because the user can first close
a DEFER_TASKRUN ring and shortly after kill the task, in which case
->iowq check would race.

Cc: stable@vger.kernel.org
Fixes: 50c52250e2d74 ("block: implement async io_uring discard cmd")
Fixes: 773af69121ecc ("io_uring: always reissue from task_work context")
Reported-by: Will <willsroot@protonmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/63312b4a2c2bb67ad67b857d17a300e1d3b078e8.1734637909.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -440,7 +440,11 @@ void io_queue_iowq(struct io_kiocb *req,
 	struct io_uring_task *tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
-	BUG_ON(!tctx->io_wq);
+
+	if ((current->flags & PF_KTHREAD) || !tctx->io_wq) {
+		io_req_task_queue_fail(req, -ECANCELED);
+		return;
+	}
 
 	/* init ->work of the whole link before punting */
 	io_prep_async_link(req);


