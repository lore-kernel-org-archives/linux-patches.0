Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B993246770;
	Tue, 13 Oct 2026 12:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894853; cv=none; b=hFO9OgijxAunk2U/t8M+/eBp9UPwkk9sICgiB3QYTDrBYrikkSmJHDXm7TtBBBp30BZKKosmhF0IfxfnsOdq0OTsCuP4YB/EjUV9Fq3BBrGWpiQZYfC+vUc/XTDKIt9/rePoVLhaSkEi9b5bKm9QIJx++hYH8UyKfg0bEN0svus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894853; c=relaxed/simple;
	bh=Wa5obE/QXlpaep5Li2Odt+vbFcRVwvjKr626fBpNg7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlC8qiP7D/k6kMGjJiL+hv/6GM3Y/SLcravhcjwqM+/8GG+OBouj5FuTUGF4gBBirhWcErme0kGkDMaruMxGYH5jJNqadVDWkHGDkCxnjvzruvGaL38hc86Ox92Kx0DhG4kssKq/U1RLUQVxnjmoqcYPmZTTbDyuFXzF1BxVqzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErokSv09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErokSv09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ABC1F00893;
	Tue, 13 Oct 2026 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894851;
	bh=1pIwkaHexexEWD58x70t4AKnC49o+6JrYj1pII5ftck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErokSv09SwYYaOh1ghefUxTxuAmRwOuH7VOD3+WubCjNHZVtI9j6gjeczacdU0c56
	 sR/nydxGIXXym0nZLEnWD1niyu1+mmrRBGDj0Y8VFXjJYjufQZu1iSoKKA7h77tH8N
	 zrQ6A0WTRK10LpGQw5EtfuE69cZ39uD64/pVpNiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 041/497] ALSA: caiaq: unregister the input device when probe fails
Date: Tue, 13 Oct 2026 13:33:28 +0200
Message-ID: <20261013112908.864713582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

commit 0b7bd20f6379bc5e431fd74d866390f5b5b63f3c upstream.

setup_card() registers the input device, whose name and phys point into
struct snd_usb_caiaqdev, and then goes on to snd_card_register() and
snd_usb_caiaq_control_init(). If either fails, snd_probe() calls
snd_card_free(), which frees the device state but leaves the input
device registered: card_free() only clears the pointer, and the input
device is unregistered from snd_disconnect() alone. Reading its "uevent"
attribute afterwards dereferences freed memory:

  BUG: KASAN: slab-use-after-free in string+0x4a9/0x4f0
  Read of size 1 at addr ffff8880208f5043 by task caiaq/4967
   add_uevent_var+0x183/0x3a0
   input_dev_uevent+0x162/0x900
   dev_uevent+0x2f1/0x870
   uevent_show+0x1ca/0x3a0
   ...

Unregister the input device on the probe error path, as
snd_disconnect() does. snd_usb_caiaq_input_disconnect() is a no-op when
no input device was registered.

Reproduced with a raw-gadget Audio Kontrol 1 and a temporary hack that
makes snd_usb_caiaq_control_init() fail.

Fixes: 28abd224db4a ("ALSA: caiaq: Handle probe errors properly")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2a123f6269da57ffefaa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2a123f6269da57ffefaa
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260925170717.22462-1-ngocthang2710.1999@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -562,6 +562,9 @@ static int snd_probe(struct usb_interfac
 	ret = init_card(caiaqdev(card));
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "unable to init card! (ret=%d)\n", ret);
+#ifdef CONFIG_SND_USB_CAIAQ_INPUT
+		snd_usb_caiaq_input_disconnect(caiaqdev(card));
+#endif
 		snd_card_free(card);
 		return ret;
 	}


