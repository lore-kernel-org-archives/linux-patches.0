Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFA415F1A;
	Tue, 21 Jul 2026 19:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662768; cv=none; b=J0smOdjjUN5WzbdKUI80VkkR5Y6zNqTmkOkfqdi2s0aTb1X35YyLqWk1w7rmWQErYJXQpZZXYJ4gazVQ7+4TLH24dkT9XNrD8LipjcdQi0t9WA79m7+yiRMqQ/A/nQr7l9K/pIyFqDaYjWM9kPb+kcWWDUlaf4D9aQUnfsDoKUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662768; c=relaxed/simple;
	bh=VkTPAQ1I/cyzDt4eDOEEuhZraFJQG9mwJRTpFvNLGEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InQyeJhQf2nYYVs7DBN6Qur3d2Z3UgFLaJ06rZ9x+1NigshrZVQZ4Z7vVEulXauUBcG+itmjj2fMtnevFQ7RM4BrmyfN9OPO8doHmnDbuhx7eJNXY3E61PKtW3nO9/PZ2kzlt9oqL14prKeAX/nlsfhmCtr3U9UfZcFHQ8t6n1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDmU3XIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDmU3XIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7A41F00A3A;
	Tue, 21 Jul 2026 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662766;
	bh=hsCotEmI0DG8dKn8oWlRe1jZvmC7UNlVYDmZE1wEFpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDmU3XIs7qfVHVblpOPMT0mIb9tbZHowUnechA2XI/qvIkX6EVeI228eLLLYPaso8
	 TFsN9lfi0uKxA5YAYE/0RPcSV48cqFVH+Dc2uSiBXcwvjoqBZAAtvrQMLioumB7GBr
	 Jw1ru/3tDKmmWl7pOyCjPwRYW3ak1EpQy2XQUzyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mir Jeffres <m-jeffres@ti.com>,
	Sen Wang <sen@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0570/1276] ASoC: tlv320aic3x: restrict CLKDIV bypass Q values in dual-rate mode
Date: Tue, 21 Jul 2026 17:16:53 +0200
Message-ID: <20260721152458.872530945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sen Wang <sen@ti.com>

[ Upstream commit fdf043f5f3bae150b678feae3d7bb1beed87ec14 ]

The datasheet documents that when the PLL is disabled and dual-rate mode
is enabled, only Q values {4, 8, 9, 12, 16} are valid for the CLKDIV
bypass path; all other Q values produce invalid bitclock output.

The existing loop iterates Q from 2 to 17 without this restriction,
causing silent audio failure when an out-of-spec Q is picked.

Restrict the Q search to the allowed set in dual-rate mode.

Fixes: 4f9c16ccfa26 ("[ALSA] soc - tlv320aic3x - revisit clock setup")
Suggested-by: Mir Jeffres <m-jeffres@ti.com>
Signed-off-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260616233322.873081-1-sen@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic3x.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 591f6c9f9d3a60..05eff1ed4e96ca 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1049,11 +1049,13 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 			   struct snd_pcm_hw_params *params,
 			   struct snd_soc_dai *dai)
 {
+	static const u8 dual_rate_q[] = {4, 8, 9, 12, 16};
 	struct snd_soc_component *component = dai->component;
 	struct aic3x_priv *aic3x = snd_soc_component_get_drvdata(component);
 	int codec_clk = 0, bypass_pll = 0, fsref, last_clk = 0;
 	u8 data, j, r, p, pll_q, pll_p = 1, pll_r = 1, pll_j = 1;
 	u16 d, pll_d = 1;
+	bool dual_rate;
 	int clk;
 	int width = aic3x->slot_width;
 
@@ -1079,14 +1081,25 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 
 	/* Fsref can be 44100 or 48000 */
 	fsref = (params_rate(params) % 11025 == 0) ? 44100 : 48000;
+	dual_rate = params_rate(params) >= 64000;
 
 	/* Try to find a value for Q which allows us to bypass the PLL and
 	 * generate CODEC_CLK directly. */
-	for (pll_q = 2; pll_q < 18; pll_q++)
-		if (aic3x->sysclk / (128 * pll_q) == fsref) {
-			bypass_pll = 1;
-			break;
+	if (dual_rate) {
+		for (int i = 0; i < ARRAY_SIZE(dual_rate_q); i++) {
+			pll_q = dual_rate_q[i];
+			if (aic3x->sysclk / (128 * pll_q) == fsref) {
+				bypass_pll = 1;
+				break;
+			}
 		}
+	} else {
+		for (pll_q = 2; pll_q < 18; pll_q++)
+			if (aic3x->sysclk / (128 * pll_q) == fsref) {
+				bypass_pll = 1;
+				break;
+			}
+	}
 
 	if (bypass_pll) {
 		pll_q &= 0xf;
@@ -1106,13 +1119,13 @@ static int aic3x_hw_params(struct snd_pcm_substream *substream,
 	 * right DAC to right channel input */
 	data = (LDAC2LCH | RDAC2RCH);
 	data |= (fsref == 44100) ? FSREF_44100 : FSREF_48000;
-	if (params_rate(params) >= 64000)
+	if (dual_rate)
 		data |= DUAL_RATE_MODE;
 	snd_soc_component_write(component, AIC3X_CODEC_DATAPATH_REG, data);
 
 	/* codec sample rate select */
 	data = (fsref * 20) / params_rate(params);
-	if (params_rate(params) < 64000)
+	if (!dual_rate)
 		data /= 2;
 	data /= 5;
 	data -= 2;
-- 
2.53.0



