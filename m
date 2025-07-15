Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713772E3AE7;
	Tue, 15 Jul 2025 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587519; cv=none; b=WHXeD2xfXk/Vhk+6tLlsl90wAftsNe8bPhlCFqpgwSo8gKw5zseMiorfbvzeUTt90+8epV+q+rzVqXBgoJGy1xC2/KgowmH89qY9KTNgzkN5znlEUgLouKtG0zlKnHKX1Dw3TJCQgsqWjU/vsPim4/yYEahfZ1xcdMGwg3FXXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587519; c=relaxed/simple;
	bh=ccB/k1+wr1pyuTdFqM70SUYWDA2nJFzg8ZQqMpBlh6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR1eQNOSkbiPfpyj+voObxmHYJoQXZsdqxkC9FRsDn0TesM97SxS+RPVBYXkJPTNYI4SBVBUO83Jyu7JnEf5zw5LEuMHmhEvV99T5glHz5mNaclM2uYJ5rCvuuVFIdt9P4A+XZHgzTsTWT6t1i+fenQWT4QhlnBPWGQZpw5CDBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPs6IJHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPs6IJHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030F4C4CEE3;
	Tue, 15 Jul 2025 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587519;
	bh=ccB/k1+wr1pyuTdFqM70SUYWDA2nJFzg8ZQqMpBlh6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPs6IJHNV7XgApkJpZJM/WqNWntpLpnRlkNzL++pjMMM76aJLA+tjTemn+Vt+ZTJC
	 CLcsD//cNDXTI4FjgkYl4QBGq/F1K5pn2Kts4nBskt/f/zaWdCgCV0XUSPe0fLzJKN
	 mT2dD6ttkNqbDoAys5iVSLUpF/s/QHHU891WEaSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/208] PCI: cadence-ep: Correct PBA offset in .set_msix() callback
Date: Tue, 15 Jul 2025 15:12:32 +0200
Message-ID: <20250715130812.681722972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit c8bcb01352a86bc5592403904109c22b66bd916e ]

While cdns_pcie_ep_set_msix() writes the Table Size field correctly (N-1),
the calculation of the PBA offset is wrong because it calculates space for
(N-1) entries instead of N.

This results in the following QEMU error when using PCI passthrough on a
device which relies on the PCI endpoint subsystem:

  failed to add PCI capability 0x11[0x50]@0xb0: table & pba overlap, or they don't fit in BARs, or don't align

Fix the calculation of PBA offset in the MSI-X capability.

[bhelgaas: more specific subject and commit log]

Fixes: 3ef5d16f50f8 ("PCI: cadence: Add MSI-X support to Endpoint driver")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250514074313.283156-10-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-ep.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-ep.c b/drivers/pci/controller/cadence/pcie-cadence-ep.c
index 403ff93bc8509..f6edbe77e640a 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -253,11 +253,12 @@ static int cdns_pcie_ep_set_msix(struct pci_epc *epc, u8 fn, u16 interrupts,
 	struct cdns_pcie *pcie = &ep->pcie;
 	u32 cap = CDNS_PCIE_EP_FUNC_MSIX_CAP_OFFSET;
 	u32 val, reg;
+	u16 actual_interrupts = interrupts + 1;
 
 	reg = cap + PCI_MSIX_FLAGS;
 	val = cdns_pcie_ep_fn_readw(pcie, fn, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
-	val |= interrupts;
+	val |= interrupts; /* 0's based value */
 	cdns_pcie_ep_fn_writew(pcie, fn, reg, val);
 
 	/* Set MSIX BAR and offset */
@@ -267,7 +268,7 @@ static int cdns_pcie_ep_set_msix(struct pci_epc *epc, u8 fn, u16 interrupts,
 
 	/* Set PBA BAR and offset.  BAR must match MSIX BAR */
 	reg = cap + PCI_MSIX_PBA;
-	val = (offset + (interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
+	val = (offset + (actual_interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
 	cdns_pcie_ep_fn_writel(pcie, fn, reg, val);
 
 	return 0;
-- 
2.39.5



