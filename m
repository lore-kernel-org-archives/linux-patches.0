Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254B330C36A;
	Mon, 13 Oct 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367919; cv=none; b=IFbzZTWvuoowkgCDOsGz1GjokEh5zYTNPI0O2K6YLungaxOsZjaiK3wdwmy5WyPCVxviaSh6PGJjsq+Qcf9FCnLx/+xjJGfDqoHtFuT7jF5N90lbm+F/2z1bTlEc7eS/HZc1YJeUb+E6yQfMvr8EfKbdVkeGlwbaYu2rsEgcpLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367919; c=relaxed/simple;
	bh=QXX6gnmouB7ge5PrXPu2VOhpdq8R1AewafLw6xi1P1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy4dz43RNTFS77FoQFKRco0/UKpyz96IVG7qeUi6yecG4GwvyKJ4GW0dUo3CFpWWqR1JGrgA5dboKKUxt1pnkl+lRtwioT+/77l8NUQQyqPekVfP8DoiWE5ua7xU2GWMzzWNmQNwzlyiQb6b8sKf16xC05QfA6DxwxFxGhuwmGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i+KaqaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i+KaqaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A513FC4CEE7;
	Mon, 13 Oct 2025 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367919;
	bh=QXX6gnmouB7ge5PrXPu2VOhpdq8R1AewafLw6xi1P1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1i+KaqaS5+FAq9mZm1S/Bq40//KAd0kkqDHuxYHaAwOeggNPgfgFGpqOttSbz+V2d
	 bd4ZmxTWAmq2IEBrNIRcyRmdeCHNXDfCUSpPmU2gDeohyQJe0RAOACOvupg/3FAaw2
	 mw9E78byIPC0A6gaW7OBALq5UjaIViNCjxDa9QdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/196] usb: vhci-hcd: Prevent suspending virtually attached devices
Date: Mon, 13 Oct 2025 16:45:37 +0200
Message-ID: <20251013144320.593347202@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit e40b984b6c4ce3f80814f39f86f87b2a48f2e662 ]

The VHCI platform driver aims to forbid entering system suspend when at
least one of the virtual USB ports are bound to an active USB/IP
connection.

However, in some cases, the detection logic doesn't work reliably, i.e.
when all devices attached to the virtual root hub have been already
suspended, leading to a broken suspend state, with unrecoverable resume.

Ensure the virtually attached devices do not enter suspend by setting
the syscore PM flag.  Note this is currently limited to the client side
only, since the server side doesn't implement system suspend prevention.

Fixes: 04679b3489e0 ("Staging: USB/IP: add client driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250902-vhci-hcd-suspend-fix-v3-1-864e4e833559@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/vhci_hcd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 14a5f55f24fc8..b22e0881bfaf3 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -764,6 +764,17 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 				 ctrlreq->wValue, vdev->rhport);
 
 			vdev->udev = usb_get_dev(urb->dev);
+			/*
+			 * NOTE: A similar operation has been done via
+			 * USB_REQ_GET_DESCRIPTOR handler below, which is
+			 * supposed to always precede USB_REQ_SET_ADDRESS.
+			 *
+			 * It's not entirely clear if operating on a different
+			 * usb_device instance here is a real possibility,
+			 * otherwise this call and vdev->udev assignment above
+			 * should be dropped.
+			 */
+			dev_pm_syscore_device(&vdev->udev->dev, true);
 			usb_put_dev(old);
 
 			spin_lock(&vdev->ud.lock);
@@ -784,6 +795,17 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 					"Not yet?:Get_Descriptor to device 0 (get max pipe size)\n");
 
 			vdev->udev = usb_get_dev(urb->dev);
+			/*
+			 * Set syscore PM flag for the virtually attached
+			 * devices to ensure they will not enter suspend on
+			 * the client side.
+			 *
+			 * Note this doesn't have any impact on the physical
+			 * devices attached to the host system on the server
+			 * side, hence there is no need to undo the operation
+			 * on disconnect.
+			 */
+			dev_pm_syscore_device(&vdev->udev->dev, true);
 			usb_put_dev(old);
 			goto out;
 
-- 
2.51.0



