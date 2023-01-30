Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E37328EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C936AC4339B;
	Mon, 30 Jan 2023 14:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087555;
	bh=KuzU3Yrb8LHAcq2AnsOQ30vhxfHViegiJW7XXM+wUE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUDUtyXKbVmzQZ0+Wtb+YGTc5S5Wsl6UsXDkyQbq5dJvS3GwX96nmKJFnPWHj7duC
	 W8DXWKzZTSFyVS6NxSR8gJvyQuAWSG8fS5vLfDpIlKlLZ/fOZYEI2f9cYa+K8QGsoN
	 KNGQCA3Lp9xZEfNfEjWObhQO5V1ByhnxIupWiDlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/313] io_uring: always prep_async for drain requests
Date: Mon, 30 Jan 2023 14:51:22 +0100
Message-Id: <20230130134348.205579242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Yudaken <dylany@meta.com>

[ Upstream commit ef5c600adb1d985513d2b612cc90403a148ff287 ]

Drain requests all go through io_drain_req, which has a quick exit in case
there is nothing pending (ie the drain is not useful). In that case it can
run the issue the request immediately.

However for safety it queues it through task work.
The problem is that in this case the request is run asynchronously, but
the async work has not been prepared through io_req_prep_async.

This has not been a problem up to now, as the task work always would run
before returning to userspace, and so the user would not have a chance to
race with it.

However - with IORING_SETUP_DEFER_TASKRUN - this is no longer the case and
the work might be defered, giving userspace a chance to change data being
referred to in the request.

Instead _always_ prep_async for drain requests, which is simpler anyway
and removes this issue.

Cc: stable@vger.kernel.org
Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20230127105911.2420061-1-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 13a60f51b283..862e05e6691d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1634,17 +1634,12 @@ static __cold void io_drain_req(struct io_kiocb *req)
 	}
 	spin_unlock(&ctx->completion_lock);
 
-	ret = io_req_prep_async(req);
-	if (ret) {
-fail:
-		io_req_complete_failed(req, ret);
-		return;
-	}
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
 		ret = -ENOMEM;
-		goto fail;
+		io_req_complete_failed(req, ret);
+		return;
 	}
 
 	spin_lock(&ctx->completion_lock);
@@ -1918,13 +1913,16 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		req->flags &= ~REQ_F_HARDLINK;
 		req->flags |= REQ_F_LINK;
 		io_req_complete_failed(req, req->cqe.res);
-	} else if (unlikely(req->ctx->drain_active)) {
-		io_drain_req(req);
 	} else {
 		int ret = io_req_prep_async(req);
 
-		if (unlikely(ret))
+		if (unlikely(ret)) {
 			io_req_complete_failed(req, ret);
+			return;
+		}
+
+		if (unlikely(req->ctx->drain_active))
+			io_drain_req(req);
 		else
 			io_queue_iowq(req, NULL);
 	}
-- 
2.39.0



