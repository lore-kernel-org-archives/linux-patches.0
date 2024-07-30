Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911AB187FF6;
	Tue, 30 Jul 2024 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356676; cv=none; b=p1hgZYzxk/dUZ70+B/dBsWoRYBZUMfgWnIjaoNrAFsR2ptWume94dIjjms3JBT9DxXmoiNvrOO3iknNSQy4dOsIQ+nnsXvAcvCx02xxbbD4h95eyCsshMoDgfgI3QO2+yz7Gy3nMo1KwOyXh887vYpWX/8wivl0cDuoEt2rQwhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356676; c=relaxed/simple;
	bh=yaDeEyX9ebkeQ8wksklJv9yZhmqUke4HWQKTyIgr4MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQPo9G9yvo9M+53ajr/Tsr0NNoSXiJ8nEPFAjkXihYD3zcWJTWiqRoStnnNszTXQUcHcWDTtoqGpbP/Nxves3hPYnQpNwK/k0eShsMdR+Kd5aDtPH1QTjQ28pLVN2RqWC5hmhOGpn9T96XwXZPpr1ONz0Z30b7b636Xw2ibCXi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gizak6UL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gizak6UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0C9C32782;
	Tue, 30 Jul 2024 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356676;
	bh=yaDeEyX9ebkeQ8wksklJv9yZhmqUke4HWQKTyIgr4MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gizak6ULvrCPMyM/NxL6Mdmk6M+Z3sTXgHZpegQiXW5IUivSAo8fB6KqAyJJLAWOu
	 c8P4n8TWDp/IKkBav7CcFFXtNO8yxnAcdPBFJ5yegH0El27yVo2fcQHB3esLdbeLL7
	 FE0I1Egb6bZMN339/Mt7kHX2MAuYG2iBMRQ4JoDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <Niklas.Cassel@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/440] PCI: dwc: Fix index 0 incorrectly being interpreted as a free ATU slot
Date: Tue, 30 Jul 2024 17:47:31 +0200
Message-ID: <20240730151624.375896172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit c2a57ee0f2f1ad8c970ff58b78a43e85abbdeb7f ]

When PERST# assert and deassert happens on the PERST# supported platforms,
both iATU0 and iATU6 will map inbound window to BAR0. DMA will access the
area that was previously allocated (iATU0) for BAR0, instead of the new
area (iATU6) for BAR0.

Right now, this isn't an issue because both iATU0 and iATU6 should
translate inbound accesses to BAR0 to the same allocated memory area.
However, having two separate inbound mappings for the same BAR is a
disaster waiting to happen.

The mappings between PCI BAR and iATU inbound window are maintained in the
dw_pcie_ep::bar_to_atu[] array. While allocating a new inbound iATU map for
a BAR, dw_pcie_ep_inbound_atu() API checks for the availability of the
existing mapping in the array and if it is not found (i.e., value in the
array indexed by the BAR is found to be 0), it allocates a new map value
using find_first_zero_bit().

The issue is the existing logic failed to consider the fact that the map
value '0' is a valid value for BAR0, so find_first_zero_bit() will return
'0' as the map value for BAR0 (note that it returns the first zero bit
position).

Due to this, when PERST# assert + deassert happens on the PERST# supported
platforms, the inbound window allocation restarts from BAR0 and the
existing logic to find the BAR mapping will return '6' for BAR0 instead of
'0' due to the fact that it considers '0' as an invalid map value.

Fix this issue by always incrementing the map value before assigning to
bar_to_atu[] array and then decrementing it while fetching. This will make
sure that the map value '0' always represents the invalid mapping."

Fixes: 4284c88fff0e ("PCI: designware-ep: Allow pci_epc_set_bar() update inbound map address")
Closes: https://lore.kernel.org/linux-pci/ZXsRp+Lzg3x%2Fnhk3@x1-carbon/
Link: https://lore.kernel.org/linux-pci/20240412160841.925927-1-Frank.Li@nxp.com
Reported-by: Niklas Cassel <Niklas.Cassel@wdc.com>
Tested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 506d6d061d4cd..449ad709495d3 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -165,7 +165,7 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, u8 func_no, int type,
 	if (!ep->bar_to_atu[bar])
 		free_win = find_first_zero_bit(ep->ib_window_map, pci->num_ib_windows);
 	else
-		free_win = ep->bar_to_atu[bar];
+		free_win = ep->bar_to_atu[bar] - 1;
 
 	if (free_win >= pci->num_ib_windows) {
 		dev_err(pci->dev, "No free inbound window\n");
@@ -179,7 +179,11 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, u8 func_no, int type,
 		return ret;
 	}
 
-	ep->bar_to_atu[bar] = free_win;
+	/*
+	 * Always increment free_win before assignment, since value 0 is used to identify
+	 * unallocated mapping.
+	 */
+	ep->bar_to_atu[bar] = free_win + 1;
 	set_bit(free_win, ep->ib_window_map);
 
 	return 0;
@@ -216,7 +220,10 @@ static void dw_pcie_ep_clear_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 	struct dw_pcie_ep *ep = epc_get_drvdata(epc);
 	struct dw_pcie *pci = to_dw_pcie_from_ep(ep);
 	enum pci_barno bar = epf_bar->barno;
-	u32 atu_index = ep->bar_to_atu[bar];
+	u32 atu_index = ep->bar_to_atu[bar] - 1;
+
+	if (!ep->bar_to_atu[bar])
+		return;
 
 	__dw_pcie_ep_reset_bar(pci, func_no, bar, epf_bar->flags);
 
-- 
2.43.0



