Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0245F381EBB;
	Sat, 12 Sep 2026 09:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205723; cv=none; b=fG27AA/hVFI7C534XR9kffaPhe4Q8Mg7Aq6XNF4FDZPQv6EGW/WJD2njaCOr1qgFynpreRFtxG1iTGJ2YdBJTRhXYVi0kFz9YpB9RaiozhB1j+nO46EV+E+MnOAq9EJXwCUrPpHbAzgdjkYDhIa1NhiM/CRJo64GTXCJxIpPQ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205723; c=relaxed/simple;
	bh=qiyajcp69SZ7d7dRdilabtnvHejxRnQqwkwnMHsfE0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8XN3UdWt2gcI+Uk1cXhj9iiavHBuLKNiBFw2KvV63zSTAM5OXZzK6NzybyYS7bcfPSz8mHgkNcljxrImah8OQQVImqe5+lFGyAbq+NsYCBNM4MLQnDlwYiE3+n9r6DeVkfLxLt7oSm5zBEZ2NUEGrsjeWkNGpThpNg41E2DqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xO2D83Ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xO2D83Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436681F000FF;
	Sat, 12 Sep 2026 09:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205720;
	bh=bI1ZJGMx2Tii7Qz5Q72t4mIq1ktIjmlacJQCaDGSblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xO2D83Qlae/g105MozPYVpIB+Z5TCiSGu3dW3BoPGLqZ3r8x1dc6Mj3ZrF/wQN8rc
	 iEAlJQZHAWIbujVpTDMuQCoNxYIxEQm8Vcsj94W8a1t7d2VF+KWnpHiKNyNkq5QHG/
	 E0+owBc7MIy8aetow+lj/gOntoDGG+hIvrdaA2qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0060/1518] io_uring/waitid: avoid siginfo copy during ring teardown
Date: Sat, 12 Sep 2026 08:37:09 +0200
Message-ID: <20260912065624.807258905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -146,7 +146,7 @@ static void io_waitid_complete(struct io
 	io_req_set_res(req, ret, 0);
 }
 
-static bool __io_waitid_cancel(struct io_kiocb *req)
+static bool __io_waitid_cancel(struct io_kiocb *req, bool copy_si)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
@@ -162,21 +162,32 @@ static bool __io_waitid_cancel(struct io
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	io_waitid_complete(req, -ECANCELED, true);
+	io_waitid_complete(req, -ECANCELED, copy_si);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
 }
 
+static bool io_waitid_cancel_cb(struct io_kiocb *req)
+{
+	return __io_waitid_cancel(req, true);
+}
+
+static bool io_waitid_cancel_nocopy_cb(struct io_kiocb *req)
+{
+	return __io_waitid_cancel(req, false);
+}
+
 int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags)
 {
-	return io_cancel_remove(ctx, cd, issue_flags, &ctx->waitid_list, __io_waitid_cancel);
+	return io_cancel_remove(ctx, cd, issue_flags, &ctx->waitid_list, io_waitid_cancel_cb);
 }
 
 bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  bool cancel_all)
 {
-	return io_cancel_remove_all(ctx, tctx, &ctx->waitid_list, cancel_all, __io_waitid_cancel);
+	return io_cancel_remove_all(ctx, tctx, &ctx->waitid_list, cancel_all,
+				       tctx ? io_waitid_cancel_cb : io_waitid_cancel_nocopy_cb);
 }
 
 static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)


