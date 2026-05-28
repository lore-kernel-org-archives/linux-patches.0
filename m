Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E833CE8A;
	Thu, 28 May 2026 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999258; cv=none; b=maWVcs81QHs+0FYjBr9xLGjDjlz9XoBTECSigX3wbEjYkjK3fEC4LI/Wg+ar2OP8IK7cBqBqg1Z4PmateOg6bbcbvIdhfarvjnEDuZt/xtSX+PSPLvtYoDD7Cmu7i5EJ3ManxIHxqogqSCEBZIWAOQhZlKJkJ6y++WhiLhvPtMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999258; c=relaxed/simple;
	bh=yIlldnTs+frcePnnivpesY6/iEflLVR8FB9OadSLRys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8ypyTN+aXwpoIB5ESJOH/13mZDTZUDPMD57TtO1gICQiLMN0zP+VeBDnEVgkxvhP9CmxdYySG38nwKq7ke4N5t8/oNSFpAsEgIpqKSOPUshYFxDGpkPdx2w+/f9Tc4xMxg6wxUinVDxs8y8ltd+oHVNqvwT/kuwhTKkEJXlPgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X312L/wI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X312L/wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6011F00A3D;
	Thu, 28 May 2026 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999257;
	bh=aq3rSWbrnQ7cFl2rbSj02uZ0uyDwcH/KbaqrErzmm9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X312L/wI6MjkbMM6GxFeRvJbVfNIBvkbxeiQgd0TFiaO1Mu6ckpA6w1QJxqmTN6sx
	 OE7eTvzgJCeOmaxdw0OqzzEXCnRM1R4RXS4rNHQ8MaZvq+o57vQTshLRlIJBwCSJiT
	 A2amkIrbpIYR43K4wSUxj+Uj/yn9od+bWM/zYITY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <lizhi2@eswincomputing.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 435/461] net: stmmac: eswin: validate RGMII delay values
Date: Thu, 28 May 2026 21:49:24 +0200
Message-ID: <20260528194700.121324677@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Li <lizhi2@eswincomputing.com>

[ Upstream commit c2e152f7ce3208b9333d212d41a87637ec1dd170 ]

Validate rx-internal-delay-ps and tx-internal-delay-ps against the
hardware capabilities of the EIC7700 MAC.

The programmable RGMII delay supports 20 ps steps and a maximum value of
2540 ps. The driver previously accepted arbitrary values and silently
truncated unsupported settings when converting them to hardware units.

As a result, invalid device tree values could lead to unexpected delay
programming and incorrect RGMII timing.

Reject delay values that are not multiples of 20 ps or exceed the
supported hardware range.

Fixes: ea77dbbdbc4e ("net: stmmac: add Eswin EIC7700 glue driver")
Signed-off-by: Zhi Li <lizhi2@eswincomputing.com>
Link: https://patch.msgid.link/20260518022214.507-1-lizhi2@eswincomputing.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-eic7700.c   | 29 ++++++++++++++++---
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
index ef60cab24533e..4ac979d874d6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
@@ -34,7 +34,10 @@
 #define EIC7700_ETH_TX_ADJ_DELAY	GENMASK(14, 8)
 #define EIC7700_ETH_RX_ADJ_DELAY	GENMASK(30, 24)
 
-#define EIC7700_MAX_DELAY_UNIT 0x7F
+#define EIC7700_MAX_DELAY_STEPS		0x7F
+#define EIC7700_DELAY_STEP_PS		20
+#define EIC7700_MAX_DELAY_PS	\
+	(EIC7700_MAX_DELAY_STEPS * EIC7700_DELAY_STEP_PS)
 
 static const char * const eic7700_clk_names[] = {
 	"tx", "axi", "cfg",
@@ -128,7 +131,7 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	struct plat_stmmacenet_data *plat_dat;
 	struct stmmac_resources stmmac_res;
 	struct eic7700_qos_priv *dwc_priv;
-	u32 delay_ps;
+	u32 delay_ps, val;
 	int i, ret;
 
 	ret = stmmac_get_platform_resources(pdev, &stmmac_res);
@@ -148,7 +151,16 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	/* Read rx-internal-delay-ps and update rx_clk delay */
 	if (!of_property_read_u32(pdev->dev.of_node,
 				  "rx-internal-delay-ps", &delay_ps)) {
-		u32 val = min(delay_ps / 20, EIC7700_MAX_DELAY_UNIT);
+		if (delay_ps % EIC7700_DELAY_STEP_PS)
+			return dev_err_probe(&pdev->dev, -EINVAL,
+				"rx delay must be multiple of %dps\n",
+				EIC7700_DELAY_STEP_PS);
+
+		if (delay_ps > EIC7700_MAX_DELAY_PS)
+			return dev_err_probe(&pdev->dev, -EINVAL,
+				"rx delay out of range\n");
+
+		val = delay_ps / EIC7700_DELAY_STEP_PS;
 
 		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_RX_ADJ_DELAY;
 		dwc_priv->eth_clk_dly_param |=
@@ -161,7 +173,16 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	/* Read tx-internal-delay-ps and update tx_clk delay */
 	if (!of_property_read_u32(pdev->dev.of_node,
 				  "tx-internal-delay-ps", &delay_ps)) {
-		u32 val = min(delay_ps / 20, EIC7700_MAX_DELAY_UNIT);
+		if (delay_ps % EIC7700_DELAY_STEP_PS)
+			return dev_err_probe(&pdev->dev, -EINVAL,
+				"tx delay must be multiple of %dps\n",
+				EIC7700_DELAY_STEP_PS);
+
+		if (delay_ps > EIC7700_MAX_DELAY_PS)
+			return dev_err_probe(&pdev->dev, -EINVAL,
+				"tx delay out of range\n");
+
+		val = delay_ps / EIC7700_DELAY_STEP_PS;
 
 		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_TX_ADJ_DELAY;
 		dwc_priv->eth_clk_dly_param |=
-- 
2.53.0



