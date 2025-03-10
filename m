Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE411BBBFD;
	Mon, 10 Mar 2025 18:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630755; cv=none; b=jGuJc+EqDYueGHv8DPty17KwuykFU1EYeo5DaMjR7+6wEcjS+MVQQTZaX5scgitBhhmlqlVX55p5IqNwLF605v2Q1NONZoUkWFD/2cI1SyORmGosh8QrRAENy8Iz1s3JU7wLfyOENUT5TnTPDouPQbMQGSVuJbxLTjW/aZRHnXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630755; c=relaxed/simple;
	bh=7hwlGyBUt2DNgHJIjO1UbUfqNDh7WjrsDe6CwBqnVnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwX9+OOPRrFnipo+k2n5LCj0OUyEXltlQQW/r52oHRDVYUZZaGhfcB13ia/+H0eMtQ7ZV1nZkVUN4PrGO7eFpqMxLlKUvtfq//DmuQzaCbORARMqrZsdcNsMpdA9ojN3dUu99L3BWCoRLPZUrlZkaIwt2Ii8EPBlv3QYgNDS1NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jt54MJDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jt54MJDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D42C4CEEC;
	Mon, 10 Mar 2025 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630755;
	bh=7hwlGyBUt2DNgHJIjO1UbUfqNDh7WjrsDe6CwBqnVnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jt54MJDsp4bWdJEn0RoxPao6fN6HKeEGJ+JpusO2nQcs7DOXmvKpeRbq8n6HVgMvM
	 I8EOBRG52qutzZH66ZPywrpOX8MWMUcz3qHnK500+N3As1J6oJ/Vw6kgGoqYuXAotk
	 eRkO6r03i7FELzascOwl48KGNuewXV/Z4fA9AHvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/620] scsi: core: Clear driver private data when retrying request
Date: Mon, 10 Mar 2025 18:05:37 +0100
Message-ID: <20250310170604.952192298@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit dce5c4afd035e8090a26e5d776b1682c0e649683 ]

After commit 1bad6c4a57ef ("scsi: zero per-cmd private driver data for each
MQ I/O"), the xen-scsifront/virtio_scsi/snic drivers all removed code that
explicitly zeroed driver-private command data.

In combination with commit 464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE"),
after virtio_scsi performs a capacity expansion, the first request will
return a unit attention to indicate that the capacity has changed. And then
the original command is retried. As driver-private command data was not
cleared, the request would return UA again and eventually time out and fail.

Zero driver-private command data when a request is retried.

Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes driver-private command data")
Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes driver-private command data")
Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes driver-private command data")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20250217021628.2929248-1-yebin@huaweicloud.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ddaffaea2c32c..c8be41d8eb247 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1532,13 +1532,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	if (in_flight)
 		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 
-	/*
-	 * Only clear the driver-private command data if the LLD does not supply
-	 * a function to initialize that data.
-	 */
-	if (!shost->hostt->init_cmd_priv)
-		memset(cmd + 1, 0, shost->hostt->cmd_size);
-
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
 		cmd->sc_data_direction = rq_dma_dir(req);
@@ -1675,6 +1668,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
 		goto out_dec_target_busy;
 
+	/*
+	 * Only clear the driver-private command data if the LLD does not supply
+	 * a function to initialize that data.
+	 */
+	if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
+		memset(cmd + 1, 0, shost->hostt->cmd_size);
+
 	if (!(req->rq_flags & RQF_DONTPREP)) {
 		ret = scsi_prepare_cmd(req);
 		if (ret != BLK_STS_OK)
-- 
2.39.5



