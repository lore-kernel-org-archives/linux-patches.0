Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4DD374EA;
	Mon, 10 Mar 2025 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630752; cv=none; b=bKmbAllKnYzANr2J+2LKuhXtl13EPgwmEngIVfH+C3mXRGKEWlSi3QqfCm7/aqGlK9DGeN+i5v2qTu++MK1ehG4/78WUBWn/HmYCA7Fim75MWdkPx50Hrxcg0HnooMRlUEqMQ3sF9wXeEkh11qVtxUCnbfLOLEq8kBloCAVoxrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630752; c=relaxed/simple;
	bh=ylwZ8VyUEp8XyAb4DQLsZ796QncVTFi59eLpuHgmqaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ide+gBfH8RvjNBsoPHfjMBkgDqjSJ27KXHWWh9jSvgTk86y+OS/TJVIpEFtIu0cfnTWIglscZOgDw9l7yZcp7i/Rm4z8d9EtoGUP82f8WpGFBq/I6zkq6WyuTDn/wVtT981lTICwJGlBgOj5DFyUzHplv2XylMVmNgob82AxJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzfoUDQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzfoUDQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F9C4CEE5;
	Mon, 10 Mar 2025 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630752;
	bh=ylwZ8VyUEp8XyAb4DQLsZ796QncVTFi59eLpuHgmqaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzfoUDQ/Bm9SQKV+hQFhEoMIVcL6LgY02/uP+x5cnGdVX4r7gjeXIRmvkSTbzW5Ak
	 2qAFmsTS7xa9kof7GQY5xBp5gVunbmLPXQmLmxUkn2WrwZuRHmPp5/F/c7odQlhlU6
	 KEqN59QMuDaUl21c9/eo98uiQVvY/cUu9vDYhWhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/620] scsi: core: Dont memset() the entire scsi_cmnd in scsi_init_command()
Date: Mon, 10 Mar 2025 18:05:36 +0100
Message-ID: <20250310170604.914108099@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 71bada345b33b9297e7cc9415db6328c99b554f9 ]

Replace the big fat memset that requires saving and restoring various
fields with just initializing those fields that need initialization.

All the clearing to 0 is moved to scsi_prepare_cmd() as scsi_ioctl_reset()
alreadly uses kzalloc() to allocate a pre-zeroed command.

This is still conservative and can probably be optimized further.

Link: https://lore.kernel.org/r/20220224175552.988286-3-hch@lst.de
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: dce5c4afd035 ("scsi: core: Clear driver private data when retrying request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 60 +++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9721984fd9bc6..ddaffaea2c32c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1114,45 +1114,16 @@ static void scsi_cleanup_rq(struct request *rq)
 /* Called before a request is prepared. See also scsi_mq_prep_fn(). */
 void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 {
-	void *buf = cmd->sense_buffer;
-	void *prot = cmd->prot_sdb;
 	struct request *rq = scsi_cmd_to_rq(cmd);
-	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
-	unsigned long jiffies_at_alloc;
-	int retries, to_clear;
-	bool in_flight;
-	int budget_token = cmd->budget_token;
-
-	if (!blk_rq_is_passthrough(rq) && !(flags & SCMD_INITIALIZED)) {
-		flags |= SCMD_INITIALIZED;
+
+	if (!blk_rq_is_passthrough(rq) && !(cmd->flags & SCMD_INITIALIZED)) {
+		cmd->flags |= SCMD_INITIALIZED;
 		scsi_initialize_rq(rq);
 	}
 
-	jiffies_at_alloc = cmd->jiffies_at_alloc;
-	retries = cmd->retries;
-	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	/*
-	 * Zero out the cmd, except for the embedded scsi_request. Only clear
-	 * the driver-private command data if the LLD does not supply a
-	 * function to initialize that data.
-	 */
-	to_clear = sizeof(*cmd) - sizeof(cmd->req);
-	if (!dev->host->hostt->init_cmd_priv)
-		to_clear += dev->host->hostt->cmd_size;
-	memset((char *)cmd + sizeof(cmd->req), 0, to_clear);
-
 	cmd->device = dev;
-	cmd->sense_buffer = buf;
-	cmd->prot_sdb = prot;
-	cmd->flags = flags;
 	INIT_LIST_HEAD(&cmd->eh_entry);
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies_at_alloc;
-	cmd->retries = retries;
-	if (in_flight)
-		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
-	cmd->budget_token = budget_token;
-
 }
 
 static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
@@ -1539,10 +1510,35 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
+	bool in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	struct scatterlist *sg;
 
 	scsi_init_command(sdev, cmd);
 
+	cmd->eh_eflags = 0;
+	cmd->allowed = 0;
+	cmd->prot_type = 0;
+	cmd->prot_flags = 0;
+	cmd->submitter = 0;
+	cmd->cmd_len = 0;
+	cmd->cmnd = NULL;
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+	cmd->underflow = 0;
+	cmd->transfersize = 0;
+	cmd->host_scribble = NULL;
+	cmd->result = 0;
+	cmd->extra_len = 0;
+	cmd->state = 0;
+	if (in_flight)
+		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+
+	/*
+	 * Only clear the driver-private command data if the LLD does not supply
+	 * a function to initialize that data.
+	 */
+	if (!shost->hostt->init_cmd_priv)
+		memset(cmd + 1, 0, shost->hostt->cmd_size);
+
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
 		cmd->sc_data_direction = rq_dma_dir(req);
-- 
2.39.5



