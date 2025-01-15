Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC668248BA7;
	Wed, 15 Jan 2025 10:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937735; cv=none; b=RchtZwvuaeWaD2B4iJygVGdeBQAPTFPBNeMHhZlJIrPwhth0l1ayxou5vBglw4+du5qq5D/sSbkxaxUvSplMMavfgsO6bOyNOgBCioETD4ijFk9Dq8rTbsTgQtknMBMjyoxQKck1/zIAgQo7blKXocIEvSOWVm6aaFsfZK/EWwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937735; c=relaxed/simple;
	bh=c8qFMsTNwarIIrrZzbG8EPLdCfnYOzF97pN+5Syz7oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG60H3hgI60t9XhPcrZb5q8uR/6t63mEodxfSf2T3ADcS+z5MkYmAEIjCwL0PO/9rvHTkrOon689/b8FtwKiueWl7+ylrFkBDG7RsEXVo7Aumrp0a16taGAQ3BR57Gsb/dxlmSFXOujURbpRVKnWPBUGUQi9lNirXIn3o6xz91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJb7B+gQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJb7B+gQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5FEC4CEE2;
	Wed, 15 Jan 2025 10:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937733;
	bh=c8qFMsTNwarIIrrZzbG8EPLdCfnYOzF97pN+5Syz7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJb7B+gQWeLUT7fSf0qNjZNVxiS6ZxOy+PdIMk7cgsa52JomSdDHj4IzOtftUY7Es
	 UOfwgAMIqfklml3Qzq5AwQxK1P4T7BIvr+wpbnhjhGA/V2ZfeJh/4MKWQxAdAenxC7
	 Kh91m9pCFT/oC8M65yEnGaLmPqxusWaJl0e0hq5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make_ruc2021@163.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 66/92] usb: fix reference leak in usb_new_device()
Date: Wed, 15 Jan 2025 11:37:24 +0100
Message-ID: <20250115103550.189020155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2632,13 +2632,13 @@ int usb_new_device(struct usb_device *ud
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
@@ -2650,6 +2650,8 @@ int usb_new_device(struct usb_device *ud
 	pm_runtime_put_sync_autosuspend(&udev->dev);
 	return err;
 
+out_del_dev:
+	device_del(&udev->dev);
 fail:
 	usb_set_device_state(udev, USB_STATE_NOTATTACHED);
 	pm_runtime_disable(&udev->dev);


