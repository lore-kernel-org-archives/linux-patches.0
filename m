Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57D6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B4C433EF;
	Tue, 10 Jan 2023 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374774;
	bh=U0IgMbheWfPsgM7fBPstUM3K0hXuWEkzuDByQym12CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5ckhKcL0vlwc0IPaDuTRT709qravn51QmEed4V62jfWieQnYI5SdHngFs1p6zEyD
	 f9OtZTcug+vjU7x3Zp/8bKVjAmUkqYjisrEoKZ9LelhJ8nLqMEphIoCuDePzlkE0fx
	 f6yC18jDRTWfVvLn3wJoelQSv/ceITWtjAbBkKC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/159] ublk: honor IO_URING_F_NONBLOCK for handling control command
Date: Tue, 10 Jan 2023 19:04:10 +0100
Message-Id: <20230110180021.529737547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index e9de9d846b73..17b677b5d3b2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1992,6 +1992,9 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
 	int ret = -EINVAL;
 
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
 	ublk_ctrl_cmd_dump(cmd);
 
 	if (!(issue_flags & IO_URING_F_SQE128))
-- 
2.35.1



