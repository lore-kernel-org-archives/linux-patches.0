Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82481D798E;
	Mon,  4 Aug 2025 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267429; cv=none; b=MtZ2miflD6MHzViXHC/jg20jEGwxrUDusCxdWJIPJeDbaFEDiS3t6F4oEfUd7ZzPwHAi2tjDptjXOdhCYZ6+tBrwswfAW+01iBMzDSDcorInHIbJkIK9sSy23s8lxGHJn2zZMo33m2rFu9V/0nuPRml59FqDLyiqS66y0bu45s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267429; c=relaxed/simple;
	bh=Tvg5gRepqZ2F4XL2BYiUV42vxng1qJOitsO0xESShHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e4DtF8wgBY2qwnYPa4l6+c9TpsFxVfi7cmC7lZRMtpOzxtMxfQ5Cpzrz82Lw0ckzu64+UHtzzHxZTe3Ab/SSTGTtr1Hq7oVR+CdrgCsh+vygxT81Dz5Jpz70uvkaeUn3oo4cHOpa5zc89ykrcoMlbNApq4GM1CDkCu3CRHA/1QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbKN77ID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbKN77ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF894C4CEEB;
	Mon,  4 Aug 2025 00:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267429;
	bh=Tvg5gRepqZ2F4XL2BYiUV42vxng1qJOitsO0xESShHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbKN77IDaF/PcQn15YptmkCvVnBJrkE0uUyMrGN2dmT0zn1c/MLR9P6YNCQkuBToT
	 L+C4ZhtvRGNXuqGkS+sIegJCGylDQmfHzF+ENPw8SBFuJD7VFcIFVql76lTh0CMAA3
	 MhlTiY4P1FBp1OuQ3tcdnbOaNm4p+t94DkcPDRn/dwJdIsEuMO515GQpQGqGBcZNG8
	 UTDHRbxqIRv8xTAbZXNVqoI7RpCARLJE/ipTKQsJatiOQB94tSRV93U0XJSt4f/G+c
	 Tv+ej3zUSwP7ITYWx1s5jKKPozNHynLbCeG5CtpOnDNU4iqiyF/tizouKTSzBWbD5z
	 4sM5atrbCw68g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	yung-chuan.liao@linux.intel.com,
	daniel.baluta@nxp.com,
	sound-open-firmware@alsa-project.org
Subject: [PATCH AUTOSEL 6.15 63/80] ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode
Date: Sun,  3 Aug 2025 20:27:30 -0400
Message-Id: <20250804002747.3617039-63-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002747.3617039-1-sashal@kernel.org>
References: <20250804002747.3617039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.9
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix**: This commit fixes a functional bug in DSPless mode where
   control names are being truncated due to excessive length. The
   warnings shown in the commit message indicate real issues that affect
   user-visible behavior:
   - "Control name 'eqiir.2.1 Post Mixer Analog Playback IIR Eq bytes'
     truncated..."
   - Multiple similar truncation warnings for various audio controls

2. **Small and Contained Fix**: The code change is minimal and
   localized:
   - Adds only ~10 lines of code to parse `dapm_widget_tokens` in the
     `sof_dspless_widget_ready()` function
   - Simply moves existing token parsing logic that was already present
     in the regular SOF mode (line 1438) to also execute in DSPless mode
   - No architectural changes or new features introduced

3. **Low Risk**: The change has minimal regression risk:
   - Only affects DSPless mode operation, not the standard DSP mode
   - Reuses existing, tested parsing code (`sof_parse_tokens` with
     `dapm_widget_tokens`)
   - The token being parsed (`SOF_TKN_COMP_NO_WNAME_IN_KCONTROL_NAME`)
     sets a flag that prevents widget names from being included in
     control names, thus avoiding the truncation

4. **Clear Root Cause**: The issue occurs because without parsing these
   tokens, the `no_wname_in_kcontrol_name` flag in `snd_soc_dapm_widget`
   (line 542 in soc-dapm.h) isn't set, causing ALSA to create overly
   long control names that exceed the 44-character limit and get
   truncated.

5. **Part of DSPless Mode Support**: DSPless mode is an important
   feature that allows audio to work without DSP firmware, and this
   fixes a user-visible issue (truncated control names) in that mode.
   The git history shows multiple DSPless-related fixes have been
   backported before (e.g., commit ef0128afa165).

The commit follows stable tree rules by fixing an important bug with
minimal changes and low risk of regression.

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

