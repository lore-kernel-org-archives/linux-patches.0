Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43B54431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4BDC433EF;
	Wed, 15 Mar 2023 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883907;
	bh=ihCHgicI0ipRToJDLyDkyFn+wsKjm8rDO1QA56RcJiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLiaKWGPmEM0ogHTVChVLGRKEgOKsk0ZEwqZbg7NahIFhD/rNMgF4Zq4Hi8c8n3vr
	 ej6np9ASV+8C2en7w9pug0Uiv++d7+3BiAULLUMamZz3fMxLgDZzc1heP9ZqaOOEUU
	 OjZ1YmAuzfnjraTcpc1MuE7M6fT86OrXOp0irfPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.2 005/141] io_uring/uring_cmd: ensure that device supports IOPOLL
Date: Wed, 15 Mar 2023 13:11:48 +0100
Message-Id: <20230315115740.124815256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

commit 03b3d6be73e81ddb7c2930d942cdd17f4cfd5ba5 upstream.

It's possible for a file type to support uring commands, but not
pollable ones. Hence before issuing one of those, we should check
that it is supported and error out upfront if it isn't.

Cc: stable@vger.kernel.org
Fixes: 5756a3a7e713 ("io_uring: add iopoll infrastructure for io_uring_cmd")
Link: https://github.com/axboe/liburing/issues/816
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -108,7 +108,7 @@ int io_uring_cmd(struct io_kiocb *req, u
 	struct file *file = req->file;
 	int ret;
 
-	if (!req->file->f_op->uring_cmd)
+	if (!file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
 
 	ret = security_uring_cmd(ioucmd);
@@ -120,6 +120,8 @@ int io_uring_cmd(struct io_kiocb *req, u
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
+		if (!file->f_op->uring_cmd_iopoll)
+			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);


