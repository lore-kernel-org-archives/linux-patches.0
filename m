Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D47C29A2;
	Mon,  4 Aug 2025 00:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267608; cv=none; b=QlJmqgYoaj773h5aw7l6K6Za7RKe3mbKAACqJNplAoR55H8Hkay9ir1doNrdlSCsICZfIRMBKg3KOG32XPP/yfhuzJCHOHDrvXMWvW2BtNhwIT2CyMKCzCVKvyvpycM2uUWRQ06lM9L4mO87dKIUknD3cbbRbDxeDLCsvWGOTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267608; c=relaxed/simple;
	bh=4i5MJOrdFVSNbIyABgV3WOL/VP7Q71f7FIzwMg6Hmf0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cb/YYVBrSwZOe4M/XIkGfx8ebW4mLmAQp7wt/4YZTWU5Fy7LFnJ4vCUnSnSnAhxOAyt+Dv38XLg+SEEKT6GK9wvA+yKBxunU2JMEbr96Ylk+j6asj/s+z30vPp6GQlQMJxJz55zfqc6LzObGciNVOSemPDuTUwyxZ4dCbq5hkpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZE1KnQvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZE1KnQvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7B5C4CEF0;
	Mon,  4 Aug 2025 00:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267608;
	bh=4i5MJOrdFVSNbIyABgV3WOL/VP7Q71f7FIzwMg6Hmf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE1KnQvwz4Oltby56VUwtDu7DushrkOH3uB8E/kPmt+E0JV7of6h258ZGVUPiV79k
	 lCQFi5qgCgmvpVfjcfLlZY8kEu9hgllEvwVkbPoz7xS/qZhEDiuA3hXpM305QIyt6d
	 yaXGggLC2/xe1aFupkQ1rjPSzQqCJLAQWik//gfSnuoz+6OjMAQQ88NJa2TqT49U4e
	 muNqqMaFeCX51QUp0rK+Oa1YIbXtY8g+vhn17ZZMl4/oatf0HnwBDUhqcwgweUAdop
	 p+mUGFsR/N6v9F8t5seMxOdoLwjD0FSnjv9kjerLJgrCz0VgLkQPEjE40CnMxLBfmf
	 bKTwvdWn3QUVA==
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
Subject: [PATCH AUTOSEL 6.12 53/69] ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode
Date: Sun,  3 Aug 2025 20:31:03 -0400
Message-Id: <20250804003119.3620476-53-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
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
index f9708b8fd73b..0104257df930 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2364,14 +2364,25 @@ static int sof_dspless_widget_ready(struct snd_soc_component *scomp, int index,
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

