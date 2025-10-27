Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16D131D732;
	Mon, 27 Oct 2025 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591229; cv=none; b=Nm/8YBHzlCwBqwt/8fP3MuWEGU4XykcN4OjG2K+r5W3rz717wE6csYxVpn6HofF6pS2QhlhX9SCFSbWefxEGZbyBeklvi7y1lh7jFwPK+1eUIQzXXk19mJURESD5hdwughjkBuIrKzN6kurce6btoWS2Fn3Eowh/se14KgB8WP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591229; c=relaxed/simple;
	bh=KfF6gHhdm9VCPs5/ck69AjWgvONKKbr7AGdopMxI6J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UY6r2vg4xNJA8m/BeSkmiXd6n2q1846fkOB0BVlHOGQp7OehGanuUTYLBMW9tzTeAFjkC5vD7J2cCnEgxHjKOXiV0E2ExDtuPHSEcWKonS9f3fS2O7O9qczhC41wrfLwds6AdyugAjwInlgi9/huF+q592hba6ge8IQqO8SAlXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A92ehYrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A92ehYrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80290C4CEF1;
	Mon, 27 Oct 2025 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591228;
	bh=KfF6gHhdm9VCPs5/ck69AjWgvONKKbr7AGdopMxI6J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A92ehYrh2OHQHg8hgqGGNoYypcsg0/XwRMNQQM8Lt/L3yRSApHXYKRgATYGRYgnXe
	 BpS4HqxxWA7za27B+ISrHLmar9IsySX5baGhVd4+1fu4k3RsRUgZjPKTDF2mPbAJpt
	 fo8HyV5W9kdLfDMr/FB3GbXyTr+01W54GLpwj65c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/332] usb: vhci-hcd: Prevent suspending virtually attached devices
Date: Mon, 27 Oct 2025 19:32:10 +0100
Message-ID: <20251027183526.654137201@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index affcb928771d8..2d2506c598818 100644
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



