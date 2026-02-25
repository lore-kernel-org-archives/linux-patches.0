Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DC918DB2A;
	Wed, 25 Feb 2026 01:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983169; cv=none; b=uQ0dJlE6xrtbXhbcMy77vz0Nl/pnPk6H+UwojyM8f1ZmXy4YfPcQIuZrllveTuBhQtB9Zzb18qz81ICyYbdDp+CtdJERqa4ZStgWGUsvX7F7/hWpohPW2ZwWJonHaQwnXIXf/cAEmX3bDRcb8Lr04sXIddaWgYYxbMZL+oz1AjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983169; c=relaxed/simple;
	bh=+/QPcB9pOGyssjvX3lSv0N5dfvWWQtkGacWUciZWBkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIC9csVJN1PmLtbEAH8COmN/STmZC3XN3gOPxmUY8txuxx23ywF6pW4YHuqwCi71DC47wCqjEbjp1QypgCl7DC4PjBbvmvdIhTla/s7Je9TmPn+gyD9pw6Ixhy4UYcuhbGdlmNrJ/ZQGiAL6RxxUWcyEemynOrvNTN+2WayvlOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGrn/3dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGrn/3dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067E7C116D0;
	Wed, 25 Feb 2026 01:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983169;
	bh=+/QPcB9pOGyssjvX3lSv0N5dfvWWQtkGacWUciZWBkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGrn/3dl8sAceWwhyLl1kX+Xt83A2hxYSHWhCJ1FCRlkzow/bj2qp9HH15ww5CY7s
	 5yW6ec4A54wPBwuKcgcPkkBCqL+N+HDeY6yqg3QcBDdMTDP12WU/IRM9hRa7U5oZ2V
	 MnUvUh5rqLTwu87kg+e8CGMss0BtZTqNFN2eEPvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 321/781] PCI: rzg3s-host: Use pci_generic_config_write() for the root bus
Date: Tue, 24 Feb 2026 17:17:10 -0800
Message-ID: <20260225012407.575132052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 4b86eff47e205819eb862097493ec20e25ac8f56 ]

The Renesas RZ/G3S host controller allows writing to read-only PCIe
configuration registers when the RZG3S_PCI_PERM_CFG_HWINIT_EN bit is set in
the RZG3S_PCI_PERM register. However, callers of struct pci_ops::write
expect the semantics defined by the PCIe specification, meaning that writes
to read-only registers must not be allowed.

The previous custom struct pci_ops::write implementation for the root bus
temporarily enabled write access before calling pci_generic_config_write().
This breaks the expected semantics.

Remove the custom implementation and simply use pci_generic_config_write().

Along with this change, the updates of the PCI_PRIMARY_BUS,
PCI_SECONDARY_BUS, and PCI_SUBORDINATE_BUS registers were moved so that
they no longer depends on the RZG3S_PCI_PERM_CFG_HWINIT_EN bit in the
RZG3S_PCI_PERM_CFG register, since these registers are R/W.

Fixes: 7ef502fb35b2 ("PCI: Add Renesas RZ/G3S host controller driver")
Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20251217111510.138848-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rzg3s-host.c | 27 ++++--------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/controller/pcie-rzg3s-host.c b/drivers/pci/controller/pcie-rzg3s-host.c
index 83ec66a708236..ae6d9c7dc2c12 100644
--- a/drivers/pci/controller/pcie-rzg3s-host.c
+++ b/drivers/pci/controller/pcie-rzg3s-host.c
@@ -439,28 +439,9 @@ static void __iomem *rzg3s_pcie_root_map_bus(struct pci_bus *bus,
 	return host->pcie + where;
 }
 
-/* Serialized by 'pci_lock' */
-static int rzg3s_pcie_root_write(struct pci_bus *bus, unsigned int devfn,
-				 int where, int size, u32 val)
-{
-	struct rzg3s_pcie_host *host = bus->sysdata;
-	int ret;
-
-	/* Enable access control to the CFGU */
-	writel_relaxed(RZG3S_PCI_PERM_CFG_HWINIT_EN,
-		       host->axi + RZG3S_PCI_PERM);
-
-	ret = pci_generic_config_write(bus, devfn, where, size, val);
-
-	/* Disable access control to the CFGU */
-	writel_relaxed(0, host->axi + RZG3S_PCI_PERM);
-
-	return ret;
-}
-
 static struct pci_ops rzg3s_pcie_root_ops = {
 	.read		= pci_generic_config_read,
-	.write		= rzg3s_pcie_root_write,
+	.write		= pci_generic_config_write,
 	.map_bus	= rzg3s_pcie_root_map_bus,
 };
 
@@ -1065,14 +1046,14 @@ static int rzg3s_pcie_config_init(struct rzg3s_pcie_host *host)
 	writel_relaxed(0xffffffff, host->pcie + RZG3S_PCI_CFG_BARMSK00L);
 	writel_relaxed(0xffffffff, host->pcie + RZG3S_PCI_CFG_BARMSK00U);
 
+	/* Disable access control to the CFGU */
+	writel_relaxed(0, host->axi + RZG3S_PCI_PERM);
+
 	/* Update bus info */
 	writeb_relaxed(primary_bus, host->pcie + PCI_PRIMARY_BUS);
 	writeb_relaxed(secondary_bus, host->pcie + PCI_SECONDARY_BUS);
 	writeb_relaxed(subordinate_bus, host->pcie + PCI_SUBORDINATE_BUS);
 
-	/* Disable access control to the CFGU */
-	writel_relaxed(0, host->axi + RZG3S_PCI_PERM);
-
 	return 0;
 }
 
-- 
2.51.0



