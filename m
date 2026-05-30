Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4D333F8A2;
	Sat, 30 May 2026 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161152; cv=none; b=LbrQI0oZz53LdRpKwJFpT0/m2zs5Wpviz1FKwK3nBuYFA6sc5mWCneVbN3AZtEQhq/7sClG6DMTrwK7AoTjJGXPT3CsGRWYHZ5rl5m6wTxF1I4g77OsyG7B6dnshDsvBln6F0aUFixm32s8lFk1/2MYZ//DirWJRjuojRWJIh+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161152; c=relaxed/simple;
	bh=w1K5fyAAWcLR0x8VCgM0af/zu2CfQl2kteRkiakRR+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUXrFzpEXZiU5nGlIlKDSY4TJK+f+uL3OKoG99TYQe8JmPk56uFY27nx5z7ne9X/WpRGFsXhdARC7c5NEL7iadNoY1/w8dydkJL6qwZKJPAq9ydAcaM0tnLyctFz1DYTEy7kNowvJaIc8s1OkPZ3jYHg3AF+YK2LbEss7jZnRWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNGcbXLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNGcbXLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623361F00893;
	Sat, 30 May 2026 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161151;
	bh=SOD41RB4iGNqZRSf/FfH1pHD9We6458ZPyLZETWpgLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNGcbXLyUo7RUlWiKFQn/gzJRzcu0TL5yaHAyQ+nedswoSyYh80jeyJfVUpWHgT56
	 aETabz9cjXcdRGeAq2tK4XEy3jDTkjnitI0DLhd1bk7WU4/QOUj81Yd5+/vpoXgPWN
	 ygruSJYK5JUTyX9CDLt0yMPyrr8ByeW2VBy6LEBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 533/969] ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_mode_put()
Date: Sat, 30 May 2026 18:00:57 +0200
Message-ID: <20260530160315.086596932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 64a496ba976324615b845d60739dfcdae3d57434 ]

ALSA controls should return 1 if the value in the control changed but the
control put operation fsl_xcvr_mode_put() only returns 0 or a negative
error code, causing ALSA to not generate any change events.

Add a suitable check in the function before updating the mode variable.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-9-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 83b1d497fbf5f..513582d69bc15 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -205,10 +205,17 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 	struct fsl_xcvr *xcvr = snd_soc_dai_get_drvdata(dai);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int *item = ucontrol->value.enumerated.item;
+	int val = snd_soc_enum_item_to_val(e, item[0]);
 	struct snd_soc_card *card = dai->component->card;
 	struct snd_soc_pcm_runtime *rtd;
+	int ret;
+
+	if (val < FSL_XCVR_MODE_SPDIF || val > FSL_XCVR_MODE_EARC)
+		return -EINVAL;
 
-	xcvr->mode = snd_soc_enum_item_to_val(e, item[0]);
+	ret = (xcvr->mode != val);
+
+	xcvr->mode = val;
 
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_ARC));
@@ -218,7 +225,7 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 	rtd = snd_soc_get_pcm_runtime(card, card->dai_link);
 	rtd->pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream_count =
 		(xcvr->mode == FSL_XCVR_MODE_SPDIF ? 1 : 0);
-	return 0;
+	return ret;
 }
 
 static int fsl_xcvr_mode_get(struct snd_kcontrol *kcontrol,
-- 
2.53.0



