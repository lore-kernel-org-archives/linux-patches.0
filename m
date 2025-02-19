Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013FE1C5F30;
	Wed, 19 Feb 2025 08:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954984; cv=none; b=ExwQYg0tv1MmY1VxuI4i+1XLOPSI3ITkHSYczjsfzKo1b8n/lBHUvepSQcg05NOHgKYYmL1MDie+uPY9269f+c8q5AYKTyy4NVbVvOLrmasVrdYNq39W45QZ/56WpEVMKwxnVFFH7td8NHP7BMcVwJqR3fBio30xBj4M05Wv6sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954984; c=relaxed/simple;
	bh=X6+Yaa7MV30HKXWsIhji+80KmrGFJHo6nup/CpDcL5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf+hSUbrEVIB7V9r0+mKOZ3blxKZRxV5x2gQl2+AKFTUySw9Pw4eE2BKUAPp6jvPviEH+3XYJ+BX2FfrtpDOIfZOj1QkenMxHNU2c1WHNbIHyYQDUKfsS+SB4RjSSqgrg6SQ/QOTgwEAxBPYpkGNRONzUf+qJFON8TzvD+zI7fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoLchjlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoLchjlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7866DC4CED1;
	Wed, 19 Feb 2025 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954983;
	bh=X6+Yaa7MV30HKXWsIhji+80KmrGFJHo6nup/CpDcL5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoLchjlOoRaQy64DVF4SW69sGSwwTjvbduhZg3qawRMMKkLMzVAK2HJ8ePMleC6i4
	 hhBvVMfABohkWGl1hzK0M2+4G1SDFYsp6Lv+JdGqMZuSzw5VC3HIK7bUkJCLWSo9md
	 DlkUBnvzz2ZYOEtjR1oxlXfGnKW1Mhqr7VgubjQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/230] media: i2c: ds90ub953: Add error handling for i2c reads/writes
Date: Wed, 19 Feb 2025 09:26:23 +0100
Message-ID: <20250219082604.293400918@linuxfoundation.org>
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

[ Upstream commit 0794c43ea1e451007e80246e1288ebbf44139397 ]

Add error handling for i2c reads/writes in various places.

Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Closes: https://lore.kernel.org/all/Zv40EQSR__JDN_0M@kekkonen.localdomain/
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ds90ub953.c | 46 ++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/ds90ub953.c b/drivers/media/i2c/ds90ub953.c
index 10daecf6f4579..f0bad3e64f23d 100644
--- a/drivers/media/i2c/ds90ub953.c
+++ b/drivers/media/i2c/ds90ub953.c
@@ -398,8 +398,13 @@ static int ub953_gpiochip_probe(struct ub953_data *priv)
 	int ret;
 
 	/* Set all GPIOs to local input mode */
-	ub953_write(priv, UB953_REG_LOCAL_GPIO_DATA, 0);
-	ub953_write(priv, UB953_REG_GPIO_INPUT_CTRL, 0xf);
+	ret = ub953_write(priv, UB953_REG_LOCAL_GPIO_DATA, 0);
+	if (ret)
+		return ret;
+
+	ret = ub953_write(priv, UB953_REG_GPIO_INPUT_CTRL, 0xf);
+	if (ret)
+		return ret;
 
 	gc->label = dev_name(dev);
 	gc->parent = dev;
@@ -961,10 +966,11 @@ static void ub953_calc_clkout_params(struct ub953_data *priv,
 	clkout_data->rate = clkout_rate;
 }
 
-static void ub953_write_clkout_regs(struct ub953_data *priv,
-				    const struct ub953_clkout_data *clkout_data)
+static int ub953_write_clkout_regs(struct ub953_data *priv,
+				   const struct ub953_clkout_data *clkout_data)
 {
 	u8 clkout_ctrl0, clkout_ctrl1;
+	int ret;
 
 	if (priv->hw_data->is_ub971)
 		clkout_ctrl0 = clkout_data->m;
@@ -974,8 +980,15 @@ static void ub953_write_clkout_regs(struct ub953_data *priv,
 
 	clkout_ctrl1 = clkout_data->n;
 
-	ub953_write(priv, UB953_REG_CLKOUT_CTRL0, clkout_ctrl0);
-	ub953_write(priv, UB953_REG_CLKOUT_CTRL1, clkout_ctrl1);
+	ret = ub953_write(priv, UB953_REG_CLKOUT_CTRL0, clkout_ctrl0);
+	if (ret)
+		return ret;
+
+	ret = ub953_write(priv, UB953_REG_CLKOUT_CTRL1, clkout_ctrl1);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static unsigned long ub953_clkout_recalc_rate(struct clk_hw *hw,
@@ -1055,9 +1068,7 @@ static int ub953_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
 	dev_dbg(&priv->client->dev, "%s %lu (requested %lu)\n", __func__,
 		clkout_data.rate, rate);
 
-	ub953_write_clkout_regs(priv, &clkout_data);
-
-	return 0;
+	return ub953_write_clkout_regs(priv, &clkout_data);
 }
 
 static const struct clk_ops ub953_clkout_ops = {
@@ -1082,7 +1093,9 @@ static int ub953_register_clkout(struct ub953_data *priv)
 
 	/* Initialize clkout to 25MHz by default */
 	ub953_calc_clkout_params(priv, UB953_DEFAULT_CLKOUT_RATE, &clkout_data);
-	ub953_write_clkout_regs(priv, &clkout_data);
+	ret = ub953_write_clkout_regs(priv, &clkout_data);
+	if (ret)
+		return ret;
 
 	priv->clkout_clk_hw.init = &init;
 
@@ -1229,10 +1242,15 @@ static int ub953_hw_init(struct ub953_data *priv)
 	if (ret)
 		return dev_err_probe(dev, ret, "i2c init failed\n");
 
-	ub953_write(priv, UB953_REG_GENERAL_CFG,
-		    (priv->non_continous_clk ? 0 : UB953_REG_GENERAL_CFG_CONT_CLK) |
-		    ((priv->num_data_lanes - 1) << UB953_REG_GENERAL_CFG_CSI_LANE_SEL_SHIFT) |
-		    UB953_REG_GENERAL_CFG_CRC_TX_GEN_ENABLE);
+	v = 0;
+	v |= priv->non_continous_clk ? 0 : UB953_REG_GENERAL_CFG_CONT_CLK;
+	v |= (priv->num_data_lanes - 1) <<
+		UB953_REG_GENERAL_CFG_CSI_LANE_SEL_SHIFT;
+	v |= UB953_REG_GENERAL_CFG_CRC_TX_GEN_ENABLE;
+
+	ret = ub953_write(priv, UB953_REG_GENERAL_CFG, v);
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



