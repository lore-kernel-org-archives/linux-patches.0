Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB96278F4A;
	Fri, 24 Apr 2026 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037587; cv=none; b=gIJTRYnhA0vwt+vn6hqQ2Kopv3CsLkmx5KMEkpXcMHgMezhUt6cHYynU7U+A70mveAQsZhuqceCsPLT7U5YP0rwxJLqxsYONB29gdJZyATrvFkDmX6HqKL7xqz/L+KeaReEsErj3NjaHbLKH4JbwYFq/6BVioEIDIlgL8SilW6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037587; c=relaxed/simple;
	bh=zuaswbwwNpzcAxCr9GfgyuzymsHxbnunj1s4GENfpmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZDB7tSxo4WYl9z5Qofj3Mg6+6vAySQmB15etGGPBH33/n0QTnHkDWm/qr5t9EYGS6CTBJfyeVnI8p1kWpmeFl1E6bwnWoX0ZP1R+bq+jcf5PVjE39LvSfRC/c/xG9IlczI4WybALds6TQBmhSHmEgcLMq0+9LQe6avj5GCU3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz8aZ/5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz8aZ/5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CB7C2BCB2;
	Fri, 24 Apr 2026 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037587;
	bh=zuaswbwwNpzcAxCr9GfgyuzymsHxbnunj1s4GENfpmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz8aZ/5iy5paw9fO3pfObMZUb73xvSw9pF5CNb9uLJA1oZy9X52GEE+bv+NkoGMnm
	 2WbRTBCRaiGAyuK3iO4XRYP1vuEBUCyN07yR4MJF85CEKt3bOSVBN8GLVp9m/Sv2Hw
	 8lrDUs/IgKeCqdICdKMC2qrlqDgB2WcbD4KjBRYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 36/42] ALSA: caiaq: take a reference on the USB device in create_card()
Date: Fri, 24 Apr 2026 15:31:01 +0200
Message-ID: <20260424132428.040392455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Berk Cem Goksel <berkcgoksel@gmail.com>

commit 80bb50e2d459213cccff3111d5ef98ed4238c0d5 upstream.

The caiaq driver stores a pointer to the parent USB device in
cdev->chip.dev but never takes a reference on it. The card's
private_free callback, snd_usb_caiaq_card_free(), can run
asynchronously via snd_card_free_when_closed() after the USB
device has already been disconnected and freed, so any access to
cdev->chip.dev in that path dereferences a freed usb_device.

On top of the refcounting issue, the current card_free implementation
calls usb_reset_device(cdev->chip.dev). A reset in a free callback
is inappropriate: the device is going away, the call takes the
device lock in a teardown context, and the reset races with the
disconnect path that the callback is already cleaning up after.

Take a reference on the USB device in create_card() with
usb_get_dev(), drop it with usb_put_dev() in the free callback,
and remove the usb_reset_device() call.

Fixes: b04dcbb7f7b1 ("ALSA: caiaq: Use snd_card_free_when_closed() at disconnection")
Cc: stable@vger.kernel.org
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Berk Cem Goksel <berkcgoksel@gmail.com>
Link: https://patch.msgid.link/20260413034941.1131465-3-berkcgoksel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -384,7 +384,7 @@ static void card_free(struct snd_card *c
 	snd_usb_caiaq_input_free(cdev);
 #endif
 	snd_usb_caiaq_audio_free(cdev);
-	usb_reset_device(cdev->chip.dev);
+	usb_put_dev(cdev->chip.dev);
 }
 
 static int create_card(struct usb_device *usb_dev,
@@ -410,7 +410,7 @@ static int create_card(struct usb_device
 		return err;
 
 	cdev = caiaqdev(card);
-	cdev->chip.dev = usb_dev;
+	cdev->chip.dev = usb_get_dev(usb_dev);
 	cdev->chip.card = card;
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));


