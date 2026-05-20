Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C2B3A3825;
	Wed, 20 May 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298213; cv=none; b=nHi7Vu/5kXbAavoRwKdRsjQcgKQoJjy52CEuWCH2mp2UldM6lJGs975Sdr0QWaj2DIt3e9BfPaM1ZkYHJQ9xrI55MUbYY73hqV6I4LHQW4Dx1FfZKknAmGvxiETOL/mI/TI0RxwSGDCl98SD/BCcYJL0KcWp9OZseIDcr2AkMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298213; c=relaxed/simple;
	bh=GGL/xUdCJCyTbU2dB3T4F+YBnT1U6YYfNG0g1AGmvLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIaeNVWVhE1Lfk1awz5+34xMMxBNF2kY7Ank2Wl6GdleFbUHHCpNvhg4mG4mUTCMG60FhENC25DPe/PkPjSIpXXBv9AbWDX9pXIGYjhbzpKPXjR0oFIdZ7VFbVU7kIB1ilxYyCq+vZ7UbypqMqlQTKqJQnWlXYklV6zRpBR7b2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIesYZlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIesYZlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2962C1F000E9;
	Wed, 20 May 2026 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298212;
	bh=+tbbDefS4FFUjwawYn0TidgUls2LOOX0XHvswBprpWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIesYZlF2+FlUTqAm6PoOBdZyQ6RSlLX2TK4gQaYkd+HqEW+rPrrwGsNtsm9kkPlK
	 1bO8RkPtUtXmYufOGiXDverBNn+JuxOzrb/G/LprhQPvrUmBzHcenjOJgVC7HurKXG
	 VK0cRNHRp+svC3aUMyDIrf24MAU1rRTvNhgElRs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 325/957] PCI: tegra194: Set LTR message request before PCIe link up in Endpoint mode
Date: Wed, 20 May 2026 18:13:28 +0200
Message-ID: <20260520162141.578551139@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit b256493bf8cacf0e524bf4c10b5c4901d0c6cefe ]

LTR message should be sent as soon as the Root Port enables LTR in the
Endpoint mode. So set snoop and no-snoop LTR timing and LTR message request
before the PCIe link comes up, so that the LTR message is sent upstream as
soon as LTR is enabled.

Without programming these values, the Endpoint would send latencies of 0 to
the host, which will be inaccurate.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-9-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 698012f2a9465..7d3ea4309e9bb 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -487,15 +487,6 @@ static irqreturn_t tegra_pcie_ep_irq_thread(int irq, void *arg)
 	if (val & PCI_COMMAND_MASTER) {
 		ktime_t timeout;
 
-		/* 110us for both snoop and no-snoop */
-		val = FIELD_PREP(PCI_LTR_VALUE_MASK, 110) |
-		      FIELD_PREP(PCI_LTR_SCALE_MASK, 2) |
-		      LTR_MSG_REQ |
-		      FIELD_PREP(PCI_LTR_NOSNOOP_VALUE, 110) |
-		      FIELD_PREP(PCI_LTR_NOSNOOP_SCALE, 2) |
-		      LTR_NOSNOOP_MSG_REQ;
-		appl_writel(pcie, val, APPL_LTR_MSG_1);
-
 		/* Send LTR upstream */
 		val = appl_readl(pcie, APPL_LTR_MSG_2);
 		val |= APPL_LTR_MSG_2_LTR_MSG_REQ_STATE;
@@ -1832,6 +1823,15 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 	val |= APPL_INTR_EN_L1_0_0_RDLH_LINK_UP_INT_EN;
 	appl_writel(pcie, val, APPL_INTR_EN_L1_0_0);
 
+	/* 110us for both snoop and no-snoop */
+	val = FIELD_PREP(PCI_LTR_VALUE_MASK, 110) |
+	      FIELD_PREP(PCI_LTR_SCALE_MASK, 2) |
+	      LTR_MSG_REQ |
+	      FIELD_PREP(PCI_LTR_NOSNOOP_VALUE, 110) |
+	      FIELD_PREP(PCI_LTR_NOSNOOP_SCALE, 2) |
+	      LTR_NOSNOOP_MSG_REQ;
+	appl_writel(pcie, val, APPL_LTR_MSG_1);
+
 	reset_control_deassert(pcie->core_rst);
 
 	val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
-- 
2.53.0



