Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16D1BDA95;
	Thu, 30 Jan 2025 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246975; cv=none; b=eV0EKaMVZJhVpXL9eVtjtVCOU6jGUDg7JwGLbibuGO0Jfw98S9kIT5bGqO21cK9AtzpgQJ48oZ0UN2elHd/OFXOJePWJmGTT7T8QudGI2Njdn6eTUjPOlOYRKadNbUgcT194REA7KElb3wckRDXRHiwO1ddj8U5+SA5HwFvyX2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246975; c=relaxed/simple;
	bh=2qUhejFZQBpSaEQ0G1/w2IK/+Xg3nXJ+BUyePBrn46U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1ADgWW38up2aap3KYpnmI175CnC9vHIPxiuJIKckEI/4EAZlT9BP+20NgcbzNO2ZnM319/sgUE3RcgI3vT+J3r7BfKoabp5LbzJLa9tOcg9dITQGgK9RCIWsvg/Wz1aAF8gEt2hoz+BmssvMdvWXGGQ04vcx7ydTuG7YAbHusk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+/x83P7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+/x83P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C8EC4CED2;
	Thu, 30 Jan 2025 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246975;
	bh=2qUhejFZQBpSaEQ0G1/w2IK/+Xg3nXJ+BUyePBrn46U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+/x83P7qoVv4aHlm79JJKRFJg5ArOayWqkGQ1sOm5amJYQJDnrd6hWBShQmnu7wo
	 s819ZvrM6DviDI8qkCDZVJely/vAHxDgj14r/K/KHcQJ4NpvMy+Kg7TqoAtSESqf/P
	 mKpdjPWJQzAOLEyxDygd7QPbcYAXqAcPWlQ3KgHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make_ruc2021@163.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 040/133] usb: fix reference leak in usb_new_device()
Date: Thu, 30 Jan 2025 15:00:29 +0100
Message-ID: <20250130140144.126654805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

commit 0df11fa8cee5a9cf8753d4e2672bb3667138c652 upstream.

When device_add(&udev->dev) succeeds and a later call fails,
usb_new_device() does not properly call device_del(). As comment of
device_add() says, 'if device_add() succeeds, you should call
device_del() when you want to get rid of it. If device_add() has not
succeeded, use only put_device() to drop the reference count'.

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 9f8b17e643fe ("USB: make usbdevices export their device nodes instead of using a separate class")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241218071346.2973980-1-make_ruc2021@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2604,13 +2604,13 @@ int usb_new_device(struct usb_device *ud
 		err = sysfs_create_link(&udev->dev.kobj,
 				&port_dev->dev.kobj, "port");
 		if (err)
-			goto fail;
+			goto out_del_dev;
 
 		err = sysfs_create_link(&port_dev->dev.kobj,
 				&udev->dev.kobj, "device");
 		if (err) {
 			sysfs_remove_link(&udev->dev.kobj, "port");
-			goto fail;
+			goto out_del_dev;
 		}
 
 		if (!test_and_set_bit(port1, hub->child_usage_bits))
@@ -2622,6 +2622,8 @@ int usb_new_device(struct usb_device *ud
 	pm_runtime_put_sync_autosuspend(&udev->dev);
 	return err;
 
+out_del_dev:
+	device_del(&udev->dev);
 fail:
 	usb_set_device_state(udev, USB_STATE_NOTATTACHED);
 	pm_runtime_disable(&udev->dev);


