Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE3C1917E3;
	Tue, 29 Apr 2025 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948385; cv=none; b=LtKqIyz49toj7KtvLkcmK1eWpreu4O4aPvUIlyRDIaf+ofWqD6bBJmZttbN8p7nJdlufiYjE5hat2XtHIBL9dggrt2xcsyl+zugEMkpLTpzITDcA3HEZFOLO4xHL6GSaYkaARdJA5m3I2/5dFj3pLXvAD09mcH1GSOKX7RpFPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948385; c=relaxed/simple;
	bh=U7P/Uk/dCxY2QpS9WyzrIyaZnqxChNQu0E/miT0keDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwsLl4548ykWmalvH8G1lnATl2DxxxAZ8t9WEBtBTfOxWlxqzAypGP90AldRbR+AjidvIyrCO3yRqWwfg7W7TiFbdNQ97Vcl2l7OMjLv4Lp7FrlpTH9vZg8+bI3QHvxW22Wul72xPjHhl0BOCa19NQZ4rM/K/sLG6MvM81M7rKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmrBZrk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmrBZrk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8739BC4CEE3;
	Tue, 29 Apr 2025 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948384;
	bh=U7P/Uk/dCxY2QpS9WyzrIyaZnqxChNQu0E/miT0keDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmrBZrk2aOJmKGRBQ07vhAK8xTKEonsrZOyCVcwR65G2ZjEh1AtAGQPkfotTkq//3
	 dM4fNmybMCL1GbBylZQMDm06Fqz35DFBJ9xml8s9oTjFoLLFcrmD8ORAATsd7gfMvz
	 AQ20KO0+/ekYn67SPqnuRPnshfWZHtrmgsYHxQWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/280] scsi: ufs: exynos: gs101: Put UFS device in reset on .suspend()
Date: Tue, 29 Apr 2025 18:42:53 +0200
Message-ID: <20250429161124.612667898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
index 55ea863b47f3d..5ba17ccf6417f 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1687,6 +1687,12 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
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
@@ -1695,6 +1701,9 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (status == PRE_CHANGE)
 		return 0;
 
+	if (ufs->drv_data->suspend)
+		ufs->drv_data->suspend(ufs);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
 
@@ -2172,6 +2181,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
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



