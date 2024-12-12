Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CF42153F4;
	Thu, 12 Dec 2024 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015923; cv=none; b=BeWkyxtkWW3zDvR7qdCTI3uk8x157v3G8SyOPrCAYoaVa98iey+dCM5njalKhsEC4H4jLrX4QcDB1NkqBaFMRoQq1sqkqBMEs9KbyjU/+CV8yJtbxKEjinoSbMnX2hto87NjIfNSjdblcb10ABZKaOmC8Y6DJz0YK8Bchxj0nR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015923; c=relaxed/simple;
	bh=OPUqhlUgdT48ANouUh1Pdm/eGEl/WBlopEyCRw5JZ68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUHn18DdKI7aubQ+SFMjNMJ1doI9aszfbJmaC4GH/E1x0leFTQ3jgQ9+oCTdZ+F4rKf2J1sZLtYU0iNaHxPZs9PecM0eHBxELSpgj9CH90AOS3ZBe2IMhiahPxJ57ptwkDQvy6tMuqVg8IaP5tbFKPJ5Kl/7pxdtN4gEQj/PG28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOQFEEtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOQFEEtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8847EC4CECE;
	Thu, 12 Dec 2024 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015923;
	bh=OPUqhlUgdT48ANouUh1Pdm/eGEl/WBlopEyCRw5JZ68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOQFEEtOCQHN/QTBe7E0OSMiQ7DDhzQu8f/4M9DTs2YqgcN3Fk39e6HUVqw3dBpta
	 uw/KSNy+p1gEVXI8+J6EcYDcHXezcZV+PisYM5M9UMBcnNCLaAizLwhcxNfdEEHdz9
	 htZrx1/P0oOgPMmUZuYEAp8zpQjLlIrbk+m5e+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/466] scsi: ufs: core: Always initialize the UIC done completion
Date: Thu, 12 Dec 2024 15:54:10 +0100
Message-ID: <20241212144310.019671380@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b1e8c53749adb795bfb0bf4e2f7836e26684bb90 ]

Simplify __ufshcd_send_uic_cmd() by always initializing the
uic_cmd::done completion. This is fine since the time required to
initialize a completion is small compared to the time required to
process an UIC command.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20240912223019.3510966-5-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 60b4dd1460f6 ("scsi: ufs: core: Add ufshcd_send_bsg_uic_cmd() for UFS BSG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abbe7135a9778..f68e13aac8d37 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2551,13 +2551,11 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
  * @hba: per adapter instance
  * @uic_cmd: UIC command
- * @completion: initialize the completion only if this is set to true
  *
  * Return: 0 only if success.
  */
 static int
-__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
-		      bool completion)
+__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	lockdep_assert_held(&hba->uic_cmd_mutex);
 
@@ -2567,8 +2565,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
 		return -EIO;
 	}
 
-	if (completion)
-		init_completion(&uic_cmd->done);
+	init_completion(&uic_cmd->done);
 
 	uic_cmd->cmd_active = 1;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
@@ -2594,7 +2591,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	mutex_lock(&hba->uic_cmd_mutex);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
-	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
 
@@ -4288,7 +4285,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		reenable_intr = true;
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
+	ret = __ufshcd_send_uic_cmd(hba, cmd);
 	if (ret) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
-- 
2.43.0



