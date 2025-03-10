Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB1A23236E;
	Mon, 10 Mar 2025 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626903; cv=none; b=BjKc+YEG9T1Cun+3AsOIjarjqTKkzMf7DuHkhDG3OL4JYzfCC/9w27fsjKdbkQh+3AX07iCbb+wIKLPxGO0PQ6CBIiuRAFDm35ANxnWx+vGgMb/w0a0DXuTqfp1wSpy1lZeZRUvTVix4JrnkMCRualvb7fAF8J7IqWZvJ0zHFDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626903; c=relaxed/simple;
	bh=RpdW1qf8WtEoosLZph9EhoNJZabnbDS/L7DrmYEF134=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkj2mosUnjRMfCUwjNy/vo2Kj6qBAu0h59SslsADnUQaN5wKh8drbfQy5U6HF2fRStaVoc0Y4A9KCatOcqdUhbCGK46Rh/KEBH85ZaJ+ZZy1RKu+ovCTPdfRtir1+i+/8Gl8Zveb0TNtjoNwJ75ua0cUxsy4xr/s/hOeGYmH9g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTy5jnr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTy5jnr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B253AC4CEE5;
	Mon, 10 Mar 2025 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626903;
	bh=RpdW1qf8WtEoosLZph9EhoNJZabnbDS/L7DrmYEF134=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTy5jnr+1pdGMZ/qMsYfVKv6xKLbpFsocMTodb8r3fTg/9QgmLBhnL3XCBi5D/JBm
	 sP0l/QCy8Khetp4XQmfMyxCiDXQCg3FQwcEV+MPIJWaDzWdPjKA1krS2TqAoYsmCWJ
	 xK6F7dJ+fgWMX2t7qILt1h2R9ILVD6wEj9pOBV88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.13 153/207] xhci: Restrict USB4 tunnel detection for USB3 devices to Intel hosts
Date: Mon, 10 Mar 2025 18:05:46 +0100
Message-ID: <20250310170453.878328201@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 487cfd4a8e3dc42d34a759017978a4edaf85fce0 upstream.

When adding support for USB3-over-USB4 tunnelling detection, a check
for an Intel-specific capability was added. This capability, which
goes by ID 206, is used without any check that we are actually
dealing with an Intel host.

As it turns out, the Cadence XHCI controller *also* exposes an
extended capability numbered 206 (for unknown purposes), but of
course doesn't have the Intel-specific registers that the tunnelling
code is trying to access. Fun follows.

The core of the problems is that the tunnelling code blindly uses
vendor-specific capabilities without any check (the Intel-provided
documentation I have at hand indicates that 192-255 are indeed
vendor-specific).

Restrict the detection code to Intel HW for real, preventing any
further explosion on my (non-Intel) HW.

Cc: stable <stable@kernel.org>
Fixes: 948ce83fbb7df ("xhci: Add USB4 tunnel detection for USB3 devices on Intel hosts")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250227194529.2288718-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 #include <linux/bitfield.h>
+#include <linux/pci.h>
 
 #include "xhci.h"
 #include "xhci-trace.h"
@@ -770,9 +771,16 @@ static int xhci_exit_test_mode(struct xh
 enum usb_link_tunnel_mode xhci_port_is_tunneled(struct xhci_hcd *xhci,
 						struct xhci_port *port)
 {
+	struct usb_hcd *hcd;
 	void __iomem *base;
 	u32 offset;
 
+	/* Don't try and probe this capability for non-Intel hosts */
+	hcd = xhci_to_hcd(xhci);
+	if (!dev_is_pci(hcd->self.controller) ||
+	    to_pci_dev(hcd->self.controller)->vendor != PCI_VENDOR_ID_INTEL)
+		return USB_LINK_UNKNOWN;
+
 	base = &xhci->cap_regs->hc_capbase;
 	offset = xhci_find_next_ext_cap(base, 0, XHCI_EXT_CAPS_INTEL_SPR_SHADOW);
 


