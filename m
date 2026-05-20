Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEA5363C55;
	Wed, 20 May 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298203; cv=none; b=tJjyD0tdFrImwihV19830J1y+vYD5lsB0SM7K6vfgoDhlQV6xqf02d5GfAb/bakujtrTah+IkZAwKZUN3CLCefBFQVcrKLXJ/fKM/iMWM5z7yy7wr/hlWXkvw4g6v0oQVBE4q9rnvilZZeSGvUHi9thpXLckIEsI4QmHi0akg1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298203; c=relaxed/simple;
	bh=aci8s7HC4VJoMVm4JwdAzasYfwkEbzzmgYmHDTsFBic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHfcEnD5go5alH2SJnXAoVkMH5oQVMht+aTDqSEXRMXCVAc+f56n8GHDq8q3xqmHaZnYUXZXloOk0l0jKP+iGa9PXH2R94LoojAzW1LBJePg++uPLpnat224kfNLDz+mjtOfZhArD/tgsPMjRlAB6mBSBjWd6/H5pzTUcY93qx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6No7n8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6No7n8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B21F00893;
	Wed, 20 May 2026 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298202;
	bh=Plk4QJM/I+IeuViG65oEh9yqzVMecAx9zwaRoxNQM4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6No7n8idshC/TD0MbzuMY/yzf2DiwnIqWHZ3pZmdJFB+LY69nz2bdnW2cb61P8LZ
	 uA/P3go91YSp3Y8t1j3S/bFg3NveFeUXunSvQ/uOWy09Ktqa4Egn3D6+tqA52tkWgv
	 uXOs5oiXts/O2JpTTAWchBTD9JP5+EqSRYQGsLPk=
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
Subject: [PATCH 6.18 322/957] PCI: tegra194: Disable PERST# IRQ only in Endpoint mode
Date: Wed, 20 May 2026 18:13:25 +0200
Message-ID: <20260520162141.514211019@linuxfoundation.org>
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
index 112fd5ea5a0ab..68920c6263a41 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1054,7 +1054,8 @@ static void tegra_pcie_dw_stop_link(struct dw_pcie *pci)
 {
 	struct tegra_pcie_dw *pcie = to_tegra_pcie(pci);
 
-	disable_irq(pcie->pex_rst_irq);
+	if (pcie->of_data->mode == DW_PCIE_EP_TYPE)
+		disable_irq(pcie->pex_rst_irq);
 }
 
 static const struct dw_pcie_ops tegra_dw_pcie_ops = {
-- 
2.53.0



