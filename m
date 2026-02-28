Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2172737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302350; cv=none; b=atTivuyE4drW0mydiRyVN7/f39D0RrFzd6bWT493OCPv20hht3qguMwOd8jSWum9QXi+B/uZpblqJJF0xIXaLXcVR8gaC83ns5UOCj3M9ulA3s1jF41ciFo3YJCJkDtvJfrj9GPkIQbUfJS0r0MqjMuw2i5fsMZm8uBGgvSFO4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302350; c=relaxed/simple;
	bh=ep9ccfOyzEpjUichpVN2H5K070Xe9ddI9rurw+SiD8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVKozv2ujdnNOSPZFGvH8JKqkg+LYnXothqSjXDjbdLVadf589jGhh0Pq9co2BIn1OrHeFU98fgm5o+ySvWVAeeKtf3lZHaSKhZJROkX62nZetR6Fb/f/BPyruMiKLzUKQmpd3Xyb3kc/muslg+zNJyyNdDFHyR+0E9i9M4QDTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/5cHCfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/5cHCfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC19C19423;
	Sat, 28 Feb 2026 18:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302350;
	bh=ep9ccfOyzEpjUichpVN2H5K070Xe9ddI9rurw+SiD8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/5cHCfqJof1oInPo6ovzKhL0ivDwWDVCmHMuNHi+VS4JNTjCopCP9wUjQS6Z9q6n
	 0dTLOVneZBGyjdJtOMpVHvHEFrddHAxkXTSXq1I1Wc4k0d74ZFJyWI2rBzdQGlWcTb
	 ydjDqgPBIAp25F4c6o6zzmCsANBugYDhnBPhSNg2Cq6T+RSwj1GPf6oBsW3Vtk6cdj
	 bMQ/EAqEPG9R0bZ1ZgCblefy9a5VjMuP/SzYVJkS/aFO6jfwy3E8nHWoCik860WGVS
	 AZ2kIb0SS/P7Ck8IMkQTxFWWjQtYaPrxoAUsF0edeSIW2aGgBvAYDDkIsAGi4Aud4L
	 MZBLxcBPEyA4Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/232] ASoC: nau8821: Consistently clear interrupts before unmasking
Date: Sat, 28 Feb 2026 13:08:48 -0500
Message-ID: <20260228181127.1592657-75-sashal@kernel.org>
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

[ Upstream commit a698679fe8b0fec41d1fb9547a53127a85c1be92 ]

The interrupt handler attempts to perform some IRQ status clear
operations *after* rather than *before* unmasking and enabling
interrupts.  This is a rather fragile approach since it may generally
lead to missing IRQ requests or causing spurious interrupts.

Make use of the nau8821_irq_status_clear() helper instead of
manipulating the related register directly and ensure any interrupt
clearing is performed *after* the target interrupts are disabled/masked
and *before* proceeding with additional interrupt unmasking/enablement
operations.

This also implicitly drops the redundant clear operation of the ejection
IRQ in the interrupt handler, since nau8821_eject_jack() has been
already responsible for clearing all active interrupts.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Fixes: 2551b6e89936 ("ASoC: nau8821: Add headset button detection")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-3-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 70237853edf0 ("ASoC: nau8821: Fixup nau8821_enable_jack_detect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 58 ++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 66309eede0dbd..625b14b58c335 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -939,20 +939,24 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 	snd_soc_component_disable_pin(component, "MICBIAS");
 	snd_soc_dapm_sync(dapm);
 
+	/* Disable & mask both insertion & ejection IRQs */
+	regmap_update_bits(regmap, NAU8821_R12_INTERRUPT_DIS_CTRL,
+			   NAU8821_IRQ_INSERT_DIS | NAU8821_IRQ_EJECT_DIS,
+			   NAU8821_IRQ_INSERT_DIS | NAU8821_IRQ_EJECT_DIS);
+	regmap_update_bits(regmap, NAU8821_R0F_INTERRUPT_MASK,
+			   NAU8821_IRQ_INSERT_EN | NAU8821_IRQ_EJECT_EN,
+			   NAU8821_IRQ_INSERT_EN | NAU8821_IRQ_EJECT_EN);
+
 	/* Clear all interruption status */
 	nau8821_irq_status_clear(regmap, 0);
 
-	/* Enable the insertion interruption, disable the ejection inter-
-	 * ruption, and then bypass de-bounce circuit.
-	 */
+	/* Enable & unmask the insertion IRQ */
 	regmap_update_bits(regmap, NAU8821_R12_INTERRUPT_DIS_CTRL,
-		NAU8821_IRQ_EJECT_DIS | NAU8821_IRQ_INSERT_DIS,
-		NAU8821_IRQ_EJECT_DIS);
-	/* Mask unneeded IRQs: 1 - disable, 0 - enable */
+			   NAU8821_IRQ_INSERT_DIS, 0);
 	regmap_update_bits(regmap, NAU8821_R0F_INTERRUPT_MASK,
-		NAU8821_IRQ_EJECT_EN | NAU8821_IRQ_INSERT_EN,
-		NAU8821_IRQ_EJECT_EN);
+			   NAU8821_IRQ_INSERT_EN, 0);
 
+	/* Bypass de-bounce circuit */
 	regmap_update_bits(regmap, NAU8821_R0D_JACK_DET_CTRL,
 		NAU8821_JACK_DET_DB_BYPASS, NAU8821_JACK_DET_DB_BYPASS);
 
@@ -976,7 +980,6 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 			NAU8821_IRQ_KEY_RELEASE_DIS |
 			NAU8821_IRQ_KEY_PRESS_DIS);
 	}
-
 }
 
 static void nau8821_jdet_work(struct work_struct *work)
@@ -1030,6 +1033,15 @@ static void nau8821_setup_inserted_irq(struct nau8821 *nau8821)
 {
 	struct regmap *regmap = nau8821->regmap;
 
+	/* Disable & mask insertion IRQ */
+	regmap_update_bits(regmap, NAU8821_R12_INTERRUPT_DIS_CTRL,
+			   NAU8821_IRQ_INSERT_DIS, NAU8821_IRQ_INSERT_DIS);
+	regmap_update_bits(regmap, NAU8821_R0F_INTERRUPT_MASK,
+			   NAU8821_IRQ_INSERT_EN, NAU8821_IRQ_INSERT_EN);
+
+	/* Clear insert IRQ status */
+	nau8821_irq_status_clear(regmap, NAU8821_JACK_INSERT_DETECTED);
+
 	/* Enable internal VCO needed for interruptions */
 	if (nau8821->dapm->bias_level < SND_SOC_BIAS_PREPARE)
 		nau8821_configure_sysclk(nau8821, NAU8821_CLK_INTERNAL, 0);
@@ -1049,17 +1061,18 @@ static void nau8821_setup_inserted_irq(struct nau8821 *nau8821)
 		regmap_update_bits(regmap, NAU8821_R0D_JACK_DET_CTRL,
 				   NAU8821_JACK_DET_DB_BYPASS, 0);
 
+	/* Unmask & enable the ejection IRQs */
 	regmap_update_bits(regmap, NAU8821_R0F_INTERRUPT_MASK,
-		NAU8821_IRQ_EJECT_EN, 0);
+			   NAU8821_IRQ_EJECT_EN, 0);
 	regmap_update_bits(regmap, NAU8821_R12_INTERRUPT_DIS_CTRL,
-		NAU8821_IRQ_EJECT_DIS, 0);
+			   NAU8821_IRQ_EJECT_DIS, 0);
 }
 
 static irqreturn_t nau8821_interrupt(int irq, void *data)
 {
 	struct nau8821 *nau8821 = (struct nau8821 *)data;
 	struct regmap *regmap = nau8821->regmap;
-	int active_irq, clear_irq = 0, event = 0, event_mask = 0;
+	int active_irq, event = 0, event_mask = 0;
 
 	if (regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq)) {
 		dev_err(nau8821->dev, "failed to read irq status\n");
@@ -1075,14 +1088,13 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
 		event_mask |= SND_JACK_HEADSET;
-		clear_irq = NAU8821_JACK_EJECT_IRQ_MASK;
 	} else if (active_irq & NAU8821_KEY_SHORT_PRESS_IRQ) {
 		event |= NAU8821_BUTTON;
 		event_mask |= NAU8821_BUTTON;
-		clear_irq = NAU8821_KEY_SHORT_PRESS_IRQ;
+		nau8821_irq_status_clear(regmap, NAU8821_KEY_SHORT_PRESS_IRQ);
 	} else if (active_irq & NAU8821_KEY_RELEASE_IRQ) {
 		event_mask = NAU8821_BUTTON;
-		clear_irq = NAU8821_KEY_RELEASE_IRQ;
+		nau8821_irq_status_clear(regmap, NAU8821_KEY_RELEASE_IRQ);
 	} else if ((active_irq & NAU8821_JACK_INSERT_IRQ_MASK) ==
 		NAU8821_JACK_INSERT_DETECTED) {
 		cancel_work_sync(&nau8821->jdet_work);
@@ -1092,27 +1104,17 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 			/* detect microphone and jack type */
 			schedule_work(&nau8821->jdet_work);
 			/* Turn off insertion interruption at manual mode */
-			regmap_update_bits(regmap,
-				NAU8821_R12_INTERRUPT_DIS_CTRL,
-				NAU8821_IRQ_INSERT_DIS,
-				NAU8821_IRQ_INSERT_DIS);
-			regmap_update_bits(regmap,
-				NAU8821_R0F_INTERRUPT_MASK,
-				NAU8821_IRQ_INSERT_EN,
-				NAU8821_IRQ_INSERT_EN);
 			nau8821_setup_inserted_irq(nau8821);
 		} else {
 			dev_warn(nau8821->dev,
 				"Inserted IRQ fired but not connected\n");
 			nau8821_eject_jack(nau8821);
 		}
+	} else {
+		/* Clear the rightmost interrupt */
+		nau8821_irq_status_clear(regmap, active_irq);
 	}
 
-	if (!clear_irq)
-		clear_irq = active_irq;
-	/* clears the rightmost interruption */
-	regmap_write(regmap, NAU8821_R11_INT_CLR_KEY_STATUS, clear_irq);
-
 	if (event_mask)
 		snd_soc_jack_report(nau8821->jack, event, event_mask);
 
-- 
2.51.0

