Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8CE6AA0;
	Tue,  5 Dec 2023 03:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGFUllPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC17C433C7;
	Tue,  5 Dec 2023 03:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746442;
	bh=qpcHbnJb6UWrKvrNp3whZqBb1mgHSbxYTdSX78TZSyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGFUllPMwDVGbehjKfW3Y0eeQo+A4OL1BZsQEewsn3lYbHYGNqoh6hdUuxqmJRDAE
	 rGnprnDTb4nfUi6/VLi6nE3FgZv8aGlVF1kZgg71ZagE2JyNDRjnJew51yeVYMyoXA
	 pZZIcxCh/1E+m10mH83No4bHfAHeEtrVWKw7+hrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 025/134] scsi: ufs: core: Clear cmd if abort succeeds in MCQ mode
Date: Tue,  5 Dec 2023 12:14:57 +0900
Message-ID: <20231205031536.983448625@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit 93e6c0e19d5bb12b49534a411c85e21d333731fa upstream.

In MCQ mode, if cmd is pending in device and abort succeeds, response will
not be returned by device. So we need clear the cmd, otherwise timeout will
happen and next time we use same tag we will get a WARN_ON(lrbp->cmd).

Below is error log:

  <3>[ 2277.447611][T21376] ufshcd-mtk 112b0000.ufshci: ufshcd_try_to_abort_task: cmd pending in the device. tag = 7
  <3>[ 2277.476954][T21376] ufshcd-mtk 112b0000.ufshci: Aborting tag 7 / CDB 0x2a succeeded
  <6>[ 2307.551263][T30974] ufshcd-mtk 112b0000.ufshci: ufshcd_abort: Device abort task at tag 7
  <4>[ 2307.623264][  T327] WARNING: CPU: 5 PID: 327 at source/drivers/ufs/core/ufshcd.c:3021 ufshcd_queuecommand+0x66c/0xe34

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20231115131024.15829-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6347,11 +6347,24 @@ static bool ufshcd_abort_one(struct requ
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct ufs_hba *hba = shost_priv(shost);
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
+	struct ufs_hw_queue *hwq;
+	unsigned long flags;
 
 	*ret = ufshcd_try_to_abort_task(hba, tag);
 	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 		*ret ? "failed" : "succeeded");
+
+	/* Release cmd in MCQ mode if abort succeeds */
+	if (is_mcq_enabled(hba) && (*ret == 0)) {
+		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(lrbp->cmd));
+		spin_lock_irqsave(&hwq->cq_lock, flags);
+		if (ufshcd_cmd_inflight(lrbp->cmd))
+			ufshcd_release_scsi_cmd(hba, lrbp);
+		spin_unlock_irqrestore(&hwq->cq_lock, flags);
+	}
+
 	return *ret == 0;
 }
 


