Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C9B18DB2A;
	Wed, 25 Feb 2026 01:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983269; cv=none; b=nLJjHAEtcwJXtQdHcuVzoFvMySb0KKkfZfDSyIXcfeNRmJxniKLgxQOTKkr5O5kX2QkBBUgfhzTK+1avW/a9dGhF6TxrWcHjz1DDd5N3iVCAGqcRGIK3ZSxADRua/RfErtnwQ+eY6jAkr5k3Kg18hgKKn56f9M88yZTRy+cjIa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983269; c=relaxed/simple;
	bh=nRvxRFONJGF455313GBLGA8zR7MnUN3oTLIs2OaeRuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlnJBS2sD1tWvenAluy7F1IlNDc+4GN81F7XGtpCCqUCJwr4fmnbJh2EdVAmz5my6kDX2ul33Hcq1GvsDD6iWGIid2kZ1CJrQSqrcCl9TAVvS5JhVx63cuiZMWY/IXMK9/fRVvalntfixHxu5A4mxPn3v//MX7+Q9QquMTfcrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqyKvb1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqyKvb1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37C3C116D0;
	Wed, 25 Feb 2026 01:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983269;
	bh=nRvxRFONJGF455313GBLGA8zR7MnUN3oTLIs2OaeRuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqyKvb1O1PuJItYwQHZQ4MsbOf/SRS73P2xOVhjAk8sF0kdxizDnOVng6nML2DULP
	 EYY1MT+vt9NeU+T3hB7rs89EdQu66E08gEO+Uxa2O81khIxL6yTmh7MKEvUs/ImKA6
	 jUQIz8wD+P4Nt0uAb4LJLC4Lg0TtkS0Ms6J7D7g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 392/781] PCI: dwc: ep: Cache MSI outbound iATU mapping
Date: Tue, 24 Feb 2026 17:18:21 -0800
Message-ID: <20260225012409.314839089@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 8719c64e76bf258cc8f44109740c854f2e2ead2e ]

dw_pcie_ep_raise_msi_irq() currently programs an outbound iATU window
for the MSI target address on every interrupt and tears it down again
via dw_pcie_ep_unmap_addr().

On systems that heavily use the AXI bridge interface (for example when
the integrated eDMA engine is active), this means the outbound iATU
registers are updated while traffic is in flight. The DesignWare
endpoint databook 5.40a - "3.10.6.1 iATU Outbound Programming Overview"
warns that updating iATU registers in this situation is not supported,
and the behavior is undefined.

Under high MSI and eDMA load this pattern results in occasional bogus
outbound transactions and IOMMU faults, on the RC side, such as:

  ipmmu-vmsa eed40000.iommu: Unhandled fault: status 0x00001502 iova 0xfe000000

followed by the system becoming unresponsive. This is the actual output
observed on Renesas R-Car S4, with its ipmmu_hc used with PCIe ch0.

There is no need to reprogram the iATU region used for MSI on every
interrupt. The host-provided MSI address is stable while MSI is enabled,
and the endpoint driver already dedicates a scratch buffer for MSI
generation.

Cache the aligned MSI address and map size, program the outbound iATU
once, and keep the window enabled. Subsequent interrupts only perform a
write to the MSI scratch buffer, avoiding dynamic iATU reprogramming in
the hot path and fixing the lockups seen under load.

dw_pcie_ep_raise_msix_irq() is not modified, as each vector can have a
different msg_addr, and because the msg_addr is allowed to be changed
while the vector is masked. Neither problem is easy to solve with the
current design. Instead, the plan is for the DWC vendor drivers to
transition to dw_pcie_ep_raise_msix_irq_doorbell(), which does not rely
on the iATU.

Signed-off-by: Koichiro Den <den@valinux.co.jp>
[cassel: improve commit message]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251222110144.3299523-2-cassel@kernel.org
Stable-dep-of: 72cb5ed2a5c6 ("PCI: dwc: ep: Add per-PF BAR and inbound ATU mapping support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pci/controller/dwc/pcie-designware-ep.c   | 48 ++++++++++++++++---
 drivers/pci/controller/dwc/pcie-designware.h  |  5 ++
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index f6c54625486e2..1195d401df19e 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -601,6 +601,16 @@ static void dw_pcie_ep_stop(struct pci_epc *epc)
 	struct dw_pcie_ep *ep = epc_get_drvdata(epc);
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
+	/*
+	 * Tear down the dedicated outbound window used for MSI
+	 * generation. This avoids leaking an iATU window across
+	 * endpoint stop/start cycles.
+	 */
+	if (ep->msi_iatu_mapped) {
+		dw_pcie_ep_unmap_addr(epc, 0, 0, ep->msi_mem_phys);
+		ep->msi_iatu_mapped = false;
+	}
+
 	dw_pcie_stop_link(pci);
 }
 
@@ -702,14 +712,37 @@ int dw_pcie_ep_raise_msi_irq(struct dw_pcie_ep *ep, u8 func_no,
 	msg_addr = ((u64)msg_addr_upper) << 32 | msg_addr_lower;
 
 	msg_addr = dw_pcie_ep_align_addr(epc, msg_addr, &map_size, &offset);
-	ret = dw_pcie_ep_map_addr(epc, func_no, 0, ep->msi_mem_phys, msg_addr,
-				  map_size);
-	if (ret)
-		return ret;
 
-	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
+	/*
+	 * Program the outbound iATU once and keep it enabled.
+	 *
+	 * The spec warns that updating iATU registers while there are
+	 * operations in flight on the AXI bridge interface is not
+	 * supported, so we avoid reprogramming the region on every MSI,
+	 * specifically unmapping immediately after writel().
+	 */
+	if (!ep->msi_iatu_mapped) {
+		ret = dw_pcie_ep_map_addr(epc, func_no, 0,
+					  ep->msi_mem_phys, msg_addr,
+					  map_size);
+		if (ret)
+			return ret;
+
+		ep->msi_iatu_mapped = true;
+		ep->msi_msg_addr = msg_addr;
+		ep->msi_map_size = map_size;
+	} else if (WARN_ON_ONCE(ep->msi_msg_addr != msg_addr ||
+				ep->msi_map_size != map_size)) {
+		/*
+		 * The host changed the MSI target address or the required
+		 * mapping size changed. Reprogramming the iATU at runtime is
+		 * unsafe on this controller, so bail out instead of trying to
+		 * update the existing region.
+		 */
+		return -EINVAL;
+	}
 
-	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
+	writel(msg_data | (interrupt_num - 1), ep->msi_mem + offset);
 
 	return 0;
 }
@@ -1087,6 +1120,9 @@ int dw_pcie_ep_init(struct dw_pcie_ep *ep)
 	struct device *dev = pci->dev;
 
 	INIT_LIST_HEAD(&ep->func_list);
+	ep->msi_iatu_mapped = false;
+	ep->msi_msg_addr = 0;
+	ep->msi_map_size = 0;
 
 	epc = devm_pci_epc_create(dev, &epc_ops);
 	if (IS_ERR(epc)) {
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index aec4af5194b51..f9e2eaa3571e0 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -479,6 +479,11 @@ struct dw_pcie_ep {
 	void __iomem		*msi_mem;
 	phys_addr_t		msi_mem_phys;
 	struct pci_epf_bar	*epf_bar[PCI_STD_NUM_BARS];
+
+	/* MSI outbound iATU state */
+	bool			msi_iatu_mapped;
+	u64			msi_msg_addr;
+	size_t			msi_map_size;
 };
 
 struct dw_pcie_ops {
-- 
2.51.0



