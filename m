Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11C82C60;
	Tue, 29 Apr 2025 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945865; cv=none; b=iA5asuivjaAdF1YoDUeC0ruced/i2ACQYz/th2bdp08FPxkxjZGbtY6nvrSbOGNjQPwRFH2GE5wx9U8CsXoId1aMFhX9kbE2pmmv4UrWW1BLcv/vbyHkb3rVfIXPLFi5D12FYkxagJ+zvuuh6TtQ1MuEV24ch2cxqCnCR9B1X28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945865; c=relaxed/simple;
	bh=fTZz1P2L/VUeNKjq2YK29/KRmxN0opi43Z2670M8jdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su+sgoouTL/NkJDVvzidOJysEeO0KYsnQeLttswAxCoEDHNUIVXeS/4lNef260NdXDuyz0JRwplu6pM5YDB+9/Lzywk44gSSFdFUI/U2W9oSZbHf6XgqiJ9+NGO8b5dPzKEpUZkaE0ftljdm1vvz+djtGC7aB8QH2i8LYqD12VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtt+M54X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtt+M54X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D78C4CEE3;
	Tue, 29 Apr 2025 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945865;
	bh=fTZz1P2L/VUeNKjq2YK29/KRmxN0opi43Z2670M8jdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtt+M54X0hNxFjj5WKTL7drV0JvFMeggRRAcqfAo7uQ38o04G3Zh32KMYI30+NnW+
	 wp0m5vEFQiVfPlT0arjgVpKVYEV2nYn7ly6fMW9nqwtL4xwe6MlQv12Vca1JYjgW/u
	 nUyc+F/HTuRr7kCY6DwknsX5cZb9t2lLosJWqok4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 075/311] net: phy: Add helper for getting tx amplitude gain
Date: Tue, 29 Apr 2025 18:38:32 +0200
Message-ID: <20250429161124.118086902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

From: Dimitri Fedrau <dimitri.fedrau@liebherr.com>

[ Upstream commit 961ee5aeea048aa292f28d61f3a96a48554e91af ]

Add helper which returns the tx amplitude gain defined in device tree.
Modifying it can be necessary to compensate losses on the PCB and
connector, so the voltages measured on the RJ45 pins are conforming.

Signed-off-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250214-dp83822-tx-swing-v5-2-02ca72620599@liebherr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 607b310ada5e ("net: dp83822: Fix OF_MDIO config check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 53 ++++++++++++++++++++++++------------
 include/linux/phy.h          |  4 +++
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 92161af788afd..2a01887c5617e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3123,19 +3123,12 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 EXPORT_SYMBOL(phy_get_pause);
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
-static int phy_get_int_delay_property(struct device *dev, const char *name)
+static int phy_get_u32_property(struct device *dev, const char *name, u32 *val)
 {
-	s32 int_delay;
-	int ret;
-
-	ret = device_property_read_u32(dev, name, &int_delay);
-	if (ret)
-		return ret;
-
-	return int_delay;
+	return device_property_read_u32(dev, name, val);
 }
 #else
-static int phy_get_int_delay_property(struct device *dev, const char *name)
+static int phy_get_u32_property(struct device *dev, const char *name, u32 *val)
 {
 	return -EINVAL;
 }
@@ -3160,12 +3153,12 @@ static int phy_get_int_delay_property(struct device *dev, const char *name)
 s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 			   const int *delay_values, int size, bool is_rx)
 {
-	s32 delay;
-	int i;
+	int i, ret;
+	u32 delay;
 
 	if (is_rx) {
-		delay = phy_get_int_delay_property(dev, "rx-internal-delay-ps");
-		if (delay < 0 && size == 0) {
+		ret = phy_get_u32_property(dev, "rx-internal-delay-ps", &delay);
+		if (ret < 0 && size == 0) {
 			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 			    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
 				return 1;
@@ -3174,8 +3167,8 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 		}
 
 	} else {
-		delay = phy_get_int_delay_property(dev, "tx-internal-delay-ps");
-		if (delay < 0 && size == 0) {
+		ret = phy_get_u32_property(dev, "tx-internal-delay-ps", &delay);
+		if (ret < 0 && size == 0) {
 			if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 			    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				return 1;
@@ -3184,8 +3177,8 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 		}
 	}
 
-	if (delay < 0)
-		return delay;
+	if (ret < 0)
+		return ret;
 
 	if (size == 0)
 		return delay;
@@ -3220,6 +3213,30 @@ s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 }
 EXPORT_SYMBOL(phy_get_internal_delay);
 
+/**
+ * phy_get_tx_amplitude_gain - stores tx amplitude gain in @val
+ * @phydev: phy_device struct
+ * @dev: pointer to the devices device struct
+ * @linkmode: linkmode for which the tx amplitude gain should be retrieved
+ * @val: tx amplitude gain
+ *
+ * Returns: 0 on success, < 0 on failure
+ */
+int phy_get_tx_amplitude_gain(struct phy_device *phydev, struct device *dev,
+			      enum ethtool_link_mode_bit_indices linkmode,
+			      u32 *val)
+{
+	switch (linkmode) {
+	case ETHTOOL_LINK_MODE_100baseT_Full_BIT:
+		return phy_get_u32_property(dev,
+					    "tx-amplitude-100base-tx-percent",
+					    val);
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(phy_get_tx_amplitude_gain);
+
 static int phy_led_set_brightness(struct led_classdev *led_cdev,
 				  enum led_brightness value)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 19f076a71f946..7c9da26145d30 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -2114,6 +2114,10 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause);
 s32 phy_get_internal_delay(struct phy_device *phydev, struct device *dev,
 			   const int *delay_values, int size, bool is_rx);
 
+int phy_get_tx_amplitude_gain(struct phy_device *phydev, struct device *dev,
+			      enum ethtool_link_mode_bit_indices linkmode,
+			      u32 *val);
+
 void phy_resolve_pause(unsigned long *local_adv, unsigned long *partner_adv,
 		       bool *tx_pause, bool *rx_pause);
 
-- 
2.39.5



