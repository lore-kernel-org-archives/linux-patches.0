Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C93433BC4;
	Tue, 21 Jul 2026 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662677; cv=none; b=EDwf1oPNR/aWxZ9nSOflyzSc52gDCWuDbnWfpzNlhT6IfzwMwEeKtDhplqNbRLJ+w0zUczzCZuu2bK6/h6H9GI/aTDP40F5qx+ilELqQF3jveD366Smd8C3UmVlthR5a8SJpivX8zBGoiBhL1x2NML3ofX4FrW5xuj8Dh5laIDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662677; c=relaxed/simple;
	bh=EQwoj9pyEQAjkR8kkv3XR4EctPcEIxucm/19ZaxB/q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avolwTy3titIJ+mAX74Bmkjcf752zQ9oWfvXvvUQ/k2dQCp4sCyZ06+oPuJ0Ow0Eusw/FpeSeBRq6l24IsZ+bZO7ZSeJWZhgpbypo7vn7/YtJ8GmkxS6kD0b0jodizjcv55m9qqP1yYH0HlMa7PIvkgVMmU8RTRQVeAlccpilSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK8O8htj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK8O8htj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C01F00A3A;
	Tue, 21 Jul 2026 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662673;
	bh=VDLFIdcokyy/7t/aU0vTucv9WJNmW9DBEwraGjCDp6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DK8O8htjc/VBvHlLd9zhJ3Zx7o7OHyT9gAgJmrCxPNpAMy65zuQawjvHKMKmpUM/k
	 ACHFLTHBiffdOT7dlBbZlqOA1mjNM6eLlbzGLw2aqxZY0EVwEgwgvzy154V14pLI8F
	 5RERwXlDpcvnEZ2BdQGFqsMZgrm57GhglNS6jE/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0534/1276] PCI: mediatek: Use actual physical address instead of virt_to_phys()
Date: Tue, 21 Jul 2026 17:16:17 +0200
Message-ID: <20260721152458.073935191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit ebc1d9906894703286d12306a6f242d90cfb49e8 ]

The driver previously used virt_to_phys() on the ioremapped register base
(port->base) to compute the MSI message address. Using virt_to_phys() on an
IO mapped address is incorrect because it expects a kernel virtual address.

To fix it, store the physical start of the I/O register region in
mtk_pcie_port->phys_base and use it to build the MSI address. This replaces
the incorrect virt_to_phys() usage and ensures MSI addresses are generated
correctly.

Fixes: 43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and MT7622")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Caleb James DeLisle <cjd@cjdns.fr>
Link: https://patch.msgid.link/20260521171951.1495781-2-cjd@cjdns.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 3ce6830d279f91..dcf8a63a984bc5 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -165,6 +165,7 @@ struct mtk_pcie_soc {
 /**
  * struct mtk_pcie_port - PCIe port information
  * @base: IO mapped register base
+ * @phys_base: Physical address of the I/O register base region
  * @list: port list
  * @pcie: pointer to PCIe host info
  * @reset: pointer to port reset control
@@ -187,6 +188,7 @@ struct mtk_pcie_soc {
  */
 struct mtk_pcie_port {
 	void __iomem *base;
+	phys_addr_t phys_base;
 	struct list_head list;
 	struct mtk_pcie *pcie;
 	struct reset_control *reset;
@@ -397,7 +399,7 @@ static void mtk_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	phys_addr_t addr;
 
 	/* MT2712/MT7622 only support 32-bit MSI addresses */
-	addr = virt_to_phys(port->base + PCIE_MSI_VECTOR);
+	addr = port->phys_base + PCIE_MSI_VECTOR;
 	msg->address_hi = 0;
 	msg->address_lo = lower_32_bits(addr);
 
@@ -513,7 +515,7 @@ static void mtk_pcie_enable_msi(struct mtk_pcie_port *port)
 	u32 val;
 	phys_addr_t msg_addr;
 
-	msg_addr = virt_to_phys(port->base + PCIE_MSI_VECTOR);
+	msg_addr = port->phys_base + PCIE_MSI_VECTOR;
 	val = lower_32_bits(msg_addr);
 	writel(val, port->base + PCIE_IMSI_ADDR);
 
@@ -916,6 +918,7 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 	struct mtk_pcie_port *port;
 	struct device *dev = pcie->dev;
 	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *res;
 	char name[20];
 	int err;
 
@@ -924,7 +927,14 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 		return -ENOMEM;
 
 	snprintf(name, sizeof(name), "port%d", slot);
-	port->base = devm_platform_ioremap_resource_byname(pdev, name);
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
+	if (!res) {
+		dev_err(dev, "failed to get port%d base\n", slot);
+		return -EINVAL;
+	}
+
+	port->phys_base = res->start;
+	port->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(port->base)) {
 		dev_err(dev, "failed to map port%d base\n", slot);
 		return PTR_ERR(port->base);
-- 
2.53.0



