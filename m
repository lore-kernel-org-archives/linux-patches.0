Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710FF31AF1F;
	Tue, 13 Oct 2026 12:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895694; cv=none; b=oNTfsazLQI6T615dWLBWujlJeor9K79cArPeF0AK06zGJMu2rTnsBcKLoR5gRuWRp4SERc8Ik+ODrqEOvhhv4r9iFBJI4WfgspinNFqsrG0xW2ZpRosXagRO2AbMmsyN2LRlGh5bE1WpIaqa05SjM51qA7ntoFv6UNzz5sBFMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895694; c=relaxed/simple;
	bh=8/vi4a+kBD9YGjDdCOZRjCgRhVRx5Ffj1PVGAKYKDdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqlR0EysHmKUnYVl4+3unXdc/BFJ5iKptMjEbdwihpOJXT0/44SLorIlxSARBs5Rh/6zWC6N4kxuOYEl4xpmBNZ1/+Y0+8Wj2SuCHXUdrWeTQ9zPmTybcqp5VDvS20mVEeY3bwf8We0AHlOOC2r/mzrGD5NzeGci2bYooWCDNJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keTUjEI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keTUjEI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7461F000FF;
	Tue, 13 Oct 2026 12:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895693;
	bh=4rCtpf39nkchC+b+rhBPHfc/O/3QaX9JAqJXDU0KD6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keTUjEI1Zv8mISUsp9HUa481+rkL8MSnVpuelZgRHRQnRJdTj/iE8wyDpfGrmM4s6
	 ORzzqenPFQD1+ab7J+UXkcqIbaluJ/6VzbROHcq+1+fEEmLSmBHxpQAZWs/++j6+C+
	 meE15+dtolUke8R0rDT9G2/GPlcOqA+BKeBok7iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 359/497] Input: ati_remote2 - fix type confusion in device attribute handlers
Date: Tue, 13 Oct 2026 13:38:46 +0200
Message-ID: <20261013112916.427010679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -682,8 +682,7 @@ static ssize_t ati_remote2_show_channel_
 					     struct device_attribute *attr,
 					     char *buf)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 
 	return sprintf(buf, "0x%04x\n", ar2->channel_mask);
@@ -693,8 +692,7 @@ static ssize_t ati_remote2_store_channel
 					      struct device_attribute *attr,
 					      const char *buf, size_t count)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 	unsigned int mask;
 	int r;
@@ -732,8 +730,7 @@ static ssize_t ati_remote2_show_mode_mas
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 
 	return sprintf(buf, "0x%02x\n", ar2->mode_mask);
@@ -743,8 +740,7 @@ static ssize_t ati_remote2_store_mode_ma
 					   struct device_attribute *attr,
 					   const char *buf, size_t count)
 {
-	struct usb_device *udev = to_usb_device(dev);
-	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
+	struct usb_interface *intf = to_usb_interface(dev);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 	unsigned int mask;
 	int err;


