Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EEC3E51C9;
	Mon,  4 May 2026 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904912; cv=none; b=BtejcW39O4fFBReaopjRc4LtV5IkE+G3UFpCn4hJfHDgHxy5MfHffmYWvD6Fozmi59ujlaFaVlPd5CvuX8i3QCJZBTZcxDpILUNnUc2DRi5AFDzwekEiRnPoqegMfgprwzf6iQB/kF01b62SbS0dceloMb+QqSkubm1fXZQCXt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904912; c=relaxed/simple;
	bh=Hwxy3IoMJLNJyhz7ZwkO1uWMK70wpW1UNhM7fP8m9qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrlAmL8frqINgKLhL8ulWLftVImtqpuISnGRfpeY9J+BEkl6ZPXhyY2s+bQFx7T4MuMx8ZufwZsyvAqIpd+igJrXbht6U29OrYHzLqQNF+AhSy6eeikvyHyV8XDVUElNoAd07O+/EC8CnF/hE0CyVEJidEoZI0QgNm2/86b5LmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eykn3mEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eykn3mEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52E6C2BCB8;
	Mon,  4 May 2026 14:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904912;
	bh=Hwxy3IoMJLNJyhz7ZwkO1uWMK70wpW1UNhM7fP8m9qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eykn3mELyCQOZfr6AHGSpaBnFJIn9n52zuywqKdkAOhhbTsbGtnmcq2+XQFKKxK69
	 Kik/LtDCvF1jwFXbX5sEgKEolx9JcbWaig3kSoSLYJgoDIRNMXeI9Vt37rzo+S5jfp
	 6ACtvgp18eH5K+YkIFJAGD/y4xSZgQJmg6i7ra2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2afd7e71155c7e241560@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 213/215] ALSA: caiaq: fix usb_dev refcount leak on probe failure
Date: Mon,  4 May 2026 15:53:52 +0200
Message-ID: <20260504135138.608968000@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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


