Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930CB2236EA;
	Thu, 12 Dec 2024 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019511; cv=none; b=Dq/DA3sf1fO0KwFA9gBUHI6uc0y4XKDncnFMLm7D2bcKVdX4cfvB0xX7U53AU4/VjYRSM1i7xuM4GyKkBK+fLr1tUsyzilXltXsJnkZK+/G8IVYaXoFCM7rjj6N7jMS2cR24RaZGihUFk2fo/yRnXHyo9Ld9g5SzP9pK+IeOfKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019511; c=relaxed/simple;
	bh=mGXJ5Io1ofmgHR5+menqo9oV/Ak9ATxcUgzvwn+sVzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y12ZIpQzLpsC2UsxF2PcpVLXVtFdIrCqa0WHHaHqQ+ZYNQWfM8C7rnw2dYcOw3AoIysCoVDXoYMj9yZbkT6ZpobL7MSvJsQ+P9iwEl7KtUXUEiMWfY5nd6wPUNzdQCcdvlW/UGgSnJpwxHqpp5USYH3fko805+cJG/vnxLpS9Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qtcv2+mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qtcv2+mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA17C4CECE;
	Thu, 12 Dec 2024 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019511;
	bh=mGXJ5Io1ofmgHR5+menqo9oV/Ak9ATxcUgzvwn+sVzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qtcv2+mkv2qp9fI/CAokywAw8BwoWMX5MkbsdCtbDXQq6zHm4GrtwvEllrVXsQQTW
	 m+u3T/AbFuDVOCVlDcEkNh8P0nsCbh3F4irlznBynmlOnO+iak/xGWIOblejHGri4C
	 nR+0OkY3PN+5GyoC2lRWXWoCNeD5TEYbhzxgIV8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/772] ALSA: 6fire: Release resources at card release
Date: Thu, 12 Dec 2024 15:52:21 +0100
Message-ID: <20241212144358.038836982@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a0810c3d6dd2d29a9b92604d682eacd2902ce947 ]

The current 6fire code tries to release the resources right after the
call of usb6fire_chip_abort().  But at this moment, the card object
might be still in use (as we're calling snd_card_free_when_closed()).

For avoid potential UAFs, move the release of resources to the card's
private_free instead of the manual call of usb6fire_chip_destroy() at
the USB disconnect callback.

Fixes: c6d43ba816d1 ("ALSA: usb/6fire - Driver for TerraTec DMX 6Fire USB")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241113111042.15058-6-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/6fire/chip.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/6fire/chip.c b/sound/usb/6fire/chip.c
index 33e962178c936..d562a30b087f0 100644
--- a/sound/usb/6fire/chip.c
+++ b/sound/usb/6fire/chip.c
@@ -61,8 +61,10 @@ static void usb6fire_chip_abort(struct sfire_chip *chip)
 	}
 }
 
-static void usb6fire_chip_destroy(struct sfire_chip *chip)
+static void usb6fire_card_free(struct snd_card *card)
 {
+	struct sfire_chip *chip = card->private_data;
+
 	if (chip) {
 		if (chip->pcm)
 			usb6fire_pcm_destroy(chip);
@@ -72,8 +74,6 @@ static void usb6fire_chip_destroy(struct sfire_chip *chip)
 			usb6fire_comm_destroy(chip);
 		if (chip->control)
 			usb6fire_control_destroy(chip);
-		if (chip->card)
-			snd_card_free(chip->card);
 	}
 }
 
@@ -136,6 +136,7 @@ static int usb6fire_chip_probe(struct usb_interface *intf,
 	chip->regidx = regidx;
 	chip->intf_count = 1;
 	chip->card = card;
+	card->private_free = usb6fire_card_free;
 
 	ret = usb6fire_comm_init(chip);
 	if (ret < 0)
@@ -162,7 +163,7 @@ static int usb6fire_chip_probe(struct usb_interface *intf,
 	return 0;
 
 destroy_chip:
-	usb6fire_chip_destroy(chip);
+	snd_card_free(card);
 	return ret;
 }
 
@@ -181,7 +182,6 @@ static void usb6fire_chip_disconnect(struct usb_interface *intf)
 
 			chip->shutdown = true;
 			usb6fire_chip_abort(chip);
-			usb6fire_chip_destroy(chip);
 		}
 	}
 }
-- 
2.43.0



