Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7B321D596;
	Wed, 25 Feb 2026 01:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982870; cv=none; b=JxL6/7/iETOoZoxhcy8Uc/niOqJctfsJc5iJavCszbwahDskBd8bFF4sXV0FHJWuBkzI+1lkZwOOVwOhjq4EALZD5CxMuVjlXF+wuSfV2VqzlST3dHWhdNa0qv9VNjhyJ0Vy0sQUL0LUhqJ1IbQJLy2o4YeQK35O2H7draYhEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982870; c=relaxed/simple;
	bh=6tG94616Mie+Y9od8ss6cVVbzD5eOOkkkP5Do/+O/PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dODKy9/OCflhL9pQLI7ZuR6bfInuFA45bEr0F89WEEJFiDAYkchhhnEMRi7dUWsKBv+BY5uqMsnXT3az1eoki9vus3OGje4sa1r31h5xl1YKhcJlcrd8CLT0fzxEv6qIABilETXeiMl5LyB5PbZz+NAPpJlYf/XQ9ZwfXeKoUT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBjlU72m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBjlU72m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46240C116D0;
	Wed, 25 Feb 2026 01:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982870;
	bh=6tG94616Mie+Y9od8ss6cVVbzD5eOOkkkP5Do/+O/PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBjlU72m07SQ6Qh8p0QO4FblaDjjjzuA/pyLIp5C689ZBGFq5BYw01QKlLuO/Vslj
	 uob9Nd/ZSk7rIGPotEj1wyFGgWRr57dbtRP1Ezv75syfvCaQswdT4+DM+y/fCJ3b6Z
	 bfFoI6CLMNeUg+AXGlRqoa1yty1vTTpRxc4ooFsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 056/781] ublk: use READ_ONCE() to read struct ublksrv_ctrl_cmd
Date: Tue, 24 Feb 2026 17:12:45 -0800
Message-ID: <20260225012401.080776686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ed9f54cc1e335096733aed03c2a46de3d58922ed ]

struct ublksrv_ctrl_cmd is part of the io_uring_sqe, which may lie in
userspace-mapped memory. It's racy to access its fields with normal
loads, as userspace may write to them concurrently. Use READ_ONCE() to
copy the ublksrv_ctrl_cmd from the io_uring_sqe to the stack. Use the
local copy in place of the one in the io_uring_sqe.

Fixes: 87213b0d847c ("ublk: allow non-blocking ctrl cmds in IO_URING_F_NONBLOCK issue")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 56 ++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0ce0e537fb850..06e0790150d1d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3311,12 +3311,11 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub, bool wait)
 	return 0;
 }
 
-static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
+static inline void ublk_ctrl_cmd_dump(u32 cmd_op,
+				      const struct ublksrv_ctrl_cmd *header)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
-
 	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
-			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
+			__func__, cmd_op, header->dev_id, header->queue_id,
 			header->data[0], header->addr, header->len);
 }
 
@@ -3685,9 +3684,8 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 }
 
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
-		struct io_uring_cmd *cmd)
+		u32 cmd_op, struct ublksrv_ctrl_cmd *header)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)io_uring_sqe_cmd(cmd->sqe);
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	char *dev_path = NULL;
@@ -3703,7 +3701,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		 * know if the specified device is created as unprivileged
 		 * mode.
 		 */
-		if (_IOC_NR(cmd->cmd_op) != UBLK_CMD_GET_DEV_INFO2)
+		if (_IOC_NR(cmd_op) != UBLK_CMD_GET_DEV_INFO2)
 			return 0;
 	}
 
@@ -3724,7 +3722,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		return PTR_ERR(dev_path);
 
 	ret = -EINVAL;
-	switch (_IOC_NR(cmd->cmd_op)) {
+	switch (_IOC_NR(cmd_op)) {
 	case UBLK_CMD_GET_DEV_INFO:
 	case UBLK_CMD_GET_DEV_INFO2:
 	case UBLK_CMD_GET_QUEUE_AFFINITY:
@@ -3753,7 +3751,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		header->addr += header->dev_path_len;
 	}
 	pr_devel("%s: dev id %d cmd_op %x uid %d gid %d path %s ret %d\n",
-			__func__, ub->ub_number, cmd->cmd_op,
+			__func__, ub->ub_number, cmd_op,
 			ub->dev_info.owner_uid, ub->dev_info.owner_gid,
 			dev_path, ret);
 exit:
@@ -3777,7 +3775,9 @@ static bool ublk_ctrl_uring_cmd_may_sleep(u32 cmd_op)
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
+	/* May point to userspace-mapped memory */
+	const struct ublksrv_ctrl_cmd *ub_src = io_uring_sqe_cmd(cmd->sqe);
+	struct ublksrv_ctrl_cmd header;
 	struct ublk_device *ub = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	int ret = -EINVAL;
@@ -3789,41 +3789,47 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (!(issue_flags & IO_URING_F_SQE128))
 		return -EINVAL;
 
-	ublk_ctrl_cmd_dump(cmd);
+	header.dev_id = READ_ONCE(ub_src->dev_id);
+	header.queue_id = READ_ONCE(ub_src->queue_id);
+	header.len = READ_ONCE(ub_src->len);
+	header.addr = READ_ONCE(ub_src->addr);
+	header.data[0] = READ_ONCE(ub_src->data[0]);
+	header.dev_path_len = READ_ONCE(ub_src->dev_path_len);
+	ublk_ctrl_cmd_dump(cmd_op, &header);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
 		goto out;
 
 	if (cmd_op == UBLK_U_CMD_GET_FEATURES) {
-		ret = ublk_ctrl_get_features(header);
+		ret = ublk_ctrl_get_features(&header);
 		goto out;
 	}
 
 	if (_IOC_NR(cmd_op) != UBLK_CMD_ADD_DEV) {
 		ret = -ENODEV;
-		ub = ublk_get_device_from_id(header->dev_id);
+		ub = ublk_get_device_from_id(header.dev_id);
 		if (!ub)
 			goto out;
 
-		ret = ublk_ctrl_uring_cmd_permission(ub, cmd);
+		ret = ublk_ctrl_uring_cmd_permission(ub, cmd_op, &header);
 		if (ret)
 			goto put_dev;
 	}
 
 	switch (_IOC_NR(cmd_op)) {
 	case UBLK_CMD_START_DEV:
-		ret = ublk_ctrl_start_dev(ub, header);
+		ret = ublk_ctrl_start_dev(ub, &header);
 		break;
 	case UBLK_CMD_STOP_DEV:
 		ret = ublk_ctrl_stop_dev(ub);
 		break;
 	case UBLK_CMD_GET_DEV_INFO:
 	case UBLK_CMD_GET_DEV_INFO2:
-		ret = ublk_ctrl_get_dev_info(ub, header);
+		ret = ublk_ctrl_get_dev_info(ub, &header);
 		break;
 	case UBLK_CMD_ADD_DEV:
-		ret = ublk_ctrl_add_dev(header);
+		ret = ublk_ctrl_add_dev(&header);
 		break;
 	case UBLK_CMD_DEL_DEV:
 		ret = ublk_ctrl_del_dev(&ub, true);
@@ -3832,26 +3838,26 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		ret = ublk_ctrl_del_dev(&ub, false);
 		break;
 	case UBLK_CMD_GET_QUEUE_AFFINITY:
-		ret = ublk_ctrl_get_queue_affinity(ub, header);
+		ret = ublk_ctrl_get_queue_affinity(ub, &header);
 		break;
 	case UBLK_CMD_GET_PARAMS:
-		ret = ublk_ctrl_get_params(ub, header);
+		ret = ublk_ctrl_get_params(ub, &header);
 		break;
 	case UBLK_CMD_SET_PARAMS:
-		ret = ublk_ctrl_set_params(ub, header);
+		ret = ublk_ctrl_set_params(ub, &header);
 		break;
 	case UBLK_CMD_START_USER_RECOVERY:
-		ret = ublk_ctrl_start_recovery(ub, header);
+		ret = ublk_ctrl_start_recovery(ub, &header);
 		break;
 	case UBLK_CMD_END_USER_RECOVERY:
-		ret = ublk_ctrl_end_recovery(ub, header);
+		ret = ublk_ctrl_end_recovery(ub, &header);
 		break;
 	case UBLK_CMD_UPDATE_SIZE:
-		ublk_ctrl_set_size(ub, header);
+		ublk_ctrl_set_size(ub, &header);
 		ret = 0;
 		break;
 	case UBLK_CMD_QUIESCE_DEV:
-		ret = ublk_ctrl_quiesce_dev(ub, header);
+		ret = ublk_ctrl_quiesce_dev(ub, &header);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
@@ -3863,7 +3869,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		ublk_put_device(ub);
  out:
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
-			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
+			__func__, ret, cmd_op, header.dev_id, header.queue_id);
 	return ret;
 }
 
-- 
2.51.0



