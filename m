Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013E1CAA81;
	Thu, 17 Apr 2025 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913782; cv=none; b=MOnTqNd7hwQh85wETZezSKTon0C4SSrQh51jTbgmXN58iwgiAXNMOa2fGG69Hk5XAo6hDVeqzgjZqAnEgx0/Rr5/p5X0jArSkIVc/fx0Nh3uMjuXwNtxr7L+nMX06N3tgmnoXSJ0cPp0nFqJXZrKbyItY3P1RuSbrEBANKstDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913782; c=relaxed/simple;
	bh=TXZUZglPqvWu+04A95GLMWB7MaEUtXxMNIkJ3HPLOas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDqegjUuGwc3SmkzS4kOP6CA3Xdg4mCjfBR8ofcVhUJ8rWpQiERcFAzrBXeRDSZ/b2t2MtJ7MIEfxRPO95rYmTaaY4qM2qgQOgT90DZlKugNm1s9CP0m8EYy3UXB9UQkHTD4xO+qvGLWfhTu6QOz8x0KWpoOA0RglHWl91ImFwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD6+Vr+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD6+Vr+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94847C4CEE4;
	Thu, 17 Apr 2025 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913782;
	bh=TXZUZglPqvWu+04A95GLMWB7MaEUtXxMNIkJ3HPLOas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BD6+Vr+c2czEaTHWquyO9RojEpkuRdwe6ZhF+OfHFqbqXwQVv1He4veR4g3FIjleG
	 yBd74j6paWOTmAn+dUZsncv2pgmDi4+v7XNYDV1Wv5VsiXs1C97VoBQtA1iXFmVEw5
	 TPI+cs1PQS1M8xABwzJ2sLuDUhIxAYwiUnSqCK3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Roy Zang <Roy.Zang@nxp.com>
Subject: [PATCH 6.14 425/449] PCI: layerscape: Fix arg_count to syscon_regmap_lookup_by_phandle_args()
Date: Thu, 17 Apr 2025 19:51:53 +0200
Message-ID: <20250417175135.400591002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

commit 4c8c0ffd41d16cf08ccb0d3626beb54adfe5450a upstream.

The arg_count parameter to syscon_regmap_lookup_by_phandle_args()
represents the number of argument cells following the phandle. In this
case, the number of arguments should be 1 instead of 2 since the dt
property looks like this:

  fsl,pcie-scfg = <&scfg 0>;

Without this fix, layerscape-pcie fails with the following message on
LS1043A:

  OF: /soc/pcie@3500000: phandle scfg@1570000 needs 2, found 1
  layerscape-pcie 3500000.pcie: No syscfg phandle specified
  layerscape-pcie 3500000.pcie: probe with driver layerscape-pcie failed with error -22

Link: https://lore.kernel.org/r/20250327151949.2765193-1-ioana.ciornei@nxp.com
Fixes: 149fc35734e5 ("PCI: layerscape: Use syscon_regmap_lookup_by_phandle_args")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Roy Zang <Roy.Zang@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-layerscape.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-layerscape.c b/drivers/pci/controller/dwc/pci-layerscape.c
index 239a05b36e8e..a44b5c256d6e 100644
--- a/drivers/pci/controller/dwc/pci-layerscape.c
+++ b/drivers/pci/controller/dwc/pci-layerscape.c
@@ -356,7 +356,7 @@ static int ls_pcie_probe(struct platform_device *pdev)
 	if (pcie->drvdata->scfg_support) {
 		pcie->scfg =
 			syscon_regmap_lookup_by_phandle_args(dev->of_node,
-							     "fsl,pcie-scfg", 2,
+							     "fsl,pcie-scfg", 1,
 							     index);
 		if (IS_ERR(pcie->scfg)) {
 			dev_err(dev, "No syscfg phandle specified\n");
-- 
2.49.0



