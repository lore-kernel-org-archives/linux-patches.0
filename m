Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE06E2E093A;
	Mon, 20 Apr 2026 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701118; cv=none; b=nMUKv/0B2+IiTJstWTfLaaleF9k1jO+ujFaoHS/P2NjHkn3YvokJFYtTnJ97jWDgTvYb3WLtIO6btg68+ji9qFFs93UF95Bzp8yeb/suP+NCV3b3CdEb/tG73dzQDy/+Tgy/g+r/1STjrBAhU+4EsO+SDU16F9qzLZFAqgLzrtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701118; c=relaxed/simple;
	bh=KC+OzE4/TP1BQnW0iSJTCPrWBUmBXio3UgF+m2NB1cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdWT3OT34rjsQG4n/MgeFavSk4+u49i6HITfr6hHlP3owCM8EDD65l7XPtomX6GBC1O1UwvHCh72PAjd0ulPWiaQt+yJLFUz2tPpTnqtEz3BRmligptl2YmqIOSx9F3+Wf4Fg87e3c+N6kJ0SmZOw63EHYPqPEZFzhCLWBoQ/v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NShbpbyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NShbpbyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47347C19425;
	Mon, 20 Apr 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701118;
	bh=KC+OzE4/TP1BQnW0iSJTCPrWBUmBXio3UgF+m2NB1cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NShbpbyzm9sEBr/pS1/OBowMIG52ybewmaCQ6tG6HXqDMwHvORF03LkGLKBgO4/Mo
	 xyYiPtR1Q77NhyZaeLIzTlpWnnvBcQNuy81Ctovap0ivISiy+GWOVAViHz25/5tf4U
	 6GxyEVfdAwDuSHZZH0BFfr7OrTUGTmHp5J5WbOoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 189/198] ALSA: 6fire: fix use-after-free on disconnect
Date: Mon, 20 Apr 2026 17:42:48 +0200
Message-ID: <20260420153942.424071884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


