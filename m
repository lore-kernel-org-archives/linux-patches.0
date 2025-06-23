Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1612C9D;
	Mon, 23 Jun 2025 21:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713629; cv=none; b=E+BaQWFCPERJ6B+7bHy440N9IkIGuCNNtavXcUpy3lJjScdspjeffw9wsqnAHhvorAlRaSjh7kMXkhV+bOU9RV8va08LhRwqbDmwLl+4KtZhkpHoRUwlRp5Tx1Y6s2209NFHrY1cvsqXSSJbfe5n/JGEkP61BZiNW7ciZbZCo+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713629; c=relaxed/simple;
	bh=zF10Zy/D/o3I3iB1ttk8HZR4fomUZlkWIAxGf1KVcvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO6vRj3IoTN3iptKcxAn8hUZTnleVgaA2KV1Uv379bb+dBP5txXKOw9ol6CkbwzqFeGKS8as3OScGtXS6tfM22mzXYP2LrQ+F1NyC4Jq4kS998hEV9pQ6Kymle4lLIMOuTq2DMa/eZUCJu7lt7PHXReSu7pEr4jIi8YMmAo5w/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8jDTO+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8jDTO+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786B9C4CEEA;
	Mon, 23 Jun 2025 21:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713628;
	bh=zF10Zy/D/o3I3iB1ttk8HZR4fomUZlkWIAxGf1KVcvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8jDTO+glmmEmmmf1MbU7KkBA+0BUlsHWckqLTxSN6dHCbL54BYdUyl6ekjlfxzcx
	 QgOrLz1F535DZhkVPjgIIT8qVTjsRkUppIPy4rIH6/FJkuccxvD3lsjltoHKI5WKnW
	 eFkfcjJnJLFqJQDdHZ45tWdXh9iJtJggbWQr2bzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 338/592] net: phy: mediatek: do not require syscon compatible for pio property
Date: Mon, 23 Jun 2025 15:04:56 +0200
Message-ID: <20250623130708.492975048@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 15d7b3dfafa98270eade6c77d2336790dde0a40d ]

Current implementation requires syscon compatible for pio property
which is used for driving the switch leds on mt7988.

Replace syscon_regmap_lookup_by_phandle with of_parse_phandle and
device_node_to_regmap to get the regmap already assigned by pinctrl
driver.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://patch.msgid.link/20250510174933.154589-1-linux@fw-web.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mediatek/mtk-ge-soc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mediatek/mtk-ge-soc.c b/drivers/net/phy/mediatek/mtk-ge-soc.c
index 175cf5239bba8..21975ef946d5b 100644
--- a/drivers/net/phy/mediatek/mtk-ge-soc.c
+++ b/drivers/net/phy/mediatek/mtk-ge-soc.c
@@ -7,6 +7,7 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/phy.h>
 #include <linux/regmap.h>
+#include <linux/of.h>
 
 #include "../phylib.h"
 #include "mtk.h"
@@ -1319,6 +1320,7 @@ static int mt7988_phy_probe_shared(struct phy_device *phydev)
 {
 	struct device_node *np = dev_of_node(&phydev->mdio.bus->dev);
 	struct mtk_socphy_shared *shared = phy_package_get_priv(phydev);
+	struct device_node *pio_np;
 	struct regmap *regmap;
 	u32 reg;
 	int ret;
@@ -1336,7 +1338,13 @@ static int mt7988_phy_probe_shared(struct phy_device *phydev)
 	 * The 4 bits in TPBANK0 are kept as package shared data and are used to
 	 * set LED polarity for each of the LED0.
 	 */
-	regmap = syscon_regmap_lookup_by_phandle(np, "mediatek,pio");
+	pio_np = of_parse_phandle(np, "mediatek,pio", 0);
+	if (!pio_np)
+		return -ENODEV;
+
+	regmap = device_node_to_regmap(pio_np);
+	of_node_put(pio_np);
+
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-- 
2.39.5



