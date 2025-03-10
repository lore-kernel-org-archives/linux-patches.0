Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93D62F28;
	Mon, 10 Mar 2025 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630687; cv=none; b=ey04TERUcGBscc5ZqLcrEl6P/oytvH6TEfOEBpyvsuhWZ3vhLOJZEu5qrlPLgLENi/BYL/u0HrIzykR30/sDfogEPEZKiRa/lPWBJeucFXtH33/NDGQcjtkWtUz2mSTev7PziNHna9mOvdG+E1ENmffn3Ra/jL+gYum6vXyR3OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630687; c=relaxed/simple;
	bh=nDFcBHcpmufHW0AYvNv5e7KOc3Kum3BY7fJ4PZh9sbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INWp82vND9ihA3PRS2THeTg9URAAyYstrfnYBcrn1xGf9PFQCOj6i1a8RKRu470hOWcNCZFKKxKefC7zINsGBetacQRf1Mw34Qe7v2DFxnkQxmqhIuBjHZsLYiXDtQoLZCrA/SprgynCOLCEWSnziWMm9bwtNN+xVwRrO/fpP/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVptptcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVptptcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0595DC4CEE5;
	Mon, 10 Mar 2025 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630687;
	bh=nDFcBHcpmufHW0AYvNv5e7KOc3Kum3BY7fJ4PZh9sbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVptptcqVpi/DNP1FtnfFA/0lOigWg2jnvQ9h91felpHMZVoOJC10AyHDKokRJIff
	 YJZMCuuuzscoiXeQD6rOI1NynpipzDOnIOPAji7hGxN3D/N9KuTC8OrQqDRPsf3TxL
	 n47519F0nH1SqtVjGZaRVIz+iREJZOj18yj+EaS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/620] ASoC: es8328: fix route from DAC to output
Date: Mon, 10 Mar 2025 18:05:47 +0100
Message-ID: <20250310170605.342833875@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 5b0c02f9b8acf2a791e531bbc09acae2d51f4f9b ]

The ES8328 codec driver, which is also used for the ES8388 chip that
appears to have an identical register map, claims that the output can
either take the route from DAC->Mixer->Output or through DAC->Output
directly. To the best of what I could find, this is not true, and
creates problems.

Without DACCONTROL17 bit index 7 set for the left channel, as well as
DACCONTROL20 bit index 7 set for the right channel, I cannot get any
analog audio out on Left Out 2 and Right Out 2 respectively, despite the
DAPM routes claiming that this should be possible. Furthermore, the same
is the case for Left Out 1 and Right Out 1, showing that those two don't
have a direct route from DAC to output bypassing the mixer either.

Those control bits toggle whether the DACs are fed (stale bread?) into
their respective mixers. If one "unmutes" the mixer controls in
alsamixer, then sure, the audio output works, but if it doesn't work
without the mixer being fed the DAC input then evidently it's not a
direct output from the DAC.

ES8328/ES8388 are seemingly not alone in this. ES8323, which uses a
separate driver for what appears to be a very similar register map,
simply flips those two bits on in its probe function, and then pretends
there is no power management whatsoever for the individual controls.
Fair enough.

My theory as to why nobody has noticed this up to this point is that
everyone just assumes it's their fault when they had to unmute an
additional control in ALSA.

Fix this in the es8328 driver by removing the erroneous direct route,
then get rid of the playback switch controls and have those bits tied to
the mixer's widget instead, which until now had no register to play
with.

Fixes: 567e4f98922c ("ASoC: add es8328 codec driver")
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://patch.msgid.link/20250222-es8328-route-bludgeoning-v1-1-99bfb7fb22d9@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8328.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index ca3b1c00fa787..fe4763805df94 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -234,7 +234,6 @@ static const struct snd_kcontrol_new es8328_right_line_controls =
 
 /* Left Mixer */
 static const struct snd_kcontrol_new es8328_left_mixer_controls[] = {
-	SOC_DAPM_SINGLE("Playback Switch", ES8328_DACCONTROL17, 7, 1, 0),
 	SOC_DAPM_SINGLE("Left Bypass Switch", ES8328_DACCONTROL17, 6, 1, 0),
 	SOC_DAPM_SINGLE("Right Playback Switch", ES8328_DACCONTROL18, 7, 1, 0),
 	SOC_DAPM_SINGLE("Right Bypass Switch", ES8328_DACCONTROL18, 6, 1, 0),
@@ -244,7 +243,6 @@ static const struct snd_kcontrol_new es8328_left_mixer_controls[] = {
 static const struct snd_kcontrol_new es8328_right_mixer_controls[] = {
 	SOC_DAPM_SINGLE("Left Playback Switch", ES8328_DACCONTROL19, 7, 1, 0),
 	SOC_DAPM_SINGLE("Left Bypass Switch", ES8328_DACCONTROL19, 6, 1, 0),
-	SOC_DAPM_SINGLE("Playback Switch", ES8328_DACCONTROL20, 7, 1, 0),
 	SOC_DAPM_SINGLE("Right Bypass Switch", ES8328_DACCONTROL20, 6, 1, 0),
 };
 
@@ -337,10 +335,10 @@ static const struct snd_soc_dapm_widget es8328_dapm_widgets[] = {
 	SND_SOC_DAPM_DAC("Left DAC", "Left Playback", ES8328_DACPOWER,
 			ES8328_DACPOWER_LDAC_OFF, 1),
 
-	SND_SOC_DAPM_MIXER("Left Mixer", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_MIXER("Left Mixer", ES8328_DACCONTROL17, 7, 0,
 		&es8328_left_mixer_controls[0],
 		ARRAY_SIZE(es8328_left_mixer_controls)),
-	SND_SOC_DAPM_MIXER("Right Mixer", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_MIXER("Right Mixer", ES8328_DACCONTROL20, 7, 0,
 		&es8328_right_mixer_controls[0],
 		ARRAY_SIZE(es8328_right_mixer_controls)),
 
@@ -419,19 +417,14 @@ static const struct snd_soc_dapm_route es8328_dapm_routes[] = {
 	{ "Right Line Mux", "PGA", "Right PGA Mux" },
 	{ "Right Line Mux", "Differential", "Differential Mux" },
 
-	{ "Left Out 1", NULL, "Left DAC" },
-	{ "Right Out 1", NULL, "Right DAC" },
-	{ "Left Out 2", NULL, "Left DAC" },
-	{ "Right Out 2", NULL, "Right DAC" },
-
-	{ "Left Mixer", "Playback Switch", "Left DAC" },
+	{ "Left Mixer", NULL, "Left DAC" },
 	{ "Left Mixer", "Left Bypass Switch", "Left Line Mux" },
 	{ "Left Mixer", "Right Playback Switch", "Right DAC" },
 	{ "Left Mixer", "Right Bypass Switch", "Right Line Mux" },
 
 	{ "Right Mixer", "Left Playback Switch", "Left DAC" },
 	{ "Right Mixer", "Left Bypass Switch", "Left Line Mux" },
-	{ "Right Mixer", "Playback Switch", "Right DAC" },
+	{ "Right Mixer", NULL, "Right DAC" },
 	{ "Right Mixer", "Right Bypass Switch", "Right Line Mux" },
 
 	{ "DAC DIG", NULL, "DAC STM" },
-- 
2.39.5



