Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195D42FF669;
	Tue, 31 Mar 2026 17:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976727; cv=none; b=jURzqGUSdw4A91RtBkqdfF5wbG+QiqrtbMOA0R6iKUlnY887h+A64lKHTB0sx1i+cDKjEe1BhEKeVBKqoOEXRmkl2L9Ey3OmYHen/cHZdZxrBmMJB0WO4FiicW5LpI0X+F8GGJWgqLHmY91bTtSbMqV8z57ENYBauaiuaEQICnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976727; c=relaxed/simple;
	bh=JAWgKaM4IxcvFq8px8Qi2dEvL4i0rnYNDzaAE0cBJuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBgchC99+3CdQjP0Liis76PwnIKjOfEKFJ11eeflTLNXC83w9M8yalhEmAsPDC60KjwZMnFspx4ktscbLXy0tsGMoCusfCwgA7DaFG3iMuImgddkOZ36dxPahjNXg5eR8RxTUhAxBcKYocsUO0D1A3nBk6H+BtFEZhCEOZv3Aus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wy/mjI4g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wy/mjI4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37B5C19423;
	Tue, 31 Mar 2026 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976727;
	bh=JAWgKaM4IxcvFq8px8Qi2dEvL4i0rnYNDzaAE0cBJuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wy/mjI4g264joIazvDWztU1H2RnsPoU/uRRiXvjtc39MyXKgQXJ+sYIfO6nLECOf8
	 xrRkPM0leHPMEsleHvX7YxNwJR5q3A0SrK4ohqIcKa0RtIZrUiEzYwIzdImmGrXv8/
	 tiyNOuG4E3Lg/NVMA1miEHbWxstI6yHwc/erBvoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/309] ASoC: adau1372: Fix unchecked clk_prepare_enable() return value
Date: Tue, 31 Mar 2026 18:21:14 +0200
Message-ID: <20260331161759.761221397@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 326fe8104a4020d30080d37ac8b6b43893cdebca ]

adau1372_set_power() calls clk_prepare_enable() but discards the return
value. If the clock enable fails, the driver proceeds to access registers
on unpowered hardware, potentially causing silent corruption.

Make adau1372_set_power() return int and propagate the error from
clk_prepare_enable(). Update adau1372_set_bias_level() to return the
error directly for the STANDBY and OFF cases.

Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260325210704.76847-2-jihed.chaibi.dev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index fdee689cae538..6345342218d61 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -782,15 +782,18 @@ static void adau1372_enable_pll(struct adau1372 *adau1372)
 		dev_err(adau1372->dev, "Failed to lock PLL\n");
 }
 
-static void adau1372_set_power(struct adau1372 *adau1372, bool enable)
+static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 {
 	if (adau1372->enabled == enable)
-		return;
+		return 0;
 
 	if (enable) {
 		unsigned int clk_ctrl = ADAU1372_CLK_CTRL_MCLK_EN;
+		int ret;
 
-		clk_prepare_enable(adau1372->mclk);
+		ret = clk_prepare_enable(adau1372->mclk);
+		if (ret)
+			return ret;
 		if (adau1372->pd_gpio)
 			gpiod_set_value(adau1372->pd_gpio, 0);
 
@@ -829,6 +832,8 @@ static void adau1372_set_power(struct adau1372 *adau1372, bool enable)
 	}
 
 	adau1372->enabled = enable;
+
+	return 0;
 }
 
 static int adau1372_set_bias_level(struct snd_soc_component *component,
@@ -842,11 +847,9 @@ static int adau1372_set_bias_level(struct snd_soc_component *component,
 	case SND_SOC_BIAS_PREPARE:
 		break;
 	case SND_SOC_BIAS_STANDBY:
-		adau1372_set_power(adau1372, true);
-		break;
+		return adau1372_set_power(adau1372, true);
 	case SND_SOC_BIAS_OFF:
-		adau1372_set_power(adau1372, false);
-		break;
+		return adau1372_set_power(adau1372, false);
 	}
 
 	return 0;
-- 
2.53.0



