Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFDB346E70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302351; cv=none; b=IsH524jogNry+HflgYhURB+M2YI5PwBbqCyKWtLej8Vf+VWvV739MIaTkXo/7P8DEnFSDhTTfXPA+nJiKILDHp3n0OCNuyihNchWNfYgfIX6Dfc/J3NmttyViHLqOb88fQ5HVon7S7EZ/GNJWfUqrpXSKv2dVRFm7u800cpMaPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302351; c=relaxed/simple;
	bh=yHl8nLPL5/EHYWbHq+ILBMDtXQeD4xLRu9TiHEuueAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0KOvlNH7ipK8K8eEjfA2xiPawItFUUhnjmeuOenqJZg+9KKRt7sm3Q70Q6s7xmHYUOBsv/+QTg6OAo6myO+cEwkZVRWl54D+rtgHuLl7HlqBabuORZ04JPvrbL4LcVlIIrhnea5h7xrfdULdfCoz/YxL0puXIQURRKiyYZfT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPW8ca2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPW8ca2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2B9C116D0;
	Sat, 28 Feb 2026 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302351;
	bh=yHl8nLPL5/EHYWbHq+ILBMDtXQeD4xLRu9TiHEuueAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPW8ca2hv6kDjC2DAoQRLs0xbpjnbQnj1y2Lku+JP3A12JMpU88zGBZjRTZjjWCjX
	 2Y5MenGPy4pMTCb/Axe0LPm6jSVVn/ci8EsF0xBxI/tn6/8aV3OwGihRaevz7B94S/
	 rG7GTfaIT/JhJpuV0nA92pYQRrEhpycyZlyvQLCXaVjNns1V3TsZzT+9+9i0ZToNp8
	 /449H2W5NQHEJ6fUO028BxomphKoJzsVRqbw1ADITDdnzLi4rENDP53ws999BuDQTo
	 RtVOfrlNgw+5K4Z++RTVFbjKjB38CMGdTwWcfCQ3uLFsvW59hVDXohufrDYKBijFaR
	 ZVKVDptxiFewQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/232] ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
Date: Sat, 28 Feb 2026 13:08:49 -0500
Message-ID: <20260228181127.1592657-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 625b14b58c335..120dced6ed4ae 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -985,16 +985,12 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
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
@@ -1024,6 +1020,7 @@ static void nau8821_jdet_work(struct work_struct *work)
 		snd_soc_component_disable_pin(component, "MICBIAS");
 		snd_soc_dapm_sync(dapm);
 	}
+
 	event_mask |= SND_JACK_HEADSET;
 	snd_soc_jack_report(nau8821->jack, event, event_mask);
 }
@@ -1072,6 +1069,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 {
 	struct nau8821 *nau8821 = (struct nau8821 *)data;
 	struct regmap *regmap = nau8821->regmap;
+	struct snd_soc_component *component;
 	int active_irq, event = 0, event_mask = 0;
 
 	if (regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq)) {
@@ -1083,7 +1081,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1097,12 +1095,15 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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
@@ -1539,7 +1540,8 @@ int nau8821_enable_jack_detect(struct snd_soc_component *component,
 
 	nau8821->jack = jack;
 	/* Initiate jack detection work queue */
-	INIT_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+	INIT_DELAYED_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+
 	ret = devm_request_threaded_irq(nau8821->dev, nau8821->irq, NULL,
 		nau8821_interrupt, IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 		"nau8821", nau8821);
diff --git a/sound/soc/codecs/nau8821.h b/sound/soc/codecs/nau8821.h
index c44251f54d481..7590bbe6fbad0 100644
--- a/sound/soc/codecs/nau8821.h
+++ b/sound/soc/codecs/nau8821.h
@@ -512,7 +512,7 @@ struct nau8821 {
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

