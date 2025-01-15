Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B48248BD0;
	Wed, 15 Jan 2025 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938729; cv=none; b=erO9xLZTY14rTGpUK7SH2RJG1D/lx6szhnBHdL8MzsrvjQ+HEFZhHuoQBMw1A9VG0bYyQXceBY6IN+33vyEZ7BNnU2Km/yBvSrkvs/k6Wgi9cePC/V9CalIcVe4cIsM/qiPb1Y4iIyiUUR0okHrwjFEPlvvonv59RFi1U32z1bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938729; c=relaxed/simple;
	bh=ukEBvjKvlcdBKXcAcZtL3yaUKJ7p6Zcu/QVaw9/Vpyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulSp/rhU8qIq4THZhXUOyaqQ4x8p30U2hr/R+NH27hGaDVrDXKv8xE7yix92H6uUFO7MLqqet3hB64WvRUODM45zXABd7gsiQ1dXsLH1tZzTz4cIbcitd5PqKXaG7G394QgixtohQv2yV+REJNtpS0xtgQfOqxEvkckVTebP+4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb1PB+4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb1PB+4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795BBC4CEDF;
	Wed, 15 Jan 2025 10:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938728;
	bh=ukEBvjKvlcdBKXcAcZtL3yaUKJ7p6Zcu/QVaw9/Vpyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb1PB+4gAq29mArfZNTbgX3WELIP0PUF+dMBSlG1EnPFdGRrfb6fBosD9up5ldL+g
	 DFVqp5XYzPBcqE/ojZX5Tw8A2mlfAzc4qy6OQG1wp8JMHfvLveKmzrLYq1EtdqtNes
	 Sph4DFYWMoHetjiGM4ptKsDydD1GvGe9ml8OBi1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/129] drm/mediatek: stop selecting foreign drivers
Date: Wed, 15 Jan 2025 11:37:03 +0100
Message-ID: <20250115103556.286938027@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 924d66011f2401a4145e2e814842c5c4572e439f ]

The PHY portion of the mediatek hdmi driver was originally part of
the driver it self and later split out into drivers/phy, which a
'select' to keep the prior behavior.

However, this leads to build failures when the PHY driver cannot
be built:

WARNING: unmet direct dependencies detected for PHY_MTK_HDMI
  Depends on [n]: (ARCH_MEDIATEK || COMPILE_TEST [=y]) && COMMON_CLK [=y] && OF [=y] && REGULATOR [=n]
  Selected by [m]:
  - DRM_MEDIATEK_HDMI [=m] && HAS_IOMEM [=y] && DRM [=m] && DRM_MEDIATEK [=m]
ERROR: modpost: "devm_regulator_register" [drivers/phy/mediatek/phy-mtk-hdmi-drv.ko] undefined!
ERROR: modpost: "rdev_get_drvdata" [drivers/phy/mediatek/phy-mtk-hdmi-drv.ko] undefined!

The best option here is to just not select the phy driver and leave that
up to the defconfig. Do the same for the other PHY and memory drivers
selected here as well for consistency.

Fixes: a481bf2f0ca4 ("drm/mediatek: Separate mtk_hdmi_phy to an independent module")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241218085837.2670434-1-arnd@kernel.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/Kconfig b/drivers/gpu/drm/mediatek/Kconfig
index 76cab28e010c..d2652751d190 100644
--- a/drivers/gpu/drm/mediatek/Kconfig
+++ b/drivers/gpu/drm/mediatek/Kconfig
@@ -10,9 +10,6 @@ config DRM_MEDIATEK
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL
-	select MEMORY
-	select MTK_SMI
-	select PHY_MTK_MIPI_DSI
 	select VIDEOMODE_HELPERS
 	help
 	  Choose this option if you have a Mediatek SoCs.
@@ -23,7 +20,6 @@ config DRM_MEDIATEK
 config DRM_MEDIATEK_DP
 	tristate "DRM DPTX Support for MediaTek SoCs"
 	depends on DRM_MEDIATEK
-	select PHY_MTK_DP
 	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DP_AUX_BUS
@@ -34,6 +30,5 @@ config DRM_MEDIATEK_HDMI
 	tristate "DRM HDMI Support for Mediatek SoCs"
 	depends on DRM_MEDIATEK
 	select SND_SOC_HDMI_CODEC if SND_SOC
-	select PHY_MTK_HDMI
 	help
 	  DRM/KMS HDMI driver for Mediatek SoCs
-- 
2.39.5



