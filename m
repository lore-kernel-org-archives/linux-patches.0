Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D288F1CAA6C;
	Sat, 30 May 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159970; cv=none; b=YQM/nnVFrsL2CC/4xgz3jTnl5AMeYdsuVopZQ5Tb9hunh/kT5Izmp2H3kG8uqlKQoVXztuNU88kW8BxHTy1Qguenl71TgEKlWafOxRYTFwQNhEiXxj6x3KtbSJmC8IFlBjtXderEFK7NHvZ2ud2oj5KwTsRrFUOwnBxWkz6oedU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159970; c=relaxed/simple;
	bh=pRHp96LBG7woT/irtDjQoeAgJZpF/snULqmK/wDEMZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcFJL62uap5NsDbQuOasyDCNwchQtgftAPGcuWGMMOkAPZzmDaa0fk7gt/AOdRItxVx2WCIC45Qx6qHNAG+fFj8QQO36ATzU7WMqtAIytKTASjgoTJT/cWj44OO+TpfLePM4zGQbuH2fyxX8znU8Fmh2SYPexYokm5lB9qTLbfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LNHA97M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LNHA97M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57AE1F00893;
	Sat, 30 May 2026 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159968;
	bh=sP4ZNGwOL7W6lWHnTPDHbXwz8Dmzcfr4KEpYjUG2bbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LNHA97MuAHskVF145UJIGKUBuQutUJQRiTHJ/5CiDHPdAYhi3TGS/lWPEMCPthQI
	 EmgqagBJ3i196djxtSvLTmHnvmpc+GtmufYI50PUZT1Yj0DJ96qR9DHt2MhRlJQDUX
	 eW402yVJj3HpCc7X07fCElZ9Hcuej+m4Xy0jfNA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 210/969] ALSA: caiaq: Handle probe errors properly
Date: Sat, 30 May 2026 17:55:34 +0200
Message-ID: <20260530160306.266522061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 28abd224db4a49560b452115bca3672a20e45b2f upstream.

The probe procedure of setup_card() in caiaq driver doesn't treat the
error cases gracefully, e.g. the error from snd_card_register() calls
snd_card_free() but continues.  This would lead to a UAF for the
further calls like snd_usb_caiaq_control_init(), as Berk suggested in
another patch in the link below.

However, the problem is not only that; in general, this function drops
the all error handlings (as it's a void function) although its caller
can propagate an error to snd_probe(), which eventually calls
snd_card_free() as a proper error path.  That said, we should treat
each error case in setup_card(), and just return the error code
promptly, which is then handled later as a fatal error in snd_probe().

This patch achieves it by changing the setup_card() to return an error
code.  Also, the superfluous snd_card_free() call is removed, too.

Note that card->private_free can be set still safely at returning an
error.  All called functions in card_free() have checks of the
unassigned resources or NULL checks.

Fixes: 8e3cd08ed8e5 ("[ALSA] caiaq - add control API and more input features")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20260413034941.1131465-2-berkcgoksel@gmail.com
Link: https://patch.msgid.link/20260414105916.364073-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -290,7 +290,7 @@ int snd_usb_caiaq_set_auto_msg(struct sn
 					  tmp, sizeof(tmp));
 }
 
-static void setup_card(struct snd_usb_caiaqdev *cdev)
+static int setup_card(struct snd_usb_caiaqdev *cdev)
 {
 	int ret;
 	char val[4];
@@ -325,8 +325,10 @@ static void setup_card(struct snd_usb_ca
 		snd_usb_caiaq_send_command(cdev, EP1_CMD_READ_IO, NULL, 0);
 
 		if (!wait_event_timeout(cdev->ep1_wait_queue,
-					cdev->control_state[0] != 0xff, HZ))
-			return;
+					cdev->control_state[0] != 0xff, HZ)) {
+			dev_err(dev, "Read timeout for control state\n");
+			return -EINVAL;
+		}
 
 		/* fix up some defaults */
 		if ((cdev->control_state[1] != 2) ||
@@ -347,33 +349,43 @@ static void setup_card(struct snd_usb_ca
 	    cdev->spec.num_digital_audio_out +
 	    cdev->spec.num_digital_audio_in > 0) {
 		ret = snd_usb_caiaq_audio_init(cdev);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(dev, "Unable to set up audio system (ret=%d)\n", ret);
+			return ret;
+		}
 	}
 
 	if (cdev->spec.num_midi_in +
 	    cdev->spec.num_midi_out > 0) {
 		ret = snd_usb_caiaq_midi_init(cdev);
-		if (ret < 0)
+		if (ret < 0) {
 			dev_err(dev, "Unable to set up MIDI system (ret=%d)\n", ret);
+			return ret;
+		}
 	}
 
 #ifdef CONFIG_SND_USB_CAIAQ_INPUT
 	ret = snd_usb_caiaq_input_init(cdev);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "Unable to set up input system (ret=%d)\n", ret);
+		return ret;
+	}
 #endif
 
 	/* finally, register the card and all its sub-instances */
 	ret = snd_card_register(cdev->chip.card);
 	if (ret < 0) {
 		dev_err(dev, "snd_card_register() returned %d\n", ret);
-		snd_card_free(cdev->chip.card);
+		return ret;
 	}
 
 	ret = snd_usb_caiaq_control_init(cdev);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "Unable to set up control system (ret=%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
 }
 
 static void card_free(struct snd_card *card)
@@ -499,8 +511,11 @@ static int init_card(struct snd_usb_caia
 	snprintf(card->longname, sizeof(card->longname), "%s %s (%s)",
 		       cdev->vendor_name, cdev->product_name, usbpath);
 
-	setup_card(cdev);
 	card->private_free = card_free;
+	err = setup_card(cdev);
+	if (err < 0)
+		return err;
+
 	return 0;
 
  err_kill_urb:


