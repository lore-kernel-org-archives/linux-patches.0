Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970A42590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA40C4339B;
	Sun, 22 Jan 2023 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400681;
	bh=fMf82nTxzvC5LwUhqZe7z1wzBYFlizwz+OhnKcxxmV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmRv39vhelwQHP7MW3sEhZgqKnwr1yiyz2rq9dKcEhB9rUaGigWSuC+BrDy3+/6TW
	 t2BxbRnyuuCjlbqUpQLfDtUloD4E5A/zCDTuSi5zjTdkXVX/pKSCW4VNFn36WC5M5r
	 OaQgXzQctKaw8uaEn+4DwPP42AiYICHAZgbe2704=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@fb.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/117] io_uring: update kiocb->ki_pos at execution time
Date: Sun, 22 Jan 2023 16:03:49 +0100
Message-Id: <20230122150234.368214381@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Yudaken <dylany@fb.com>

commit d34e1e5b396a0dbaa4a29b7138df662cfb9d8e8e upstream.

Update kiocb->ki_pos at execution time rather than in io_prep_rw().
io_prep_rw() happens before the job is enqueued to a worker and so the
offset might be read multiple times before being executed once.

Ensures that the file position in a set of _linked_ SQEs will be only
obtained after earlier SQEs have completed, and so will include their
incremented file position.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 14297add8485..d9396cfaa4f3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2922,14 +2922,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		req->flags |= REQ_F_ISREG;
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
-	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
-			kiocb->ki_pos = 0;
-		}
-	}
 	kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
 	kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
@@ -3011,6 +3003,20 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
+static inline void io_kiocb_update_pos(struct io_kiocb *req)
+{
+	struct kiocb *kiocb = &req->rw.kiocb;
+
+	if (kiocb->ki_pos == -1) {
+		if (!(req->file->f_mode & FMODE_STREAM)) {
+			req->flags |= REQ_F_CUR_POS;
+			kiocb->ki_pos = req->file->f_pos;
+		} else {
+			kiocb->ki_pos = 0;
+		}
+	}
+}
+
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		       unsigned int issue_flags)
 {
@@ -3566,6 +3572,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
+	io_kiocb_update_pos(req);
+
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
@@ -3700,6 +3708,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
+	io_kiocb_update_pos(req);
+
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
 	if (unlikely(ret))
 		goto out_free;
-- 
2.39.0



