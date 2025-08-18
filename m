Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138E32135CE;
	Mon, 18 Aug 2025 13:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523443; cv=none; b=rEEnpT+YNUpH3OHQozJlO55bo3CafVbe4XXSAB0rw1Dhew1bNQld0GYtC7JWIH6Bay32rPqp/M7lhDe8z5632oh8Ekj4KKcJb47z1dVafWkxDO/tivLLTILwERGQWu/iJ9EBYVkoSivi/nJ28wqsRTtTtjkWsFyJYH+RBd0qNWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523443; c=relaxed/simple;
	bh=/J3hqniTaRoMqxQTS4UqviSgLpzDyilYx7uwD28N98I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjKu8rNe8Cx5iP7QT69U/WzIvFQ3WTBkCgvni6BsE+VHokuyTXhm2W0mmKY0OCyC8Oc/oSJ46WiY9nHuFw+7oTan1f32IoS8WIqk9N3qO0gaXrhJxAS5XIoV1AHs+Iq4kCOt8095zdCsKj6zobCxpoWk/HOElQ723+t/Ra7s9Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/QLPnxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/QLPnxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7588EC4CEEB;
	Mon, 18 Aug 2025 13:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523442;
	bh=/J3hqniTaRoMqxQTS4UqviSgLpzDyilYx7uwD28N98I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/QLPnxXHod6qXb+d0v/BR2p1EKlo6xMQrQW0JCKQVR65MqXN31WbR/VPf5KIscGo
	 S/Xi+PrBdcWNR/HttFYFfH5MwZ7x6iJbQiw7w2VkK6VM5gHsSBcGk0zWGgAlLahCrA
	 SfbTu9KNjV5JPNP4N7pl097DdVV5viTHRfiyTYMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 172/515] ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode
Date: Mon, 18 Aug 2025 14:42:38 +0200
Message-ID: <20250818124504.986357325@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 14aa8ecc4bc4..554808d2dc29 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2368,14 +2368,25 @@ static int sof_dspless_widget_ready(struct snd_soc_component *scomp, int index,
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



