Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977C1A5B8D;
	Mon,  4 Aug 2025 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267219; cv=none; b=hf6KN7UspbVgKLWPzM9m02zQZCXlRNgxot8MoIpmeren2rFaa7iQM3Rnh7hx0ff8BPxh4+oXj3WIcuJSmpuQ7reL+1ha9ReXzNibZrkb6EWVxKMs2WlRk8/ZM0CmLs5CGhawBVsf8AAtQYNfko/GBTVnaHVcOc4ozXFNg+c43rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267219; c=relaxed/simple;
	bh=qand33AF2c8BlSP2DOKpERG1tl7shJx9uVEWXGqQE4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KSPLgHL25hNqFXMrQF0CcYpM5G5ZSu0VzW0g/aqymEZ+P3jDtNJJZ4a4vWxx6zwSf7rK964kfhAo4V9nOKBEhKXoQ3lyK6ycdDoXb+PKhy783NDqBncR1aBY6lAovUF4HPAHC5SephEml0Er0jY31IJD3fpXCuhrKjgvlcvCOUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6iLqdbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6iLqdbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AF1C4CEEB;
	Mon,  4 Aug 2025 00:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267219;
	bh=qand33AF2c8BlSP2DOKpERG1tl7shJx9uVEWXGqQE4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6iLqdbh0MhuTvTaq3c+Evs0ia9dZzsWeMNmtsA3zGx0v6U5oPoJt4F11JIT8Bkij
	 r5lcaM73hMgO1AzS4a+RgYOrBlR6LjOJZ/WEv/dGe8CXvFjO6BNcKR+Nrv6zKSQk7v
	 vzK/2MbkCLE3QdCxg13kpB3AKU7Qyhslzr8Mn1DCFtP8RIOqF2ghPjzF9ZcbF5qUE/
	 z/nPZg5iX/xQMdlIyMzLN/31t7vk4IZWdpkvic3q0JgNuDqNU0Gm62rYH+FOOIWECO
	 DQT54sKgg/s9r72MpL5jnx7yWZqquuuuT35TIJT6YcrVM1MR92woZY16qnzSAYy3dQ
	 fqgPaKc18vEvw==
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
Subject: [PATCH AUTOSEL 6.16 68/85] ASoC: SOF: topology: Parse the dapm_widget_tokens in case of DSPless mode
Date: Sun,  3 Aug 2025 20:23:17 -0400
Message-Id: <20250804002335.3613254-68-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
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

