Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7826919BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB692C433D2;
	Wed,  7 Jun 2023 20:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170558;
	bh=YWmMkh8l0UbNdG6QgZ4XM8b+KLeWJUU4FDAk16KjKIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr77B+JNb73cqAZAdpqXzHxos031h6q+qh8KWioJo4DSrg7vG/FD9c3unXAX9lCmw
	 cP+H/J+UXQ4KbiIuy4BQh3sGSevyvqFccyu6aGevEVJqGJTM9M7DcgLLSAuYL4+u1P
	 wdy54xxiDaJMjXFATuAOChDaIgiICA06/+QXQg+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/225] ublk: fix AB-BA lockdep warning
Date: Wed,  7 Jun 2023 22:15:24 +0200
Message-ID: <20230607200918.657885013@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit ac5902f84bb546c64aea02c439c2579cbf40318f ]

When handling UBLK_IO_FETCH_REQ, ctx->uring_lock is grabbed first, then
ub->mutex is acquired.

When handling UBLK_CMD_STOP_DEV or UBLK_CMD_DEL_DEV, ub->mutex is
grabbed first, then calling io_uring_cmd_done() for canceling uring
command, in which ctx->uring_lock may be required.

Real deadlock only happens when all the above commands are issued from
same uring context, and in reality different uring contexts are often used
for handing control command and IO command.

Fix the issue by using io_uring_cmd_complete_in_task() to cancel command
in ublk_cancel_dev(ublk_cancel_queue).

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/becol2g7sawl4rsjq2dztsbc7mqypfqko6wzsyoyazqydoasml@rcxarzwidrhk
Cc: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20230517133408.210944-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c0cbc5f3eb266..c56d1c6d8e58d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1045,6 +1045,11 @@ static inline bool ublk_queue_ready(struct ublk_queue *ubq)
 	return ubq->nr_io_ready == ubq->q_depth;
 }
 
+static void ublk_cmd_cancel_cb(struct io_uring_cmd *cmd, unsigned issue_flags)
+{
+	io_uring_cmd_done(cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
+}
+
 static void ublk_cancel_queue(struct ublk_queue *ubq)
 {
 	int i;
@@ -1056,8 +1061,8 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 		struct ublk_io *io = &ubq->ios[i];
 
 		if (io->flags & UBLK_IO_FLAG_ACTIVE)
-			io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
-						IO_URING_F_UNLOCKED);
+			io_uring_cmd_complete_in_task(io->cmd,
+						      ublk_cmd_cancel_cb);
 	}
 
 	/* all io commands are canceled */
-- 
2.39.2



