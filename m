Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D831D396;
	Mon, 13 Oct 2025 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369999; cv=none; b=Q9sRvaGYIipZ5CqOMqUk9EmZPKGX307NICj3CbxJzwKR8en1cRI7xPT57SLLg+dxOhoD2gUYDyDya1PXp/VC6f89ZA0iqHCJbRPBjq3y9ETeE1Sbhy2krXWnXL+oOm7GWnnw6Q5LDmZkFGuk96e1gK6YjRneJyHQsy9IR84I+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369999; c=relaxed/simple;
	bh=nBGIPg6XXIg+h6Puclgghb5PsAXYZVk7XqXDGwHqnSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbtCCkDdvzQQE1q6Ik6ep2GIbmk2AoDxr9EJ2VklKexpieVRabiE1DNX87gald0cU+5UKNXhki4/tH6tqdXKBoSlY/A/bTHe7DwLIYwUbaOyl546p4xW/B/RJilDJevUHoaukQRsMKuctEXVCpAqCvRKEg2sHej/koLjZrKIhcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIycA63s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIycA63s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F84C116C6;
	Mon, 13 Oct 2025 15:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369998;
	bh=nBGIPg6XXIg+h6Puclgghb5PsAXYZVk7XqXDGwHqnSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIycA63sEEIHLRWa/Cg/vTvutdfQJBe+s6jGzRSbOyl5blJf5esyPLC7eUEB2gn8z
	 aPCLyDMpdICcc/pM3j8dqsInFkSqfMWLN1c+zZdZR0y7BrozKKnfd9cAig/LBbEnRq
	 npvzO2Jm06Tmj3hu7PK9fWA1p/qyLwA3FqCAcmEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 441/563] usb: vhci-hcd: Prevent suspending virtually attached devices
Date: Mon, 13 Oct 2025 16:45:02 +0200
Message-ID: <20251013144427.258123443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index e70fba9f55d6a..0d6c10a8490c0 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -765,6 +765,17 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
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
@@ -785,6 +796,17 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
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



