Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E050316184;
	Wed,  3 Dec 2025 15:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776597; cv=none; b=cHu6NWaaZQwbPM7XJ5FsV1KHj8AULekzgZvUk+K2H+au97RYXXA9mMX5dL1bNmFMaS3qVL4z95y/ma+uSprEU9fA2iFLPJc9pgcu3q02YhJjJOfA1QnMqkOpyx6k166EnaHmYPCz1QsmZBAevKUSX9fDURkEqmssyQOlSx7Cfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776597; c=relaxed/simple;
	bh=Ql5RI2a77XkYBLFH6KKx4wa2xKacQouAuirBZyHFdHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaxK4WDxYhzsTXyXKALhMM1P+TLiOCvm+s/TolbHQUUCeWev76iCNRdZ2ROZxC+/vwa5Fy3DvenJi5gLqpTqtSTkIfwIoRWWHBIC7enx1Gqa1/vjmfJuTIRLwOwPVs/460e97e5ofRJ8ZKs/V76Q0MJjs+KOIFmFFucW/zNktLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Obcb1K08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Obcb1K08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A98C4CEF5;
	Wed,  3 Dec 2025 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776596;
	bh=Ql5RI2a77XkYBLFH6KKx4wa2xKacQouAuirBZyHFdHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Obcb1K081lKRU8mrnRjS5vvlqKXAt6800Bu4mg7ype37AI83r6wYWrIYDABksiOzK
	 zTjseo+BQghJ3vGOW+UWPE1bGEOUw86dH1IUiTtOfESsdNE0mvxiephP2pm85jbPpa
	 nFsGnZ89PsXvVsmmmYa5wqqWRwHTUAF5WVvXlYvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/300] scsi: core: Fix a regression triggered by scsi_host_busy()
Date: Wed,  3 Dec 2025 16:27:14 +0100
Message-ID: <20251203152409.147484703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a0b7780602b1b196f47e527fec82166a7e67c4d0 ]

Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
iterators") introduced the following regression:

Call trace:
 __srcu_read_lock+0x30/0x80 (P)
 blk_mq_tagset_busy_iter+0x44/0x300
 scsi_host_busy+0x38/0x70
 ufshcd_print_host_state+0x34/0x1bc
 ufshcd_link_startup.constprop.0+0xe4/0x2e0
 ufshcd_init+0x944/0xf80
 ufshcd_pltfrm_init+0x504/0x820
 ufs_rockchip_probe+0x2c/0x88
 platform_probe+0x5c/0xa4
 really_probe+0xc0/0x38c
 __driver_probe_device+0x7c/0x150
 driver_probe_device+0x40/0x120
 __driver_attach+0xc8/0x1e0
 bus_for_each_dev+0x7c/0xdc
 driver_attach+0x24/0x30
 bus_add_driver+0x110/0x230
 driver_register+0x68/0x130
 __platform_driver_register+0x20/0x2c
 ufs_rockchip_pltform_init+0x1c/0x28
 do_one_initcall+0x60/0x1e0
 kernel_init_freeable+0x248/0x2c4
 kernel_init+0x20/0x140
 ret_from_fork+0x10/0x20

Fix this regression by making scsi_host_busy() check whether the SCSI
host tag set has already been initialized. tag_set->ops is set by
scsi_mq_setup_tags() just before blk_mq_alloc_tag_set() is called. This
fix is based on the assumption that scsi_host_busy() and
scsi_mq_setup_tags() calls are serialized. This is the case in the UFS
driver.

Reported-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Closes: https://lore.kernel.org/linux-block/pnezafputodmqlpumwfbn644ohjybouveehcjhz2hmhtcf2rka@sdhoiivync4y/
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20251007214800.1678255-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 17fa1cd91da61..97cbe22d7fee2 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -598,8 +598,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
 {
 	int cnt = 0;
 
-	blk_mq_tagset_busy_iter(&shost->tag_set,
-				scsi_host_check_in_flight, &cnt);
+	if (shost->tag_set.ops)
+		blk_mq_tagset_busy_iter(&shost->tag_set,
+					scsi_host_check_in_flight, &cnt);
 	return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
-- 
2.51.0



