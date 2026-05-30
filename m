Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49C13148DA;
	Sat, 30 May 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161203; cv=none; b=f6m4hgwJOsGA9/23ehnHwf4LIh5YAo0Z9JCmBTLf6ZRG63bfMC79c6aMm0us/nrDyBE8w01sxnpQZwSyFBM5mhX89rEqciKDMhOTQJ/Ka8AUAAukRYTTRdocC8cXQJtcLTq0Ghkxe/CD28yaWTs7FhsCBGNLz0fy8M/C69I27mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161203; c=relaxed/simple;
	bh=O2BPljaDGP8CcHSNlRwrP6KwDr9SdcjHYMUhdv29d04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZC0OIPDCYUHiQklItPgzkHVVOenyVrob76aXFKk4BBZONqykoTFBk+9oDFQPe0msdC4M2BujDeENmM6O5orS1QzoBb42Se+l8vpNhaVEFmyQgivj3KL2d67BSSpXgAnLQJKtCHkmwWiiO26PFuzEeesPTVTF8HhBFexwMMKUT7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itJJeiFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itJJeiFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD24F1F00893;
	Sat, 30 May 2026 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161202;
	bh=B0er144KrahbXEwkUuWRghIOoqE0xszBURwxJ27Ti4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itJJeiFBgVF7Yfgx4AvCA6/BcXSgGI4SKgHKAhE5hVo/ZuloSUdPgNVmHhW55G4ty
	 SRl8NOUb5NqB90+0TKG5W+/Pwdzeg9nCMCStnmTrqgBWcM1uRFh/0SwCIVsicwToSe
	 qyle3Wjnedo0ZPfcwKOB6myPafvKPeqgOAvyERRk=
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
Subject: [PATCH 6.1 555/969] PCI: tegra194: Disable PERST# IRQ only in Endpoint mode
Date: Sat, 30 May 2026 18:01:19 +0200
Message-ID: <20260530160315.709900724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c562a4b97da1c..5085bacd2f542 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1041,7 +1041,8 @@ static void tegra_pcie_dw_stop_link(struct dw_pcie *pci)
 {
 	struct tegra_pcie_dw *pcie = to_tegra_pcie(pci);
 
-	disable_irq(pcie->pex_rst_irq);
+	if (pcie->of_data->mode == DW_PCIE_EP_TYPE)
+		disable_irq(pcie->pex_rst_irq);
 }
 
 static const struct dw_pcie_ops tegra_dw_pcie_ops = {
-- 
2.53.0



