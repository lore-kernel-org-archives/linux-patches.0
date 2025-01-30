Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612A11E522;
	Thu, 30 Jan 2025 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247396; cv=none; b=OCYzs92oPeLCPXhgb8YH80JDot6Oyjhli7Jv+UTf22fqSw5XOh9tu8QHR+jwqdJuWCD3lp5lCzt6ZbxGbwC4R6p/Y0m9OJFw5pifJ8oLeT4byqQwznLxk59TxrYQo10no/f3J36x6nfudE+VXZ47Tg+p8bfVNufeYo8tLCrsL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247396; c=relaxed/simple;
	bh=8mntfKfkbNx7CUm1+OdlhvfUfrNP+xd6XBQXz5IdVm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjKEDqgJpm1wvTwBanwwW8MUlTu10E72htUqCkqg1HvJNso4G5s831yiv9U2LJHmCegr8qevGDZhMCQBNcSjxjTSJ9n+QElhyULQtJHebZON4JBxZ7UmMQHkyHSe6Rn7EmSzJ6uNMpsaXC1maVNXORNlKDV/6fFNiWcQunUuZ7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8IyWhYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8IyWhYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20E9C4CED2;
	Thu, 30 Jan 2025 14:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247396;
	bh=8mntfKfkbNx7CUm1+OdlhvfUfrNP+xd6XBQXz5IdVm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8IyWhYQVSj7q9TCFLH6UUZg+psZYv42L+4UlYzZ3FHNZOJgTQy3WY0ewdALBwESa
	 yqiGxQXEDC7bYoF15IAE2mr4gFhaZsskGTPTGBlGA5P+rwmDTcBwjwEHMMZMa+PKqC
	 ecmhkbcanaTkOpZXPztJqKE8zGjwTg4RNDQhCfbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/49] ASoC: samsung: midas_wm1811: Map missing jack kcontrols
Date: Thu, 30 Jan 2025 15:01:43 +0100
Message-ID: <20250130140134.125220348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alper Nebi Yasak <alpernebiyasak@gmail.com>

[ Upstream commit d27224a45e5457ad89195d92decdd57596253428 ]

This driver does not map jack pins to kcontrols that PulseAudio/PipeWire
need to handle jack detection events. The WM1811 codec used here seems
to support detecting Headphone and Headset Mic connections. Expose each
to userspace as a kcontrol and add the necessary widgets.

Signed-off-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Link: https://lore.kernel.org/r/20230802175737.263412-28-alpernebiyasak@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 704dbe97a681 ("ASoC: samsung: Add missing depends on I2C")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/midas_wm1811.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/sound/soc/samsung/midas_wm1811.c b/sound/soc/samsung/midas_wm1811.c
index 6931b9a45b3e5..44b32f5cddcac 100644
--- a/sound/soc/samsung/midas_wm1811.c
+++ b/sound/soc/samsung/midas_wm1811.c
@@ -38,6 +38,17 @@ struct midas_priv {
 	struct snd_soc_jack headset_jack;
 };
 
+static struct snd_soc_jack_pin headset_jack_pins[] = {
+	{
+		.pin = "Headphone",
+		.mask = SND_JACK_HEADPHONE,
+	},
+	{
+		.pin = "Headset Mic",
+		.mask = SND_JACK_MICROPHONE,
+	},
+};
+
 static int midas_start_fll1(struct snd_soc_pcm_runtime *rtd, unsigned int rate)
 {
 	struct snd_soc_card *card = rtd->card;
@@ -246,6 +257,7 @@ static const struct snd_kcontrol_new midas_controls[] = {
 	SOC_DAPM_PIN_SWITCH("Main Mic"),
 	SOC_DAPM_PIN_SWITCH("Sub Mic"),
 	SOC_DAPM_PIN_SWITCH("Headset Mic"),
+	SOC_DAPM_PIN_SWITCH("Headphone"),
 
 	SOC_DAPM_PIN_SWITCH("FM In"),
 };
@@ -261,6 +273,7 @@ static const struct snd_soc_dapm_widget midas_dapm_widgets[] = {
 	SND_SOC_DAPM_LINE("HDMI", NULL),
 	SND_SOC_DAPM_LINE("FM In", midas_fm_set),
 
+	SND_SOC_DAPM_HP("Headphone", NULL),
 	SND_SOC_DAPM_MIC("Headset Mic", NULL),
 	SND_SOC_DAPM_MIC("Main Mic", midas_mic_bias),
 	SND_SOC_DAPM_MIC("Sub Mic", midas_submic_bias),
@@ -305,11 +318,13 @@ static int midas_late_probe(struct snd_soc_card *card)
 		return ret;
 	}
 
-	ret = snd_soc_card_jack_new(card, "Headset",
-			SND_JACK_HEADSET | SND_JACK_MECHANICAL |
-			SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2 |
-			SND_JACK_BTN_3 | SND_JACK_BTN_4 | SND_JACK_BTN_5,
-			&priv->headset_jack);
+	ret = snd_soc_card_jack_new_pins(card, "Headset",
+					 SND_JACK_HEADSET | SND_JACK_MECHANICAL |
+					 SND_JACK_BTN_0 | SND_JACK_BTN_1 | SND_JACK_BTN_2 |
+					 SND_JACK_BTN_3 | SND_JACK_BTN_4 | SND_JACK_BTN_5,
+					 &priv->headset_jack,
+					 headset_jack_pins,
+					 ARRAY_SIZE(headset_jack_pins));
 	if (ret)
 		return ret;
 
-- 
2.39.5



