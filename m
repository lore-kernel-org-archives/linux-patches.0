Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DD423AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB0CC433D2;
	Wed, 28 Dec 2022 16:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246730;
	bh=fz1Qq1RMCwmoaiqL42FsUBGvamhIGxf64gEan4snkrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4Txc+BaaZZIDGs5sDqBVkLcRpOJzAHMsuMoMCAmueTzVwR2wGCpmdD7f8iOJjUCg
	 o9Ig+U6K4aJOg76+ZMi0UHhoJSrwYlXhCkhIFWgp/IMKUhqyqPxqmXfMbxVtdPofQo
	 3Gy9nVMuIe+wLBtW2j5s12JrFOxTznBVgYq3SmXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1142/1146] io_uring: remove iopoll spinlock
Date: Wed, 28 Dec 2022 15:44:41 +0100
Message-Id: <20221228144401.159814298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

commit 2dac1a159216b39ced8d78dba590c5d2f4249586 upstream.

This reverts commit 2ccc92f4effcfa1c51c4fcf1e34d769099d3cad4

io_req_complete_post() should now behave well even in case of IOPOLL, we
can remove completion_lock locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/7e171c8b530656b14a671c59100ca260e46e7f2a.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1043,7 +1043,6 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 	else if (!pos)
 		return 0;
 
-	spin_lock(&ctx->completion_lock);
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
@@ -1058,11 +1057,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 		req->cqe.flags = io_put_kbuf(req, 0);
 		__io_fill_cqe_req(req->ctx, req);
 	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
+
 	if (unlikely(!nr_events))
 		return 0;
 
+	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);


