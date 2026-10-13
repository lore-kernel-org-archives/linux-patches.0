Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220BC4F68B0;
	Tue, 13 Oct 2026 12:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892831; cv=none; b=hLe6Y666ZeQIQq0NiDeHStxTVHJ5GIhzWd6Fy7Zd+zwc6yQUekA4gs07kC0WKZqnzImkqs/Cnwq6wy2V1rFRDx6Vmh6W7yvPOBmLtOxUnaeCAjaYxeLtwM87WaSLftG/pYfK6j9R4D1tU+WV9DNeeoiKCfETCo2DLkC5VEsCwhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892831; c=relaxed/simple;
	bh=7q0LJ8Y08N5pj9DPLNre7FCqz0o0++KKYMZkU+HKczU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFOIKCmVivJ3+LajBxhGm52M3Y42wPejm7Y1qRJ4RJ9aJxIDSlOBRPKGcr4LhUQTvuHf19FM9zK6WG4C6E2noi+ghCpUdU25E+OXbqUKxVU9eoHuvz9OXKt15qw2zbGJeIFKEZSBbLfTMyZV3bVQX1xX6pJa58lDCzQaAP+dQQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gu7YVMLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gu7YVMLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED611F00893;
	Tue, 13 Oct 2026 12:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892830;
	bh=4b9UTX+PjW3AAyXCtZiwoaNps/G0F6tTSG5G9RTs4ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gu7YVMLUQliEKU+td2QghTs3DyQiJf6FrFeFS8s/VE12f1LYFtcrb8mxc2hkLvHH3
	 qtp28xmGmI11s7MN23RcsfHOwELZzghHH3xYXKv4nKEzRo/uFTK/f46td0rpt/qlgA
	 7wlJSA1LmrAF12GxKIp3XuiECLFcSbb36fG5bHBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 023/621] Input: ati_remote2 - fix type confusion in device attribute handlers
Date: Tue, 13 Oct 2026 13:30:18 +0200
Message-ID: <20261013112921.416478485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

commit f321cc430c49b6c1be0d53f2ef19d8342d8029cc upstream.

Previously, the channel_mask and mode_mask attributes were registered on
the parent usb_device via sysfs_create_group(). When commit b20d6bf8014b
("Input: ati-remote2 - use driver core to instantiate device
attributes") converted the driver to let the driver core manage them via
dev_groups in struct usb_driver, the attributes moved to the bound
usb_interface devices, but the show and store callbacks were not updated
accordingly.

As a result, the callbacks still invoked to_usb_device() on a device
pointer belonging to a struct usb_interface, producing an invalid
usb_device pointer.

Use to_usb_interface() directly in the attribute handlers to obtain the
interface and its driver data.

Fixes: b20d6bf8014b ("Input: ati-remote2 - use driver core to instantiate device attributes")
Assisted-by: DeepSeek-V4.1-Flash
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261009040302.3087205-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ati_remote2.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -672,8 +672,7 @@ static ssize_t ati_remote2_show_channel_
 					     struct device_attribute *attr,
 					     char *buf)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 
 	return sprintf(buf, "0x%04x\n", ar2->channel_mask);
@@ -683,8 +682,7 @@ static ssize_t ati_remote2_store_channel
 					      struct device_attribute *attr,
 					      const char *buf, size_t count)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 	unsigned int mask;
 	int r;
@@ -720,8 +718,7 @@ static ssize_t ati_remote2_show_mode_mas
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 
 	return sprintf(buf, "0x%02x\n", ar2->mode_mask);
@@ -731,8 +728,7 @@ static ssize_t ati_remote2_store_mode_ma
 					   struct device_attribute *attr,
 					   const char *buf, size_t count)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 	unsigned int mask;
 	int err;


