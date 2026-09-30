Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A0A52188D;
	Wed, 30 Sep 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789898; cv=none; b=sMvl/kLx5TjAbaY6iQNtOcnyyvQdt6q5W7lynbCvTYS/IYH3XPYukYaeE5SwbqqJcO99ibBhwARLsbumbVy4e78ZVZnfdcl7QCuSvgDPlUCz5McuMDxhfEg50sMqYHhOFpUvuADmBVdzmCkPX7arlxM4SInPCsY01ezBTpVPDH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789898; c=relaxed/simple;
	bh=fEdWXexBeOtDsqPF8F+h0i8Y8WnG1XVhQOfJt5exPLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9pFGIGthVppjQRr4f14csriSUzJecxDZzrLFqGThbNhiRT626aOEqGoHw6fsor8UsI4FXJnpcxTlkaPDNhxV3FZ83P+uoCbLJNTWrYyUebPA0/CfKFLgji/CwXij2ZZ+YuGaubdgYQZS+Va2KS+S70vPtXkg2a6cNoL7pljYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F82ga8vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F82ga8vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C2F1F000FF;
	Wed, 30 Sep 2026 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789896;
	bh=SFcFFO4sI2yQrd6p76qiAvPcdoo8M6G/iqIWtRDOPhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F82ga8vL7YdyKGxSPyN+p5Y1MV4H8Jvz6t5eSkWdpQT3LcxqcDume2aa0NLF+Psos
	 EoeuP2iX0EJlaF+VRgws32h5zQq3FCnkBjDknxC3lesWWEfdGSQc4UF8CBsF67I+LT
	 EUgDCPu6sBZCMHvTKYEujWLHsGkdtmRuO9k14AlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 595/877] io_uring/waitid: avoid siginfo copy during ring teardown
Date: Wed, 30 Sep 2026 17:25:06 +0200
Message-ID: <20260930152427.491729446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 2cf20c4e0f72d523b8673053e7120d092ff1f074 ]

During ring teardown, io_ring_exit_work() cancels outstanding requests
from a kworker with a NULL tctx. The waitid cancellation path eventually
reaches io_waitid_finish(), which copies the stored siginfo to the
userspace pointer supplied with the request.

Ring-wide teardown does not run in the task context that submitted the
request, so it must not access that task's userspace pointer. Depending
on the address and mm state, the copy may fail with -EFAULT, but the
uaccess itself is inappropriate from the teardown kworker.

Use a no-copy cancellation callback when io_waitid_remove_all() is
called without an owning task context. Complete the request with
-ECANCELED while releasing the waitid state without touching siginfo.

Keep the existing siginfo handling for explicit async cancellation and
task-scoped cancellation.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
Link: https://patch.msgid.link/20260818103336.1922818-3-sh_def@163.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ adapted copy_si handling to older direct cancellation helpers using task instead of tctx. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -131,7 +131,7 @@ static void io_waitid_remove_wq(struct i
 	}
 }
 
-static void io_waitid_complete(struct io_kiocb *req, int ret)
+static void io_waitid_complete(struct io_kiocb *req, int ret, bool copy_si)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
@@ -143,13 +143,17 @@ static void io_waitid_complete(struct io
 	hlist_del_init(&req->hash_node);
 	io_waitid_remove_wq(req);
 
-	ret = io_waitid_finish(req, ret);
+	if (copy_si)
+		ret = io_waitid_finish(req, ret);
+	else
+		io_waitid_free(req);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 }
 
-static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			       bool copy_si)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
@@ -165,7 +169,7 @@ static bool __io_waitid_cancel(struct io
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	io_waitid_complete(req, -ECANCELED);
+	io_waitid_complete(req, -ECANCELED, copy_si);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
 }
@@ -185,7 +189,7 @@ int io_waitid_cancel(struct io_ring_ctx
 		if (req->cqe.user_data != cd->data &&
 		    !(cd->flags & IORING_ASYNC_CANCEL_ANY))
 			continue;
-		if (__io_waitid_cancel(ctx, req))
+		if (__io_waitid_cancel(ctx, req, true))
 			nr++;
 		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
 			break;
@@ -211,7 +215,7 @@ bool io_waitid_remove_all(struct io_ring
 		if (!io_match_task_safe(req, task, cancel_all))
 			continue;
 		hlist_del_init(&req->hash_node);
-		__io_waitid_cancel(ctx, req);
+		__io_waitid_cancel(ctx, req, task != NULL);
 		found = true;
 	}
 
@@ -270,7 +274,7 @@ static void io_waitid_cb(struct io_kiocb
 		}
 	}
 
-	io_waitid_complete(req, ret);
+	io_waitid_complete(req, ret, true);
 	io_req_task_complete(req, ts);
 }
 


