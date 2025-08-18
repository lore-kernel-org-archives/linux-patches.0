Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4491335BC1;
	Mon, 18 Aug 2025 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525197; cv=none; b=c7tnJ42KXyknxhQ3r72d0g+jxSAdDTS6H6/N3wsWxffmr0W9IGQhexA+f00H2ke7m7wC26OURfs0SRfTg4hCwiGsu6niEHht0a1kL92SHBD45qrjgmIibOEL4BSbzI2zEda8ZYuqeNw1CgNYj9tVtIUJJyxuXoKCw9wDhxCId98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525197; c=relaxed/simple;
	bh=RPvHU3cqLa+syShMlcHIGjp/GoAtua2pl88J9jL827E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVAnOx3l7lWeGZfKJTQIsmabP/tFFIG65rVZlfvrwDZ5I280LQsd2ZItlD5clPz9+GfESPfHmQvGZPE00GdpjtuXpKkUdgYtSAGl7evQapPRe11HSZPvbaG7V2N2ulhbbcZPmZcpao7WPDnsJpV7b9sRAUsGm9YW1A+1mk7BSYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdhhXxV0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdhhXxV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659BAC116C6;
	Mon, 18 Aug 2025 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525196;
	bh=RPvHU3cqLa+syShMlcHIGjp/GoAtua2pl88J9jL827E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdhhXxV0UnVKtW2KMPAylV6m8BcxJ8eYWGKukKeTR6SOHOoz+ay+fgAF6+Ldd/fWm
	 0UzTGx9ALD2Jm81onxhHTX57jDIiXs295thInIuVjMLOQymi3edHzvj07V8ChMbs00
	 EEe16S8cug0XHLaQBOymQa0izB2iVczIQKY0//Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 188/570] ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode
Date: Mon, 18 Aug 2025 14:42:55 +0200
Message-ID: <20250818124513.049982940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6b3cb7f4341cbf62d41ccf6ea906dbe66be8aa3d ]

Parsing the dapm_widget_tokens is also needed for DSPless mode as it is
setting the snd_soc_dapm_widget.no_wname_in_kcontrol_name flag for the
kcontrol creation from DAPM widgets.
Without that flag set, the following warnings might appear because of long
control names:
ALSA: Control name 'eqiir.2.1 Post Mixer Analog Playback IIR Eq bytes' truncated to 'eqiir.2.1 Post Mixer Analog Playback IIR Eq'
ALSA: Control name 'eqfir.2.1 Post Mixer Analog Playback FIR Eq bytes' truncated to 'eqfir.2.1 Post Mixer Analog Playback FIR Eq'
ALSA: Control name 'drc.2.1 Post Mixer Analog Playback DRC bytes' truncated to 'drc.2.1 Post Mixer Analog Playback DRC byte'
ALSA: Control name 'drc.2.1 Post Mixer Analog Playback DRC switch' truncated to 'drc.2.1 Post Mixer Analog Playback DRC swit'
ALSA: Control name 'gain.15.1 Pre Mixer Deepbuffer HDA Analog Volume' truncated to 'gain.15.1 Pre Mixer Deepbuffer HDA Analog V'

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20250619102640.12068-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index d612d693efc3..b6d5c8024f8c 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2378,14 +2378,25 @@ static int sof_dspless_widget_ready(struct snd_soc_component *scomp, int index,
 				    struct snd_soc_dapm_widget *w,
 				    struct snd_soc_tplg_dapm_widget *tw)
 {
+	struct snd_soc_tplg_private *priv = &tw->priv;
+	int ret;
+
+	/* for snd_soc_dapm_widget.no_wname_in_kcontrol_name */
+	ret = sof_parse_tokens(scomp, w, dapm_widget_tokens,
+			       ARRAY_SIZE(dapm_widget_tokens),
+			       priv->array, le32_to_cpu(priv->size));
+	if (ret < 0) {
+		dev_err(scomp->dev, "failed to parse dapm widget tokens for %s\n",
+			w->name);
+		return ret;
+	}
+
 	if (WIDGET_IS_DAI(w->id)) {
 		static const struct sof_topology_token dai_tokens[] = {
 			{SOF_TKN_DAI_TYPE, SND_SOC_TPLG_TUPLE_TYPE_STRING, get_token_dai_type, 0}};
 		struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
-		struct snd_soc_tplg_private *priv = &tw->priv;
 		struct snd_sof_widget *swidget;
 		struct snd_sof_dai *sdai;
-		int ret;
 
 		swidget = kzalloc(sizeof(*swidget), GFP_KERNEL);
 		if (!swidget)
-- 
2.39.5



