Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799E62572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF192C433D2;
	Tue, 18 Apr 2023 12:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822267;
	bh=5aP2MZitRMu7m5JTImsGIFU6mtqfgvzLQMMYsFJgxqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slB9CQsdWUVVZnNsQdVWfSp/CIogbfHziG3yNLMA2aat5ZR+4ChoQt8/AMJB7UB1m
	 NwCHbk3497ZzgxhsewdDgGIIBQGz7MMaBUT/tz/4kGKyJxRH9qQGM0mv34cwqziFua
	 SVqn18X/xeb4c49KYo5/bm1F0BMToGsPrE21U48E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Zhang <ZiyangZhang@linux.alibaba.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 086/139] block: ublk_drv: mark device as LIVE before adding disk
Date: Tue, 18 Apr 2023 14:22:31 +0200
Message-Id: <20230418120317.044301050@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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

[ Upstream commit 4985e7b2c002eb4c5c794a1d3acd91b82c89a0fd ]

IO can be started before add_disk() returns, such as reading parititon table,
then the monitor work should work for making forward progress.

So mark device as LIVE before adding disk, meantime change to
DEAD if add_disk() fails.

Fixed: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230318141231.55562-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 2ed994a313a91..c0cbc5f3eb266 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1571,17 +1571,18 @@ static int ublk_ctrl_start_dev(struct io_uring_cmd *cmd)
 		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	get_device(&ub->cdev_dev);
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	ret = add_disk(disk);
 	if (ret) {
 		/*
 		 * Has to drop the reference since ->free_disk won't be
 		 * called in case of add_disk failure.
 		 */
+		ub->dev_info.state = UBLK_S_DEV_DEAD;
 		ublk_put_device(ub);
 		goto out_put_disk;
 	}
 	set_bit(UB_STATE_USED, &ub->state);
-	ub->dev_info.state = UBLK_S_DEV_LIVE;
 out_put_disk:
 	if (ret)
 		put_disk(disk);
-- 
2.39.2



