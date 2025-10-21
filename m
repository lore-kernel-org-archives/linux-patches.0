Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB75525A355;
	Tue, 21 Oct 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077417; cv=none; b=U5wcgGMhQOcKWAPC1N7D17/vlI9Ncv1bbk+rq9/9zVi3h8x+qopG3AzsP7leD/SP+AwQmSjzjGh3AcAYLotWt9Vb4nA3ahntm7MijgCB/0Lm7I9MNrYsydAAZkcMYJlhz5ICnrIm6EiQNxtzM0UjSlnk+yQt2uX+V9nXwY/lSoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077417; c=relaxed/simple;
	bh=vbtopTyH54A+drZYetxffk3eGj1SmA4/VbrzC0W9XzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zn6FW0voz2jcJTre9oMjnkCzkbvpY4aL/WxcbvRDBdrDs1faCQSVQQGydi4R15FkHBWJwgG0/MnoMMbKaC6bEwL23nrBSQjKZEBWgiX03GMcc1sCdJ4nMbr+dcOc8YuVHGXuEaXw5zlzPtx5QJugK0lO0CLHNUpFdLhVFMwXL8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1FBQVPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1FBQVPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA39C4CEF1;
	Tue, 21 Oct 2025 20:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077417;
	bh=vbtopTyH54A+drZYetxffk3eGj1SmA4/VbrzC0W9XzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1FBQVPqgxhvfnMTmFoNmaoxvgzRWOz2gwvO9joWWuK28SkRbbLfOthJeyVLKGlY4
	 8UqT4e54onTPPL4nH/YRTR+YfndXhQ618XrQKdWKTjTQPOjvVIHIAoZxM9oGrwL0jb
	 i41jupx2l7fQaybJdUVZ0pV9sQJ3U+/iRdZaCx8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 100/159] ASoC: nau8821: Consistently clear interrupts before unmasking
Date: Tue, 21 Oct 2025 21:51:17 +0200
Message-ID: <20251021195045.590182254@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 58 ++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index cefce97893123..56e5a0d80782b 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1057,20 +1057,24 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
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
 
@@ -1094,7 +1098,6 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 			NAU8821_IRQ_KEY_RELEASE_DIS |
 			NAU8821_IRQ_KEY_PRESS_DIS);
 	}
-
 }
 
 static void nau8821_jdet_work(struct work_struct *work)
@@ -1151,6 +1154,15 @@ static void nau8821_setup_inserted_irq(struct nau8821 *nau8821)
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
@@ -1169,17 +1181,18 @@ static void nau8821_setup_inserted_irq(struct nau8821 *nau8821)
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
@@ -1195,14 +1208,13 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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
@@ -1212,27 +1224,17 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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



