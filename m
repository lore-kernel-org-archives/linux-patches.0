Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7212DFF17;
	Tue, 17 Jun 2025 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177428; cv=none; b=dcsJ1axRp9fdWoIVw6A4XZlEUoWJqOT1Czkc4tmdhiS12FgJgvc+KVTHS2x8yqjnxm9O5zZyzUEgfY212VP8okzK6gZdiZBbmX+D+uwPSKQNUOa9HU+Bv/vQzeXhs2RrPLtuSahOKDSERy43WSSfdqzg5u+/qogYDvA7pNdZdG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177428; c=relaxed/simple;
	bh=oqR5ptHMG50fs/tiOkBIi5tuVQDkFyLwwlNpRR/+lFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo+eRS6ab7lqJ/in6n18Kx0qcUCyYMqJ3d/D53pGGOuWtzCYcE8JEqVvaCZ36iS6x6i19Ri0JTv+vdFDM83lMG85l/2bwHmQroG+GPU7uH7WfWo9i1T0SIyS9a2rP6C/sWVUrZTgqRyZwEr+YKzmNf3Q1TUs733saDV2jRVi7gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBme1rZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBme1rZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B03C4CEE3;
	Tue, 17 Jun 2025 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177428;
	bh=oqR5ptHMG50fs/tiOkBIi5tuVQDkFyLwwlNpRR/+lFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBme1rZKk6plSEfJVExXRQFsZxc+W86hLitEMaatEtpGD40lRf+K4aPL/cv+xvaRy
	 wTilpCK3JcEy82ReKDt1Vux4t7rIJBgXN23+VYTm5Gwn+EFWvnvQ9UPEwNypJOoCP+
	 u4gmAad/5y2QLgIQZtb48/FmeVvT7EHx1QnqWQYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ping.gao" <ping.gao@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 282/780] scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()
Date: Tue, 17 Jun 2025 17:19:50 +0200
Message-ID: <20250617152502.955551977@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ping.gao <ping.gao@samsung.com>

[ Upstream commit 53755903b9357e69b2dd6a02fafbb1e30c741895 ]

After UFS_ABORT_TASK has been processed successfully, the host will
generate MCQ IRQ for ABORT TAG with response OCS_ABORTED. This results in
ufshcd_compl_one_cqe() calling ufshcd_release_scsi_cmd().

But ufshcd_mcq_abort() already calls ufshcd_release_scsi_cmd(), resulting
in __ufshcd_release() being called twice. This means
hba->clk_gating.active_reqs will be decreased twice, making it go
negative.

Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort().

Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Signed-off-by: ping.gao <ping.gao@samsung.com>
Link: https://lore.kernel.org/r/20250516083812.3894396-1-ping.gao@samsung.com
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index f1294c29f4849..1e50675772feb 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -674,7 +674,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 	int err;
 
 	/* Skip task abort in case previous aborts failed and report failure */
@@ -713,10 +712,5 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
-	spin_lock_irqsave(&hwq->cq_lock, flags);
-	if (ufshcd_cmd_inflight(lrbp->cmd))
-		ufshcd_release_scsi_cmd(hba, lrbp);
-	spin_unlock_irqrestore(&hwq->cq_lock, flags);
-
 	return SUCCESS;
 }
-- 
2.39.5



