Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59C346FB3;
	Thu, 12 Mar 2026 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346371; cv=none; b=NnVkZfAtBcDZVbEU4uP7HJDs84ozzTuMe2DNGHn+4L+ETtqhKyk9pbckK2zaWRxRfvvnz3a1DV89CwJyiFNRLQi66tsA9dyrEkK6A5tJONRLguNakQe235j4LMEN1VZwGcfvg40+XZcfqHcw1DBWP5XDBvh6S/bLQHmQA/D/pFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346371; c=relaxed/simple;
	bh=fqhr6TFsOpgRQVCOE4h/OxfU2/FO9Q/q8xykspKOycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArjlNLLWQznxneOp81loxri8OVNAYdePuQo1Wcw4fmO2dBAiMDaAXirzNkw4AYFwLcid56nq+Bxo8ay21BlYYW7wfuUqvNJJ1hMijcXM3s51DACVnJBDIP4GYtxmgwjgTB9zcBaKgO7YsjVj7fBXYnq/XmBYZqDvVfGxNDGh+wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fpMH+JY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fpMH+JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC98C4CEF7;
	Thu, 12 Mar 2026 20:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346371;
	bh=fqhr6TFsOpgRQVCOE4h/OxfU2/FO9Q/q8xykspKOycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fpMH+JYKzpjeuLVmxw+E22PPrrqJgzOvhwbLYHz8qL46lwgr1AaIPdTarRQxibfc
	 /ihy2hhKWdGs6TBEvWbTrC4c5ZoWaBb6w/HBKE6tkzwZZ9fuWctbVmzhUIXhglMgC3
	 klFhoOF21COeVU07namxK+RsK3+D38D9LnW1j3jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/265] PCI: dwc: ep: Flush MSI-X write before unmapping its ATU entry
Date: Thu, 12 Mar 2026 21:06:54 +0100
Message-ID: <20260312201019.166352855@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c22533c66ccae10511ad6a7afc34bb26c47577e3 ]

Endpoint drivers use dw_pcie_ep_raise_msix_irq() to raise an MSI-X
interrupt to the host using a writel(), which generates a PCI posted write
transaction.  There's no completion for posted writes, so the writel() may
return before the PCI write completes.  dw_pcie_ep_raise_msix_irq() also
unmaps the outbound ATU entry used for the PCI write, so the write races
with the unmap.

If the PCI write loses the race with the ATU unmap, the write may corrupt
host memory or cause IOMMU errors, e.g., these when running fio with a
larger queue depth against nvmet-pci-epf:

  arm-smmu-v3 fc900000.iommu:      0x0000010000000010
  arm-smmu-v3 fc900000.iommu:      0x0000020000000000
  arm-smmu-v3 fc900000.iommu:      0x000000090000f040
  arm-smmu-v3 fc900000.iommu:      0x0000000000000000
  arm-smmu-v3 fc900000.iommu: event: F_TRANSLATION client: 0000:01:00.0 sid: 0x100 ssid: 0x0 iova: 0x90000f040 ipa: 0x0
  arm-smmu-v3 fc900000.iommu: unpriv data write s1 "Input address caused fault" stag: 0x0

Flush the write by performing a readl() of the same address to ensure that
the write has reached the destination before the ATU entry is unmapped.

The same problem was solved for dw_pcie_ep_raise_msi_irq() in commit
8719c64e76bf ("PCI: dwc: ep: Cache MSI outbound iATU mapping"), but there
it was solved by dedicating an outbound iATU only for MSI. We can't do the
same for MSI-X because each vector can have a different msg_addr and the
msg_addr may be changed while the vector is masked.

Fixes: beb4641a787d ("PCI: dwc: Add MSI-X callbacks handler")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260211175540.105677-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index b8c9cb5d65f70..189675747b2bc 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -647,6 +647,9 @@ int dw_pcie_ep_raise_msix_irq(struct dw_pcie_ep *ep, u8 func_no,
 
 	writel(msg_data, ep->msi_mem + offset);
 
+	/* flush posted write before unmap */
+	readl(ep->msi_mem + offset);
+
 	dw_pcie_ep_unmap_addr(epc, func_no, 0, ep->msi_mem_phys);
 
 	return 0;
-- 
2.51.0



