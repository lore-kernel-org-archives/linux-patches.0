Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348022590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3EDC433EF;
	Sun, 22 Jan 2023 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400684;
	bh=2SwMuT/2UzosTnDpPW+ZDHQAe3aFn++7ZNH4Zi9xqkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awd1k0XsNAhCx+deeqzwqJEVyiXr/fA7H8fVV/U25h6oSU2byVU/T4zR1VQDj8dB/
	 JRPUd0jUdXbKDz4ylpRYxivY+7EjnwXiCbIoguOD9BaQSCZXetCKKwgamXaINam4zV
	 CvO+P96P98c6DZp3245ZHLWDLvoL8BmeCgXqTm10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@fb.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/117] io_uring: do not recalculate ppos unnecessarily
Date: Sun, 22 Jan 2023 16:03:50 +0100
Message-Id: <20230122150234.407739857@linuxfoundation.org>
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

commit b4aec40015953b65f2f114641e7fd7714c8df8e6 upstream.

There is a slight optimisation to be had by calculating the correct pos
pointer inside io_kiocb_update_pos and then using that later.

It seems code size drops by a bit:
000000000000a1b0 0000000000000400 t io_read
000000000000a5b0 0000000000000319 t io_write

vs
000000000000a1b0 00000000000003f6 t io_read
000000000000a5b0 0000000000000310 t io_write

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d9396cfaa4f3..73d261004c4a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3003,18 +3003,22 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 	}
 }
 
-static inline void io_kiocb_update_pos(struct io_kiocb *req)
+static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
+	bool is_stream = req->file->f_mode & FMODE_STREAM;
 
 	if (kiocb->ki_pos == -1) {
-		if (!(req->file->f_mode & FMODE_STREAM)) {
+		if (!is_stream) {
 			req->flags |= REQ_F_CUR_POS;
 			kiocb->ki_pos = req->file->f_pos;
+			return &kiocb->ki_pos;
 		} else {
 			kiocb->ki_pos = 0;
+			return NULL;
 		}
 	}
+	return is_stream ? NULL : &kiocb->ki_pos;
 }
 
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
@@ -3540,6 +3544,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3572,9 +3577,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret ?: -EAGAIN;
 	}
 
-	io_kiocb_update_pos(req);
+	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+	ret = rw_verify_area(READ, req->file, ppos, req->result);
 	if (unlikely(ret)) {
 		kfree(iovec);
 		return ret;
@@ -3678,6 +3683,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	loff_t *ppos;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3708,9 +3714,9 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	io_kiocb_update_pos(req);
+	ppos = io_kiocb_update_pos(req);
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
+	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
 	if (unlikely(ret))
 		goto out_free;
 
-- 
2.39.0



