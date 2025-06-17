Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32B23B633;
	Tue, 17 Jun 2025 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174962; cv=none; b=VbZiTLLFbr40OO2F50pWow32+f8F+MKlCWU04Jff7TST1VpgihoBazZjVZkbMUaGx2ZyxJAHzFdGKHGtI+Gp8MMyCQmiVqI/l7bpYh6hQlQtvqehNGw/as8YQ3ke4DuJKp0o5Q5HLTUdCW3Au6AcjPWli8z4GE9/+ZlQDyhyGtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174962; c=relaxed/simple;
	bh=9xl/tnJh/kSqWYJ9Ov8P2Q1V60kJJSuRr8uEPId4+Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gi4ttenEPUF3Rmngj5c0189SXuCmPtyNtzdLm5oHmDARtBMrfxH7JgGxRhCUHXC1BAedFtt1FDXgcfBFOQ6GSGV2DvXTMtuxv5UIZ+hTeED4n9yxFMW/c5olN0d6gJ9qAIJeFyTBTefExvmoRlfvUknj5l9Z1lXrNQ3/FU8YBb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2rshDIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2rshDIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019F0C4CEE3;
	Tue, 17 Jun 2025 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174962;
	bh=9xl/tnJh/kSqWYJ9Ov8P2Q1V60kJJSuRr8uEPId4+Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2rshDIvGrmSCgaeA2ML6ha22kNw68os8O4/IL9fRB+dOyblbIdB9Aa4HZMoXMdjp
	 bnjfRzwU5f5BhFSYPQ4Edo117Eal8PMw7omfW/dcJD/EazcV6sUrGVLYVe/ngeVtCN
	 Dq5Gy+p07i90wSqQn35KARr+Wi9JZoWeVtzCVCqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ping.gao" <ping.gao@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/356] scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()
Date: Tue, 17 Jun 2025 17:24:07 +0200
Message-ID: <20250617152343.548826552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index 411109a5ebbff..14864cfc24223 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -629,7 +629,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 	int err;
 
 	/* Skip task abort in case previous aborts failed and report failure */
@@ -668,10 +667,5 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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



