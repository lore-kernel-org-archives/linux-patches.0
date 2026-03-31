Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5A0402B9B;
	Tue, 31 Mar 2026 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974920; cv=none; b=MH2yZNiMAUUl4lL0XgloiUubNAOZ0No+XhRJKS4Wh1a2eZi9NBb7pQZnVSDgP0jv3zm9cbVBiwpYwmLkVLLDw8TGEsE4hUsGrfaZjKXAnMISjb2oNIrrZ9XHiwZDWorDn8+knTWqpkZZ1qWlCY47ntg/JTQ5TBWedrGIi6gUOvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974920; c=relaxed/simple;
	bh=g1alI/EX3UJG35ZqCoc/IjRk/2Pa98SZpz9YsWVPj0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUI0gT3YFOMJO/9vzgt9pDnbFxG6bqBcR6COc5yogiPRS9SUvnlyFsxad9J24QX/H+GediW4F/5MewHdHaZwTS0cSPEExlzny6zHubbxa7gtvynDNZy9lDupF0ZqgOqlaPSchdreYiBEnAYNsFcQWLMX7sUlxlOxB8tP1f2ZDfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDV6W8+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDV6W8+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35029C2BCB2;
	Tue, 31 Mar 2026 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974920;
	bh=g1alI/EX3UJG35ZqCoc/IjRk/2Pa98SZpz9YsWVPj0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDV6W8+N9J2y+pCHJXxP6B6eRUwl0x8uOnhPLej7FMTGi/6VokrfxI2UI5SYYZLoL
	 dKH48UNBLmNVTPBhQCnCWGeZBaTP9i1XrexrRtO7YPEzLMI5u2Lxjq/2yJJw96w33Z
	 VrKoIeaIZ1L3CBd0E3904+O3r/mA3Lfp86zfTolo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 053/342] ASoC: cs35l56: Only patch ASP registers if the DAI is part of a DAIlink
Date: Tue, 31 Mar 2026 18:18:06 +0200
Message-ID: <20260331161800.850396900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 9351cf3fd92dc1349bb75f2f7f7324607dcf596f ]

Move the ASP register patches to a separate struct and apply this from the
ASP DAI probe() function so that the registers are only patched if the DAI
is part of a DAI link.

Some systems use the ASP as a special-purpose interconnect and on these
systems the ASP registers are configured by a third party (the firmware,
the BIOS, or another device using the amp's secondary host control
interface).

If the machine driver does not hook up the ASP DAI then the ASP registers
must be omitted from the patch to prevent overwriting the third party
configuration.

If the machine driver includes the ASP DAI in a DAI link, this implies that
the machine driver and higher components (such as alsa-ucm) are taking
ownership of the ASP. In this case the ASP registers are patched to known
defaults and the machine driver should configure the ASP.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260226110137.1664562-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h           |  1 +
 sound/soc/codecs/cs35l56-shared.c | 16 +++++++++++++++-
 sound/soc/codecs/cs35l56.c        |  8 ++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index 5928af539c468..d0ae1ae2ae2a0 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -374,6 +374,7 @@ extern const char * const cs35l56_cal_set_status_text[3];
 extern const char * const cs35l56_tx_input_texts[CS35L56_NUM_INPUT_SRC];
 extern const unsigned int cs35l56_tx_input_values[CS35L56_NUM_INPUT_SRC];
 
+int cs35l56_set_asp_patch(struct cs35l56_base *cs35l56_base);
 int cs35l56_set_patch(struct cs35l56_base *cs35l56_base);
 int cs35l56_mbox_send(struct cs35l56_base *cs35l56_base, unsigned int command);
 int cs35l56_firmware_shutdown(struct cs35l56_base *cs35l56_base);
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index 60100c8f8c952..0ec6a96e80858 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -23,7 +23,7 @@
 
 #include "cs35l56.h"
 
-static const struct reg_sequence cs35l56_patch[] = {
+static const struct reg_sequence cs35l56_asp_patch[] = {
 	/*
 	 * Firmware can change these to non-defaults to satisfy SDCA.
 	 * Ensure that they are at known defaults.
@@ -40,6 +40,20 @@ static const struct reg_sequence cs35l56_patch[] = {
 	{ CS35L56_ASP1TX2_INPUT,		0x00000000 },
 	{ CS35L56_ASP1TX3_INPUT,		0x00000000 },
 	{ CS35L56_ASP1TX4_INPUT,		0x00000000 },
+};
+
+int cs35l56_set_asp_patch(struct cs35l56_base *cs35l56_base)
+{
+	return regmap_register_patch(cs35l56_base->regmap, cs35l56_asp_patch,
+				     ARRAY_SIZE(cs35l56_asp_patch));
+}
+EXPORT_SYMBOL_NS_GPL(cs35l56_set_asp_patch, "SND_SOC_CS35L56_SHARED");
+
+static const struct reg_sequence cs35l56_patch[] = {
+	/*
+	 * Firmware can change these to non-defaults to satisfy SDCA.
+	 * Ensure that they are at known defaults.
+	 */
 	{ CS35L56_SWIRE_DP3_CH1_INPUT,		0x00000018 },
 	{ CS35L56_SWIRE_DP3_CH2_INPUT,		0x00000019 },
 	{ CS35L56_SWIRE_DP3_CH3_INPUT,		0x00000029 },
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 55b4d0d55712a..1c1924c6f4070 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -346,6 +346,13 @@ static int cs35l56_dsp_event(struct snd_soc_dapm_widget *w,
 	return wm_adsp_event(w, kcontrol, event);
 }
 
+static int cs35l56_asp_dai_probe(struct snd_soc_dai *codec_dai)
+{
+	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(codec_dai->component);
+
+	return cs35l56_set_asp_patch(&cs35l56->base);
+}
+
 static int cs35l56_asp_dai_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(codec_dai->component);
@@ -550,6 +557,7 @@ static int cs35l56_asp_dai_set_sysclk(struct snd_soc_dai *dai,
 }
 
 static const struct snd_soc_dai_ops cs35l56_ops = {
+	.probe = cs35l56_asp_dai_probe,
 	.set_fmt = cs35l56_asp_dai_set_fmt,
 	.set_tdm_slot = cs35l56_asp_dai_set_tdm_slot,
 	.hw_params = cs35l56_asp_dai_hw_params,
-- 
2.51.0



