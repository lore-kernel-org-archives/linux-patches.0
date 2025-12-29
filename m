Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F889460;
	Mon, 29 Dec 2025 16:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025304; cv=none; b=nfeuIoKTtufO0ZiE1Qmz0AoY3mqiGDVOxGmRbHauOebnAULNuzC9aMPk81oY6kt/7dtdDrxxmmw8JbZdBIpo0HxJdG6PpUaO8lNdWs6hubMMYD5AlV/U5fVIEsD4z1IUk4i4J0VPP5jYtoXxpFLJcWJ7dEN42G9cRmr1uAsyl3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025304; c=relaxed/simple;
	bh=z3HXxZAaV+nOsiEgsks6hL4yuD1rUh+XgiRgh1YNaGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJowS2JkaZF/nzHNsjVk03Iek0zGx+nganj64gpLqSNlHpv8prqZVXelzPS7ZBx3r9Zw5/dpqyv9hfPAK1v0IpY3ht/ADeuGgSZRvkU7lWn+QsV4DDu9EAl14wwRKFD7nJgNlNHWgSpStPdjZ/A/p6bpD0N9JclToB0U1ttSjDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhtZYHms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhtZYHms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F08C4CEF7;
	Mon, 29 Dec 2025 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025304;
	bh=z3HXxZAaV+nOsiEgsks6hL4yuD1rUh+XgiRgh1YNaGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhtZYHmsESWulpKffpD06ynHwRqxtStnbpXHkhZAo3t/5Klw15GUX9nCC8BkUnhI7
	 bCgVgi3IpG0ji/oPwakv+JKntlgAsb/pbHjCoNQNYXuf9OVNv12r0uCAuYEsKg+pyl
	 3srWGXRfHD3SnwvmRaSqe+ZQbei4KX8Qxz/iPBPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/430] ublk: add `union ublk_io_buf` with improved naming
Date: Mon, 29 Dec 2025 17:08:55 +0100
Message-ID: <20251229160729.259722124@linuxfoundation.org>
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

[ Upstream commit 8d61ece156bd4f2b9e7d3b2a374a26d42c7a4a06 ]

Add `union ublk_io_buf` for naming the anonymous union of struct ublk_io's
addr and buf fields, meantime apply it to `struct ublk_io` for storing either
ublk auto buffer register data or ublk server io buffer address.

The union uses clear field names:
- `addr`: for regular ublk server io buffer addresses
- `auto_reg`: for ublk auto buffer registration data

This eliminates confusing access patterns and improves code readability.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c258f5c4502c ("ublk: fix deadlock when reading partition table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 599571634b7a..c9d258b99090 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -155,12 +155,13 @@ struct ublk_uring_cmd_pdu {
  */
 #define UBLK_REFCOUNT_INIT (REFCOUNT_MAX / 2)
 
+union ublk_io_buf {
+	__u64	addr;
+	struct ublk_auto_buf_reg auto_reg;
+};
+
 struct ublk_io {
-	/* userspace buffer address from io cmd */
-	union {
-		__u64	addr;
-		struct ublk_auto_buf_reg buf;
-	};
+	union ublk_io_buf buf;
 	unsigned int flags;
 	int res;
 
@@ -499,7 +500,7 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
 	iod->op_flags = ublk_op | ublk_req_build_flags(req);
 	iod->nr_sectors = blk_rq_sectors(req);
 	iod->start_sector = blk_rq_pos(req);
-	iod->addr = io->addr;
+	iod->addr = io->buf.addr;
 
 	return BLK_STS_OK;
 }
@@ -1047,7 +1048,7 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct iov_iter iter;
 		const int dir = ITER_DEST;
 
-		import_ubuf(dir, u64_to_user_ptr(io->addr), rq_bytes, &iter);
+		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), rq_bytes, &iter);
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
@@ -1068,7 +1069,7 @@ static int ublk_unmap_io(bool need_map,
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		import_ubuf(dir, u64_to_user_ptr(io->addr), io->res, &iter);
+		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), io->res, &iter);
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
@@ -1134,7 +1135,7 @@ static blk_status_t ublk_setup_iod(struct ublk_queue *ubq, struct request *req)
 	iod->op_flags = ublk_op | ublk_req_build_flags(req);
 	iod->nr_sectors = blk_rq_sectors(req);
 	iod->start_sector = blk_rq_pos(req);
-	iod->addr = io->addr;
+	iod->addr = io->buf.addr;
 
 	return BLK_STS_OK;
 }
@@ -1248,9 +1249,9 @@ static bool ublk_auto_buf_reg(const struct ublk_queue *ubq, struct request *req,
 	int ret;
 
 	ret = io_buffer_register_bvec(cmd, req, ublk_io_release,
-				      io->buf.index, issue_flags);
+				      io->buf.auto_reg.index, issue_flags);
 	if (ret) {
-		if (io->buf.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
+		if (io->buf.auto_reg.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
 			ublk_auto_buf_reg_fallback(ubq, io);
 			return true;
 		}
@@ -1539,7 +1540,7 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 		 */
 		io->flags &= UBLK_IO_FLAG_CANCELED;
 		io->cmd = NULL;
-		io->addr = 0;
+		io->buf.addr = 0;
 
 		/*
 		 * old task is PF_EXITING, put it now
@@ -2100,13 +2101,16 @@ static inline int ublk_check_cmd_op(u32 cmd_op)
 
 static inline int ublk_set_auto_buf_reg(struct ublk_io *io, struct io_uring_cmd *cmd)
 {
-	io->buf = ublk_sqe_addr_to_auto_buf_reg(READ_ONCE(cmd->sqe->addr));
+	struct ublk_auto_buf_reg buf;
+
+	buf = ublk_sqe_addr_to_auto_buf_reg(READ_ONCE(cmd->sqe->addr));
 
-	if (io->buf.reserved0 || io->buf.reserved1)
+	if (buf.reserved0 || buf.reserved1)
 		return -EINVAL;
 
-	if (io->buf.flags & ~UBLK_AUTO_BUF_REG_F_MASK)
+	if (buf.flags & ~UBLK_AUTO_BUF_REG_F_MASK)
 		return -EINVAL;
+	io->buf.auto_reg = buf;
 	return 0;
 }
 
@@ -2128,7 +2132,7 @@ static int ublk_handle_auto_buf_reg(struct ublk_io *io,
 		 * this ublk request gets stuck.
 		 */
 		if (io->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
-			*buf_idx = io->buf.index;
+			*buf_idx = io->buf.auto_reg.index;
 	}
 
 	return ublk_set_auto_buf_reg(io, cmd);
@@ -2156,7 +2160,7 @@ ublk_config_io_buf(const struct ublk_device *ub, struct ublk_io *io,
 	if (ublk_dev_support_auto_buf_reg(ub))
 		return ublk_handle_auto_buf_reg(io, cmd, buf_idx);
 
-	io->addr = buf_addr;
+	io->buf.addr = buf_addr;
 	return 0;
 }
 
@@ -2353,7 +2357,7 @@ static bool ublk_get_data(const struct ublk_queue *ubq, struct ublk_io *io,
 	 */
 	io->flags &= ~UBLK_IO_FLAG_NEED_GET_DATA;
 	/* update iod->addr because ublksrv may have passed a new io buffer */
-	ublk_get_iod(ubq, req->tag)->addr = io->addr;
+	ublk_get_iod(ubq, req->tag)->addr = io->buf.addr;
 	pr_devel("%s: update iod->addr: qid %d tag %d io_flags %x addr %llx\n",
 			__func__, ubq->q_id, req->tag, io->flags,
 			ublk_get_iod(ubq, req->tag)->addr);
-- 
2.51.0



