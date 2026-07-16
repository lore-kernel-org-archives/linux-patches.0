Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FD4298CAB;
	Thu, 16 Jul 2026 14:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210604; cv=none; b=dMqEX4y3UawaFfZirzvpxtuf8FzLFcfboGUWr4dfBwAGLrInOhsoH/+cgr7NsUuH6HSWwzuoyvKOOY/sqUiPX4VhM79IaFlNauvkV+JAM6k5f+tTt3RQW3hwf5MMtI74L7sRfe7SLIxdiWwuqZBh/4rJUseKtc5PO/YwY5qgB/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210604; c=relaxed/simple;
	bh=CQAGF3i3HXF9bjIMfguv6MR00c4oy8zEwDgdAHPe6/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tC3DWNSTcTPa8FqTiuxbQXSaHNLWFGMz+7b4gxa9nPz8mGLPlJdkjdwZnkwFMLVLA6dG+JkfkyZSKMZnXyii2XXiKHxxHCvP/hELSt8IPcxaPLMcODcVarhgclc7dQGJhON2vrUnImbp08ZZqDysZZqaoux7i+bP7C8tx5rSWzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNhGoxYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNhGoxYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC8A1F000E9;
	Thu, 16 Jul 2026 14:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210602;
	bh=1DILQX0uLHjNcLdXMq2UuK1Zk5k+wAbERx9DjL2f+NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNhGoxYTsLUBUBrDRGx3JpUAZGWy9u9bTWg3KKQ0Of0N1U/ktPI6nmnHHcu6JPzUS
	 AeStJMHuC/ekT9qnDxW/5XgcAGla8pZQdB6PkLdp2qtrdmakdI9L265p09hAoNJNH5
	 4pAy/EgC2BAvdH5FRPISL30P0kbfBngD9/q50McM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Darvell Long <contact@darvell.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 110/480] ALSA: usb-audio: avoid kobject path lookup in DualSense match
Date: Thu, 16 Jul 2026 15:27:37 +0200
Message-ID: <20260716133047.087647056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Darvell Long <contact@darvell.me>

commit 7693c0cc415f3a16a7a3355f245474a5e661be4e upstream.

The DualSense jack-detection input handler verifies that a matching input
device belongs to the same physical controller by building kobject path
strings for both the input device and the USB audio device, then comparing
the path prefix.

This was observed when a weak physical connection caused the controller
to rapidly disconnect and reconnect. During that repeated hotplug,
snd_dualsense_ih_match() can run while the controller's USB device is
being disconnected. kobject_get_path() walks ancestor kobjects and
dereferences their names; if the USB device kobject name is no longer
valid, this can fault in strlen():

  RIP: 0010:strlen+0x10/0x30
  Call Trace:
   kobject_get_path+0x34/0x150
   snd_dualsense_ih_match+0x49/0xd0 [snd_usb_audio]
   input_register_device+0x566/0x6a0
   ps_probe+0xb89/0x1590 [hid_playstation]

The same ownership check can be done without building kobject path
strings. The input device is parented below the HID device, USB interface
and USB device, so walking the input device parent chain and comparing
against the mixer USB device preserves the check without dereferencing
kobject names during disconnect.

Fixes: 79d561c4ec04 ("ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5")
Cc: <stable@vger.kernel.org>
Assisted-by: Cute:gpt-5.5
Signed-off-by: Darvell Long <contact@darvell.me>
Link: https://patch.msgid.link/20260624143723.2986353-1-contact@darvell.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -567,46 +567,30 @@ static bool snd_dualsense_ih_match(struc
 {
 	struct dualsense_mixer_elem_info *mei;
 	struct usb_device *snd_dev;
-	char *input_dev_path, *usb_dev_path;
-	size_t usb_dev_path_len;
-	bool match = false;
+	struct device *parent;
 
 	mei = container_of(handler, struct dualsense_mixer_elem_info, ih);
 	snd_dev = mei->info.head.mixer->chip->dev;
 
-	input_dev_path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
-	if (!input_dev_path) {
-		dev_warn(&snd_dev->dev, "Failed to get input dev path\n");
-		return false;
-	}
-
-	usb_dev_path = kobject_get_path(&snd_dev->dev.kobj, GFP_KERNEL);
-	if (!usb_dev_path) {
-		dev_warn(&snd_dev->dev, "Failed to get USB dev path\n");
-		goto free_paths;
-	}
-
 	/*
 	 * Ensure the VID:PID matched input device supposedly owned by the
 	 * hid-playstation driver belongs to the actual hardware handled by
-	 * the current USB audio device, which implies input_dev_path being
-	 * a subpath of usb_dev_path.
+	 * the current USB audio device.
 	 *
 	 * This verification is necessary when there is more than one identical
 	 * controller attached to the host system.
+	 *
+	 * The input device is registered below the HID device, USB interface and
+	 * USB device, so compare the parent chain directly instead of building
+	 * kobject path strings. This avoids dereferencing kobject names while the
+	 * USB device hierarchy is being torn down during disconnect.
 	 */
-	usb_dev_path_len = strlen(usb_dev_path);
-	if (usb_dev_path_len >= strlen(input_dev_path))
-		goto free_paths;
-
-	usb_dev_path[usb_dev_path_len] = '/';
-	match = !memcmp(input_dev_path, usb_dev_path, usb_dev_path_len + 1);
-
-free_paths:
-	kfree(input_dev_path);
-	kfree(usb_dev_path);
+	for (parent = dev->dev.parent; parent; parent = parent->parent) {
+		if (parent == &snd_dev->dev)
+			return true;
+	}
 
-	return match;
+	return false;
 }
 
 static int snd_dualsense_ih_connect(struct input_handler *handler,


