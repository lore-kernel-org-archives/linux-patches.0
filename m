Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9942F2345;
	Tue, 17 Jun 2025 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176125; cv=none; b=Ra09tgHb12zDZD5+CDU6L6bH9v0zC/rJD7Hsc1Kd5+I8Lnq63yoxU85utAQ2S0TW2FTO3yfvxZAsGBXBc9dDpOMT8G2dhVdyGMMSulMk+wCgtWLKaJniwZv+zpMbLjTKb/rhCgkzVoKzezEzW50NStUx1f/a231ugVpU3ihsBF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176125; c=relaxed/simple;
	bh=lQfAmT1ClX4k+oT/iz3nyvXlwrR8GbGTpmHHewclPXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U02Em7Adye53uDWhZDtVv0nAInj3yPd8OG8rPqkhacJHc7lcpAK26uqIQRQSZP5ZdopEcs3atnsh9sfxfmAjNgDZ1Ga8vTv4lkI815cXyLZhPLFcfjNLtT/Zu5nOuazPJgBOTTN6QZPKWE2Dh7f+mINLzvGLo2ADw7VuC2httJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeibXtSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeibXtSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F92C4CEE3;
	Tue, 17 Jun 2025 16:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176124;
	bh=lQfAmT1ClX4k+oT/iz3nyvXlwrR8GbGTpmHHewclPXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeibXtSVtFXKEPgOwendqLxNBmM+Po2N08V9NXjphadZFNBGnzJN5MIaWOsRfRSJu
	 Z+M6d74HuAaIUPp0QWfnWgLgPUqYeGf3p66IGFq7u69bRaZxf6z2F8QVE05xFFaq/u
	 ey9A7RgDFlJdZKzE76G0DtxrTwnY/lkif4zYzoFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ping.gao" <ping.gao@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/512] scsi: ufs: mcq: Delete ufshcd_release_scsi_cmd() in ufshcd_mcq_abort()
Date: Tue, 17 Jun 2025 17:22:26 +0200
Message-ID: <20250617152426.947224394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 45b04f3c37764..420e943bb73a7 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -670,7 +670,6 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
-	unsigned long flags;
 	int err;
 
 	/* Skip task abort in case previous aborts failed and report failure */
@@ -709,10 +708,5 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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



