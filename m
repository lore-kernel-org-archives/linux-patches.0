Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98A82566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA97C433EF;
	Tue, 18 Apr 2023 12:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821158;
	bh=AcPItg8NvLaplLX1JB3P8phC12zXZ2Dd2KRzeOTis4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7CS6R1wyIWydlwDopPACWBcaM/D9c5lNNfeZ2m4vu0ZHcAC31zl0xXPk76wf+39I
	 5lyiU6AVpltBjRYQDsDMNz8nKusjzukonMN9DgSSIFgXi6xCoQOPjPQaMfiHY/cLGF
	 lQ7oXIOtHjk1GlrDSXoSQsKFWdJu+43lIB3w+g64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Marc Zyngier <maz@kernel.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 020/124] xhci: also avoid the XHCI_ZERO_64B_REGS quirk with a passthrough iommu
Date: Tue, 18 Apr 2023 14:20:39 +0200
Message-Id: <20230418120310.404968830@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D Scott Phillips <scott@os.amperecomputing.com>

commit ecaa4902439298f6b0e29f47424a86b310a9ff4f upstream.

Previously the quirk was skipped when no iommu was present. The same
rationale for skipping the quirk also applies in the iommu.passthrough=1
case.

Skip applying the XHCI_ZERO_64B_REGS quirk if the device's iommu domain is
passthrough.

Fixes: 12de0a35c996 ("xhci: Add quirk to zero 64bit registers on Renesas PCIe controllers")
Cc: stable <stable@kernel.org>
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 #include <linux/iopoll.h>
 #include <linux/irq.h>
 #include <linux/log2.h>
@@ -226,6 +227,7 @@ int xhci_reset(struct xhci_hcd *xhci, u6
 static void xhci_zero_64b_regs(struct xhci_hcd *xhci)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	struct iommu_domain *domain;
 	int err, i;
 	u64 val;
 	u32 intrs;
@@ -244,7 +246,9 @@ static void xhci_zero_64b_regs(struct xh
 	 * an iommu. Doing anything when there is no iommu is definitely
 	 * unsafe...
 	 */
-	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !device_iommu_mapped(dev))
+	domain = iommu_get_domain_for_dev(dev);
+	if (!(xhci->quirks & XHCI_ZERO_64B_REGS) || !domain ||
+	    domain->type == IOMMU_DOMAIN_IDENTITY)
 		return;
 
 	xhci_info(xhci, "Zeroing 64bit base registers, expecting fault\n");


