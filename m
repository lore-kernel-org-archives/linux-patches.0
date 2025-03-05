Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0DF1FC7D0;
	Wed,  5 Mar 2025 18:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197981; cv=none; b=EpTJOnKR2jQZOiivhME+3LChphEuBvEBZbNKJ4i2e0iWWhctn6wtjlc+26nQ4VysgguLn5w38EdWGjHSvVSEa0qF+B+BjWWCGQQaf3k4EIkWSoazA4rRBydxgeso9gtrKTP10/kbaSKfdfdpGOE7X9vqqydcya48BsxdAPlvWO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197981; c=relaxed/simple;
	bh=yc2SCE3kppb/91lLPx4sBodgo7+Uzpv9Aj9e7kila8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEtAZvtjsy23YXfA933Snv3Q24EUzMq5oQ6+CpzuycgWwVInsSCckuXn0DpDQ7ftQVufM//0hYQy4RvEHxK9l2/DNMw1UVIdBcsdC4EIGEhKAMgPW9Wr5R12pY6t+T9lfo+j0ib58yyfgZBFOdIGGlbgoGioViEVy033AqXzmdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGrYKtXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGrYKtXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C79C4CEE0;
	Wed,  5 Mar 2025 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197981;
	bh=yc2SCE3kppb/91lLPx4sBodgo7+Uzpv9Aj9e7kila8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGrYKtXQA1VxDxvwvGj/aLoqTLtWxhMJ5Cz4+pVyrsNiPmPOzpKXpIHZagNAKIv6B
	 VWvq62dx/tnk1Jyf2Jux5sFW5utR3M+bde2o9r/+vDWrT9bI5B0XRLDqjQgYuobfo0
	 e0rnBJBRkGP6vvX/yXyIuvy1jv1WHoye1l9+xIrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/150] scsi: ufs: core: Set default runtime/system PM levels before ufshcd_hba_init()
Date: Wed,  5 Mar 2025 18:47:33 +0100
Message-ID: <20250305174504.783490462@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit fe06b7c07f3fbcce2a2ca6f7b0d543b5699ea00f ]

Commit bb9850704c04 ("scsi: ufs: core: Honor runtime/system PM levels if
set by host controller drivers") introduced the check for setting default
PM levels only if the levels are uninitialized by the host controller
drivers. But it missed the fact that the levels could be initialized to 0
(UFS_PM_LVL_0) on purpose by the controller drivers. Even though none of
the drivers are doing so now, the logic should be fixed irrespectively.

So set the default levels unconditionally before calling ufshcd_hba_init()
API which initializes the controller drivers. It ensures that the
controller drivers could override the default levels if required.

Fixes: bb9850704c04 ("scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers")
Reported-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250219105047.49932-1-manivannan.sadhasivam@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ff4878cf882be..a3e95ef5eda82 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10457,6 +10457,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	spin_lock_init(&hba->clk_gating.lock);
 
+	/*
+	 * Set the default power management level for runtime and system PM.
+	 * Host controller drivers can override them in their
+	 * 'ufs_hba_variant_ops::init' callback.
+	 *
+	 * Default power saving mode is to keep UFS link in Hibern8 state
+	 * and UFS device in sleep state.
+	 */
+	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+						UFS_SLEEP_PWR_MODE,
+						UIC_LINK_HIBERN8_STATE);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
@@ -10606,21 +10621,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto free_tmf_queue;
 	}
 
-	/*
-	 * Set the default power management level for runtime and system PM if
-	 * not set by the host controller drivers.
-	 * Default power saving mode is to keep UFS link in Hibern8 state
-	 * and UFS device in sleep state.
-	 */
-	if (!hba->rpm_lvl)
-		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
-						UFS_SLEEP_PWR_MODE,
-						UIC_LINK_HIBERN8_STATE);
-	if (!hba->spm_lvl)
-		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
-						UFS_SLEEP_PWR_MODE,
-						UIC_LINK_HIBERN8_STATE);
-
 	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work, ufshcd_rpm_dev_flush_recheck_work);
 	INIT_DELAYED_WORK(&hba->ufs_rtc_update_work, ufshcd_rtc_work);
 
-- 
2.39.5



