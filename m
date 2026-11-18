Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031273;
	b=EX6JLp9bcudvJz+08V63tqJquEElHPQT69wYnBpWCvxDKzZDGpSXceem7PaQwQ2WYeL1
	 ZwpjBNs4LzMpXPpbMDO0KvM6g1gfVLMMK1LzhLcvR0SY0p73jvXujitgnFf05/vVpKq1x
	 bqiZiern7eQrcTyu/5LvnnUCQzbY5FzhhTIWAIhVBqhGHmSlIG0PxFJNtXYcfORtfh6Cn
	 G470tWhiS676J03l5WlIIyplcjtx6Oaa/bX9TxFYVLiNOrhW/4IfZwKB3g3qtBHLnPkQD
	 Uoah5YfS3cdrXpCaS0v+SWuaNjyknzimncM6M3GyGX7HXQKQ+uS1CXDaI/LcEiE6GKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOCnUIk48jGI6hajNMe3ep87ZtLSlKZswfIuAxZ1D2U=;
	b=3JjJZLNc4Fz66T7W2GcSxntrCFwkzEoUtTZnZUcpaa5HYY7X8+/S0DFb8eCnA4JpI1se
	 xiykQ113ajzyzp95Kyiw4puaybd0/lOUVhfqJsie4U6zZIVzgZ4nzHIz07iyjy/r15dc+
	 si81dn51FhtnUdhiiajl/waHi+B1ZguZWP9DC5xgb/83BW5VpmQ7tZV/IF6A9AplrIAm6
	 nJu14jtFmVmGF3+/y7ZXQUtG/ZeM9kIQFb64YUYMEEemVdcC+eIIGaPZlU+s0IeW2IhOY
	 6Bb0a/mJZl2fNjWh2i4t7GrGdjz2aEI9dOcuJnKZSlnuP/oJckP1egNiNA6789G/ecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EegDego/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AB3606A320;
	Wed, 18 Nov 2026 19:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EegDego/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE02B1F000C4;
	Wed, 18 Nov 2026 19:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031273;
	bh=FOCnUIk48jGI6hajNMe3ep87ZtLSlKZswfIuAxZ1D2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EegDego/2Mf0A1QylX77Idp984bjZwCJ/KMcFA9ZPHTBbaLaYNx9bR4OLyXdWduoJ
	 m8kywICZD0IdS8bkepRXxQwUOjKXGM7UvhM7kIBq98I2i1bevaG1guJQ8kDglAYzAk
	 laSe/PgD1PnN887sYPUZAlaV6y0KXVre1qAbbyCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0999/1756] ALSA: hda/intel: Move firmware loading into the probe work
Date: Wed, 18 Nov 2026 15:52:06 +0100
Message-ID: <20261118150049.939450300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit eb90ae3cca783ebec65704597027811431465de4 ]

The hda-intel driver uses request_firmware_nowait() for loading its
patch, and tries to continue the probe directly from the fw loader
callback.  This works in principle, but it has a few drawbacks:

- The driver may be released before the firmware callback completes
- Having two ways of async probe makes the code flow unnecessarily
  complex

The former issue is more severe, as it may potentially lead to a UAF,
and there is no explicit way to cancel the pending firmware worker
for now.

This patch changes the firmware loading to be performed rather in the
common probe work without *_nowait().  Then the pending work can be
easily canceled, and the code becomes more straightforward.

A nice bonus is that, by moving into the probe work, the firmware
doesn't need any longer to be cached, hence we can get rid of struct
azx.fw field, and release the firmware immediately after parsing it,
too.

Fixes: 5cb543dba986 ("ALSA: hda - Deferred probing with request_firmware_nowait()")
Link: https://patch.msgid.link/20260415135526.1813126-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 7e1ad3c55baa ("ALSA: hda: Don't free card at probe error in vga_switcheroo handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_controller.h |  4 ---
 sound/pci/hda/hda_intel.c      | 58 +++++++++-------------------------
 2 files changed, 15 insertions(+), 47 deletions(-)

diff --git a/sound/pci/hda/hda_controller.h b/sound/pci/hda/hda_controller.h
index c2d0109866e62..7434f38038a0b 100644
--- a/sound/pci/hda/hda_controller.h
+++ b/sound/pci/hda/hda_controller.h
@@ -127,10 +127,6 @@ struct azx {
 	unsigned int beep_mode;
 	bool ctl_dev_id;
 
-#ifdef CONFIG_SND_HDA_PATCH_LOADER
-	const struct firmware *fw;
-#endif
-
 	/* flags */
 	int bdl_pos_adj;
 	unsigned int running:1;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 667eac42a0869..d5142861d2865 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1390,9 +1390,6 @@ static void azx_free(struct azx *chip)
 	azx_free_streams(chip);
 	snd_hdac_bus_exit(bus);
 
-#ifdef CONFIG_SND_HDA_PATCH_LOADER
-	release_firmware(chip->fw);
-#endif
 	display_power(chip, false);
 
 	if (chip->driver_caps & AZX_DCAPS_I915_COMPONENT)
@@ -2037,24 +2034,6 @@ static int azx_first_init(struct azx *chip)
 	return 0;
 }
 
-#ifdef CONFIG_SND_HDA_PATCH_LOADER
-/* callback from request_firmware_nowait() */
-static void azx_firmware_cb(const struct firmware *fw, void *context)
-{
-	struct snd_card *card = context;
-	struct azx *chip = card->private_data;
-
-	if (fw)
-		chip->fw = fw;
-	else
-		dev_err(card->dev, "Cannot load firmware, continue without patching\n");
-	if (!chip->disabled) {
-		/* continue probing */
-		azx_probe_continue(chip);
-	}
-}
-#endif
-
 static int disable_msi_reset_irq(struct azx *chip)
 {
 	struct hdac_bus *bus = azx_bus(chip);
@@ -2119,7 +2098,6 @@ static int azx_probe(struct pci_dev *pci,
 	struct snd_card *card;
 	struct hda_intel *hda;
 	struct azx *chip;
-	bool schedule_probe;
 	int dev;
 	int err;
 
@@ -2224,22 +2202,7 @@ static int azx_probe(struct pci_dev *pci,
 		chip->disabled = true;
 	}
 
-	schedule_probe = !chip->disabled;
-
-#ifdef CONFIG_SND_HDA_PATCH_LOADER
-	if (patch[dev] && *patch[dev]) {
-		dev_info(card->dev, "Applying patch firmware '%s'\n",
-			 patch[dev]);
-		err = request_firmware_nowait(THIS_MODULE, true, patch[dev],
-					      &pci->dev, GFP_KERNEL, card,
-					      azx_firmware_cb);
-		if (err < 0)
-			goto out_free;
-		schedule_probe = false; /* continued in azx_firmware_cb() */
-	}
-#endif /* CONFIG_SND_HDA_PATCH_LOADER */
-
-	if (schedule_probe)
+	if (!chip->disabled)
 		schedule_delayed_work(&hda->probe_work, 0);
 
 	set_bit(dev, probed_devs);
@@ -2368,11 +2331,20 @@ static int azx_probe_continue(struct azx *chip)
 	}
 
 #ifdef CONFIG_SND_HDA_PATCH_LOADER
-	if (chip->fw) {
-		err = snd_hda_load_patch(&chip->bus, chip->fw->size,
-					 chip->fw->data);
-		if (err < 0)
-			goto out_free;
+	if (patch[dev] && *patch[dev]) {
+		const struct firmware *fw = NULL;
+
+		dev_info(&pci->dev, "Applying patch firmware '%s'\n",
+			 patch[dev]);
+		if (request_firmware(&fw, patch[dev], &pci->dev) < 0) {
+			dev_err(&pci->dev,
+				"Cannot load firmware, continue without patching\n");
+		} else {
+			err = snd_hda_load_patch(&chip->bus, fw->size, fw->data);
+			release_firmware(fw);
+			if (err < 0)
+				goto out_free;
+		}
 	}
 #endif
 
-- 
2.53.0



