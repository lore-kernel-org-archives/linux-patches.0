Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190717C69;
	Mon, 14 Oct 2024 15:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920015; cv=none; b=Yt3xxB4AUDiuclXBZGNPIpwgF7frztxBR1hloC5Q6paSHB4F+dJpw60OARQT0WkUc6ZRkKfEluhToxeyle5RlzH//NpZyv4Y0+GUwKgDVhJgd19EGM9/4A6+mQTCCRuGmKAwMQ7sC0+y/46ZBfZiAADm0AhfFuVOFEz2zhkHNRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920015; c=relaxed/simple;
	bh=LfdqG6h5QMKFkirToMQeUmqp4BZsGfYhoP74aqEYlQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQallRF6aAN3CyoZEFaezsMmPodSkla96lSDp5kHQsX44HJC7gBYPPvskwrqFD09in07yP3RdBThoXDYv9yomsz5eyBPY4hhmg9FmdeuNt9o+1z6bXQ0Ce0p9Ty1+YAwdnOP0AGCoWOXnEeAIPVWmU/4cDHJdbiz6hBzOHtCDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcS7uGNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcS7uGNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4C2C4CEC3;
	Mon, 14 Oct 2024 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920014;
	bh=LfdqG6h5QMKFkirToMQeUmqp4BZsGfYhoP74aqEYlQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcS7uGNcddyTgpQ+Xb6fRa8YMdTgisiPhS5UvsX4zLPiT+R9x6lon8UrveCipJo5v
	 L+NhHiBl9o4W6qD07j67cTLLZ3i0SZRC8IXSew2laO5Wce9ev2CwE15M6sixP5FoMI
	 5h0sT8tKkrqcW7r4wqo5xSVMXoaFz0TUijXkOs08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wade Wang <wade.wang@hp.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 774/798] HID: plantronics: Workaround for an unexcepted opposite volume key
Date: Mon, 14 Oct 2024 16:22:08 +0200
Message-ID: <20241014141248.470211821@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wade Wang <wade.wang@hp.com>

commit 87b696209007b7c4ef7bdfe39ea0253404a43770 upstream.

Some Plantronics headset as the below send an unexcept opposite
volume key's HID report for each volume key press after 200ms, like
unecepted Volume Up Key following Volume Down key pressed by user.
This patch adds a quirk to hid-plantronics for these devices, which
will ignore the second unexcepted opposite volume key if it happens
within 220ms from the last one that was handled.
    Plantronics EncorePro 500 Series  (047f:431e)
    Plantronics Blackwire_3325 Series (047f:430c)

The patch was tested on the mentioned model, it shouldn't affect
other models, however, this quirk might be needed for them too.
Auto-repeat (when a key is held pressed) is not affected per test
result.

Cc: stable@vger.kernel.org
Signed-off-by: Wade Wang <wade.wang@hp.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h         |    2 ++
 drivers/hid/hid-plantronics.c |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1020,6 +1020,8 @@
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3325_SERIES	0x430c
+#define USB_DEVICE_ID_PLANTRONICS_ENCOREPRO_500_SERIES		0x431e
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -38,8 +38,10 @@
 			    (usage->hid & HID_USAGE_PAGE) == HID_UP_CONSUMER)
 
 #define PLT_QUIRK_DOUBLE_VOLUME_KEYS BIT(0)
+#define PLT_QUIRK_FOLLOWED_OPPOSITE_VOLUME_KEYS BIT(1)
 
 #define PLT_DOUBLE_KEY_TIMEOUT 5 /* ms */
+#define PLT_FOLLOWED_OPPOSITE_KEY_TIMEOUT 220 /* ms */
 
 struct plt_drv_data {
 	unsigned long device_type;
@@ -137,6 +139,21 @@ static int plantronics_event(struct hid_
 
 		drv_data->last_volume_key_ts = cur_ts;
 	}
+	if (drv_data->quirks & PLT_QUIRK_FOLLOWED_OPPOSITE_VOLUME_KEYS) {
+		unsigned long prev_ts, cur_ts;
+
+		/* Usages are filtered in plantronics_usages. */
+
+		if (!value) /* Handle key presses only. */
+			return 0;
+
+		prev_ts = drv_data->last_volume_key_ts;
+		cur_ts = jiffies;
+		if (jiffies_to_msecs(cur_ts - prev_ts) <= PLT_FOLLOWED_OPPOSITE_KEY_TIMEOUT)
+			return 1; /* Ignore the followed opposite volume key. */
+
+		drv_data->last_volume_key_ts = cur_ts;
+	}
 
 	return 0;
 }
@@ -210,6 +227,12 @@ static const struct hid_device_id plantr
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
 					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES),
 		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3325_SERIES),
+		.driver_data = PLT_QUIRK_FOLLOWED_OPPOSITE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_ENCOREPRO_500_SERIES),
+		.driver_data = PLT_QUIRK_FOLLOWED_OPPOSITE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };


