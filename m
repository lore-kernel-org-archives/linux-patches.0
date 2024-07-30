Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC9518B47F;
	Tue, 30 Jul 2024 17:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359236; cv=none; b=P97cmTN6i8wjjk73MX451f00QFuUlXBB42LPsDU7wb1Pz+LQc/35Jxy0gBG9E8srT+2cm8qSMjv+/wspFqeJTECNKsoKxEYPQZwsem0BuZlhL+lPkq36PWFIkL/rAeYAJjhvDM0FFyrukRc2hovOFsilB1QglOYNP01oaYV2ZE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359236; c=relaxed/simple;
	bh=muM7QsJRcLC6IWQ5EOuX3AMn1YBYWLlOVfp5HoHNCD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EuZkIrg1+C9L0mAwT6OFlSb46ZQ7ptXpRIXWU6r52/BDxlBoYhW5SeL/RPfIpDt/q9XrfbLR/VMopRQopV92gxXkB/ejOyQD0LOKQ/qT6SqsuchIgo6keUGYLb8ftc/zMHsX2qhDOD67GR69RtembrjPByOVN2b8qsDuEHOzfTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xL7uuDDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xL7uuDDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8023CC32782;
	Tue, 30 Jul 2024 17:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359236;
	bh=muM7QsJRcLC6IWQ5EOuX3AMn1YBYWLlOVfp5HoHNCD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xL7uuDDXiDR12V4TLd2g9V1LDSSD9WDaa58VZFbcGD02wPIdlCisKgNNe7AWrVM4P
	 gUkiH1eG6mc3TnkNSGzAZGqxR4GIJXNb3IW9hGV4lZlVly+j20bKolJ5qV9MmHhW7C
	 WKLf2Ko9VFmLXIlWSQwbtQx6/l4kZoxb49WjYR+c=
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
Subject: [PATCH 6.10 455/809] PCI: dwc: Fix index 0 incorrectly being interpreted as a free ATU slot
Date: Tue, 30 Jul 2024 17:45:31 +0200
Message-ID: <20240730151742.700424950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 47391d7d3a734..769e848246870 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -161,7 +161,7 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, u8 func_no, int type,
 	if (!ep->bar_to_atu[bar])
 		free_win = find_first_zero_bit(ep->ib_window_map, pci->num_ib_windows);
 	else
-		free_win = ep->bar_to_atu[bar];
+		free_win = ep->bar_to_atu[bar] - 1;
 
 	if (free_win >= pci->num_ib_windows) {
 		dev_err(pci->dev, "No free inbound window\n");
@@ -175,7 +175,11 @@ static int dw_pcie_ep_inbound_atu(struct dw_pcie_ep *ep, u8 func_no, int type,
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
@@ -212,7 +216,10 @@ static void dw_pcie_ep_clear_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
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



