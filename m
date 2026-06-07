Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7070808;
	Sun,  7 Jun 2026 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828940; cv=none; b=Z6PzqIWgB4l/0hRrDU45QeCwFO0EkTrSH57xpYBr2QRstylbAdJXEe/V7HJJVreKbHHk60txpdevM7zBSiPWVzcsGCVuGhcRqbpeLoQ3OQaTXocJI4Bx5OuGY9BqZbdIi9c5FHinAJ2lfVqMS5LY0fnpI36Dp5qvLovsUAHs4nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828940; c=relaxed/simple;
	bh=5BBafiM9uQb/Y92P+aDpzqTnZlkntdH96eXY9m7zpHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq2y0fnpDoeCjT9brQoUipkArDARz/sDscMX7XFVt2QbRhxK0yk8m9oUh9ZgHzps9RNhAaiy5d5Q1XhMGeqi6L4RDeG5nPdiHmyhgEmWoLVUrBxHVvbBiBO9up9Q1cAKW07owIsuW6JKQQw319yHK4RAnaU0Mg2uWEXoNLn2fPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFpNMKWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFpNMKWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CA91F00893;
	Sun,  7 Jun 2026 10:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828939;
	bh=5C6yow/H+lZ/5ha4hySv3D5GurVSWjWpwfg0MaLzgNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFpNMKWQyZeWkB5aX2e/Sx0DwNtOLd8pRAqZCBIzHK4kPoBC4NLtr9Iq6waTfNe8Y
	 KX/PnmMZDiCaOI7sVFiDokMLFN5dW8OFpjXaOZMThbvAkB90SGo84ZOlhIKrhBjRcY
	 QdKDYCaWFwmwSMLPsFIxTQMvqXfz5wcpW8NA9f2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 228/332] ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417
Date: Sun,  7 Jun 2026 11:59:57 +0200
Message-ID: <20260607095736.432591052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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


