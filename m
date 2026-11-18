Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025966;
	b=vE2IBS96q49cVhDbTlCYA4AIvY/+HcPt1UNpMXs7zlFS1Adf+EtqDk89/Nu4yARoeCsT
	 io3tyUI9bV8HCWIxVeDckgGKlul4TF5GbZROmPYd+3ukSUadvmatAwlCpVAeaJEmoCXyZ
	 +fj1lFf7xD66n5dIRt7FhbXiHnocBlQlI9Zx3LhbbP/N/OBJ/zyTU08viz9/Eswj5ZyVY
	 lMKMk8A7eqSj0EbYUp+KncO0NL9xaGq09kpvrWqvlz9W+RpIt7R2+lyzyaA/Ov/k1vWP7
	 iM0LeaXtI8t3gJHyEFlmJIvMWq78asJfbTRF4TobTxfHsMx7XQ6IRTCUQOD+7Kme6bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=unXmMvZAixUrIqyAts8QKdyCxIy575OlpPwB5tkOp8A=;
	b=PdTDSWdBgLZ2WxS6heeIjMvbltFUCiayxiXJneQf6tHxFAsqN7NvlCbPD7rtl0YBXx0+
	 zqPCh1rKh2eh/bHHMrvBfq8PE1MEenhBF1UWXGsiBOt/40V6Tgpi22Z5kYxkSWmDEr3fr
	 Fa2JEo3yX9Wa3fSbCEs66CIyatmE8v+cU14cw6jaBCTjFBC4QpXdGwebDl8Z+erhgplFs
	 c5i2aMgwEzHkMr733pA6qqCaNX8qmXxYsvN+iRj0Z5X5x+Ry4sYPyC9irSZqFJ7/tag1u
	 EBN+AODQWv45horY78i36lOHvB02J0UTstyDsJ9VoYVtphV6Dy3QjCkxrJzZHghJj0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQcN7q4v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DA3606A325;
	Wed, 18 Nov 2026 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQcN7q4v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EE91F000C4;
	Wed, 18 Nov 2026 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025966;
	bh=unXmMvZAixUrIqyAts8QKdyCxIy575OlpPwB5tkOp8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQcN7q4vzJl5O1Zdlu5um64a9ModCZLsYC4HAGUnyMqi3RQZNBcOfgud/czOdWrO0
	 TXGVGn7er9f4KmZvaEwwNE7EESA/epTXR7KNTEwFAYGlfmduCixWQTjvKkyuPE5Kbz
	 MHb5q+wBjMEt+UAWEsHp903kJeu596KAsbIs+fLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1267/2151] ALSA: hda: Dont free card at probe error in vga_switcheroo handler
Date: Wed, 18 Nov 2026 15:50:02 +0100
Message-ID: <20261118150208.295264364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7e1ad3c55baa80399f1727dfd2303fa4d1558d9a ]

The vga_switcheroo handler azx_vs_set_state() calls
azx_probe_contine() for enabling the audio, and if an error happens
during the probe, azx_probe_continue() releases its associated sound
card object at the error path.  The card release procedure includes
the call of vga_switcheroo_unregister_client(), and this triggers the
vgasr_mutex lock again that had been already held by the caller
(vga_switcheroo_process_delayed_switch()) -- leading to a deadlock.

(Moreover, the card release will cause a potential UAF at the error
message in azx_vs_set_state() since the card object is already gone;
this was the original report by Sashiko.)

For avoiding the unneeded crash, it's better to avoid the card release
in this error path, so we make azx_probe_continue() behaving
conditionally.  In return, set hda->init_failed flag, so that any
further (re-)attempts will be filtered after that point.

The check of hda->init_failed is dropped from azx_vs_can_switch().
It's because otherwise vga_switcheroo can't be switched to turn off
GPU once when a probe error happens at the audio side.

Fixes: 39173303c838 ("ALSA: hda: Free card instance properly at probe errors")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261007213728.155092-1-tiwai%40suse.de
Link: https://patch.msgid.link/20261007223448.172443-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/controllers/intel.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index c6e491298a859..523324a565c9c 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1170,7 +1170,7 @@ static const struct dev_pm_ops azx_pm = {
 };
 
 
-static int azx_probe_continue(struct azx *chip);
+static int azx_probe_continue(struct azx *chip, bool free_on_error);
 
 #ifdef SUPPORT_VGA_SWITCHEROO
 static struct pci_dev *get_bound_vga(struct pci_dev *pci);
@@ -1197,8 +1197,10 @@ static void azx_vs_set_state(struct pci_dev *pci,
 		if (!disabled) {
 			dev_info(chip->card->dev,
 				 "Start delayed initialization\n");
-			if (azx_probe_continue(chip) < 0)
+			if (azx_probe_continue(chip, false) < 0) {
+				hda->init_failed = 1;
 				dev_err(chip->card->dev, "initialization error\n");
+			}
 		}
 	} else {
 		dev_info(chip->card->dev, "%s via vga_switcheroo\n",
@@ -1237,8 +1239,6 @@ static bool azx_vs_can_switch(struct pci_dev *pci)
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 
 	wait_for_completion(&hda->probe_wait);
-	if (hda->init_failed)
-		return false;
 	if (chip->disabled || !hda->probe_continued)
 		return true;
 	if (snd_hda_lock_devices(&chip->bus))
@@ -1723,7 +1723,7 @@ static void azx_check_snoop_available(struct azx *chip)
 static void azx_probe_work(struct work_struct *work)
 {
 	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
-	azx_probe_continue(&hda->chip);
+	azx_probe_continue(&hda->chip, true);
 }
 
 static int default_bdl_pos_adj(struct azx *chip)
@@ -2289,7 +2289,7 @@ static const unsigned int azx_max_codecs[AZX_NUM_DRIVERS] = {
 	[AZX_DRIVER_TERA] = 1,
 };
 
-static int azx_probe_continue(struct azx *chip)
+static int azx_probe_continue(struct azx *chip, bool free_on_error)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
 	struct hdac_bus *bus = azx_bus(chip);
@@ -2381,10 +2381,12 @@ static int azx_probe_continue(struct azx *chip)
 
 out_free:
 	if (err < 0) {
-		pci_set_drvdata(pci, NULL);
 		if (hda->vga_switcheroo_registered)
 			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
-		snd_card_free(chip->card);
+		if (free_on_error) {
+			pci_set_drvdata(pci, NULL);
+			snd_card_free(chip->card);
+		}
 		return err;
 	}
 
-- 
2.53.0



