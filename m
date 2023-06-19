Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A266BA94D
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E3DC433C9;
	Mon, 19 Jun 2023 10:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172075;
	bh=eGy7470Zs5xGo/O58VxDZU2Z/mTcEDC0f9Ixbs88Cko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvdXr/WLekABbGfbvbJFcbyGc43mh1VKFwA6Peir9U8HM9UkxvpdrQLKshmbnDnOf
	 clRCYGqTUB/5B9Chv4lz66Eg6i65DSiIvJUD0hWdQE8c84s0MZvdKNlv+7QAiZM6rX
	 vgKvzsF+nZYcOcEb9wEuLYIvllbG6EP+KVxsqpsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Querijn Voet <querijnqyn@gmail.com>
Subject: [PATCH 5.10 27/89] io_uring: hold uring mutex around poll removal
Date: Mon, 19 Jun 2023 12:30:15 +0200
Message-ID: <20230619102139.519551782@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
References: <20230619102138.279161276@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

Snipped from commit 9ca9fb24d5febccea354089c41f96a8ad0d853f8 upstream.

While reworking the poll hashing in the v6.0 kernel, we ended up
grabbing the ctx->uring_lock in poll update/removal. This also fixed
a bug with linked timeouts racing with timeout expiry and poll
removal.

Bring back just the locking fix for that.

Reported-and-tested-by: Querijn Voet <querijnqyn@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5966,6 +5966,8 @@ static int io_poll_update(struct io_kioc
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 
+	io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
+
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
 	if (!preq || !io_poll_disarm(preq)) {
@@ -5997,6 +5999,7 @@ out:
 		req_set_fail(req);
 	/* complete update request, we're done with it */
 	io_req_complete(req, ret);
+	io_ring_submit_unlock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
 	return 0;
 }
 


