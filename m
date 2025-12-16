Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964F396565;
	Tue, 16 Dec 2025 12:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888308; cv=none; b=jo38ZbsiyemM8bSI7OGXw72W1aank1qxynQRQ79iePGuiMQiFFDq5c4hkB7raz9OGZPipa4r3cx4ci5LGQn3D0Q4lG+yTntB9c2NpOiGH4OS3Yf8iGUgetD3qEdtdLTXpnlt6QXvzlc5JwQw7MaF8r84BOJZ+seuV7r1IYnVQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888308; c=relaxed/simple;
	bh=/CzQ25zWJp0/Y2dx0FNBWstvScWdPEmyeIdeYrxa3FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUdqz2F6Vx0tv4DTehTwBEzgFC2aZlo9EGPgJQTF4948Ru/jhltX/sa1QN6zlEobAFlm3Y+/8Sc+KmgQNAEIVeGvo1YNIICoW1ifCA1DOufGr1Fs6TjYKKHnObks4WoGiUv3Uue7njPMBLJoR/Wh+7bXyW+JvxjXSQZw/d9kp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zeRU/v25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zeRU/v25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A7C4CEF5;
	Tue, 16 Dec 2025 12:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888308;
	bh=/CzQ25zWJp0/Y2dx0FNBWstvScWdPEmyeIdeYrxa3FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zeRU/v25hpWIJiSVMHZFmNEu1XBtVREKgc92pwU8hKJPq1lGOzXbGTyXkSXUg9iru
	 6l/0djWK4JyLvvQB/NoRgG/LIDd5H+E+CDkUDQQjcdTprPyyyxmpS+cJ6nM08vl4qE
	 1A17yiCSsSvXWd7JfnwdDkLOfVP7TRgjdZbqoWOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/614] ublk: prevent invalid access with DEBUG
Date: Tue, 16 Dec 2025 12:13:39 +0100
Message-ID: <20251216111417.744906353@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 0c74a41a67530..359564c40cb50 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2367,7 +2367,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 	u16 buf_idx = UBLK_INVALID_BUF_IDX;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
-	struct ublk_io *io;
+	struct ublk_io *io = NULL;
 	u32 cmd_op = cmd->cmd_op;
 	u16 q_id = READ_ONCE(ub_src->q_id);
 	u16 tag = READ_ONCE(ub_src->tag);
@@ -2488,7 +2488,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 
  out:
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
-			__func__, cmd_op, tag, ret, io->flags);
+			__func__, cmd_op, tag, ret, io ? io->flags : 0);
 	return ret;
 }
 
-- 
2.51.0



