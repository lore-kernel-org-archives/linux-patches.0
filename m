Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02BD36404E;
	Wed, 20 May 2026 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294981; cv=none; b=f34ZqXdPyGBGNHmHWXWIs/tEp/SSp424cy5WN5Vp5EAL2hvnQ2v1QNuI0pm9rCE7flmEtELH+r+WlmGFsNUdLEWsF57WJn+KMfcO+59HDnr4ZWlzz+vWzHZXtCiJCVbFeK/xa5zWnzeeMwQ0KXakpdEEAqBuNtriSXDqXREihQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294981; c=relaxed/simple;
	bh=EsRz4fXzI2RqIH7jjw097wilUKgxSt7V2D2NYyM0A9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HARmGaDSo1ZKEYwWgpVJAUEMjSHQ3njG+8085ZK2GLXkLd5jtygx8uXQgP3xD7bEwjCWVh2c8IGtA2UQcS+ka6j76AJMOdZOevuhwaQIcKsttloJ8m6/KApvVE3XUGO+LwwCNBjrM7PcSQ1MBTVRwl8Td3iw4/m/OrZqKPmOVbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQvu3QXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQvu3QXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0531F1F000E9;
	Wed, 20 May 2026 16:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294979;
	bh=+vjZl4Q3+uqStPYTf+ng6pRUqrJMs8vDP/JxTUHtg8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQvu3QXj7HX6G/FC+kvhyQDZmevQND1GaMYji3ssSkRMR99SMDnK1YUyjxB4o/7OW
	 Poz0rFYj+tliT91Hcy/sarmwy+HTy0bBhDbtMD+vrzTofts7Q/iGH/fqyw0mtb2YSu
	 s4pqMynsS6IiGL4PpduFZ4znrkraU+tJb9itrRn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0244/1146] PCI: imx6: Fix device node reference leak in imx_pcie_probe()
Date: Wed, 20 May 2026 18:08:14 +0200
Message-ID: <20260520162153.761374557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 3b55079d6387805ede687e234d84669aeb0f7e98 ]

In imx_pcie_probe(), of_parse_phandle() returns the device node pointer
with increased refcount. The pointer reference must be dropped by the
caller when it's no longer needed. However, imx_pcie_probe() doesn't drop
the reference, causing reference leak.

Fix this by using the __free(device_node) cleanup handler to drop the
reference when the function goes out of scope.

Fixes: 1df82ec46600 ("PCI: imx: Add workaround for e10728, IMX7d PCIe PLL failure")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Link: https://patch.msgid.link/20260124-pci_imx6-v2-1-acb8d5187683@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index e01a225cf3ab6..2aa5467d5400a 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1647,7 +1647,6 @@ static int imx_pcie_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct dw_pcie *pci;
 	struct imx_pcie *imx_pcie;
-	struct device_node *np;
 	struct device_node *node = dev->of_node;
 	int i, ret, domain;
 	u16 val;
@@ -1674,7 +1673,8 @@ static int imx_pcie_probe(struct platform_device *pdev)
 		pci->pp.ops = &imx_pcie_host_dw_pme_ops;
 
 	/* Find the PHY if one is defined, only imx7d uses it */
-	np = of_parse_phandle(node, "fsl,imx7d-pcie-phy", 0);
+	struct device_node *np __free(device_node) =
+		of_parse_phandle(node, "fsl,imx7d-pcie-phy", 0);
 	if (np) {
 		struct resource res;
 
-- 
2.53.0



