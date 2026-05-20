Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F2C36A376;
	Wed, 20 May 2026 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295033; cv=none; b=FKh53RCSd5j9ICpNIQEHs9UGvq+9ZCIiKWamAbBrUjxaxuZBeYB3E7zZ4v0SJEati34TAOEjEuZhzO585ylsmrbF8XSSlpG+XHs/RkCKFjPdIJhHn9fkArySO0RIHT1nKLMHZ//3S0Ti9NQ0JD0sI1+EuofSOZ9JDiwlNZElr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295033; c=relaxed/simple;
	bh=vJcaWHcJCTMd267gAhXNsWk93mLnmZl5o51J28GXTAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8oRfp/v40fXDE5vVCjQe/AkWcXGkXyZywcNPZUpZhQLb6YYs7SGe3ltpw1rru0OeSnEqOry1aALYWeMSvYc4vzSYic7ZxoiAHHGi5EBtnTC+Zx7n5CqgeJ0dyEFvwx1k5L8cE3MoAROqS4xnLv9I6VGy1j0F0/SXxhR9mB8lN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWM8NzS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWM8NzS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A2B1F000E9;
	Wed, 20 May 2026 16:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295032;
	bh=19rwA/3f5jAO+VMXVUhRDr2U/Z6c3imldCsBAkh1U94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWM8NzS13mEPlt5d39QOa6kM4Xy5FSUSjpEedkUd+E7EKwXQMZLk5f7UM2qIMKmAk
	 kjdXjuCBztpFvCek0vexiXr9kHX2idtv/Fqt3JRhGj8JJ+3cb9zme7IEI5V+YInmIQ
	 bUc8brZphMjuyEVBRDIq/idGDn3UQAHtdWPlkwuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0266/1146] PCI: dwc: ep: Mirror the max link width and speed fields to all functions
Date: Wed, 20 May 2026 18:08:36 +0200
Message-ID: <20260520162154.245640046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 94cbea0f636b55602a9a10583670976680ecea67 ]

PCIe r7.0, section 7.5.3.6 states that for multi-function devices, the
Max Link Width and Max Link Speed fields in the Link Capabilities
Register must report the same values for all functions.

Currently, dw_pcie_setup() programs these fields only for Function 0
via dw_pcie_link_set_max_speed() and dw_pcie_link_set_max_link_width().
For multi-function endpoint configurations, Function 1 and beyond retain
their default values, violating the PCIe specification.

Fix this by reading the Max Link Width and Max Link Speed fields from
Link Capabilities Register of Function 0 after dw_pcie_setup() completes,
then mirroring these values to all other functions.

Fixes: 24ede430fa49 ("PCI: designware-ep: Add multiple PFs support for DWC")
Fixes: 89db0793c9f2 ("PCI: dwc: Add missing PCI_EXP_LNKCAP_MLW handling")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
[mani: renamed ref_lnkcap to func0_lnkcap]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260224083817.916782-3-a-garg7@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 10d6f53cf7bad..ab2e7de5c55eb 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -1110,7 +1110,8 @@ static void dw_pcie_ep_init_non_sticky_registers(struct dw_pcie *pci)
 {
 	struct dw_pcie_ep *ep = &pci->ep;
 	u8 funcs = ep->epc->max_functions;
-	u8 func_no;
+	u32 func0_lnkcap, lnkcap;
+	u8 func_no, offset;
 
 	dw_pcie_dbi_ro_wr_en(pci);
 
@@ -1118,6 +1119,32 @@ static void dw_pcie_ep_init_non_sticky_registers(struct dw_pcie *pci)
 		dw_pcie_ep_init_rebar_registers(ep, func_no);
 
 	dw_pcie_setup(pci);
+
+	/*
+	 * PCIe r7.0, section 7.5.3.6 states that for multi-function
+	 * endpoints, max link width and speed fields must report same
+	 * values for all functions. However, dw_pcie_setup() programs
+	 * these fields only for function 0. Hence, mirror these fields
+	 * to all other functions as well.
+	 */
+	if (funcs > 1) {
+		offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+		func0_lnkcap = dw_pcie_readl_dbi(pci, offset + PCI_EXP_LNKCAP);
+		func0_lnkcap = FIELD_GET(PCI_EXP_LNKCAP_MLW |
+					 PCI_EXP_LNKCAP_SLS, func0_lnkcap);
+
+		for (func_no = 1; func_no < funcs; func_no++) {
+			offset = dw_pcie_ep_find_capability(ep, func_no,
+							    PCI_CAP_ID_EXP);
+			lnkcap = dw_pcie_ep_readl_dbi(ep, func_no,
+						      offset + PCI_EXP_LNKCAP);
+			FIELD_MODIFY(PCI_EXP_LNKCAP_MLW | PCI_EXP_LNKCAP_SLS,
+				     &lnkcap, func0_lnkcap);
+			dw_pcie_ep_writel_dbi(ep, func_no,
+					      offset + PCI_EXP_LNKCAP, lnkcap);
+		}
+	}
+
 	dw_pcie_dbi_ro_wr_dis(pci);
 }
 
-- 
2.53.0



