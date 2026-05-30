Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF64C39B4A6;
	Sat, 30 May 2026 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160333; cv=none; b=qAb8oHBDeuHHyLeBmdklTmcbYMQXUibpnVFvSLFPa1E7LtfMgwSHx0UsgjFiV+/1IYs44zvXhC7VMrstA3J+YKoA7S4Qt6h2KzRaF2ukiZCENyiqdyG0v4Qr8YJkNvjTkFH7GW0FLmfkgNvKI92J77axLjE3trrNsS9y/LkRcwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160333; c=relaxed/simple;
	bh=veTVYVdSU114fxsjeit+zsfUbR3ckEDFJ9THrUMR+u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+0DU+5CPmFCURo65eVBzX/4OGx7oWG33xDEeYFiCOye2OZWdE9xMTTATAmTR97kvu07DNMdXJAG1inDTvys7C69iP8d6mCVXLLGdrKXhArpFDLdYSNp6RHKdS3YUe7RURhe+uAXjKktQgyCMtvPo6mvmigX27nGyJ9xPvOxCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHVVtOZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHVVtOZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCF71F00893;
	Sat, 30 May 2026 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160332;
	bh=i+bTdsTHrtYAkaCa5UiHcUQE/RwebWKc3jK1Op0UNXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHVVtOZmzqH/2LpZ9Nurkon3Xk6uHyee0kyv4BXvqkAfuPrKqKwnqzguIIh4Em6i0
	 qIgaQZWVLbh7N96n4Soimg88+kJgt23u/g3vr2FtGou13Vb7yq0DpPs9j9G/TCWLZ9
	 XTllmCBYSHoa09/ux3PfFFc2VRaWalgm2Zb8uxBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2afd7e71155c7e241560@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 276/969] ALSA: caiaq: fix usb_dev refcount leak on probe failure
Date: Sat, 30 May 2026 17:56:40 +0200
Message-ID: <20260530160308.099066673@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 7a5f1cd22d47f8ca4b760b6334378ae42c1bd24b upstream.

create_card() takes a reference on the USB device with usb_get_dev()
and stores the matching usb_put_dev() in card_free(), which is
installed as the snd_card's ->private_free destructor.

However, ->private_free is only assigned near the end of init_card(),
after several failure points (usb_set_interface(), EP type checks,
usb_submit_urb(), the EP1_CMD_GET_DEVICE_INFO exchange, and its
timeout). When any of those fail, init_card() returns an error to
snd_probe(), which calls snd_card_free(card). Because ->private_free
is still NULL, card_free() never runs, the usb_get_dev() reference
is not dropped, and the struct usb_device leaks along with its
descriptor allocations and device_private.

syzbot reproduces this with a malformed UAC3 device whose only valid
altsetting is 0; init_card()'s usb_set_interface(usb_dev, 0, 1) call
fails with -EIO and triggers the leak.

Move the ->private_free assignment into create_card(), immediately
after usb_get_dev(), so that every error path reaching snd_card_free()
balances the reference. card_free()'s callees (snd_usb_caiaq_input_free,
free_urbs, kfree) already tolerate the partially-initialized state
because the chip private area is zero-initialized by snd_card_new().

Fixes: 80bb50e2d459 ("ALSA: caiaq: take a reference on the USB device in create_card()")
Reported-by: syzbot+2afd7e71155c7e241560@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2afd7e71155c7e241560
Tested-by: syzbot+2afd7e71155c7e241560@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260426001934.70813-1-kartikey406@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -423,6 +423,7 @@ static int create_card(struct usb_device
 
 	cdev = caiaqdev(card);
 	cdev->chip.dev = usb_get_dev(usb_dev);
+	card->private_free = card_free;
 	cdev->chip.card = card;
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
@@ -511,7 +512,6 @@ static int init_card(struct snd_usb_caia
 	snprintf(card->longname, sizeof(card->longname), "%s %s (%s)",
 		       cdev->vendor_name, cdev->product_name, usbpath);
 
-	card->private_free = card_free;
 	err = setup_card(cdev);
 	if (err < 0)
 		goto err_kill_urb;


