Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9886D13247D;
	Wed,  3 Jul 2024 11:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005850; cv=none; b=BOexbGMv2R+wDo3RQRMqdiXAm+5t09c3cVcKw7bRFwT4RuWTiMJbjPPLHigv4fBn0eoR/yRnHWOTSKsuvARTdjFwfnR2W6Z74rx4WA8GpEEUQ6ydfKcM/ozvLJkPM2JrSf1wknTqx7DOmTvWKRUXltVy6rX547Lky3VnemlkuS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005850; c=relaxed/simple;
	bh=xlvmudW9rFi4YPM4V555KAVnoOwka9+GhztxbunxWKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JneTdExYV7myGz/7YNdRkrM7XtCkjkL/QGrqnTWMQAKaLYHZOOS8+ZMSAjFMz49T78B+qgeeIIMccF02kKXoiiff0QfN3ureEoTjxZE6sJzxulW2UGRigrsLLAWHFZax75AJMWHobhzv6aXtpBu/G5S15CDtfw75a/Zw3hvUQkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utRT5OLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utRT5OLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C7DC2BD10;
	Wed,  3 Jul 2024 11:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005850;
	bh=xlvmudW9rFi4YPM4V555KAVnoOwka9+GhztxbunxWKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utRT5OLlLlvwyUX7yoNFP3m3duBstY6guR/qqk3HVYP1lfIdrKaOL5kNs7yoGg9UP
	 ZHA5C/HiuCFKKpjjJdEukFy0FJP8QFljODjowz7jzpK+n+2184P3yTeY+d9TZUrrya
	 OqEwStHF8trFnWvs4O+l+lAYnAvvvrx1BuACOYHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/356] usb: misc: uss720: check for incompatible versions of the Belkin F5U002
Date: Wed,  3 Jul 2024 12:38:32 +0200
Message-ID: <20240703102919.763092888@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Henrie <alexhenrie24@gmail.com>

[ Upstream commit 3295f1b866bfbcabd625511968e8a5c541f9ab32 ]

The incompatible device in my possession has a sticker that says
"F5U002 Rev 2" and "P80453-B", and lsusb identifies it as
"050d:0002 Belkin Components IEEE-1284 Controller". There is a bug
report from 2007 from Michael Trausch who was seeing the exact same
errors that I saw in 2024 trying to use this cable.

Link: https://lore.kernel.org/all/46DE5830.9060401@trausch.us/
Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Link: https://lore.kernel.org/r/20240326150723.99939-5-alexhenrie24@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/uss720.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 0be8efcda15d5..d972c09629397 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -677,7 +677,7 @@ static int uss720_probe(struct usb_interface *intf,
 	struct parport_uss720_private *priv;
 	struct parport *pp;
 	unsigned char reg;
-	int i;
+	int ret;
 
 	dev_dbg(&intf->dev, "probe: vendor id 0x%x, device id 0x%x\n",
 		le16_to_cpu(usbdev->descriptor.idVendor),
@@ -688,8 +688,8 @@ static int uss720_probe(struct usb_interface *intf,
 		usb_put_dev(usbdev);
 		return -ENODEV;
 	}
-	i = usb_set_interface(usbdev, intf->altsetting->desc.bInterfaceNumber, 2);
-	dev_dbg(&intf->dev, "set interface result %d\n", i);
+	ret = usb_set_interface(usbdev, intf->altsetting->desc.bInterfaceNumber, 2);
+	dev_dbg(&intf->dev, "set interface result %d\n", ret);
 
 	interface = intf->cur_altsetting;
 
@@ -725,12 +725,18 @@ static int uss720_probe(struct usb_interface *intf,
 	set_1284_register(pp, 7, 0x00, GFP_KERNEL);
 	set_1284_register(pp, 6, 0x30, GFP_KERNEL);  /* PS/2 mode */
 	set_1284_register(pp, 2, 0x0c, GFP_KERNEL);
-	/* debugging */
-	get_1284_register(pp, 0, &reg, GFP_KERNEL);
+
+	/* The Belkin F5U002 Rev 2 P80453-B USB parallel port adapter shares the
+	 * device ID 050d:0002 with some other device that works with this
+	 * driver, but it itself does not. Detect and handle the bad cable
+	 * here. */
+	ret = get_1284_register(pp, 0, &reg, GFP_KERNEL);
 	dev_dbg(&intf->dev, "reg: %7ph\n", priv->reg);
+	if (ret < 0)
+		return ret;
 
-	i = usb_find_last_int_in_endpoint(interface, &epd);
-	if (!i) {
+	ret = usb_find_last_int_in_endpoint(interface, &epd);
+	if (!ret) {
 		dev_dbg(&intf->dev, "epaddr %d interval %d\n",
 				epd->bEndpointAddress, epd->bInterval);
 	}
-- 
2.43.0



