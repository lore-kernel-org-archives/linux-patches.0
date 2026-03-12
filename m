Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2653FF8AD;
	Thu, 12 Mar 2026 20:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346355; cv=none; b=g2lSF9alvh8ATOg0N9S47z/nLc96paFvlIFOxN6gGmdNzPsCmD0qKqC091mlU3MIuRkT8beKIBk3Ly8ptrWPa2JcFxdYYtes86Lg+vM23XSpkQu707yOsEnmDELL4fJnFKV6M/V3GHlbepdKcrTHxyPhS6IMw0Alrz6MDW98dpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346355; c=relaxed/simple;
	bh=4LxPhUpKxtSnJcHd2o8npL/aVvAfrrwNmhZkBzMHS/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1PvuZrCdqxEcfTNXfZEDJl1Wftyv0pec0RFbBfBP5LoCq4doxRfnRJrjs0XFzcos/0iy0bXflgVCVWM4fYftEWXl95GP7BrGtKPcXCx0slWBR3pskjaeMXiOnsMQLusA/ERKb7L7wauswu4YSTTpl+ij6hca0hHh20kBKhs+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xON43ISf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xON43ISf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89532C4CEF7;
	Thu, 12 Mar 2026 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346355;
	bh=4LxPhUpKxtSnJcHd2o8npL/aVvAfrrwNmhZkBzMHS/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xON43ISfpmc+ZQN1MR7oTD2RytHknhhuNy85eXlIqj+MTh3+BM8+/XcME8RVEnHAt
	 n66ONeoRgynx14BATyDHKYlsKGFCyGNWI2BuD2NOPhLiv2w0Z4lEDDi83h6YSZfW9Y
	 yfKzPSXLnS+yx5AOed8aGq5vYtyQ5gN8PCgUodc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/265] PCI: endpoint: Introduce pci_epc_function_is_valid()
Date: Thu, 12 Mar 2026 21:06:50 +0100
Message-ID: <20260312201019.019485599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ca3c342fb3c76eee739a1cfc4ff59841722ebee7 ]

Introduce the epc core helper function pci_epc_function_is_valid() to
verify that an epc pointer, a physical function number and a virtual
function number are all valid. This avoids repeating the code pattern:

if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
	return err;

if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
	return err;

in many functions of the endpoint controller core code.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20241012113246.95634-2-dlemoal@kernel.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c22533c66cca ("PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-epc-core.c | 79 +++++++++++------------------
 1 file changed, 31 insertions(+), 48 deletions(-)

diff --git a/drivers/pci/endpoint/pci-epc-core.c b/drivers/pci/endpoint/pci-epc-core.c
index de665342dc16d..66c7434a63153 100644
--- a/drivers/pci/endpoint/pci-epc-core.c
+++ b/drivers/pci/endpoint/pci-epc-core.c
@@ -128,6 +128,18 @@ enum pci_barno pci_epc_get_next_free_bar(const struct pci_epc_features
 }
 EXPORT_SYMBOL_GPL(pci_epc_get_next_free_bar);
 
+static bool pci_epc_function_is_valid(struct pci_epc *epc,
+				      u8 func_no, u8 vfunc_no)
+{
+	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
+		return false;
+
+	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+		return false;
+
+	return true;
+}
+
 /**
  * pci_epc_get_features() - get the features supported by EPC
  * @epc: the features supported by *this* EPC device will be returned
@@ -145,10 +157,7 @@ const struct pci_epc_features *pci_epc_get_features(struct pci_epc *epc,
 {
 	const struct pci_epc_features *epc_features;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return NULL;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return NULL;
 
 	if (!epc->ops->get_features)
@@ -218,10 +227,7 @@ int pci_epc_raise_irq(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return -EINVAL;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
 	if (!epc->ops->raise_irq)
@@ -262,10 +268,7 @@ int pci_epc_map_msi_irq(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(epc))
-		return -EINVAL;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
 	if (!epc->ops->map_msi_irq)
@@ -293,10 +296,7 @@ int pci_epc_get_msi(struct pci_epc *epc, u8 func_no, u8 vfunc_no)
 {
 	int interrupt;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return 0;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return 0;
 
 	if (!epc->ops->get_msi)
@@ -329,11 +329,10 @@ int pci_epc_set_msi(struct pci_epc *epc, u8 func_no, u8 vfunc_no, u8 interrupts)
 	int ret;
 	u8 encode_int;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions ||
-	    interrupts < 1 || interrupts > 32)
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (interrupts < 1 || interrupts > 32)
 		return -EINVAL;
 
 	if (!epc->ops->set_msi)
@@ -361,10 +360,7 @@ int pci_epc_get_msix(struct pci_epc *epc, u8 func_no, u8 vfunc_no)
 {
 	int interrupt;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return 0;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return 0;
 
 	if (!epc->ops->get_msix)
@@ -397,11 +393,10 @@ int pci_epc_set_msix(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions ||
-	    interrupts < 1 || interrupts > 2048)
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (interrupts < 1 || interrupts > 2048)
 		return -EINVAL;
 
 	if (!epc->ops->set_msix)
@@ -428,10 +423,7 @@ EXPORT_SYMBOL_GPL(pci_epc_set_msix);
 void pci_epc_unmap_addr(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 			phys_addr_t phys_addr)
 {
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return;
 
 	if (!epc->ops->unmap_addr)
@@ -459,10 +451,7 @@ int pci_epc_map_addr(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return -EINVAL;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
 	if (!epc->ops->map_addr)
@@ -489,12 +478,11 @@ EXPORT_SYMBOL_GPL(pci_epc_map_addr);
 void pci_epc_clear_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 		       struct pci_epf_bar *epf_bar)
 {
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions ||
-	    (epf_bar->barno == BAR_5 &&
-	     epf_bar->flags & PCI_BASE_ADDRESS_MEM_TYPE_64))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return;
 
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (epf_bar->barno == BAR_5 &&
+	    epf_bar->flags & PCI_BASE_ADDRESS_MEM_TYPE_64)
 		return;
 
 	if (!epc->ops->clear_bar)
@@ -521,18 +509,16 @@ int pci_epc_set_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	int ret;
 	int flags = epf_bar->flags;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions ||
-	    (epf_bar->barno == BAR_5 &&
-	     flags & PCI_BASE_ADDRESS_MEM_TYPE_64) ||
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
+		return -EINVAL;
+
+	if ((epf_bar->barno == BAR_5 && flags & PCI_BASE_ADDRESS_MEM_TYPE_64) ||
 	    (flags & PCI_BASE_ADDRESS_SPACE_IO &&
 	     flags & PCI_BASE_ADDRESS_IO_MASK) ||
 	    (upper_32_bits(epf_bar->size) &&
 	     !(flags & PCI_BASE_ADDRESS_MEM_TYPE_64)))
 		return -EINVAL;
 
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
-		return -EINVAL;
-
 	if (!epc->ops->set_bar)
 		return 0;
 
@@ -561,10 +547,7 @@ int pci_epc_write_header(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(epc) || func_no >= epc->max_functions)
-		return -EINVAL;
-
-	if (vfunc_no > 0 && (!epc->max_vfs || vfunc_no > epc->max_vfs[func_no]))
+	if (!pci_epc_function_is_valid(epc, func_no, vfunc_no))
 		return -EINVAL;
 
 	/* Only Virtual Function #1 has deviceID */
-- 
2.51.0



