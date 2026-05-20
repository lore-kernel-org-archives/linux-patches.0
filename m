Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CA53A6B6D;
	Wed, 20 May 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300626; cv=none; b=S1hSQzjD1ytOceDzbTzbV5s2sNpGFf2pachOEredoOHqOzqe+x2Fo53Hll/6NHvwP3uLpRVCecc9ygLeXIsRoevs7VduGpBanNJU4f87Ul8LY5mD8YuS1jOJxGpAVoYv+eVy0AnajsInAGkHXMhn6IuPMlET0OPubkgyTPUw6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300626; c=relaxed/simple;
	bh=L365VY2fo9Q4MdjzqQ6CDu6hRYdfYnxiDLDgZQeb8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5jnC2dTUTG2r5e9OxmP39r2qEMGn2VBiBy9M3dCSTnBwNgstyUizOoCJBF1qdeau1ooEdzttDIY7ukGGHIQN3QclE2Nxg8/ykLTJof+uqdwyN1GKErgkRQN2HoRbHiS6WPbgHY0Wl7Z9YbVGlVuc/jntXXA4KmPzH+VDIYmRoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPCwXLli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPCwXLli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD9E1F000E9;
	Wed, 20 May 2026 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300624;
	bh=WNWBp3otr6NDrRFf7BgpWnNc+MFDqgSYIj9WZXxGCZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPCwXLliDp6NaHYO5Yg8niKPO1h0L+kS0TPk9KutDG5l3NOy4gmJAZvJ6/rH0OI8V
	 69QlJODxqw2lHxBPLwb1t2lyKAxRuqb1Ajl6skqBNSbaS6ktPRveQP2xpqp761/Y0h
	 sJSqzG7ggOCPkzGIBKCuzA5JRLl8B8ox+kMgk3Zk=
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
Subject: [PATCH 6.12 245/666] PCI: tegra194: Fix CBB timeout caused by DBI access before core power-on
Date: Wed, 20 May 2026 18:17:36 +0200
Message-ID: <20260520162116.529745575@linuxfoundation.org>
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

[ Upstream commit 34b3eef48d980cd37b876e128bbf314f69fb5d70 ]

When PERST# is deasserted twice (assert -> deassert -> assert -> deassert),
a CBB (Control Backbone) timeout occurs at DBI register offset 0x8bc
(PCIE_MISC_CONTROL_1_OFF). This happens because pci_epc_deinit_notify()
and dw_pcie_ep_cleanup() are called before reset_control_deassert() powers
on the controller core.

The call chain that causes the timeout:

  pex_ep_event_pex_rst_deassert()
    pci_epc_deinit_notify()
      pci_epf_test_epc_deinit()
        pci_epf_test_clear_bar()
          pci_epc_clear_bar()
            dw_pcie_ep_clear_bar()
              __dw_pcie_ep_reset_bar()
                dw_pcie_dbi_ro_wr_en()      <- Accesses 0x8bc DBI register
    reset_control_deassert(pcie->core_rst)  <- Core powered on HERE

The DBI registers, including PCIE_MISC_CONTROL_1_OFF (0x8bc), are only
accessible after the controller core is powered on via
reset_control_deassert(pcie->core_rst). Accessing them before this point
results in a CBB timeout because the hardware is not yet operational.

Fix this by moving pci_epc_deinit_notify() and dw_pcie_ep_cleanup() to
after reset_control_deassert(pcie->core_rst), ensuring the controller is
fully powered on before any DBI register accesses occur.

Fixes: 40e2125381dc ("PCI: tegra194: Move controller cleanups to pex_ep_event_pex_rst_deassert()")
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-15-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 5faac8b7190ca..368c50abd4fc4 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1757,10 +1757,6 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 		goto fail_phy;
 	}
 
-	/* Perform cleanup that requires refclk */
-	pci_epc_deinit_notify(pcie->pci.ep.epc);
-	dw_pcie_ep_cleanup(&pcie->pci.ep);
-
 	/* Clear any stale interrupt statuses */
 	appl_writel(pcie, 0xFFFFFFFF, APPL_INTR_STATUS_L0);
 	appl_writel(pcie, 0xFFFFFFFF, APPL_INTR_STATUS_L1_0_0);
@@ -1830,6 +1826,10 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 
 	reset_control_deassert(pcie->core_rst);
 
+	/* Perform cleanup that requires refclk and core reset deasserted */
+	pci_epc_deinit_notify(pcie->pci.ep.epc);
+	dw_pcie_ep_cleanup(&pcie->pci.ep);
+
 	val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
 	val &= ~PORT_LOGIC_SPEED_CHANGE;
 	dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
-- 
2.53.0



