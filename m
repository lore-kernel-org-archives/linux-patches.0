Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817C3143C45;
	Wed, 19 Jun 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801895; cv=none; b=L3UNGKktSB/wrIBviIPuByW3Cxk+rmOU2vtH2ETP6kKMnShxgOsu0oDF5hb39Lsu19rUKOh4Q5+V2tNa6LOlDbLk2T2UWNc9RbIZiLQU4uaE53csB1U2/kxJgJF6pcnFinICRIp/SjHKfqVwJiWy5jPqrsK42bCiEFrkGToqXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801895; c=relaxed/simple;
	bh=Lbh8t8szIfevDEda5lh7LfmS/PnBiP1+w3wGB7wXb7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNxjEpNV6EZXAxDn++IZSKI1w8l3/KhvjYD6BHOSxfJcCbwgWU3YWwFfBcoQ1nGPvbMsMFZSbjsa3oq7ujhDwtZe5WngbTzoETRY/XxRYVf/pITYTeUdFLTMXi1OJzQHbb8XZ5lDyMEure6iMYhAYotng46JqFzpn9gp/lxHc4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xq/IY9+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xq/IY9+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31C2C2BBFC;
	Wed, 19 Jun 2024 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801895;
	bh=Lbh8t8szIfevDEda5lh7LfmS/PnBiP1+w3wGB7wXb7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xq/IY9+Q2TwHePnmjjR8yCdtMGUJLAy0hCq9jqqgQfcFstUVe6BlqelsYzzHb4NJ8
	 DVR5dhMJqH3gJ6fT/ot9BJkIavmRskdMA7ABjMlic2L7kUHLEIR3qBOYieqbr93WPb
	 pf0Vbs6HtxFAEVT5QIFr1QiPx/KczWLW6J3n+aYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/267] scsi: ufs: mcq: Fix error output and clean up ufshcd_mcq_abort()
Date: Wed, 19 Jun 2024 14:52:44 +0200
Message-ID: <20240619125606.863777081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Chanwoo Lee <cw9316.lee@samsung.com>

[ Upstream commit d53b681ce9ca7db5ef4ecb8d2cf465ae4a031264 ]

An error unrelated to ufshcd_try_to_abort_task is being logged and can
cause confusion. Modify ufshcd_mcq_abort() to print the result of the abort
failure. For readability, return immediately instead of 'goto'.

Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
Link: https://lore.kernel.org/r/20240524015904.1116005-1-cw9316.lee@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 7ae3096814282..4e84ee6564d4b 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -630,20 +630,20 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
 	unsigned long flags;
-	int err = FAILED;
+	int err;
 
 	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
 		dev_err(hba->dev,
 			"%s: skip abort. cmd at tag %d already completed.\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		dev_err(hba->dev, "%s: skip abort. tag %d failed earlier\n",
 			__func__, tag);
-		goto out;
+		return FAILED;
 	}
 
 	hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
@@ -655,7 +655,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		 */
 		dev_err(hba->dev, "%s: cmd found in sq. hwq=%d, tag=%d\n",
 			__func__, hwq->id, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/*
@@ -663,18 +663,17 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	 * in the completion queue either. Query the device to see if
 	 * the command is being processed in the device.
 	 */
-	if (ufshcd_try_to_abort_task(hba, tag)) {
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err) {
 		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
 		lrbp->req_abort_skip = true;
-		goto out;
+		return FAILED;
 	}
 
-	err = SUCCESS;
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	if (ufshcd_cmd_inflight(lrbp->cmd))
 		ufshcd_release_scsi_cmd(hba, lrbp);
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
-out:
-	return err;
+	return SUCCESS;
 }
-- 
2.43.0



