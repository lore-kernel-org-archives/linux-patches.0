Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1B514A4C9;
	Tue, 25 Jun 2024 09:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308333; cv=none; b=BgXZ4bb1+Uq0PPMvDKW2dMsEplAQjSMqeh3NL7+yp3RTj3Waj8vQJt5jErEG5emgEA3i3Cj/n3uQfwDytcyC5AO2qysxeDxIu+toUtT+DQwATrP/UqWH9SSSBzZLrzV1MgZHBHYBMI76+Qd1oBJlf1J3zwxjI0JrVAgG3vdoIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308333; c=relaxed/simple;
	bh=4jXP9q1QoVIN/4rn6q3HFBf9pyDK8wGb7+jPyraz2Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHsXLIPG/JB9545odWjPEOFCuxLtGYpdqlUWuFQ3HDRB/ADkv++tp97JjknPGXe8cLPhL5ahJxCDRYmV/ZfI1LArl8+iKMfx+44GDA6XV5G7Qd4JOrJNBpxPC/6gapGTFRVx7Cm7y5pfZdQTpAbwYS4Hxedt0FQN2aNqoenroBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4brTDNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4brTDNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A1C4AF09;
	Tue, 25 Jun 2024 09:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308332;
	bh=4jXP9q1QoVIN/4rn6q3HFBf9pyDK8wGb7+jPyraz2Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4brTDNxAL+pjWZVo0aLyEXpz1tkWETeUmpoCF/jClNFX5fnjzmanK1T0eOyzihjK
	 sfb8jBiqTFWJdLcWQydowlMSoN/wGjC7t8zH0DMFVaHaMXAoKEea9sUssjVkwpQV+Y
	 3RCOMlpYYEa2NfpvIAK3y44svsg2xJpF/FZ7LmD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 085/250] xhci: remove XHCI_TRUST_TX_LENGTH quirk
Date: Tue, 25 Jun 2024 11:30:43 +0200
Message-ID: <20240625085551.329914854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 34b67198244f2d7d8409fa4eb76204c409c0c97e ]

If this quirk was set then driver would treat transfer events with
'Success' completion code as 'Short packet' if there were untransferred
bytes left.

This is so common that turn it into default behavior.

xhci_warn_ratelimited() is no longer used after this, so remove it.

A success event with untransferred bytes left doesn't always mean a
misbehaving controller. If there was an error mid a multi-TRB TD it's
allowed to issue a success event for the last TRB in that TD.

See xhci 1.2 spec 4.9.1 Transfer Descriptors

"Note: If an error is detected while processing a multi-TRB TD, the xHC
 shall generate a Transfer Event for the TRB that the error was detected
 on with the appropriate error Condition Code, then may advance to the
 next TD. If in the process of advancing to the next TD, a Transfer TRB
 is encountered with its IOC flag set, then the Condition Code of the
 Transfer Event generated for that Transfer TRB should be Success,
 because there was no error actually associated with the TRB that
 generated the Event. However, an xHC implementation may redundantly
 assert the original error Condition Code."

Co-developed-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240429140245.3955523-10-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c  | 15 ++-------------
 drivers/usb/host/xhci-rcar.c |  6 ++----
 drivers/usb/host/xhci-ring.c | 15 +++++----------
 drivers/usb/host/xhci.h      |  4 +---
 4 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index b271ec916926b..febf64723434c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -271,17 +271,12 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 				"QUIRK: Fresco Logic revision %u "
 				"has broken MSI implementation",
 				pdev->revision);
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
 			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1009)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
-	if (pdev->vendor == PCI_VENDOR_ID_FRESCO_LOGIC &&
-			pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_FL1100)
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
-
 	if (pdev->vendor == PCI_VENDOR_ID_NEC)
 		xhci->quirks |= XHCI_NEC_HOST;
 
@@ -308,11 +303,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	}
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
-		if (pdev->device == 0x43f7)
-			xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
-	}
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x43f7)
+		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if ((pdev->vendor == PCI_VENDOR_ID_AMD) &&
 		((pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4) ||
@@ -400,7 +392,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_EJ168) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
@@ -411,7 +402,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 	    pdev->device == 0x0014) {
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 		xhci->quirks |= XHCI_ZERO_64B_REGS;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
@@ -441,7 +431,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
-		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
diff --git a/drivers/usb/host/xhci-rcar.c b/drivers/usb/host/xhci-rcar.c
index ab9c5969e4624..8b357647728c2 100644
--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -214,8 +214,7 @@ static int xhci_rcar_resume_quirk(struct usb_hcd *hcd)
  */
 #define SET_XHCI_PLAT_PRIV_FOR_RCAR(firmware)				\
 	.firmware_name = firmware,					\
-	.quirks = XHCI_NO_64BIT_SUPPORT | XHCI_TRUST_TX_LENGTH |	\
-		  XHCI_SLOW_SUSPEND,					\
+	.quirks = XHCI_NO_64BIT_SUPPORT |  XHCI_SLOW_SUSPEND,		\
 	.init_quirk = xhci_rcar_init_quirk,				\
 	.plat_start = xhci_rcar_start,					\
 	.resume_quirk = xhci_rcar_resume_quirk,
@@ -229,8 +228,7 @@ static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen3 = {
 };
 
 static const struct xhci_plat_priv xhci_plat_renesas_rzv2m = {
-	.quirks = XHCI_NO_64BIT_SUPPORT | XHCI_TRUST_TX_LENGTH |
-		  XHCI_SLOW_SUSPEND,
+	.quirks = XHCI_NO_64BIT_SUPPORT | XHCI_SLOW_SUSPEND,
 	.init_quirk = xhci_rzv2m_init_quirk,
 	.plat_start = xhci_rzv2m_start,
 };
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 850846c206ed4..48d745e9f9730 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2431,8 +2431,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 			break;
 		if (remaining) {
 			frame->status = short_framestatus;
-			if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
-				sum_trbs_for_length = true;
+			sum_trbs_for_length = true;
 			break;
 		}
 		frame->status = 0;
@@ -2681,15 +2680,11 @@ static int handle_tx_event(struct xhci_hcd *xhci,
 	 * transfer type
 	 */
 	case COMP_SUCCESS:
-		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
-			break;
-		if (xhci->quirks & XHCI_TRUST_TX_LENGTH ||
-		    ep_ring->last_td_was_short)
+		if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
 			trb_comp_code = COMP_SHORT_PACKET;
-		else
-			xhci_warn_ratelimited(xhci,
-					      "WARN Successful completion on short TX for slot %u ep %u: needs XHCI_TRUST_TX_LENGTH quirk?\n",
-					      slot_id, ep_index);
+			xhci_dbg(xhci, "Successful completion on short TX for slot %u ep %u with last td short %d\n",
+				 slot_id, ep_index, ep_ring->last_td_was_short);
+		}
 		break;
 	case COMP_SHORT_PACKET:
 		break;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 069a187540a0c..1683d779e4bc0 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1590,7 +1590,7 @@ struct xhci_hcd {
 #define XHCI_RESET_ON_RESUME	BIT_ULL(7)
 #define	XHCI_SW_BW_CHECKING	BIT_ULL(8)
 #define XHCI_AMD_0x96_HOST	BIT_ULL(9)
-#define XHCI_TRUST_TX_LENGTH	BIT_ULL(10)
+#define XHCI_TRUST_TX_LENGTH	BIT_ULL(10) /* Deprecated */
 #define XHCI_LPM_SUPPORT	BIT_ULL(11)
 #define XHCI_INTEL_HOST		BIT_ULL(12)
 #define XHCI_SPURIOUS_REBOOT	BIT_ULL(13)
@@ -1730,8 +1730,6 @@ static inline bool xhci_has_one_roothub(struct xhci_hcd *xhci)
 	dev_err(xhci_to_hcd(xhci)->self.controller , fmt , ## args)
 #define xhci_warn(xhci, fmt, args...) \
 	dev_warn(xhci_to_hcd(xhci)->self.controller , fmt , ## args)
-#define xhci_warn_ratelimited(xhci, fmt, args...) \
-	dev_warn_ratelimited(xhci_to_hcd(xhci)->self.controller , fmt , ## args)
 #define xhci_info(xhci, fmt, args...) \
 	dev_info(xhci_to_hcd(xhci)->self.controller , fmt , ## args)
 
-- 
2.43.0



