Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E114B075;
	Wed,  5 Mar 2025 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197537; cv=none; b=upPtvQibbGMjkKFmxN1LhA3Fn88GWQ10OCsoe6rJt5bIa/5GrTwc6MDoheiY+mxKZiFJ1g+YKeLyIW8htWk3hWxCIZVXRi1zUQjVzII3ZgNZciIRmKiiIYp0u4z5xvTDilXgtPmX+p5TLw8rJVC9KtNuTUwapkVxZH8GGgadZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197537; c=relaxed/simple;
	bh=qlDaaTRsxs3r69iyXXTmveJf1sn5adH/uWOSAaKgBNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GynnRSMx20SfWKE7OL7rvVei1rdCr09vBX46j7xx5FdBVJVd5VR3z1JiA4Ybuu+W3kY3Rpz1DeGNCoU7uVL/3x5VvM2XMlfSl1H3jzQ9Pg4hQ/2XI1Nc3B9pXaKAZ8kcSWIOXlIa8F1SsaXeacc8ijJcmEb3QwIf7TeNiOy3dww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEh/fPXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEh/fPXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4849C4CED1;
	Wed,  5 Mar 2025 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197537;
	bh=qlDaaTRsxs3r69iyXXTmveJf1sn5adH/uWOSAaKgBNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEh/fPXNjnswWcbUSoMJDgSWyDMaOfCpUzlIES3e/hsyobaiZr/+ESPQlIlVidaZ/
	 LE2uwkJi95JIJINnsRoefsjNGf0iM3bZZMyPBB1pPqqdWOcHe6/vsxTpyUOi8vj2CS
	 XrItFTSD7UyETpzyA6BODsojmMq1adC76FCO5kYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/142] scsi: core: Clear driver private data when retrying request
Date: Wed,  5 Mar 2025 18:47:13 +0100
Message-ID: <20250305174500.914072150@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f026377f1cf1c..e6dc2c556fde9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1570,13 +1570,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
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
@@ -1743,6 +1736,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
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



