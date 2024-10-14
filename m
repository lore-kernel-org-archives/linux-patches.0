Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD111C304F;
	Mon, 14 Oct 2024 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918039; cv=none; b=Rjz+e99uWdvRAVRmkR5gYF7PU2taLI23ioZjehFJmk+e/hr0zz4nQltny8zIWxRPnakIpdlrF3F3OCM59qDkrUrp1LPnIqy1ylansvmo3DV4UURauu2xxZIHo8RorjAL6kNA7/6izSYO+iyw2sXlQOZrVFkjoVGVnw/J7WZ8TEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918039; c=relaxed/simple;
	bh=V2tEPP7ZMb8LnYpF6wEcwFaVdKFWIc92AgfLx67bYWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EknjpbKgq01CuqmEp+qf9LcHcqlDjMXmwShRruc4U9rIYEdhjBPzd4hWWqXOyoislzgOLOu2ZELIQkp7GYzKtDWzJpvY7/cq2Ls9Y+fh2mpLiJ48MAY6b+F3IZBbZBHuHJVclPXLiN/m5eyDvdg+lpUdN6Oa1fEKM9i/x7FiYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNg/7obb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNg/7obb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B488EC4CEC3;
	Mon, 14 Oct 2024 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918039;
	bh=V2tEPP7ZMb8LnYpF6wEcwFaVdKFWIc92AgfLx67bYWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNg/7obbBMVpGNgwDl7wD3dw+Tn6az9riwEVf2zq5CuM67NCM3ZvTkul1MlvPTHFr
	 ibfEwqodONgk4/eWrEa3w3qOZv8rqRCLFaBFlhnDvUj7x6Xs0qeJ0VSuwT22qqpraT
	 oyaXUxT0z2WoTRg3QZpMPPgRJd8RWjk+cFRmJiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/798] PCI: xilinx-nwl: Clean up clock on probe failure/removal
Date: Mon, 14 Oct 2024 16:12:39 +0200
Message-ID: <20241014141225.979336226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 18c6519e7d1da..0311fed2a25e2 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -792,6 +792,7 @@ static int nwl_pcie_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pcie = pci_host_bridge_priv(bridge);
+	platform_set_drvdata(pdev, pcie);
 
 	pcie->dev = dev;
 	pcie->ecam_value = NWL_ECAM_VALUE_DEFAULT;
@@ -815,13 +816,13 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -831,11 +832,24 @@ static int nwl_pcie_probe(struct platform_device *pdev)
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
@@ -845,5 +859,6 @@ static struct platform_driver nwl_pcie_driver = {
 		.of_match_table = nwl_pcie_of_match,
 	},
 	.probe = nwl_pcie_probe,
+	.remove_new = nwl_pcie_remove,
 };
 builtin_platform_driver(nwl_pcie_driver);
-- 
2.43.0



