Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A047461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316FAC433C8;
	Sun, 17 Sep 2023 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980831;
	bh=KkNcjq1dxyEckrVtKdsBJGRfEbywks8JtlWhA8n4NOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+0+p4rpqQz6cac2mHvNA86sUXSueq40dJGCzkJzBb6lqxj23r69buPT1QZIHPku8
	 c6vw4RMyyUKp/59jC+Mhv0Mw+k0FF7qYd1AMZwY+lagFGATnMZ2C50KL/ydArLxgaV
	 HAm4MyQbuTXevNxp5YtIIzjCGTjdXsWcbRHEv5fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Yudaken <dylany@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 005/219] io_uring: revert "io_uring fix multishot accept ordering"
Date: Sun, 17 Sep 2023 21:12:12 +0200
Message-ID: <20230917191041.158454836@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

From: Dylan Yudaken <dylany@meta.com>

[ upstream commit 515e26961295bee9da5e26916c27739dca6c10e1 ]

This is no longer needed after commit aa1df3a360a0 ("io_uring: fix CQE
reordering"), since all reordering is now taken care of.

This reverts commit cbd25748545c ("io_uring: fix multishot accept
ordering").

Signed-off-by: Dylan Yudaken <dylany@meta.com>
Link: https://lore.kernel.org/r/20221107125236.260132-2-dylany@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1337,12 +1337,12 @@ retry:
 		return IOU_OK;
 	}
 
-	if (ret >= 0 &&
-	    io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, false))
+	if (ret < 0)
+		return ret;
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, true))
 		goto retry;
 
-	io_req_set_res(req, ret, 0);
-	return (issue_flags & IO_URING_F_MULTISHOT) ? IOU_STOP_MULTISHOT : IOU_OK;
+	return -ECANCELED;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


