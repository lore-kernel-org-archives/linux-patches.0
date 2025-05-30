Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D902F26B95A;
	Fri, 30 May 2025 12:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608882; cv=none; b=f8m3+0RkV91Qq1iNBo56S9QFHne89yC/FWE2cGpjsrGRQKMIybuq7uX/go/MFJHZkox0ffHbs8NCWHLMagktOJsoFHIMo4yaLvKfMF4/hgDWVH9E5ytoxBvhJyotv5KNFaIJma80R1etJ7d56qTNUPJQKDyCkY5nOecZRAM0z4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608882; c=relaxed/simple;
	bh=KuoD4p3kA0hMAk3IJcTJDtGzA1Y7/fjMyVTFTfrxFpA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j14v65WyRbgM09vKP22tAV60+S+aU+e3aS2/EqackuHgzY7PpnlcIH1twk40RWRKHPzGsSBOONUjDmmb96r2+x+e/j7Rr5kFK2RYzcT/N0KAZgLwIx4qwW4I22u2TLUe0jU7t+Fzy7ScLlhr56/zyK+UG2CF/RH/dUrxWs2trUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ulD//e8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ulD//e8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864E8C4CEE9;
	Fri, 30 May 2025 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608881;
	bh=KuoD4p3kA0hMAk3IJcTJDtGzA1Y7/fjMyVTFTfrxFpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulD//e8Dwy9D4R6INnAhpFt5ukmvG+DDFGYY5p7H+Hdrm1suyEWUsU/elpYOBIUL4
	 XnJPgDT/rN3B0CzrxbUsI8YwqgMTkayehakKjScZqdXFeJEeIOIs0PQdW8Ekz40BVk
	 uxzXYlFVy1BeXCicVIHfgoonBj9B2OlXo5C3BvnFxYhNWBPxJ2Oun8tNZC7qRZZEpe
	 Y1SKMI82H13UdKeLqIi+Vm/Qq4YZNnyIW4qS2V9lLzjgYxNnOkBv+LH3R2H9JQ+o3S
	 lDJmCX8dRkJd3bV1WPXFZB3ziBsVaWFo1mQag9eH7kGhuvM3tLqimAKOGPtWRqpHjq
	 M3rZszjMljkhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 06/13] ASoC: tas2770: Power cycle amp on ISENSE/VSENSE change
Date: Fri, 30 May 2025 08:41:05 -0400
Message-Id: <20250530124112.2576343-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530124112.2576343-1-sashal@kernel.org>
References: <20250530124112.2576343-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit f529c91be8a34ac12e7599bf87c65b6f4a2c9f5c ]

The ISENSE/VSENSE blocks are only powered up when the amplifier
transitions from shutdown to active. This means that if those controls
are flipped on while the amplifier is already playing back audio, they
will have no effect.

Fix this by forcing a power cycle around transitions in those controls.

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250406-apple-codec-changes-v5-1-50a00ec850a3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
my analysis of both the commit message and code changes. Here's my
extensive explanation: ## Bug Fix Analysis This commit addresses a
specific functional bug in the tas2770 audio codec driver where
ISENSE/VSENSE controls don't work properly when changed during active
playback. The commit message clearly states: "if those controls are
flipped on while the amplifier is already playing back audio, they will
have no effect." ## Code Changes Analysis The fix is contained and
minimal, involving three key changes to `sound/soc/codecs/tas2770.c`: 1.
**Addition of `sense_event` function (lines +21 to +43)**: This function
implements a power cycling mechanism that forces the amplifier through a
shutdown state when ISENSE/VSENSE controls are changed. This ensures the
changes take effect regardless of playback state. 2. **Modified DAPM
widget definitions (lines +45 to +48)**: The ISENSE and VSENSE switches
are changed from simple `SND_SOC_DAPM_SWITCH` to `SND_SOC_DAPM_SWITCH_E`
with event handling, connecting them to the new `sense_event` function.
3. **Event triggers**: The widgets respond to `SND_SOC_DAPM_PRE_REG` and
`SND_SOC_DAPM_POST_REG` events to perform the power cycling around
register changes. ## Why This Should Be Backported 1. **User-Affecting
Bug**: This fixes a real functional issue where audio controls don't
work as expected during playback, which directly impacts user
experience. 2. **Small and Contained**: The fix is confined to a single
driver file (`tas2770.c`) and doesn't affect other subsystems. The
changes are surgical and targeted. 3. **Low Risk**: The fix follows
established ASoC patterns using standard DAPM event handling. Similar
power cycling approaches are used throughout the ASoC subsystem. 4. **No
New Features**: This purely fixes existing functionality rather than
adding new features. 5. **Comparison with Similar Commits**: Looking at
the provided examples, this commit is very similar to "Similar Commit
#2" and "Similar Commit #5" which were both marked as backportable
(YES). Like commit #2, it fixes incorrect hardware behavior with a small
register/control change. Like commit #5, it addresses power state
management issues in audio hardware. 6. **Hardware-Specific Fix**: The
commit addresses a hardware limitation specific to the tas2770 chip
where ISENSE/VSENSE blocks are only powered up during shutdown-to-active
transitions. This is documented in the commit message and is a
legitimate hardware workaround. The fix ensures that software speaker
protection functionality works correctly by guaranteeing that IVSENSE
controls are functional, which is critical for protecting audio hardware
from damage.

 sound/soc/codecs/tas2770.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index e284a3a854591..8bd98e9817c97 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -158,11 +158,37 @@ static const struct snd_kcontrol_new isense_switch =
 static const struct snd_kcontrol_new vsense_switch =
 	SOC_DAPM_SINGLE("Switch", TAS2770_PWR_CTRL, 2, 1, 1);
 
+static int sense_event(struct snd_soc_dapm_widget *w,
+			struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	struct tas2770_priv *tas2770 = snd_soc_component_get_drvdata(component);
+
+	/*
+	 * Powering up ISENSE/VSENSE requires a trip through the shutdown state.
+	 * Do that here to ensure that our changes are applied properly, otherwise
+	 * we might end up with non-functional IVSENSE if playback started earlier,
+	 * which would break software speaker protection.
+	 */
+	switch (event) {
+	case SND_SOC_DAPM_PRE_REG:
+		return snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
+						    TAS2770_PWR_CTRL_MASK,
+						    TAS2770_PWR_CTRL_SHUTDOWN);
+	case SND_SOC_DAPM_POST_REG:
+		return tas2770_update_pwr_ctrl(tas2770);
+	default:
+		return 0;
+	}
+}
+
 static const struct snd_soc_dapm_widget tas2770_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_IN("ASI1", "ASI1 Playback", 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_MUX("ASI1 Sel", SND_SOC_NOPM, 0, 0, &tas2770_asi1_mux),
-	SND_SOC_DAPM_SWITCH("ISENSE", TAS2770_PWR_CTRL, 3, 1, &isense_switch),
-	SND_SOC_DAPM_SWITCH("VSENSE", TAS2770_PWR_CTRL, 2, 1, &vsense_switch),
+	SND_SOC_DAPM_SWITCH_E("ISENSE", TAS2770_PWR_CTRL, 3, 1, &isense_switch,
+		sense_event, SND_SOC_DAPM_PRE_REG | SND_SOC_DAPM_POST_REG),
+	SND_SOC_DAPM_SWITCH_E("VSENSE", TAS2770_PWR_CTRL, 2, 1, &vsense_switch,
+		sense_event, SND_SOC_DAPM_PRE_REG | SND_SOC_DAPM_POST_REG),
 	SND_SOC_DAPM_DAC_E("DAC", NULL, SND_SOC_NOPM, 0, 0, tas2770_dac_event,
 			   SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 	SND_SOC_DAPM_OUTPUT("OUT"),
-- 
2.39.5

