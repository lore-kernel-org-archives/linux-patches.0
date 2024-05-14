Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1E433BE;
	Tue, 14 May 2024 10:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682397; cv=none; b=uCXoMlqnCK1rU3TMWQ7JCTqyo8yQceT83Z0iiNOqJ01LIURrdlxJaMJ0Jy7vNg7bXWNWREGPqvZ9mh1ldPNiDPjVh2cjRhG62PmwpOmmazSAZBtZpMPCWoCyI4iQPtV6t+HSioGp7VZhoVspL0w4HPotjTeIRA2anirgFrPv2Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682397; c=relaxed/simple;
	bh=V0K/10I/0PdLTj23Gn45pprWYe/ouurYUYiMwWDQmko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4mm59kglDFXBA9WBArn0RqcXgQenpOCIaMdt5F861wAA1BGI5kzPgPdSoH0K1vUSs8ziYigvEZiFv6RLLFwox4tL0sOX8R0yeNbpS/HuaylRkK9FaDxMy15iyv8Pw2Cbzl83BbLuPz7WD5TvzeyXCNnkekjmu7S5vWhhyzobKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhpjAeAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhpjAeAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA78CC2BD10;
	Tue, 14 May 2024 10:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682396;
	bh=V0K/10I/0PdLTj23Gn45pprWYe/ouurYUYiMwWDQmko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhpjAeAYl8joxiC8fem9Vsg9G2o+yRCJH1MDe3WuwP4VfeWRZbIjzGThxBiAjUuuj
	 oLPJtN8OYDKLa7Jq9P8i52oyRlGiFvxe8N80GkXH53UAKlLxLQFLRBxlGc5CIi67+w
	 Q8ONJpoLzNzagVtlHzUv3Kqf3jB428sL8dEP/SeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 055/336] ALSA: emu10k1: move the whole GPIO event handling to the workqueue
Date: Tue, 14 May 2024 12:14:19 +0200
Message-ID: <20240514101040.683639093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit f848337cd801c7106a4ec0d61765771dab2a5909 ]

The actual event processing was already done by workqueue items. We can
move the event dispatching there as well, rather than doing it already
in the interrupt handler callback.

This change has a rather profound "side effect" on the reliability of
the FPGA programming: once we enter programming mode, we must not issue
any snd_emu1010_fpga_{read,write}() calls until we're done, as these
would badly mess up the programming protocol. But exactly that would
happen when trying to program the dock, as that triggers GPIO interrupts
as a side effect. This is mitigated by deferring the actual interrupt
handling, as workqueue items are not re-entrant.

To avoid scheduling the dispatcher on non-events, we now explicitly
ignore GPIO IRQs triggered by "uninteresting" pins, which happens a lot
as a side effect of calling snd_emu1010_fpga_{read,write}().

Fixes: fbb64eedf5a3 ("ALSA: emu10k1: make E-MU dock monitoring interrupt-driven")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218584
Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20240428093716.3198666-4-oswald.buddenhagen@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/emu10k1.h          |  3 +-
 sound/pci/emu10k1/emu10k1.c      |  3 +-
 sound/pci/emu10k1/emu10k1_main.c | 56 ++++++++++++++++----------------
 3 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/include/sound/emu10k1.h b/include/sound/emu10k1.h
index 1af9e68193920..9cc10fab01a8c 100644
--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1684,8 +1684,7 @@ struct snd_emu1010 {
 	unsigned int clock_fallback;
 	unsigned int optical_in; /* 0:SPDIF, 1:ADAT */
 	unsigned int optical_out; /* 0:SPDIF, 1:ADAT */
-	struct work_struct firmware_work;
-	struct work_struct clock_work;
+	struct work_struct work;
 };
 
 struct snd_emu10k1 {
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index fe72e7d772412..dadeda7758cee 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -189,8 +189,7 @@ static int snd_emu10k1_suspend(struct device *dev)
 
 	emu->suspend = 1;
 
-	cancel_work_sync(&emu->emu1010.firmware_work);
-	cancel_work_sync(&emu->emu1010.clock_work);
+	cancel_work_sync(&emu->emu1010.work);
 
 	snd_ac97_suspend(emu->ac97);
 
diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index 6265fc9ae2606..86eaf5963502c 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -765,19 +765,10 @@ static void snd_emu1010_load_dock_firmware(struct snd_emu10k1 *emu)
 	msleep(10);
 }
 
-static void emu1010_firmware_work(struct work_struct *work)
+static void emu1010_dock_event(struct snd_emu10k1 *emu)
 {
-	struct snd_emu10k1 *emu;
 	u32 reg;
 
-	emu = container_of(work, struct snd_emu10k1,
-			   emu1010.firmware_work);
-	if (emu->card->shutdown)
-		return;
-#ifdef CONFIG_PM_SLEEP
-	if (emu->suspend)
-		return;
-#endif
 	snd_emu1010_fpga_read(emu, EMU_HANA_OPTION_CARDS, &reg); /* OPTIONS: Which cards are attached to the EMU */
 	if (reg & EMU_HANA_OPTION_DOCK_OFFLINE) {
 		/* Audio Dock attached */
@@ -792,20 +783,10 @@ static void emu1010_firmware_work(struct work_struct *work)
 	}
 }
 
-static void emu1010_clock_work(struct work_struct *work)
+static void emu1010_clock_event(struct snd_emu10k1 *emu)
 {
-	struct snd_emu10k1 *emu;
 	struct snd_ctl_elem_id id;
 
-	emu = container_of(work, struct snd_emu10k1,
-			   emu1010.clock_work);
-	if (emu->card->shutdown)
-		return;
-#ifdef CONFIG_PM_SLEEP
-	if (emu->suspend)
-		return;
-#endif
-
 	spin_lock_irq(&emu->reg_lock);
 	// This is the only thing that can actually happen.
 	emu->emu1010.clock_source = emu->emu1010.clock_fallback;
@@ -816,19 +797,40 @@ static void emu1010_clock_work(struct work_struct *work)
 	snd_ctl_notify(emu->card, SNDRV_CTL_EVENT_MASK_VALUE, &id);
 }
 
-static void emu1010_interrupt(struct snd_emu10k1 *emu)
+static void emu1010_work(struct work_struct *work)
 {
+	struct snd_emu10k1 *emu;
 	u32 sts;
 
+	emu = container_of(work, struct snd_emu10k1, emu1010.work);
+	if (emu->card->shutdown)
+		return;
+#ifdef CONFIG_PM_SLEEP
+	if (emu->suspend)
+		return;
+#endif
+
 	snd_emu1010_fpga_read(emu, EMU_HANA_IRQ_STATUS, &sts);
 
 	// The distinction of the IRQ status bits is unreliable,
 	// so we dispatch later based on option card status.
 	if (sts & (EMU_HANA_IRQ_DOCK | EMU_HANA_IRQ_DOCK_LOST))
-		schedule_work(&emu->emu1010.firmware_work);
+		emu1010_dock_event(emu);
 
 	if (sts & EMU_HANA_IRQ_WCLK_CHANGED)
-		schedule_work(&emu->emu1010.clock_work);
+		emu1010_clock_event(emu);
+}
+
+static void emu1010_interrupt(struct snd_emu10k1 *emu)
+{
+	// We get an interrupt on each GPIO input pin change, but we
+	// care only about the ones triggered by the dedicated pin.
+	u16 sts = inw(emu->port + A_GPIO);
+	u16 bit = emu->card_capabilities->ca0108_chip ? 0x2000 : 0x8000;
+	if (!(sts & bit))
+		return;
+
+	schedule_work(&emu->emu1010.work);
 }
 
 /*
@@ -969,8 +971,7 @@ static void snd_emu10k1_free(struct snd_card *card)
 		/* Disable 48Volt power to Audio Dock */
 		snd_emu1010_fpga_write(emu, EMU_HANA_DOCK_PWR, 0);
 	}
-	cancel_work_sync(&emu->emu1010.firmware_work);
-	cancel_work_sync(&emu->emu1010.clock_work);
+	cancel_work_sync(&emu->emu1010.work);
 	release_firmware(emu->firmware);
 	release_firmware(emu->dock_fw);
 	snd_util_memhdr_free(emu->memhdr);
@@ -1549,8 +1550,7 @@ int snd_emu10k1_create(struct snd_card *card,
 	emu->irq = -1;
 	emu->synth = NULL;
 	emu->get_synth_voice = NULL;
-	INIT_WORK(&emu->emu1010.firmware_work, emu1010_firmware_work);
-	INIT_WORK(&emu->emu1010.clock_work, emu1010_clock_work);
+	INIT_WORK(&emu->emu1010.work, emu1010_work);
 	/* read revision & serial */
 	emu->revision = pci->revision;
 	pci_read_config_dword(pci, PCI_SUBSYSTEM_VENDOR_ID, &emu->serial);
-- 
2.43.0



