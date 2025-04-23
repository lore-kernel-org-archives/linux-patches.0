Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5F528EA5B;
	Wed, 23 Apr 2025 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421207; cv=none; b=M2LkOW+mBaxGMzjiklElwve1EhvECcVWLaOLBgkKTTpKBCQAehLkzsIMUOo/nOq0fY7GQwQYLWzLfpQKyU3Y6NywI7bhynZ7IPeW0xLumxlPEnpLHWLKcyIqKnxWjCS8btr0xsF4VksH1g3TVxA+xHFM8HBzmppLc0fqw5iIPW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421207; c=relaxed/simple;
	bh=zPFDKDMdYt2gUQgo0ju4gMV4+QL5g+UESwSmVsIJjtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4oK5TzpEMcpFahWWvjh7NWWcwv3AoYvDPysR4cJBOfms/cJxQMlI+bxDooW5yuuYr4GCLsjY5+2rErFmVKa4s6t9F09QdndnJzN+xF9luTMJvIzjYivikPgc/Q2Eu2lpOh/FzdengiE4/6N2uI10XVR3khqqI5kPcnw7ir7eKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrGbAZIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrGbAZIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DB4C4CEE2;
	Wed, 23 Apr 2025 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421207;
	bh=zPFDKDMdYt2gUQgo0ju4gMV4+QL5g+UESwSmVsIJjtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrGbAZITS2qvtuizOBlJNwXnwDOEryNA9HWfOqVwLPBdzSN5Mdn5fSG3dqy/6umJ5
	 sYEyCgh3/uuS9lqHNLbv2yS0X6PyAHiSYEjI8R357rX3AEZEjrbrOWrKZ/iqCxZx6o
	 RFQ1RFBra0hRo8NevtlMnvi9LpeYUPyQVjg/vCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.14 161/241] scsi: ufs: exynos: Move UFS shareability value to drvdata
Date: Wed, 23 Apr 2025 16:43:45 +0200
Message-ID: <20250423142627.114522837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

commit 68f5ef7eebf0f41df4d38ea55a54c2462af1e3d6 upstream.

gs101 I/O coherency shareability bits differ from exynosauto SoC. To
support both SoCs move this info the SoC drvdata.

Currently both the value and mask are the same for both gs101 and
exynosauto, thus we use the same value.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-2-96722cc2ba1b@linaro.org
Fixes: d11e0a318df8 ("scsi: ufs: exynos: Add support for Tensor gs101 SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-exynos.c |   20 ++++++++++++++------
 drivers/ufs/host/ufs-exynos.h |    2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -92,11 +92,16 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
 
-/* FSYS UFS Shareability */
-#define UFS_WR_SHARABLE		BIT(2)
-#define UFS_RD_SHARABLE		BIT(1)
-#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
-#define UFS_SHAREABILITY_OFFSET	0x710
+/* UFS Shareability */
+#define UFS_EXYNOSAUTO_WR_SHARABLE	BIT(2)
+#define UFS_EXYNOSAUTO_RD_SHARABLE	BIT(1)
+#define UFS_EXYNOSAUTO_SHARABLE		(UFS_EXYNOSAUTO_WR_SHARABLE | \
+					 UFS_EXYNOSAUTO_RD_SHARABLE)
+#define UFS_GS101_WR_SHARABLE		BIT(1)
+#define UFS_GS101_RD_SHARABLE		BIT(0)
+#define UFS_GS101_SHARABLE		(UFS_GS101_WR_SHARABLE | \
+					 UFS_GS101_RD_SHARABLE)
+#define UFS_SHAREABILITY_OFFSET		0x710
 
 /* Multi-host registers */
 #define MHCTRL			0xC4
@@ -210,7 +215,7 @@ static int exynos_ufs_shareability(struc
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
 					  ufs->shareability_reg_offset,
-					  UFS_SHARABLE, UFS_SHARABLE);
+					  ufs->iocc_mask, ufs->iocc_mask);
 	}
 
 	return 0;
@@ -1174,6 +1179,7 @@ static int exynos_ufs_parse_dt(struct de
 		}
 	}
 
+	ufs->iocc_mask = ufs->drv_data->iocc_mask;
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
@@ -2034,6 +2040,7 @@ static const struct exynos_ufs_drv_data
 	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.iocc_mask		= UFS_EXYNOSAUTO_SHARABLE,
 	.drv_init		= exynosauto_ufs_drv_init,
 	.post_hce_enable	= exynosauto_ufs_post_hce_enable,
 	.pre_link		= exynosauto_ufs_pre_link,
@@ -2135,6 +2142,7 @@ static const struct exynos_ufs_drv_data
 	.opts			= EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
+	.iocc_mask		= UFS_GS101_SHARABLE,
 	.drv_init		= gs101_ufs_drv_init,
 	.pre_link		= gs101_ufs_pre_link,
 	.post_link		= gs101_ufs_post_link,
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -181,6 +181,7 @@ struct exynos_ufs_drv_data {
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
+	u32 iocc_mask;
 	/* SoC's specific operations */
 	int (*drv_init)(struct exynos_ufs *ufs);
 	int (*pre_link)(struct exynos_ufs *ufs);
@@ -231,6 +232,7 @@ struct exynos_ufs {
 	const struct exynos_ufs_drv_data *drv_data;
 	struct regmap *sysreg;
 	u32 shareability_reg_offset;
+	u32 iocc_mask;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)


