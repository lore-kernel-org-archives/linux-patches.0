Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A6330B19;
	Fri, 21 Nov 2025 13:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730911; cv=none; b=YyQX7HN8XCqjS5hRUAsqEKJPcYqwW/dN2pb8oE1b2zCM56w2UcmFRN2Pku1Xk1NP6iINRiKM7oGkI+4SWMpyL5P49xVr2ol7r8yB4CUMxem34mY8ZIm91Gg3+KZrCmhc3OzsOZrUYFPTLBfhvElIFLtyt8nRziF3HmVOkphfMpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730911; c=relaxed/simple;
	bh=MAvEmfUS9AoWyIGyJu4FavwaZAWNlZlP63B0sV+kaYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTTrD8WCftbtlkroG68Lgk7/ZJ83b+/grMyWpEHSUb7I+3QCh3MnlF6V4bYVTqSCivuP4IOHvwv7PBUsgJh7GfPoZKqbIpmo/b6PXtzPpp8SJJn7SlW7qHF247ibOJU42kmtn0Y4LkXLh8qPOj5bppFpqXGemf4P/qLskT+aKnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEaV2QMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEaV2QMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAE4C4CEF1;
	Fri, 21 Nov 2025 13:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730910;
	bh=MAvEmfUS9AoWyIGyJu4FavwaZAWNlZlP63B0sV+kaYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jEaV2QMC/tLM2SmaBx0iRkPceTAlKzBmM4Ys2Boqj83kkrZuwMz08cGqyTi7UHPEf
	 PN/x8rpBTTd73k7BwMSR99RKK7LhdUBSldwI70AXcy9AAE/lfAkdhScvV2YvOVAAJ/
	 fIXA0lwR5n4MB6Ke9kDhBKxIHVfaDIky9rBGsSC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 025/247] ASoC: nau8821: Avoid unnecessary blocking in IRQ handler
Date: Fri, 21 Nov 2025 14:09:32 +0100
Message-ID: <20251121130155.507234688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 22 ++++++++++++----------
 sound/soc/codecs/nau8821.h |  2 +-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index a8ff2ce70be9a..4fa9a785513e5 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1104,16 +1104,12 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
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
@@ -1146,6 +1142,7 @@ static void nau8821_jdet_work(struct work_struct *work)
 		snd_soc_component_disable_pin(component, "MICBIAS");
 		snd_soc_dapm_sync(dapm);
 	}
+
 	event_mask |= SND_JACK_HEADSET;
 	snd_soc_jack_report(nau8821->jack, event, event_mask);
 }
@@ -1194,6 +1191,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 {
 	struct nau8821 *nau8821 = (struct nau8821 *)data;
 	struct regmap *regmap = nau8821->regmap;
+	struct snd_soc_component *component;
 	int active_irq, event = 0, event_mask = 0;
 
 	if (regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq)) {
@@ -1205,7 +1203,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
-		cancel_work_sync(&nau8821->jdet_work);
+		cancel_delayed_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1219,12 +1217,15 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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
@@ -1661,7 +1662,8 @@ int nau8821_enable_jack_detect(struct snd_soc_component *component,
 
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



