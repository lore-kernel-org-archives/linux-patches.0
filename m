Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4508C8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D7C433D2;
	Tue, 28 Mar 2023 14:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015285;
	bh=b9HxH5DCQVbFGTCWaOEPB4LcaRoVc0gPMD3gnTvVU9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dX1iJtKhaGh3hkntzA1TP6hZV/+obBfVkscyjJYUZhyoW+2ZLsifPthPB2w7JzW+H
	 cJ9sccJBlLZCy15XuRJ4XmnSqcvyHBq6M0U2qYUzBs3LhwZIM3PQCTdnQHl/ppYDL4
	 57/7uu/e/xVdzn0SupNUOjmiwchOo2OxPQpEg7As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hui, Chunyang" <sanqian.hcy@antgroup.com>,
	Jens Axboe <axboe@kernel.dk>,
	Hui
Subject: [PATCH 6.2 203/240] io_uring/net: avoid sending -ECONNABORTED on repeated connection requests
Date: Tue, 28 Mar 2023 16:42:46 +0200
Message-Id: <20230328142628.142527210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

commit 74e2e17ee1f8d8a0928b90434ad7e2df70f8483e upstream.

Since io_uring does nonblocking connect requests, if we do two repeated
ones without having a listener, the second will get -ECONNABORTED rather
than the expected -ECONNREFUSED. Treat -ECONNABORTED like a normal retry
condition if we're nonblocking, if we haven't already seen it.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/828
Reported-by: Hui, Chunyang <sanqian.hcy@antgroup.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -47,6 +47,7 @@ struct io_connect {
 	struct sockaddr __user		*addr;
 	int				addr_len;
 	bool				in_progress;
+	bool				seen_econnaborted;
 };
 
 struct io_sr_msg {
@@ -1431,7 +1432,7 @@ int io_connect_prep(struct io_kiocb *req
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
-	conn->in_progress = false;
+	conn->in_progress = conn->seen_econnaborted = false;
 	return 0;
 }
 
@@ -1468,18 +1469,24 @@ int io_connect(struct io_kiocb *req, uns
 
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
-	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
+	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-		} else {
-			if (req_has_async_data(req))
-				return -EAGAIN;
-			if (io_alloc_async_data(req)) {
-				ret = -ENOMEM;
+			return -EAGAIN;
+		}
+		if (ret == -ECONNABORTED) {
+			if (connect->seen_econnaborted)
 				goto out;
-			}
-			memcpy(req->async_data, &__io, sizeof(__io));
+			connect->seen_econnaborted = true;
+		}
+		if (req_has_async_data(req))
+			return -EAGAIN;
+		if (io_alloc_async_data(req)) {
+			ret = -ENOMEM;
+			goto out;
 		}
+		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)


