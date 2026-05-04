Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D153DEAD3;
	Mon,  4 May 2026 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904344; cv=none; b=lL7EDTudf+HCu9ikSmXdi6l+EtHyVuQ9lH8fUDrTW1nLtsX9GnPq2BtqEdYPDNLHsWwzUgUIV0JAs4zRXavLL0vo/5HwfVeSJYBIV0HARE2KPuvyqf0QTzRgeieH58yUBtZF2UQ1HrbNLF6g7DwYgrY4J6YxlyROMgGJtW5j/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904344; c=relaxed/simple;
	bh=GZNf80S3NOZf1cA45nGX5jcYOgT4BIFvlVle8lm2dWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIsuUuZM24+Y4JU0Yi//thdMeA2C3qb0BT3xvUZ2BID5gRtOp9NHz7F4WaLXzXHuDYw1VwgExPRlgbxDbXKlGSeLmz+QuRE3BDXXRZtgPKDyiQCLYtmj0+HH9Slrh0UZgFztJa402kpLZSfV6R/o8tbW5l0glhrVp13AXyOByYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ossNCvZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ossNCvZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4E6C2BCB8;
	Mon,  4 May 2026 14:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904344;
	bh=GZNf80S3NOZf1cA45nGX5jcYOgT4BIFvlVle8lm2dWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ossNCvZwTBiJB5PeHogYTl6KhbcBpcuXQz4jFIf/loHNuXmPeGFQWcvh5QHQr9cKG
	 rJFjKBIVKjUqEfEnYI9i3roiwQY9abf9OL80Vk4DJkqBcL/hYGvfxyU9K5ZN2qhmoA
	 QcjOVCZ5rcBiDMm8GlYGoZ+OG2cOxZn8dRgWQm1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2afd7e71155c7e241560@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 269/275] ALSA: caiaq: fix usb_dev refcount leak on probe failure
Date: Mon,  4 May 2026 15:53:29 +0200
Message-ID: <20260504135153.028099945@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
 	scnprintf(card->longname, sizeof(card->longname), "%s %s (%s)",
 		       cdev->vendor_name, cdev->product_name, usbpath);
 
-	card->private_free = card_free;
 	err = setup_card(cdev);
 	if (err < 0)
 		goto err_kill_urb;


