Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6962E7E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14FBC433EF;
	Sun, 22 Jan 2023 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400309;
	bh=9E0HHCdfjBhajCWmjOFB+FAheWEg9z7r+yXKVvpvCx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ghxM5LEZYjdsp51MMRB/H48ClwipUOxN/6TQlSqLw12vVPR5wobEWFrohPIOKI3y
	 hM2wy6F0oCT9Dh4PLJmhDdJH++2YGFWZizZ/+FYslkDEu6paMRrtyiTrxSaiaRftG4
	 fc1uwuGoPgiRH3C+EeEXGGwqFJKYaSeSTjAQwJDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/98] io_uring: fix async accept on O_NONBLOCK sockets
Date: Sun, 22 Jan 2023 16:03:42 +0100
Message-Id: <20230122150230.570832678@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit a73825ba70c93e1eb39a845bb3d9885a787f8ffe upstream.

Do not set REQ_F_NOWAIT if the socket is non blocking. When enabled this
causes the accept to immediately post a CQE with EAGAIN, which means you
cannot perform an accept SQE on a NONBLOCK socket asynchronously.

By removing the flag if there is no pending accept then poll is armed as
usual and when a connection comes in the CQE is posted.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
Link: https://lore.kernel.org/r/20220324143435.2875844-1-dylany@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cc8e13de5fa9..8c8ba8c067ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5112,9 +5112,6 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5127,6 +5124,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
+		/* safe to retry */
+		req->flags |= REQ_F_PARTIAL_IO;
 		if (ret == -EAGAIN && force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
-- 
2.39.0



