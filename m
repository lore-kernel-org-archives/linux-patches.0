Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF0A37C0E2;
	Sat, 12 Sep 2026 07:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197721; cv=none; b=QR1dErKy7++SUf4WQm1+/Yp23XlEh1PMZpLuBkoLIIqku36yCfTF/kR6IiyofPN+sOlR/1PGpMIyTJPzXTVvPDhnzeAmvoY546qyb5zUgzZxIA1Ai7NRAQa3vT0PiBrxGie/sUbl6NGJ/G2uaFA3UzmpTHANCXmRwMOcK6ipS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197721; c=relaxed/simple;
	bh=LUarm1Nr7npSJZMHznl4PZn3YqzW96h5NgCdffa5+tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks7teEcaH2hZNQ3DDsF9lJOiAROkOX29d16h1QpikMAqQrCyhDRTN6QjhRQZsTPVvewwJwg07galmXuDwYJsC3FHBo+xcwuDmt+dJbgr5J/6MVWW3a4mD4XzrnhG77cU5HScGLYny/vS5b9sqLnEiKP2jPfTjjLofZFMD/wJu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JIsM9mY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JIsM9mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FE41F000FF;
	Sat, 12 Sep 2026 07:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197719;
	bh=Vq+dDX65bygIZhDxX0MrSDhE0r5qmuDk3qMWFZ7VR7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JIsM9mYbhEnNR6cfuISvlsdaAXmsidsnToPSxFJyUcSiuKT6EEAbSJgSp9LML+ek
	 MPPmG+3CTJgw6Je9UHzjHuo/+tpEmJjH3Jdq1cFeA8itkjMTJb33I5Q8eDjNHFwhWR
	 HEpn7mzIg14dfnMk+SNlmQBLXAk2g8uHG/1S1C+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0226/1815] PCI: qcom: Skip PERST# GPIOs provided by downstream PCIe devices
Date: Sat, 12 Sep 2026 08:32:56 +0200
Message-ID: <20260912065654.298260059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 3edb3a038d423480efeb204dbc6ddc9a292f8ecb ]

Currently, the pcie-qcom driver recursively parses the PERST# GPIO from all
child nodes defined in DT and acquires them. But this creates issues with
PERST# GPIO provided by one of the child devices like the PCIe switch port.
In this case, the RC driver cannot acquire the PERST# GPIO since it will be
provided by the child PCIe device which was not yet enumerated during RC
driver probe.

Fix this by checking if the GPIO provider is a child of the RC's DT node
(i.e., sits behind this PCIe controller). If so, skip it, as PERST#
should be controlled by the respective PCIe client driver implementation.
GPIOs provided by external GPIO controllers (e.g., TLMM in Qcom SoCs)
continue to be handled normally.

Fixes: 2fd60a2edb83 ("PCI: qcom: Parse PERST# from all PCIe bridge nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260616-pci-qcom-perst-fix-v1-1-27600d6ae357@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index d8eb52857f69c..d62cf302de2b8 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1820,6 +1820,23 @@ static const struct pci_ecam_ops pci_qcom_ecam_ops = {
 	}
 };
 
+/* Check if @node is a child of @dev in DT */
+static bool qcom_pcie_is_child_node(struct device *dev,
+				    struct device_node *node)
+{
+	struct device_node *parent;
+
+	for (parent = of_get_parent(node); parent;
+	     parent = of_get_next_parent(parent)) {
+		if (parent == dev->of_node) {
+			of_node_put(parent);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /* Parse PERST# from all nodes in depth first manner starting from @np */
 static int qcom_pcie_parse_perst(struct qcom_pcie *pcie,
 				 struct qcom_pcie_port *port,
@@ -1827,6 +1844,7 @@ static int qcom_pcie_parse_perst(struct qcom_pcie *pcie,
 {
 	struct device *dev = pcie->pci->dev;
 	struct qcom_pcie_perst *perst;
+	struct device_node *gpio_np;
 	struct gpio_desc *reset;
 	int ret;
 
@@ -1840,6 +1858,25 @@ static int qcom_pcie_parse_perst(struct qcom_pcie *pcie,
 	if (!of_find_property(np, "reset-gpios", NULL))
 		goto parse_child_node;
 
+	/*
+	 * Skip GPIOs provided by a PCIe device which is a child of the Root
+	 * Complex (e.g., a PCIe switch with GPIO controller capability). Such
+	 * controllers won't be available at RC probe time and their PERST#
+	 * should be controlled by the respective PCI client driver
+	 * implementation.
+	 */
+	gpio_np = of_parse_phandle(np, "reset-gpios", 0);
+	if (!gpio_np) {
+		dev_err(dev, "Failed to parse GPIO provider\n");
+		return -EINVAL;
+	}
+
+	if (qcom_pcie_is_child_node(dev, gpio_np)) {
+		of_node_put(gpio_np);
+		goto parse_child_node;
+	}
+	of_node_put(gpio_np);
+
 	reset = devm_fwnode_gpiod_get(dev, of_fwnode_handle(np), "reset",
 				      GPIOD_OUT_HIGH, "PERST#");
 	if (IS_ERR(reset)) {
-- 
2.53.0



