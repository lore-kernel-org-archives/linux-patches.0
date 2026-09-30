Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5750E5BC;
	Wed, 30 Sep 2026 16:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785604; cv=none; b=n0oGPpbJIzONIi76u5R8/PhhC1CLQEY3zbuEcEEtyQNO9fFuNKFiaybUOjNL+qztGztq+GCFwu0H3IhyzG/Y+sGX/wNsryYdUdKQJyNjqXHcFJg6gKQLFgLWCHJgLG4TH8ZfrTDNmovJR5hHSqHhSmZZuZt5F2LkPVkTeLkLjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785604; c=relaxed/simple;
	bh=fWliRPRMqpOeaDE6DYsusoEJwc5Madkm9cDrsl5Hu/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUjmw95J2Ykn47yV9yrEGwDfY2NTGano+Qhur31yP/Q2bAkxXteSGXXMzqkYGVZKpT8AUveNcctweCIKBkXYceU1VK2MJNrRlvbgRdYvmLTNMuVvK9jnp6ug55U/PLKY0Ujj3BcQa+pxBNQhn7XUeiJ1q1UdJtXq4CBuPPCoeec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE7OGR4g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE7OGR4g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E72D1F008A0;
	Wed, 30 Sep 2026 16:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785594;
	bh=ABjIOy3AFGgWqKNiHmX4pKM92ogq856nZ6T6BR6iT5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CE7OGR4gVa2ncc2szYEFjEO1+ZY+FGyUez4LpFlgcmqZLo/D2TdvEzoIXUUpe9cwq
	 CC/4Z3kYY4hmCyMijpNXh2O7eM4Qst3wx+3b392yLPoy3EoFIHYiOm1YE4yqygXspa
	 z56XM1U++gpHfvVoiPG6iOfKOK2WbzII0Xi8ZDfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 564/982] media: as102: do not rely on id table address comparison
Date: Wed, 30 Sep 2026 17:21:40 +0200
Message-ID: <20260930152428.885679280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 91a8c8c718889fc8ccf5c38b750d790e9f36f92d ]

The driver info should be retrieved using the driver_info field, not by
address comparison.

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-4-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/as102/as102_usb_drv.c | 73 ++++++++++---------------
 1 file changed, 30 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 07f6d0331e4d9..083f1535e862f 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -24,35 +24,33 @@ static void as102_usb_stop_stream(struct as102_dev_t *dev);
 static int as102_open(struct inode *inode, struct file *file);
 static int as102_release(struct inode *inode, struct file *file);
 
-static const struct usb_device_id as102_usb_id_table[] = {
-	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
-	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
-	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
-	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID) },
-	{ USB_DEVICE(SKY_IT_DIGITAL_KEY_USB_VID, SKY_IT_DIGITAL_KEY_USB_PID) },
-	{ } /* Terminating entry */
+struct as102_dev_info {
+	const char *name;
+	/*
+	 * eLNA configuration: devices built on the reference design work best
+	 * with 0xA0, while custom designs seem to require 0xC0
+	 */
+	uint8_t elna_cfg;
 };
 
-/* Note that this table must always have the same number of entries as the
-   as102_usb_id_table struct */
-static const char * const as102_device_names[] = {
-	AS102_REFERENCE_DESIGN,
-	AS102_PCTV_74E,
-	AS102_ELGATO_EYETV_DTT_NAME,
-	AS102_NBOX_DVBT_DONGLE_NAME,
-	AS102_SKY_IT_DIGITAL_KEY_NAME,
-	NULL /* Terminating entry */
-};
+#define DRIVER_INFO(dev_name, dev_elna_cfg) \
+	.driver_info = (kernel_ulong_t)&(const struct as102_dev_info){ \
+		.name = (dev_name), \
+		.elna_cfg = (dev_elna_cfg), \
+	}
 
-/* eLNA configuration: devices built on the reference design work best
-   with 0xA0, while custom designs seem to require 0xC0 */
-static uint8_t const as102_elna_cfg[] = {
-	0xA0,
-	0xC0,
-	0xC0,
-	0xA0,
-	0xA0,
-	0x00 /* Terminating entry */
+static const struct usb_device_id as102_usb_id_table[] = {
+	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001),
+	  DRIVER_INFO(AS102_REFERENCE_DESIGN, 0xA0) },
+	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID),
+	  DRIVER_INFO(AS102_PCTV_74E, 0xC0) },
+	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID),
+	  DRIVER_INFO(AS102_ELGATO_EYETV_DTT_NAME, 0xC0) },
+	{ USB_DEVICE(NBOX_DVBT_DONGLE_USB_VID, NBOX_DVBT_DONGLE_USB_PID),
+	  DRIVER_INFO(AS102_NBOX_DVBT_DONGLE_NAME, 0xA0) },
+	{ USB_DEVICE(SKY_IT_DIGITAL_KEY_USB_VID, SKY_IT_DIGITAL_KEY_USB_PID),
+	  DRIVER_INFO(AS102_SKY_IT_DIGITAL_KEY_NAME, 0xA0) },
+	{ } /* Terminating entry */
 };
 
 struct usb_driver as102_usb_driver = {
@@ -338,29 +336,18 @@ static int as102_usb_probe(struct usb_interface *intf,
 {
 	int ret;
 	struct as102_dev_t *as102_dev;
-	int i;
-
-	/* This should never actually happen */
-	if (ARRAY_SIZE(as102_usb_id_table) !=
-	    (sizeof(as102_device_names) / sizeof(const char *))) {
-		pr_err("Device names table invalid size");
-		return -EINVAL;
-	}
+	const struct as102_dev_info *info = (const struct as102_dev_info *)id->driver_info;
 
 	as102_dev = kzalloc(sizeof(struct as102_dev_t), GFP_KERNEL);
 	if (as102_dev == NULL)
 		return -ENOMEM;
 
-	/* Assign the user-friendly device name */
-	for (i = 0; i < ARRAY_SIZE(as102_usb_id_table); i++) {
-		if (id == &as102_usb_id_table[i]) {
-			as102_dev->name = as102_device_names[i];
-			as102_dev->elna_cfg = as102_elna_cfg[i];
-		}
-	}
-
-	if (as102_dev->name == NULL)
+	if (info) {
+		as102_dev->name = info->name;
+		as102_dev->elna_cfg = info->elna_cfg;
+	} else {
 		as102_dev->name = "Unknown AS102 device";
+	}
 
 	/* set private callback functions */
 	as102_dev->bus_adap.ops = &as102_priv_ops;
-- 
2.53.0



