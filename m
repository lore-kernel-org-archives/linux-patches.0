Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CC1A315E;
	Wed, 19 Feb 2025 09:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955619; cv=none; b=rmc7KTpxlfj2glfu15kR1TOzt/4XgDIGZ9rbEHbpGdbQ49ywlXPeGLANZgqcelkCk7POPpnHSfYwfUsU9cYXzYgHzMTpm7p8tIfIQOKUnpKB3j70DyIRZWxESvuB0gFPr1Qtuwz6aN9Zayoj+rz2Z/p27mzAiXYV2oYqFiGmU3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955619; c=relaxed/simple;
	bh=vUiNAKCkHA9YmK/p9zgd2CBNpBipxwqnLgUT0JEPX1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYSoqU8y9Jc9+Oy5BUDJbinwoMSo0SnrkbhR4+QxJX3Gsmm3qiQnghlQTLlESo1pnnWLY4stU9K1lmhSmiR8PFgQ7WYuagUTjD5viZ3vWSQd8N4J84hM9r36KkpyQaO9Dc43Q6bz7mQFO7YdiaitKJsCDCIzz79vTfJqfUNLmkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkoc88SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkoc88SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E16C4CED1;
	Wed, 19 Feb 2025 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955619;
	bh=vUiNAKCkHA9YmK/p9zgd2CBNpBipxwqnLgUT0JEPX1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkoc88SH5RS2bBVsPZl/qt45C40NrOrmdNg1UWcq15+C69ow/RVGwgzDVMqAIa4P8
	 Ry8y5see+ElPsKa89LaY6lToMvpZCNw5Nn1RIO/mjFOBKbVwqhcnHc3ChOch+Ss7hw
	 MvZBasDjTOLArQsiqWTaFhl9I2VOuHVepouPcXn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/152] media: i2c: ds90ub913: Add error handling to ub913_hw_init()
Date: Wed, 19 Feb 2025 09:27:23 +0100
Message-ID: <20250219082551.231033706@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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
index 5a650facae415..ae33d1ecf835d 100644
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



