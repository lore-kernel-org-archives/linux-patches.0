Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942B817A2E8;
	Mon, 10 Mar 2025 18:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629649; cv=none; b=jUMAzs42RXLbLfgf3knJYRVNe4O8lF6W1N4a4EI3ZEpyANEhFP/9WjQ2sp3WIJcTR7CO253HnyNJamjxdGyjU2jrt5AeYzA65+z9IlgRio98QyjBgn6AcQZ3R5WM/slD9NXVZCJ2odk61n6PIFrFKUgq+cG54cq0qokIB8KJITs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629649; c=relaxed/simple;
	bh=bU34KvswcYy/9EiswDDJNFKE4dxrK1va4IlP9eqvUXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOLBz1NJiLfkLsrTuCaigVE1spkUw7O5nMwFKQrax4p1XYTGYKuaHqfcoXr6821gp3w2RhePLMtsOKXGDwhMxnx77+ZCr5dPW+o8mwowRmy1XI80DkJZXFhP318FiKt+InlxtSfOdQvVK6iypvAQ9A3pMepRJmVcnMk459+o/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKnNH073; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKnNH073"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18977C4CEE5;
	Mon, 10 Mar 2025 18:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629649;
	bh=bU34KvswcYy/9EiswDDJNFKE4dxrK1va4IlP9eqvUXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKnNH073DfCWaPYUcFdx4k+KGeuUUxweaHgVyCMVQ5FDkHsV+84VIl8ExDvcpoa/w
	 sF9Bt2U4pO92u0gnMTpjqB3MbO3PMmqOG/XwK8NivLjdbn5F7f/EJlKxVmeHde0nUH
	 sC0f1uVZqyIYHAxY3959UjTjlETTqRRT5hUsbSII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 5.15 368/620] USB: hub: Ignore non-compliant devices with too many configs or interfaces
Date: Mon, 10 Mar 2025 18:03:34 +0100
Message-ID: <20250310170600.131656635@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 2240fed37afbcdb5e8b627bc7ad986891100e05d upstream.

Robert Morris created a test program which can cause
usb_hub_to_struct_hub() to dereference a NULL or inappropriate
pointer:

Oops: general protection fault, probably for non-canonical address
0xcccccccccccccccc: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
CPU: 7 UID: 0 PID: 117 Comm: kworker/7:1 Not tainted 6.13.0-rc3-00017-gf44d154d6e3d #14
Hardware name: FreeBSD BHYVE/BHYVE, BIOS 14.0 10/17/2021
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_hub_adjust_deviceremovable+0x78/0x110
...
Call Trace:
 <TASK>
 ? die_addr+0x31/0x80
 ? exc_general_protection+0x1b4/0x3c0
 ? asm_exc_general_protection+0x26/0x30
 ? usb_hub_adjust_deviceremovable+0x78/0x110
 hub_probe+0x7c7/0xab0
 usb_probe_interface+0x14b/0x350
 really_probe+0xd0/0x2d0
 ? __pfx___device_attach_driver+0x10/0x10
 __driver_probe_device+0x6e/0x110
 driver_probe_device+0x1a/0x90
 __device_attach_driver+0x7e/0xc0
 bus_for_each_drv+0x7f/0xd0
 __device_attach+0xaa/0x1a0
 bus_probe_device+0x8b/0xa0
 device_add+0x62e/0x810
 usb_set_configuration+0x65d/0x990
 usb_generic_driver_probe+0x4b/0x70
 usb_probe_device+0x36/0xd0

The cause of this error is that the device has two interfaces, and the
hub driver binds to interface 1 instead of interface 0, which is where
usb_hub_to_struct_hub() looks.

We can prevent the problem from occurring by refusing to accept hub
devices that violate the USB spec by having more than one
configuration or interface.

Reported-and-tested-by: Robert Morris <rtm@csail.mit.edu>
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/linux-usb/95564.1737394039@localhost/
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/c27f3bf4-63d8-4fb5-ac82-09e3cd19f61c@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1804,6 +1804,17 @@ static int hub_probe(struct usb_interfac
 	hdev = interface_to_usbdev(intf);
 
 	/*
+	 * The USB 2.0 spec prohibits hubs from having more than one
+	 * configuration or interface, and we rely on this prohibition.
+	 * Refuse to accept a device that violates it.
+	 */
+	if (hdev->descriptor.bNumConfigurations > 1 ||
+			hdev->actconfig->desc.bNumInterfaces > 1) {
+		dev_err(&intf->dev, "Invalid hub with more than one config or interface\n");
+		return -EINVAL;
+	}
+
+	/*
 	 * Set default autosuspend delay as 0 to speedup bus suspend,
 	 * based on the below considerations:
 	 *


