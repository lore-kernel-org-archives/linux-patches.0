Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1C71F1534;
	Sat, 12 Sep 2026 08:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201641; cv=none; b=d7gSN0OyBjnnnGNvI9kWPjjJC1BikAJrEbD0/om2j0U5KxlxApDZaz+KFLPF1UdGZAnlLMtQ2DdeXrllGUSF1Ee8OLxLZCEKLKXRrp7sW49oSjqcMeEQUk3P/A/dfNEzPuol0BuR5f3orp6CiZZI09EHtXRrIebjoPimmccwu2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201641; c=relaxed/simple;
	bh=F/b9SEPxSIHBYg/NaK548GaKXiLzQLLlzEPx/8AV1q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4oFenMJqSLdKSYKv4ApJWIrL1G7lHnmhnC/YABK9jfCLGamTtwXKwiKyZ67ScWGc1vkte7TlNV+K7HlqMB7w7J4Kgmjm97iAXz5/qmTC43B80YcdUVkPAZ1X4wo/tVd/n4YOH2eRbfxE/pvRX4JuhmtcXgHUTUuVmcyLlSYLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9nL5cLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9nL5cLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789A61F000FF;
	Sat, 12 Sep 2026 08:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201639;
	bh=3VVqiqM6dm7+JPvAQYN9I5Amhi6DPnHnsloVnSkl7Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y9nL5cLXfo2XAExlvdjQClF3BMEunAwBTxyga42Wt8dHDCkAqK9VnuRdtSqwCQvOD
	 UkOlg5hoHiCs0w/I7DC4wQiNgNlMj4z9yWhephxepa4G1pZfm+JitVFustBu/dtMlM
	 +kbyLKKkoDboYJ56K5k4QX9nZNTeAYagLzg/khjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1036/1815] ublk: validate auto buf reg before taking uring_cmd
Date: Sat, 12 Sep 2026 08:46:26 +0200
Message-ID: <20260912065713.340475639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/block/ublk_drv.c | 74 +++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ebd84d36cd486..1fc6449431910 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3093,18 +3093,19 @@ static inline int ublk_check_cmd_op(u32 cmd_op)
 	return 0;
 }
 
-static inline int ublk_set_auto_buf_reg(struct ublk_io *io, struct io_uring_cmd *cmd)
+/* Must run before ublk_fill_io_cmd() / __ublk_fetch(). */
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
 
@@ -3125,17 +3126,25 @@ static void ublk_clear_auto_buf_reg(struct ublk_io *io,
 		 * responsibility for unregistering the buffer, otherwise
 		 * this ublk request gets stuck.
 		 */
-		if (io->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
+		if (buf_idx &&
+		    io->buf_ctx_handle == io_uring_cmd_ctx_handle(cmd))
 			*buf_idx = io->buf.auto_reg.index;
 	}
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
-	ublk_clear_auto_buf_reg(io, cmd, buf_idx);
-	return ublk_set_auto_buf_reg(io, cmd);
+	if (ublk_dev_support_auto_buf_reg(ub)) {
+		ublk_clear_auto_buf_reg(io, cmd, buf_idx);
+		io->buf.auto_reg = *auto_buf;
+	} else {
+		io->buf.addr = buf_addr;
+	}
 }
 
 /* Once we return, `io->req` can't be used any more */
@@ -3152,18 +3161,6 @@ ublk_fill_io_cmd(struct ublk_io *io, struct io_uring_cmd *cmd)
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
@@ -3304,6 +3301,7 @@ static int __ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 		      struct ublk_io *io, __u64 buf_addr, u16 q_id)
 {
+	struct ublk_auto_buf_reg auto_buf;
 	int ret;
 
 	/*
@@ -3312,11 +3310,13 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 	 * FETCH, so it is fine even for IO_URING_F_NONBLOCK.
 	 */
 	mutex_lock(&ub->mutex);
-	ret = __ublk_fetch(cmd, ub, io, q_id);
-	if (!ret)
-		ret = ublk_config_io_buf(ub, io, cmd, buf_addr, NULL);
+	ret = ublk_validate_io_buf(ub, cmd, &auto_buf);
 	if (!ret)
+		ret = __ublk_fetch(cmd, ub, io, q_id);
+	if (!ret) {
+		ublk_apply_io_buf(ub, io, cmd, buf_addr, &auto_buf, NULL);
 		ublk_mark_io_ready(ub, q_id, io);
+	}
 	mutex_unlock(&ub->mutex);
 	return ret;
 }
@@ -3459,13 +3459,18 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
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
@@ -3474,10 +3479,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 			req->__sector = addr;
 		if (compl)
 			__ublk_complete_rq(req, io, ublk_dev_need_map_io(ub), NULL);
-
-		if (ret)
-			goto out;
 		break;
+	}
 	case UBLK_IO_NEED_GET_DATA:
 		/*
 		 * ublk_get_data() may fail and fallback to requeue, so keep
@@ -3485,8 +3488,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
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



