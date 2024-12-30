Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88B642AA6;
	Mon, 30 Dec 2024 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574243; cv=none; b=SZlUHpW7+vbK6MEniV42ZkonU+0UMV11+/Sra6Si+qjPmV1p76oHIhkFk07+NXpFPGln+tQ4xncy+b/VaOtMTKT/EIwDud43u1Rs8UMpq65mL6QD+x8gnhjLvTHFyAGKj9hiEYESBLO7pm/brO/0GyZKi0jcktnCNL90xb2SYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574243; c=relaxed/simple;
	bh=CF/rBW43nwPSCgWsYLeg0DEZmQMDqCTD3tLujpI3qek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=indMh8ZyWcFLgQeLQklrhxqM6O/Zq7xMbwnqCyItTIUp9y/qLg6BFiR6u6Rdl0fny/Gf58MVk9P21caKJzHtWClBnDwhulGlfEGsuN5N8yWjHvPrNBavmmnB6pfbLh4kgFtaqxKROx/7de5JhX8o9DMq5k455S2JkbmnL+Bh328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSeaZwUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSeaZwUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53007C4CED0;
	Mon, 30 Dec 2024 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574242;
	bh=CF/rBW43nwPSCgWsYLeg0DEZmQMDqCTD3tLujpI3qek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSeaZwUpEGngHIpS3u/Nbd8z091fLHk69qTuQrsUnm1QV5OIOXL3dBwNFctWx79Si
	 eqzDKqiplGu8bwiywxwicIOgXzBYAyeeqODu2JQ7TXFcObXpwbRUYx3MEiyVM1J1u5
	 u5N1YeSX3LH3iuMEAjYJIPE4Gymg9wdcudp7Bpgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/114] ublk: detach gendisk from ublk device if add_disk() fails
Date: Mon, 30 Dec 2024 16:43:15 +0100
Message-ID: <20241230154221.098496785@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 75cd4005da5492129917a4a4ee45e81660556104 ]

Inside ublk_abort_requests(), gendisk is grabbed for aborting all
inflight requests. And ublk_abort_requests() is called when exiting
the uring context or handling timeout.

If add_disk() fails, the gendisk may have been freed when calling
ublk_abort_requests(), so use-after-free can be caused when getting
disk's reference in ublk_abort_requests().

Fixes the bug by detaching gendisk from ublk device if add_disk() fails.

Fixes: bd23f6c2c2d0 ("ublk: quiesce request queue when aborting queue")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241225110640.351531-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 90bc605ff6c2..458ac54e7b20 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1599,6 +1599,21 @@ static void ublk_unquiesce_dev(struct ublk_device *ub)
 	blk_mq_kick_requeue_list(ub->ub_disk->queue);
 }
 
+static struct gendisk *ublk_detach_disk(struct ublk_device *ub)
+{
+	struct gendisk *disk;
+
+	/* Sync with ublk_abort_queue() by holding the lock */
+	spin_lock(&ub->lock);
+	disk = ub->ub_disk;
+	ub->dev_info.state = UBLK_S_DEV_DEAD;
+	ub->dev_info.ublksrv_pid = -1;
+	ub->ub_disk = NULL;
+	spin_unlock(&ub->lock);
+
+	return disk;
+}
+
 static void ublk_stop_dev(struct ublk_device *ub)
 {
 	struct gendisk *disk;
@@ -1612,14 +1627,7 @@ static void ublk_stop_dev(struct ublk_device *ub)
 		ublk_unquiesce_dev(ub);
 	}
 	del_gendisk(ub->ub_disk);
-
-	/* Sync with ublk_abort_queue() by holding the lock */
-	spin_lock(&ub->lock);
-	disk = ub->ub_disk;
-	ub->dev_info.state = UBLK_S_DEV_DEAD;
-	ub->dev_info.ublksrv_pid = -1;
-	ub->ub_disk = NULL;
-	spin_unlock(&ub->lock);
+	disk = ublk_detach_disk(ub);
 	put_disk(disk);
  unlock:
 	mutex_unlock(&ub->mutex);
@@ -2295,7 +2303,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 
 out_put_cdev:
 	if (ret) {
-		ub->dev_info.state = UBLK_S_DEV_DEAD;
+		ublk_detach_disk(ub);
 		ublk_put_device(ub);
 	}
 	if (ret)
-- 
2.39.5



