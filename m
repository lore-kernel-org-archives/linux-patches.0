Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEFE285063;
	Tue, 17 Jun 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178810; cv=none; b=ihSSyncEkmyjWME6cAcRU5/1Of0vaEuE7zs2fYQjrnF1eAAmovFv6GW/bZgDwfWgVFgJhS/JNTVq/CSrVZCx92bcjZ6Xi7F6rVwjxcnokvQqjg3bFbA+RlSXhBg7FvFXvmDZbDcnbK54xecBEaW9xersMcitFa7p1UnJ7Nk3TNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178810; c=relaxed/simple;
	bh=dMaLXJYFIVFDgi4W3ucJP1HwS/5DXRCP7ICN3X4Df3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDQPr/CWF/QuFTWhwy0NNHejAD4e1Af8qmN37MX0jjpCItjOhaLokqY/EObQE2z5A7QwjJ0guRxUiiE0Es1mVgAaw/rJKZX3h4oiBpME+ZAWFsZ8fnVkRIl0oBa5qq8LD9oC1Y1L/eMSnK9t0Nt0PyC9/J6VejUHlcLGdnNmDHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjSLoIj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjSLoIj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A570DC4CEE3;
	Tue, 17 Jun 2025 16:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178810;
	bh=dMaLXJYFIVFDgi4W3ucJP1HwS/5DXRCP7ICN3X4Df3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjSLoIj/7jsO+2ZLQp32gQa4G5DpmN2j+fz5JDcshdckZnqJdXJrCNybLW0RPbSLk
	 Hi+VLR39Z9J0P4eb906pXGd0GUh4wECZ8n/O5JUebs/esDzxs0Q/mXwlLcje//tVoo
	 K/vOlVaz4Ew73r0iH9G0d5qoyavybpmZNo7Vbzg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 560/780] net: stmmac: platform: guarantee uniqueness of bus_id
Date: Tue, 17 Jun 2025 17:24:28 +0200
Message-ID: <20250617152514.299775825@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit eb7fd7aa35bfcc1e1fda4ecc42ccfcb526cdc780 ]

bus_id is currently derived from the ethernetX alias. If one is missing
for the device, 0 is used. If ethernet0 points to another stmmac device
or if there are 2+ stmmac devices without an ethernet alias, then bus_id
will be 0 for all of those.

This is an issue because the bus_id is used to generate the mdio bus id
(new_bus->id in drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
stmmac_mdio_register) and this needs to be unique.

This allows to avoid needing to define ethernet aliases for devices with
multiple stmmac controllers (such as the Rockchip RK3588) for multiple
stmmac devices to probe properly.

Obviously, the bus_id isn't guaranteed to be stable across reboots if no
alias is set for the device but that is easily fixed by simply adding an
alias if this is desired.

Fixes: 25c83b5c2e82 ("dt:net:stmmac: Add support to dwmac version 3.610 and 3.710")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250527-stmmac-mdio-bus_id-v2-1-a5ca78454e3c@cherry.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index c73eff6a56b87..15205a47cafc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -430,6 +430,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	struct device_node *np = pdev->dev.of_node;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_dma_cfg *dma_cfg;
+	static int bus_id = -ENODEV;
 	int phy_mode;
 	void *ret;
 	int rc;
@@ -465,8 +466,14 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	of_property_read_u32(np, "max-speed", &plat->max_speed);
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
-	if (plat->bus_id < 0)
-		plat->bus_id = 0;
+	if (plat->bus_id < 0) {
+		if (bus_id < 0)
+			bus_id = of_alias_get_highest_id("ethernet");
+		/* No ethernet alias found, init at -1 so first bus_id is 0 */
+		if (bus_id < 0)
+			bus_id = -1;
+		plat->bus_id = ++bus_id;
+	}
 
 	/* Default to phy auto-detection */
 	plat->phy_addr = -1;
-- 
2.39.5



