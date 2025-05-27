Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9D1CD0C;
	Tue, 27 May 2025 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366854; cv=none; b=oTeV60yYzVMHMNjtKHfdSt4fVNSf7GooCfCDuO/ZKhbneCZmrsdB4ZtJJCLfnygdQefe6oyfRruJx83IEJopvkrSXPN20f6jd2zeJ2ZCSpmy2HAtosSZ+62anXDKgEpFBW/gaPxK/3BYj8A59E0+EiBTWRjeFv2kyRoQXFkAxys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366854; c=relaxed/simple;
	bh=NaJY+VpaNDgW+KqF/u4jqPjZlq2qnsT+N0+DsOzDx8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mayQJ+vYtX4W6iqfS/ld5Z7CEKxCfSK5Y8fMbpVVbgo8wR9zffz6b2W8JJkypQfJBmEdTgevRFNK634fYaZfk/dCjAF187Axxcxgj112ZUaxzlKox54bhviAnklYSGk0H/fT1ePi/FhiS6wR47GSLLfdID9yX58DFdjSWUcEGe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPke+w0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPke+w0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2463BC4CEE9;
	Tue, 27 May 2025 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366854;
	bh=NaJY+VpaNDgW+KqF/u4jqPjZlq2qnsT+N0+DsOzDx8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPke+w0UD+vzj0MS005pwgdCrFkz5/O2r7KnmhBSQI1HYK8qwlB0NVrLdX5OhnWok
	 XlivNgYeiBdO2YJ+zwDTdD8gPiCBLgEpriz+AWTWCbECLFuOaJoSACcamod97N/ERN
	 TpbVBX8pKCKVEDACo6dmnjQMBOTLNPVbclhLhdGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Simon Horman <horms@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 199/783] net: stmmac: dwmac-rk: Validate GRF and peripheral GRF during probe
Date: Tue, 27 May 2025 18:19:56 +0200
Message-ID: <20250527162521.252001718@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 247e84f66a3d1946193d739fec5dc3d69833fd00 ]

All Rockchip GMAC variants typically write to GRF regs to control e.g.
interface mode, speed and MAC rx/tx delay. Newer SoCs such as RK3576 and
RK3588 use a mix of GRF and peripheral GRF regs. These syscon regmaps is
located with help of a rockchip,grf and rockchip,php-grf phandle.

However, validating the rockchip,grf and rockchip,php-grf syscon regmap
is deferred until e.g. interface mode or speed is configured, inside the
individual SoC specific operations.

Change to validate the rockchip,grf and rockchip,php-grf syscon regmap
at probe time to simplify all SoC specific operations.

This should not introduce any backward compatibility issues as all
GMAC nodes have been added together with a rockchip,grf phandle (and
rockchip,php-grf where required) in their initial commit.

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250308213720.2517944-3-jonas@kwiboo.se
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index a4dc89e23a68e..a33be23121b35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -33,6 +33,7 @@ struct rk_gmac_ops {
 	void (*set_clock_selection)(struct rk_priv_data *bsp_priv, bool input,
 				    bool enable);
 	void (*integrated_phy_powerup)(struct rk_priv_data *bsp_priv);
+	bool php_grf_required;
 	bool regs_valid;
 	u32 regs[];
 };
@@ -1254,6 +1255,7 @@ static const struct rk_gmac_ops rk3576_ops = {
 	.set_rgmii_speed = rk3576_set_gmac_speed,
 	.set_rmii_speed = rk3576_set_gmac_speed,
 	.set_clock_selection = rk3576_set_clock_selection,
+	.php_grf_required = true,
 	.regs_valid = true,
 	.regs = {
 		0x2a220000, /* gmac0 */
@@ -1401,6 +1403,7 @@ static const struct rk_gmac_ops rk3588_ops = {
 	.set_rgmii_speed = rk3588_set_gmac_speed,
 	.set_rmii_speed = rk3588_set_gmac_speed,
 	.set_clock_selection = rk3588_set_clock_selection,
+	.php_grf_required = true,
 	.regs_valid = true,
 	.regs = {
 		0xfe1b0000, /* gmac0 */
@@ -1812,8 +1815,22 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 
 	bsp_priv->grf = syscon_regmap_lookup_by_phandle(dev->of_node,
 							"rockchip,grf");
-	bsp_priv->php_grf = syscon_regmap_lookup_by_phandle(dev->of_node,
-							    "rockchip,php-grf");
+	if (IS_ERR(bsp_priv->grf)) {
+		dev_err_probe(dev, PTR_ERR(bsp_priv->grf),
+			      "failed to lookup rockchip,grf\n");
+		return ERR_CAST(bsp_priv->grf);
+	}
+
+	if (ops->php_grf_required) {
+		bsp_priv->php_grf =
+			syscon_regmap_lookup_by_phandle(dev->of_node,
+							"rockchip,php-grf");
+		if (IS_ERR(bsp_priv->php_grf)) {
+			dev_err_probe(dev, PTR_ERR(bsp_priv->php_grf),
+				      "failed to lookup rockchip,php-grf\n");
+			return ERR_CAST(bsp_priv->php_grf);
+		}
+	}
 
 	if (plat->phy_node) {
 		bsp_priv->integrated_phy = of_property_read_bool(plat->phy_node,
-- 
2.39.5



