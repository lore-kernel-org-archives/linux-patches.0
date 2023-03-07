Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CF1BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FBFC433EF;
	Tue,  7 Mar 2023 17:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209138;
	bh=CpUr+PbcGYWrMt6j6e3IRoIvTDGzYJAE4UKwKhNc3VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmCUXKOQu/TZduQoarN/95sS0JGSHBGLmpQYUp2Pjq5s5M3feCBzdGb61CExpGNPT
	 xyVxQiANdGFEYgQSuy5eCupG5GxKoPTYcqOaVV9xnw0598Pc2NjerkEjYKgVjiXVTl
	 35j+JVL0hQDS0NHQ4OJvWyHvBYNmoAp1yYCQ4r3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0093/1001] ublk_drv: dont probe partitions if the ubq daemon isnt trusted
Date: Tue,  7 Mar 2023 17:47:45 +0100
Message-Id: <20230307170026.212843076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 73a166d9749230d598320fdae3b687cdc0e2e205 ]

If any ubq daemon is unprivileged, the ublk char device is allowed
for unprivileged user actually, and we can't trust the current user,
so not probe partitions.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230106041711.914434-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f44b9467720c9..450bd54fd0061 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -159,6 +159,7 @@ struct ublk_device {
 
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
+	unsigned int		nr_privileged_daemon;
 
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
@@ -1178,6 +1179,9 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 		ubq->ubq_daemon = current;
 		get_task_struct(ubq->ubq_daemon);
 		ub->nr_queues_ready++;
+
+		if (capable(CAP_SYS_ADMIN))
+			ub->nr_privileged_daemon++;
 	}
 	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
 		complete_all(&ub->completion);
@@ -1534,6 +1538,10 @@ static int ublk_ctrl_start_dev(struct io_uring_cmd *cmd)
 	if (ret)
 		goto out_put_disk;
 
+	/* don't probe partitions if any one ubq daemon is un-trusted */
+	if (ub->nr_privileged_daemon != ub->nr_queues_ready)
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
+
 	get_device(&ub->cdev_dev);
 	ret = add_disk(disk);
 	if (ret) {
@@ -1935,6 +1943,7 @@ static int ublk_ctrl_start_recovery(struct io_uring_cmd *cmd)
 	/* set to NULL, otherwise new ubq_daemon cannot mmap the io_cmd_buf */
 	ub->mm = NULL;
 	ub->nr_queues_ready = 0;
+	ub->nr_privileged_daemon = 0;
 	init_completion(&ub->completion);
 	ret = 0;
  out_unlock:
-- 
2.39.2



