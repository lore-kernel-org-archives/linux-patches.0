Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF5C1FE468;
	Tue, 29 Apr 2025 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947681; cv=none; b=ET6R1QHbj8xynvw0dLYimu4o5gRu9USirFKMK8c8IhAy/ZQssdBqK/aUx7xB8qosfeaJegqhBVe/QhNQVYgHfPi4djP3vZqeZ6zfwb9vWYNBqyQZYK7CJRWW+0ciUPhvl//pWQKrTBKAwjZa0f5dc2xYXyCotbAnkCp+rLZxyK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947681; c=relaxed/simple;
	bh=zTARzdI1Ikc0B2a3YeAEgCKl/huQw9DBJgMHWhoN7dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4gnbXS/tZJ70xifAB2JC2WHE3rgtTEorpEHDK5PXe/YLh+36+JqNoFtEZwd6+ZgMCodVCXGPgnyURdE7/FE72j1T8oay8T75Od+9j68XnZRVxhlWVNZ7vptsYCtvPmzqBhuEwNg/JKQn+5Y/aVFpUoChxl52lLbGobNEHjRyMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSi9oCya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSi9oCya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E219DC4CEE9;
	Tue, 29 Apr 2025 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947681;
	bh=zTARzdI1Ikc0B2a3YeAEgCKl/huQw9DBJgMHWhoN7dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSi9oCyalY9P7ChtVSFuRmG8iPUQBhkYi97XdCnMEw1djceuWoezBO4H9FfsULlex
	 wTyhOq1A+kPeQTpAaSjY3s4G35AgKcTvT3D40rKda4/XcLZ0O8f3VhIc/1tqn8VYPN
	 CaUODT6tU3T6o8wD587UWyDJF2XsGrQ95HXvCcfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Chanho Park <chanho61.park@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/280] scsi: ufs: exynos: Disable iocc if dma-coherent property isnt set
Date: Tue, 29 Apr 2025 18:39:45 +0200
Message-ID: <20250429161116.922860311@linuxfoundation.org>
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
index 453f1dee103c8..fd1ebb4fcd96c 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -210,8 +210,8 @@ static int exynos_ufs_shareability(struct exynos_ufs *ufs)
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
-					  ufs->shareability_reg_offset,
-					  ufs->iocc_mask, ufs->iocc_mask);
+					  ufs->iocc_offset,
+					  ufs->iocc_mask, ufs->iocc_val);
 	}
 
 	attr->tx_dif_p_nsec = 3200000;
@@ -1147,13 +1147,22 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
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
 
 	ufs->iocc_mask = ufs->drv_data->iocc_mask;
+	/*
+	 * no 'dma-coherent' property means the descriptors are
+	 * non-cacheable so iocc shareability should be disabled.
+	 */
+	if (of_dma_is_coherent(dev->of_node))
+		ufs->iocc_val = ufs->iocc_mask;
+	else
+		ufs->iocc_val = 0;
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index ad49d9cdd5c12..d0b3df221503c 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -231,8 +231,9 @@ struct exynos_ufs {
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
 	struct regmap *sysreg;
-	u32 shareability_reg_offset;
+	u32 iocc_offset;
 	u32 iocc_mask;
+	u32 iocc_val;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.39.5



