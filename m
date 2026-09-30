Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCED5678C9;
	Wed, 30 Sep 2026 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789875; cv=none; b=QwBue85Oe8k8BOLg7EXmMsfp/MXi1bGJc2aa21HskGXLyZTTix9vMeSYIIV9F+O/qpxBYVuG98pnrBw3WpaNtG7C+eUBPjHFaEgqmufPMVXy/e7m/Y1nTEUmoDTIwJAIKZTr5QF+NYUz27U5Y9zMqM2qyGpDojQEfXKsTDH/XFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789875; c=relaxed/simple;
	bh=ORIiUfynUbo6hgAFk3oX0azxBaw8iAyFNVlHIXJUnGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg6o0VPhXTf20JwZhu0PmLreYjsvY3u7TV0xs5rRmZnnFfEt2Z6aSjUf9WxKEXocFf2T6Ger4GRehnb82DcX7xIojVneAFdjMBMqizaSGGQD+NodMPRyuyNu9XvnOmVM8WE3ppsKhAqvXWBUe91jFmMv0NGlWpnqgUusx2erRMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVCSV+UC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVCSV+UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3181F000FF;
	Wed, 30 Sep 2026 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789874;
	bh=NMc8LXBBfNHDs+kVKWkIPjx4hDF9iy5VYLsr3FgBKnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVCSV+UC7axoi1Jl1p+iTEF/0AcoXlr6lJxsRLJ8jd8/KeRoDRgvosbtZd2MGsI28
	 ZRCNr1AmwFxQ2enUfOSAf4rimWAgsSJwsAFqY4eGhiRKD709UN6LIwLXDrUwe35WAk
	 AwC7NrD3Iklg4KnPD5ld4s3MuDMeHNMIbR3dSc0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 594/877] io_uring/waitid: have io_waitid_complete() remove wait queue entry
Date: Wed, 30 Sep 2026 17:25:05 +0200
Message-ID: <20260930152427.470098768@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a48c0cbf28c03f6c590a14ceb31bf6e619c2f6da ]

Both callers of this need the entry potentially removed, so shift the
removal into the completion side and kill it from the two callers.

While at it, add a helper for removing the wait_queue_entry based
on the passed in io_kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2cf20c4e0f72 ("io_uring/waitid: avoid siginfo copy during ring teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -115,6 +115,22 @@ static int io_waitid_finish(struct io_ki
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
@@ -125,6 +141,7 @@ static void io_waitid_complete(struct io
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	hlist_del_init(&req->hash_node);
+	io_waitid_remove_wq(req);
 
 	ret = io_waitid_finish(req, ret);
 	if (ret < 0)
@@ -135,7 +152,8 @@ static void io_waitid_complete(struct io
 static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_waitid_async *iwa = req->async_data;
+
+	lockdep_assert_held(&req->ctx->uring_lock);
 
 	/*
 	 * Mark us canceled regardless of ownership. This will prevent a
@@ -147,9 +165,6 @@ static bool __io_waitid_cancel(struct io
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	spin_lock_irq(&iw->head->lock);
-	list_del_init(&iwa->wo.child_wait.entry);
-	spin_unlock_irq(&iw->head->lock);
 	io_waitid_complete(req, -ECANCELED);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
@@ -251,8 +266,7 @@ static void io_waitid_cb(struct io_kiocb
 				io_waitid_drop_issue_ref(req);
 				return;
 			}
-
-			remove_wait_queue(iw->head, &iwa->wo.child_wait);
+			/* fall through to complete, will kill waitqueue */
 		}
 	}
 


