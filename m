Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D90827FB37;
	Sat, 12 Sep 2026 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229582; cv=none; b=MzRdyQRf2wG5F/E0Wql3++HY8heCpMT6rkbVNS2crU4JH4Gh1ztyleqqnG0q4SytRpvE5a1xU8GFuc27DdEKSXGc8nb19ljj0oGD69mzUgFupQ/mToZuQiHr5FFUNbTD7H5vzVf/40iJyoCkgGhRgsXlnPJpoy3NwsWa2+dQp4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229582; c=relaxed/simple;
	bh=prujLqecv6+JE4uzFpH8DYbrNsx9saoeYaWu1R+sI6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGHDH3rL6BMdLqZRBj3aLP8AW9Av5cq0ThwGa/D6Kxyuj6TNwhhdfwISesBojE1lQn6e3eU1g/FY5qKxjeQWVnMbOTmJXqfh9CJBqo//JnkAahKSvSvcpB5btO0G7vnaHZYmiiKTGiTblpBGsxTq+sf81k/RzKwIFTvyytnRbAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3vNFpGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3vNFpGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B332D1F000FF;
	Sat, 12 Sep 2026 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229580;
	bh=0ejMxFQ1rUEQKD6VO1UqlSFDNFdo1WLtFXS+ob08ScQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3vNFpGnSUiANOJ/UZPnTNQVSGEmSterUI9glJMMzQDqVj3AQSArlPsN9Sg7Wwj5p
	 goEg7DS3I6Nr9oiooCpyGdU9FUd/2LfBUR/AEWvPJKpMFQcEMV9LMbDNA6xV4WraEe
	 ekdCtbOIcFf6pXLd58BQQ/2U7FX/HuDk3zcPVdkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0619/1191] PCI: xgene: Drop unnecessary OF node reference
Date: Sat, 12 Sep 2026 08:55:47 +0200
Message-ID: <20260912065602.155315175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 049881a96cf44..d1773a4d77d7c 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -59,7 +59,6 @@
 
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



