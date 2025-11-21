Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C634E345CAA;
	Fri, 21 Nov 2025 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733001; cv=none; b=cZgLgfnAsYOE9olHf2mAnOp29/hsMdSJKLhKJYWy5x2lEncbC7hfnNutH5lhWBaRdl8/rjh6Ik5lw2fZesA2Ptxz67N1UhrFszjb6h3LIoOgOD+40pjD6hw1ruZcUQ7X8tFV+7XAsY/8KKX3t1FKPYUn1ehM6tBQALJqv50LLq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733001; c=relaxed/simple;
	bh=apZ5t8jZPxcJ+bTswT6Vc8oWLwaHrTkTQoDiXUzvFp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPUpR79P4K7TfQRP/1YEvS0DEwPNLCFbrxdwTalQFaNYbh+8wRrkfXc234IuaJbg2DoLEmh6di42OTYoc0dAZVoTS7QGyAC/H/cvR5XVJ4y0/7DwNGQexSAglo9yiUMqzrcg8eFf0EEFDInmVHMwmyy+0DA92abvLt8hxmGZe7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNqZYSoi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNqZYSoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D570AC4CEF1;
	Fri, 21 Nov 2025 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733001;
	bh=apZ5t8jZPxcJ+bTswT6Vc8oWLwaHrTkTQoDiXUzvFp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNqZYSoiUpYS3P8cqnVNiOU0E18+6AlELZ9P0v9S8o3VRdhaA5hwMBRopuUbGgBgD
	 0sf11mT81/NRrCqeTbKedhZr+tql+Yl88Av9cVJPd4+jm1/LpjXKhi80UkqRcjlJGV
	 hWkTV7/pRGXs4B+RK3qdfJjObYNjPYgFoYg4Y0oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/529] ASoC: tlv320aic3x: Fix class-D initialization for tlv320aic3007
Date: Fri, 21 Nov 2025 14:09:42 +0100
Message-ID: <20251121130241.099808568@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 733a763dd8b3ac2858dd238a91bb3a2fdff4739e ]

The problem of having class-D initialization sequence in probe using
regmap_register_patch() is that it will do hardware register writes
immediately after being called as it bypasses regcache. Afterwards, in
aic3x_init() we also perform codec soft reset, rendering class-D init
sequence pointless. This issue is even more apparent when using reset
GPIO line, since in that case class-D amplifier initialization fails
with "Failed to init class D: -5" message as codec is already held in
reset state after requesting the reset GPIO and hence hardware I/O
fails with -EIO errno.

Thus move class-D amplifier initialization sequence from probe function
to aic3x_set_power() just before the usual regcache sync. Use bypassed
regmap_multi_reg_write_bypassed() function to make sure, class-D init
sequence is performed in proper order as described in the datasheet.

Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Link: https://patch.msgid.link/20250925085929.2581749-1-primoz.fiser@norik.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic3x.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 56e795a00e22f..591f6c9f9d3a6 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -121,6 +121,16 @@ static const struct reg_default aic3x_reg[] = {
 	{ 108, 0x00 }, { 109, 0x00 },
 };
 
+static const struct reg_sequence aic3007_class_d[] = {
+	/* Class-D speaker driver init; datasheet p. 46 */
+	{ AIC3X_PAGE_SELECT, 0x0D },
+	{ 0xD, 0x0D },
+	{ 0x8, 0x5C },
+	{ 0x8, 0x5D },
+	{ 0x8, 0x5C },
+	{ AIC3X_PAGE_SELECT, 0x00 },
+};
+
 static bool aic3x_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -1393,6 +1403,10 @@ static int aic3x_set_power(struct snd_soc_component *component, int power)
 			gpiod_set_value(aic3x->gpio_reset, 0);
 		}
 
+		if (aic3x->model == AIC3X_MODEL_3007)
+			regmap_multi_reg_write_bypassed(aic3x->regmap, aic3007_class_d,
+							ARRAY_SIZE(aic3007_class_d));
+
 		/* Sync reg_cache with the hardware */
 		regcache_cache_only(aic3x->regmap, false);
 		regcache_sync(aic3x->regmap);
@@ -1723,17 +1737,6 @@ static void aic3x_configure_ocmv(struct device *dev, struct aic3x_priv *aic3x)
 	}
 }
 
-
-static const struct reg_sequence aic3007_class_d[] = {
-	/* Class-D speaker driver init; datasheet p. 46 */
-	{ AIC3X_PAGE_SELECT, 0x0D },
-	{ 0xD, 0x0D },
-	{ 0x8, 0x5C },
-	{ 0x8, 0x5D },
-	{ 0x8, 0x5C },
-	{ AIC3X_PAGE_SELECT, 0x00 },
-};
-
 int aic3x_probe(struct device *dev, struct regmap *regmap, kernel_ulong_t driver_data)
 {
 	struct aic3x_priv *aic3x;
@@ -1825,13 +1828,6 @@ int aic3x_probe(struct device *dev, struct regmap *regmap, kernel_ulong_t driver
 
 	aic3x_configure_ocmv(dev, aic3x);
 
-	if (aic3x->model == AIC3X_MODEL_3007) {
-		ret = regmap_register_patch(aic3x->regmap, aic3007_class_d,
-					    ARRAY_SIZE(aic3007_class_d));
-		if (ret != 0)
-			dev_err(dev, "Failed to init class D: %d\n", ret);
-	}
-
 	ret = devm_snd_soc_register_component(dev, &soc_component_dev_aic3x, &aic3x_dai, 1);
 	if (ret)
 		return ret;
-- 
2.51.0



