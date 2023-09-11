Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB8F11729
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9105FC433C8;
	Mon, 11 Sep 2023 14:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442712;
	bh=3WItYjx6EVcy3ON/hR2hdQTFgQO8S8zuOhCJaQQoGCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeYyvWWyXS2s17R1nVOWbvE4X29TF3dB1FZrgOP3snTM85O9an/cXnFKIVLKA3D5r
	 q4pEm1JyBxJGne38ot/4T5VQVYzLy9AkyUp8PtBOJlxZPV/bGMtB1QicbDvUMeVhz1
	 pBiHkkBpRGskdUQ+ZrDnKF1nugO1bnpZVhk8Csdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 6.4 095/737] Revert "PCI: tegra194: Enable support for 256 Byte payload"
Date: Mon, 11 Sep 2023 15:39:14 +0200
Message-ID: <20230911134653.166625790@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

commit ebfde1584d9f037b6309fc682c96e22dac7bcb7a upstream.

After commit 4fb8e46c1bc4 ("PCI: tegra194: Enable support for 256 Byte
payload"), we initialize MPS=256 for tegra194 Root Ports before enumerating
the hierarchy.

Consider an Endpoint that supports only MPS=128.  In the default situation
(CONFIG_PCIE_BUS_DEFAULT set and no "pci=pcie_bus_*" parameter), Linux
tries to configure the MPS of every device to match the upstream bridge.
If the Endpoint is directly below the Root Port, Linux can reduce the Root
Port MPS to 128 to match the Endpoint.  But if there's a switch in the
middle, Linux doesn't reduce the Root Port MPS because other devices below
the switch may already be configured with MPS larger than 128.

This scenario results in uncorrectable Malformed TLP errors if the Root
Port sends TLPs with payloads larger than 128 bytes.  These errors can
be avoided by using the "pci=pcie_bus_safe" parameter, but it doesn't
seem to be a good idea to always have this parameter even for basic
functionality to work.

Revert commit 4fb8e46c1bc4 ("PCI: tegra194: Enable support for 256 Byte
payload") so the Root Ports default to MPS=128, which all devices
support.

If peer-to-peer DMA is not required, one can use "pci=pcie_bus_perf" to
get the benefit of larger MPS settings.

[bhelgaas: commit log; kwilczynski: retain "u16 val_16" declaration at
the top, add missing acked by tag]
Fixes: 4fb8e46c1bc4 ("PCI: tegra194: Enable support for 256 Byte payload")
Link: https://lore.kernel.org/linux-pci/20230619102604.3735001-1-vidyas@nvidia.com
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Cc: stable@vger.kernel.org # v6.0-rc1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -883,11 +883,6 @@ static int tegra_pcie_dw_host_init(struc
 		pcie->pcie_cap_base = dw_pcie_find_capability(&pcie->pci,
 							      PCI_CAP_ID_EXP);
 
-	val_16 = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base + PCI_EXP_DEVCTL);
-	val_16 &= ~PCI_EXP_DEVCTL_PAYLOAD;
-	val_16 |= PCI_EXP_DEVCTL_PAYLOAD_256B;
-	dw_pcie_writew_dbi(pci, pcie->pcie_cap_base + PCI_EXP_DEVCTL, val_16);
-
 	val = dw_pcie_readl_dbi(pci, PCI_IO_BASE);
 	val &= ~(IO_BASE_IO_DECODE | IO_BASE_IO_DECODE_BIT8);
 	dw_pcie_writel_dbi(pci, PCI_IO_BASE, val);
@@ -1876,11 +1871,6 @@ static void pex_ep_event_pex_rst_deasser
 	pcie->pcie_cap_base = dw_pcie_find_capability(&pcie->pci,
 						      PCI_CAP_ID_EXP);
 
-	val_16 = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base + PCI_EXP_DEVCTL);
-	val_16 &= ~PCI_EXP_DEVCTL_PAYLOAD;
-	val_16 |= PCI_EXP_DEVCTL_PAYLOAD_256B;
-	dw_pcie_writew_dbi(pci, pcie->pcie_cap_base + PCI_EXP_DEVCTL, val_16);
-
 	/* Clear Slot Clock Configuration bit if SRNS configuration */
 	if (pcie->enable_srns) {
 		val_16 = dw_pcie_readw_dbi(pci, pcie->pcie_cap_base +


