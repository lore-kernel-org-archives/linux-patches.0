Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D384266BF;
	Tue, 21 Jul 2026 22:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671723; cv=none; b=P6uIGkIYjQHpJMaQD6UvJflo63pvHewZ073wGMSJ+2phL2IBKtIoWgmysRflHbEscrDxTKYV5S/H+uN9BqLwT8Lq4pAVDnnwcMUD0yuKXgCXZ7XMYE3tLcOyDj+tfFYc39hAzOk8jnecTwynmmtyaAUTH4Jc989J45lIfeCrp9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671723; c=relaxed/simple;
	bh=FnKQd0dMfAkA+MgUPos+elfE1h5tOxOBkdirLhjqtGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqLgJh/vgxYy3Qbo1t885rJESk1fOsKAU0IIca7LMtwiIWT81GbI8GzfPbQXpP4aH127BiEwR/lsxewxVK1jl5ZXXtGTgftDEZwHRQXlY9xBjl1tVN7OFvo2rd6VHn0GgpQTh5CakgCMgjj0DbuiJA9Oc9Hc5aeMvpUZJHk5m2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v63lOCow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v63lOCow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F321F000E9;
	Tue, 21 Jul 2026 22:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671722;
	bh=SFfrZ6/HFjGj7cSRXPfACadM6ybRvOOu2hAJ+GFmEds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v63lOCowbTYo00phGf0/Fp5Xk50d/aHEA71Y9Kne5SqW0hixxuGxRlFVrz5bZPfL3
	 MJLQYatwygQglPfDm1irg+sbKkoKbiYqzeLFjpwkTYsSbPaBBnavYE2B1PUZjISXZ2
	 WoBcGq/NYm1ZoFSded6rR7+0hXpqLcgeYYsbbFWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/843] ASoC: adau1372: Clear PLL_EN on failed PLL lock without reset GPIO
Date: Tue, 21 Jul 2026 17:19:47 +0200
Message-ID: <20260721152413.953494216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 69b4141b428bcf2cf7a863950c0d6e5c5ae89ac1 ]

The PLL lock failure path in adau1372_set_power() unwinds by putting
the regmap back in cache-only mode, asserting the optional power-down
GPIO and disabling mclk.

adau1372_enable_pll() enables CLK_CTRL.PLL_EN before polling the PLL
lock bit. If the lock fails on a board without a power-down GPIO, the
error path disables mclk and returns an error, but leaves PLL_EN set in
the hardware register. The normal power-off path already handles the
no-GPIO case by explicitly clearing PLL_EN.

Mirror that cleanup in the PLL lock failure path and clear PLL_EN while
the regmap is still live, before switching it back to cache-only mode.

Fixes: bfe6a264effc ("ASoC: adau1372: Fix clock leak on PLL lock failure")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260604125520.1428905-1-lgs201920130244@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index e20145812f12b6..0dc5381cdc3966 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -812,6 +812,11 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 		if (adau1372->use_pll) {
 			ret = adau1372_enable_pll(adau1372);
 			if (ret) {
+				if (!adau1372->pd_gpio)
+					regmap_update_bits(adau1372->regmap,
+							   ADAU1372_REG_CLK_CTRL,
+							   ADAU1372_CLK_CTRL_PLL_EN,
+							   0);
 				regcache_cache_only(adau1372->regmap, true);
 				if (adau1372->pd_gpio)
 					gpiod_set_value(adau1372->pd_gpio, 1);
-- 
2.53.0



