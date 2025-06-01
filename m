Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B53E2868AD;
	Sun,  1 Jun 2025 23:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820571; cv=none; b=oG1duY9Mlrj2RvviZzsK68DD2KKa6SDjF1eLct1UuGw71oy7iShAGodQSku/jJTH5WVRr+vth3fbV8l+j3X5N10QR1QUfqpxQIEhU+afk/EivS/WYQnXuH2rx1YNGLTzxuLUAq3vtI2gD6LPvkXDgl1bbK9eJl4rB4jGKscsgOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820571; c=relaxed/simple;
	bh=GK5mGb0I3HvZIhVVeEReJKL89SL5IZSHys/RSbCc4dw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LU3Lf395PYBUtaBkH9WQOMeWg5kF5xab6BFPQTRP6a6ZhmlTdVrCTlbSvHcbgk0RPE1XPqIwW+V+eenXrlNBB7QbQubANL8QkJix/k0hu93d7m/ZtqWfYCIkvA5XcFObax2KE21tyRWKAywR6hQ+vI++9TalqQU831IU/8y+TtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0Xornwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0Xornwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D96C4CEF2;
	Sun,  1 Jun 2025 23:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820571;
	bh=GK5mGb0I3HvZIhVVeEReJKL89SL5IZSHys/RSbCc4dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0XornwiXwn6E+kZoaOAgvxEiwgIL3r5xh28vw/I46QPVSLfDTfKyJUYiR9QMZbSR
	 +BWBrZlPVnFq6gRVjbOBYdLTgCA05GKrztkT70nevK3E48iuGjMvN+r+frn9Q4zMjd
	 q23U3CZ2khqVpSftPu3zjRkKQpwjMIBl+wXJH5OdTNBpkDAwvIBwwq+6Rbc38yzupK
	 gMZ0EU+8RpI+YoXm+ylANkWvNaU6MacL/iD5HKt2wIFQvwqWi+PAYwh3o9HUy+KWhP
	 5nqed9ZP9zHTdZgZAd06ZNH/eUQ1vFEc7fva0RSXgbhmh0LLPGAyyQJYjDry8QI+Tq
	 WqVC3exTdp/jg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 110/110] ASoC: tas2770: Power cycle amp on ISENSE/VSENSE change
Date: Sun,  1 Jun 2025 19:24:32 -0400
Message-Id: <20250601232435.3507697-110-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232435.3507697-1-sashal@kernel.org>
References: <20250601232435.3507697-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
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

Based on my comprehensive analysis of both the commit and the TAS2770
codebase, here is my assessment: **YES** This commit should be
backported to stable kernel trees for the following reasons: ## Critical
Functionality Fix The commit addresses a **fundamental hardware
functionality issue** where ISENSE/VSENSE blocks (current/voltage
monitoring) only power up during amplifier state transitions from
shutdown to active. This is a hardware-level limitation that affects the
core operation of the audio codec. ## Speaker Protection System Impact
The code changes reveal this is about **speaker protection**, which is
safety-critical functionality: ```c /bin /bin.usr-is-merged /boot /dev
/etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt
/opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp
/usr /var * Powering up ISENSE/VSENSE requires a trip through the
shutdown state. * Do that here to ensure that our changes are applied
properly, otherwise * we might end up with non-functional IVSENSE if
playback started earlier, * which would break software speaker
protection. */ ``` Non-functional IVSENSE/VSENSE breaks software speaker
protection algorithms that prevent hardware damage from
overcurrent/overvoltage conditions. ## Clean, Contained Fix The
implementation is minimal and surgical: - Adds a new `sense_event()`
function with only 12 lines of logic - Modifies DAPM widget definitions
to use `SND_SOC_DAPM_SWITCH_E` instead of `SND_SOC_DAPM_SWITCH` - Forces
a controlled power cycle (shutdown → normal operation) when sense
controls change - No architectural changes or new features ## Historical
Pattern Alignment This follows the **positive backport pattern** seen in
similar commit #2 (tas2562 amp_level fix) and #5 (tas2781 power state
restoration), both marked "Backport Status: YES" for fixing hardware
control issues in TAS codec family. ## Low Regression Risk The fix
operates within existing DAPM event handling framework: -
`SND_SOC_DAPM_PRE_REG`: Forces shutdown before register changes -
`SND_SOC_DAPM_POST_REG`: Restores proper power state after changes -
Uses existing `tas2770_update_pwr_ctrl()` function - No changes to
normal playback paths when sense controls aren't modified ## User-
Affecting Bug Users enabling ISENSE/VSENSE monitoring during active
playback would experience: - Silent failure of speaker protection -
Potential hardware damage risk - Inconsistent behavior depending on
timing of control changes The fix ensures these controls work reliably
regardless of when they're activated, which is essential for proper
codec operation and hardware protection.

 sound/soc/codecs/tas2770.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 7f219df8be704..8de7e94d4ba47 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -156,11 +156,37 @@ static const struct snd_kcontrol_new isense_switch =
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

