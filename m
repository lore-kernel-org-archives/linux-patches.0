Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4D11F707B;
	Tue, 21 Jan 2025 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482379; cv=none; b=ttWsq7o72OLjmRcRxRM9V2Tnk2DGa2DjX1eM0UKFetyOfPf8WnVaQd0K+RevRSbvxboWFHEODOsaWLx2N1bcUi9WmxnM8AdcGiFICKRosIK7IWYH+RR/yzo5/Q6UtJHy3Sn7RiSUOCY1pUV3FIfyWMJYHi5ntQKImLlSQ6I59y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482379; c=relaxed/simple;
	bh=63RR5c3VC1qfAkCaGsDtnPnsl+RYub2pENbjk9j+/7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MP5oe+Y/LvZbn7OisfD+Y97fMAA91EOLaTQWWP1NQg5aPyYjR694u2SwdMp9yhc1FsTGBpvYH+8bQa70OkA1P1wSXywXwO4hEGvRSBN2qQQ5o9GuJUFjvcVCwZKn5W2RxKEj9U3NE3XgGLwa4FKQhpTpdMmb117ZTBWZbnm6oms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjd6I+CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjd6I+CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E488DC4CEE0;
	Tue, 21 Jan 2025 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482379;
	bh=63RR5c3VC1qfAkCaGsDtnPnsl+RYub2pENbjk9j+/7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjd6I+CQpu+a/zMj9ZNvCB9kZ8OQVfv2s7A50gAiK4bXOfnSzlEFXZyA+7SMiNNTg
	 81MG84hkOcWToqfP6CyMIF6nJUu+sH52n7JgzvRTjezTXiKsAvHbhsQCn3ojam8ilv
	 Lj0AD4OQjC4SSh10FhtJY1e2ZhFs0Gp8V4HaCd2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/122] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Tue, 21 Jan 2025 18:51:44 +0100
Message-ID: <20250121174535.148427260@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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
index 05b936ad353be..6cc9e61cca07d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10589,14 +10589,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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



