Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC912590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AEDC433EF;
	Sun, 22 Jan 2023 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400952;
	bh=0t9SVHLmr4XpwPHxlmAnMe9oSoX617tzC0K7FVJ+Rac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGIQgslEcTQeQ2GyeMFdki+YS/zjW4fFtH7kN0Ls3nn+XmA435SUgsk2Avk4RmeS/
	 ZHTKkZ8NHy2wdIKpLc/DjxKt5INzupmBGUdVNXAJvDtwvS8bnPAXFh/Jd4B2H/a7bH
	 Qvoy71zG7ZI4CNWzS9ho9bU+NnojSL3Z3fuSINlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.1 053/193] xhci: Add update_hub_device override for PCI xHCI hosts
Date: Sun, 22 Jan 2023 16:03:02 +0100
Message-Id: <20230122150248.769876460@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 23a3b8d5a2365653fd9bc5a9454d1e7f4facbf85 upstream.

Allow PCI hosts to check and tune roothub and port settings
before the hub is up and running.

This override is needed to turn off U1 and U2 LPM for some ports
based on per port ACPI _DSM, _UPC, or possibly vendor specific mmio
values for Intel xHC hosts.

Usb core calls the host update_hub_device once it creates a hub.

Entering U1 or U2 link power save state on ports with this limitation
will cause link to fail, turning the usb device unusable in that setup.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230116142216.1141605-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    9 +++++++++
 drivers/usb/host/xhci.c     |    5 ++++-
 drivers/usb/host/xhci.h     |    4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -78,9 +78,12 @@ static const char hcd_name[] = "xhci_hcd
 static struct hc_driver __read_mostly xhci_pci_hc_driver;
 
 static int xhci_pci_setup(struct usb_hcd *hcd);
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags);
 
 static const struct xhci_driver_overrides xhci_pci_overrides __initconst = {
 	.reset = xhci_pci_setup,
+	.update_hub_device = xhci_pci_update_hub_device,
 };
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -386,6 +389,12 @@ static int xhci_pci_setup(struct usb_hcd
 	return xhci_pci_reinit(xhci, pdev);
 }
 
+static int xhci_pci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+				      struct usb_tt *tt, gfp_t mem_flags)
+{
+	return xhci_update_hub_device(hcd, hdev, tt, mem_flags);
+}
+
 /*
  * We need to register our own PCI probe function (instead of the USB core's
  * function) in order to create a second roothub under xHCI.
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5124,7 +5124,7 @@ static int xhci_disable_usb3_lpm_timeout
 /* Once a hub descriptor is fetched for a device, we need to update the xHC's
  * internal data structures for the device.
  */
-static int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
 			struct usb_tt *tt, gfp_t mem_flags)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
@@ -5224,6 +5224,7 @@ static int xhci_update_hub_device(struct
 	xhci_free_command(xhci, config_cmd);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(xhci_update_hub_device);
 
 static int xhci_get_frame(struct usb_hcd *hcd)
 {
@@ -5507,6 +5508,8 @@ void xhci_init_driver(struct hc_driver *
 			drv->check_bandwidth = over->check_bandwidth;
 		if (over->reset_bandwidth)
 			drv->reset_bandwidth = over->reset_bandwidth;
+		if (over->update_hub_device)
+			drv->update_hub_device = over->update_hub_device;
 	}
 }
 EXPORT_SYMBOL_GPL(xhci_init_driver);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1943,6 +1943,8 @@ struct xhci_driver_overrides {
 			     struct usb_host_endpoint *ep);
 	int (*check_bandwidth)(struct usb_hcd *, struct usb_device *);
 	void (*reset_bandwidth)(struct usb_hcd *, struct usb_device *);
+	int (*update_hub_device)(struct usb_hcd *hcd, struct usb_device *hdev,
+			    struct usb_tt *tt, gfp_t mem_flags);
 };
 
 #define	XHCI_CFC_DELAY		10
@@ -2122,6 +2124,8 @@ int xhci_drop_endpoint(struct usb_hcd *h
 		       struct usb_host_endpoint *ep);
 int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
 void xhci_reset_bandwidth(struct usb_hcd *hcd, struct usb_device *udev);
+int xhci_update_hub_device(struct usb_hcd *hcd, struct usb_device *hdev,
+			   struct usb_tt *tt, gfp_t mem_flags);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);
 int xhci_ext_cap_init(struct xhci_hcd *xhci);
 


