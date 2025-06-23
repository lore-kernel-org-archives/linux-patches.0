Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3980125291B;
	Mon, 23 Jun 2025 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684837; cv=none; b=uXjrNzDLFu7CgGI9Ah0dLL6PUl419j3tLXqetMmzt5LklTCg47E0qk55GbMJoOyhZadx/egpCNjpiVr+PyA5HkmBTNlhRFLLEVolrVuM0MCaoK4a8uod5vCkIn9D+t3BT9noZC1QFLW6/fRgVWrCISgKY593njpqd2x7o74R6SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684837; c=relaxed/simple;
	bh=tydNrfFemZCVhuuPOXJCwPHZOfMGcB5UilpA6QeopAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWMmqvxhrHGN0e0USnU6FoEgCmszCT/Yi8MMps94zYIQ9GmRGqCTaEnkMepWoYvOkBCU4a/cQ2M5LF+hje+m1p0vYXd44Fp2bEy6enbEhVK5Mr5YV3xbiJJ1DUQGxTVdzoZa6+QTr8RrFPS0XmEWmSrN/3XqraW6IPg8u7EB7RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BahFhEak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BahFhEak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B90FC4CEEA;
	Mon, 23 Jun 2025 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684837;
	bh=tydNrfFemZCVhuuPOXJCwPHZOfMGcB5UilpA6QeopAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BahFhEakyrZS3kRXYERKAKU03n5JhK75az86qa0vv/t2pnir9Zj6CPAVWL9entzNo
	 je+RXGtMjOsp37LxRLFcH1Ha60/eNcWQkbdCJ5ez12X2nD2I9P2avyq75SRAnyXEuC
	 rymSBbEPXJaGWX3+NHiRtzEH/O2wkioeNwSfWj7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.15 181/592] PCI: dwc: ep: Correct PBA offset in .set_msix() callback
Date: Mon, 23 Jun 2025 15:02:19 +0200
Message-ID: <20250623130704.587138554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 810276362bad172d063d1f6be1cc2cb425b90103 upstream.

While dw_pcie_ep_set_msix() writes the Table Size field correctly (N-1),
the calculation of the PBA offset is wrong because it calculates space for
(N-1) entries instead of N.

This results in the following QEMU error when using PCI passthrough on a
device which relies on the PCI endpoint subsystem:

  failed to add PCI capability 0x11[0x50]@0xb0: table & pba overlap, or they don't fit in BARs, or don't align

Fix the calculation of PBA offset in the MSI-X capability.

[bhelgaas: more specific subject and commit log]

Fixes: 83153d9f36e2 ("PCI: endpoint: Fix ->set_msix() to take BIR and offset as arguments")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250514074313.283156-9-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -585,6 +585,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 	struct dw_pcie_ep_func *ep_func;
 	u32 val, reg;
+	u16 actual_interrupts = interrupts + 1;
 
 	ep_func = dw_pcie_ep_get_func_from_ep(ep, func_no);
 	if (!ep_func || !ep_func->msix_cap)
@@ -595,7 +596,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	reg = ep_func->msix_cap + PCI_MSIX_FLAGS;
 	val = dw_pcie_ep_readw_dbi(ep, func_no, reg);
 	val &= ~PCI_MSIX_FLAGS_QSIZE;
-	val |= interrupts;
+	val |= interrupts; /* 0's based value */
 	dw_pcie_writew_dbi(pci, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_TABLE;
@@ -603,7 +604,7 @@ static int dw_pcie_ep_set_msix(struct pc
 	dw_pcie_ep_writel_dbi(ep, func_no, reg, val);
 
 	reg = ep_func->msix_cap + PCI_MSIX_PBA;
-	val = (offset + (interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
+	val = (offset + (actual_interrupts * PCI_MSIX_ENTRY_SIZE)) | bir;
 	dw_pcie_ep_writel_dbi(ep, func_no, reg, val);
 
 	dw_pcie_dbi_ro_wr_dis(pci);


