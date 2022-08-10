Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8017EC
	for <patches@lists.linux.dev>; Wed, 10 Aug 2022 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC61C433C1
	for <patches@lists.linux.dev>; Wed, 10 Aug 2022 13:02:17 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 10 Aug 2022 14:02:14 +0100
Resent-Message-ID: <YvOsVu3h1I4LEE9Y@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 10 Aug 2022 11:42:10 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=g+OE=YO=pengutronix.de=p.zabel@kernel.org>)
	id 1oLjA8-008PKD-9E
	for broonie@sirena.co.uk; Wed, 10 Aug 2022 11:42:10 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 2021D611E9
	for <broonie@sirena.co.uk>; Wed, 10 Aug 2022 10:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 94971C433D7; Wed, 10 Aug 2022 10:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB3DDC433D6
	for <broonie@kernel.org>; Wed, 10 Aug 2022 10:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org EB3DDC433D6
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
	by metis.ext.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <p.zabel@pengutronix.de>)
	id 1oLjA1-0004mL-Cw; Wed, 10 Aug 2022 12:42:01 +0200
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Sia Jee Heng <jee.heng.sia@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	alsa-devel@alsa-project.org,
	kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Date: Wed, 10 Aug 2022 12:41:56 +0200
Message-Id: <20220810104156.665452-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-PTX-Original-Recipient: broonie@kernel.org
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=g+OE=YO=pengutronix.de=p.zabel@kernel.org
Subject: [PATCH] ASoC: codec: tlv320aic32x4: fix mono playback via I2S
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: fHtxNcHRRJ2v

The two commits referenced below break mono playback via I2S DAI because
they set BCLK to half the required speed. For PCM transport over I2S, the
number of transmitted channels is always 2, even for mono playback.

Fixes: dcd79364bff3 ("ASoC: codec: tlv3204: Enable 24 bit audio support")
Fixes: 40b37136287b ("ASoC: tlv320aic32x4: Fix bdiv clock rate derivation")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 sound/soc/codecs/tlv320aic32x4.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 4b74805cdd2e..ffe1828a4b7e 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -49,6 +49,8 @@ struct aic32x4_priv {
 	struct aic32x4_setup_data *setup;
 	struct device *dev;
 	enum aic32x4_type type;
+
+	unsigned int fmt;
 };
 
 static int aic32x4_reset_adc(struct snd_soc_dapm_widget *w,
@@ -611,6 +613,7 @@ static int aic32x4_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_component *component = codec_dai->component;
+	struct aic32x4_priv *aic32x4 = snd_soc_component_get_drvdata(component);
 	u8 iface_reg_1 = 0;
 	u8 iface_reg_2 = 0;
 	u8 iface_reg_3 = 0;
@@ -653,6 +656,8 @@ static int aic32x4_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
+	aic32x4->fmt = fmt;
+
 	snd_soc_component_update_bits(component, AIC32X4_IFACE1,
 				AIC32X4_IFACE1_DATATYPE_MASK |
 				AIC32X4_IFACE1_MASTER_MASK, iface_reg_1);
@@ -757,6 +762,10 @@ static int aic32x4_setup_clocks(struct snd_soc_component *component,
 		return -EINVAL;
 	}
 
+	/* PCM over I2S is always 2-channel */
+	if ((aic32x4->fmt & SND_SOC_DAIFMT_FORMAT_MASK) == SND_SOC_DAIFMT_I2S)
+		channels = 2;
+
 	madc = DIV_ROUND_UP((32 * adc_resource_class), aosr);
 	max_dosr = (AIC32X4_MAX_DOSR_FREQ / sample_rate / dosr_increment) *
 			dosr_increment;

base-commit: afb176d45870048eea540991b082208270824037
-- 
2.30.2

