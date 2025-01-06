Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE48200A3;
	Mon,  6 Jan 2025 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176747; cv=none; b=TRAwXIbogfpeoNRAAWGiETbP1jV6aQ83kM6MrTaHqs6HC12iS4TLo1piZSN+a8SqJF+j4S/bBV14xwIFDTEmVNkM7cs9qFsACIVPnotCjUhYv3l9UGDjy6NyN8Ubr4c3w4oIPuFediyQtuPPEan4Ofq4fpI+2vAMpNZ8JgEiWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176747; c=relaxed/simple;
	bh=xklYoeTmbwkLhRx96PStFby+A74ba5x2vYxzN/cfkuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQ1/hGaEKpudD+Ilr9CCbUy1gZjClZuYbW0vb9qqvpOIV0mBJpdoICs69Z0Zj9c8uWCzub36/OERxGeN7VxD7tcKRX/8UCm6Yc2aH8AaszkDbe/aOk4W26eG/mOh7f9fCM/or2s0eIn5r7t4EwScb37jNCs1kxbpwk3fygfXgZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNljUalB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNljUalB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52917C4CED6;
	Mon,  6 Jan 2025 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176746;
	bh=xklYoeTmbwkLhRx96PStFby+A74ba5x2vYxzN/cfkuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNljUalBNPbgEPZu1lEPzH/3WHDGWihW+WJZVGzopAkcAh1GFyrsAYRRdXpcs0m8g
	 nPPj1nwcmaoz9ToUxSNfF1329YygDyuXGnbjT6vYLhjD/5m35NC7SzepntubfpGa80
	 uhXsxHufM/BuYtRE2oPH0XKqL/5s5spk50RnIQ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/81] net: dsa: microchip: Fix KSZ9477 set_ageing_time function
Date: Mon,  6 Jan 2025 16:15:50 +0100
Message-ID: <20250106151130.123570236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 262bfba8ab820641c8cfbbf03b86d6c00242c078 ]

The aging count is not a simple 11-bit value but comprises a 3-bit
multiplier and an 8-bit second count.  The code tries to use the
original multiplier which is 4 as the second count is still 300 seconds
by default.

Fixes: 2c119d9982b1 ("net: dsa: microchip: add the support for set_ageing_time")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241218020224.70590-2-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c     | 47 +++++++++++++++++++------
 drivers/net/dsa/microchip/ksz9477_reg.h |  4 +--
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index e9fa92a83322..b854ee425fcd 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -2,7 +2,7 @@
 /*
  * Microchip KSZ9477 switch driver main logic
  *
- * Copyright (C) 2017-2019 Microchip Technology Inc.
+ * Copyright (C) 2017-2024 Microchip Technology Inc.
  */
 
 #include <linux/kernel.h>
@@ -964,26 +964,51 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 int ksz9477_set_ageing_time(struct ksz_device *dev, unsigned int msecs)
 {
 	u32 secs = msecs / 1000;
-	u8 value;
-	u8 data;
+	u8 data, mult, value;
+	u32 max_val;
 	int ret;
 
-	value = FIELD_GET(SW_AGE_PERIOD_7_0_M, secs);
+#define MAX_TIMER_VAL	((1 << 8) - 1)
 
-	ret = ksz_write8(dev, REG_SW_LUE_CTRL_3, value);
-	if (ret < 0)
-		return ret;
+	/* The aging timer comprises a 3-bit multiplier and an 8-bit second
+	 * value.  Either of them cannot be zero.  The maximum timer is then
+	 * 7 * 255 = 1785 seconds.
+	 */
+	if (!secs)
+		secs = 1;
 
-	data = FIELD_GET(SW_AGE_PERIOD_10_8_M, secs);
+	/* Return error if too large. */
+	else if (secs > 7 * MAX_TIMER_VAL)
+		return -EINVAL;
 
 	ret = ksz_read8(dev, REG_SW_LUE_CTRL_0, &value);
 	if (ret < 0)
 		return ret;
 
-	value &= ~SW_AGE_CNT_M;
-	value |= FIELD_PREP(SW_AGE_CNT_M, data);
+	/* Check whether there is need to update the multiplier. */
+	mult = FIELD_GET(SW_AGE_CNT_M, value);
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
+		value &= ~SW_AGE_CNT_M;
+		value |= FIELD_PREP(SW_AGE_CNT_M, data);
+		ret = ksz_write8(dev, REG_SW_LUE_CTRL_0, value);
+		if (ret < 0)
+			return ret;
+	}
 
-	return ksz_write8(dev, REG_SW_LUE_CTRL_0, value);
+	value = DIV_ROUND_UP(secs, data);
+	return ksz_write8(dev, REG_SW_LUE_CTRL_3, value);
 }
 
 void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 04086e9ab0a0..ffb9484018ed 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -2,7 +2,7 @@
 /*
  * Microchip KSZ9477 register definitions
  *
- * Copyright (C) 2017-2018 Microchip Technology Inc.
+ * Copyright (C) 2017-2024 Microchip Technology Inc.
  */
 
 #ifndef __KSZ9477_REGS_H
@@ -190,8 +190,6 @@
 #define SW_VLAN_ENABLE			BIT(7)
 #define SW_DROP_INVALID_VID		BIT(6)
 #define SW_AGE_CNT_M			GENMASK(5, 3)
-#define SW_AGE_CNT_S			3
-#define SW_AGE_PERIOD_10_8_M		GENMASK(10, 8)
 #define SW_RESV_MCAST_ENABLE		BIT(2)
 #define SW_HASH_OPTION_M		0x03
 #define SW_HASH_OPTION_CRC		1
-- 
2.39.5



