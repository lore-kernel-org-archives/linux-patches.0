Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB77D32FA3D;
	Fri,  9 Jan 2026 11:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959916; cv=none; b=qbCbBsHlMxHZkqHR1dplguS+yVqggvk1SMZ8HVZE1CuPj7nAUCBhToASvWSQKPnyI23Xh9TUG1OjxFRW4k+i51BdtzbMdsRb7ZTjAvl7sX4K/wPFhkTflHHU4KeOVa4W0rtVjMrJGoeScu0KiuAMoJYw5Q24uoGrPLfqNntPjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959916; c=relaxed/simple;
	bh=468pLwhaowFwz6WlUoAWHCe2hQv8fwmxNEaD/8UZGhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STLvTPwaBPXoeNdHqhyyighUT3nTLr1SPSwHoLJQxJrHlAeayPMckuFeLevY4b74+abfBTuVJX27k/etF6qUWqWbzzYekGZy55OuiYHrDrUIzdb82l403dkqQnb8T3m/bW8hbCb6ZYtLE54MJv7Jh8K/bi148vRMGY+PXplff7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmdLkvnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmdLkvnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16047C4CEF1;
	Fri,  9 Jan 2026 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959916;
	bh=468pLwhaowFwz6WlUoAWHCe2hQv8fwmxNEaD/8UZGhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmdLkvnIwN93mrp3axWi7f++L5NIC7cvMyos853I2Km0Buw4vv13YmDSxgNLSlxJL
	 O9/Y/fPR2YlLowWiK67ZysItZ4rFsLW4byBD/S/51ZnKi5I6cRKYr+MTmK7nbKhRGB
	 dQdBAYR4smbZodgWXQ/o+cnp+bNVZJW4qFHhCdig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/737] ublk: complete command synchronously on error
Date: Fri,  9 Jan 2026 12:36:00 +0100
Message-ID: <20260109112142.316242694@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 603f9be21c1894e462416e3324962d6c9c2b95f8 ]

In case of an error, ublk's ->uring_cmd() functions currently return
-EIOCBQUEUED and immediately call io_uring_cmd_done(). -EIOCBQUEUED and
io_uring_cmd_done() are intended for asynchronous completions. For
synchronous completions, the ->uring_cmd() function can just return the
negative return code directly. This skips io_uring_cmd_del_cancelable(),
and deferring the completion to task work. So return the error code
directly from __ublk_ch_uring_cmd() and ublk_ctrl_uring_cmd().

Update ublk_ch_uring_cmd_cb(), which currently ignores the return value
from __ublk_ch_uring_cmd(), to call io_uring_cmd_done() for synchronous
completions.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20250225212456.2902549-1-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c6a45ee7607d ("ublk: prevent invalid access with DEBUG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6419f304fa5e2..88d566f0ffa64 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1821,10 +1821,9 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
@@ -1880,7 +1879,10 @@ static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	ublk_ch_uring_cmd_local(cmd, issue_flags);
+	int ret = ublk_ch_uring_cmd_local(cmd, issue_flags);
+
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(cmd, ret, 0, issue_flags);
 }
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
@@ -2948,10 +2950,9 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
-	return -EIOCBQUEUED;
+	return ret;
 }
 
 static const struct file_operations ublk_ctl_fops = {
-- 
2.51.0



