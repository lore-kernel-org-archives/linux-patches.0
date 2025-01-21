Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40151F5404;
	Tue, 21 Jan 2025 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482907; cv=none; b=E/EMPoJDW6rJNnqvtJCPIYjjX5LDohnj7Ir7rQ2VSLMT5lPLDQ4SXAHzDfnMQiEDOyIv0LeGo/S5TO9lY1qgyVXrsh70VNakKZk++cwyPQbGSRSo2hQ9lxGOxRr4+Ne8OTrjaG8GpB+7616kcR6B/fSiOFuzJXjm+9jUSxaBl/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482907; c=relaxed/simple;
	bh=f0r6p6LpnYE9L+/RSGYmvXGEsYl+rXrTnh99A59kGLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=csK0e0vvM3Ma8NJnUCQPkIqFhyOk2qX/mk8vv4mF4km2aVko569vQe1CJjQzj5RaFxHCIitvhRgdL9lWdmEAhlc5ssP4Ub74+cSQwzugceQBNqL7bpFWR9CJuJAQgpkT2PGVMHt6yi3SctiVdxrTyAJE6iyGTbpk2eBnaI+gkIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNeHQL9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNeHQL9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7F4C4CEDF;
	Tue, 21 Jan 2025 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482906;
	bh=f0r6p6LpnYE9L+/RSGYmvXGEsYl+rXrTnh99A59kGLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNeHQL9QsxWK0fdkbcSzWS75mvvC6VyCNED8UbzvpraO8ru7STX5uaJeD3HECpPqr
	 8d1A1hkm1pUAKoVjr96EblrIhvz3DWAyliK+bAx6ElNQuIDd8ict/1w5pDjgcLb6ds
	 4dlpA1Conq0wgpYonXF1G3DrvvBmHdqRmhg4d428=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make_ruc2021@163.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 050/127] usb: fix reference leak in usb_new_device()
Date: Tue, 21 Jan 2025 18:52:02 +0100
Message-ID: <20250121174531.599437254@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2605,13 +2605,13 @@ int usb_new_device(struct usb_device *ud
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
@@ -2623,6 +2623,8 @@ int usb_new_device(struct usb_device *ud
 	pm_runtime_put_sync_autosuspend(&udev->dev);
 	return err;
 
+out_del_dev:
+	device_del(&udev->dev);
 fail:
 	usb_set_device_state(udev, USB_STATE_NOTATTACHED);
 	pm_runtime_disable(&udev->dev);


