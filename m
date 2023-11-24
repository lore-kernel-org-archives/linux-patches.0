Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AFD381D5;
	Fri, 24 Nov 2023 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECE87XIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE654C433C7;
	Fri, 24 Nov 2023 18:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849606;
	bh=XzvJ9tiJOw5s+3uhl37P4eUy9zUu+Y+77JeQU2NObtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECE87XIU9dQTGsigZFdS++trgBn1CMsRVorn7ZJ8XcscRIwf1y+evTIQSQeGGeIBZ
	 OrCHfVBFdZJREfbJ1Q+X/Tv0Q5ExgsVzqVyrb/gIJqddMTjEH97cAaZm3REJe3L6TW
	 KX+iH5gZ2Eq2Se6JXvh3iU1vWGaIXWgffi5HekLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 249/530] scsi: ufs: qcom: Update PHY settings only when scaling to higher gears
Date: Fri, 24 Nov 2023 17:46:55 +0000
Message-ID: <20231124172035.635304836@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit fc88ca19ad0989dc0e4d4b126d5d0ba91f6cb616 upstream.

The "hs_gear" variable is used to program the PHY settings (submode) during
ufs_qcom_power_up_sequence(). Currently, it is being updated every time the
agreed gear changes. Due to this, if the gear got downscaled before suspend
(runtime/system), then while resuming, the PHY settings for the lower gear
will be applied first and later when scaling to max gear with REINIT, the
PHY settings for the max gear will be applied.

This adds a latency while resuming and also really not needed as the PHY
gear settings are backwards compatible i.e., we can continue using the PHY
settings for max gear with lower gear speed.

So let's update the "hs_gear" variable _only_ when the agreed gear is
greater than the current one. This guarantees that the PHY settings will be
changed only during probe time and fatal error condition.

Due to this, UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH can now be skipped
when the PM operation is in progress.

Cc: stable@vger.kernel.org
Fixes: 96a7141da332 ("scsi: ufs: core: Add support for reinitializing the UFS device")
Reported-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20230908145329.154024-1-manivannan.sadhasivam@linaro.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Tested-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c   |    3 ++-
 drivers/ufs/host/ufs-qcom.c |    9 +++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8723,7 +8723,8 @@ static int ufshcd_probe_hba(struct ufs_h
 	if (ret)
 		goto out;
 
-	if (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
+	if (!hba->pm_op_in_progress &&
+	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
 		/* Reset the device and controller before doing reinit */
 		ufshcd_device_reset(hba);
 		ufshcd_hba_stop(hba);
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -909,8 +909,13 @@ static int ufs_qcom_pwr_change_notify(st
 			return ret;
 		}
 
-		/* Use the agreed gear */
-		host->hs_gear = dev_req_params->gear_tx;
+		/*
+		 * Update hs_gear only when the gears are scaled to a higher value. This is because,
+		 * the PHY gear settings are backwards compatible and we only need to change the PHY
+		 * settings while scaling to higher gears.
+		 */
+		if (dev_req_params->gear_tx > host->hs_gear)
+			host->hs_gear = dev_req_params->gear_tx;
 
 		/* enable the device ref clock before changing to HS mode */
 		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&


