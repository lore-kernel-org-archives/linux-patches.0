Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C6E248BA6;
	Wed, 15 Jan 2025 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937710; cv=none; b=S9tbYJuCGgNliRIKoiTqKujx8oTW/gZt9DvoxlrLqd8L/scERRhhXwPk9Al6+dd5GU9lCH0St1i7mfYOU4tZaaPjtIxdERaAx2CCH+iIhovs//4qrTU0fy07q+dfNzX2OfOLdpgZ4WrqsFzaDmvh8GQOKpA2YW7lzh/FCCbMlAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937710; c=relaxed/simple;
	bh=KjECM/RB1HMHVWWQEBDuiXjfFfYKIB+VVVcJuDqMAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZRi29gZ33X4rlREPMi7KKqLAc+ir/F8BIp4zUBc2kCoByYBQf8MAv1cA9oSeeAX04fftAXXAWo/4hh06xZ5y5NMe/osy4AKJMzBGMExAntRQX4VYcSXukVZ5+PL6Ozx7ULvv5C2uVK0gI+DkevQjBD+sNR2fW+3DwWnXQEilLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0/o2KWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0/o2KWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC28C4CEE2;
	Wed, 15 Jan 2025 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937710;
	bh=KjECM/RB1HMHVWWQEBDuiXjfFfYKIB+VVVcJuDqMAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0/o2KWxJ9MQtDpkuFM1QsZoBrY7bHyfLsNyY131Rv6NMdw+LIRgW2krli2o7wX+6
	 SFmU18FW+VZ1/ULnA6QBbOl1ATLn5bMXzsUEfxvhoazYhwsVqB4PUMFTVuFQfAwR2z
	 OwW7VwbRdySWZQ7hZua0dBgKnt1EiUHpppuuvU8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/92] drm/mediatek: stop selecting foreign drivers
Date: Wed, 15 Jan 2025 11:36:46 +0100
Message-ID: <20250115103548.651549088@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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
index d1eededee943..d663869bfce1 100644
--- a/drivers/gpu/drm/mediatek/Kconfig
+++ b/drivers/gpu/drm/mediatek/Kconfig
@@ -11,9 +11,6 @@ config DRM_MEDIATEK
 	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL
-	select MEMORY
-	select MTK_SMI
-	select PHY_MTK_MIPI_DSI
 	select VIDEOMODE_HELPERS
 	help
 	  Choose this option if you have a Mediatek SoCs.
@@ -24,7 +21,6 @@ config DRM_MEDIATEK
 config DRM_MEDIATEK_DP
 	tristate "DRM DPTX Support for MediaTek SoCs"
 	depends on DRM_MEDIATEK
-	select PHY_MTK_DP
 	select DRM_DISPLAY_HELPER
 	select DRM_DISPLAY_DP_HELPER
 	select DRM_DP_AUX_BUS
@@ -35,6 +31,5 @@ config DRM_MEDIATEK_HDMI
 	tristate "DRM HDMI Support for Mediatek SoCs"
 	depends on DRM_MEDIATEK
 	select SND_SOC_HDMI_CODEC if SND_SOC
-	select PHY_MTK_HDMI
 	help
 	  DRM/KMS HDMI driver for Mediatek SoCs
-- 
2.39.5



