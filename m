Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA341ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2837C433C8;
	Tue, 25 Jul 2023 11:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283805;
	bh=4fwhpFrpetu8aLX26AzW8PjLCWr+6InK6eiPlU8RxQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBBKnpN+w0LwRBZSA/F+wnFeUKRT4Xsau2rs+duJIHxTQj18rC51kUPBFtMe3L5DV
	 IwYzLgPKcjfZz4roHpy1Kc1taPH3SjlaAxE775QhWPNqPz4N4F7PYrminZnMwLDVL/
	 uejrNDN6xeisYpqB+wcc6HXaj/WsOU2+8NPlFCjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/509] ASoC: es8316: Increment max value for ALC Capture Target Volume control
Date: Tue, 25 Jul 2023 12:41:08 +0200
Message-ID: <20230725104559.601008938@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 6f073429037cd79d7311cd8236311c53f5ea8f01 ]

The following error occurs when trying to restore a previously saved
ALSA mixer state (tested on a Rock 5B board):

  $ alsactl --no-ucm -f /tmp/asound.state store hw:Analog
  $ alsactl --no-ucm -I -f /tmp/asound.state restore hw:Analog
  alsactl: set_control:1475: Cannot write control '2:0:0:ALC Capture Target Volume:0' : Invalid argument

According to ES8316 datasheet, the register at address 0x2B, which is
related to the above mixer control, contains by default the value 0xB0.
Considering the corresponding ALC target bits (ALCLVL) are 7:4, the
control is initialized with 11, which is one step above the maximum
value allowed by the driver:

 ALCLVL | dB gain
 -------+--------
  0000  |  -16.5
  0001  |  -15.0
  0010  |  -13.5
  ....  |  .....
  0111  |   -6.0
  1000  |   -4.5
  1001  |   -3.0
  1010  |   -1.5
  ....  |  .....
  1111  |   -1.5

The tests performed using the VU meter feature (--vumeter=TYPE) of
arecord/aplay confirm the specs are correct and there is no measured
gain if the 1011-1111 range would have been mapped to 0 dB:

 dB gain | VU meter %
 --------+-----------
   -6.0  |  30-31
   -4.5  |  35-36
   -3.0  |  42-43
   -1.5  |  50-51
    0.0  |  50-51

Increment the max value allowed for ALC Capture Target Volume control,
so that it matches the hardware default.  Additionally, update the
related TLV to prevent an artificial extension of the dB gain range.

Fixes: b8b88b70875a ("ASoC: add es8316 codec driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230530181140.483936-2-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index bc3d46617a113..423d9ce2df266 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -52,7 +52,12 @@ static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(dac_vol_tlv, -9600, 50, 1);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(adc_vol_tlv, -9600, 50, 1);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_max_gain_tlv, -650, 150, 0);
 static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_min_gain_tlv, -1200, 150, 0);
-static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(alc_target_tlv, -1650, 150, 0);
+
+static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(alc_target_tlv,
+	0, 10, TLV_DB_SCALE_ITEM(-1650, 150, 0),
+	11, 11, TLV_DB_SCALE_ITEM(-150, 0, 0),
+);
+
 static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(hpmixer_gain_tlv,
 	0, 4, TLV_DB_SCALE_ITEM(-1200, 150, 0),
 	8, 11, TLV_DB_SCALE_ITEM(-450, 150, 0),
@@ -115,7 +120,7 @@ static const struct snd_kcontrol_new es8316_snd_controls[] = {
 		       alc_max_gain_tlv),
 	SOC_SINGLE_TLV("ALC Capture Min Volume", ES8316_ADC_ALC2, 0, 28, 0,
 		       alc_min_gain_tlv),
-	SOC_SINGLE_TLV("ALC Capture Target Volume", ES8316_ADC_ALC3, 4, 10, 0,
+	SOC_SINGLE_TLV("ALC Capture Target Volume", ES8316_ADC_ALC3, 4, 11, 0,
 		       alc_target_tlv),
 	SOC_SINGLE("ALC Capture Hold Time", ES8316_ADC_ALC3, 0, 10, 0),
 	SOC_SINGLE("ALC Capture Decay Time", ES8316_ADC_ALC4, 4, 10, 0),
-- 
2.39.2



