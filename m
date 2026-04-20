Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBE3336896;
	Mon, 20 Apr 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700555; cv=none; b=XPfQOYUm2OXyScurhIe6wbJogLKmrKSp9dYDMgi7QvMpN5FJmPwJrskkXT3dGLLDZ8kLS6WNPx2a9PSGbOyc4qEoL4kLLGCSfyvudiRbaIFknLYJ7P6auMsJhkrTNapHKdhJkqZ10Fn3GfvrfGlzdYp5O7O22mxY+KRH5xAX++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700555; c=relaxed/simple;
	bh=vWMrgbicuGrFQN2Aj1y3J23atsjIBaDRsqhKbsCEZsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA7ljWTe6MFbDXfhPwI6vZI/gmdwUCmk8CO3zo53+FQcHalGo9zUrDrAwDtRSx6ka/hn/zwzF8C04qOsW5bC8dK7sgfZ8hcGMrxH4vES1+iyX7Nxnlxhkv88RSxnTmnmweJWhroIOwnC9HBqHhyM/j+SO5f3QfXxD89fO4PTM58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3NBTpFW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3NBTpFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42783C19425;
	Mon, 20 Apr 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700555;
	bh=vWMrgbicuGrFQN2Aj1y3J23atsjIBaDRsqhKbsCEZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3NBTpFWZs4/cXIZur6QoAkmQ3KZGXuAYqeK4w+bNOO0VZgfUqtDhGo7IkuwnvMvQ
	 Km0zhV12wVJl6HP9yiAF/D5nI4ICVAf6o7/H9RhOYWoZSNR8QKCgTFrHyojdU///c7
	 xSP5hBItES6M0K/4YgvPfEUOhTvWepfitqD1W1nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 211/220] ALSA: 6fire: fix use-after-free on disconnect
Date: Mon, 20 Apr 2026 17:42:32 +0200
Message-ID: <20260420153941.624417766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berk Cem Goksel <berkcgoksel@gmail.com>

commit b9c826916fdce6419b94eb0cd8810fdac18c2386 upstream.

In usb6fire_chip_abort(), the chip struct is allocated as the card's
private data (via snd_card_new with sizeof(struct sfire_chip)).  When
snd_card_free_when_closed() is called and no file handles are open, the
card and embedded chip are freed synchronously.  The subsequent
chip->card = NULL write then hits freed slab memory.

Call trace:
  usb6fire_chip_abort sound/usb/6fire/chip.c:59 [inline]
  usb6fire_chip_disconnect+0x348/0x358 sound/usb/6fire/chip.c:182
  usb_unbind_interface+0x1a8/0x88c drivers/usb/core/driver.c:458
  ...
  hub_event+0x1a04/0x4518 drivers/usb/core/hub.c:5953

Fix by moving the card lifecycle out of usb6fire_chip_abort() and into
usb6fire_chip_disconnect().  The card pointer is saved in a local
before any teardown, snd_card_disconnect() is called first to prevent
new opens, URBs are aborted while chip is still valid, and
snd_card_free_when_closed() is called last so chip is never accessed
after the card may be freed.

Fixes: a0810c3d6dd2 ("ALSA: 6fire: Release resources at card release")
Cc: stable@vger.kernel.org
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Berk Cem Goksel <berkcgoksel@gmail.com>
Link: https://patch.msgid.link/20260410051341.1069716-1-berkcgoksel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/chip.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -53,11 +53,6 @@ static void usb6fire_chip_abort(struct s
 			usb6fire_comm_abort(chip);
 		if (chip->control)
 			usb6fire_control_abort(chip);
-		if (chip->card) {
-			snd_card_disconnect(chip->card);
-			snd_card_free_when_closed(chip->card);
-			chip->card = NULL;
-		}
 	}
 }
 
@@ -168,6 +163,7 @@ destroy_chip:
 static void usb6fire_chip_disconnect(struct usb_interface *intf)
 {
 	struct sfire_chip *chip;
+	struct snd_card *card;
 
 	chip = usb_get_intfdata(intf);
 	if (chip) { /* if !chip, fw upload has been performed */
@@ -178,8 +174,19 @@ static void usb6fire_chip_disconnect(str
 				chips[chip->regidx] = NULL;
 			}
 
+			/*
+			 * Save card pointer before teardown.
+			 * snd_card_free_when_closed() may free card (and
+			 * the embedded chip) immediately, so it must be
+			 * called last and chip must not be accessed after.
+			 */
+			card = chip->card;
 			chip->shutdown = true;
+			if (card)
+				snd_card_disconnect(card);
 			usb6fire_chip_abort(chip);
+			if (card)
+				snd_card_free_when_closed(card);
 		}
 	}
 }


