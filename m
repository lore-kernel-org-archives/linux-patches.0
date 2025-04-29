Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A03127E18;
	Tue, 29 Apr 2025 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946458; cv=none; b=EWMrUTnEYgMsoOUftCm5WFEIdYhICjsXRAag7IwBhN8lZf7mM1C8o9ZkcNgLUqTD1R+DmpQwA50fLbamDA0wY0pT/YKE+eo0KsxhQoxlr+iCA2kgrsYsC62QysSoGdMaRKgDSeGFkXbBqHBopd443aWMMv7Fz89IXZmnlY2kUP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946458; c=relaxed/simple;
	bh=OhjCo4NO5pI5NoO3T2Kh0MYMZzHXx+7nIVKjL0nxTlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAODOuJjdHb3vfpGv7Scoa4zRevM36/Vyi1xOmIwHFIQ1pP8CL2Lqt9eYqp/6flJZ9t8/b+qJxiPCcS3kpsnbkLBBm6E3Th32XIqO5PuK3DmURgJyTkrATBPmZyugqUfal/ObOgABo27I1qWx9fyTay5Mv/ZhSHPmJ8oPJ6P0Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyOrfGdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyOrfGdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574A9C4CEE3;
	Tue, 29 Apr 2025 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946457;
	bh=OhjCo4NO5pI5NoO3T2Kh0MYMZzHXx+7nIVKjL0nxTlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jyOrfGdX04RBb4BkSSvA+76Q7KV2w00fUOjDoHiidIBCh7QwqgO1HHG0CRHGe9hbL
	 xdrxIU9rs66EnZbMxeZdxxSR6s1mSHev2BGQx0jMDXR1FQlizA+fxvYix3dsMEKLi0
	 /hMWbKX3T1vEtOY2qc1dRyKmB+292URfpQL1ILi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 273/311] scsi: ufs: exynos: gs101: Put UFS device in reset on .suspend()
Date: Tue, 29 Apr 2025 18:41:50 +0200
Message-ID: <20250429161132.205288677@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit cd4c0025069f16fc666c6ffc56c49c9b1154841f ]

GPIO_OUT[0] is connected to the reset pin of embedded UFS device.
Before powering off the phy assert the reset signal.

This is added as a gs101 specific suspend hook so as not to have any
unintended consequences for other SoCs supported by this driver.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-7-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 10 ++++++++++
 drivers/ufs/host/ufs-exynos.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index b9fbc78be74ee..2436b9454480b 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1700,6 +1700,12 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
 	}
 }
 
+static int gs101_ufs_suspend(struct exynos_ufs *ufs)
+{
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
@@ -1708,6 +1714,9 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (status == PRE_CHANGE)
 		return 0;
 
+	if (ufs->drv_data->suspend)
+		ufs->drv_data->suspend(ufs);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
@@ -2170,6 +2179,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
 	.pre_pwr_change		= gs101_ufs_pre_pwr_change,
+	.suspend		= gs101_ufs_suspend,
 };
 
 static const struct of_device_id exynos_ufs_of_match[] = {
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index d0b3df221503c..3c6fe5132190a 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -192,6 +192,7 @@ struct exynos_ufs_drv_data {
 				struct ufs_pa_layer_attr *pwr);
 	int (*pre_hce_enable)(struct exynos_ufs *ufs);
 	int (*post_hce_enable)(struct exynos_ufs *ufs);
+	int (*suspend)(struct exynos_ufs *ufs);
 };
 
 struct ufs_phy_time_cfg {
-- 
2.39.5



