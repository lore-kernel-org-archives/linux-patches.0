Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174946AA64;
	Tue, 21 Jul 2026 18:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659864; cv=none; b=HWdnkGe0sajU/F/WHlKgjuE4fgKOkay1bVSXhpK1Uyn/Xh0g5vaPFDWDJQ2P/GK1sfQAKFhp9pjEI7RNNh7cvOGQSNG2UJwDAW9Uavb+oue/c6yQ2fTWCToZc/HelAx4bGVJRPb3VwPRAF5JTy8DpIE8G1yFSWiueP8D07ez45o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659864; c=relaxed/simple;
	bh=I8OIAzTe094j2KU4CSsw1qCTlYPsu5ccZoRZPqCc5s0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoVKdjsHDNhMbra5Jl4moa7bhjbxc0wu/SEkAI7oAfosMPrOof5W7nB68vRSra5mlcSvBkJp+ZDjfe/WHd1HMKM2+Ssp0sVtqkZP9+oubUTI0BXkh8vfvpYjbpBDDgdaJ7gaxn4m8vyLQsDmJcsn2XedYoNPgtcsakaupBn6BRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysCemOvC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysCemOvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689581F000E9;
	Tue, 21 Jul 2026 18:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659862;
	bh=LAr6zwRHf7UUcTq0p2TNaZYPG+xK/GZq0JNNRuxwGIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysCemOvColXo184r9j51VDknDDZ7GbkNiHr67TT4DH8Rhu1+9UBKwh8Jc44H3nC+e
	 F8pKlqywO84/MK3ywWQT4V2dZCJkHW7RlgM9zxJpkN3UMEsHd5XsQUmCOBtSGWEFzs
	 W7oh1Ko7wVrpABD1pxyRpYyqMJviNa/kvy72ONNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0735/2077] ASoC: adau1372: Clear PLL_EN on failed PLL lock without reset GPIO
Date: Tue, 21 Jul 2026 17:06:48 +0200
Message-ID: <20260721152610.133325678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d7363f9d53bb31..879afeb81c422d 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -813,6 +813,11 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
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



