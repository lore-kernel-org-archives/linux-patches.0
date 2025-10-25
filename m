Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F7430B527;
	Sat, 25 Oct 2025 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409034; cv=none; b=TojiKiE5pWlIlvCY+TSXz4V+PoFVeeDR1VPkGzJ+KPZMgs1xknITZQ1bd7h75JI70uPS7WR2ynUXtAl82bcRfDpUWsr/ctLCCRZ/kgoYN2YVPV/VN+ORRyp+T7xt5WGlQfOU33o4QOcqFNMoC31I8xCWWp6e31aYhqtWIoW3rxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409034; c=relaxed/simple;
	bh=+Q4I3s1hMoccXGt3od3BjlqiRClbKs+el/X4XfZ2330=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qldg8RdpDdXgC4qmSeMNBqzzISEhvFmfDNZs5fJlLPKLExnpfAHNc5wNPjlqa4WAoZcTuPvH0FILXtlZsc1IGxg7E4B2EkY4INh8obc9Y55eJf3RUGORMgIa4OLuEXKVgD/uzJjbWn+LXGp/tOp90TCJDLfDvl8ekq3HTGQG3oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKq2cwbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKq2cwbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0238CC4CEFB;
	Sat, 25 Oct 2025 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409034;
	bh=+Q4I3s1hMoccXGt3od3BjlqiRClbKs+el/X4XfZ2330=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKq2cwbQYmXFqruCATCCVZPEB3G/jvysdtmNj6TpNQu1R5mwNeQyo9VoGsfo2E5hY
	 KVmzsP+0Mojna+KYeTCXc4CSJVHps5qbakPOIzEc8+kKS8IvqMd6Z/Q1roobUk/WL6
	 fRy2UTGvVYEKqyoxdzxuMpXCj40Y2UEXP9y4ZWINVulgNwPoMWub5XQmxgyXTj4+LH
	 hGU8GKbmrMmCHUEIhepoqPTWO8UjeJk5E5mB4K+5Rvxgk28FqklqGApRh/qSOnDlJi
	 TlI+Cair3fPwp54i1rrkwzkESoMPtl6la4AQWKXXZjGigQ4EUsqUD2zvSoEKlLMwbm
	 OSjsg0JPAopQw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Primoz Fiser <primoz.fiser@norik.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	linux-sound@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] ASoC: tlv320aic3x: Fix class-D initialization for tlv320aic3007
Date: Sat, 25 Oct 2025 11:56:50 -0400
Message-ID: <20251025160905.3857885-179-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- Moving the class‑D init to the power‑on path ensures the sequence
  actually programs the codec after reset:
  `regmap_multi_reg_write_bypassed()` now runs immediately after
  regulators are enabled and the reset GPIO is deasserted
  (`sound/soc/codecs/tlv320aic3x.c:1394-1408`), so the class‑D block on
  tlv320aic3007 finally comes out of reset with the datasheet‑mandated
  ordering retained (`drivers/base/regmap/regmap.c:2649-2684`).
- The prior implementation wrote the same register sequence during probe
  while the chip was still (or about to be) reset
  (`sound/soc/codecs/tlv320aic3x.c:1553-1559`,
  `sound/soc/codecs/tlv320aic3x.c:1794-1815`), yielding -EIO failures
  and undoing the configuration; removing that probe-time call
  (`sound/soc/codecs/tlv320aic3x.c:1782-1828`) eliminates the window
  where the codec couldn’t be addressed.
- Change scope is tight: the new sequence is guarded by `aic3x->model ==
  AIC3X_MODEL_3007` and only affects the existing power/bias flow, so
  other aic3x variants and runtime paths remain untouched.
- This clearly fixes a user-visible regression (class‑D amp never
  enables on systems using the reset GPIO), introduces no new APIs, and
  aligns with stable rules for targeted bug fixes.

Suggested next step: 1) Validate audio output on hardware carrying
tlv320aic3007 with reset GPIO asserted to confirm the class‑D amplifier
now powers up correctly.

 sound/soc/codecs/tlv320aic3x.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index f1649df197389..eea8ca285f8e0 100644
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
@@ -1823,13 +1826,6 @@ int aic3x_probe(struct device *dev, struct regmap *regmap, kernel_ulong_t driver
 
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

