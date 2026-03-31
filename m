Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E652E1C7C;
	Tue, 31 Mar 2026 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976729; cv=none; b=Pvk5cpwprBldxjyRS5J4Sg7mS7jHMCVToXSRoh9X1b78DcnSNfC2dP2c+SRj6fxFOSAwc8HBxtnTfkwKrLUpDA/YRaNphtKbdkP8jJc3U4vsP5E2q0klkwsLNeZEjVLqf+dYzn7VGbLulkWCSC5oMPAHT/Zo8IvdQxw/X/MhmjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976729; c=relaxed/simple;
	bh=WVCJmcO1MlpnRAu8rXsyO+wbog2zqux0gtE4V88YjK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFIvxNP+cE0R4PN4Eei/ktPzfOkju8v4yWnMAeUmwaA+PNexCePccHnj/zMELcFkM2q/AsTfrgxbJRZkChU6I4VVelQmWcJIDhu8/zg+2jEWmEsCIukHbhe71TSr4CHOy5DO8TeDwZ+v3akUEpfVxUQiwYiOZ1OrgX1euWNGv1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGesQcTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGesQcTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C78CC2BCB3;
	Tue, 31 Mar 2026 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976729;
	bh=WVCJmcO1MlpnRAu8rXsyO+wbog2zqux0gtE4V88YjK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGesQcTBeapn8CCVvu5OwiD9mKOnR+QmOYk5/Op4n1lpYwDx6gqMv26yn716gv+Yv
	 wzoN7jzgpuiLmiccuJ0quF3lmHKjvox80nAbHYHwtWAglaDW3sl7Cy+lIsKNogzxj/
	 YYvAhILLm0Miusv39juF78fb3DaH5IQ8wa+QkryU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/309] ASoC: adau1372: Fix clock leak on PLL lock failure
Date: Tue, 31 Mar 2026 18:21:15 +0200
Message-ID: <20260331161759.797480054@linuxfoundation.org>
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

[ Upstream commit bfe6a264effcb6fe99ad7ceaf9e8c7439fc9555b ]

adau1372_enable_pll() was a void function that logged a dev_err() on
PLL lock timeout but did not propagate the error. As a result,
adau1372_set_power() would continue with adau1372->enabled set to true
despite the PLL being unlocked, and the mclk left enabled with no
corresponding disable on the error path.

Convert adau1372_enable_pll() to return int, using -ETIMEDOUT on lock
timeout and propagating regmap errors directly. In adau1372_set_power(),
check the return value and unwind in reverse order: restore regcache to
cache-only mode, reassert GPIO power-down, and disable the clock before
returning the error.

Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260325210704.76847-3-jihed.chaibi.dev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index 6345342218d61..d7363f9d53bb3 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -762,7 +762,7 @@ static int adau1372_startup(struct snd_pcm_substream *substream, struct snd_soc_
 	return 0;
 }
 
-static void adau1372_enable_pll(struct adau1372 *adau1372)
+static int adau1372_enable_pll(struct adau1372 *adau1372)
 {
 	unsigned int val, timeout = 0;
 	int ret;
@@ -778,8 +778,12 @@ static void adau1372_enable_pll(struct adau1372 *adau1372)
 		timeout++;
 	} while (!(val & 1) && timeout < 3);
 
-	if (ret < 0 || !(val & 1))
+	if (ret < 0 || !(val & 1)) {
 		dev_err(adau1372->dev, "Failed to lock PLL\n");
+		return ret < 0 ? ret : -ETIMEDOUT;
+	}
+
+	return 0;
 }
 
 static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
@@ -807,7 +811,14 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 		 * accessed.
 		 */
 		if (adau1372->use_pll) {
-			adau1372_enable_pll(adau1372);
+			ret = adau1372_enable_pll(adau1372);
+			if (ret) {
+				regcache_cache_only(adau1372->regmap, true);
+				if (adau1372->pd_gpio)
+					gpiod_set_value(adau1372->pd_gpio, 1);
+				clk_disable_unprepare(adau1372->mclk);
+				return ret;
+			}
 			clk_ctrl |= ADAU1372_CLK_CTRL_CLKSRC;
 		}
 
-- 
2.53.0



