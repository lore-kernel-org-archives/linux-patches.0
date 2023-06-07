Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4313925D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF051C433EF;
	Wed,  7 Jun 2023 20:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169546;
	bh=hVtHiV4tktYdS6kpiViux1Z237vpIMuTIER+JWq5JNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uORupTAFmjrydbcEq7l5oNDG1rqUOfDZLd0jb0O2MkN8nhw8wbm7AffS19jCvtG7A
	 Hm8KeIqcwasgGxMOnTCAhkJ+F5bAEA3J7Vscg6LpcgEntigIFxAKri2XOncOl7k0mO
	 qH3L2jqxEoicK7PQ/l6p+f9xK5r013bpxkQ11Nyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 121/286] ASoC: jz4740-i2s: Make I2S divider calculations more robust
Date: Wed,  7 Jun 2023 22:13:40 +0200
Message-ID: <20230607200927.034337877@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

[ Upstream commit ad721bc919edfd8b4b06977458a412011e2f0c50 ]

When the CPU supplies bit/frame clocks, the system clock (clk_i2s)
is divided to produce the bit clock. This is a simple 1/N divider
with a fairly limited range, so for a given system clock frequency
only a few sample rates can be produced. Usually a wider range of
sample rates is supported by varying the system clock frequency.

The old calculation method was not very robust and could easily
produce the wrong clock rate, especially with non-standard rates.
For example, if the system clock is 1.99x the target bit clock
rate, the divider would be calculated as 1 instead of the more
accurate 2.

Instead, use a more accurate method that considers two adjacent
divider settings and selects the one that produces the least error
versus the requested rate. If the error is 5% or higher then the
rate setting is rejected to prevent garbled audio.

Skip divider calculation when the codec is supplying both the bit
and frame clock; in that case, the divider outputs are unused and
we don't want to constrain the sample rate.

Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com
Link: https://lore.kernel.org/r/20230509125134.208129-1-aidanmacdonald.0x0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/jz4740/jz4740-i2s.c | 54 ++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 6d9cfe0a50411..d0f6c945d9aee 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -218,18 +218,48 @@ static int jz4740_i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	return 0;
 }
 
+static int jz4740_i2s_get_i2sdiv(unsigned long mclk, unsigned long rate,
+				 unsigned long i2sdiv_max)
+{
+	unsigned long div, rate1, rate2, err1, err2;
+
+	div = mclk / (64 * rate);
+	if (div == 0)
+		div = 1;
+
+	rate1 = mclk / (64 * div);
+	rate2 = mclk / (64 * (div + 1));
+
+	err1 = abs(rate1 - rate);
+	err2 = abs(rate2 - rate);
+
+	/*
+	 * Choose the divider that produces the smallest error in the
+	 * output rate and reject dividers with a 5% or higher error.
+	 * In the event that both dividers are outside the acceptable
+	 * error margin, reject the rate to prevent distorted audio.
+	 * (The number 5% is arbitrary.)
+	 */
+	if (div <= i2sdiv_max && err1 <= err2 && err1 < rate/20)
+		return div;
+	if (div < i2sdiv_max && err2 < rate/20)
+		return div + 1;
+
+	return -EINVAL;
+}
+
 static int jz4740_i2s_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params, struct snd_soc_dai *dai)
 {
 	struct jz4740_i2s *i2s = snd_soc_dai_get_drvdata(dai);
 	struct regmap_field *div_field;
+	unsigned long i2sdiv_max;
 	unsigned int sample_size;
-	uint32_t ctrl;
-	int div;
+	uint32_t ctrl, conf;
+	int div = 1;
 
 	regmap_read(i2s->regmap, JZ_REG_AIC_CTRL, &ctrl);
-
-	div = clk_get_rate(i2s->clk_i2s) / (64 * params_rate(params));
+	regmap_read(i2s->regmap, JZ_REG_AIC_CONF, &conf);
 
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S8:
@@ -258,11 +288,27 @@ static int jz4740_i2s_hw_params(struct snd_pcm_substream *substream,
 			ctrl &= ~JZ_AIC_CTRL_MONO_TO_STEREO;
 
 		div_field = i2s->field_i2sdiv_playback;
+		i2sdiv_max = GENMASK(i2s->soc_info->field_i2sdiv_playback.msb,
+				     i2s->soc_info->field_i2sdiv_playback.lsb);
 	} else {
 		ctrl &= ~JZ_AIC_CTRL_INPUT_SAMPLE_SIZE;
 		ctrl |= FIELD_PREP(JZ_AIC_CTRL_INPUT_SAMPLE_SIZE, sample_size);
 
 		div_field = i2s->field_i2sdiv_capture;
+		i2sdiv_max = GENMASK(i2s->soc_info->field_i2sdiv_capture.msb,
+				     i2s->soc_info->field_i2sdiv_capture.lsb);
+	}
+
+	/*
+	 * Only calculate I2SDIV if we're supplying the bit or frame clock.
+	 * If the codec is supplying both clocks then the divider output is
+	 * unused, and we don't want it to limit the allowed sample rates.
+	 */
+	if (conf & (JZ_AIC_CONF_BIT_CLK_MASTER | JZ_AIC_CONF_SYNC_CLK_MASTER)) {
+		div = jz4740_i2s_get_i2sdiv(clk_get_rate(i2s->clk_i2s),
+					    params_rate(params), i2sdiv_max);
+		if (div < 0)
+			return div;
 	}
 
 	regmap_write(i2s->regmap, JZ_REG_AIC_CTRL, ctrl);
-- 
2.39.2



