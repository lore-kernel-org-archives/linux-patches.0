Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4E52590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD7C433EF;
	Sun, 22 Jan 2023 15:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400678;
	bh=PXwRsd3OduKL48CriyI8E7kOgOEg6V6PkEYCjrWSADY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7gslqa2tGa3Sh98Ao3Z8QyxHdAATG+Lti7L/xYlE9PtRQNB3tOm6esJwLgWscRn5
	 JqUXJQ6KYnmMsQNlI5fA/jn47sWjJQx/adQLBRQbtsYsfoPpOROyoPLhmVxjsY7vaQ
	 Dw4+RiNzbfoyk60BNslnUZz2P57VwBx0Di94+G8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@fb.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/117] io_uring: remove duplicated calls to io_kiocb_ppos
Date: Sun, 22 Jan 2023 16:03:48 +0100
Message-Id: <20230122150234.318679518@linuxfoundation.org>
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

commit af9c45ecebaf1b428306f41421f4bcffe439f735 upstream.

io_kiocb_ppos is called in both branches, and it seems that the compiler
does not fuse this. Fusing removes a few bytes from loop_rw_iter.

Before:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 0000000000000124 t loop_rw_iter

After:
$ nm -S fs/io_uring.o | grep loop_rw_iter
0000000000002430 000000000000010d t loop_rw_iter

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2caef6417260..14297add8485 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3303,6 +3303,7 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct file *file = req->file;
 	ssize_t ret = 0;
+	loff_t *ppos;
 
 	/*
 	 * Don't support polled IO through this interface, and we can't
@@ -3314,6 +3315,8 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		return -EAGAIN;
 
+	ppos = io_kiocb_ppos(kiocb);
+
 	while (iov_iter_count(iter)) {
 		struct iovec iovec;
 		ssize_t nr;
@@ -3327,10 +3330,10 @@ static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, io_kiocb_ppos(kiocb));
+					      iovec.iov_len, ppos);
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, io_kiocb_ppos(kiocb));
+					       iovec.iov_len, ppos);
 		}
 
 		if (nr < 0) {
-- 
2.39.0



