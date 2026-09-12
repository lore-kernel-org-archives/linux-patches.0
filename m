Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B360832A3DA;
	Sat, 12 Sep 2026 14:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223302; cv=none; b=iYL6Bh9+D0+DAla1KkG+7FtqLNcN2LHz9wxyYLN0A6FK+tyyeUK9RTnXNMwESEy8A2IUdAiHKY4sRqbuPUvNsFK1ob1ejurV4dzHw9onQ64XNyrivlIhIYIxyoR5WdANlFJ/mq5zCFdkDNrtybTmIvWr6XZucvyvA2hVsQSBGSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223302; c=relaxed/simple;
	bh=3dnZLKwCUIbSU3XQveUUtpRxKDwx4nXQ/skOGw0Wr4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgAdMW3gihjjUmUVVDFA+p4MHRiuIctojaS7MyeiTwjDzr1vs3qggAOykTYbxb4RFwrjShUNwCnIMfX58Gs45GZ1AA4n4tT7eBDJY7xX8LiqEYVianEqQEbrNDJ+76qp+IRLxjPHD+4i3X6cCTDdZwyrqHdFA+K+MgV24/HK+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ky2VhV76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ky2VhV76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3436B1F000FF;
	Sat, 12 Sep 2026 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223301;
	bh=wi7nN2vYvjkMCQtd87L05fcXb7UliacoQPJEayPbcX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ky2VhV76SzB7wSp5eMg2InvPWUV3BwN0+JhuioYjcAbO9mauCXauezi6viNPAYdta
	 w4n4UsmgminZy9lUzQOFpFFAv7KnUgkkGdcP54DZcYO34B8sKB7p73ql9JqN1wosXM
	 5+zYIyDKmSFbpxHszriZe6FqnEjOpEZzZFl6SA5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0760/1424] PCI: xgene: Drop unnecessary OF node reference
Date: Sat, 12 Sep 2026 08:53:12 +0200
Message-ID: <20260912065624.316031957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf89b799e0b9f..4c14911170a4b 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -58,7 +58,6 @@
 
 #if defined(CONFIG_PCI_XGENE) || (defined(CONFIG_ACPI) && defined(CONFIG_PCI_QUIRKS))
 struct xgene_pcie {
-	struct device_node	*node;
 	struct device		*dev;
 	struct clk		*clk;
 	void __iomem		*csr_base;
@@ -527,7 +526,7 @@ static void xgene_pcie_setup_ib_reg(struct xgene_pcie *port,
 
 static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie *port)
 {
-	struct device_node *np = port->node;
+	struct device_node *np = port->dev->of_node;
 	struct of_pci_range range;
 	struct of_pci_range_parser parser;
 	struct device *dev = port->dev;
@@ -595,7 +594,6 @@ static struct pci_ops xgene_pcie_ops = {
 static int xgene_pcie_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *dn = dev->of_node;
 	struct xgene_pcie *port;
 	struct pci_host_bridge *bridge;
 	int ret;
@@ -606,7 +604,6 @@ static int xgene_pcie_probe(struct platform_device *pdev)
 
 	port = pci_host_bridge_priv(bridge);
 
-	port->node = of_node_get(dn);
 	port->dev = dev;
 	port->version = XGENE_PCIE_IP_VER_1;
 
-- 
2.53.0



