Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8F7143C58;
	Wed, 19 Jun 2024 13:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802706; cv=none; b=VZLbIx2jDJbnvPH8apNKy0V9IR0/yIBmztLSNXIxcfVJwKssahzeyDs942ux3fdGiqfL6x1jPLq/kPwKwlsSPEAScBSfmDSUPlcwvkovWoHhHL72MAb5IumJ1/63dja1CTc9va2elPedTdrNm6RD+SrkwrsKuBmwzfiCGialDms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802706; c=relaxed/simple;
	bh=JxIESsJKq4LWKt50G66ajxf+eYuvGuibKPCq1rrExzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gl8Lv+9Sk38EX0xHB+xZ1Gw20xnUQ7tAfgzmUBiahGKLZiXdXBWslYfnxhe0jBDOnvD5225gEoGhlGJJbDQ0Q+W65GQfPhJubZooTtm0cuicMTWePVFTt0t1Ag5XSAeo6KGmJVN/HiFgTeCGK4TSloK90LHbZ56R7WP9ede8zI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KP6ZYWcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KP6ZYWcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFD9C2BBFC;
	Wed, 19 Jun 2024 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802706;
	bh=JxIESsJKq4LWKt50G66ajxf+eYuvGuibKPCq1rrExzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KP6ZYWcA135+85Y4RpMLtQE25x6TycINxpu2MNtci5ZRry6Aq0JD6MqGrDnVrVFZv
	 jfg4A3WTuu/Np/88BuFJN8vhqG7qsQEoiVjEcuZxvdzvi8P3dx5rrW5HmbaHjNxnnj
	 enkyIpVspd2QeIvSF6OaeDPYXP/WtHdmIPdyAXB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chanwoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 020/281] scsi: ufs: mcq: Fix error output and clean up ufshcd_mcq_abort()
Date: Wed, 19 Jun 2024 14:52:59 +0200
Message-ID: <20240619125610.625907418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 005d63ab1f441..8944548c30fa1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -634,20 +634,20 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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
@@ -659,7 +659,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 		 */
 		dev_err(hba->dev, "%s: cmd found in sq. hwq=%d, tag=%d\n",
 			__func__, hwq->id, tag);
-		goto out;
+		return FAILED;
 	}
 
 	/*
@@ -667,18 +667,17 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
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



