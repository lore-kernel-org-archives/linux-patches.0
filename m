Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF691CAA82;
	Wed, 19 Feb 2025 09:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956597; cv=none; b=SEqZQ2xaLyDTukFDpDXUSjfoMtPK0WKMOVrnfjtwsc+CA5G6IbKxxoasNPw9kHSBjWQg0iDPF8MVGsCcriO1Kinh0QdtPoT8N4FjbbcCW0Sj6YSUb89muSazjapLXOEYPGsz6QEJlKJvPaC7wew2aq/wOfyyfOqH1Gg00qQu0V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956597; c=relaxed/simple;
	bh=5/OsQU/BU/NG06+gS/yEk0C/iVEg8Wvlp5GDPNQLy34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbBCPmhp4USBz21LQ2Grpsgc0YMV4/Xhfu6IGTnONCrX0442NDPECX98beBQ/jxuo2AYmBoWz2l1tjIXdjr7V8kJPEqd3KuwzYj8x9naWKMAAC/nhFwzKtTCe0n0T5a7fMPes2UhUocrZ3PYLO3dy2PRo/QbGdpuAMgYdvdmvSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmMsz4ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmMsz4ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D59C4CED1;
	Wed, 19 Feb 2025 09:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956597;
	bh=5/OsQU/BU/NG06+gS/yEk0C/iVEg8Wvlp5GDPNQLy34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmMsz4ll8ZtY+ZTYLmS7Uquf3jA/JNeHOCTIqWo938udOoI+p1c3sw+CHkZXw2Jng
	 gVNR5L/rAD6g6byqguFAuJNY14ol/FXTJ8cFI7b+DbAMow7vB9ZCfqIg0DIIQ9IECU
	 pWVkiHUe/mAa/ghtEzfONkvYRhVtIc3ll4idDbJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/578] ASoC: rockchip: i2s_tdm: Re-add the set_sysclk callback
Date: Wed, 19 Feb 2025 09:23:57 +0100
Message-ID: <20250219082702.211145557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 5323186e2e8d33c073fad51e24f18e2d6dbae2da ]

In commit
9e2ab4b18ebd ("ASoC: rockchip: i2s-tdm: Fix inaccurate sampling rates"),
the set_sysclk callback was removed as considered unused as the mclk rate
can be set in the hw_params callback.
The difference between hw_params and set_sysclk is that the former is
called with the audio sampling rate set in the params (e.g.: 48000 Hz)
while the latter is called with a clock rate already computed with
  sampling_rate * mclk-fs (e.g.: 48000 * 256)

For HDMI audio using the Rockchip I2S TDM driver, the mclk-fs value must
be set to 128 instead of the default 256, and that value is set in the
device tree at the machine driver level (like a simple-audio-card
compatible node).
Therefore, the i2s_tdm driver has no idea that another mclk-fs value can
be configured and simply computes the mclk rate in the hw_params callback
with DEFAULT_MCLK_FS * params_rate(params), which is wrong for HDMI
audio.

Re-add the set_sysclk callback so that the mclk rate is computed by the
machine driver which has the correct mclk-fs value set in its device tree
node.

Fixes: 9e2ab4b18ebd ("ASoC: rockchip: i2s-tdm: Fix inaccurate sampling rates")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Link: https://patch.msgid.link/20250117163102.65807-1-detlev.casanova@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c | 31 +++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s_tdm.c b/sound/soc/rockchip/rockchip_i2s_tdm.c
index bcea52fa45a50..d20438cf8fc4a 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -24,7 +24,6 @@
 
 #define DRV_NAME "rockchip-i2s-tdm"
 
-#define DEFAULT_MCLK_FS				256
 #define CH_GRP_MAX				4  /* The max channel 8 / 2 */
 #define MULTIPLEX_CH_MAX			10
 
@@ -72,6 +71,8 @@ struct rk_i2s_tdm_dev {
 	bool has_playback;
 	bool has_capture;
 	struct snd_soc_dai_driver *dai;
+	unsigned int mclk_rx_freq;
+	unsigned int mclk_tx_freq;
 };
 
 static int to_ch_num(unsigned int val)
@@ -641,6 +642,27 @@ static int rockchip_i2s_trcm_mode(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+static int rockchip_i2s_tdm_set_sysclk(struct snd_soc_dai *cpu_dai, int stream,
+				       unsigned int freq, int dir)
+{
+	struct rk_i2s_tdm_dev *i2s_tdm = to_info(cpu_dai);
+
+	if (i2s_tdm->clk_trcm) {
+		i2s_tdm->mclk_tx_freq = freq;
+		i2s_tdm->mclk_rx_freq = freq;
+	} else {
+		if (stream == SNDRV_PCM_STREAM_PLAYBACK)
+			i2s_tdm->mclk_tx_freq = freq;
+		else
+			i2s_tdm->mclk_rx_freq = freq;
+	}
+
+	dev_dbg(i2s_tdm->dev, "The target mclk_%s freq is: %d\n",
+		stream ? "rx" : "tx", freq);
+
+	return 0;
+}
+
 static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
 				      struct snd_pcm_hw_params *params,
 				      struct snd_soc_dai *dai)
@@ -655,15 +677,19 @@ static int rockchip_i2s_tdm_hw_params(struct snd_pcm_substream *substream,
 
 		if (i2s_tdm->clk_trcm == TRCM_TX) {
 			mclk = i2s_tdm->mclk_tx;
+			mclk_rate = i2s_tdm->mclk_tx_freq;
 		} else if (i2s_tdm->clk_trcm == TRCM_RX) {
 			mclk = i2s_tdm->mclk_rx;
+			mclk_rate = i2s_tdm->mclk_rx_freq;
 		} else if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			mclk = i2s_tdm->mclk_tx;
+			mclk_rate = i2s_tdm->mclk_tx_freq;
 		} else {
 			mclk = i2s_tdm->mclk_rx;
+			mclk_rate = i2s_tdm->mclk_rx_freq;
 		}
 
-		err = clk_set_rate(mclk, DEFAULT_MCLK_FS * params_rate(params));
+		err = clk_set_rate(mclk, mclk_rate);
 		if (err)
 			return err;
 
@@ -822,6 +848,7 @@ static const struct snd_soc_dai_ops rockchip_i2s_tdm_dai_ops = {
 	.hw_params = rockchip_i2s_tdm_hw_params,
 	.set_bclk_ratio	= rockchip_i2s_tdm_set_bclk_ratio,
 	.set_fmt = rockchip_i2s_tdm_set_fmt,
+	.set_sysclk = rockchip_i2s_tdm_set_sysclk,
 	.set_tdm_slot = rockchip_dai_tdm_slot,
 	.trigger = rockchip_i2s_tdm_trigger,
 };
-- 
2.39.5



