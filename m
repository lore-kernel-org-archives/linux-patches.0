Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532FC32BF21;
	Fri,  9 Jan 2026 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959919; cv=none; b=i7baYNlVI+q8lZ+YQD6Vc3BK9jYaeMI+7KuyopvUklrNfcCmibE1r9eUA+R9/MIN7E4VcG/mGp5fXrtd2zi+jKBrEW2nDFh5Cgf9uVrAEgu+JHwMF9hYPEpd7V6o6y7BnnW3MaENI57gv3Novw92/0T2IRuy93qo86quIBSA2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959919; c=relaxed/simple;
	bh=cwMbQRweGBlBX5YMA5qcgqHrEVJlH+mKzGlbYa4bfE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuSferQg9xaSTmuZDb2fOElZUAxSlPUnAOg5IZIsW6wllYGiOp6nOqTUnnx8RIWoDZmSloQX81Qf37zi4tvdhl/i2GdZnfNxfA+HRQ5e52s/tq2ypqu4plOZnl/yNo+KKdgkypjWB++EXmKncp7PiJYmZtAglFLugIQtv6pVLUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYmLF7qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYmLF7qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65C3C4CEF1;
	Fri,  9 Jan 2026 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959919;
	bh=cwMbQRweGBlBX5YMA5qcgqHrEVJlH+mKzGlbYa4bfE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYmLF7qqhAf03VBw/5eAAkmC9y99YCd1UYEfy8v6d+gOraT0i6erVxPXFByci4oBu
	 NIy68StkYh/li1PgVdjVAxQ8aRr/kHMdgfYtArEGqsQanWEw2eIDyYgG8OUBzg2lc9
	 OnWPzNZIp61FgORlCMGpVayqTFAHTG7Jwe1896iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/737] ublk: prevent invalid access with DEBUG
Date: Fri,  9 Jan 2026 12:36:01 +0100
Message-ID: <20260109112142.353460403@linuxfoundation.org>
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
index 88d566f0ffa64..563b2a94d4c3c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1709,7 +1709,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 {
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
-	struct ublk_io *io;
+	struct ublk_io *io = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	unsigned tag = ub_cmd->tag;
 	int ret = -EINVAL;
@@ -1822,7 +1822,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 
  out:
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
-			__func__, cmd_op, tag, ret, io->flags);
+			__func__, cmd_op, tag, ret, io ? io->flags : 0);
 	return ret;
 }
 
-- 
2.51.0



