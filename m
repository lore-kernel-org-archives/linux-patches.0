Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C803E557D;
	Tue, 13 Oct 2026 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894099; cv=none; b=VrBl2uuR5WuP7FBcI3BYwlAuzimQDiVKUi4/WGr1O3a8jMM3O+x+bg8+zbl42WpS9oj+RQ5vaH/jifuUOmpTlSm9/D8StK211vgV+srd45tkudh3tGk4J+bBFwJ3IQMH231sRcclMEnnC19w7QjtZx9EDrtdWOAuwIpdVCBuJkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894099; c=relaxed/simple;
	bh=X5FIGRqnJE5uq5MYKhzoPs2YeFPrid97sp2nsq+bses=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYjSYziOUUbZbGebqmQCIDZfaWTX8lZB6Mn1fvxeEEMU1pxU6exw3Uby0MLehKxis18F5TFk2gbXFYi5xtVyJcgl7rB/JSKk4IxKCZ/B59dccrsSap1buGH2xc2Wz6wvpq5aUKPVjpTcuynXY8368Hgx5Tn5Iu+2P3X2/1cDE38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7Nq4J6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7Nq4J6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD651F000FF;
	Tue, 13 Oct 2026 12:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894098;
	bh=dXhFfMQQ1fKIxotbeQ8WUTKKvdtWKc4VhCCbr5d2ByA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7Nq4J6Ffk6XNgliRuADWIcVRF3JrBTjiH4If/S0K9OaBLuG2InLu9MvOtc069dn8
	 24Nd9HKR+OY66ntLdU3pjR88SdydenvL72MMVMp3fs/Oe9AwoVe1Xj2Ltf+giOvjDV
	 9CjjqxXNC5aOnVFbkU13vEYjt4VMw0BUvHDtuJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 447/621] ublk: validate auto buf reg before taking uring_cmd
Date: Tue, 13 Oct 2026 13:37:22 +0200
Message-ID: <20261013112931.438932619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit ca5a01eee34c7cbe0f531a613b0292a3ad1a419b ]

With UBLK_F_AUTO_BUF_REG, invalid sqe->addr can fail after
ublk_fill_io_cmd() has set UBLK_IO_FLAG_ACTIVE. The uring_cmd is
completed while the tag stays active, which can hang teardown.

Split validation from buffer apply so the check has no side effects,
then take the uring_cmd and store the already-validated buffer. Apply
the same order in FETCH so io->buf is not written before __ublk_fetch()
state checks.

Fixes: 52460dda3a77 ("ublk: move auto buffer register handling into one dedicated helper")
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 75 +++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index d1959b4445710..f44512ed12176 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2188,25 +2188,34 @@ static inline int ublk_check_cmd_op(u32 cmd_op)
 	return 0;
 }
 
-static inline int ublk_set_auto_buf_reg(struct ublk_io *io, struct io_uring_cmd *cmd)
+/* Must run before ublk_fill_io_cmd(). */
+static inline int ublk_validate_io_buf(const struct ublk_device *ub,
+				       struct io_uring_cmd *cmd,
+				       struct ublk_auto_buf_reg *buf)
 {
-	struct ublk_auto_buf_reg buf;
-
-	buf = ublk_sqe_addr_to_auto_buf_reg(READ_ONCE(cmd->sqe->addr));
+	if (!ublk_dev_support_auto_buf_reg(ub))
+		return 0;
 
-	if (buf.reserved0 || buf.reserved1)
+	*buf = ublk_sqe_addr_to_auto_buf_reg(READ_ONCE(cmd->sqe->addr));
+	if (buf->reserved0 || buf->reserved1)
 		return -EINVAL;
-
-	if (buf.flags & ~UBLK_AUTO_BUF_REG_F_MASK)
+	if (buf->flags & ~UBLK_AUTO_BUF_REG_F_MASK)
 		return -EINVAL;
-	io->buf.auto_reg = buf;
 	return 0;
 }
 
-static int ublk_handle_auto_buf_reg(struct ublk_io *io,
-				    struct io_uring_cmd *cmd,
-				    u16 *buf_idx)
+static inline void ublk_apply_io_buf(const struct ublk_device *ub,
+				     struct ublk_io *io,
+				     struct io_uring_cmd *cmd,
+				     unsigned long buf_addr,
+				     const struct ublk_auto_buf_reg *auto_buf,
+				     u16 *buf_idx)
 {
+	if (!ublk_dev_support_auto_buf_reg(ub)) {
+		io->buf.addr = buf_addr;
+		return;
+	}
+
 	if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG) {
 		io->flags &= ~UBLK_IO_FLAG_AUTO_BUF_REG;
 
@@ -2220,11 +2229,12 @@ static int ublk_handle_auto_buf_reg(struct ublk_io *io,
 		 * responsibility for unregistering the buffer, otherwise
 		 * this ublk request gets stuck.
 		 */
-		if (io->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
+		if (buf_idx &&
+		    io->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
 			*buf_idx = io->buf.auto_reg.index;
 	}
 
-	return ublk_set_auto_buf_reg(io, cmd);
+	io->buf.auto_reg = *auto_buf;
 }
 
 /* Once we return, `io->req` can't be used any more */
@@ -2241,18 +2251,6 @@ ublk_fill_io_cmd(struct ublk_io *io, struct io_uring_cmd *cmd)
 	return req;
 }
 
-static inline int
-ublk_config_io_buf(const struct ublk_device *ub, struct ublk_io *io,
-		   struct io_uring_cmd *cmd, unsigned long buf_addr,
-		   u16 *buf_idx)
-{
-	if (ublk_dev_support_auto_buf_reg(ub))
-		return ublk_handle_auto_buf_reg(io, cmd, buf_idx);
-
-	io->buf.addr = buf_addr;
-	return 0;
-}
-
 static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 				    unsigned int issue_flags,
 				    struct ublk_queue *ubq, unsigned int tag)
@@ -2370,7 +2368,8 @@ static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_addr)
 static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 		      struct ublk_queue *ubq, struct ublk_io *io, __u64 buf_addr)
 {
-	int ret = 0;
+	struct ublk_auto_buf_reg auto_buf;
+	int ret;
 
 	/*
 	 * When handling FETCH command for setting up ublk uring queue,
@@ -2378,6 +2377,10 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 	 * FETCH, so it is fine even for IO_URING_F_NONBLOCK.
 	 */
 	mutex_lock(&ub->mutex);
+	ret = ublk_validate_io_buf(ub, cmd, &auto_buf);
+	if (ret)
+		goto out;
+
 	/* UBLK_IO_FETCH_REQ is only allowed before dev is setup */
 	if (ublk_dev_ready(ub)) {
 		ret = -EBUSY;
@@ -2393,9 +2396,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV);
 
 	ublk_fill_io_cmd(io, cmd);
-	ret = ublk_config_io_buf(ub, io, cmd, buf_addr, NULL);
-	if (ret)
-		goto out;
+	ublk_apply_io_buf(ub, io, cmd, buf_addr, &auto_buf, NULL);
 
 	WRITE_ONCE(io->task, get_task_struct(current));
 	ublk_mark_io_ready(ub, ubq, io);
@@ -2541,13 +2542,18 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 	case UBLK_IO_REGISTER_IO_BUF:
 		return ublk_daemon_register_io_buf(cmd, ub, q_id, tag, io, addr,
 						   issue_flags);
-	case UBLK_IO_COMMIT_AND_FETCH_REQ:
+	case UBLK_IO_COMMIT_AND_FETCH_REQ: {
+		struct ublk_auto_buf_reg auto_buf;
+
 		ret = ublk_check_commit_and_fetch(ub, io, addr);
+		if (ret)
+			goto out;
+		ret = ublk_validate_io_buf(ub, cmd, &auto_buf);
 		if (ret)
 			goto out;
 		io->res = result;
 		req = ublk_fill_io_cmd(io, cmd);
-		ret = ublk_config_io_buf(ub, io, cmd, addr, &buf_idx);
+		ublk_apply_io_buf(ub, io, cmd, addr, &auto_buf, &buf_idx);
 		if (buf_idx != UBLK_INVALID_BUF_IDX)
 			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
 		compl = ublk_need_complete_req(ub, io);
@@ -2557,10 +2563,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 			req->__sector = addr;
 		if (compl)
 			__ublk_complete_rq(req, io, ublk_dev_need_map_io(ub));
-
-		if (ret)
-			goto out;
 		break;
+	}
 	case UBLK_IO_NEED_GET_DATA:
 		/*
 		 * ublk_get_data() may fail and fallback to requeue, so keep
@@ -2568,8 +2572,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		 * request
 		 */
 		req = ublk_fill_io_cmd(io, cmd);
-		ret = ublk_config_io_buf(ub, io, cmd, addr, NULL);
-		WARN_ON_ONCE(ret);
+		io->buf.addr = addr;
 		if (likely(ublk_get_data(ubq, io, req))) {
 			__ublk_prep_compl_io_cmd(io, req);
 			return UBLK_IO_RES_OK;
-- 
2.53.0



