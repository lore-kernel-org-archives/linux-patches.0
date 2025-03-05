Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8C82512EF;
	Wed,  5 Mar 2025 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198538; cv=none; b=TTmbRRh/KURIvrqE6UtCBQPmNpAzCixg2ERcMJiGUUvU/quJeWbSoY3kZduQJCrFUg8x/Tfw1/YGWxR3BbrlKsM4LZzcCE+aqeaJSz76qoSrdWV309/Vo7IVYQ+HhU9hlkW0VQU5Ke9zou4QNVNZ1+QAkDMu1+/qQI8xGEelu1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198538; c=relaxed/simple;
	bh=gW+XLf4IdWU7b6PIjBIGtRM6yAcsbs3TbHnDg/CVcl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcSqbBOI50VPxVNWmIvFhXV7Pvl0FmKQhX150ZNXxqRMUjqWmt6A/Db4QdhwRzC6J8Bo7a28tObbfzdYXqR1/fP/D6qMQkuylKwxgI1D08Cf41XtWeQYVys2h1JZQ7MoA1WMZjNkB8TvM00M88SrsnjEk/qMHG2Bolj6i0nq3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/PjdQJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/PjdQJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56598C4CED1;
	Wed,  5 Mar 2025 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198538;
	bh=gW+XLf4IdWU7b6PIjBIGtRM6yAcsbs3TbHnDg/CVcl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/PjdQJMJTKg9JwJPmoLe9CL3xiKx7RBFkmzCZJ+ETkRLzGmLE5XWRX1BLaYeMR9m
	 GgMyYJrMk5UuGT5meASJr2CXpCHL6MGR7zUGUjLiBy/wi7Df9uhFhdoGZbXQp1TyvI
	 fWt/oZPpLt5LnDmcOmvGoMxd3MRrXAwuqDmDJEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/157] scsi: core: Clear driver private data when retrying request
Date: Wed,  5 Mar 2025 18:47:36 +0100
Message-ID: <20250305174506.101734745@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5f9b107ae267f..43766589bfc6e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1656,13 +1656,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
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
@@ -1829,6 +1822,13 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
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



