Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34E1C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E3FC433EF;
	Mon, 20 Mar 2023 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326200;
	bh=quSTZp71LXUAnBVrfWKSEfJuYTcsibE94qPn8B9SIAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+QfLiVnkjYqp1YQpa0s/A6HYu0AGcXpKZfta7EwB33MUwTdq6jrJFj7IhUZYU9r1
	 C1bwELnBss+z3l6HEMhOKf/XtVZMAlSuwQwu2+7UJmxu4XGYgOh6zpzsCjh1+iLdYr
	 Xf8NrWO+yX9OGu0lDMGsgsBva2UVTU/59CGnD1ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 197/211] io_uring/msg_ring: let target know allocated index
Date: Mon, 20 Mar 2023 15:55:32 +0100
Message-Id: <20230320145521.794026664@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 5da28edd7bd5518f97175ecea77615bb729a7a28 upstream.

msg_ring requests transferring files support auto index selection via
IORING_FILE_INDEX_ALLOC, however they don't return the selected index
to the target ring and there is no other good way for the userspace to
know where is the receieved file.

Return the index for allocated slots and 0 otherwise, which is
consistent with other fixed file installing requests.

Cc: stable@vger.kernel.org # v6.0+
Fixes: e6130eba8a848 ("io_uring: add support for passing fixed file descriptors")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://github.com/axboe/liburing/issues/809
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -183,7 +183,7 @@ static int io_msg_install_complete(struc
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
 		ret = -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(target_ctx);
@@ -210,6 +210,8 @@ static int io_msg_send_fd(struct io_kioc
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *src_file = msg->src_file;
 
+	if (msg->len)
+		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)


