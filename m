Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E601F5438;
	Tue, 21 Jan 2025 18:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482645; cv=none; b=Z+ycwIp04nfpBL3dH5O8SCYRboiGvcnRKYqEMIBdJh9ihuFso3PKtcEqVX1x8T+s+ufVqtUW8Eq1UwcVif0cuur/IaqQP7U55oxScvWi54eoIAlDsBiLgkd/Rg2ji1XJA9t8MVyNUJCxq8nfRWL2ka6xZSjH2zB5pfv8+vrMJI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482645; c=relaxed/simple;
	bh=i3mSLQXv0M7g9wvlW3SdoSqGoAp+FBbyusMifDo6uIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gC1+wjp55r5Xo5HQMKn9Uu9/cURTRC2tSJtTpu3rpRvX8ZPJmobJ7j0mmruQbED1bHs569mHmA+2IGm9/jFt706gyUwd325XErQO/2+QX4vh6Tor6BnsIRibIi48tVXyIZXNMVgt2kk5FxUBjA+c/dIxY2GJg/jim5sAmjo2t9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jl8zVDzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jl8zVDzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676E5C4CEE1;
	Tue, 21 Jan 2025 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482644;
	bh=i3mSLQXv0M7g9wvlW3SdoSqGoAp+FBbyusMifDo6uIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jl8zVDzR/lr4EE5mB2I9KrCTKuRh9UuR+m5ZoAuFDA9pOC9EqOJ4Vpy49bfum+eTc
	 m68Rikw7Gs9NY8bVa2a6vWsLNovHCtDGccu+HRYGb4UNsi2WCsTNb1N4IMUE1iAcFY
	 8E7dyVWxhzxN0eOKyGxeoA1mu4pVyJLOLzNk7uM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/64] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Tue, 21 Jan 2025 18:52:23 +0100
Message-ID: <20250121174522.479067379@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit bb9850704c043e48c86cc9df90ee102e8a338229 ]

Otherwise, the default levels will override the levels set by the host
controller drivers.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241219-ufs-qcom-suspend-fix-v3-2-63c4b95a70b9@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1ea7ae78fca2c..c5115f6adbdc2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9879,14 +9879,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/*
-	 * Set the default power management level for runtime and system PM.
+	 * Set the default power management level for runtime and system PM if
+	 * not set by the host controller drivers.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
 	 * and UFS device in sleep state.
 	 */
-	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->rpm_lvl)
+		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
-	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->spm_lvl)
+		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
-- 
2.39.5



