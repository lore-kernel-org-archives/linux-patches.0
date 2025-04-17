Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1309D254878;
	Thu, 17 Apr 2025 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915518; cv=none; b=Cm6oPXFLTiPHF3Z688L42rrHfygnYsQm3Lb5b8Mb8V1kio0ZVi3fgnI9cUGeqNHqrUUPplFGTfpUjW6H1XhsuiedO7qO/tTCZxy035AmaYFwIBcYFt+e3OvGoA+LcprIYMbpJOYOQcP09KgMC7ZY3gXDNnPjHa4e/40HMbb6f2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915518; c=relaxed/simple;
	bh=PDFy2WYG0Fd9xTgVRK0tdXMzbi8WDzi1XaUcltXwnW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jdrc+uagm4HeFbZYh3QK+IqCX5aMNCXrG+IGZH1QIfKzdOxCqEFqex65RxwA+kk9WLbgKjV3PCQAiNCfGg5lfMfBr0gjKPzruPqooynAXTRgZlrq5jvATUZVCbu5Kc5HUIP3d1oYJMUGVdRuyHPAOMeUpDKJLbJkdQiGSApw9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIgHZ1II; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIgHZ1II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01186C4CEEA;
	Thu, 17 Apr 2025 18:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915517;
	bh=PDFy2WYG0Fd9xTgVRK0tdXMzbi8WDzi1XaUcltXwnW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIgHZ1II3yB8F2tgy7EGVXrTxf18Qgl5QcZ7UmL+9VokvulucuUdAYTzIjO2IIV8X
	 eUbnEc0Lc+XCWFtSyG28vzQ28nWsSJAzKG5esxvTqukWk0vbM2Lu//q4Ee8HNyqJKv
	 6OmLklE5QD/55feDsR2B7ngzV9/W5wzh07FEGXbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@linux.intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/393] PCI: Check BAR index for validity
Date: Thu, 17 Apr 2025 19:49:20 +0200
Message-ID: <20250417175113.656195541@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit b1a7f99967fc0c052db8e65b449c7b32b1e9177f ]

Many functions in PCI use accessor macros such as pci_resource_len(),
which take a BAR index. That index, however, is never checked for
validity, potentially resulting in undefined behavior by overflowing the
array pci_dev.resource in the macro pci_resource_n().

Since many users of those macros directly assign the accessed value to
an unsigned integer, the macros cannot be changed easily anymore to
return -EINVAL for invalid indexes. Consequently, the problem has to be
mitigated in higher layers.

Add pci_bar_index_valid(). Use it where appropriate.

Link: https://lore.kernel.org/r/20250312080634.13731-4-phasta@kernel.org
Closes: https://lore.kernel.org/all/adb53b1f-29e1-3d14-0e61-351fd2d3ff0d@linux.intel.com/
Reported-by: Bingbu Cao <bingbu.cao@linux.intel.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
[kwilczynski: correct if-statement condition the pci_bar_index_is_valid()
helper function uses, tidy up code comments]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
[bhelgaas: fix typo]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/devres.c | 16 ++++++++++++++--
 drivers/pci/iomap.c  | 29 +++++++++++++++++++++--------
 drivers/pci/pci.c    |  6 ++++++
 drivers/pci/pci.h    | 16 ++++++++++++++++
 4 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index 643f85849ef64..cd39479de7c72 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -577,7 +577,7 @@ static int pcim_add_mapping_to_legacy_table(struct pci_dev *pdev,
 {
 	void __iomem **legacy_iomap_table;
 
-	if (bar >= PCI_STD_NUM_BARS)
+	if (!pci_bar_index_is_valid(bar))
 		return -EINVAL;
 
 	legacy_iomap_table = (void __iomem **)pcim_iomap_table(pdev);
@@ -622,7 +622,7 @@ static void pcim_remove_bar_from_legacy_table(struct pci_dev *pdev, int bar)
 {
 	void __iomem **legacy_iomap_table;
 
-	if (bar >= PCI_STD_NUM_BARS)
+	if (!pci_bar_index_is_valid(bar))
 		return;
 
 	legacy_iomap_table = (void __iomem **)pcim_iomap_table(pdev);
@@ -655,6 +655,9 @@ void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen)
 	void __iomem *mapping;
 	struct pcim_addr_devres *res;
 
+	if (!pci_bar_index_is_valid(bar))
+		return NULL;
+
 	res = pcim_addr_devres_alloc(pdev);
 	if (!res)
 		return NULL;
@@ -722,6 +725,9 @@ void __iomem *pcim_iomap_region(struct pci_dev *pdev, int bar,
 	int ret;
 	struct pcim_addr_devres *res;
 
+	if (!pci_bar_index_is_valid(bar))
+		return IOMEM_ERR_PTR(-EINVAL);
+
 	res = pcim_addr_devres_alloc(pdev);
 	if (!res)
 		return IOMEM_ERR_PTR(-ENOMEM);
@@ -822,6 +828,9 @@ static int _pcim_request_region(struct pci_dev *pdev, int bar, const char *name,
 	int ret;
 	struct pcim_addr_devres *res;
 
+	if (!pci_bar_index_is_valid(bar))
+		return -EINVAL;
+
 	res = pcim_addr_devres_alloc(pdev);
 	if (!res)
 		return -ENOMEM;
@@ -1043,6 +1052,9 @@ void __iomem *pcim_iomap_range(struct pci_dev *pdev, int bar,
 	void __iomem *mapping;
 	struct pcim_addr_devres *res;
 
+	if (!pci_bar_index_is_valid(bar))
+		return IOMEM_ERR_PTR(-EINVAL);
+
 	res = pcim_addr_devres_alloc(pdev);
 	if (!res)
 		return IOMEM_ERR_PTR(-ENOMEM);
diff --git a/drivers/pci/iomap.c b/drivers/pci/iomap.c
index 9fb7cacc15cde..fe706ed946dfd 100644
--- a/drivers/pci/iomap.c
+++ b/drivers/pci/iomap.c
@@ -9,6 +9,8 @@
 
 #include <linux/export.h>
 
+#include "pci.h" /* for pci_bar_index_is_valid() */
+
 /**
  * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
  * @dev: PCI device that owns the BAR
@@ -33,12 +35,19 @@ void __iomem *pci_iomap_range(struct pci_dev *dev,
 			      unsigned long offset,
 			      unsigned long maxlen)
 {
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
+	resource_size_t start, len;
+	unsigned long flags;
+
+	if (!pci_bar_index_is_valid(bar))
+		return NULL;
+
+	start = pci_resource_start(dev, bar);
+	len = pci_resource_len(dev, bar);
+	flags = pci_resource_flags(dev, bar);
 
 	if (len <= offset || !start)
 		return NULL;
+
 	len -= offset;
 	start += offset;
 	if (maxlen && len > maxlen)
@@ -77,16 +86,20 @@ void __iomem *pci_iomap_wc_range(struct pci_dev *dev,
 				 unsigned long offset,
 				 unsigned long maxlen)
 {
-	resource_size_t start = pci_resource_start(dev, bar);
-	resource_size_t len = pci_resource_len(dev, bar);
-	unsigned long flags = pci_resource_flags(dev, bar);
+	resource_size_t start, len;
+	unsigned long flags;
 
-
-	if (flags & IORESOURCE_IO)
+	if (!pci_bar_index_is_valid(bar))
 		return NULL;
 
+	start = pci_resource_start(dev, bar);
+	len = pci_resource_len(dev, bar);
+	flags = pci_resource_flags(dev, bar);
+
 	if (len <= offset || !start)
 		return NULL;
+	if (flags & IORESOURCE_IO)
+		return NULL;
 
 	len -= offset;
 	start += offset;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 169aa8fd74a11..be61fa93d3971 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3922,6 +3922,9 @@ EXPORT_SYMBOL(pci_enable_atomic_ops_to_root);
  */
 void pci_release_region(struct pci_dev *pdev, int bar)
 {
+	if (!pci_bar_index_is_valid(bar))
+		return;
+
 	/*
 	 * This is done for backwards compatibility, because the old PCI devres
 	 * API had a mode in which the function became managed if it had been
@@ -3967,6 +3970,9 @@ EXPORT_SYMBOL(pci_release_region);
 static int __pci_request_region(struct pci_dev *pdev, int bar,
 				const char *res_name, int exclusive)
 {
+	if (!pci_bar_index_is_valid(bar))
+		return -EINVAL;
+
 	if (pci_is_managed(pdev)) {
 		if (exclusive == IORESOURCE_EXCLUSIVE)
 			return pcim_request_region_exclusive(pdev, bar, res_name);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1cdc2c9547a7e..65df6d2ac0032 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -165,6 +165,22 @@ static inline void pci_wakeup_event(struct pci_dev *dev)
 	pm_wakeup_event(&dev->dev, 100);
 }
 
+/**
+ * pci_bar_index_is_valid - Check whether a BAR index is within valid range
+ * @bar: BAR index
+ *
+ * Protects against overflowing &struct pci_dev.resource array.
+ *
+ * Return: true for valid index, false otherwise.
+ */
+static inline bool pci_bar_index_is_valid(int bar)
+{
+	if (bar >= 0 && bar < PCI_NUM_RESOURCES)
+		return true;
+
+	return false;
+}
+
 static inline bool pci_has_subordinate(struct pci_dev *pci_dev)
 {
 	return !!(pci_dev->subordinate);
-- 
2.39.5



