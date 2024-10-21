Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965FC1D04BB;
	Mon, 21 Oct 2024 10:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506599; cv=none; b=lyXLm0S+X5JcX2EGbyb1IlKNecUcB+6ZJgfI43ypKEaYt8sFkbKjdIobqvIVh64cBZL8AG4H6KnmKXk9t8ZQ1IknxsDbyXCTdUiZh2+k8uUrTdM+yu0D/DWjhr4AXfRST5SjV8HLEA/MCB9Q0XyErqZ4Is4GvhgwrvcZnm2cg4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506599; c=relaxed/simple;
	bh=9MggNq3OmpZIi2Kw9uMk5C6BP9LvevCAkCi414gcQLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivXx88ukGl9MrXlMDV3Im3no/jw2t7mxP9NQXG2g1QRVfV6Yi5U9Ww2Ic2KX6IVEd0tfqL5nDpkGuYnzLE7uSkezfqYbM2SRP0JlktrysdMZxUa0n6wq/lI1ciE7oAhLDrs9kbne0T4Y5Mhwz56BLhsyzl6nhhHylrYEKuiKgZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7rpFJoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7rpFJoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7ABC4CEC3;
	Mon, 21 Oct 2024 10:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506599;
	bh=9MggNq3OmpZIi2Kw9uMk5C6BP9LvevCAkCi414gcQLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7rpFJoP5yB2kkzwzz1huWv0LgsKEQ6Gpe/IRIYm8aNnvAj6D6rD/bYXjH/UEUowO
	 yz9hmoAptd18/+wHexUgGR60Rvs70ScXVncvM58kdgUJKeAJ1zN17jzN+cKjCaAoPG
	 Sr0IfhxEGBfSwpofzHV5GKum5wwhl0XMxIizjQLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 058/135] scsi: ufs: core: Requeue aborted request
Date: Mon, 21 Oct 2024 12:23:34 +0200
Message-ID: <20241021102301.598694629@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit 8fa075804cb3b00960dd5c06554308175c834530 upstream.

After the SQ cleanup fix, the CQ will receive a response with the
corresponding tag marked as OCS: ABORTED. To align with the behavior of
Legacy SDB mode, the handling of OCS: ABORTED has been changed to match
that of OCS_INVALID_COMMAND_STATUS (SDB), with both returning a SCSI
result of DID_REQUEUE.

Furthermore, the workaround implemented before the SQ cleanup fix can be
removed.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20241001091917.6917-3-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5403,10 +5403,12 @@ ufshcd_transfer_rsp_status(struct ufs_hb
 		}
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
-		break;
 	case OCS_INVALID_COMMAND_STATUS:
 		result |= DID_REQUEUE << 16;
+		dev_warn(hba->dev,
+				"OCS %s from controller for tag %d\n",
+				(ocs == OCS_ABORTED ? "aborted" : "invalid"),
+				lrbp->task_tag);
 		break;
 	case OCS_INVALID_CMD_TABLE_ATTR:
 	case OCS_INVALID_PRDT_ATTR:
@@ -6470,26 +6472,12 @@ static bool ufshcd_abort_one(struct requ
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct ufs_hba *hba = shost_priv(shost);
-	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
-	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 
 	*ret = ufshcd_try_to_abort_task(hba, tag);
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 		*ret ? "failed" : "succeeded");
 
-	/* Release cmd in MCQ mode if abort succeeds */
-	if (hba->mcq_enabled && (*ret == 0)) {
-		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
-		if (!hwq)
-			return 0;
-		spin_lock_irqsave(&hwq->cq_lock, flags);
-		if (ufshcd_cmd_inflight(lrbp->cmd))
-			ufshcd_release_scsi_cmd(hba, lrbp);
-		spin_unlock_irqrestore(&hwq->cq_lock, flags);
-	}
-
 	return *ret == 0;
 }
 


