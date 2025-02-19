Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA201C175A;
	Wed, 19 Feb 2025 08:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954981; cv=none; b=plZiSLsoeuB8pbhBTPk4S7VFNn08yOgud4U/n0LBLJFt1SOmQfMRLnW4wTBevWS+jYkbNRY2xNjtNuXB25nGIbt8vg6U/DikNqYqp0/a2gfzf5h0laFi2uEplfWBxmBe5UAwY64QDp4KFuvNQAECmhkapBBJsGB+lGPQVLCzAJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954981; c=relaxed/simple;
	bh=6GRMO0/5fHoVycWfD0rDIBd5sCYi8c/inSBwJ6/paBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRh65HNGfVf8BauLlqzYSY2HSqdqk4hVKoeL2U++HeFzZkxme/Keay1iKHZjUbZyplIlXf+DdkBLDxBMlJsIWQfxhiT7OPXb7dPV/YicN1hg6P1DpraHh75yQT7ydIX5U2sUe+JkovCUk/DInkzwfm4nA2cE8LlEr+V84PRHSZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGucPefL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGucPefL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED01C4CED1;
	Wed, 19 Feb 2025 08:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954980;
	bh=6GRMO0/5fHoVycWfD0rDIBd5sCYi8c/inSBwJ6/paBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGucPefLKquWS7f40M8Ekvkuml3oyEKalIpQ3oXteT7kZrbGmnrvc9mNCpM58awjq
	 YOwzrxnSZacYSPLVpDWAXvlvWF4BreVJhv7EMnow4VXPdA32VXni1Yj/OgA3I7t/JY
	 Iuwk+hCVj3aGVlYuIlLwFqRlSntWLB63ZEFpqcdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/230] media: i2c: ds90ub913: Add error handling to ub913_hw_init()
Date: Wed, 19 Feb 2025 09:26:22 +0100
Message-ID: <20250219082604.255154918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit acd8f58d7a3bce0fbd3263961cd09555c00464ba ]

Add error handling to ub913_hw_init() using a new helper function,
ub913_update_bits().

Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Closes: https://lore.kernel.org/all/Zv40EQSR__JDN_0M@kekkonen.localdomain/
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ds90ub913.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ds90ub913.c b/drivers/media/i2c/ds90ub913.c
index b5375d7366299..7670d6c82d923 100644
--- a/drivers/media/i2c/ds90ub913.c
+++ b/drivers/media/i2c/ds90ub913.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2023 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
  */
 
+#include <linux/bitfield.h>
 #include <linux/clk-provider.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
@@ -146,6 +147,19 @@ static int ub913_write(const struct ub913_data *priv, u8 reg, u8 val)
 	return ret;
 }
 
+static int ub913_update_bits(const struct ub913_data *priv, u8 reg, u8 mask,
+			     u8 val)
+{
+	int ret;
+
+	ret = regmap_update_bits(priv->regmap, reg, mask, val);
+	if (ret < 0)
+		dev_err(&priv->client->dev,
+			"Cannot update register 0x%02x %d!\n", reg, ret);
+
+	return ret;
+}
+
 /*
  * GPIO chip
  */
@@ -733,10 +747,13 @@ static int ub913_hw_init(struct ub913_data *priv)
 	if (ret)
 		return dev_err_probe(dev, ret, "i2c master init failed\n");
 
-	ub913_read(priv, UB913_REG_GENERAL_CFG, &v);
-	v &= ~UB913_REG_GENERAL_CFG_PCLK_RISING;
-	v |= priv->pclk_polarity_rising ? UB913_REG_GENERAL_CFG_PCLK_RISING : 0;
-	ub913_write(priv, UB913_REG_GENERAL_CFG, v);
+	ret = ub913_update_bits(priv, UB913_REG_GENERAL_CFG,
+				UB913_REG_GENERAL_CFG_PCLK_RISING,
+				FIELD_PREP(UB913_REG_GENERAL_CFG_PCLK_RISING,
+					   priv->pclk_polarity_rising));
+
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



