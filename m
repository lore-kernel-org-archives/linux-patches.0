Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2021F373BF3;
	Sat, 12 Sep 2026 08:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200559; cv=none; b=J8Sa1isckXSkfwpmG4kN7jgL9/gycJ+nbop2aqhR3NDfoCAvNA6cBjERi5rbC3YNWbbDa3EZahN+EvGDQQYZQ2/usgOdFCmH77wtEL3DTHhLErKMJX1pIMZTUShbijFjhF2CmH8XKzVEKZlUX0x9fqrr/56CcD4r8KJaXZLBU/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200559; c=relaxed/simple;
	bh=ttEfTb1eeQhvUJib12SPy1rSnnoD1YzKYgp5nBANK6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdoB7SCzexQxvFiicmtgCIGW6/4K4ufBQ2nrQXs4+2Je6emPtBM63wdM8ADi36GJNPnKSr3cHS8NR+sypTpMHk0diODlh/uLePrD+2C6W95Z0tK6b5n+Qy6i8OyK9fjHO8Zuf0aI2GMe7FHVkx5bsQiHhN0eguFO6+AkN7ZSsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+Y3Sk/e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+Y3Sk/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F401F000FF;
	Sat, 12 Sep 2026 08:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200556;
	bh=d5bJD8xa5Qcd5/opVdMaz/HsE5KvSBjxdocGCWxSoeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+Y3Sk/e/D9oVTBxGMWAN6Kmij8qAB/CeU5b2zSOZ+Ie2KwG436dAhNs/64URzSv3
	 +3Oqwpzbr8x6gIHvmvd9CdEvUCDjprwCk9EqgjPSWnoD7HPSJKLU4JxDlmzxSsp5yz
	 Yotlwbe/XTpyP0txZGLKQZvDJSaCXz2ubq+6HAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0777/1815] PCI: dwc: ep: Clear MSI iATU mapping in dw_pcie_ep_cleanup()
Date: Sat, 12 Sep 2026 08:42:07 +0200
Message-ID: <20260912065707.149570548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 36637958726a4bbc630c0848eb3eb07cbfae89c2 ]

The MSI iATU mapping is currently only cleared when the endpoint is
stopped via configfs or when the host updates the MSI address/size.
This avoids redundant iATU reconfiguration every time the endpoint
raises an MSI interrupt.

However, a fundamental reset triggered by PERST# assert/deassert
resets all iATU inbound/outbound registers without going through the
configfs stop path. If the host also retains the same MSI address/size
after PERST# deassert, the driver never clears the stale MSI iATU
mapping. It then continues using this stale mapping to raise the MSI
interrupts, which can cause IOMMU faults and MSI failures on the host.

Fix this by clearing the MSI iATU mapping inside dw_pcie_ep_cleanup(),
which is already called as part of the PERST# assert/deassert sequence.
This unmaps the MSI iATU region and sets the msi_iatu_mapped flag to
false, ensuring that dw_pcie_ep_raise_msi_irq() performs a fresh iATU
mapping on its next invocation, regardless of whether the host changed
the MSI address/size.

Fixes: 8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260729-pci-port-reset-v9-1-53570b92064d@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 7d2794945704e..31402ae218c79 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -1153,6 +1153,11 @@ void dw_pcie_ep_cleanup(struct dw_pcie_ep *ep)
 {
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 
+	if (ep->msi_iatu_mapped) {
+		dw_pcie_ep_unmap_addr(ep->epc, 0, 0, ep->msi_mem_phys);
+		ep->msi_iatu_mapped = false;
+	}
+
 	dwc_pcie_debugfs_deinit(pci);
 	dw_pcie_edma_remove(pci);
 }
-- 
2.53.0



