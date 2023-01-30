Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661EE28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD908C433D2;
	Mon, 30 Jan 2023 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087439;
	bh=8ZSKvPOum3MLw1r1dtetFSXC3ZryVls5EoDCTJNmMVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svewyk/Y0bFqjbcJfmsKzb018mbIFwVm9fqBufL7Fs6vltwCRFb2vYIS7/+ECFqZp
	 JL3HCTAdYjzajuueyydhuQ4yOyYopuGEOp5RcbeeDvcvdS96rzSJNyr+ElyEGDow2/
	 Lpo7PIKsZy6lC4weQK5A6NLVpmhbsSWTihFFlkGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 201/313] io_uring/msg_ring: fix remote queue to disabled ring
Date: Mon, 30 Jan 2023 14:50:36 +0100
Message-Id: <20230130134346.078425111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

commit 8579538c89e33ce78be2feb41e07489c8cbf8f31 upstream.

IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
it's not always safe to use ->submitter_task. Disallow posting msg_ring
messaged to disabled rings. Also add task NULL check for loosy sync
around testing for IORING_SETUP_R_DISABLED.

Cc: stable@vger.kernel.org
Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/msg_ring.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -30,6 +30,8 @@ static int io_msg_ring_data(struct io_ki
 
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
 		return 0;
@@ -84,6 +86,8 @@ static int io_msg_send_fd(struct io_kioc
 
 	if (target_ctx == ctx)
 		return -EINVAL;
+	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
+		return -EBADFD;
 
 	ret = io_double_lock_ctx(ctx, target_ctx, issue_flags);
 	if (unlikely(ret))


