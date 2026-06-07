Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E05285CA4;
	Sun,  7 Jun 2026 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829156; cv=none; b=PDrsWOAvRuTdMC1HyDeaTu4sKu+EDZ+Wq3fBh/A/B84UTrWXEyT351i+3hkn/QwHVD91b+hq0PBZdIQVZpRNeYN1kVOshI3qiZb2kLWDKiSRbCNWfVU0fYgPFl2rauImYFOVTIIvR3KzEK0lpFcTeMLFFpeBvM5VBTeVx5VBX8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829156; c=relaxed/simple;
	bh=0duQyAnh3xcIn2TzMie7OUNrHXsCs6OrUOOOrxH5M/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q4abvS4UroyzBBM8DaO2JOxA+Nd5DRlUCMdC8B/IMuAobROiL+f87KPQaox7L6QW7Ye9LMZnJpi6bIbSLjmvF3/TbTpnr3NHpfd8IXg18Z+rM8ruysSZ3LOrQgpEhwQC/nF1yC8SBjXuTEBtRRFL+bQYNQcy0Kq/n9a4AGJ3fQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Knz46A+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Knz46A+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10781F00893;
	Sun,  7 Jun 2026 10:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829155;
	bh=xbuMxpdXEb+etWEHg2dpHiH2vm0LQHsQo9Zo/D2QilY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Knz46A+41YplSmj8qyQ9tpEvCkz3Iw9YsoNjU2ArqBqpzMmJqbJg0AH0BQlHDePFL
	 83SdM3BziX09/4qZEkDmhAaJOsB2GTHXHMGwK5LSTyL2QLnD3wmeaK3adyG3PkitVq
	 NGDy1DR/B1nRts6mOCj+1BNUl6SwP9XGbjf6M+ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 200/307] ALSA: scarlett2: Fix 2i2 Gen 4 direct monitor gain on firmware 2417
Date: Sun,  7 Jun 2026 11:59:57 +0200
Message-ID: <20260607095735.071255812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
@@ -2467,6 +2467,27 @@ static int scarlett2_has_config_item(
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
@@ -2476,6 +2497,7 @@ static int scarlett2_usb_get_config(
 	const struct scarlett2_config *config_item =
 		&private->config_set->items[config_item_num];
 	int size, err, i;
+	int item_offset;
 	u8 *buf_8;
 	u8 value;
 
@@ -2485,13 +2507,15 @@ static int scarlett2_usb_get_config(
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
@@ -2509,7 +2533,7 @@ static int scarlett2_usb_get_config(
 	}
 
 	/* For bit-sized parameters, retrieve into value */
-	err = scarlett2_usb_get(mixer, config_item->offset, &value, 1);
+	err = scarlett2_usb_get(mixer, item_offset, &value, 1);
 	if (err < 0)
 		return err;
 
@@ -2659,7 +2683,8 @@ static int scarlett2_usb_set_config(
 	 */
 	if (config_item->size >= 8) {
 		size = config_item->size / 8;
-		offset = config_item->offset + index * size;
+		offset = scarlett2_config_item_offset(private, config_item_num) +
+			 index * size;
 
 	/* If updating a bit, retrieve the old value, set/clear the
 	 * bit as needed, and update value
@@ -2668,7 +2693,7 @@ static int scarlett2_usb_set_config(
 		u8 tmp;
 
 		size = 1;
-		offset = config_item->offset;
+		offset = scarlett2_config_item_offset(private, config_item_num);
 
 		err = scarlett2_usb_get(mixer, offset, &tmp, 1);
 		if (err < 0)


