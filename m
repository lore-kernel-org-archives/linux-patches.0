Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8010D25B675;
	Tue, 25 Mar 2025 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905962; cv=none; b=oByZkmk2HfazQN6fTlfLH72djse9Hq3DyIWW4pcN+x57++Dzpgc0XyyJDLtqn6b9FhJWF46MAuuRqRb13zb8gl9rzQZtIZvsnFUMzgXcjYajWwwAC9gZc7iKsJiXFf0Hw1DsDMj6dC/8v+tiFv32s5Pz5eE3MtbS9B41npSuJIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905962; c=relaxed/simple;
	bh=kcuqyIFu/KvYZr4sno/k6Eoktg8Xvy4EuraXxYkhbLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9z5qJWKAue0UygwX5FiMFf3WIrU3DQVxS6tHp+d0i5M0anGIkB+cLwE1h30adTcOu1ErWJWFiq1MP+dzzydLeVD48e1cPtut7wvrAJcWzjo6JYo6Fu06NWvk1q2t1n28pApsKA7CAS92r4NGwfAh8l+BGzRWD1blcTunI3aj9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebFz4Aci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebFz4Aci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B407C4CEE4;
	Tue, 25 Mar 2025 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905962;
	bh=kcuqyIFu/KvYZr4sno/k6Eoktg8Xvy4EuraXxYkhbLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebFz4AcisBIOxMkNteHiytndzLUa6JEvLvDAgBVt1cbaVDf03MO4R7iD05+umZy/l
	 dYBERxQXFPuWhg74ndLvFZ+LocCbTpReqNkcLKT6sEvEpmiH0r266F5E0x3gy5vIGP
	 GY5GYiqcEEQADBhRC/PNnHhKKjEuaM1sXJmRbVkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/119] reset: mchp: sparx5: Fix for lan966x
Date: Tue, 25 Mar 2025 08:21:27 -0400
Message-ID: <20250325122149.808753981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 0e2268f88bb27ef14ac3de1bc4df29ff12bb28cb ]

With the blamed commit it seems that lan966x doesn't seem to boot
anymore when the internal CPU is used.
The reason seems to be the usage of the devm_of_iomap, if we replace
this with devm_ioremap, this seems to fix the issue as we use the same
region also for other devices.

Fixes: 0426a920d6269c ("reset: mchp: sparx5: Map cpu-syscon locally in case of LAN966x")
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Tested-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://lore.kernel.org/r/20250227105502.25125-1-horatiu.vultur@microchip.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-microchip-sparx5.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/reset/reset-microchip-sparx5.c b/drivers/reset/reset-microchip-sparx5.c
index aa5464be7053b..6d3e75b33260e 100644
--- a/drivers/reset/reset-microchip-sparx5.c
+++ b/drivers/reset/reset-microchip-sparx5.c
@@ -8,6 +8,7 @@
  */
 #include <linux/mfd/syscon.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/property.h>
@@ -72,14 +73,22 @@ static struct regmap *mchp_lan966x_syscon_to_regmap(struct device *dev,
 						    struct device_node *syscon_np)
 {
 	struct regmap_config regmap_config = mchp_lan966x_syscon_regmap_config;
-	resource_size_t size;
+	struct resource res;
 	void __iomem *base;
+	int err;
+
+	err = of_address_to_resource(syscon_np, 0, &res);
+	if (err)
+		return ERR_PTR(err);
 
-	base = devm_of_iomap(dev, syscon_np, 0, &size);
-	if (IS_ERR(base))
-		return ERR_CAST(base);
+	/* It is not possible to use devm_of_iomap because this resource is
+	 * shared with other drivers.
+	 */
+	base = devm_ioremap(dev, res.start, resource_size(&res));
+	if (!base)
+		return ERR_PTR(-ENOMEM);
 
-	regmap_config.max_register = size - 4;
+	regmap_config.max_register =  resource_size(&res) - 4;
 
 	return devm_regmap_init_mmio(dev, base, &regmap_config);
 }
-- 
2.39.5



