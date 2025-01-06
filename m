Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB286347;
	Mon,  6 Jan 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177379; cv=none; b=ouFb6VkxN9egae6GD9kL7k2ADFe8DC6g3pJHBYAKoxv4drKCSfiluJDOXF1sh78+1ksWpxP5hFGjs/05GSndDwb9b3geSKh7jsdvmffW5a/H7GLFXQ2oeRLf3a3Pm0DWK3XDPdEa/yQDO+96obF5pw+/dTGMgZKII98sFuDkCzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177379; c=relaxed/simple;
	bh=mabODHF5bsDObjbA0GFOx5iaQ6yB+kZQPVHTRj0CUtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtww3RI0NDsgEOEfvLnLApNf6K8Zy/rdHag1t3quAhEVTIsMVBn4+uYwcF3j+Fkdhz8InYFxEnDvLwRU+oi4+pEH8jJhOZZGy5H6c5a+YX2lyojqY92WB6dFM1h1DqlakJ9636PNyWvWNJDjuoqh+NKPoj395HAQIWXpHwRNHYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHlDEJee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHlDEJee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC02CC4CED2;
	Mon,  6 Jan 2025 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177379;
	bh=mabODHF5bsDObjbA0GFOx5iaQ6yB+kZQPVHTRj0CUtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHlDEJeeyEe9kKo8+yuttnL+RWIVBJx52itXLp5f6r0rux4VyN+Zd99WLxhhFQfcO
	 s7qVEKbCCHuilSS3kbOEcLYsKcI2b5WE47d5Q/GlFHpY5BMOCdaul7UMdWyJsYDjHp
	 D6uie/naIVPGObpO6pp8GPCB4dMmPIDYRt+xVx0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/222] net: dsa: microchip: Fix LAN937X set_ageing_time function
Date: Mon,  6 Jan 2025 16:15:48 +0100
Message-ID: <20250106151156.217153441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit bb9869043438af5b94230f94fb4c39206525d758 ]

The aging count is not a simple 20-bit value but comprises a 3-bit
multiplier and a 20-bit second time.  The code tries to use the
original multiplier which is 4 as the second count is still 300 seconds
by default.

As the 20-bit number is now too large for practical use there is an option
to interpret it as microseconds instead of seconds.

Fixes: 2c119d9982b1 ("net: dsa: microchip: add the support for set_ageing_time")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241218020224.70590-3-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/lan937x_main.c | 62 ++++++++++++++++++++++--
 drivers/net/dsa/microchip/lan937x_reg.h  |  9 ++--
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index b479a628b1ae..dde37e61faa3 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Microchip LAN937X switch driver main logic
- * Copyright (C) 2019-2022 Microchip Technology Inc.
+ * Copyright (C) 2019-2024 Microchip Technology Inc.
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -257,10 +257,66 @@ int lan937x_change_mtu(struct ksz_device *dev, int port, int new_mtu)
 
 int lan937x_set_ageing_time(struct ksz_device *dev, unsigned int msecs)
 {
-	u32 secs = msecs / 1000;
-	u32 value;
+	u8 data, mult, value8;
+	bool in_msec = false;
+	u32 max_val, value;
+	u32 secs = msecs;
 	int ret;
 
+#define MAX_TIMER_VAL	((1 << 20) - 1)
+
+	/* The aging timer comprises a 3-bit multiplier and a 20-bit second
+	 * value.  Either of them cannot be zero.  The maximum timer is then
+	 * 7 * 1048575 = 7340025 seconds.  As this value is too large for
+	 * practical use it can be interpreted as microseconds, making the
+	 * maximum timer 7340 seconds with finer control.  This allows for
+	 * maximum 122 minutes compared to 29 minutes in KSZ9477 switch.
+	 */
+	if (msecs % 1000)
+		in_msec = true;
+	else
+		secs /= 1000;
+	if (!secs)
+		secs = 1;
+
+	/* Return error if too large. */
+	else if (secs > 7 * MAX_TIMER_VAL)
+		return -EINVAL;
+
+	/* Configure how to interpret the number value. */
+	ret = ksz_rmw8(dev, REG_SW_LUE_CTRL_2, SW_AGE_CNT_IN_MICROSEC,
+		       in_msec ? SW_AGE_CNT_IN_MICROSEC : 0);
+	if (ret < 0)
+		return ret;
+
+	ret = ksz_read8(dev, REG_SW_LUE_CTRL_0, &value8);
+	if (ret < 0)
+		return ret;
+
+	/* Check whether there is need to update the multiplier. */
+	mult = FIELD_GET(SW_AGE_CNT_M, value8);
+	max_val = MAX_TIMER_VAL;
+	if (mult > 0) {
+		/* Try to use the same multiplier already in the register as
+		 * the hardware default uses multiplier 4 and 75 seconds for
+		 * 300 seconds.
+		 */
+		max_val = DIV_ROUND_UP(secs, mult);
+		if (max_val > MAX_TIMER_VAL || max_val * mult != secs)
+			max_val = MAX_TIMER_VAL;
+	}
+
+	data = DIV_ROUND_UP(secs, max_val);
+	if (mult != data) {
+		value8 &= ~SW_AGE_CNT_M;
+		value8 |= FIELD_PREP(SW_AGE_CNT_M, data);
+		ret = ksz_write8(dev, REG_SW_LUE_CTRL_0, value8);
+		if (ret < 0)
+			return ret;
+	}
+
+	secs = DIV_ROUND_UP(secs, data);
+
 	value = FIELD_GET(SW_AGE_PERIOD_7_0_M, secs);
 
 	ret = ksz_write8(dev, REG_SW_AGE_PERIOD__1, value);
diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
index 45b606b6429f..b3e536e7c686 100644
--- a/drivers/net/dsa/microchip/lan937x_reg.h
+++ b/drivers/net/dsa/microchip/lan937x_reg.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Microchip LAN937X switch register definitions
- * Copyright (C) 2019-2021 Microchip Technology Inc.
+ * Copyright (C) 2019-2024 Microchip Technology Inc.
  */
 #ifndef __LAN937X_REG_H
 #define __LAN937X_REG_H
@@ -48,8 +48,7 @@
 
 #define SW_VLAN_ENABLE			BIT(7)
 #define SW_DROP_INVALID_VID		BIT(6)
-#define SW_AGE_CNT_M			0x7
-#define SW_AGE_CNT_S			3
+#define SW_AGE_CNT_M			GENMASK(5, 3)
 #define SW_RESV_MCAST_ENABLE		BIT(2)
 
 #define REG_SW_LUE_CTRL_1		0x0311
@@ -62,6 +61,10 @@
 #define SW_FAST_AGING			BIT(1)
 #define SW_LINK_AUTO_AGING		BIT(0)
 
+#define REG_SW_LUE_CTRL_2		0x0312
+
+#define SW_AGE_CNT_IN_MICROSEC		BIT(7)
+
 #define REG_SW_AGE_PERIOD__1		0x0313
 #define SW_AGE_PERIOD_7_0_M		GENMASK(7, 0)
 
-- 
2.39.5



