Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E46934886B;
	Fri, 21 Nov 2025 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733115; cv=none; b=hyatKKwcxrRA8T21zYDvIPYPwwDO8cfXYsavwNLXjQYfL4nuWbNLOxvEbOgMNcgRUxK0c7YJR8Lz/yxCg1tZo3coF7DOuzmZeykgOHnGx4zROl1MPadEg17iu4YkHzVaq/3Jo35IRuk1TasiPt5UdYL7v+7jRPhTX66u5LTvz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733115; c=relaxed/simple;
	bh=eKLQMauX5LlTfIDbrJglZIS8+Bfry/VhsnEEsobx220=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4GJhf1vAJd7MMjf4jK95mEYIchCFzbdVtdRzaM762RyTupqid66lxROiHnrg9UC1EgU8S5guVwI/nHm1TkGfT5imiTTZQ0FWOHhjI5+WbkTNcswOcZc2z2hwk48mXUj1V/OWJHdewdvz1gD8nBhbSXR0f4UL1KxiZDPCeGPOCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmzvO8Ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmzvO8Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6F7C4CEF1;
	Fri, 21 Nov 2025 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733115;
	bh=eKLQMauX5LlTfIDbrJglZIS8+Bfry/VhsnEEsobx220=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmzvO8Ps45r1E0KI/GMxKuOhvGWtxC81UCPpPiBHbjCKEhBVozmDBP8qC2HqpIVoa
	 gLrHhC/46+LkSnvHQ0YB7oEWQ8yEHcg4mwOMvfAEpdEeLNzY2JF1nYCHc0zshG6T5W
	 +pHE8KMfO4sJCvI3Pmqa2qYCSN+0GF04bCgo8h8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	=?UTF-8?q?=C5=81ukasz=20Majewski?= <lukma@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/529] net: dsa: microchip: Fix reserved multicast address table programming
Date: Fri, 21 Nov 2025 14:10:56 +0100
Message-ID: <20251121130243.731157832@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit 96baf482ca1f69f0da9d10a5bd8422c87ea9039e ]

KSZ9477/KSZ9897 and LAN937X families of switches use a reserved multicast
address table for some specific forwarding with some multicast addresses,
like the one used in STP.  The hardware assumes the host port is the last
port in KSZ9897 family and port 5 in LAN937X family.  Most of the time
this assumption is correct but not in other cases like KSZ9477.
Originally the function just setups the first entry, but the others still
need update, especially for one common multicast address that is used by
PTP operation.

LAN937x also uses different register bits when accessing the reserved
table.

Fixes: 457c182af597 ("net: dsa: microchip: generic access to ksz9477 static and reserved table")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Tested-by: Łukasz Majewski <lukma@nabladev.com>
Link: https://patch.msgid.link/20251105033741.6455-1-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477.c     | 98 +++++++++++++++++++++----
 drivers/net/dsa/microchip/ksz9477_reg.h |  3 +-
 drivers/net/dsa/microchip/ksz_common.c  |  4 +
 drivers/net/dsa/microchip/ksz_common.h  |  2 +
 4 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 59134d117846d..a11f2c1aabaca 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1087,9 +1087,15 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
 	}
 }
 
+#define RESV_MCAST_CNT	8
+
+static u8 reserved_mcast_map[RESV_MCAST_CNT] = { 0, 1, 3, 16, 32, 33, 2, 17 };
+
 int ksz9477_enable_stp_addr(struct ksz_device *dev)
 {
+	u8 i, ports, update;
 	const u32 *masks;
+	bool override;
 	u32 data;
 	int ret;
 
@@ -1098,23 +1104,87 @@ int ksz9477_enable_stp_addr(struct ksz_device *dev)
 	/* Enable Reserved multicast table */
 	ksz_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
 
-	/* Set the Override bit for forwarding BPDU packet to CPU */
-	ret = ksz_write32(dev, REG_SW_ALU_VAL_B,
-			  ALU_V_OVERRIDE | BIT(dev->cpu_port));
-	if (ret < 0)
-		return ret;
+	/* The reserved multicast address table has 8 entries.  Each entry has
+	 * a default value of which port to forward.  It is assumed the host
+	 * port is the last port in most of the switches, but that is not the
+	 * case for KSZ9477 or maybe KSZ9897.  For LAN937X family the default
+	 * port is port 5, the first RGMII port.  It is okay for LAN9370, a
+	 * 5-port switch, but may not be correct for the other 8-port
+	 * versions.  It is necessary to update the whole table to forward to
+	 * the right ports.
+	 * Furthermore PTP messages can use a reserved multicast address and
+	 * the host will not receive them if this table is not correct.
+	 */
+	for (i = 0; i < RESV_MCAST_CNT; i++) {
+		data = reserved_mcast_map[i] <<
+			dev->info->shifts[ALU_STAT_INDEX];
+		data |= ALU_STAT_START |
+			masks[ALU_STAT_DIRECT] |
+			masks[ALU_RESV_MCAST_ADDR] |
+			masks[ALU_STAT_READ];
+		ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+		if (ret < 0)
+			return ret;
 
-	data = ALU_STAT_START | ALU_RESV_MCAST_ADDR | masks[ALU_STAT_WRITE];
+		/* wait to be finished */
+		ret = ksz9477_wait_alu_sta_ready(dev);
+		if (ret < 0)
+			return ret;
 
-	ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
-	if (ret < 0)
-		return ret;
+		ret = ksz_read32(dev, REG_SW_ALU_VAL_B, &data);
+		if (ret < 0)
+			return ret;
 
-	/* wait to be finished */
-	ret = ksz9477_wait_alu_sta_ready(dev);
-	if (ret < 0) {
-		dev_err(dev->dev, "Failed to update Reserved Multicast table\n");
-		return ret;
+		override = false;
+		ports = data & dev->port_mask;
+		switch (i) {
+		case 0:
+		case 6:
+			/* Change the host port. */
+			update = BIT(dev->cpu_port);
+			override = true;
+			break;
+		case 2:
+			/* Change the host port. */
+			update = BIT(dev->cpu_port);
+			break;
+		case 4:
+		case 5:
+		case 7:
+			/* Skip the host port. */
+			update = dev->port_mask & ~BIT(dev->cpu_port);
+			break;
+		default:
+			update = ports;
+			break;
+		}
+		if (update != ports || override) {
+			data &= ~dev->port_mask;
+			data |= update;
+			/* Set Override bit to receive frame even when port is
+			 * closed.
+			 */
+			if (override)
+				data |= ALU_V_OVERRIDE;
+			ret = ksz_write32(dev, REG_SW_ALU_VAL_B, data);
+			if (ret < 0)
+				return ret;
+
+			data = reserved_mcast_map[i] <<
+			       dev->info->shifts[ALU_STAT_INDEX];
+			data |= ALU_STAT_START |
+				masks[ALU_STAT_DIRECT] |
+				masks[ALU_RESV_MCAST_ADDR] |
+				masks[ALU_STAT_WRITE];
+			ret = ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
+			if (ret < 0)
+				return ret;
+
+			/* wait to be finished */
+			ret = ksz9477_wait_alu_sta_ready(dev);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index d0886ed984c57..c3ad8ce707f85 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -2,7 +2,7 @@
 /*
  * Microchip KSZ9477 register definitions
  *
- * Copyright (C) 2017-2024 Microchip Technology Inc.
+ * Copyright (C) 2017-2025 Microchip Technology Inc.
  */
 
 #ifndef __KSZ9477_REGS_H
@@ -422,7 +422,6 @@
 
 #define ALU_RESV_MCAST_INDEX_M		(BIT(6) - 1)
 #define ALU_STAT_START			BIT(7)
-#define ALU_RESV_MCAST_ADDR		BIT(1)
 
 #define REG_SW_ALU_VAL_A		0x0420
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 997c225dfba4d..cff83a8fb7d28 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -437,6 +437,8 @@ static const u16 ksz9477_regs[] = {
 static const u32 ksz9477_masks[] = {
 	[ALU_STAT_WRITE]		= 0,
 	[ALU_STAT_READ]			= 1,
+	[ALU_STAT_DIRECT]		= 0,
+	[ALU_RESV_MCAST_ADDR]		= BIT(1),
 	[P_MII_TX_FLOW_CTRL]		= BIT(5),
 	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
@@ -464,6 +466,8 @@ static const u8 ksz9477_xmii_ctrl1[] = {
 static const u32 lan937x_masks[] = {
 	[ALU_STAT_WRITE]		= 1,
 	[ALU_STAT_READ]			= 2,
+	[ALU_STAT_DIRECT]		= BIT(3),
+	[ALU_RESV_MCAST_ADDR]		= BIT(2),
 	[P_MII_TX_FLOW_CTRL]		= BIT(5),
 	[P_MII_RX_FLOW_CTRL]		= BIT(3),
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a4de58847deab..0e51f2277381d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -255,6 +255,8 @@ enum ksz_masks {
 	DYNAMIC_MAC_TABLE_TIMESTAMP,
 	ALU_STAT_WRITE,
 	ALU_STAT_READ,
+	ALU_STAT_DIRECT,
+	ALU_RESV_MCAST_ADDR,
 	P_MII_TX_FLOW_CTRL,
 	P_MII_RX_FLOW_CTRL,
 };
-- 
2.51.0



