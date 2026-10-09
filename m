Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18544A7CA0;
	Fri,  9 Oct 2026 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556199; cv=none; b=AI+frEOIrOcUj1DIl+krcHJNXpctRZaiKGSa4cCsX9u2Gtq3O6DX5FeBH3MMyWks3iDSmJp5U0hTXhACnxu9a4PiS8PBIfIL5AMPNzAbh3msnWe4zfyCBE8h95eSOI4KKWOPclqYi9j8eg9LkmJiUswKKKP/k6m7Ko05L9jNjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556199; c=relaxed/simple;
	bh=JkA2wvfsa7X3TmuCz0DKIkj571POGO5g02wr3qgm+yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hl3LL3ogNgKY+uXtlroF84ngMEfN2cCk3iX6oMvwjVPGs7lcI6f71/m1AFsKhHmhMT5vr1hMhaXsDQ7Eil/2GNTK8F6cfZA4HUmjT61wJKPPc+8KYixL0z4uR/JZ+higdGpOcXCBLPUQVJy9+ttjI5WEJa20iRXOcUW5KqfHv6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jop0R7TK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jop0R7TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FF31F000FF;
	Fri,  9 Oct 2026 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556198;
	bh=o9LiTXbYJjJjNpZGQBzvxVSOJiJt7YeVRnsh9ejWQg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jop0R7TKHFS0Gh72gFdYNmqjvNsBpXTTLxqdx66poW/fxjJWp36MG3Hl5ECSv2/Ox
	 PG92qqZ3eW2VzmqHhCJfMpazDDV0aRIcWvNE3DS+qhgXAD/CbFqJvJ+u+bBoykmjrH
	 pYDelBDB8loGhX9Zw12khGzBt6PI0pSAFt6meWP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Sebastian=20Dalfu=C3=9F?= <sd@sedf.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 136/428] ALSA: usb-audio: Add boot quirk for Behringer CM1A
Date: Fri,  9 Oct 2026 16:07:53 +0200
Message-ID: <20261009140949.167477277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Dalfuß <sd@sedf.de>

[ Upstream commit 45b5beb60bf7bd41c55ef17f6f2d28b351fad6c0 ]

After a power cycle and reenumeration, the Behringer CM1A* leaves its
MIDI endpoint inoperative. USB enumeration and driver binding
complete successfully, but MIDI outputs remain pending.

A GET_DESCRIPTOR request for the device descriptor, issued after USB
configuration, makes the endpoint operational. Add a one time boot quirk
to perform that request before ALSA initializes the device.

*
ID 1397:1234 BEHRINGER International GmbH CM1A

Signed-off-by: Sebastian Dalfuß <sd@sedf.de>
Link: https://patch.msgid.link/apwG4DRfNyvmRzyb@sedf.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b5c4823cf3e4 ("ALSA: usb-audio: Apply boot quirk for Behringer models generically")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 681f4cff3546f..034bc4bbe7f4c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -849,6 +849,27 @@ static int snd_usb_accessmusic_boot_quirk(struct usb_device *dev)
 	return 0;
 }
 
+/*
+ * A post configuration device descriptor read is needed to make the CM1A
+ * operational after reenumeration.
+ */
+static int snd_usb_cm1a_boot_quirk(struct usb_device *dev)
+{
+	struct usb_device_descriptor *desc __free(kfree) = kmalloc_obj(*desc);
+	int err;
+
+	if (!desc)
+		return -ENOMEM;
+
+	err = usb_get_descriptor(dev, USB_DT_DEVICE, 0, desc, sizeof(*desc));
+	if (err < 0) {
+		dev_err(&dev->dev, "failed to read device descriptor: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 /*
  * Some sound cards from Native Instruments are in fact compliant to the USB
  * audio standard of version 2 and other approved USB standards, even though
@@ -1681,6 +1702,8 @@ int snd_usb_apply_boot_quirk_once(struct usb_device *dev,
 	switch (id) {
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series, 1st hardware version */
 		return snd_usb_motu_m_series_boot_quirk(dev);
+	case USB_ID(0x1397, 0x1234): /* Behringer CM1A */
+		return snd_usb_cm1a_boot_quirk(dev);
 	}
 
 	return 0;
-- 
2.53.0



