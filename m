Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A2C33121F;
	Mon, 29 Dec 2025 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025285; cv=none; b=mjhE7PRHOXUTnzU3JnzgW36p9tWo8eMU3Vl93ZlconlmfqqcCQyO0OUJ9OnIX0c8e3VPqOIAGmUh2vv2FFxhtmH+Lky27XFe5UC/UTmOayqjxFsDIiAUDPHuDyWRkVa28u96tAiUYjGvI56DwyOJaqU3EZzMP7MdfuIMnWdI/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025285; c=relaxed/simple;
	bh=JrbYSg1sO6GI3PLi7g7gZnaFrHffUv66snvX5gHjAps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kgy+bu4tD32/9XlWoq5VhTW+wK3JN+lYDMBqWfToGvM0Kc8uoss157KbWIXOgPIhhqqbd5tKo30JcjgrknJjy7y4VbLodWdpM9Ko/zml7e7FrwxNSCyAnw7lHzhjasFe6w7txbgeLAN2wtKIPij1N4ZMSI2QI/Odz+eN5oYrSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coLWpZe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coLWpZe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BAAC4CEF7;
	Mon, 29 Dec 2025 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025285;
	bh=JrbYSg1sO6GI3PLi7g7gZnaFrHffUv66snvX5gHjAps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coLWpZe5+pv/fDX+z2/Tp5b92cQdLxdRd/jrci5yPcvqVlYtPuMMYMEp7lt7iw9TY
	 lcKT8uJP7A9aPOCMRiR8WCPnP5CciVJ/pGVOy8mtwflp3+YszRweJBiH5fsn6S7LSi
	 mUSP83NG16KeNg3WzUWgbkJgC2Q8L2ZtNQ5Kthhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/430] ublk: add parameter `struct io_uring_cmd *` to ublk_prep_auto_buf_reg()
Date: Mon, 29 Dec 2025 17:08:54 +0100
Message-ID: <20251229160729.223327259@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3035b9b46b0611898babc0b96ede65790d3566f7 ]

Add parameter `struct io_uring_cmd *` to ublk_prep_auto_buf_reg() and
prepare for reusing this helper for the coming UBLK_BATCH_IO feature,
which can fetch & commit one batch of io commands via single uring_cmd.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c258f5c4502c ("ublk: fix deadlock when reading partition table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 359564c40cb5..599571634b7a 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1242,11 +1242,12 @@ ublk_auto_buf_reg_fallback(const struct ublk_queue *ubq, struct ublk_io *io)
 }
 
 static bool ublk_auto_buf_reg(const struct ublk_queue *ubq, struct request *req,
-			      struct ublk_io *io, unsigned int issue_flags)
+			      struct ublk_io *io, struct io_uring_cmd *cmd,
+			      unsigned int issue_flags)
 {
 	int ret;
 
-	ret = io_buffer_register_bvec(io->cmd, req, ublk_io_release,
+	ret = io_buffer_register_bvec(cmd, req, ublk_io_release,
 				      io->buf.index, issue_flags);
 	if (ret) {
 		if (io->buf.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
@@ -1258,18 +1259,19 @@ static bool ublk_auto_buf_reg(const struct ublk_queue *ubq, struct request *req,
 	}
 
 	io->task_registered_buffers = 1;
-	io->buf_ctx_handle = io_uring_cmd_ctx_handle(io->cmd);
+	io->buf_ctx_handle = io_uring_cmd_ctx_handle(cmd);
 	io->flags |= UBLK_IO_FLAG_AUTO_BUF_REG;
 	return true;
 }
 
 static bool ublk_prep_auto_buf_reg(struct ublk_queue *ubq,
 				   struct request *req, struct ublk_io *io,
+				   struct io_uring_cmd *cmd,
 				   unsigned int issue_flags)
 {
 	ublk_init_req_ref(ubq, io);
 	if (ublk_support_auto_buf_reg(ubq) && ublk_rq_has_data(req))
-		return ublk_auto_buf_reg(ubq, req, io, issue_flags);
+		return ublk_auto_buf_reg(ubq, req, io, cmd, issue_flags);
 
 	return true;
 }
@@ -1344,7 +1346,7 @@ static void ublk_dispatch_req(struct ublk_queue *ubq,
 	if (!ublk_start_io(ubq, req, io))
 		return;
 
-	if (ublk_prep_auto_buf_reg(ubq, req, io, issue_flags))
+	if (ublk_prep_auto_buf_reg(ubq, req, io, io->cmd, issue_flags))
 		ublk_complete_io_cmd(io, req, UBLK_IO_RES_OK, issue_flags);
 }
 
-- 
2.51.0



