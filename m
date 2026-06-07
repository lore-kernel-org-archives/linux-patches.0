Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ED970808;
	Sun,  7 Jun 2026 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828937; cv=none; b=nIrve4xqWs9gKi0azVIMuBmGRMLT10uKprMPzih+zAqU5VOFKBhj1upMXi11J5zaoBAR3PISc0IHzOGN4rhd0sffJWkEHvMlf1C893S9Kia8JYC5WmJVNXk9XGbKIpzomfKjUuq6g7hIb2hWumGMjnY0AjwZ+WDVcZvsLgDVP+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828937; c=relaxed/simple;
	bh=+5BbJukmPM4+M5BLyugmqs7Lj0lk5lGuLsvha9THYJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wd3gF3lXNYhX8zEiJZ3E+MFLN0h98IdZKUPvS+tXe9XTVd5WpVxC9vgZBlWiLvy0tmUOVstYhxJHDoa2kbyVkhmMRD3xf9CaAh8AIwSgTd+H37EoX3EeCCudpHb44GiMRN1MTq7yRQKN6yBRMoNoXMKHnSKV+B0wOCSMIq4xO/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwRfdd12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwRfdd12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822AA1F00893;
	Sun,  7 Jun 2026 10:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828936;
	bh=1I/CDymJNN2eqWqRRAx2IITc84G7V5F/QVTbIMoIGdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwRfdd12hob16xDeK2Wj19omMpyfc+jx/r9S34u8nEPvjM1vEsXcbPXSP2dxZRciX
	 iUbIw1dST1lL6qTk/ogTxPgkrCLnH3/KYUclBrKwD0iGmXQ2jkbhWNNGGjcJFR0+V4
	 1xDkSzyKqFhhdGaY8RTpay01V/KAdfyR6JxI0r7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 203/315] ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417
Date: Sun,  7 Jun 2026 11:59:50 +0200
Message-ID: <20260607095735.027166550@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

commit db37cf47b67e38ade40de5cd74a4d4d772ff1416 upstream.

Firmware 2417 for the Scarlett 4th Gen 2i2 moved the direct monitor
gain parameter by 4 bytes, from offset 0x2a0 to 0x2a4, breaking the
"Direct Monitor X Mix Y" controls.

Special-case the offset in the get/set config helpers when the
running firmware is 2417 or later.

Fixes: 4e809a299677 ("ALSA: scarlett2: Add support for Solo, 2i2, and 4i4 Gen 4")
Cc: <stable@vger.kernel.org>
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/ahIWTueUlWA5xiV+@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -2504,6 +2504,27 @@ static int scarlett2_has_config_item(
 	return !!private->config_set->items[config_item_num].offset;
 }
 
+/* Return the configuration item's offset, applying any per-firmware
+ * overrides.
+ *
+ * Firmware 2417 for the 2i2 Gen 4 moved DIRECT_MONITOR_GAIN by 4
+ * bytes. Apply that shift here so that the rest of the driver can
+ * keep using the single config set. This override can be removed
+ * once the multi-config-set framework lands.
+ */
+static int scarlett2_config_item_offset(
+	struct scarlett2_data *private, int config_item_num)
+{
+	int offset = private->config_set->items[config_item_num].offset;
+
+	if (config_item_num == SCARLETT2_CONFIG_DIRECT_MONITOR_GAIN &&
+	    private->info == &s2i2_gen4_info &&
+	    private->firmware_version >= 2417)
+		offset = 0x2a4;
+
+	return offset;
+}
+
 /* Send a USB message to get configuration parameters; result placed in *buf */
 static int scarlett2_usb_get_config(
 	struct usb_mixer_interface *mixer,
@@ -2513,6 +2534,7 @@ static int scarlett2_usb_get_config(
 	const struct scarlett2_config *config_item =
 		&private->config_set->items[config_item_num];
 	int size, err, i;
+	int item_offset;
 	u8 *buf_8;
 	u8 value;
 
@@ -2522,13 +2544,15 @@ static int scarlett2_usb_get_config(
 	if (!config_item->offset)
 		return -EFAULT;
 
+	item_offset = scarlett2_config_item_offset(private, config_item_num);
+
 	/* Writes to the parameter buffer are always 1 byte */
 	size = config_item->size ? config_item->size : 8;
 
 	/* For byte-sized parameters, retrieve directly into buf */
 	if (size >= 8) {
 		size = size / 8 * count;
-		err = scarlett2_usb_get(mixer, config_item->offset, buf, size);
+		err = scarlett2_usb_get(mixer, item_offset, buf, size);
 		if (err < 0)
 			return err;
 		if (config_item->size == 16) {
@@ -2546,7 +2570,7 @@ static int scarlett2_usb_get_config(
 	}
 
 	/* For bit-sized parameters, retrieve into value */
-	err = scarlett2_usb_get(mixer, config_item->offset, &value, 1);
+	err = scarlett2_usb_get(mixer, item_offset, &value, 1);
 	if (err < 0)
 		return err;
 
@@ -2696,7 +2720,8 @@ static int scarlett2_usb_set_config(
 	 */
 	if (config_item->size >= 8) {
 		size = config_item->size / 8;
-		offset = config_item->offset + index * size;
+		offset = scarlett2_config_item_offset(private, config_item_num) +
+			 index * size;
 
 	/* If updating a bit, retrieve the old value, set/clear the
 	 * bit as needed, and update value
@@ -2705,7 +2730,7 @@ static int scarlett2_usb_set_config(
 		u8 tmp;
 
 		size = 1;
-		offset = config_item->offset;
+		offset = scarlett2_config_item_offset(private, config_item_num);
 
 		err = scarlett2_usb_get(mixer, offset, &tmp, 1);
 		if (err < 0)


