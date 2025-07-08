Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D102F37;
	Tue,  8 Jul 2025 16:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993676; cv=none; b=FXd99z6qutULVNhiwr2TdMFNp/6pPCrpOK1VHUjkY4YOdLHnyhVcwXXx+OJQ6GCgj5gFZqR2P8tvi9GIqYbVQKrprcRl4V0uiBSTCC0Fx2PsdUsNm9cZ1NhQizFf8ItA4oH24XBx0JUs1ZHrh9jVVfqjjzMjOf0sigPX64NT99g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993676; c=relaxed/simple;
	bh=eVQKyz4ZVRxe/M+yW2YXepiUxw1N58Bw5QOBd/NqD+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgucLRXbYiHtaIK5oA7fmCT4uAElK6sxMt/hTpzqGjdq1OVtFeUz2OrfxjC6nb1nojGm2QXOVaVR6acvSfue753E1cxbROB+3jUSftA87uwrKib79ty89hIcF+a8Per8zwmK46a7LRgOnY61cAa5qbVUeUsDwemBEqpbciOvFtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+YDCjF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+YDCjF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0EBDC4CEED;
	Tue,  8 Jul 2025 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993676;
	bh=eVQKyz4ZVRxe/M+yW2YXepiUxw1N58Bw5QOBd/NqD+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+YDCjF4LPboDVSN5GXcabMmd0fxEG+kMmVmKVRWtohjoMlni40riV1lkvp+rpJTL
	 dbqc0Gsv9ZBJkp0YyaTXf39fsAeQLXMwPI0ZzKrKcNfLh8g50/PIT0xkUZk5zlgmrL
	 TF3/L7iy5Gllx9k3oKxGovcRv3giLZQ/Xwacmam4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.15 155/178] usb: acpi: fix device link removal
Date: Tue,  8 Jul 2025 18:23:12 +0200
Message-ID: <20250708162240.548808090@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 3b18405763c1ebb1efc15feef5563c9cdb2cc3a7 upstream.

The device link to the USB4 host interface has to be removed
manually since it's no longer auto removed.

Fixes: 623dae3e7084 ("usb: acpi: fix boot hang due to early incorrect 'tunneled' USB3 device links")
Cc: stable <stable@kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20250611111415.2707865-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c      |    3 +++
 drivers/usb/core/usb-acpi.c |    4 +++-
 include/linux/usb.h         |    2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2337,6 +2337,9 @@ void usb_disconnect(struct usb_device **
 	usb_remove_ep_devs(&udev->ep0);
 	usb_unlock_device(udev);
 
+	if (udev->usb4_link)
+		device_link_del(udev->usb4_link);
+
 	/* Unregister the device.  The device driver is responsible
 	 * for de-configuring the device and invoking the remove-device
 	 * notifier chain (used by usbfs and possibly others).
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(usb_acpi_set_power_sta
  */
 static int usb_acpi_add_usb4_devlink(struct usb_device *udev)
 {
-	const struct device_link *link;
+	struct device_link *link;
 	struct usb_port *port_dev;
 	struct usb_hub *hub;
 
@@ -188,6 +188,8 @@ static int usb_acpi_add_usb4_devlink(str
 	dev_dbg(&port_dev->dev, "Created device link from %s to %s\n",
 		dev_name(&port_dev->child->dev), dev_name(nhi_fwnode->dev));
 
+	udev->usb4_link = link;
+
 	return 0;
 }
 
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -614,6 +614,7 @@ struct usb3_lpm_parameters {
  *	FIXME -- complete doc
  * @authenticated: Crypto authentication passed
  * @tunnel_mode: Connection native or tunneled over USB4
+ * @usb4_link: device link to the USB4 host interface
  * @lpm_capable: device supports LPM
  * @lpm_devinit_allow: Allow USB3 device initiated LPM, exit latency is in range
  * @usb2_hw_lpm_capable: device can perform USB2 hardware LPM
@@ -724,6 +725,7 @@ struct usb_device {
 	unsigned reset_resume:1;
 	unsigned port_is_suspended:1;
 	enum usb_link_tunnel_mode tunnel_mode;
+	struct device_link *usb4_link;
 
 	int slot_id;
 	struct usb2_lpm_parameters l1_params;


