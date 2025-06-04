Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F061CAA4;
	Wed,  4 Jun 2025 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998314; cv=none; b=M/tsVoDnzBwA+H2tpkZiQ7AWIdbFctuNtnbfzY7emMTGfNQzMzXHu0qsHj7+yF7gNl0/ANqqOluqYrDJYeVsFkeRwLK+kfdhJ9i1q3gCSoy/7Bs1ma4YZlB83wQdVt2wvXnrA5siOvolfnSbuD1I2udcmvorRB054p082f/BT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998314; c=relaxed/simple;
	bh=KQRPWiVIirFM5HlqIdlbktPx3zZ+EkbTpPF8djX4G4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X4BY/fNDD6+KJj6zEjR7AZusU3+HrgtuI4Uwcwf5Zym9aM931mfUF1Pe9scoptgOhSN2U4LXxDPeNPYHwweQoF2AckdMIp+dzmPpeqbiu6WnU9rDCs3Xua9A3oX5uEM+iDGTn4DF+r7+hssQLTDlS6SQLB/E29Uoy5KCX8MAge0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1+zSFVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1+zSFVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D886AC4CEF1;
	Wed,  4 Jun 2025 00:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998313;
	bh=KQRPWiVIirFM5HlqIdlbktPx3zZ+EkbTpPF8djX4G4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1+zSFVBNfUIC9vLfCMo8uqHv2WsFrb2wvRUwcgKSUsIEvZ+/Y4xEIJQ1kjnVslUc
	 4R4CoRqEG6uOf6njrxf9YkJfBui2tp/hf766naypq1FwskHmawSOAjShiz1cn4mvOW
	 W7QqP8MHyjVW6p+HqpFNBIEjN31PjhfFUxUXslop0J3yAIbuigQ9wJdw90a9NkbVev
	 hD0hHNe3GrgAEgszqIUCAgA2X1toNI0F1XZOBxqiY/YnoBX5PHbhVxLogMrpTEiarg
	 ob5RbAyQFQi+mf6d8Z/jofMUXS/RBHOc+mtJoQzbiikBk9Rt5NbtxCpBQR4LaKqGGU
	 gCHe61RIZXTQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frank Wunderlich <frank-w@public-files.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	daniel@makrotopia.org,
	dqfext@gmail.com,
	SkyLake.Huang@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.15 029/118] net: phy: mediatek: do not require syscon compatible for pio property
Date: Tue,  3 Jun 2025 20:49:20 -0400
Message-Id: <20250604005049.4147522-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

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

**YES** This commit should be backported to stable kernel trees. ##
Analysis ### Core Issue Being Fixed The commit addresses a **device tree
compatibility problem** in the MediaTek MT7988 PHY driver. The original
code used `syscon_regmap_lookup_by_phandle()` which **requires** the
target device node to have a "syscon" compatible string. This created an
artificial requirement that forced users to modify their device trees
even when the pinctrl driver already provided the necessary regmap. ###
Code Changes Analysis The change is minimal but significant: ```c //
OLD: Forces syscon compatible requirement regmap =
syscon_regmap_lookup_by_phandle(np, "mediatek,pio"); // NEW: Works with
any regmap provider pio_np = of_parse_phandle(np, "mediatek,pio", 0);
regmap = device_node_to_regmap(pio_np); of_node_put(pio_np); ``` **Key
differences:** - `syscon_regmap_lookup_by_phandle()` requires "syscon"
compatible - `device_node_to_regmap()` works with any device that has
registered a regmap - Proper error handling maintained with
`of_node_put()` ### Why This Should Be Backported **1. Fixes Real User
Issues:** - MT7988 hardware is actively deployed (BananaPi R4,
networking devices) - Users cannot use PHY LED functionality without
modifying device trees - This affects real hardware in production, not
just development boards **2. Low Risk Change:** - Only 9 insertions, 1
deletion - No functional behavior change - same register access, same
error paths - Uses well-established kernel APIs - **Backward
compatible:** Still works with DTs that have syscon compatible -
**Forward compatible:** Also works with DTs that don't have syscon
compatible **3. High Impact Fix:** - Removes artificial device tree
constraints - Enables legitimate hardware configurations without DT
hacks - Prevents fragmentation of MT7988 ecosystem across kernel
versions - LED functionality is important for networking hardware
visibility **4. Fits Stable Criteria:** - Fixes important functionality
for users - Does not introduce new features - No architectural changes -
Confined to one driver/subsystem - Minimal regression risk ###
Comparison to Similar Commits Looking at the historical examples
provided, this commit is similar to "clk: mediatek: Get regmap without
syscon compatible check" which also moved from `syscon_node_to_regmap()`
to `device_node_to_regmap()` for the same compatibility reasons. The
pattern of removing unnecessary syscon requirements is well-established
and safe. ### Real-World Impact Without this fix, users with legitimate
device trees (where pinctrl doesn't have syscon compatible) cannot use
MT7988 PHY LED functionality. This forces them to either: 1. Patch their
device trees (not always possible in production) 2. Use older kernel
versions 3. Lose LED functionality entirely The commit solves a
**compatibility regression** rather than adding new functionality,
making it an ideal stable backport candidate.

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

