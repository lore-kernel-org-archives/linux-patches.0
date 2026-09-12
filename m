Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC49433E35C;
	Sat, 12 Sep 2026 12:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215528; cv=none; b=tx15hjybLv/YjXjcVvjcm1hiql0MOq+jmFrnPprFH7EoHDi/rp9LGtJzF6iWV8korZjGhMSLy/VhlfwvcKt6iBTtrfwR5/lwxG2fOogWgy1/DtIi2LJcWc+H8eYgWpfB+HPBBABA5zIKpMZTuhrKXqTCCONVNSVf9FVLecLvZzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215528; c=relaxed/simple;
	bh=9sHm5GdJXbRxnMpfuCX3F0ivHxYGVkaF20T35nl0W5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9uJlL0eGC72vs1fBpMr4qDbpSpvfLYxdhUxAMPoy3bKQDCTaHl/ENM/gNKK+oq51QpntvI/FlV1CkchqHqLNyBvAN2SPGNDeIi3zo29LUaO+b2jx464LC7mXB2h1sMy/pFr1G9XVWbINujYkLEZxNTMhCINtuO8Zb4jC1CGbiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFf/c8um; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFf/c8um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13051F000FF;
	Sat, 12 Sep 2026 12:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215526;
	bh=Ig3Qq18tnpBVMDeLWRO1CdRoHsDL6VImH5cL/8kudRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HFf/c8umI58/mGI/J+We6up927FFctI8qvEE85lR9ObkhTi0Ssg00tmUKUtOX7O/u
	 +3kAeIggr0e6ZbTFZb2P0tLx8JOBfS5F1c0a9LnyoZT7reS1HivPsoasI5WD+T3njO
	 uDwIL6d2rEFVbWFcf6Ul4zU+zTo2g/3b47c5M4o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0549/1376] PCI: xgene: Drop unnecessary OF node reference
Date: Sat, 12 Sep 2026 08:49:35 +0200
Message-ID: <20260912065619.775139394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4869db344e76c9adfb1d9654df442db5371fac71 ]

xgene_pcie_probe() stores dev->of_node in port->node with
of_node_get(), but the cached node is only used during probe by
xgene_pcie_parse_map_dma_ranges(). The driver never releases the extra
reference, so the node reference is leaked.

There is no need for private OF node ownership here. Use the device's
existing of_node directly in xgene_pcie_parse_map_dma_ranges() and remove
the cached port->node pointer.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260630195234.1871951-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 16d4fd2364e35..7028d4b6abe6c 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -58,7 +58,6 @@
 
 #if defined(CONFIG_PCI_XGENE) || (defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS))
 struct xgene_pcie {
-	struct device_node	*node;
 	struct device		*dev;
 	struct clk		*clk;
 	void __iomem		*csr_base;
@@ -528,7 +527,7 @@ static void xgene_pcie_setup_ib_reg(struct xgene_pcie *port,
 
 static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie *port)
 {
-	struct device_node *np = port->node;
+	struct device_node *np = port->dev->of_node;
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
 	struct device *dev = port->dev;
@@ -596,7 +595,6 @@ static struct pci_ops xgene_pcie_ops = {
 static int xgene_pcie_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *dn = dev->of_node;
 	struct xgene_pcie *port;
 	struct pci_host_bridge *bridge;
 	int ret;
@@ -607,7 +605,6 @@ static int xgene_pcie_probe(struct platform_device *pdev)
 
 	port = pci_host_bridge_priv(bridge);
 
-	port->node = of_node_get(dn);
 	port->dev = dev;
 	port->version = XGENE_PCIE_IP_VER_1;
 
-- 
2.53.0



