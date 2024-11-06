Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE2D1DF721;
	Wed,  6 Nov 2024 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895570; cv=none; b=joZcAResTXPrBpkgl8WdIOXqAF9E2+Mk/fVJZBcR8n99C6Y5ASMoFsE3Q4zciHZQq2IipoI8rnjPGtCrPf9LAGxUAojD56RQbu8Winc4kUPfTTLdom/1bXfW5hmtxKe9wqpjTMUcC7jyAda0V8cYQZyccwIEB/Z9+bpLeBuoVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895570; c=relaxed/simple;
	bh=vhK/DeCt/aF/i05ofFUwDZsAS50MKGbJQ3gcQTVEcO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHGJQieR1/K2uqdzHAVe7kIe1K4ha13Kf2LgEERWQapXB6yjuxZw9wj1GC3G0HY6OkznfsiUSVf6Tk0v7v1dHeYN0vgVbrtOTs6LB1rR+eLCxe/Clhg1vQXB2vv+BI7s478brU21bdqryJXtVwVPij0XSOGcWK7it8PfOmvrs7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+XSye62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+XSye62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2517BC4CECD;
	Wed,  6 Nov 2024 12:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895570;
	bh=vhK/DeCt/aF/i05ofFUwDZsAS50MKGbJQ3gcQTVEcO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+XSye62GaU89rEP6bW+P4+m/qOTAduLN1u7LmClyLX9r3ZpodqlDpDyD6cW6FyDZ
	 gifC257Izhb/3az9lMd4sZUFZisedUE2x1EPxpP8SlM5f2/NrnXWcFIism69AOMH85
	 TAPC5bDpuX6xREX2Wfj36t6svv6rOR1yHEtnulKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wade Wang <wade.wang@hp.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 4.19 263/350] HID: plantronics: Workaround for an unexcepted opposite volume key
Date: Wed,  6 Nov 2024 13:03:11 +0100
Message-ID: <20241106120327.396522020@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -916,6 +916,8 @@
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3325_SERIES	0x430c
+#define USB_DEVICE_ID_PLANTRONICS_ENCOREPRO_500_SERIES		0x431e
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -41,8 +41,10 @@
 			    (usage->hid & HID_USAGE_PAGE) == HID_UP_CONSUMER)
 
 #define PLT_QUIRK_DOUBLE_VOLUME_KEYS BIT(0)
+#define PLT_QUIRK_FOLLOWED_OPPOSITE_VOLUME_KEYS BIT(1)
 
 #define PLT_DOUBLE_KEY_TIMEOUT 5 /* ms */
+#define PLT_FOLLOWED_OPPOSITE_KEY_TIMEOUT 220 /* ms */
 
 struct plt_drv_data {
 	unsigned long device_type;
@@ -140,6 +142,21 @@ static int plantronics_event(struct hid_
 
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
@@ -213,6 +230,12 @@ static const struct hid_device_id plantr
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


