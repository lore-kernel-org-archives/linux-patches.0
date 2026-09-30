Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA3536D4E1;
	Wed, 30 Sep 2026 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791773; cv=none; b=MjrAXWg2zRq9NOd+Bb8+H8vPey4mlnuprd2+Nv9f0fvKWqUP9jCvNMu6BTO/pz26m6wzo0sLFV16euL8tVs+ZelnHSaVkK8CL2yllcwb09BxXXTdqx5CLYnT27LixLseib4tvHq50jA528Tw9KH0WoXGmsg/QbPnehxN/y6uCws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791773; c=relaxed/simple;
	bh=dtmhzlU/Mv8zUvTPeUVGvx/aD6TEbKgtaw77P0nAaQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxIG6iGB7L/2NxNs5RWfCPnCVCyQgr6Y3VSorfwKPDRBVuXYqM2LkuH/vj33SMZGW+Ul5kdwpHq5gB+Mo4Ivz44ThFJnfCDII0FRMP4qf+BUHP5cHo+p2Ztl7/8VumWTQyiQbzE/FqA7a19nnpZ5pOkBlFfahKCjzyoHAP4eGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZ0nZ2TH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZ0nZ2TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACF91F000FF;
	Wed, 30 Sep 2026 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791772;
	bh=jZK0/kTwGKfql6Twkbi67dqwmmI0orghRIQIJZ7zUKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZ0nZ2THuaeMsN4AuQiGRAfU+MQoe5SHdxGXYoVvfJktsPiz1TOtzRyTHw8L1RYs5
	 KMlPHRDj8+PlD7LzykrOMkLIfbSY6MQ/LyRw6G4rAR8lVpAxnb/LE00Q3PJynrKf6V
	 VPBmzTHGSvhfc/ua7bmaYfbmx6nCL+KdskStBDpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/752] Revert "scsi: smartpqi: Stop using the SCSI pointer"
Date: Wed, 30 Sep 2026 17:23:55 +0200
Message-ID: <20260930152406.178557253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 3285f3a01085e815a2e2a6b72dcffbb037a62553.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7ecc62fc572aa..1df17ef2ec93a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,15 +54,6 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-struct pqi_cmd_priv {
-	int this_residual;
-};
-
-static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
-{
-	return scsi_cmd_priv(cmd);
-}
-
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
@@ -5399,7 +5390,7 @@ static void pqi_aio_io_complete(struct pqi_io_request *io_request,
 	scsi_dma_unmap(scmd);
 	if (io_request->status == -EAGAIN || pqi_raid_bypass_retry_needed(io_request)) {
 		set_host_byte(scmd, DID_IMM_RETRY);
-		pqi_cmd_priv(scmd)->this_residual++;
+		scmd->SCp.this_residual++;
 	}
 
 	pqi_free_io_request(io_request);
@@ -5623,7 +5614,7 @@ static inline bool pqi_is_bypass_eligible_request(struct scsi_cmnd *scmd)
 	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
 		return false;
 
-	return pqi_cmd_priv(scmd)->this_residual == 0;
+	return scmd->SCp.this_residual == 0;
 }
 
 /*
@@ -6989,7 +6980,6 @@ static struct scsi_host_template pqi_driver_template = {
 	.map_queues = pqi_map_queues,
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
-	.cmd_size = sizeof(struct pqi_cmd_priv),
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.53.0



