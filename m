Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695428DF5A;
	Wed,  7 May 2025 19:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645049; cv=none; b=egRZNma7d2Aip4qDPl8N8NaumoC4DsxbmMyhs/UlNq1l9W7W8hhNW10wAjHfYBjpqsdPvHdbv1nhQI/n8OHIgIozPOZyciA7U02SrkihZHHIxzm9nHNppdwk6qbMYz2ek5Bjxf3MX8/i35bQbycsMeINMexVkWJEqfBijn3X2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645049; c=relaxed/simple;
	bh=5QggyPsYuO3BQBEUfqDUoTSdV7hIlXRNc7q2yrBiuaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsieehV4tUPCoCNCzYSiAFjWA6e27fEksIgWj8DypdroRjW1PDAxsjGRP5MFYrFJDq2p4ZJcRODzIXYTrUtYSSEkJJKym0hU85FCONct02ViOjsU9rI8ASeCtKOERCtaJmMzXQo6ojZyF/6nuVBtjGC4yorzoCnhb8IvNNiF5NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVE/Wya0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVE/Wya0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0ADC4CEE2;
	Wed,  7 May 2025 19:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645048;
	bh=5QggyPsYuO3BQBEUfqDUoTSdV7hIlXRNc7q2yrBiuaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVE/Wya0YMmQTqTX2Bq7FkKhEDS2+tGOnGcekfBavwRcW2CIqZ3pMuiYtXI7U5CpZ
	 QPIwe8VEhJ2ZIu8bXHCbqqwCb7XV0Mg/zyZ5ZJjulqncCwx+U01aZUc/BqVsicA+j4
	 HaPiIXDtqzLDqBb29nobX+w+rYgzjeQzu1H1ksHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Da Xue <da@libre.computer>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/129] net: mdio: mux-meson-gxl: set reversed bit when using internal phy
Date: Wed,  7 May 2025 20:40:12 +0200
Message-ID: <20250507183816.594737210@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Da Xue <da@libre.computer>

[ Upstream commit b23285e93bef729e67519a5209d5b7fde3b4af50 ]

This bit is necessary to receive packets from the internal PHY.
Without this bit set, no activity occurs on the interface.

Normally u-boot sets this bit, but if u-boot is compiled without
net support, the interface will be up but without any activity.
If bit is set once, it will work until the IP is powered down or reset.

The vendor SDK sets this bit along with the PHY_ID bits.

Signed-off-by: Da Xue <da@libre.computer>
Fixes: 9a24e1ff4326 ("net: mdio: add amlogic gxl mdio mux support")
Link: https://patch.msgid.link/20250425192009.1439508-1-da@libre.computer
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mux-meson-gxl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
index 76188575ca1fc..19153d44800a9 100644
--- a/drivers/net/mdio/mdio-mux-meson-gxl.c
+++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
@@ -17,6 +17,7 @@
 #define  REG2_LEDACT		GENMASK(23, 22)
 #define  REG2_LEDLINK		GENMASK(25, 24)
 #define  REG2_DIV4SEL		BIT(27)
+#define  REG2_REVERSED		BIT(28)
 #define  REG2_ADCBYPASS		BIT(30)
 #define  REG2_CLKINSEL		BIT(31)
 #define ETH_REG3		0x4
@@ -65,7 +66,7 @@ static void gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
 	 * The only constraint is that it must match the one in
 	 * drivers/net/phy/meson-gxl.c to properly match the PHY.
 	 */
-	writel(FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
+	writel(REG2_REVERSED | FIELD_PREP(REG2_PHYID, EPHY_GXL_ID),
 	       priv->regs + ETH_REG2);
 
 	/* Enable the internal phy */
-- 
2.39.5



