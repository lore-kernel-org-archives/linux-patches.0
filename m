Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67653596F3;
	Wed, 21 Jan 2026 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020319; cv=none; b=UhPWEHvraDKmFiM+nh8VzN7NiSTnSBIaMpUb+79vvWTcMJ3Uk4gG/1Mep/e6v03f1WC3mvqT2oqKrIn0ENOX1s45jmc3+bGPG37vtiHwQ0el+iTy3WIwjW1oJWxmHQf6XNOQA91n0xhgcUQyVtgXSOocPpw40fkc2SXb3kV1rQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020319; c=relaxed/simple;
	bh=w2atDMv+vfnGkAxdjqrtSDmo5If9GmUiVvz6a9Cdk58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=usCElrLDTLxM8VAoD81XmwtSlS/y1/eeHyxuwxx7ZGiZ0ywwVg43sViLUMVLqLh7C/l1el24wv+Zw1bc+544Q52VjbnJI88kVaExtMQaMVf7ihLStXs5SCBE+PM897FHyIoqT7i9mRyvCZqQOZe7QEKpaOZdgBQYzRrDttW3DBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQW+ZYO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQW+ZYO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0565C4CEF1;
	Wed, 21 Jan 2026 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020318;
	bh=w2atDMv+vfnGkAxdjqrtSDmo5If9GmUiVvz6a9Cdk58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQW+ZYO19glA+4gV0D0W2fSckwRioLqPJ11vLoIVLJh1lTL4flahK0NVHUKUhdRny
	 CoGj6eFSFy5/MQfDyZ9jyKcV6JcRIvLZPnLNgWkzM8N/K104g9s2jSvl97gI/21/ow
	 iRZoeJhT3Ux4uDO4VwEohcGzhQyioRGE8buoPHmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Johannes=20Br=C3=BCderl?= <johannes.bruederl@gmail.com>
Subject: [PATCH 6.18 122/198] usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor
Date: Wed, 21 Jan 2026 19:15:50 +0100
Message-ID: <20260121181422.940409650@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Brüderl <johannes.bruederl@gmail.com>

commit 2740ac33c87b3d0dfa022efd6ba04c6261b1abbd upstream.

Add USB_QUIRK_NO_BOS quirk flag to skip requesting the BOS descriptor
for devices that cannot handle it.

Add Elgato 4K X (0fd9:009b) to the quirk table. This device hangs when
the BOS descriptor is requested at SuperSpeed Plus (10Gbps).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220027
Cc: stable <stable@kernel.org>
Signed-off-by: Johannes Brüderl <johannes.bruederl@gmail.com>
Link: https://patch.msgid.link/20251207090220.14807-1-johannes.bruederl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c  |    5 +++++
 drivers/usb/core/quirks.c  |    3 +++
 include/linux/usb/quirks.h |    3 +++
 3 files changed, 11 insertions(+)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -1040,6 +1040,11 @@ int usb_get_bos_descriptor(struct usb_de
 	__u8 cap_type;
 	int ret;
 
+	if (dev->quirks & USB_QUIRK_NO_BOS) {
+		dev_dbg(ddev, "skipping BOS descriptor\n");
+		return -ENOMSG;
+	}
+
 	bos = kzalloc(sizeof(*bos), GFP_KERNEL);
 	if (!bos)
 		return -ENOMEM;
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -450,6 +450,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Elgato 4K X - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x0fd9, 0x009b), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Sony Xperia XZ1 Compact (lilac) smartphone in fastboot mode */
 	{ USB_DEVICE(0x0fce, 0x0dde), .driver_info = USB_QUIRK_NO_LPM },
 
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -75,4 +75,7 @@
 /* short SET_ADDRESS request timeout */
 #define USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT	BIT(16)
 
+/* skip BOS descriptor request */
+#define USB_QUIRK_NO_BOS			BIT(17)
+
 #endif /* __LINUX_USB_QUIRKS_H */


