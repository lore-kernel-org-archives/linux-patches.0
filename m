Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8856E3AA196;
	Wed,  3 Dec 2025 16:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779582; cv=none; b=mLybv7ssV8tsyN++P4hXn06JXn6a/dAkNAfP2ZQXM4xo1EV47c2zd7kxU1OHANVHfrt7Lb3n+PJoj+fP+a/Cj5SPt8n3LshTNVEhq5U8sZ1CYkeDKN7+sGAwUC4Pp1UVYwMaNl5Iavm7TKwLe6GjNBccWVxUxHM262QMlYl3gyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779582; c=relaxed/simple;
	bh=Ni5CDvub3hp4YP09K+9OEOsC74ouwrJSmrTdSE6AWSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4S5WA42CmJTUyr9LxmN3baVVfd1+Hy5Ud1c1HC9HkN6Z429xxkBo0amqyoNNLl/KmA6Ebu93MC4MMeBmHt7hU7RhKvmY/kavvr6XGI7OsQGR23/RNlCRYFXCf8ZCOS608N12TxL6TwTnEvA4+qxdD6LLzA81jSdp2A0VERlcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oC97QnvN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oC97QnvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D2DC4CEF5;
	Wed,  3 Dec 2025 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779582;
	bh=Ni5CDvub3hp4YP09K+9OEOsC74ouwrJSmrTdSE6AWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC97QnvNdLccdE+LSgNPsSmSgZyfAe9CPaql9Dp9/JB3mYjCP93zihrp4+WqKJSi+
	 NAo5qi4FsGDk0ZQmQHMwF1GZHzGd95LH34DiTn4WC0XA/ElVHWhgEh66+1yZikhzwL
	 jQeHYsTZebYApA3p+PnLtekOmxewbzzzsVVUmdjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valerio Setti <vsetti@baylibre.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 300/568] ASoC: meson: aiu-encoder-i2s: fix bit clock polarity
Date: Wed,  3 Dec 2025 16:25:02 +0100
Message-ID: <20251203152451.694777635@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valerio Setti <vsetti@baylibre.com>

[ Upstream commit 4c4ed5e073a923fb3323022e1131cb51ad8df7a0 ]

According to I2S specs audio data is sampled on the rising edge of the
clock and it can change on the falling one. When operating in normal mode
this SoC behaves the opposite so a clock polarity inversion is required
in this case.

This was tested on an OdroidC2 (Amlogic S905 SoC) board.

Signed-off-by: Valerio Setti <vsetti@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20251007-fix-i2s-polarity-v1-1-86704d9cda10@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/aiu-encoder-i2s.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/sound/soc/meson/aiu-encoder-i2s.c b/sound/soc/meson/aiu-encoder-i2s.c
index a0dd914c8ed13..3b4061508c180 100644
--- a/sound/soc/meson/aiu-encoder-i2s.c
+++ b/sound/soc/meson/aiu-encoder-i2s.c
@@ -236,8 +236,12 @@ static int aiu_encoder_i2s_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	    inv == SND_SOC_DAIFMT_IB_IF)
 		val |= AIU_CLK_CTRL_LRCLK_INVERT;
 
-	if (inv == SND_SOC_DAIFMT_IB_NF ||
-	    inv == SND_SOC_DAIFMT_IB_IF)
+	/*
+	 * The SoC changes data on the rising edge of the bitclock
+	 * so an inversion of the bitclock is required in normal mode
+	 */
+	if (inv == SND_SOC_DAIFMT_NB_NF ||
+	    inv == SND_SOC_DAIFMT_NB_IF)
 		val |= AIU_CLK_CTRL_AOCLK_INVERT;
 
 	/* Signal skew */
@@ -328,4 +332,3 @@ const struct snd_soc_dai_ops aiu_encoder_i2s_dai_ops = {
 	.startup	= aiu_encoder_i2s_startup,
 	.shutdown	= aiu_encoder_i2s_shutdown,
 };
-
-- 
2.51.0



