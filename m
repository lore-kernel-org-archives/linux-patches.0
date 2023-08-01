Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9BB1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439CFC433C9;
	Tue,  1 Aug 2023 09:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882541;
	bh=6+6Xg7DpzUeH8KhdYxZHiaof8dcWcbQ5IlZTwNrBHqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScuSa21/Joa6qlFoqf4sdlshiKdpSwmNBo8LAxfZ0TsF6vMD1g8j9RGVMdm9idzUZ
	 uUOu1RM1dL9Pya0yXzgYJOn9fgP/YkIawDVkLpNm5GPULfpsmSgrnH3l12aMTfGfx5
	 8FCd5XxVAtkOK2JgKUWwzVhzZz2c1Vp88UttRSh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	German Maglione <gmaglione@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/228] ublk: fail to start device if queue setup is interrupted
Date: Tue,  1 Aug 2023 11:19:59 +0200
Message-ID: <20230801091927.963042348@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

[ Upstream commit 53e7d08f6d6e214c40db1f51291bb2975c789dc2 ]

In ublk_ctrl_start_dev(), if wait_for_completion_interruptible() is
interrupted by signal, queues aren't setup successfully yet, so we
have to fail UBLK_CMD_START_DEV, otherwise kernel oops can be triggered.

Reported by German when working on qemu-storage-deamon which requires
single thread ublk daemon.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reported-by: German Maglione <gmaglione@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230726144502.566785-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3ae22e7eb0b09..495e1bf9003b6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1539,7 +1539,8 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 	if (ublksrv_pid <= 0)
 		return -EINVAL;
 
-	wait_for_completion_interruptible(&ub->completion);
+	if (wait_for_completion_interruptible(&ub->completion) != 0)
+		return -EINTR;
 
 	schedule_delayed_work(&ub->monitor_work, UBLK_DAEMON_MONITOR_PERIOD);
 
-- 
2.40.1



