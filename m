Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C219B3FF;
	Tue, 15 Oct 2024 11:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992848; cv=none; b=XUgWNvQxg67VQTr2ZES/HVcl1xbYD/Pse0azQ5nVt9zheP38VWCTEmheDSIQLDKEVDCpB+ABaN1qAbk833HuYT3oRN+AotbP+Kj7x+KVgtR9MfKSwDAWhTeVO2mtY7gwRMRWijmq1WCu/mSwiWJk+WPx1XnTFkJTa6FZ7rodhDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992848; c=relaxed/simple;
	bh=1BBd6EJ42SrOvOJsQskzihVmZGoPYIOV7RIjdU0P+ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTDAJUhPhIO55NPPCRRHo6Y0yGUvUrUCLngh64u5cfygV6IDsNvwLPj7lalXY/1AxBFm9cchjtuNrSw8O5WOAwlrQGjESxDwswDBq3ijm8LT6S9m62uQA797HX10vehLRoMfDtZQBwvs7FLuqB3KlDCTlAZwl6MjfgoE705qj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcBoftkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcBoftkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295BEC4CECF;
	Tue, 15 Oct 2024 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992845;
	bh=1BBd6EJ42SrOvOJsQskzihVmZGoPYIOV7RIjdU0P+ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UcBoftkDkiE7MQHjNxEfV16OhW+5i2SDr9jChl2QQozGR09aHHopAzlQNFE+A04KR
	 wS7iSJ9mjGhNfUPmnACIOUY2eaD5heqqeIKSh7x17LIO2FAEUBCkPKO3pzLfGe1/bz
	 5etyVrYR+TRM3ShP/AouDpepfxvAFHJep/wud1/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/691] PCI: xilinx-nwl: Clean up clock on probe failure/removal
Date: Tue, 15 Oct 2024 13:23:03 +0200
Message-ID: <20241015112449.684284630@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e1bcdd2e46484..280c569c5dcb0 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -808,6 +808,7 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pcie = pci_host_bridge_priv(bridge);
+	platform_set_drvdata(pdev, pcie);
 
 	pcie->dev = dev;
 	pcie->ecam_value = NWL_ECAM_VALUE_DEFAULT;
@@ -831,13 +832,13 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -847,11 +848,24 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -861,5 +875,6 @@ static struct platform_driver nwl_pcie_driver = {
 		.of_match_table = nwl_pcie_of_match,
 	},
 	.probe = nwl_pcie_probe,
+	.remove_new = nwl_pcie_remove,
 };
 builtin_platform_driver(nwl_pcie_driver);
-- 
2.43.0



