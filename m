Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93889469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B932DC433C7;
	Mon, 28 Aug 2023 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218720;
	bh=gADK3H8U8aLzfIj0HI0IpLwdijPkcNl1XB8bPGYxaow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5mdMdZiEGR6I17I4vtDPqpCV8NN5Jo8RXCpwHMmHS5FFtD3wsP6nPNGQQ2lw1OiO
	 0XHJnSW6+pLPQi58ArghoaKaI3uMs9tuIIHb8YOc+DVP+X+NMGI9aG1Iv//eJRppah
	 wEIpqdBwF/v/cqQ/XsQ+CKF4vgIK4UEaZzymNm+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 060/122] io_uring/msg_ring: fix missing lock on overflow for IOPOLL
Date: Mon, 28 Aug 2023 12:12:55 +0200
Message-ID: <20230828101158.427639186@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit e12d7a46f65ae4b7d58a5e0c1cbfa825cf8d830d upstream.

If the target ring is configured with IOPOLL, then we always need to hold
the target ring uring_lock before posting CQEs. We could just grab it
unconditionally, but since we don't expect many target rings to be of this
type, make grabbing the uring_lock conditional on the ring type.

Link: https://lore.kernel.org/io-uring/Y8krlYa52%2F0YGqkg@ip-172-31-85-199.ec2.internal/
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -57,20 +57,30 @@ void io_msg_ring_cleanup(struct io_kiocb
 	msg->src_file = NULL;
 }
 
-static int io_msg_ring_data(struct io_kiocb *req)
+static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	int ret;
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
 
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
-		return 0;
+	ret = -EOVERFLOW;
+	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
+		if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+			return -EAGAIN;
+		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
+			ret = 0;
+		io_double_unlock_ctx(target_ctx);
+	} else {
+		if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
+			ret = 0;
+	}
 
-	return -EOVERFLOW;
+	return ret;
 }
 
 static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
@@ -175,7 +185,7 @@ int io_msg_ring(struct io_kiocb *req, un
 
 	switch (msg->cmd) {
 	case IORING_MSG_DATA:
-		ret = io_msg_ring_data(req);
+		ret = io_msg_ring_data(req, issue_flags);
 		break;
 	case IORING_MSG_SEND_FD:
 		ret = io_msg_send_fd(req, issue_flags);


