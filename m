Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B44E1F7540;
	Tue,  3 Dec 2024 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239739; cv=none; b=QlytzD+6dfCDizJEC5PbsP4mHsEzReOTjXFR5vUN+Pr6eYTzbf+AODesXMq1vC1Q3beEjhzlpz7UGSEdojA8jSj3P/Xvl7JrLS2CMjqmBEpKX8hv9b05vEF763VvnWk+5UU2F6tK375FtvjVICE0Q2CJefPsQtd0tdNvOPD8W24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239739; c=relaxed/simple;
	bh=Yy1ceF9Gx3YUC+c1aQdrONCxCgF1cvM6XV8D4pKvq9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX/d0LDcVCLP429r+Ay42RKaxImwzxSXnBwo9etfsjOa2DQ3vac1imXyCHu8aAxAYL4ljDAhorcB2u5fV/v6jDG6dZCypb3Am+G+BWAqZZyJ7REBvemJt/+07yXCMExUDU/QEQWi31a+SlngolixwdTFBGnvPXxh96seIBRPJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4tZtYxj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4tZtYxj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE96BC4CECF;
	Tue,  3 Dec 2024 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239739;
	bh=Yy1ceF9Gx3YUC+c1aQdrONCxCgF1cvM6XV8D4pKvq9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4tZtYxjsSY2expKTkqZxfABCyRxqBnbViifW3+y9L1lSsw02w2upsy2aDAYNI9Ky
	 OVHCXIz3bCT2XY3ag0of8mumsmAUuz/qcIeHK97XpFOJVBdw8+GTPQJkYVrgumCKuX
	 6Ig+AVtO7NegpOwjD0wj58OyQ6EnXBKgW4+iwEpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.11 676/817] xhci: Dont issue Reset Device command to Etron xHCI host
Date: Tue,  3 Dec 2024 15:44:08 +0100
Message-ID: <20241203144022.344921348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuangyi Chiang <ki.chiang65@gmail.com>

commit 76d98856b1c6d06ce18f32c20527a4f9d283e660 upstream.

Sometimes the hub driver does not recognize the USB device connected
to the external USB2.0 hub when the system resumes from S4.

After the SetPortFeature(PORT_RESET) request is completed, the hub
driver calls the HCD reset_device callback, which will issue a Reset
Device command and free all structures associated with endpoints
that were disabled.

This happens when the xHCI driver issue a Reset Device command to
inform the Etron xHCI host that the USB device associated with a
device slot has been reset. Seems that the Etron xHCI host can not
perform this command correctly, affecting the USB device.

To work around this, the xHCI driver should obtain a new device slot
with reference to commit 651aaf36a7d7 ("usb: xhci: Handle USB transaction
error on address command"), which is another way to inform the Etron
xHCI host that the USB device has been reset.

Add a new XHCI_ETRON_HOST quirk flag to invoke the workaround in
xhci_discover_or_reset_device().

Fixes: 2a8f82c4ceaf ("USB: xhci: Notify the xHC when a device is reset.")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-19-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    1 +
 drivers/usb/host/xhci.c     |   19 +++++++++++++++++++
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 21 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -403,6 +403,7 @@ static void xhci_pci_quirks(struct devic
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 	    (pdev->device == PCI_DEVICE_ID_EJ168 ||
 	     pdev->device == PCI_DEVICE_ID_EJ188)) {
+		xhci->quirks |= XHCI_ETRON_HOST;
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 		xhci->quirks |= XHCI_NO_SOFT_RETRY;
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3692,6 +3692,8 @@ void xhci_free_device_endpoint_resources
 				xhci->num_active_eps);
 }
 
+static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
+
 /*
  * This submits a Reset Device Command, which will set the device state to 0,
  * set the device address to 0, and disable all the endpoints except the default
@@ -3762,6 +3764,23 @@ static int xhci_discover_or_reset_device
 						SLOT_STATE_DISABLED)
 		return 0;
 
+	if (xhci->quirks & XHCI_ETRON_HOST) {
+		/*
+		 * Obtaining a new device slot to inform the xHCI host that
+		 * the USB device has been reset.
+		 */
+		ret = xhci_disable_slot(xhci, udev->slot_id);
+		xhci_free_virt_device(xhci, udev->slot_id);
+		if (!ret) {
+			ret = xhci_alloc_dev(hcd, udev);
+			if (ret == 1)
+				ret = 0;
+			else
+				ret = -EINVAL;
+		}
+		return ret;
+	}
+
 	trace_xhci_discover_or_reset_device(slot_ctx);
 
 	xhci_dbg(xhci, "Resetting device with slot ID %u\n", slot_id);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1629,6 +1629,7 @@ struct xhci_hcd {
 #define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
 #define XHCI_WRITE_64_HI_LO	BIT_ULL(47)
 #define XHCI_CDNS_SCTX_QUIRK	BIT_ULL(48)
+#define XHCI_ETRON_HOST	BIT_ULL(49)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


