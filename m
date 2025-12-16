Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4443557E8;
	Tue, 16 Dec 2025 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886216; cv=none; b=pM6cVs6JSeLIv6DLmRIQ2Mg/sQuOiDERmzCTJC1UOSgSZ/FqOtVkk5cQXeY5E7INdSuwYvbstQSoWVkePmbFiPlHao4mlX7dAle00FwbG5jiaozZuzxP8t4RvsAMUY/IlVxyYnxrLvUfOAY/nGEPxVskIr+ezfUsS9ILHfgHUjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886216; c=relaxed/simple;
	bh=jSS4Nno4Zrdu/hI8+sB+uxxZUyqrFi9w836mEzrkM9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8EEnTxGT4W9gbvmK2Fwg8s6iSF7bj9g5AYk29RtuhmIJlpGhQGyjfgUU0WH41sr6lGZk5rVCajrV6O+0IQom7HYROZ4V+C3S12vPKwFm0Nw6hdEeA03AOudZw6ml9igxAJwNVAeOqAAB8a3tfxExfzKZTjf6IgMpZfCqWaXSfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1vWyB7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1vWyB7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA171C4CEF1;
	Tue, 16 Dec 2025 11:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886216;
	bh=jSS4Nno4Zrdu/hI8+sB+uxxZUyqrFi9w836mEzrkM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1vWyB7jVHfxBBoI7GJYUafclahx/v7hLSRokqEDrn5PqI2zZFySkmLxoTm8ELGHi
	 0o2WeAotJ1zjoM4LMw/fG+IANguT22cUL4kROpBdtrNGelI1CK3hkqNtPNWauCCMRK
	 3gO7hyEM7kmvcOvAXpgbmmr2sAVp3lIvsH2gUriY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 371/507] ublk: prevent invalid access with DEBUG
Date: Tue, 16 Dec 2025 12:13:32 +0100
Message-ID: <20251216111358.899608528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Brodsky <kevin.brodsky@arm.com>

[ Upstream commit c6a45ee7607de3a350008630f4369b1b5ac80884 ]

ublk_ch_uring_cmd_local() may jump to the out label before
initialising the io pointer. This will cause trouble if DEBUG is
defined, because the pr_devel() call dereferences io. Clang reports:

drivers/block/ublk_drv.c:2403:6: error: variable 'io' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
 2403 |         if (tag >= ub->dev_info.queue_depth)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/block/ublk_drv.c:2492:32: note: uninitialized use occurs here
 2492 |                         __func__, cmd_op, tag, ret, io->flags);
      |

Fix this by initialising io to NULL and checking it before
dereferencing it.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 67d4a867aec48..c12bee92fcfd2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2340,7 +2340,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	u16 buf_idx = UBLK_INVALID_BUF_IDX;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
-	struct ublk_io *io;
+	struct ublk_io *io = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	unsigned tag = ub_cmd->tag;
 	struct request *req;
@@ -2458,7 +2458,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 
  out:
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
-			__func__, cmd_op, tag, ret, io->flags);
+			__func__, cmd_op, tag, ret, io ? io->flags : 0);
 	return ret;
 }
 
-- 
2.51.0



