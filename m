Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE606A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FDCC433EF;
	Tue, 10 Jan 2023 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374240;
	bh=NmLXmVX2i8srkGjhE3f/Jn204w02k4Af8Qrin22ewJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8QpY09sfGk0FIii4KDEdlziOv7P1paeIZk8e/0VXrVyx2K+ItAiV0IPGvAuEhRSv
	 JvGZ2la8F1n9hM706k5giV7N6/cxfmZzaRL3dtC1gqJXILSu7a7jIrcjWYJLMJxYeW
	 jA9Fv1vxLObnWfL/Lr49re9OrY7Bl4Bd0yz/TIbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 097/148] ublk: honor IO_URING_F_NONBLOCK for handling control command
Date: Tue, 10 Jan 2023 19:03:21 +0100
Message-Id: <20230110180020.266827273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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

[ Upstream commit fa8e442e832a3647cdd90f3e606c473a51bc1b26 ]

Most of control command handlers may sleep, so return -EAGAIN in case
of IO_URING_F_NONBLOCK to defer the handling into io wq context.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230104133235.836536-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 31a8715d3a4d..ebb5c846d826 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1718,6 +1718,9 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
 	int ret = -EINVAL;
 
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
 	ublk_ctrl_cmd_dump(cmd);
 
 	if (!(issue_flags & IO_URING_F_SQE128))
-- 
2.35.1



