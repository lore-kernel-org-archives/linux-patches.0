Received: from mail114-240.sinamail.sina.com.cn (mail114-240.sinamail.sina.com.cn [218.30.114.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78750366052
	for <patches@lists.linux.dev>; Wed, 20 May 2026 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.114.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779263089; cv=none; b=LW89hzeWTfbse6+fLrj+H9zpsJgHFf+NZXAX5LF2NrVefg1qc5Y9ri/+mssr5GGFGpoKmohfPBkpOkjmZiNuCnO6HVerWWlxNrYupXqMHznCxpeQJnqhf4e6CBusL/MX0C/rQQeYN8U5Ew6cNEk6PErFhhRucoeXqttmXiDqNgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779263089; c=relaxed/simple;
	bh=uXkYFxdaAETwxJgpORJBxdQY2Eu+hISiH3UitJQD50c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KR2R8FImPUcWflZrcD2HCF/gb005dPrSS6vtj2e3kqznJRBhc+CRMGHuXiFFk7RnTXRbJWzRTTTgKLNqjWDU2t4ILO3MtWtcc0rqHeuue9H3sy8iRY+f9Dx15f+bdBjkzK6MpAE1cEy9h56IGMvhzmKh35mkdycD6ML+MHz7I/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=KkZVQlKB; arc=none smtp.client-ip=218.30.114.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="KkZVQlKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1779263084;
	bh=VbljUZZ+f3x/ZX7/096BB0jO8aeqIRyL8nsBVLH0DC4=;
	h=From:Subject:Date:Message-Id;
	b=KkZVQlKBSyAVRZ7EWjI9sQA2oirXbF1y2UuiMJhIR9OuwBfG3H7XZE++axGOf8QJH
	 s7354CkyNgI+9XJC7aCDzIQcpaysuv6nmWqE1Gn8Jk1baQYbbj5ktNjZDEd9fxLVez
	 B0OTaLQ788KvT3mlelMitWhVuuhpZe6NHTJIP9ZE=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.23) with ESMTP
	id 6A0D666000000184; Wed, 20 May 2026 15:44:34 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 9922928912952
X-SMAIL-UIID: 28CF97DE4ACC47EE977A656367876B80-20260520-154434-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	berkcgoksel@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	zonque@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	tiwai@suse.de
Subject: [PATCH 6.1.y] ALSA: caiaq: take a reference on the USB device in create_card()
Date: Wed, 20 May 2026 15:44:33 +0800
Message-Id: <20260520074433.3784952-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Berk Cem Goksel <berkcgoksel@gmail.com>

[ Upstream commit 80bb50e2d459213cccff3111d5ef98ed4238c0d5 ]

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
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 sound/usb/caiaq/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 910b2ee83a17..b66737792ebd 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -384,7 +384,7 @@ static void card_free(struct snd_card *card)
 	snd_usb_caiaq_input_free(cdev);
 #endif
 	snd_usb_caiaq_audio_free(cdev);
-	usb_reset_device(cdev->chip.dev);
+	usb_put_dev(cdev->chip.dev);
 }
 
 static int create_card(struct usb_device *usb_dev,
@@ -410,7 +410,7 @@ static int create_card(struct usb_device *usb_dev,
 		return err;
 
 	cdev = caiaqdev(card);
-	cdev->chip.dev = usb_dev;
+	cdev->chip.dev = usb_get_dev(usb_dev);
 	cdev->chip.card = card;
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
-- 
2.34.1

