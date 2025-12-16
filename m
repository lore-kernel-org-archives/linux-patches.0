Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BDB2BE7B2;
	Tue, 16 Dec 2025 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884662; cv=none; b=eztcW9yO9Y1TJlccochn4EfKhEFpa8DFvNeQvQrUolBLBE1drKznJoSnLcet2EJS1WbzzPA9gifwsagF/XXIvyp+YP4I5ihbT3e2cz1zj5kOddsrnlMZWpI5IJP2S7ttBM/ZRWtsZNkW0vUIZmmFCg44dctQD7XJz8dy6Kkg6wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884662; c=relaxed/simple;
	bh=2Qva6ZPd2jGJf+eAQR0ZFe10lF3nylBx6iHS2gpSaPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXHFO1HvaLaYV+pi8OI8yR9bcGw6+UXkp58MmBRZq94O4vw0kamLtXIB9qMP8zXmyHj+wL8yAR0zUBz5XRtspnl/KHcyEFx1eALaIChDxxKNJCw7wU+q/jIPRl7N+KsbF1sPuU4k9pwKo9hkQ3h8VxkQoFfaeF02KlxqPqtuxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HeHsWQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HeHsWQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684CFC4CEF1;
	Tue, 16 Dec 2025 11:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884661;
	bh=2Qva6ZPd2jGJf+eAQR0ZFe10lF3nylBx6iHS2gpSaPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HeHsWQT5lEn4/EZHtw3a58aDodBZJRjxwAY+743E76EB7BTvUR/kfFCLvd/bwzy/
	 ngBdkJKZg0yITuelkn789gx+1XNi6I5P9VjY7zhP0VOLUyZHF1qn4rBHvODMcVmTm+
	 lfq61xt/qQkPIyR2Y5/5ILbBIUhvZetQjduzSd5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/354] ublk: prevent invalid access with DEBUG
Date: Tue, 16 Dec 2025 12:13:31 +0100
Message-ID: <20251216111329.753424412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index defcc964ecab6..b874cb84bad95 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1768,7 +1768,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 {
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
-	struct ublk_io *io;
+	struct ublk_io *io = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	unsigned tag = ub_cmd->tag;
 	int ret = -EINVAL;
@@ -1882,7 +1882,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 
  out:
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
-			__func__, cmd_op, tag, ret, io->flags);
+			__func__, cmd_op, tag, ret, io ? io->flags : 0);
 	return ret;
 }
 
-- 
2.51.0



