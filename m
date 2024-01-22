Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8424745F0;
	Tue, 23 Jan 2024 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975504; cv=none; b=PoYFU75PuzUbwv/ahMCVPT3las1fGCGIh/0+RyIDLNm4ItGAab83ifAr1KikoVlTnqwfBw0zxd5ZIZJdzVy3ghgbPNC/KmEBmdKEQWpQp2b8L9RHOAy5DL9Ch3VHpYcOH7lPs2DAe+NDTd43aFtM9ARAcQ8OuDQblVFEsynW6aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975504; c=relaxed/simple;
	bh=gW3UN6johKmXicP2sl4jdifwUGXiQDW+YG17Egz4jkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhfhTaVwnCFPn0gymb4tqY6E7ZHOWX2G9RZfarDmi8kgJ4xwDsZzpcMYn653MRENsSHYiomFNhhRB8YUxcWakPXDxV4v3zB9MYlgNeBtTlv+tCe0CcUJ5iP7RqtG6r35Gp1H5tXnfUuaIe9EJ/CCXvwQe/rNfVnTU2oAFUGrGPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TebvrXHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TebvrXHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6DEC433C7;
	Tue, 23 Jan 2024 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975504;
	bh=gW3UN6johKmXicP2sl4jdifwUGXiQDW+YG17Egz4jkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TebvrXHvsNCW2X8qSDI7m8Y1fZC4yRGlWQxiGVhL69HcQSRdvaNhsYWj552ebDP4y
	 bHH1qud5q5Nu9R1VF9Yz1VnyqzAqsJExMCGkgwjYlSlIYMYM9eoEy/xsQ+qWdJClqo
	 t+l2+znzGG9jHM5Pk6l4gzxRBUG5QdGqPMUrBym0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 439/583] mfd: cs42l43: Correct SoundWire port list
Date: Mon, 22 Jan 2024 15:58:10 -0800
Message-ID: <20240122235825.408140064@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 47b1b03dc56ebc302620ce43e967aa8f33516f6f ]

Two ports are missing from the port list, and the wrong port is set
to 4 channels. Also the attempt to list them by function is rather
misguided, there is nothing in the hardware that fixes a particular
port to one function. Factor out the port properties to an actual
struct, fixing the missing ports and correcting the port set to 4
channels.

Fixes: ace6d1448138 ("mfd: cs42l43: Add support for cs42l43 core driver")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231130115712.669180-1-ckeepax@opensource.cirrus.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/cs42l43-sdw.c | 74 +++++++++++++++------------------------
 1 file changed, 28 insertions(+), 46 deletions(-)

diff --git a/drivers/mfd/cs42l43-sdw.c b/drivers/mfd/cs42l43-sdw.c
index 7392b3d2e6b9..4be4df9dd8cf 100644
--- a/drivers/mfd/cs42l43-sdw.c
+++ b/drivers/mfd/cs42l43-sdw.c
@@ -17,13 +17,12 @@
 
 #include "cs42l43.h"
 
-enum cs42l43_sdw_ports {
-	CS42L43_DMIC_DEC_ASP_PORT = 1,
-	CS42L43_SPK_TX_PORT,
-	CS42L43_SPDIF_HP_PORT,
-	CS42L43_SPK_RX_PORT,
-	CS42L43_ASP_PORT,
-};
+#define CS42L43_SDW_PORT(port, chans) { \
+	.num = port, \
+	.max_ch = chans, \
+	.type = SDW_DPN_FULL, \
+	.max_word = 24, \
+}
 
 static const struct regmap_config cs42l43_sdw_regmap = {
 	.reg_bits		= 32,
@@ -42,65 +41,48 @@ static const struct regmap_config cs42l43_sdw_regmap = {
 	.num_reg_defaults	= ARRAY_SIZE(cs42l43_reg_default),
 };
 
+static const struct sdw_dpn_prop cs42l43_src_port_props[] = {
+	CS42L43_SDW_PORT(1, 4),
+	CS42L43_SDW_PORT(2, 2),
+	CS42L43_SDW_PORT(3, 2),
+	CS42L43_SDW_PORT(4, 2),
+};
+
+static const struct sdw_dpn_prop cs42l43_sink_port_props[] = {
+	CS42L43_SDW_PORT(5, 2),
+	CS42L43_SDW_PORT(6, 2),
+	CS42L43_SDW_PORT(7, 2),
+};
+
 static int cs42l43_read_prop(struct sdw_slave *sdw)
 {
 	struct sdw_slave_prop *prop = &sdw->prop;
 	struct device *dev = &sdw->dev;
-	struct sdw_dpn_prop *dpn;
-	unsigned long addr;
-	int nval;
 	int i;
-	u32 bit;
 
 	prop->use_domain_irq = true;
 	prop->paging_support = true;
 	prop->wake_capable = true;
-	prop->source_ports = BIT(CS42L43_DMIC_DEC_ASP_PORT) | BIT(CS42L43_SPK_TX_PORT);
-	prop->sink_ports = BIT(CS42L43_SPDIF_HP_PORT) |
-			   BIT(CS42L43_SPK_RX_PORT) | BIT(CS42L43_ASP_PORT);
 	prop->quirks = SDW_SLAVE_QUIRKS_INVALID_INITIAL_PARITY;
 	prop->scp_int1_mask = SDW_SCP_INT1_BUS_CLASH | SDW_SCP_INT1_PARITY |
 			      SDW_SCP_INT1_IMPL_DEF;
 
-	nval = hweight32(prop->source_ports);
-	prop->src_dpn_prop = devm_kcalloc(dev, nval, sizeof(*prop->src_dpn_prop),
-					  GFP_KERNEL);
+	for (i = 0; i < ARRAY_SIZE(cs42l43_src_port_props); i++)
+		prop->source_ports |= BIT(cs42l43_src_port_props[i].num);
+
+	prop->src_dpn_prop = devm_kmemdup(dev, cs42l43_src_port_props,
+					  sizeof(cs42l43_src_port_props), GFP_KERNEL);
 	if (!prop->src_dpn_prop)
 		return -ENOMEM;
 
-	i = 0;
-	dpn = prop->src_dpn_prop;
-	addr = prop->source_ports;
-	for_each_set_bit(bit, &addr, 32) {
-		dpn[i].num = bit;
-		dpn[i].max_ch = 2;
-		dpn[i].type = SDW_DPN_FULL;
-		dpn[i].max_word = 24;
-		i++;
-	}
-	/*
-	 * All ports are 2 channels max, except the first one,
-	 * CS42L43_DMIC_DEC_ASP_PORT.
-	 */
-	dpn[CS42L43_DMIC_DEC_ASP_PORT].max_ch = 4;
+	for (i = 0; i < ARRAY_SIZE(cs42l43_sink_port_props); i++)
+		prop->sink_ports |= BIT(cs42l43_sink_port_props[i].num);
 
-	nval = hweight32(prop->sink_ports);
-	prop->sink_dpn_prop = devm_kcalloc(dev, nval, sizeof(*prop->sink_dpn_prop),
-					   GFP_KERNEL);
+	prop->sink_dpn_prop = devm_kmemdup(dev, cs42l43_sink_port_props,
+					   sizeof(cs42l43_sink_port_props), GFP_KERNEL);
 	if (!prop->sink_dpn_prop)
 		return -ENOMEM;
 
-	i = 0;
-	dpn = prop->sink_dpn_prop;
-	addr = prop->sink_ports;
-	for_each_set_bit(bit, &addr, 32) {
-		dpn[i].num = bit;
-		dpn[i].max_ch = 2;
-		dpn[i].type = SDW_DPN_FULL;
-		dpn[i].max_word = 24;
-		i++;
-	}
-
 	return 0;
 }
 
-- 
2.43.0



