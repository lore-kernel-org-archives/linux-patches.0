Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44AD20125F;
	Mon, 13 Oct 2025 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368528; cv=none; b=AFSasGQAKZ2iyjP0vgvRy88isdk8on4n9r5JB0HsMhyzYH7/FAxCqG2i98IQOOftQENn8TNRo114uN9RGq7FCceO+lGqKF4Qiw84jAH27t9KvAzFW/4p19C1UmcGv0utWqEoIN/qlxIE29QdpvwhnbHNJQhLfsoyP8wQ8HfETfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368528; c=relaxed/simple;
	bh=wAN4dR44f05Ty1Ubmnuw2fuAlCttf8VxI7t8lWnrF6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exff43NOW7NUGJVf288MSbT5i7EorapGkFnforiW+S2aM+RauL1qLNKFG9+FuOVQW/PEsq8+F7JfzCG1gmzORvjFsa+6zhKt3RGGIWFNlzEKjSnj1mqhQk2g+1YcQ9IcHgeU9aASZeIJDM16oTApprnoIXjaHsv7bewQ/cz5nk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWWrwoAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWWrwoAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53157C4CEE7;
	Mon, 13 Oct 2025 15:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368528;
	bh=wAN4dR44f05Ty1Ubmnuw2fuAlCttf8VxI7t8lWnrF6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWWrwoAa3xC84OOeyaXmNMpL8gGOSxJc6pxTDjxaAVnzQDiHmufigbeFK0Nwo2CY8
	 molbPQ4BFtwarG5cKWvbV7sg1h3gIrGU9cF+KQwJ76Hzq/Rp6VQA1B4V9KtAI87dKB
	 uKFFtvb4i5QkN/W/Ki0R+plOhnd3Fvviot0VBAe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/262] usb: vhci-hcd: Prevent suspending virtually attached devices
Date: Mon, 13 Oct 2025 16:45:35 +0200
Message-ID: <20251013144333.199359674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 8dac1edc74d4e..a793e30d46b78 100644
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



