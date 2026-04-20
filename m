Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D34D2853F3;
	Mon, 20 Apr 2026 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701534; cv=none; b=AFnzyg349YmgjmuAycmbsMCa6f9cARqWVMumjhiKML8dP9zvYD9VJ2YCzHRzxhMXltbBfgSrwfbe6KqIOuH9YgS99hwxw4WOLTXQ7ecMq4VEUpD4Ef8oOJiK3G+IueUMYIeCkKrIQ1L6kg0Pcp0rPwDfps7JyrANRr+uALUyPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701534; c=relaxed/simple;
	bh=XcVsjhWOOLbMQIRO9M6ohd1xEEoI+1uHBwV0iXlkVg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTnhMif4DwlbaaMzTLdW+8jRJ1uTTLwO5DwL5YwrbZdCdu346wYqY7w9044LFhYgvxetSNMTLiVTCX8oSVM50T7G5aX88G3dyh97C/noxAiKLxGh9i6laIG8pvQIyb03S72q8d5hwg3XSHO0WUAzK29PpB++02pOhgDl1v3/PzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1VLQpEb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1VLQpEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13631C19425;
	Mon, 20 Apr 2026 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701534;
	bh=XcVsjhWOOLbMQIRO9M6ohd1xEEoI+1uHBwV0iXlkVg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1VLQpEb2747URtdhN5C++TQUUXVKLLexRMSS6BfbRzlepRY3LsAihh4FMAj6j3lt
	 vrw33Y0Kwh6f5jC9UyoWq0CmiQp0dEGHfReB7e3dGcj9o4YGmwmz/rsDNUFOfH+fgi
	 UAswbyRisRywni10GrXwX9ihcNTphLOkO/mHyGcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 150/162] ALSA: 6fire: fix use-after-free on disconnect
Date: Mon, 20 Apr 2026 17:43:02 +0200
Message-ID: <20260420153932.483112066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -170,6 +165,7 @@ destroy_chip:
 static void usb6fire_chip_disconnect(struct usb_interface *intf)
 {
 	struct sfire_chip *chip;
+	struct snd_card *card;
 
 	chip = usb_get_intfdata(intf);
 	if (chip) { /* if !chip, fw upload has been performed */
@@ -180,8 +176,19 @@ static void usb6fire_chip_disconnect(str
 			chips[chip->regidx] = NULL;
 			mutex_unlock(&register_mutex);
 
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


