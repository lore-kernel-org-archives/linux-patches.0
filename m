Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4847F34A76F;
	Tue, 16 Dec 2025 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886372; cv=none; b=lfGPAk4PG2yqSJOcsFpl2red6e7Q/8u4x6BWdD9njLQbhqiTHTJBX9obfdsZ9mSgELSl7hUQVdRiGax+3oPCYONpfSSFAAElusvuKvi6y8wUM861zBbXAT5SGlq8070uJBfeWPawQyVVkGchSvVlgSiFzVb+ymHln1V9joSnCH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886372; c=relaxed/simple;
	bh=yZ/7Naoq9oiPKYEPijKPR03xwOg8eTz9OzKxSXij3E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0hlrM74MMfj6nkRMIt8G8C8MasCgAzckMAyfqRVg8krbceZbb8vUOJbvaLus/tXIeribPrCRnBUmxqeYdNuSfo+lz9IVqlWu43zvkQKBBEdZYtA465RsESzl0mCc1Adn3iyjUMDxwIhShgZf7ZbgZd436SB0PPr0flsB+bmzdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cgi455pB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cgi455pB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3580C4CEF5;
	Tue, 16 Dec 2025 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886372;
	bh=yZ/7Naoq9oiPKYEPijKPR03xwOg8eTz9OzKxSXij3E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cgi455pBeVZUew9bTclE+ncJrwCowEyhU2mDFaYdF0K1z2Ra8nJakJB8MM68mg/xM
	 uPdgrJ6YuMDuB9x+mAJOs6gx7swOwigfthiucwSynpY0aCTJP6Qfy1BpgvIX9Iczrr
	 zilmkMWSPW0xEcy50KnJNgXfzXe2+878uPHCb/rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 416/507] net: dsa: b53: move ARL entry functions into ops struct
Date: Tue, 16 Dec 2025 12:14:17 +0100
Message-ID: <20251216111400.532922677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit a7e73339ad46ade76d29fb6cc7d7854222608c26 ]

Now that the differences in ARL entry formats are neatly contained into
functions per chip family, wrap them into an ops struct and add wrapper
functions to access them.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-7-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 67 ++++++++++++++++++++++----------
 drivers/net/dsa/b53/b53_priv.h   | 30 ++++++++++++++
 2 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 190eb11644917..50ed9b7157197 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1890,10 +1890,7 @@ static int b53_arl_read(struct b53_device *dev, const u8 *mac,
 
 	/* Read the bins */
 	for (i = 0; i < dev->num_arl_bins; i++) {
-		if (is5325(dev) || is5365(dev))
-			b53_arl_read_entry_25(dev, ent, i);
-		else
-			b53_arl_read_entry_95(dev, ent, i);
+		b53_arl_read_entry(dev, ent, i);
 
 		if (!ent->is_valid) {
 			set_bit(i, free_bins);
@@ -1979,10 +1976,7 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 	ent.is_static = true;
 	ent.is_age = false;
 	memcpy(ent.mac, addr, ETH_ALEN);
-	if (is5325(dev) || is5365(dev))
-		b53_arl_write_entry_25(dev, &ent, idx);
-	else
-		b53_arl_write_entry_95(dev, &ent, idx);
+	b53_arl_write_entry(dev, &ent, idx);
 
 	return b53_arl_rw_op(dev, 0);
 }
@@ -2093,17 +2087,6 @@ static void b53_arl_search_read_95(struct b53_device *dev, u8 idx,
 	b53_arl_to_entry(ent, mac_vid, fwd_entry);
 }
 
-static void b53_arl_search_rd(struct b53_device *dev, u8 idx,
-			      struct b53_arl_entry *ent)
-{
-	if (is5325(dev))
-		b53_arl_search_read_25(dev, idx, ent);
-	else if (is5365(dev))
-		b53_arl_search_read_65(dev, idx, ent);
-	else
-		b53_arl_search_read_95(dev, idx, ent);
-}
-
 static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 			dsa_fdb_dump_cb_t *cb, void *data)
 {
@@ -2137,13 +2120,13 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 		if (ret)
 			break;
 
-		b53_arl_search_rd(priv, 0, &results[0]);
+		b53_arl_search_read(priv, 0, &results[0]);
 		ret = b53_fdb_copy(port, &results[0], cb, data);
 		if (ret)
 			break;
 
 		if (results_per_hit == 2) {
-			b53_arl_search_rd(priv, 1, &results[1]);
+			b53_arl_search_read(priv, 1, &results[1]);
 			ret = b53_fdb_copy(port, &results[1], cb, data);
 			if (ret)
 				break;
@@ -2669,6 +2652,24 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_change_mtu	= b53_change_mtu,
 };
 
+static const struct b53_arl_ops b53_arl_ops_25 = {
+	.arl_read_entry = b53_arl_read_entry_25,
+	.arl_write_entry = b53_arl_write_entry_25,
+	.arl_search_read = b53_arl_search_read_25,
+};
+
+static const struct b53_arl_ops b53_arl_ops_65 = {
+	.arl_read_entry = b53_arl_read_entry_25,
+	.arl_write_entry = b53_arl_write_entry_25,
+	.arl_search_read = b53_arl_search_read_65,
+};
+
+static const struct b53_arl_ops b53_arl_ops_95 = {
+	.arl_read_entry = b53_arl_read_entry_95,
+	.arl_write_entry = b53_arl_write_entry_95,
+	.arl_search_read = b53_arl_search_read_95,
+};
+
 struct b53_chip_data {
 	u32 chip_id;
 	const char *dev_name;
@@ -2682,6 +2683,7 @@ struct b53_chip_data {
 	u8 duplex_reg;
 	u8 jumbo_pm_reg;
 	u8 jumbo_size_reg;
+	const struct b53_arl_ops *arl_ops;
 };
 
 #define B53_VTA_REGS	\
@@ -2701,6 +2703,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_buckets = 1024,
 		.imp_port = 5,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
+		.arl_ops = &b53_arl_ops_25,
 	},
 	{
 		.chip_id = BCM5365_DEVICE_ID,
@@ -2711,6 +2714,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_buckets = 1024,
 		.imp_port = 5,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
+		.arl_ops = &b53_arl_ops_65,
 	},
 	{
 		.chip_id = BCM5389_DEVICE_ID,
@@ -2724,6 +2728,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM5395_DEVICE_ID,
@@ -2737,6 +2742,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM5397_DEVICE_ID,
@@ -2750,6 +2756,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM5398_DEVICE_ID,
@@ -2763,6 +2770,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53101_DEVICE_ID,
@@ -2776,6 +2784,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53115_DEVICE_ID,
@@ -2789,6 +2798,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53125_DEVICE_ID,
@@ -2802,6 +2812,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53128_DEVICE_ID,
@@ -2815,6 +2826,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM63XX_DEVICE_ID,
@@ -2828,6 +2840,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK_63XX,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE_63XX,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53010_DEVICE_ID,
@@ -2841,6 +2854,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53011_DEVICE_ID,
@@ -2854,6 +2868,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53012_DEVICE_ID,
@@ -2867,6 +2882,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53018_DEVICE_ID,
@@ -2880,6 +2896,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53019_DEVICE_ID,
@@ -2893,6 +2910,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM58XX_DEVICE_ID,
@@ -2906,6 +2924,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM583XX_DEVICE_ID,
@@ -2919,6 +2938,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	/* Starfighter 2 */
 	{
@@ -2933,6 +2953,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM7445_DEVICE_ID,
@@ -2946,6 +2967,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM7278_DEVICE_ID,
@@ -2959,6 +2981,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 	{
 		.chip_id = BCM53134_DEVICE_ID,
@@ -2973,6 +2996,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
+		.arl_ops = &b53_arl_ops_95,
 	},
 };
 
@@ -3001,6 +3025,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
 			dev->num_arl_buckets = chip->arl_buckets;
+			dev->arl_ops = chip->arl_ops;
 			break;
 		}
 	}
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 2f44b3b6a0d9f..c6e2d5e41c758 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -58,6 +58,17 @@ struct b53_io_ops {
 				bool link_up);
 };
 
+struct b53_arl_entry;
+
+struct b53_arl_ops {
+	void (*arl_read_entry)(struct b53_device *dev,
+			       struct b53_arl_entry *ent, u8 idx);
+	void (*arl_write_entry)(struct b53_device *dev,
+				const struct b53_arl_entry *ent, u8 idx);
+	void (*arl_search_read)(struct b53_device *dev, u8 idx,
+				struct b53_arl_entry *ent);
+};
+
 #define B53_INVALID_LANE	0xff
 
 enum {
@@ -127,6 +138,7 @@ struct b53_device {
 	struct mutex stats_mutex;
 	struct mutex arl_mutex;
 	const struct b53_io_ops *ops;
+	const struct b53_arl_ops *arl_ops;
 
 	/* chip specific data */
 	u32 chip_id;
@@ -371,6 +383,24 @@ static inline void b53_arl_from_entry_25(u64 *mac_vid,
 		*mac_vid |= ARLTBL_AGE_25;
 }
 
+static inline void b53_arl_read_entry(struct b53_device *dev,
+				      struct b53_arl_entry *ent, u8 idx)
+{
+	dev->arl_ops->arl_read_entry(dev, ent, idx);
+}
+
+static inline void b53_arl_write_entry(struct b53_device *dev,
+				       const struct b53_arl_entry *ent, u8 idx)
+{
+	dev->arl_ops->arl_write_entry(dev, ent, idx);
+}
+
+static inline void b53_arl_search_read(struct b53_device *dev, u8 idx,
+				       struct b53_arl_entry *ent)
+{
+	dev->arl_ops->arl_search_read(dev, idx, ent);
+}
+
 #ifdef CONFIG_BCM47XX
 
 #include <linux/bcm47xx_nvram.h>
-- 
2.51.0



