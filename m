Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293D8517BA9;
	Mon, 31 Aug 2026 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183810; cv=none; b=nQl7ZXFHTbMztmzTAOZOpExXphxCneC+QrYwv5q7xLtS+no17XSaZ0uocUtLrPIpD4fZc7DoUf14xG+u7ihAqPgBiUTnHVfGzKo5x2xN9xcUmYk8+8UEKHaf/tcT4ZwVokdNXudypnuaaNSDkOw7asoaj4Eitn/z+Yz+ZcMfwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183810; c=relaxed/simple;
	bh=L/U8JwRUPb7jf9ayewEkIQwp+BQHCWe0Y5j8qV6YXx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfYAbGuDE++AijNLfWffzAnhciJgftsXH0AMi3bicL0Ovhngp4NPm/X8ESnJ+fTu+XwcrM03rPE4RFzg1qVP8Cx4/j0EZCtsOCJEg+QVZCnfNdlgaFKfji1KmugtWxRTV6Taa083MS8rHr3kxcrle8CBHPdetUZQ7qZ0pKMUqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLN2hYSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLN2hYSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAAF1F00A3D;
	Mon, 31 Aug 2026 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183808;
	bh=KI7627IY+8wjZQdDo7ER05xOo/vdB+wQYLdlKj3s+WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLN2hYSRHKguOQTHXxg8o4r8f1sGjyNQ9fWahBOl610hIiITZgjodNrBa97YMtFgG
	 svnwlPnj9gJGHUrIw9YNOW8ZwpNT/QfzQLjje/d10MYzSL33Vz/FKdfHEw6tUN/PQZ
	 SgmAGGMEyQXvCKAEAeKPyTAUvBjr6QnR5r4d9kWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.1 22/76] usb: xhci: bail out of setup if the controller is inaccessible
Date: Mon, 31 Aug 2026 15:33:54 +0200
Message-ID: <20260831133400.380872456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 78203d5b54a40f0e36196ebf31c9c7a380fc8811 upstream.

xhci_gen_setup() locates the operational registers using the capability
length read from the very first register:

	xhci->op_regs = hcd->regs +
		HC_LENGTH(readl(&xhci->cap_regs->hc_capbase));

If the controller is dead or has dropped off the bus, that read returns
~0, HC_LENGTH() truncates it to 0xff, and op_regs ends up 0xff bytes
past the page-aligned MMIO base, i.e. unaligned. The first access
through it, xhci_halt() -> xhci_handshake() reading op_regs->status, is
then an unaligned readl() on device memory. arm64 faults on unaligned
device accesses, so instead of xhci_handshake() catching the all-ones
value and returning -ENODEV, setup oopses:

  xhci-pci-renesas 0005:08:00.0: Unable to change power state from D3cold to D0, device inaccessible
  xhci-pci-renesas 0005:08:00.0: xHCI Host Controller
  xhci-pci-renesas 0005:08:00.0: new USB bus registered, assigned bus number 1
  Unable to handle kernel paging request at virtual address ffff80030a770103
    ESR = 0x0000000096000021
    FSC = 0x21: alignment fault
  Internal error: Oops: 0000000096000021 [#1]  SMP
  pc : xhci_halt [xhci_hcd]
  Call trace:
   xhci_halt
   xhci_gen_setup
   xhci_pci_setup
   usb_add_hcd
   usb_hcd_pci_probe
   xhci_pci_common_probe
   xhci_pci_renesas_probe

This was hit with a Renesas uPD720201 that failed to power up ("Unable
to change power state from D3cold to D0, device inaccessible") yet still
reached the HCD probe path.

Read the capability register once, and if it reads back the all-ones
value (as xhci_handshake() and xhci_reset() already test for), abort
setup with -ENODEV before op_regs is derived from it. Reading it once
also avoids re-reading a register that may change under a concurrent
hot-removal.

Fixes: 66d4eadd8d06 ("USB: xhci: BIOS handoff and HW initialization.")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260806142113.2436238-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5436,6 +5436,7 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	struct device		*dev = hcd->self.sysdev;
 	int			retval;
 	u32			hcs_params1;
+	u32			hc_capbase;
 
 	/* Accept arbitrarily long scatter-gather lists */
 	hcd->self.sg_tablesize = ~0;
@@ -5456,15 +5457,19 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	mutex_init(&xhci->mutex);
 	xhci->main_hcd = hcd;
 	xhci->cap_regs = hcd->regs;
-	xhci->op_regs = hcd->regs +
-		HC_LENGTH(readl(&xhci->cap_regs->hc_capbase));
+	hc_capbase = readl(&xhci->cap_regs->hc_capbase);
+	if (hc_capbase == U32_MAX) {
+		xhci_warn(xhci, "Host controller not accessible, removed?\n");
+		return -ENODEV;
+	}
+	xhci->op_regs = hcd->regs + HC_LENGTH(hc_capbase);
 	xhci->run_regs = hcd->regs +
 		(readl(&xhci->cap_regs->run_regs_off) & RTSOFF_MASK);
 	/* Cache read-only capability registers */
 	hcs_params1 = readl(&xhci->cap_regs->hcs_params1);
 	xhci->hcs_params2 = readl(&xhci->cap_regs->hcs_params2);
 	xhci->hcs_params3 = readl(&xhci->cap_regs->hcs_params3);
-	xhci->hci_version = HC_VERSION(readl(&xhci->cap_regs->hc_capbase));
+	xhci->hci_version = HC_VERSION(hc_capbase);
 	xhci->hcc_params = readl(&xhci->cap_regs->hcc_params);
 	if (xhci->hci_version > 0x100)
 		xhci->hcc_params2 = readl(&xhci->cap_regs->hcc_params2);


