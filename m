Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E31F76D7;
	Tue,  3 Dec 2024 16:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241749; cv=none; b=K2KgULfFVJq2uMVdVwEEf+ihhgaVQLd7D12sdCUO0c33b82af9Vl3Pr/djAoxtOpBaePMqDU4fopfx9Y7/hhJJJV8UE1COdGNXFWKKs60bvZFRBkhJUMKhR1fhWiziHxYhqNdFD+zLJX3t3l5AhxVE1NOfCfCoFHYTY50NKAq/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241749; c=relaxed/simple;
	bh=Bn5ETz2qJM5/hRP1JhDOen+qLZJcDx5M+d4OQlhMZC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Swigto0+twTMuO5RQhHEnN01HaMgjlkif065M1tFA7kEr9nz3VuqIvDO9xpIoKfndny5uiL51831uPIicjntQbicyAYUz0LbXp6fIAlDzePLklUItpFN/VtSDTnKdUiKjlbjURHDH9sBxw3t5qlM33yUJuaAynvO0TKRAEBjey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2PNsNbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2PNsNbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F4CC4CECF;
	Tue,  3 Dec 2024 16:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241749;
	bh=Bn5ETz2qJM5/hRP1JhDOen+qLZJcDx5M+d4OQlhMZC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2PNsNbbnLjkMUeAVQgXydihk8arGEMQHjcHNz543RG+iwzbReWVo/mYRs97AgsNb
	 NQJGfDsD5RQlrfclt/N+f8ff0JnJdjUqrYpt2I1vhGGtqOmOZew+7Xqq5obaZ7AuOj
	 Ll0EPUmaFCbEqIg+iC9U3C7TOcdpULbqzwVy0GVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Vidya Sagar <vidyas@nvidia.com>,
	linux-tegra@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/826] PCI: tegra194: Move controller cleanups to pex_ep_event_pex_rst_deassert()
Date: Tue,  3 Dec 2024 15:43:51 +0100
Message-ID: <20241203144803.417379720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 40e2125381dc11379112485e3eefdd25c6df5375 ]

Currently, the endpoint cleanup function dw_pcie_ep_cleanup() and EPF
deinit notify function pci_epc_deinit_notify() are called during the
execution of pex_ep_event_pex_rst_assert() i.e., when the host has asserted
PERST#. But quickly after this step, refclk will also be disabled by the
host.

All of the tegra194 endpoint SoCs supported as of now depend on the refclk
from the host for keeping the controller operational. Due to this
limitation, any access to the hardware registers in the absence of refclk
will result in a whole endpoint crash. Unfortunately, most of the
controller cleanups require accessing the hardware registers (like eDMA
cleanup performed in dw_pcie_ep_cleanup(), etc...). So these cleanup
functions can cause the crash in the endpoint SoC once host asserts PERST#.

One way to address this issue is by generating the refclk in the endpoint
itself and not depending on the host. But that is not always possible as
some of the endpoint designs do require the endpoint to consume refclk from
the host.

Thus, fix this crash by moving the controller cleanups to the start of
the pex_ep_event_pex_rst_deassert() function. This function is called
whenever the host has deasserted PERST# and it is guaranteed that the
refclk would be active at this point. So at the start of this function
(after enabling resources) the controller cleanup can be performed. Once
finished, rest of the code execution for PERST# deassert can continue as
usual.

Fixes: 473b2cf9c4d1 ("PCI: endpoint: Introduce 'epc_deinit' event and notify the EPF drivers")
Fixes: 570d7715eed8 ("PCI: dwc: ep: Introduce dw_pcie_ep_cleanup() API for drivers supporting PERST#")
Link: https://lore.kernel.org/r/20240817-pci-qcom-ep-cleanup-v1-2-d6b958226559@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Vidya Sagar <vidyas@nvidia.com>
Cc: linux-tegra@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index c1394f2ab63ff..ced3b7e7bdade 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1704,9 +1704,6 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
 	if (ret)
 		dev_err(pcie->dev, "Failed to go Detect state: %d\n", ret);
 
-	pci_epc_deinit_notify(pcie->pci.ep.epc);
-	dw_pcie_ep_cleanup(&pcie->pci.ep);
-
 	reset_control_assert(pcie->core_rst);
 
 	tegra_pcie_disable_phy(pcie);
@@ -1785,6 +1782,10 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 		goto fail_phy;
 	}
 
+	/* Perform cleanup that requires refclk */
+	pci_epc_deinit_notify(pcie->pci.ep.epc);
+	dw_pcie_ep_cleanup(&pcie->pci.ep);
+
 	/* Clear any stale interrupt statuses */
 	appl_writel(pcie, 0xFFFFFFFF, APPL_INTR_STATUS_L0);
 	appl_writel(pcie, 0xFFFFFFFF, APPL_INTR_STATUS_L1_0_0);
-- 
2.43.0



