Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F32590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E51AC433EF;
	Sun, 22 Jan 2023 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400673;
	bh=3cRGBHDByLnAZeCjvn7v97G2SNm9CO8kgin0q7ZsY00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Nw0StOBVEkXdXtl326g4niHVJ6xIfVUdnyTVGz76Q3p3DyE/Sj/riuEB/Wzq8Zrr
	 S7kwoiIGfxvYi8bwVmxkcXpn2/8d9ALyOw8scP8dcgYym4uhjXW1klBDOfs8mFPNMq
	 vSEIUYR+K7MquNyhPKAL/mf0GXvJXg2LWNzv2NNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/117] io_uring: fix async accept on O_NONBLOCK sockets
Date: Sun, 22 Jan 2023 16:03:46 +0100
Message-Id: <20230122150234.230902259@linuxfoundation.org>
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
index 997a7264e1d4..e1e15d40d758 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5272,9 +5272,6 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
-	if (req->file->f_flags & O_NONBLOCK)
-		req->flags |= REQ_F_NOWAIT;
-
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5286,6 +5283,8 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
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



