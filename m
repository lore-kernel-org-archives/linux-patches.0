Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF30425A321;
	Wed,  8 Apr 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674350; cv=none; b=AyLooJtViMUV2gjxGObGHTOx028dve8DkM1G5o1LFUnANDotLTSf7KiQvJJs8aRNYwExqgeUgYyyTo3WH08U2SzvTGcFaaD3xtcOB9gLYmofp1o4FD5mxfK9BKYCZX7H5i0xKKd5JbiJeN0OSlAPxyZdZs5tEeX/wyvIqcZuwQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674350; c=relaxed/simple;
	bh=+1C3OCJQLG9uhCR4l2qiG54lShbSasjlb+5jov8QWtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxIwFt+vseOXAW/6bzCQ7QwSuxCQO+TRO2qFHt/AkaT/969Ez1pZIldizoNr70XqVJWHfooo+Z8byWLZqmZuNQR1fmkulzVADQlpbp/UsoymL9vPB2hTstGw89tKykM7G3aluNz14HsKEBfEB8v57EwpD8QyQp2A1luCvZhWNC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWhnCCsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWhnCCsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449E7C19421;
	Wed,  8 Apr 2026 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674350;
	bh=+1C3OCJQLG9uhCR4l2qiG54lShbSasjlb+5jov8QWtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWhnCCsgSGaf1OVK/mlEuKh8QBUZBYW/YKZ5KOjul/djQoowv75Hb5mk59FQOnjPG
	 oN+2Rs1W31fmFUaeKc4VzoauqMp/vx2nJcj+Mf9+NfQbjyjPHlXu1r8r6UI+GBqm8u
	 1OssmI6AJnMTIb3VJtp7OBYz9o+rTpU363kE7d3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 062/311] ASoC: ep93xx: Fix unchecked clk_prepare_enable() and add rollback on failure
Date: Wed,  8 Apr 2026 20:01:02 +0200
Message-ID: <20260408175941.731390045@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index cca01c03f0486..5dba741594fab 100644
--- a/sound/soc/cirrus/ep93xx-i2s.c
+++ b/sound/soc/cirrus/ep93xx-i2s.c
@@ -91,16 +91,28 @@ static inline unsigned ep93xx_i2s_read_reg(struct ep93xx_i2s_info *info,
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
@@ -119,6 +131,8 @@ static void ep93xx_i2s_enable(struct ep93xx_i2s_info *info, int stream)
 		ep93xx_i2s_write_reg(info, EP93XX_I2S_TXCTRL,
 				     EP93XX_I2S_TXCTRL_TXEMPTY_LVL |
 				     EP93XX_I2S_TXCTRL_TXUFIE);
+
+	return 0;
 }
 
 static void ep93xx_i2s_disable(struct ep93xx_i2s_info *info, int stream)
@@ -195,9 +209,7 @@ static int ep93xx_i2s_startup(struct snd_pcm_substream *substream,
 {
 	struct ep93xx_i2s_info *info = snd_soc_dai_get_drvdata(dai);
 
-	ep93xx_i2s_enable(info, substream->stream);
-
-	return 0;
+	return ep93xx_i2s_enable(info, substream->stream);
 }
 
 static void ep93xx_i2s_shutdown(struct snd_pcm_substream *substream,
@@ -373,14 +385,16 @@ static int ep93xx_i2s_suspend(struct snd_soc_component *component)
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



