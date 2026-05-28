Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1766933CE8A;
	Thu, 28 May 2026 20:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999256; cv=none; b=tf6OBcy9yheW6a6fGNnJf8CjoJ9WP804oYp9t2C5bUMVLK8DYDP4JAnGGzvCm+mUkM9BBRW0dauyVxppAx+ue+UHt96WAN5PswpzaiKhEHXexGQ6vgd3B1rBJld8psx83Zknz/VdPVZKV003Dw5wSpHHfguLF8uJh/5Z/AOOboo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999256; c=relaxed/simple;
	bh=AmcbuUNT7VcWpCmF80+j6T8AjHgSen0PAIWMt4rIWqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cy6OsEMTQh14ee6IN3DmVPfgOGFdDHLVRTm8vsXaqQmrh8MNm25VbHS74nSRJybpmAl3vV8Y+aM4wp41eTn55zEv16/5qj+fwVpWzr6RGSB0F22vr264Kw/8aROQxFsvCok2VyzACXK4HKaUPDKIMSQAHVbyLBN6LmUt8t64RZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2vnuMVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2vnuMVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBEA1F000E9;
	Thu, 28 May 2026 20:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999254;
	bh=2YAs/yxsAKZsLpSvmCsh6k5OIGBDU7O2NjEYawbBOdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2vnuMVxRrHmeHs1ph++0FLrEajWA+CYp5KKaQzEVbzAkDSr/VrgVhWdfFDsfiVyJ
	 EyXAiHV8e8fLKI9GixKQbxxy9KaNNXSdKmxpyuUgvhyliQOBTin63n90su/OHg7c2Q
	 rS4xYePsv3tVzbf8kiiXBP2/eY47i0UuHYvbYGuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <lizhi2@eswincomputing.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 434/461] net: stmmac: eswin: correct RGMII delay granularity to 20 ps
Date: Thu, 28 May 2026 21:49:23 +0200
Message-ID: <20260528194700.090298105@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Li <lizhi2@eswincomputing.com>

[ Upstream commit 6ffcef9bc1fc2ad8110777decd6d026e3cb468ce ]

The EIC7700 MAC implements programmable RGMII delay adjustment with a
granularity of 20 ps per hardware step.

The driver previously converted rx-internal-delay-ps and
tx-internal-delay-ps values using a 100 ps step size, resulting in
incorrect delay programming.

Update the conversion to use the correct 20 ps granularity so the
programmed delay matches the values described in the device tree.

Fixes: ea77dbbdbc4e ("net: stmmac: add Eswin EIC7700 glue driver")
Signed-off-by: Zhi Li <lizhi2@eswincomputing.com>
Link: https://patch.msgid.link/20260518022156.484-1-lizhi2@eswincomputing.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
index 541b279f08a17..ef60cab24533e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-eic7700.c
@@ -28,8 +28,8 @@
 
 /*
  * TX/RX Clock Delay Bit Masks:
- * - TX Delay: bits [14:8] — TX_CLK delay (unit: 0.1ns per bit)
- * - RX Delay: bits [30:24] — RX_CLK delay (unit: 0.1ns per bit)
+ * - TX Delay: bits [14:8] — TX_CLK delay (unit: 0.02ns per bit)
+ * - RX Delay: bits [30:24] — RX_CLK delay (unit: 0.02ns per bit)
  */
 #define EIC7700_ETH_TX_ADJ_DELAY	GENMASK(14, 8)
 #define EIC7700_ETH_RX_ADJ_DELAY	GENMASK(30, 24)
@@ -148,7 +148,7 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	/* Read rx-internal-delay-ps and update rx_clk delay */
 	if (!of_property_read_u32(pdev->dev.of_node,
 				  "rx-internal-delay-ps", &delay_ps)) {
-		u32 val = min(delay_ps / 100, EIC7700_MAX_DELAY_UNIT);
+		u32 val = min(delay_ps / 20, EIC7700_MAX_DELAY_UNIT);
 
 		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_RX_ADJ_DELAY;
 		dwc_priv->eth_clk_dly_param |=
@@ -161,7 +161,7 @@ static int eic7700_dwmac_probe(struct platform_device *pdev)
 	/* Read tx-internal-delay-ps and update tx_clk delay */
 	if (!of_property_read_u32(pdev->dev.of_node,
 				  "tx-internal-delay-ps", &delay_ps)) {
-		u32 val = min(delay_ps / 100, EIC7700_MAX_DELAY_UNIT);
+		u32 val = min(delay_ps / 20, EIC7700_MAX_DELAY_UNIT);
 
 		dwc_priv->eth_clk_dly_param &= ~EIC7700_ETH_TX_ADJ_DELAY;
 		dwc_priv->eth_clk_dly_param |=
-- 
2.53.0



