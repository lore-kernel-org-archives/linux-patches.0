Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4465C23AF
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F8CC433EF;
	Wed, 28 Dec 2022 16:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246712;
	bh=3tjUQMxqMlsSlyeYOf19aBlkwT5RoOyi6HuPh2esJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iqny9+MPegSwC+IsFe1QmvzQgHgLgxxqndVHXh5hlkFdvdDfLN7IU/SaricOVQVfT
	 bGprTLqTRPXzl33Lhy+w402JEU5M4RbGDFzeQ7yBHDToT2O3E/Dy9kPxHCbY1rHkDO
	 s4EIL/O4wOxo3UtZrWxhk+/u7xeb7txqfeJ4sy4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 1136/1146] io_uring: add completion locking for iopoll
Date: Wed, 28 Dec 2022 15:44:35 +0100
Message-Id: <20221228144400.999010405@linuxfoundation.org>
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

commit 2ccc92f4effcfa1c51c4fcf1e34d769099d3cad4 upstream.

There are pieces of code that may allow iopoll to race filling cqes,
temporarily add spinlocking around posting events.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/84d86b5c117feda075471c5c9e65208e0dccf5d0.1669203009.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1043,6 +1043,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 	else if (!pos)
 		return 0;
 
+	spin_lock(&ctx->completion_lock);
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
@@ -1057,11 +1058,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 		req->cqe.flags = io_put_kbuf(req, 0);
 		__io_fill_cqe_req(req->ctx, req);
 	}
-
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
 	if (unlikely(!nr_events))
 		return 0;
 
-	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);


