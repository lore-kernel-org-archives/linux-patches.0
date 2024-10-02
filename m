Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385F91D094C;
	Wed,  2 Oct 2024 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879957; cv=none; b=MmGO6wJLIV1YVOPvsg1BMHdg8Tm4cmFEBKZCUe8AVGXE0mYQ5kdjeMQtBppOdBcvkAKU9PV+CAda6nX1dmPs+Wg7DWcrhi8hgz4P0N8CowgTXbgRb/rFSjtQMWNRkmWTxrQrMyx5EqnTq93lHnJw69TPddvPDiv6OczwWzfaA5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879957; c=relaxed/simple;
	bh=S4RAIihjn5XDOk9NUrMeSVnbT6Wx5awTp5jazXEPtTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+1BGe5Pcz4DjAV0G7Os7bQCm0pIaMkqFQChX+vWyjxf3OtSGTTP47UUdBeE5/Ky35On0ij5SzYHBRwe8o+dz3J3jGaWnNCSIRTBABFQyM6cy3GuZwhFRuZQ2vD/JFLAldjniirN8zhI6p/KTQhhHK1nXld6zHWUjODyKDTqSNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rt64KUuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rt64KUuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B350FC4CEC2;
	Wed,  2 Oct 2024 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879957;
	bh=S4RAIihjn5XDOk9NUrMeSVnbT6Wx5awTp5jazXEPtTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rt64KUuC6IJKYm1xuTwUUw7i05pzHyAKO/AISlA+h8UhWnNMR+BXuAeX9fLhSJ2s5
	 Y7PSXjQf3pzINrl63WVPAD0K0PyfHhUtNDL9NkctUbAiGpzcSg5EWPooiYukngBUvO
	 y+gBqY4ZimyNgZvhh8DnWaVTQRM8vZsYfUhXDWhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/538] PCI: xilinx-nwl: Clean up clock on probe failure/removal
Date: Wed,  2 Oct 2024 14:58:53 +0200
Message-ID: <20241002125803.863321837@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7cf05431d54bc..60afbb51511c3 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -790,6 +790,7 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pcie = pci_host_bridge_priv(bridge);
+	platform_set_drvdata(pdev, pcie);
 
 	pcie->dev = dev;
 	pcie->ecam_value = NWL_ECAM_VALUE_DEFAULT;
@@ -813,13 +814,13 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -829,11 +830,24 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -843,5 +857,6 @@ static struct platform_driver nwl_pcie_driver = {
 		.of_match_table = nwl_pcie_of_match,
 	},
 	.probe = nwl_pcie_probe,
+	.remove_new = nwl_pcie_remove,
 };
 builtin_platform_driver(nwl_pcie_driver);
-- 
2.43.0



