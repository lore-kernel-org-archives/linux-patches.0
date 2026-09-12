Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDC6299920;
	Sat, 12 Sep 2026 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205880; cv=none; b=rS2LhtDXaXbUjiACUXinU6v/IhShfi5Dapu1FrTkF8d5bNAEJ3GcaWL9RIBqS3TPh4ANme1Xh64eCPkO6/qoy0ghkvGibmLjEfebLhF8EOdSeyJ4JO64bwjABABVzlS/62WjabAwJV1A3EFuTwsAWGi6/PQ5jcZEcpGtHCIuEdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205880; c=relaxed/simple;
	bh=iSSVdQWr919BA1P5eG2AlqrzVr3NKwaDSv/YeBkbWL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7wh1uNdah4PdhT4GlGVSnK+pLH1CKEOnwLhrruZFsK+rOQZlll7L1n1metoyk6VkTlVWnMUO+IJqt+Lf+PJpqGWGsDo1hfedNZTvSv+ZhJMXvmVurkQ3m+bo2bdgBrPvMxJj0iPSmiOmjkUvT2GaW8M2+Y3BpQtj+M4ZDIqJ7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXfCjZNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXfCjZNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56401F000FF;
	Sat, 12 Sep 2026 09:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205879;
	bh=Ndg5BfRh4ybCOVkUJeMDLk+F4ZEhX1GqTBOc/VmBAwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXfCjZNtNREjDxw/oDOtcRwXI+92fWeeFfgytVBHghD6/4ULhYPajirqjuxl3l6Nx
	 XaNEgP2xAfpZ8d/9BxhqZ1PF7pW74uaVHx/kVhqSeNAdcw+VkIl92BDr7UyRLBnE1T
	 glmtNiE3DChAkQ2sB4+4yDwBVQSsMenrIb6BbbeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0049/1518] io_uring/waitid: have io_waitid_complete() remove wait queue entry
Date: Sat, 12 Sep 2026 08:36:58 +0200
Message-ID: <20260912065624.549431253@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a48c0cbf28c03f6c590a14ceb31bf6e619c2f6da ]

Both callers of this need the entry potentially removed, so shift the
removal into the completion side and kill it from the two callers.

While at it, add a helper for removing the wait_queue_entry based
on the passed in io_kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 14572de82e50 ("io_uring/waitid: honor task_work cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -109,6 +109,22 @@ static int io_waitid_finish(struct io_ki
 	return ret;
 }
 
+static void io_waitid_remove_wq(struct io_kiocb *req)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct wait_queue_head *head;
+
+	head = READ_ONCE(iw->head);
+	if (head) {
+		struct io_waitid_async *iwa = req->async_data;
+
+		iw->head = NULL;
+		spin_lock_irq(&head->lock);
+		list_del_init(&iwa->wo.child_wait.entry);
+		spin_unlock_irq(&head->lock);
+	}
+}
+
 static void io_waitid_complete(struct io_kiocb *req, int ret)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
@@ -119,6 +135,7 @@ static void io_waitid_complete(struct io
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	hlist_del_init(&req->hash_node);
+	io_waitid_remove_wq(req);
 
 	ret = io_waitid_finish(req, ret);
 	if (ret < 0)
@@ -129,7 +146,8 @@ static void io_waitid_complete(struct io
 static bool __io_waitid_cancel(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_waitid_async *iwa = req->async_data;
+
+	lockdep_assert_held(&req->ctx->uring_lock);
 
 	/*
 	 * Mark us canceled regardless of ownership. This will prevent a
@@ -141,9 +159,6 @@ static bool __io_waitid_cancel(struct io
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	spin_lock_irq(&iw->head->lock);
-	list_del_init(&iwa->wo.child_wait.entry);
-	spin_unlock_irq(&iw->head->lock);
 	io_waitid_complete(req, -ECANCELED);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
@@ -209,8 +224,7 @@ static void io_waitid_cb(struct io_kiocb
 				io_waitid_drop_issue_ref(req);
 				return;
 			}
-
-			remove_wait_queue(iw->head, &iwa->wo.child_wait);
+			/* fall through to complete, will kill waitqueue */
 		}
 	}
 


