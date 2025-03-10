Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C04232378;
	Mon, 10 Mar 2025 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626909; cv=none; b=k4cFG84Z3l2Ss1HuJ52Ptf9Tzk2pQtmjioKGUamcgdOLS+xdwuJ2fkL8GARx8kJML1iRkeba/S9syao20jZ9/yCqsYGytOqmyXonjsWZZSUdCBrJAlKywGvlq6CdZnHpjRiAU/CT+/2ENrJVMwSm4ofzmz1zRpx+NzYShxBDqWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626909; c=relaxed/simple;
	bh=LY2k71ZU2tRR5GKjWc+aoHy2nr/gNpm3Eh3hqaIDJhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSEVyGEbfs61p5FnEggOmC86R4DslL0Fnzhtfi8B6XQBmLjY9ecRtceUrLaXyEyUYBVxy/7rmmE5P/ZUuu2ndBnVHDSa1c3xotYURt5WujtpHA8SFRrogVawXcL7JL5yNBflK3CGnon9WlAr305fzYFmhxNs6UiTl7+/oKupVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML0o/ny0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML0o/ny0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7978EC4CEE5;
	Mon, 10 Mar 2025 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626908;
	bh=LY2k71ZU2tRR5GKjWc+aoHy2nr/gNpm3Eh3hqaIDJhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML0o/ny0jN9/LGfRFaWdQLcvATZBanOcVGkWI+oL1getGbhWLEKN9HnCYWdIW1kxk
	 PhVBDc/ZdnLqnk4JNIbIaDo3xDOciesv+7dCA9Ygf8WM5SR4Iftur+oZd5qabMDTHq
	 Qu6/9bfyIboODKfzWJgidYfKKxpODUJPBpmE5rTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.13 155/207] usb: hub: lack of clearing xHC resources
Date: Mon, 10 Mar 2025 18:05:48 +0100
Message-ID: <20250310170453.955969221@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 2b66ef84d0d2a0ea955b40bd306f5e3abbc5cf9c upstream.

The xHC resources allocated for USB devices are not released in correct
order after resuming in case when while suspend device was reconnected.

This issue has been detected during the fallowing scenario:
- connect hub HS to root port
- connect LS/FS device to hub port
- wait for enumeration to finish
- force host to suspend
- reconnect hub attached to root port
- wake host

For this scenario during enumeration of USB LS/FS device the Cadence xHC
reports completion error code for xHC commands because the xHC resources
used for devices has not been properly released.
XHCI specification doesn't mention that device can be reset in any order
so, we should not treat this issue as Cadence xHC controller bug.
Similar as during disconnecting in this case the device resources should
be cleared starting form the last usb device in tree toward the root hub.
To fix this issue usbcore driver should call hcd->driver->reset_device
for all USB devices connected to hub which was reconnected while
suspending.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/PH7PR07MB953841E38C088678ACDCF6EEDDCC2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -6066,6 +6066,36 @@ void usb_hub_cleanup(void)
 } /* usb_hub_cleanup() */
 
 /**
+ * hub_hc_release_resources - clear resources used by host controller
+ * @udev: pointer to device being released
+ *
+ * Context: task context, might sleep
+ *
+ * Function releases the host controller resources in correct order before
+ * making any operation on resuming usb device. The host controller resources
+ * allocated for devices in tree should be released starting from the last
+ * usb device in tree toward the root hub. This function is used only during
+ * resuming device when usb device require reinitialization – that is, when
+ * flag udev->reset_resume is set.
+ *
+ * This call is synchronous, and may not be used in an interrupt context.
+ */
+static void hub_hc_release_resources(struct usb_device *udev)
+{
+	struct usb_hub *hub = usb_hub_to_struct_hub(udev);
+	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
+	int i;
+
+	/* Release up resources for all children before this device */
+	for (i = 0; i < udev->maxchild; i++)
+		if (hub->ports[i]->child)
+			hub_hc_release_resources(hub->ports[i]->child);
+
+	if (hcd->driver->reset_device)
+		hcd->driver->reset_device(hcd, udev);
+}
+
+/**
  * usb_reset_and_verify_device - perform a USB port reset to reinitialize a device
  * @udev: device to reset (not in SUSPENDED or NOTATTACHED state)
  *
@@ -6129,6 +6159,9 @@ static int usb_reset_and_verify_device(s
 	bos = udev->bos;
 	udev->bos = NULL;
 
+	if (udev->reset_resume)
+		hub_hc_release_resources(udev);
+
 	mutex_lock(hcd->address0_mutex);
 
 	for (i = 0; i < PORT_INIT_TRIES; ++i) {


