Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13A250BF3;
	Wed,  5 Mar 2025 18:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198579; cv=none; b=Hb4tqhmoRp6AHgRV8XPv+nFyUMPl7Ie5vUisHiuQGajHfc7iww3gXM4HsNp0nyPuXKRZbAG9brru5t1k6mNMt7pfwiURIhnSeZbTXikWw8DObm25HKesiqXurqWFvCZTnbRDyGKFcpMe2CgwGEIhFvgdOkgi4RhPCksDDGMsQ3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198579; c=relaxed/simple;
	bh=WTRHrNmNTRAXvK0TZBZp+n+T8N/+lodT2uaGcfSrF3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nft8eJ7najI1ueiwKE/RhSOtHHGGoBbnrFgcLYngxZMYAq/T5th1IpVcM7+GSrZ2LB4JGRO0RlXvl+NvRtcHokw6fp5GMw2GP/LdLDzCmvTBOviZ7DoqT3pG0zfbamo4UFkdbvb+uUli/2SBSixYTP++9zqBYQhVa2+FR1IWDKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkSATIvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkSATIvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CD7C4CED1;
	Wed,  5 Mar 2025 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198578;
	bh=WTRHrNmNTRAXvK0TZBZp+n+T8N/+lodT2uaGcfSrF3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkSATIvkbrQVPGrENFR1HsMbbBQ7bh486Wc+fQVOpi0QNGY8P0vPFkoAGboDh2JWe
	 3aIbgxzV5Z/VWVO1y1Zh1dYnhjoiVe5qDwMCwOZ+WUsWGnqxrtol3i7yS/byKfHywC
	 H5ErQY5OwIbV0Ul8PWNpgvgm2VhL90l5v0nha330=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/157] phy: stm32: Fix constant-value overflow assertion
Date: Wed,  5 Mar 2025 18:48:32 +0100
Message-ID: <20250305174508.361465281@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit fd75f371f3a1b04a33d2e750363d6ad76abf734e ]

Rework the workaround as the lookup tables always fits into the bitfield,
and the default values are defined by the hardware and cannot be 0:

Guard against false positive with a WARN_ON check to make the compiler
happy: The offset range is pre-checked against the sorted imp_lookup_table
values and overflow should not happen and would be caught by a warning and
return in error.

Also guard against a true positive found during the max_vswing lookup, as a
max vswing value can be 802000 or 803000 microvolt depending on the current
impedance. Therefore set the default impedence index.

Fixes: 2de679ecd724 ("phy: stm32: work around constant-value overflow assertion")
Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Link: https://lore.kernel.org/r/20250210103515.2598377-1-christian.bruel@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-combophy.c | 38 ++++++++++++++---------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/phy/st/phy-stm32-combophy.c b/drivers/phy/st/phy-stm32-combophy.c
index 49e9fa90a6819..607b4d607eb5e 100644
--- a/drivers/phy/st/phy-stm32-combophy.c
+++ b/drivers/phy/st/phy-stm32-combophy.c
@@ -111,6 +111,7 @@ static const struct clk_impedance imp_lookup[] = {
 	{ 4204000, { 511000, 609000, 706000, 802000 } },
 	{ 3999000, { 571000, 648000, 726000, 803000 } }
 };
+#define DEFAULT_IMP_INDEX 3 /* Default impedance is 50 Ohm */
 
 static int stm32_impedance_tune(struct stm32_combophy *combophy)
 {
@@ -119,10 +120,9 @@ static int stm32_impedance_tune(struct stm32_combophy *combophy)
 	u8 imp_of, vswing_of;
 	u32 max_imp = imp_lookup[0].microohm;
 	u32 min_imp = imp_lookup[imp_size - 1].microohm;
-	u32 max_vswing = imp_lookup[imp_size - 1].vswing[vswing_size - 1];
+	u32 max_vswing;
 	u32 min_vswing = imp_lookup[0].vswing[0];
 	u32 val;
-	u32 regval;
 
 	if (!of_property_read_u32(combophy->dev->of_node, "st,output-micro-ohms", &val)) {
 		if (val < min_imp || val > max_imp) {
@@ -130,45 +130,43 @@ static int stm32_impedance_tune(struct stm32_combophy *combophy)
 			return -EINVAL;
 		}
 
-		regval = 0;
-		for (imp_of = 0; imp_of < ARRAY_SIZE(imp_lookup); imp_of++) {
-			if (imp_lookup[imp_of].microohm <= val) {
-				regval = FIELD_PREP(STM32MP25_PCIEPRG_IMPCTRL_OHM, imp_of);
+		for (imp_of = 0; imp_of < ARRAY_SIZE(imp_lookup); imp_of++)
+			if (imp_lookup[imp_of].microohm <= val)
 				break;
-			}
-		}
+
+		if (WARN_ON(imp_of == ARRAY_SIZE(imp_lookup)))
+			return -EINVAL;
 
 		dev_dbg(combophy->dev, "Set %u micro-ohms output impedance\n",
 			imp_lookup[imp_of].microohm);
 
 		regmap_update_bits(combophy->regmap, SYSCFG_PCIEPRGCR,
 				   STM32MP25_PCIEPRG_IMPCTRL_OHM,
-				   regval);
-	} else {
-		regmap_read(combophy->regmap, SYSCFG_PCIEPRGCR, &val);
-		imp_of = FIELD_GET(STM32MP25_PCIEPRG_IMPCTRL_OHM, val);
-	}
+				   FIELD_PREP(STM32MP25_PCIEPRG_IMPCTRL_OHM, imp_of));
+	} else
+		imp_of = DEFAULT_IMP_INDEX;
 
 	if (!of_property_read_u32(combophy->dev->of_node, "st,output-vswing-microvolt", &val)) {
+		max_vswing = imp_lookup[imp_of].vswing[vswing_size - 1];
+
 		if (val < min_vswing || val > max_vswing) {
 			dev_err(combophy->dev, "Invalid value %u for output vswing\n", val);
 			return -EINVAL;
 		}
 
-		regval = 0;
-		for (vswing_of = 0; vswing_of < ARRAY_SIZE(imp_lookup[imp_of].vswing); vswing_of++) {
-			if (imp_lookup[imp_of].vswing[vswing_of] >= val) {
-				regval = FIELD_PREP(STM32MP25_PCIEPRG_IMPCTRL_VSWING, vswing_of);
+		for (vswing_of = 0; vswing_of < ARRAY_SIZE(imp_lookup[imp_of].vswing); vswing_of++)
+			if (imp_lookup[imp_of].vswing[vswing_of] >= val)
 				break;
-			}
-		}
+
+		if (WARN_ON(vswing_of == ARRAY_SIZE(imp_lookup[imp_of].vswing)))
+			return -EINVAL;
 
 		dev_dbg(combophy->dev, "Set %u microvolt swing\n",
 			 imp_lookup[imp_of].vswing[vswing_of]);
 
 		regmap_update_bits(combophy->regmap, SYSCFG_PCIEPRGCR,
 				   STM32MP25_PCIEPRG_IMPCTRL_VSWING,
-				   regval);
+				   FIELD_PREP(STM32MP25_PCIEPRG_IMPCTRL_VSWING, vswing_of));
 	}
 
 	return 0;
-- 
2.39.5



