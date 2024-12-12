Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2586211493;
	Thu, 12 Dec 2024 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024094; cv=none; b=LqLsVfisqoXMtEoOqffTFs3gTdWUWDLuWwy1xOlpZrQhp0/XSuQHFLdI4vzbDI+IVNslDHv3T7UXDmmgMMmOYAic+98NpLZABQ7EqyFXdWDrVotBilU8vckAFWZbg77TMfSJfCG2vzVIdg/Fc26PaMriCPnLOpic3GTMnHoXsMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024094; c=relaxed/simple;
	bh=buwBPoZPaSFuSkYSugud5zoRWy1O/ZerTI5ItH+kbdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FokNRv81Bx1Zxy4m/gO3VYGnFV5Ie21I0quWqOoUa93wccyTb6wPVZ3+28iYkzVFcUOpsMigBKZsVd3T/wfvqWwMRJ/3MHA7ZkS1/eUeYwXQt10QLb4E23qd/tlFZkNAAfQv9sFsePZkdHZZZZtKlhKaYgjaIvmb4GjHJ7h/YeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibMTWRrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibMTWRrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F412C4CECE;
	Thu, 12 Dec 2024 17:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024093;
	bh=buwBPoZPaSFuSkYSugud5zoRWy1O/ZerTI5ItH+kbdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ibMTWRrIA8C9NElcN2ZQ53gaA4p5tmNLCW3Vsr/4SgM9aPjrq3LLXVtvQDB6qZ3F5
	 zn7lW5dPAGG6jeX8LrD3d2StG7nugl/KGY7oJj2dyQwJY2sTNBVn6DklEA2i3++QAs
	 lWTGECZoZBCaXcjMCF0KXu9JIFE+KM99PQk8A1Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 154/459] ALSA: usx2y: Cleanup probe and disconnect callbacks
Date: Thu, 12 Dec 2024 15:58:12 +0100
Message-ID: <20241212144259.601405832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2ac7a12ead2be2e31bd5e796455bef31e8516845 ]

Minor code refactoring by merging the superfluous function calls.
The functions were split in the past for covering pre-history USB
driver code, but this is utterly useless.

Link: https://lore.kernel.org/r/20210517131545.27252-11-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: dafb28f02be4 ("ALSA: usx2y: Use snd_card_free_when_closed() at disconnection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 107 ++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 67 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index 373c600ba3fec..9d5a33c4ff2f3 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -149,7 +149,6 @@ MODULE_PARM_DESC(enable, "Enable "NAME_ALLCAPS".");
 
 static int snd_usx2y_card_used[SNDRV_CARDS];
 
-static void usx2y_usb_disconnect(struct usb_device *usb_device, void *ptr);
 static void snd_usx2y_card_private_free(struct snd_card *card);
 
 /*
@@ -363,66 +362,6 @@ static int usx2y_create_card(struct usb_device *device,
 	return 0;
 }
 
-static int usx2y_usb_probe(struct usb_device *device,
-			   struct usb_interface *intf,
-			   const struct usb_device_id *device_id,
-			   struct snd_card **cardp)
-{
-	int		err;
-	struct snd_card *card;
-
-	*cardp = NULL;
-	if (le16_to_cpu(device->descriptor.idVendor) != 0x1604 ||
-	    (le16_to_cpu(device->descriptor.idProduct) != USB_ID_US122 &&
-	     le16_to_cpu(device->descriptor.idProduct) != USB_ID_US224 &&
-	     le16_to_cpu(device->descriptor.idProduct) != USB_ID_US428))
-		return -EINVAL;
-
-	err = usx2y_create_card(device, intf, &card);
-	if (err < 0)
-		return err;
-	err = usx2y_hwdep_new(card, device);
-	if (err < 0)
-		goto error;
-	err = snd_card_register(card);
-	if (err < 0)
-		goto error;
-	*cardp = card;
-	return 0;
-
- error:
-	snd_card_free(card);
-	return err;
-}
-
-/*
- * new 2.5 USB kernel API
- */
-static int snd_usx2y_probe(struct usb_interface *intf, const struct usb_device_id *id)
-{
-	struct snd_card *card;
-	int err;
-
-	err = usx2y_usb_probe(interface_to_usbdev(intf), intf, id, &card);
-	if (err < 0)
-		return err;
-	dev_set_drvdata(&intf->dev, card);
-	return 0;
-}
-
-static void snd_usx2y_disconnect(struct usb_interface *intf)
-{
-	usx2y_usb_disconnect(interface_to_usbdev(intf),
-			     usb_get_intfdata(intf));
-}
-
-static struct usb_driver snd_usx2y_usb_driver = {
-	.name =		"snd-usb-usx2y",
-	.probe =	snd_usx2y_probe,
-	.disconnect =	snd_usx2y_disconnect,
-	.id_table =	snd_usx2y_usb_id_table,
-};
-
 static void snd_usx2y_card_private_free(struct snd_card *card)
 {
 	struct usx2ydev *usx2y = usx2y(card);
@@ -436,18 +375,15 @@ static void snd_usx2y_card_private_free(struct snd_card *card)
 		snd_usx2y_card_used[usx2y->card_index] = 0;
 }
 
-/*
- * Frees the device.
- */
-static void usx2y_usb_disconnect(struct usb_device *device, void *ptr)
+static void snd_usx2y_disconnect(struct usb_interface *intf)
 {
 	struct snd_card *card;
 	struct usx2ydev *usx2y;
 	struct list_head *p;
 
-	if (!ptr)
+	card = usb_get_intfdata(intf);
+	if (!card)
 		return;
-	card = ptr;
 	usx2y = usx2y(card);
 	usx2y->chip_status = USX2Y_STAT_CHIP_HUP;
 	usx2y_unlinkseq(&usx2y->as04);
@@ -463,4 +399,41 @@ static void usx2y_usb_disconnect(struct usb_device *device, void *ptr)
 	snd_card_free(card);
 }
 
+static int snd_usx2y_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	struct usb_device *device = interface_to_usbdev(intf);
+	struct snd_card *card;
+	int err;
+
+	if (le16_to_cpu(device->descriptor.idVendor) != 0x1604 ||
+	    (le16_to_cpu(device->descriptor.idProduct) != USB_ID_US122 &&
+	     le16_to_cpu(device->descriptor.idProduct) != USB_ID_US224 &&
+	     le16_to_cpu(device->descriptor.idProduct) != USB_ID_US428))
+		return -EINVAL;
+
+	err = usx2y_create_card(device, intf, &card);
+	if (err < 0)
+		return err;
+	err = usx2y_hwdep_new(card, device);
+	if (err < 0)
+		goto error;
+	err = snd_card_register(card);
+	if (err < 0)
+		goto error;
+
+	dev_set_drvdata(&intf->dev, card);
+	return 0;
+
+ error:
+	snd_card_free(card);
+	return err;
+}
+
+static struct usb_driver snd_usx2y_usb_driver = {
+	.name =		"snd-usb-usx2y",
+	.probe =	snd_usx2y_probe,
+	.disconnect =	snd_usx2y_disconnect,
+	.id_table =	snd_usx2y_usb_id_table,
+};
 module_usb_driver(snd_usx2y_usb_driver);
-- 
2.43.0



