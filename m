Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6673D75AB;
	Wed, 20 May 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300521; cv=none; b=LzpknBzG6OzL9C94ROKcjyTf55CHgMCkwZSCFfnwwkBiZCMeDpQ67OgY8awF7nTwbObBWgK5X1mUkL6En2k09f4iTZNcyypYyST80EgVB31HOXQOXFz9XAyOL2MvYxIdTi+SDK6uaSw+wvStM8a53WlVrokNy7PaOqSQOVBunBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300521; c=relaxed/simple;
	bh=3/SisJg8WoSMiEOVAIa+e5+iaRXnt7UjgIUCFgVpqLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJoNzPz2nUqVdBcCcXxg/uGzn9AQO/erolJx1c8LcV8EZEWaCVcOJ6moudbB8ZNye3XaM9DFeoTu0SCJE3DZ187iaOMBEzEF9+UoiaLTRgZLKgskkCyhk6YmsusIXdidQ1K9T6CwkbqoflpSkDnd0ctETkj1h4kEq7/xuxq9pMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KUJCkF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KUJCkF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15191F000E9;
	Wed, 20 May 2026 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300520;
	bh=RtjSPu1FSamrGTirMFaEru21qg/Arsbnylb63uCgClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KUJCkF3Ifm2JbiCVamXSiX2NrNriV+oVbQwMZOcdUhqd8C9GKm0bk5Hxvb9fLjXq
	 1bQhMrWe8ZJrgU/KPofT/BmxEnShq2LGqF2IytBSvo9FXtC/bKAp48mIgAddQJblpk
	 CW0ETzntORBlmzlVnEcwHdmGKkPux9R24AihJnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/666] ASoC: fsl_xcvr: Fix event generation in fsl_xcvr_mode_put()
Date: Wed, 20 May 2026 18:16:55 +0200
Message-ID: <20260520162115.627017395@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index cae42d919f930..a042bae63ab34 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -218,10 +218,17 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
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
@@ -231,7 +238,7 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 	rtd = snd_soc_get_pcm_runtime(card, card->dai_link);
 	rtd->pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream_count =
 		(xcvr->mode == FSL_XCVR_MODE_SPDIF ? 1 : 0);
-	return 0;
+	return ret;
 }
 
 static int fsl_xcvr_mode_get(struct snd_kcontrol *kcontrol,
-- 
2.53.0



