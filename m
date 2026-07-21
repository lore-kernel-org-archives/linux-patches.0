Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D8F3446C7;
	Tue, 21 Jul 2026 21:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669429; cv=none; b=o3mDp5BOXpw+LURPfSDHSaktKxtsGZCubh0U0HbTQBp32OP7lqjlO0Eol78UvCGiiV14/5f2H6yA9jp278oswloIsg2k2obegQSXvfbr1S7DnKDRPSnh0hG2MW6QFUPcg4Q+9dRW7Xn7mQWxAZoFbHVRq51T5U/vlSYOE2nPDYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669429; c=relaxed/simple;
	bh=KaFv5BmsjK05Eoiy7ot9tpbsjkOEGzFYrrfi6xf/FuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYybTN5oVHdwm9N308RDOK5jMwVIEGx6S2wNOD+3tpSH9keqFzU9KcYVwcMZteRZ0O3L9PS7ltsB7qTt2qKXcZT7LofovMBSFhPiRzzfx1UmB1ixEHKXr5EQP3HJd+lD+khBe0ixp15Ggx0JdZ6HKzlku5ZQjKuwKiFsxgjwAFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9/ikOdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9/ikOdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864BA1F000E9;
	Tue, 21 Jul 2026 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669428;
	bh=i4/ZlpB+awLnWHsEUbrsgI7Tq2H7XoAXCVIH+8Mv22w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9/ikOdhCHvJT53WFpNkRoJ1w9qUDXq8mbE58sz+zIgPQePPqLWl1+zjUy79wEc7a
	 sS6IQ7DpP8IRHZw1VtdBT4JkEMTEI8aU1N8PTf6kqup5eloqviX1St7Vy3BDP5UG0S
	 pmfzMLU5t3TRWpUXb2tKjs+0pMLqg92qnK5oc2i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0550/1067] PCI: mediatek: Use actual physical address instead of virt_to_phys()
Date: Tue, 21 Jul 2026 17:19:11 +0200
Message-ID: <20260721152436.914329383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index c8c87e8afa6cc7..673f170620bca1 100644
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
@@ -398,7 +400,7 @@ static void mtk_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	phys_addr_t addr;
 
 	/* MT2712/MT7622 only support 32-bit MSI addresses */
-	addr = virt_to_phys(port->base + PCIE_MSI_VECTOR);
+	addr = port->phys_base + PCIE_MSI_VECTOR;
 	msg->address_hi = 0;
 	msg->address_lo = lower_32_bits(addr);
 
@@ -521,7 +523,7 @@ static void mtk_pcie_enable_msi(struct mtk_pcie_port *port)
 	u32 val;
 	phys_addr_t msg_addr;
 
-	msg_addr = virt_to_phys(port->base + PCIE_MSI_VECTOR);
+	msg_addr = port->phys_base + PCIE_MSI_VECTOR;
 	val = lower_32_bits(msg_addr);
 	writel(val, port->base + PCIE_IMSI_ADDR);
 
@@ -924,6 +926,7 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
 	struct mtk_pcie_port *port;
 	struct device *dev = pcie->dev;
 	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *res;
 	char name[20];
 	int err;
 
@@ -932,7 +935,14 @@ static int mtk_pcie_parse_port(struct mtk_pcie *pcie,
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



