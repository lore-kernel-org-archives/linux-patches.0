Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0E1ACEDD;
	Wed,  5 Mar 2025 18:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197978; cv=none; b=npZRMQLsNYoTIoVNQqZ4AguqruiKgKU1EArkxftXXC8Xjw0H1wzhKd1UUsX01Q8cyY5hb9Ti6OPaZ82x1sK+zyTNH+RsFfcs5w+RAHUBYcOMq5EGnK76Q2FisBG8betry+1GzAD6I6u4SypN+knDNvENEa3919yCHsHwEd11Qfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197978; c=relaxed/simple;
	bh=rheAOM3p8ft55Q71uARPnC2yJp+i+GGTymvOmsmDoJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXkD/rR8m5VWos0dGZa+hEl3zFjjtc8sa7ng9KVPJ3qIw88Mced0IoP8X5ZBuO9thk99FR0DDYjJFoTRZiosvnUZftdgGKZTkaAp9yFX44yCKcNcC53ZUauhwId17Q/ANoaRGJX6my55xwJLVayxZW73NHRAc0ut/jvuWLlHyZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1Q8UCm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1Q8UCm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB128C4CED1;
	Wed,  5 Mar 2025 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197978;
	bh=rheAOM3p8ft55Q71uARPnC2yJp+i+GGTymvOmsmDoJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1Q8UCm/6PRbKWW7jsFBFbDzPBku76QKXbq6yNNozX1XhlNUwO7slkmkrhdhvTdle
	 rqx9kYucakFFZ6gVMobhjna63SNAA7zfZSnMFKyuzsPK0qU1KpzSFFgYS2uezomQbi
	 Vurlqf8YPhPpsE5mV15Dbri2W4+NvCMV4H2HoUPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/150] scsi: core: Clear driver private data when retrying request
Date: Wed,  5 Mar 2025 18:47:32 +0100
Message-ID: <20250305174504.742837962@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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
index c9dde1ac9523e..3023b07dc483b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1653,13 +1653,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
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
@@ -1826,6 +1819,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
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



