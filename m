Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D058628135D;
	Thu, 27 Nov 2025 15:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255960; cv=none; b=pY+rtTDeuiU6jTn4DmO9nS8RWsMs7sRxjfL8mM3XzHypP02ii65VYdA8xTN3g+xFQXrxAACv34cbQ7eyq3iuoOKwKxUZjm6WURMuTzhf77N2H7xF2JtcEgHWRkD1zVHdE8bGAiYASzzmGM47V/XP8SOJt/SN9UFiL7rw1pBFgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255960; c=relaxed/simple;
	bh=XTlXF857igtpeLE9nHQdlclj/M9hiqopLUmIRrXfh+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNn75a3vLnDjNQjwjIhl0JKK5p/4brtVZjo946A4TbIPdsK010w94xyYJ7aa4e2YYWzmS5Fgv+Hl1Av+149qJ1nD1wotQ2rSZIGq/yY8mlm3tr7W2GJVHvN/RYLJnBokWu+kkH35i0/D5gR31PJfCUlHX8NwHVwM7/hnlRywXp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8T8msoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8T8msoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256CEC4CEF8;
	Thu, 27 Nov 2025 15:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255960;
	bh=XTlXF857igtpeLE9nHQdlclj/M9hiqopLUmIRrXfh+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8T8msoUb6cs/lT1rjZeIcaSKAtUKYNU2QzCDCeXrTga5bBVuLvLLXVA5B7noQ77L
	 5T25TqwxuDyrTSJazeLzXKuLl9sYhlnMX+Yj9JP8a8Wx6Q/zDcTpTdUAGpMulXmHyt
	 +N+Aq/C9LarEm23o/uVfkN7XN7iGA1aNryFWPk48=
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
Subject: [PATCH 6.17 141/175] scsi: core: Fix a regression triggered by scsi_host_busy()
Date: Thu, 27 Nov 2025 15:46:34 +0100
Message-ID: <20251127144048.107580959@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index cc5d05dc395c4..17173239301e6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -611,8 +611,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
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



