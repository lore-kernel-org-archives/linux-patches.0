Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAAE306B0A;
	Mon, 13 Apr 2026 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097494; cv=none; b=Z+joELbiZSxQU9RyhhOHpXWaCPBldRrutskjznT0VI77jezunmh6o4ig4AMolYEz6+HWeeDskjmvgGUe4XADyMphVw+XiOK0RmX5zje2C+99G26xVM7Wes4+sdSSR9eyWlPMHvn1H9FI7llP1HkchdpmAU4vyvNdlrtmAuxSjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097494; c=relaxed/simple;
	bh=DxmSehe1Lfe5252h0F+E30v1vp2kmr5f2HXDwIcbUE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+f8ojQ+TtnjNeLMBNGm//Q6snuavl83rnH9hTJpUFtIyLPD9vWEvKVteRKdaVGiHUJkcGmMiWQm/tB0cRDgcxGDMbbYag7GaTcWsde4BW4NvcaF7Dly835Bf2Os4TJQrrMVBiPhBdxLVbrZNk5BNoMJ1niK1lbZgHfUH2eEpuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBGRn+1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBGRn+1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AD8C2BCB3;
	Mon, 13 Apr 2026 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097494;
	bh=DxmSehe1Lfe5252h0F+E30v1vp2kmr5f2HXDwIcbUE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBGRn+1vdi5HBK/fOQsoPSZLgQoeL8bzS8xZtRB6n1N0195nU7GjCQNsP6JRpUtf0
	 PcLO1xwpQdaV8RkP1Ap3qgNXa8UChq96GvRVANuUa44RrWu1q4+RaqDrgCSWWmr5HM
	 W5B4oGQ4ro6OWAIsMHKWAg6vKK2NVChdnXfSLGjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/570] ASoC: amd: acp3x-rt5682-max9836: Add missing error check for clock acquisition
Date: Mon, 13 Apr 2026 17:54:16 +0200
Message-ID: <20260413155835.125478029@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 53f3a900e9a383d47af7253076e19f510c5708d0 ]

The acp3x_5682_init() function did not check the return value of
clk_get(), which could lead to dereferencing error pointers in
rt5682_clk_enable().

Fix this by:
1. Changing clk_get() to the device-managed devm_clk_get().
2. Adding proper IS_ERR() checks for both clock acquisitions.

Fixes: 6b8e4e7db3cd ("ASoC: amd: Add machine driver for Raven based platform")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://patch.msgid.link/20260310024246.2153827-1-nichen@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp3x-rt5682-max9836.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp3x-rt5682-max9836.c b/sound/soc/amd/acp3x-rt5682-max9836.c
index e561464f7d603..f8f268090d8a8 100644
--- a/sound/soc/amd/acp3x-rt5682-max9836.c
+++ b/sound/soc/amd/acp3x-rt5682-max9836.c
@@ -83,8 +83,13 @@ static int acp3x_5682_init(struct snd_soc_pcm_runtime *rtd)
 		return ret;
 	}
 
-	rt5682_dai_wclk = clk_get(component->dev, "rt5682-dai-wclk");
-	rt5682_dai_bclk = clk_get(component->dev, "rt5682-dai-bclk");
+	rt5682_dai_wclk = devm_clk_get(component->dev, "rt5682-dai-wclk");
+	if (IS_ERR(rt5682_dai_wclk))
+		return PTR_ERR(rt5682_dai_wclk);
+
+	rt5682_dai_bclk = devm_clk_get(component->dev, "rt5682-dai-bclk");
+	if (IS_ERR(rt5682_dai_bclk))
+		return PTR_ERR(rt5682_dai_bclk);
 
 	ret = snd_soc_card_jack_new(card, "Headset Jack",
 				SND_JACK_HEADSET | SND_JACK_LINEOUT |
-- 
2.51.0



