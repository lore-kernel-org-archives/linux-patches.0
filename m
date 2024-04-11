Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE34114B07B;
	Thu, 11 Apr 2024 10:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831648; cv=none; b=pF3uqzxnVCQvUgcT9fh00SJyzx/AhaMD9JBMrBcoex+lSRZrG0Jic7NVfq/PKCvBtufEkAR1q1H4hAY6uXvK/DfZumRjORxt2xaqJw53C/HSvMjlJi2PODusHL0ASY8vvadpEdw4D3gw3xatg/hiv47BXHeXmBRtNkadtk4AZSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831648; c=relaxed/simple;
	bh=EdSgtFducRCtP/XivefJgSDJbIIhL2YAp+tQptYteSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncTLx5ZAGB4Jksnt/xJfnN9oHD97tv1SuLA1TZ6YwwXxRqkhRFYOz9L1tlZkLh4iQeF7I+L17RjiSZK3cax2Wp1qDeUj4xoLWR0nW9hVXNUiUbAtB1sucKMSYa9GiGvMxlUkTyjInFydhbzHPSpmI72HXJGni0SXGvBswnV3M3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n10KiLck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n10KiLck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64835C433C7;
	Thu, 11 Apr 2024 10:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831647;
	bh=EdSgtFducRCtP/XivefJgSDJbIIhL2YAp+tQptYteSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n10KiLckndTcLBOtTl+OL218KkkfkT8UEof5/S0cdIH/3MbLpEHiQAEBFvwwY4r5W
	 S2ZzdfyB7ldQONb81kzJtNVc795kW3nOG45IYDibqQAboapbdGpzfgekypcV1h8H7b
	 vSPx63Z9JJJVQgsOgUU+98tsnDHZmdMbU5X9rEEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/294] PCI: Cache PCIe Device Capabilities register
Date: Thu, 11 Apr 2024 11:53:45 +0200
Message-ID: <20240411095437.559079636@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amey Narkhede <ameynarkhede03@gmail.com>

[ Upstream commit 69139244806537f9d51364f37fe146bb2ee88a05 ]

Add a new member called devcap in struct pci_dev for caching the PCIe
Device Capabilities register to avoid reading PCI_EXP_DEVCAP multiple
times.

Refactor pcie_has_flr() to use cached device capabilities.

Link: https://lore.kernel.org/r/20210817180500.1253-2-ameynarkhede03@gmail.com
Signed-off-by: Amey Narkhede <ameynarkhede03@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
Stable-dep-of: 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c   | 6 ++----
 drivers/pci/probe.c | 5 +++--
 include/linux/pci.h | 1 +
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1f8106ec70945..d1631109b1422 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -31,6 +31,7 @@
 #include <linux/vmalloc.h>
 #include <asm/dma.h>
 #include <linux/aer.h>
+#include <linux/bitfield.h>
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -4572,13 +4573,10 @@ EXPORT_SYMBOL(pci_wait_for_pending_transaction);
  */
 bool pcie_has_flr(struct pci_dev *dev)
 {
-	u32 cap;
-
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return false;
 
-	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-	return cap & PCI_EXP_DEVCAP_FLR;
+	return FIELD_GET(PCI_EXP_DEVCAP_FLR, dev->devcap) == 1;
 }
 EXPORT_SYMBOL_GPL(pcie_has_flr);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ab106d2a99479..02a75f3b59208 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -19,6 +19,7 @@
 #include <linux/hypervisor.h>
 #include <linux/irqdomain.h>
 #include <linux/pm_runtime.h>
+#include <linux/bitfield.h>
 #include "pci.h"
 
 #define CARDBUS_LATENCY_TIMER	176	/* secondary latency timer */
@@ -1496,8 +1497,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 	pdev->pcie_cap = pos;
 	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
 	pdev->pcie_flags_reg = reg16;
-	pci_read_config_word(pdev, pos + PCI_EXP_DEVCAP, &reg16);
-	pdev->pcie_mpss = reg16 & PCI_EXP_DEVCAP_PAYLOAD;
+	pci_read_config_dword(pdev, pos + PCI_EXP_DEVCAP, &pdev->devcap);
+	pdev->pcie_mpss = FIELD_GET(PCI_EXP_DEVCAP_PAYLOAD, pdev->devcap);
 
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 1e3df93b39ca9..75f29838d25cf 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -333,6 +333,7 @@ struct pci_dev {
 #ifdef CONFIG_PCIEPORTBUS
 	struct rcec_ea	*rcec_ea;	/* RCEC cached endpoint association */
 #endif
+	u32		devcap;		/* PCIe Device Capabilities */
 	u8		pcie_cap;	/* PCIe capability offset */
 	u8		msi_cap;	/* MSI capability offset */
 	u8		msix_cap;	/* MSI-X capability offset */
-- 
2.43.0



