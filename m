Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B518B0A;
	Wed, 25 Feb 2026 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983257; cv=none; b=lFa896ghiMI+SZseH+Jac8PArHzglI1rKZHeX9YYBED+j3P8f37yF2AloBUFG4OXotrds6uzaUchO5FLfSwC6QiMg35sUym77q4GGR4IJoXbAP5fHhoCMCB4lJ832RWbnL4PkZF/nZBDEvcdKbnUhFRiGVpQtM6cL2KBPrl5VA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983257; c=relaxed/simple;
	bh=3k3j0eYImRl0xyXieE3ldUnnN6elvs4fY6eraqdpIWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKF6FOVW+aYEHrgGUxLwsxKYg9rZ8mp0bKcizLqsEz1PB2NC/urGmTDolnLat1jTUGWMjPp0aZdyfFfUd1AIvy+cz5Ogfy97UZE8rSnzYAgTOU7OfAdVNl9M+0aUTl8Zph63wpExir5Nvr8aomlQeWbnp0bo/7ApQVb/WA58fiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xhssv0AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xhssv0AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424B7C116D0;
	Wed, 25 Feb 2026 01:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983257;
	bh=3k3j0eYImRl0xyXieE3ldUnnN6elvs4fY6eraqdpIWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xhssv0ATCnPYb4tsMmv6cPIGGoiPko5c66eoeQKzul0V6qPMNHLpZcUXoQIxb40li
	 Xxw3WeEo2o5G4FqkrpbXfvtfzyVWLyYT6mmKnA7WYp7xpJcM1brwrby8+riQ0WRC52
	 ENrpy5oR6Ef3wb2+M49Ct1dntN9a+Zna2GYcDgyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenbin Yao <wenbin.yao@oss.qualcomm.com>,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 391/781] PCI: dwc: Add new APIs to remove standard and extended Capability
Date: Tue, 24 Feb 2026 17:18:20 -0800
Message-ID: <20260225012409.287893256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <qiang.yu@oss.qualcomm.com>

[ Upstream commit 0183562f1e824c0ca6c918309a0978e9a269af3e ]

On some platforms, certain PCIe Capabilities may be present in hardware
but are not fully implemented as defined in PCIe spec. These incomplete
capabilities should be hidden from the PCI framework to prevent unexpected
behavior.

Introduce two APIs to remove a specific PCIe Capability and Extended
Capability by updating the previous capability's next offset field to skip
over the unwanted capability. These APIs allow RC drivers to easily hide
unsupported or partially implemented capabilities from software.

Co-developed-by: Wenbin Yao <wenbin.yao@oss.qualcomm.com>
Signed-off-by: Wenbin Yao <wenbin.yao@oss.qualcomm.com>
Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251109-remove_cap-v1-2-2208f46f4dc2@oss.qualcomm.com
Stable-dep-of: 72cb5ed2a5c6 ("PCI: dwc: ep: Add per-PF BAR and inbound ATU mapping support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 53 ++++++++++++++++++++
 drivers/pci/controller/dwc/pcie-designware.h |  2 +
 2 files changed, 55 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 5d7a7e6f5724e..345365ea97c74 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -236,6 +236,59 @@ u16 dw_pcie_find_ext_capability(struct dw_pcie *pci, u8 cap)
 }
 EXPORT_SYMBOL_GPL(dw_pcie_find_ext_capability);
 
+void dw_pcie_remove_capability(struct dw_pcie *pci, u8 cap)
+{
+	u8 cap_pos, pre_pos, next_pos;
+	u16 reg;
+
+	cap_pos = PCI_FIND_NEXT_CAP(dw_pcie_read_cfg, PCI_CAPABILITY_LIST, cap,
+				 &pre_pos, pci);
+	if (!cap_pos)
+		return;
+
+	reg = dw_pcie_readw_dbi(pci, cap_pos);
+	next_pos = (reg & 0xff00) >> 8;
+
+	dw_pcie_dbi_ro_wr_en(pci);
+	if (pre_pos == PCI_CAPABILITY_LIST)
+		dw_pcie_writeb_dbi(pci, PCI_CAPABILITY_LIST, next_pos);
+	else
+		dw_pcie_writeb_dbi(pci, pre_pos + 1, next_pos);
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+EXPORT_SYMBOL_GPL(dw_pcie_remove_capability);
+
+void dw_pcie_remove_ext_capability(struct dw_pcie *pci, u8 cap)
+{
+	int cap_pos, next_pos, pre_pos;
+	u32 pre_header, header;
+
+	cap_pos = PCI_FIND_NEXT_EXT_CAP(dw_pcie_read_cfg, 0, cap, &pre_pos, pci);
+	if (!cap_pos)
+		return;
+
+	header = dw_pcie_readl_dbi(pci, cap_pos);
+	/*
+	 * If the first cap at offset PCI_CFG_SPACE_SIZE is removed,
+	 * only set it's capid to zero as it cannot be skipped.
+	 */
+	if (cap_pos == PCI_CFG_SPACE_SIZE) {
+		dw_pcie_dbi_ro_wr_en(pci);
+		dw_pcie_writel_dbi(pci, cap_pos, header & 0xffff0000);
+		dw_pcie_dbi_ro_wr_dis(pci);
+		return;
+	}
+
+	pre_header = dw_pcie_readl_dbi(pci, pre_pos);
+	next_pos = PCI_EXT_CAP_NEXT(header);
+
+	dw_pcie_dbi_ro_wr_en(pci);
+	dw_pcie_writel_dbi(pci, pre_pos,
+			  (pre_header & 0xfffff) | (next_pos << 20));
+	dw_pcie_dbi_ro_wr_dis(pci);
+}
+EXPORT_SYMBOL_GPL(dw_pcie_remove_ext_capability);
+
 static u16 __dw_pcie_find_vsec_capability(struct dw_pcie *pci, u16 vendor_id,
 					  u16 vsec_id)
 {
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 31685951a0804..aec4af5194b51 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -562,6 +562,8 @@ void dw_pcie_version_detect(struct dw_pcie *pci);
 
 u8 dw_pcie_find_capability(struct dw_pcie *pci, u8 cap);
 u16 dw_pcie_find_ext_capability(struct dw_pcie *pci, u8 cap);
+void dw_pcie_remove_capability(struct dw_pcie *pci, u8 cap);
+void dw_pcie_remove_ext_capability(struct dw_pcie *pci, u8 cap);
 u16 dw_pcie_find_rasdes_capability(struct dw_pcie *pci);
 u16 dw_pcie_find_ptm_capability(struct dw_pcie *pci);
 
-- 
2.51.0



