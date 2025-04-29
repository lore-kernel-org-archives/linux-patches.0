Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4768E2472BC;
	Tue, 29 Apr 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947558; cv=none; b=RLcgtUa5xD4v3lWa4Glm3Iqcj/jOJCOYyx0dZD8Wkx/rD/CZ+iMaUxwN93VcwJOnJcKFB3bJHaLTmzTFgh+B3e3VbmncNvTWQQPYk5aVBGP8nZNo5mjImy2PmOPm0bdRLZS5Y0DHyp0c2blizU9MBqzsKeERa5oN9lui2QWwwFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947558; c=relaxed/simple;
	bh=rg71rUAoA4FBVMV2DJOCzw7RkWuI9nB+ommm6MLTh1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvPqjfqpwFgh1t93VcqA+kNopFtpVDC2EmZClk5cAfbUAPUAlPmxIVDNronAYyQPXP3IBDyGGMI3b8XjhvLUQ8Qgs7mTulzQgWkDsgqrMcAyltB3eYNJGGCMAQ+WjmBj0zAWt6JFwMulVih6POOUizUCwTATJMqABuTSQX9N6Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJf1Ih1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJf1Ih1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8F4C4CEE3;
	Tue, 29 Apr 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947557;
	bh=rg71rUAoA4FBVMV2DJOCzw7RkWuI9nB+ommm6MLTh1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJf1Ih1bRW+w3I5xN4ZFb+n3WxmfZE7ve7aVQCmB/K/Zo7bYXpy27jIVzxeCfS25D
	 MMNrAqTcLMQI0/YOUXHvZ1mJvIQbFWeACjUnWRcpoaSAWcm9gn6c1dxp8eulSwTtut
	 Udzf7KSbVtVn3nV5Nhq3xdwwhAZO8L1/abZ4M46E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gomez <da.gomez@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Juergen Gross <jgross@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/280] PCI/MSI: Handle the NOMASK flag correctly for all PCI/MSI backends
Date: Tue, 29 Apr 2025 18:39:33 +0200
Message-ID: <20250429161116.436680500@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 3ece3e8e5976c49c3f887e5923f998eabd54ff40 ]

The conversion of the XEN specific global variable pci_msi_ignore_mask to a
MSI domain flag, missed the facts that:

    1) Legacy architectures do not provide a interrupt domain
    2) Parent MSI domains do not necessarily have a domain info attached

Both cases result in an unconditional NULL pointer dereference. This was
unfortunatly missed in review and testing revealed it late.

Cure this by using the existing pci_msi_domain_supports() helper, which
handles all possible cases correctly.

Fixes: c3164d2e0d18 ("PCI/MSI: Convert pci_msi_ignore_mask to per MSI domain flag")
Reported-by: Daniel Gomez <da.gomez@kernel.org>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Borislav Petkov <bp@alien8.de>
Tested-by: Daniel Gomez <da.gomez@kernel.org>
Link: https://lore.kernel.org/all/87iknwyp2o.ffs@tglx
Closes: https://lore.kernel.org/all/qn7fzggcj6qe6r6gdbwcz23pzdz2jx64aldccmsuheabhmjgrt@tawf5nfwuvw7
Stable-dep-of: cf761e3dacc6 ("PCI/MSI: Add an option to write MSIX ENTRY_DATA before any reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi/msi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 4c8c2b57b5f61..6569ba3577fe6 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -285,8 +285,6 @@ static void pci_msi_set_enable(struct pci_dev *dev, int enable)
 static int msi_setup_msi_desc(struct pci_dev *dev, int nvec,
 			      struct irq_affinity_desc *masks)
 {
-	const struct irq_domain *d = dev_get_msi_domain(&dev->dev);
-	const struct msi_domain_info *info = d->host_data;
 	struct msi_desc desc;
 	u16 control;
 
@@ -297,7 +295,7 @@ static int msi_setup_msi_desc(struct pci_dev *dev, int nvec,
 	/* Lies, damned lies, and MSIs */
 	if (dev->dev_flags & PCI_DEV_FLAGS_HAS_MSI_MASKING)
 		control |= PCI_MSI_FLAGS_MASKBIT;
-	if (info->flags & MSI_FLAG_NO_MASK)
+	if (pci_msi_domain_supports(dev, MSI_FLAG_NO_MASK, DENY_LEGACY))
 		control &= ~PCI_MSI_FLAGS_MASKBIT;
 
 	desc.nvec_used			= nvec;
@@ -605,20 +603,18 @@ static void __iomem *msix_map_region(struct pci_dev *dev,
  */
 void msix_prepare_msi_desc(struct pci_dev *dev, struct msi_desc *desc)
 {
-	const struct irq_domain *d = dev_get_msi_domain(&dev->dev);
-	const struct msi_domain_info *info = d->host_data;
-
 	desc->nvec_used				= 1;
 	desc->pci.msi_attrib.is_msix		= 1;
 	desc->pci.msi_attrib.is_64		= 1;
 	desc->pci.msi_attrib.default_irq	= dev->irq;
 	desc->pci.mask_base			= dev->msix_base;
-	desc->pci.msi_attrib.can_mask		= !(info->flags & MSI_FLAG_NO_MASK) &&
-						  !desc->pci.msi_attrib.is_virtual;
 
-	if (desc->pci.msi_attrib.can_mask) {
+
+	if (!pci_msi_domain_supports(dev, MSI_FLAG_NO_MASK, DENY_LEGACY) &&
+	    !desc->pci.msi_attrib.is_virtual) {
 		void __iomem *addr = pci_msix_desc_addr(desc);
 
+		desc->pci.msi_attrib.can_mask = 1;
 		desc->pci.msix_ctrl = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
 	}
 }
@@ -715,8 +711,6 @@ static int msix_setup_interrupts(struct pci_dev *dev, struct msix_entry *entries
 static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 				int nvec, struct irq_affinity *affd)
 {
-	const struct irq_domain *d = dev_get_msi_domain(&dev->dev);
-	const struct msi_domain_info *info = d->host_data;
 	int ret, tsize;
 	u16 control;
 
@@ -747,7 +741,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
 
-	if (!(info->flags & MSI_FLAG_NO_MASK)) {
+	if (!pci_msi_domain_supports(dev, MSI_FLAG_NO_MASK, DENY_LEGACY)) {
 		/*
 		 * Ensure that all table entries are masked to prevent
 		 * stale entries from firing in a crash kernel.
-- 
2.39.5



