Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168A3ACA41;
	Wed,  8 Apr 2026 18:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672509; cv=none; b=CVoiu3vpRJTL/5fnQHZjtby5XikmKq3FVjP4lHBWMco0QZDfIjEgF7iYg1dQRjQX69kxWwjle6EO+gGCNn6x6K3etdpL90ForGccp2vu3Q5cj1RzCHONND9niolyPneOBnWHKItmGS7qxXsX5lUr5QB4LnJyxxtyViTibU9B/YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672509; c=relaxed/simple;
	bh=W/TSDni4HC5gN81YEZ6bojk89bw4nvKT+cx4X34zppI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/x4Ch7DidXrYEoLyBvcTqfT9UiAoCYEaTf30Z0uiYii1ljEhxzTU1tBO1CNIh4SyokRto7S9+ve38dB5QAkd+INOhrwXlqLd7RYC9FeBR7Jpq1weK+M1CmdCNjktBpqSD5fpp36YzCSNlLzQEMjDHvKiyFZh6PzQHjtVYnlMng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMzwbU6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMzwbU6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE778C19421;
	Wed,  8 Apr 2026 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672509;
	bh=W/TSDni4HC5gN81YEZ6bojk89bw4nvKT+cx4X34zppI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMzwbU6wHK7jzLAtV3PQj2WQQXU9hK+fII+ilrjyDzrZzEyiMhWj9lqVrdJ4ZCR/r
	 Ft9PPNQzthM6Ow9lBL+qhSW+H4/gHvzAMD19NDT8eFITYIVBqnyFiZy28QaD4k4NwL
	 cm7tCrCpah/GKJdf+ba/jSq1oALPfaO3M226x3i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/160] ASoC: ep93xx: Fix unchecked clk_prepare_enable() and add rollback on failure
Date: Wed,  8 Apr 2026 20:01:54 +0200
Message-ID: <20260408175914.224859019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 622363757b2286dd2c2984b0d80255cbb35a0495 ]

ep93xx_i2s_enable() calls clk_prepare_enable() on three clocks in
sequence (mclk, sclk, lrclk) without checking the return value of any
of them. If an intermediate enable fails, the clocks that were already
enabled are never rolled back, leaking them until the next disable cycle
— which may never come if the stream never started cleanly.

Change ep93xx_i2s_enable() from void to int. Add error checking after
each clk_prepare_enable() call and unwind already-enabled clocks on
failure. Propagate the error through ep93xx_i2s_startup() and
ep93xx_i2s_resume(), both of which already return int.

Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Fixes: f4ff6b56bc8a ("ASoC: cirrus: i2s: Prepare clock before using it")
Link: https://patch.msgid.link/20260324210909.45494-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/cirrus/ep93xx-i2s.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/sound/soc/cirrus/ep93xx-i2s.c b/sound/soc/cirrus/ep93xx-i2s.c
index 522de4b802939..a13fb1243379e 100644
--- a/sound/soc/cirrus/ep93xx-i2s.c
+++ b/sound/soc/cirrus/ep93xx-i2s.c
@@ -105,16 +105,28 @@ static inline unsigned ep93xx_i2s_read_reg(struct ep93xx_i2s_info *info,
 	return __raw_readl(info->regs + reg);
 }
 
-static void ep93xx_i2s_enable(struct ep93xx_i2s_info *info, int stream)
+static int ep93xx_i2s_enable(struct ep93xx_i2s_info *info, int stream)
 {
 	unsigned base_reg;
+	int err;
 
 	if ((ep93xx_i2s_read_reg(info, EP93XX_I2S_TX0EN) & 0x1) == 0 &&
 	    (ep93xx_i2s_read_reg(info, EP93XX_I2S_RX0EN) & 0x1) == 0) {
 		/* Enable clocks */
-		clk_prepare_enable(info->mclk);
-		clk_prepare_enable(info->sclk);
-		clk_prepare_enable(info->lrclk);
+		err = clk_prepare_enable(info->mclk);
+		if (err)
+			return err;
+		err = clk_prepare_enable(info->sclk);
+		if (err) {
+			clk_disable_unprepare(info->mclk);
+			return err;
+		}
+		err = clk_prepare_enable(info->lrclk);
+		if (err) {
+			clk_disable_unprepare(info->sclk);
+			clk_disable_unprepare(info->mclk);
+			return err;
+		}
 
 		/* Enable i2s */
 		ep93xx_i2s_write_reg(info, EP93XX_I2S_GLCTRL, 1);
@@ -133,6 +145,8 @@ static void ep93xx_i2s_enable(struct ep93xx_i2s_info *info, int stream)
 		ep93xx_i2s_write_reg(info, EP93XX_I2S_TXCTRL,
 				     EP93XX_I2S_TXCTRL_TXEMPTY_LVL |
 				     EP93XX_I2S_TXCTRL_TXUFIE);
+
+	return 0;
 }
 
 static void ep93xx_i2s_disable(struct ep93xx_i2s_info *info, int stream)
@@ -214,9 +228,7 @@ static int ep93xx_i2s_startup(struct snd_pcm_substream *substream,
 {
 	struct ep93xx_i2s_info *info = snd_soc_dai_get_drvdata(dai);
 
-	ep93xx_i2s_enable(info, substream->stream);
-
-	return 0;
+	return ep93xx_i2s_enable(info, substream->stream);
 }
 
 static void ep93xx_i2s_shutdown(struct snd_pcm_substream *substream,
@@ -392,14 +404,16 @@ static int ep93xx_i2s_suspend(struct snd_soc_component *component)
 static int ep93xx_i2s_resume(struct snd_soc_component *component)
 {
 	struct ep93xx_i2s_info *info = snd_soc_component_get_drvdata(component);
+	int err;
 
 	if (!snd_soc_component_active(component))
 		return 0;
 
-	ep93xx_i2s_enable(info, SNDRV_PCM_STREAM_PLAYBACK);
-	ep93xx_i2s_enable(info, SNDRV_PCM_STREAM_CAPTURE);
+	err = ep93xx_i2s_enable(info, SNDRV_PCM_STREAM_PLAYBACK);
+	if (err)
+		return err;
 
-	return 0;
+	return ep93xx_i2s_enable(info, SNDRV_PCM_STREAM_CAPTURE);
 }
 #else
 #define ep93xx_i2s_suspend	NULL
-- 
2.53.0



