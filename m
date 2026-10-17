Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C6936195A;
	Sat, 17 Oct 2026 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260575; cv=none; b=O8EV8dcUUOC9VZJ8K3KffdDpC+Qxm2X1Nn9ePNHbQEm6WJYe/Nsb0g7CjU0DOq8w3xBzktD7vIq5Cq9derM2qWxacLYNnv1aKF5Di23z4F7xVM5IWenImFZIwhcGF4bpQCxRNfewEwj9joklSy6kOlUrWjYTGXOqByWvIQ2aVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260575; c=relaxed/simple;
	bh=vaBcL72PMuEHcPyz7uA/MseQpClGrKNzwY5wITHT+hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdDWR/l3G6XGeX8eErheXPBVT1rxRWL3ALWar7VThXtDflA3oKcttKVPnU5cUwCoFPoV9lO3j5H4bFGCk0ElGkgzWZJq+I36BtG8eXcqlyntdOooPMrSQr3Qd3chhf7bo6z+mtvXR+q3KC3dirgMAv1Tec2rDUurb2N5FXtdWr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjqw/Gsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjqw/Gsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6788D1F000C4;
	Sat, 17 Oct 2026 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260572;
	bh=vxKFIM3HDi/FA62nXD4EJrxvgMNgah2xGMeS+1uyp30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rjqw/GsbcgOD44uTDuFRw5JGkcdpVGQjxYao8JDUCzbkdEc6yEIEKEUCI9QVPvyYN
	 1kTKiaMOU18OaTrxpsZbUJ38zyP3PQZp+EHLvFmGVLmFfaW7RD4Rfb7XjiveLjWBJ7
	 d70E4xmr0wjYvXW3uXCFlFV9ZLbtOS4d8TgcErqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Chanho Park <chanho61.park@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1548/1674] scsi: ufs: exynos: Disable iocc if dma-coherent property isnt set
Date: Sat, 17 Oct 2026 18:03:40 +0200
Message-ID: <20261017160510.841224885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit f92bb7436802f8eb7ee72dc911a33c8897fde366 ]

If dma-coherent property isn't set then descriptors are non-cacheable
and the iocc shareability bits should be disabled. Without this UFS can
end up in an incompatible configuration and suffer from random cache
related stability issues.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Fixes: cc52e15397cc ("scsi: ufs: ufs-exynos: Support ExynosAuto v9 UFS")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-3-96722cc2ba1b@linaro.org
Cc: Chanho Park <chanho61.park@samsung.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 17 +++++++++++++----
 drivers/ufs/host/ufs-exynos.h |  3 ++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 14c1b855e10ad..3e3ec906cb602 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -200,8 +200,8 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
-					  ufs->shareability_reg_offset,
-					  UFS_SHARABLE, UFS_SHARABLE);
+					  ufs->iocc_offset,
+					  UFS_SHARABLE, ufs->iocc_val);
 	}
 
 	attr->tx_dif_p_nsec = 3200000;
@@ -1102,12 +1102,21 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		ufs->sysreg = NULL;
 	else {
 		if (of_property_read_u32_index(np, "samsung,sysreg", 1,
-					       &ufs->shareability_reg_offset)) {
+					       &ufs->iocc_offset)) {
 			dev_warn(dev, "can't get an offset from sysreg. Set to default value\n");
-			ufs->shareability_reg_offset = UFS_SHAREABILITY_OFFSET;
+			ufs->iocc_offset = UFS_SHAREABILITY_OFFSET;
 		}
 	}
 
+	/*
+	 * no 'dma-coherent' property means the descriptors are
+	 * non-cacheable so iocc shareability should be disabled.
+	 */
+	if (of_dma_is_coherent(dev->of_node))
+		ufs->iocc_val = UFS_SHARABLE;
+	else
+		ufs->iocc_val = 0;
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index a4bd6646d7f13..65aa04d41c3eb 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -212,7 +212,8 @@ struct exynos_ufs {
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
 	struct regmap *sysreg;
-	u32 shareability_reg_offset;
+	u32 iocc_offset;
+	u32 iocc_val;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.53.0



