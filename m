Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB92379EE4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301743; cv=none; b=TaAH+4sc2MlwamdSyssAOcT7ZB1KovYRB40Ljqu6xAovrtY3h3rfkqJ962TrYQ4GYBMy1OUp+rGR598+Ifj68BZ4ygB3H5NTciJBcbsUc7Ub893RgX/ePzyAVh2EZyErWW7d+emoh4yquCrJNs+x/HqHAdNo8vRzXDQ+ohg034s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301743; c=relaxed/simple;
	bh=3l2T9/f2AwVhMblaX6g5Rw7FBya2sNPasJhpwMCzOAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0gQsf+Oec1aYqs1aMPB5xNhMh0b6xuACMTYoabg+d6naQ6jywHkgvrj9MjKI8Tpt4HZJ0H58xbexrYK3mie7T5NajnA4iuiJGLNPpspk+bng7y9YDJqvvOuUYRV2+JH9ZhYNYNRi+o3ZUr+oyKVLuMpl7wIcquGH3A3JRjC4oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDKGKqoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDKGKqoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AAEC19424;
	Sat, 28 Feb 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301743;
	bh=3l2T9/f2AwVhMblaX6g5Rw7FBya2sNPasJhpwMCzOAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDKGKqoAq0i9YGuITNo2ik52XdlL0iRdMEPvp4KF2AigV8flObjplcPL779AJ/Y8V
	 j+v2IJka2jkVP4i1ooGQEs9vjyzVPsXmcBjePUkXG5H43weOIr2+/TjAArVMKZXNKb
	 im9/hzR5++vFK3WftxgZiDZEtgjeSCeNNiwha4ZgnpUs6AT/9kYy+Lj7C5gsLjSfrC
	 c5tqytpOx32Y6LsOddfxfyqQ9ZQ6uJs5Z5bxVE1FFlwaeOfNtPHWeazkixyKk1uJiI
	 XuVL+QFMJFsAtAjzhot6zE4W7RVzbDk+tZdF/beECkA9kz1krbpy5Q/KvPFXVKCr7h
	 zozoxYUFnXl0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/385] ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
Date: Sat, 28 Feb 2026 12:56:07 -0500
Message-ID: <20260228180011.1568201-145-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit ee70bacef1c6050e4836409927294d744dbcfa72 ]

The interrupt handler offloads the microphone detection logic to
nau8821_jdet_work(), which implies a sleep operation.  However, before
being able to process any subsequent hotplug event, the interrupt
handler needs to wait for any prior scheduled work to complete.

Move the sleep out of jdet_work by converting it to a delayed work.
This eliminates the undesired blocking in the interrupt handler when
attempting to cancel a recently scheduled work item and should help
reducing transient input reports that might confuse user-space.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-5-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 70237853edf0 ("ASoC: nau8821: Fixup nau8821_enable_jack_detect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 22 ++++++++++++----------
 sound/soc/codecs/nau8821.h |  2 +-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index beeca33a0b7ee..9d006c4b6f284 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1105,16 +1105,12 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 static void nau8821_jdet_work(struct work_struct *work)
 {
 	struct nau8821 *nau8821 =
-		container_of(work, struct nau8821, jdet_work);
+		container_of(work, struct nau8821, jdet_work.work);
 	struct snd_soc_dapm_context *dapm = nau8821->dapm;
 	struct snd_soc_component *component = snd_soc_dapm_to_component(dapm);
 	struct regmap *regmap = nau8821->regmap;
 	int jack_status_reg, mic_detected, event = 0, event_mask = 0;
 
-	snd_soc_component_force_enable_pin(component, "MICBIAS");
-	snd_soc_dapm_sync(dapm);
-	msleep(20);
-
 	regmap_read(regmap, NAU8821_R58_I2C_DEVICE_ID, &jack_status_reg);
 	mic_detected = !(jack_status_reg & NAU8821_KEYDET);
 	if (mic_detected) {
@@ -1147,6 +1143,7 @@ static void nau8821_jdet_work(struct work_struct *work)
 		snd_soc_component_disable_pin(component, "MICBIAS");
 		snd_soc_dapm_sync(dapm);
 	}
+
 	event_mask |= SND_JACK_HEADSET;
 	snd_soc_jack_report(nau8821->jack, event, event_mask);
 }
@@ -1195,6 +1192,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 {
 	struct nau8821 *nau8821 = (struct nau8821 *)data;
 	struct regmap *regmap = nau8821->regmap;
+	struct snd_soc_component *component;
 	int active_irq, event = 0, event_mask = 0;
 
 	if (regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq)) {
@@ -1206,7 +1204,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1220,12 +1218,15 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 		nau8821_irq_status_clear(regmap, NAU8821_KEY_RELEASE_IRQ);
 	} else if ((active_irq & NAU8821_JACK_INSERT_IRQ_MASK) ==
 		NAU8821_JACK_INSERT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_EN);
 		if (nau8821_is_jack_inserted(regmap)) {
-			/* detect microphone and jack type */
-			schedule_work(&nau8821->jdet_work);
+			/* Detect microphone and jack type */
+			component = snd_soc_dapm_to_component(nau8821->dapm);
+			snd_soc_component_force_enable_pin(component, "MICBIAS");
+			snd_soc_dapm_sync(nau8821->dapm);
+			schedule_delayed_work(&nau8821->jdet_work, msecs_to_jiffies(20));
 			/* Turn off insertion interruption at manual mode */
 			nau8821_setup_inserted_irq(nau8821);
 		} else {
@@ -1662,7 +1663,8 @@ int nau8821_enable_jack_detect(struct snd_soc_component *component,
 
 	nau8821->jack = jack;
 	/* Initiate jack detection work queue */
-	INIT_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+	INIT_DELAYED_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+
 	ret = devm_request_threaded_irq(nau8821->dev, nau8821->irq, NULL,
 		nau8821_interrupt, IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 		"nau8821", nau8821);
diff --git a/sound/soc/codecs/nau8821.h b/sound/soc/codecs/nau8821.h
index f0935ffafcbec..88602923780d8 100644
--- a/sound/soc/codecs/nau8821.h
+++ b/sound/soc/codecs/nau8821.h
@@ -561,7 +561,7 @@ struct nau8821 {
 	struct regmap *regmap;
 	struct snd_soc_dapm_context *dapm;
 	struct snd_soc_jack *jack;
-	struct work_struct jdet_work;
+	struct delayed_work jdet_work;
 	int irq;
 	int clk_id;
 	int micbias_voltage;
-- 
2.51.0

