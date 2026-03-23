Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F96A3BD655;
	Mon, 23 Mar 2026 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283047; cv=none; b=Ldb3MRXwCbIUi6gd2Zgo8wHDHxIha0xdczQfNvMufGeZhNojGUrI/saQw6c4yR6EA3Js5g0o2LHdS/+FZkPcrQtyfuYdBnNW+tf35CtRJA/xGyxCLW18DJNJwgEd1WvSUnitdmRFbaIuOzKHYgOJxcaR5K2gJlT4QkM/0yRsGPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283047; c=relaxed/simple;
	bh=1RNcVwuIbamLtaZctYjGHq2fly5iC0ejEexxHqV7Ma4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTH3ueSdRirvd4qop5HHLS06Buh9nFKO5twhLHS8/GgqbfgnThLO9j9kw5wTaqaCJhU5AjZAWA0eavicsBUuaAaTnjJxYgwAFud4+oHJTyPVYfOMvAzGviR1H0IfYOJiq7CVk99yCXxGG8f4BkOP5XI+2ZB5vVHEmKGWZmodc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfjTO8ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfjTO8ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DA2C4CEF7;
	Mon, 23 Mar 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283047;
	bh=1RNcVwuIbamLtaZctYjGHq2fly5iC0ejEexxHqV7Ma4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfjTO8ejl2cgba/Bj0oj5DYlVyk/q6dQ2e9/H4YQ4B29TjtMwxVdHgTD6ZrmqVU7N
	 62NQAZxmfNcNt4aiApP6o6ZRqgRQLf7Iv0pOID2QEIcGq+Lw9zLzHKZOzHqV5tPxCU
	 RznResKSMzyE+/lh8qvGsMsX8bEan7M1nNTWhplA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 383/481] scsi: ufs: core: Fix handling of lrbp->cmd
Date: Mon, 23 Mar 2026 14:46:05 +0100
Message-ID: <20260323134534.473825700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 549e91a9bbaa0ee480f59357868421a61d369770 ]

ufshcd_queuecommand() may be called two times in a row for a SCSI command
before it is completed. Hence make the following changes:

 - In the functions that submit a command, do not check the old value of
   lrbp->cmd nor clear lrbp->cmd in error paths.

 - In ufshcd_release_scsi_cmd(), do not clear lrbp->cmd.

See also scsi_send_eh_cmnd().

This commit prevents that the following appears if a command times out:

WARNING: at drivers/ufs/core/ufshcd.c:2965 ufshcd_queuecommand+0x6f8/0x9a8
Call trace:
 ufshcd_queuecommand+0x6f8/0x9a8
 scsi_send_eh_cmnd+0x2c0/0x960
 scsi_eh_test_devices+0x100/0x314
 scsi_eh_ready_devs+0xd90/0x114c
 scsi_error_handler+0x2b4/0xb70
 kthread+0x16c/0x1e0

Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230524203659.1394307-3-bvanassche@acm.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ Removed the change in ufshcd_advanced_rpmb_req_handler() due to missing
commit:6ff265fc5ef6("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg") ]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2821,7 +2821,6 @@ static int ufshcd_queuecommand(struct Sc
 		(hba->clk_gating.state != CLKS_ON));
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -2837,7 +2836,6 @@ static int ufshcd_queuecommand(struct Sc
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
-		lrbp->cmd = NULL;
 		ufshcd_release(hba);
 		goto out;
 	}
@@ -3047,7 +3045,7 @@ static int ufshcd_exec_dev_cmd(struct uf
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
+	lrbp->cmd = NULL;
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out;
@@ -5357,7 +5355,6 @@ static void ufshcd_release_scsi_cmd(stru
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
-	lrbp->cmd = NULL;	/* Mark the command as completed. */
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
@@ -6936,7 +6933,6 @@ static int ufshcd_issue_devman_upiu_cmd(
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;


