Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838953B0AFC;
	Wed,  8 Apr 2026 18:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673634; cv=none; b=NAkuyaNVwk1HV1rNsYuXIBOAO1g97H9z3q2ClSsm4V//fa7h8Bsa/FQMDRPaiNTaQeDzDkW3qn8EvXYU15FSi3OSWJw/2tmYDMn7P8mtfdpntVZOtx5fN4mVL0CGfRIPdLciWmEHeVid26goTZD1TXCnECkYav3XvXColTzRae0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673634; c=relaxed/simple;
	bh=dGLi8KGu1Y0wmpieWa7JcgweU9nUoXc76dK+fv0DF6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmXoCq+gIdW3uvrWeSivv+4NEe8FaEpbwJtt6uBqv49OxXV5Q4sYuaGQuo4AFDHOBrBbuzV2W58u+ixiMnRoebFj4fQ19BiXiNZYLFV6PplgRbVlfYL3qFQBVrqYufkFx/W/RywdrpsbysUh3vkOK/q4zgxInFtHY+fSNJfkvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smedEjFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smedEjFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C20C19421;
	Wed,  8 Apr 2026 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673634;
	bh=dGLi8KGu1Y0wmpieWa7JcgweU9nUoXc76dK+fv0DF6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smedEjFHl4KR91OIA7WD/WSSG90f1hto1W3o2TtShiTJgA9if8lwL8/U+HvQe4GH+
	 dBha500v/oTtEHGyaSbHGxwtaVY0HxH0aM/nHCYn7Lfvg9qGbjm7tHR1EgJBDz81Vs
	 FcPZlqNMd3qEe4EZEkrdCuvM4ncUGqjsiDGDrKDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 003/242] io_uring/kbuf: simplify __io_put_kbuf
Date: Wed,  8 Apr 2026 20:00:43 +0200
Message-ID: <20260408175927.198587300@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit dc39fb1093ea33019f192c93b77b863282e10162 upstream.

As a preparation step remove an optimisation from __io_put_kbuf() trying
to use the locked cache. With that __io_put_kbuf_list() is only used
with ->io_buffers_comp, and we remove the explicit list argument.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1b7f1394ec4afc7f96b35a61f5992e27c49fd067.1738724373.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 --
 io_uring/kbuf.c     |   26 +++-----------------------
 io_uring/kbuf.h     |   11 +++++------
 3 files changed, 8 insertions(+), 31 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -385,9 +385,7 @@ static bool req_need_defer(struct io_kio
 static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		spin_lock(&req->ctx->completion_lock);
 		io_kbuf_drop(req);
-		spin_unlock(&req->ctx->completion_lock);
 	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -78,29 +78,9 @@ bool io_kbuf_recycle_legacy(struct io_ki
 
 void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
 {
-	/*
-	 * We can add this buffer back to two lists:
-	 *
-	 * 1) The io_buffers_cache list. This one is protected by the
-	 *    ctx->uring_lock. If we already hold this lock, add back to this
-	 *    list as we can grab it from issue as well.
-	 * 2) The io_buffers_comp list. This one is protected by the
-	 *    ctx->completion_lock.
-	 *
-	 * We migrate buffers from the comp_list to the issue cache list
-	 * when we need one.
-	 */
-	if (issue_flags & IO_URING_F_UNLOCKED) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		spin_lock(&ctx->completion_lock);
-		__io_put_kbuf_list(req, len, &ctx->io_buffers_comp);
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		lockdep_assert_held(&req->ctx->uring_lock);
-
-		__io_put_kbuf_list(req, len, &req->ctx->io_buffers_cache);
-	}
+	spin_lock(&req->ctx->completion_lock);
+	__io_put_kbuf_list(req, len);
+	spin_unlock(&req->ctx->completion_lock);
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -171,27 +171,26 @@ static inline bool __io_put_kbuf_ring(st
 	return ret;
 }
 
-static inline void __io_put_kbuf_list(struct io_kiocb *req, int len,
-				      struct list_head *list)
+static inline void __io_put_kbuf_list(struct io_kiocb *req, int len)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
 		__io_put_kbuf_ring(req, len, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
-		list_add(&req->kbuf->list, list);
+		list_add(&req->kbuf->list, &req->ctx->io_buffers_comp);
 		req->flags &= ~REQ_F_BUFFER_SELECTED;
 	}
 }
 
 static inline void io_kbuf_drop(struct io_kiocb *req)
 {
-	lockdep_assert_held(&req->ctx->completion_lock);
-
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 
+	spin_lock(&req->ctx->completion_lock);
 	/* len == 0 is fine here, non-ring will always drop all of it */
-	__io_put_kbuf_list(req, 0, &req->ctx->io_buffers_comp);
+	__io_put_kbuf_list(req, 0);
+	spin_unlock(&req->ctx->completion_lock);
 }
 
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,


