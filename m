Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F67E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9CC433D6;
	Wed,  2 Nov 2022 03:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358866;
	bh=nMfqhsNKOLbmYaEwocGrQS0M7V4qGvXjMkDphrxv6Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLjngBc9Yl3+Xb3RTWE8EmLOpppUXqtnjj4NU/UlYaiZx7gD5XKBtXZT6oTVMfIbY
	 +SY6qY0uoSJJthZJrF/0Js0Tqp32I4punKCT8rFoPBZ5j2ZzENrVgcZkth/x0Ex1ML
	 Orzc/CtTPkYX7hpyvHaluOkHSyxqxWoEBFfe/w0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 12/91] xhci: Add quirk to reset host back to default state at shutdown
Date: Wed,  2 Nov 2022 03:32:55 +0100
Message-Id: <20221102022055.394858891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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

commit 34cd2db408d591bc15771cbcc90939ade0a99a21 upstream.

Systems based on Alder Lake P see significant boot time delay if
boot firmware tries to control usb ports in unexpected link states.

This is seen with self-powered usb devices that survive in U3 link
suspended state over S5.

A more generic solution to power off ports at shutdown was attempted in
commit 83810f84ecf1 ("xhci: turn off port power in shutdown")
but it caused regression.

Add host specific XHCI_RESET_TO_DEFAULT quirk which will reset host and
ports back to default state in shutdown.

Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-3-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 ++++
 drivers/usb/host/xhci.c     |   10 ++++++++--
 drivers/usb/host/xhci.h     |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -254,6 +254,10 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_MISSING_CAS;
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI)
+		xhci->quirks |= XHCI_RESET_TO_DEFAULT;
+
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_2C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_4C_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALPINE_RIDGE_LP_XHCI ||
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -794,9 +794,15 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
-	/* Workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+
+	/*
+	 * Workaround for spurious wakeps at shutdown with HSW, and for boot
+	 * firmware delay in ADL-P PCH if port are left in U3 at shutdown
+	 */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP ||
+	    xhci->quirks & XHCI_RESET_TO_DEFAULT)
 		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
+
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1889,6 +1889,7 @@ struct xhci_hcd {
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 #define XHCI_SUSPEND_RESUME_CLKS	BIT_ULL(43)
+#define XHCI_RESET_TO_DEFAULT	BIT_ULL(44)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


