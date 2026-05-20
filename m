Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBAD36CE19;
	Wed, 20 May 2026 17:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297866; cv=none; b=hQCU/xDmjsWhyXEP2RUWBg2XUA9cxnAURm9zMvAw2kFL3hGmezhyWyPaagxVm97UTLlT17G5NFZ3mrzQOOSNG2SH08TEYl59+juaNQ+w3qtSMXr2l5QwWY8V3zGzkuiL4K75TXhZar6L5BblOgVvfjnnQzMUBlaihfhxA88vexQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297866; c=relaxed/simple;
	bh=Qru+fkONUPKf38FdsQ8rnMBKCy5RzAa5nx8bjc/XEnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRYXI3ErCYojfDEFTNzIAbbdeQP5phCgKk9KKyR6QonSzzaQB6Ba7mTMwk2TebA7SVc1GLvJSS1SuduQkK/dKYuSuoqVwC1VDtIX9vYY94KdsR7lA7qMIE9/z7Y8nkxnWCJbaybpLJMsUQrnIxsDu8abw0wZgXmpCFkC9oHgk/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8wtySW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8wtySW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E62E1F000E9;
	Wed, 20 May 2026 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297864;
	bh=VnAuzWBG2w4PdbczMkkRHPe7A2Ckxp+DWKLOKj/S1Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8wtySW4thVkwz/u1s55MRmt36yFzAdn5CsNd3z5ckJpurtpZQEh8aBSx5EVPNVJo
	 6RgdRSnnAQP/nBI/WktO9z9meDPYrpqoJPRXJeRTSF8pZdQAabfK3ceadRuVjCjzru
	 wzKQunDS5f1oc/D/ukCSvVRgOlLfuFAIK8OhKSUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/957] PCI: imx6: Fix device node reference leak in imx_pcie_probe()
Date: Wed, 20 May 2026 18:11:16 +0200
Message-ID: <20260520162138.736786488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3984c16dbec39..9083658a4287f 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1619,7 +1619,6 @@ static int imx_pcie_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct dw_pcie *pci;
 	struct imx_pcie *imx_pcie;
-	struct device_node *np;
 	struct device_node *node = dev->of_node;
 	int ret, domain;
 	u16 val;
@@ -1646,7 +1645,8 @@ static int imx_pcie_probe(struct platform_device *pdev)
 		pci->pp.ops = &imx_pcie_host_dw_pme_ops;
 
 	/* Find the PHY if one is defined, only imx7d uses it */
-	np = of_parse_phandle(node, "fsl,imx7d-pcie-phy", 0);
+	struct device_node *np __free(device_node) =
+		of_parse_phandle(node, "fsl,imx7d-pcie-phy", 0);
 	if (np) {
 		struct resource res;
 
-- 
2.53.0



