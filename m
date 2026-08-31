Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C8946AA8C;
	Mon, 31 Aug 2026 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183296; cv=none; b=HnLL2pI+ezZOXGjcmffm2W4lrmvkMMj0LwlJnEFfbQJtM6KEfJ03N8rm0tMaFR8+3QK09nF0Id3slGwwwgWIFh51MWP1Jqce2rzWAdjbM+jwx64/ufjUNKmgK8pV6UzDG1j4byjV+Vjf34pkdCyfwVYuEdnkAMxDRwNLpPTaGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183296; c=relaxed/simple;
	bh=Q1Om9O+tYLXKWIi+j8yPF31cJiWKxx3aSZjzffXMolo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sML294T3MDbr+ijSUpr3IkA698Vkhvbb3IHjUdWHIoBpxugsqzbs7qnWxOJpHLQwEfbE9jOVRvNo01UWTcnnXsakoHSA5263HKlmrien/z8MT9z0VIbzfsHyzPpuR3AwlOmO17EIhXUcriT4sq9///PrTh1oPQctjkM8ruP01KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RqhYv2Qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RqhYv2Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53561F000E9;
	Mon, 31 Aug 2026 13:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183294;
	bh=Rto4Ld4oxE/HhgmXsII1Ti65TWprBdnsCAbbrWMsjls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqhYv2QxTzIE+8deByASzMvXQsT/a++I56fwRKK74yF2denpC89KeQkj5mT9Q8+8L
	 TjjV6hqeUTh/mLrPpiGdl/dB/6QdhrNVhAO9yOGv4ggtV1PyWSpEu1qgI8tnvDBBSE
	 gleM2L0x9k9tpuYz6bEr6tz1fwzsF4aQrutaRlEk7tClfJlJM1wQrCMWZBFqt7N4Gx
	 XXSlzJoPZdHCPnOZ3iaZ0NbDnIrBniBTs05xtmFWfkEtq6bK2FnbrzMvC8fysU8eQ8
	 ffN5M+zPhTAVloxnWBJFzYLCl4eMZsLrZ0Bd4K1R6JgeK0R2lNahZHtxI4yM5PjM2h
	 8ox4vWXuGQBMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Eckert <fe@dev.tdt.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: intel-gw: Enable clock before PHY init
Date: Mon, 31 Aug 2026 09:21:31 -0400
Message-ID: <20260831133314.4125787-63-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit febf9ed3c35e5eec7ea384ebbd55a5296e3ca5e9 ]

To ensure that the boot sequence is correct, the DWC PCIe core clock must
be switched on before PHY init call [1]. This changes are based on patched
kernel sources of the MaxLinear SDK.

The reason why the MaxLinear SDK is used as a reference here is, that this
PCIe DWC IP is used in the URX851 and URX850 SoC. This SoC was originally
developed by Intel when they acquired Lantiq’s home networking division in
2015 [2]. In 2020 the home network division was sold to MaxLinear [3].
Since then, this SoC belongs to MaxLinear. They use their own SDK, which
runs on kernel version '5.15.x'.

[1] https://github.com/maxlinear/linux/blob/updk_9.1.90/drivers/pci/controller/dwc/pcie-intel-gw.c#L544
[2] https://www.intc.com/news-events/press-releases/detail/364/intel-to-acquire-lantiq-advancing-the-connected-home
[3] https://investors.maxlinear.com/press-releases/detail/395/maxlinear-to-acquire-intels-home-gateway-platform

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260417-pcie-intel-gw-v5-4-0a2b933fe04f@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search for `intel,lgm-pcie` in this stable checkout only
turned up merge commits — the tree’s history is too shallow to show the
original introduction. From `v5.15` history, the driver dates to
`ed22aaaede44f` (“PCI: dwc: intel: PCIe RC controller driver”, 2019),
and the wrong clock/PHY ordering has been there since then.

**Verdict for linux-6.18.y: YES** — enable the core clock before
`phy_init()` in `intel_pcie_host_setup()`. It’s a small, vendor-
validated hardware sequencing fix for MaxLinear/Intel Gateway SoCs, and
it applies with a minor tweak (6.18.y still uses inline interrupt enable
instead of `intel_pcie_core_irq_enable()`).

Note: this is patch 4/7 of a larger intel-gw series; full driver
restoration on current dwc may also need the `.start_link()` and ATU
patches from the same series.

 drivers/pci/controller/dwc/pcie-intel-gw.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-intel-gw.c b/drivers/pci/controller/dwc/pcie-intel-gw.c
index c21906eced618..8b51eb30112d9 100644
--- a/drivers/pci/controller/dwc/pcie-intel-gw.c
+++ b/drivers/pci/controller/dwc/pcie-intel-gw.c
@@ -285,13 +285,9 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	intel_pcie_core_rst_assert(pcie);
 	intel_pcie_device_rst_assert(pcie);
-
-	ret = phy_init(pcie->phy);
-	if (ret)
-		return ret;
-
 	intel_pcie_core_rst_deassert(pcie);
 
+	/* Controller clock must be provided earlier than PHY */
 	ret = clk_prepare_enable(pcie->core_clk);
 	if (ret) {
 		dev_err(pcie->pci.dev, "Core clock enable failed: %d\n", ret);
@@ -300,13 +296,17 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	pci->atu_base = pci->dbi_base + 0xC0000;
 
+	ret = phy_init(pcie->phy);
+	if (ret)
+		goto phy_err;
+
 	intel_pcie_ltssm_disable(pcie);
 	intel_pcie_link_setup(pcie);
 	intel_pcie_init_n_fts(pci);
 
 	ret = dw_pcie_setup_rc(&pci->pp);
 	if (ret)
-		goto app_init_err;
+		goto err;
 
 	dw_pcie_upconfig_setup(pci);
 
@@ -315,7 +315,7 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	ret = dw_pcie_wait_for_link(pci);
 	if (ret)
-		goto app_init_err;
+		goto err;
 
 	/* Enable integrated interrupts */
 	pcie_app_wr_mask(pcie, PCIE_APP_IRNEN, PCIE_APP_IRN_INT,
@@ -323,11 +323,12 @@ static int intel_pcie_host_setup(struct intel_pcie *pcie)
 
 	return 0;
 
-app_init_err:
+err:
+	phy_exit(pcie->phy);
+phy_err:
 	clk_disable_unprepare(pcie->core_clk);
 clk_err:
 	intel_pcie_core_rst_assert(pcie);
-	phy_exit(pcie->phy);
 
 	return ret;
 }
-- 
2.53.0

