Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03C3A6B6D;
	Wed, 20 May 2026 18:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300602; cv=none; b=cswKLl6NiCIvKBsmmWR2nvxw5shjVUESt+Tl6HIiqCb+8WLWhUNs8R18/GxeCRL/HlOpNxgJby7gee/OYxPsx0b9yenxuryoSlSh3GCDIUu6Ywd1eeRA5+DLr1xMGTGU+sT+4DgIgJcPtpNy51whOt0V0B71PCq6EU7exKBGwPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300602; c=relaxed/simple;
	bh=XN68GuaTs92FV9RrnaLp7O7NPisfGnnQvDr3jGZXups=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTOtR1b4w3IzhOfHE0IeLKOyrFRNsLfBgnQn951rODHDgckq6W39B98QgjBm2tM6Z2onrXL+f7nXDSVj2kOlJhGdKUhuwry2S8p0qdqRorapvgZ/rv7A833h4IptK8gvAZTePhdMswbfZ+EZm2S6crkcpFY8+52llvdmU/p36PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcr6nibB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcr6nibB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071DE1F000E9;
	Wed, 20 May 2026 18:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300601;
	bh=HClXnAwIXPxqZGB3zr5gtYIU6YZGcc7D36H04FQhLZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcr6nibBUIKWeZm/feC8rvurdFbISVAvd07UJ4+PwYWv+ksMI0FF4K8cXccN5SGx7
	 pKLKj4ekhzA6GCMu09EbLavtajJx2x6t/r23W8zS8Yn37ALVg8fAhJp+D2332KQ5kn
	 u8tIRKXyWQICM9bqVsCPbztwfurWQFSN675TKIAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vidya Sagar <vidyas@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/666] PCI: tegra194: Disable PERST# IRQ only in Endpoint mode
Date: Wed, 20 May 2026 18:17:28 +0200
Message-ID: <20260520162116.352463303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit 40658a31b6e134169c648041efc84944c4c71dcd ]

The PERST# GPIO interrupt is only registered when the controller is
operating in Endpoint mode. In Root Port mode, the PERST# GPIO is
configured as an output to control downstream devices, and no interrupt is
registered for it.

Currently, tegra_pcie_dw_stop_link() unconditionally calls disable_irq()
on pex_rst_irq, which causes issues in Root Port mode where this IRQ is
not registered.

Fix this by only disabling the PERST# IRQ when operating in Endpoint mode,
where the interrupt is actually registered and used to detect PERST#
assertion/deassertion from the host.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-6-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index d2a06a34137d7..4b88cfd1fa64e 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1042,7 +1042,8 @@ static void tegra_pcie_dw_stop_link(struct dw_pcie *pci)
 {
 	struct tegra_pcie_dw *pcie = to_tegra_pcie(pci);
 
-	disable_irq(pcie->pex_rst_irq);
+	if (pcie->of_data->mode == DW_PCIE_EP_TYPE)
+		disable_irq(pcie->pex_rst_irq);
 }
 
 static const struct dw_pcie_ops tegra_dw_pcie_ops = {
-- 
2.53.0



