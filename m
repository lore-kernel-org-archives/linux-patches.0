Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2281D0DC3;
	Wed,  2 Oct 2024 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878236; cv=none; b=kyPHOiigBCjsZeKcYkG3IyapxgAYEtI/WqJdPfGRX4VM2BkMimmcxzlc40cNzGPyX2cnAGVQDEk+73uP6JGNsCsNqu5GX5Wt9f4zCJsDuNxGeLip5qgzdBtQRX2cbn5OeG/N2OTTburv8Q9TUQu0FnDl/sg/2NiJZ4RDitFxBPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878236; c=relaxed/simple;
	bh=6imlpnFljCAzh84I/PMq15m7F2Tn6/bPyEXB8gXjf1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiDVf6Ov59AotL0CyvkRxVr+zEukDpkQw14/mRESfrxbI0IekIi6EajEqKjgMe7qAmgZz1Tt2CtKOnLDaj3air0WtCVBbgjNxGbsth+YuAXCb6CAKjypFTXFmqoSwb5SkIQtNaEeJNtHMsOygsF5RwMXmGx2Yl0yfHoEneml6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Reyovwmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Reyovwmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88985C4CECD;
	Wed,  2 Oct 2024 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878235;
	bh=6imlpnFljCAzh84I/PMq15m7F2Tn6/bPyEXB8gXjf1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Reyovwmnyq5WYddmX77U+75GH1IVcTpVkYEnS1MiznwYmAkAzPxnz/2whh3B8yJ3m
	 YxTlNftzt2WsMn0czTr077hyww2LDxdDN3fYOZBU+f0Y9dwXlBSPGzgj4Fwf5zGuuq
	 R9ynnH8dxCx5KcZtFV8oOkAt8qb2AcG2mi44DWV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 345/634] PCI: xilinx-nwl: Clean up clock on probe failure/removal
Date: Wed,  2 Oct 2024 14:57:25 +0200
Message-ID: <20241002125824.717713183@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit cfd67903977b13f63340a4eb5a1cc890994f2c62 ]

Make sure we turn off the clock on probe failure and device removal.

Fixes: de0a01f52966 ("PCI: xilinx-nwl: Enable the clock through CCF")
Link: https://lore.kernel.org/r/20240531161337.864994-6-sean.anderson@linux.dev
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index 1e15852153d6c..2f1bb2e8a840e 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -779,6 +779,7 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pcie = pci_host_bridge_priv(bridge);
+	platform_set_drvdata(pdev, pcie);
 
 	pcie->dev = dev;
 
@@ -801,13 +802,13 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 	err = nwl_pcie_bridge_init(pcie);
 	if (err) {
 		dev_err(dev, "HW Initialization failed\n");
-		return err;
+		goto err_clk;
 	}
 
 	err = nwl_pcie_init_irq_domain(pcie);
 	if (err) {
 		dev_err(dev, "Failed creating IRQ Domain\n");
-		return err;
+		goto err_clk;
 	}
 
 	bridge->sysdata = pcie;
@@ -817,11 +818,24 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		err = nwl_pcie_enable_msi(pcie);
 		if (err < 0) {
 			dev_err(dev, "failed to enable MSI support: %d\n", err);
-			return err;
+			goto err_clk;
 		}
 	}
 
-	return pci_host_probe(bridge);
+	err = pci_host_probe(bridge);
+	if (!err)
+		return 0;
+
+err_clk:
+	clk_disable_unprepare(pcie->clk);
+	return err;
+}
+
+static void nwl_pcie_remove(struct platform_device *pdev)
+{
+	struct nwl_pcie *pcie = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(pcie->clk);
 }
 
 static struct platform_driver nwl_pcie_driver = {
@@ -831,5 +845,6 @@ static struct platform_driver nwl_pcie_driver = {
 		.of_match_table = nwl_pcie_of_match,
 	},
 	.probe = nwl_pcie_probe,
+	.remove_new = nwl_pcie_remove,
 };
 builtin_platform_driver(nwl_pcie_driver);
-- 
2.43.0



