Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393F17B421;
	Wed, 23 Apr 2025 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421597; cv=none; b=WNqbkiUtoxiYNFdXxfIyjXA/wUDUezEzTx/nG6Lrs8hbQxVPHHDhBDgD81bduyzSj2mI7fXV2Gh1SuGtyGhBAqTnS8YO2avmeF84NuLDuINKI12/JLqgw86Jp8k/FMWQAhihQRkNJPegEdiw/4ZU4zx23BsvJHRSiSdoPUkhFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421597; c=relaxed/simple;
	bh=0GZXIhZNBoZ2LtgfzN76jZ2hamwEZDFvtN/AmUKRce4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFSEDgYXY86jFHR9H7iWxEF3WDMBJKLJlIx24IzlF1bU70UUVEOP4KzNiZYKcvN8kOypaYMrZJan29b9j6r1RoNHKu5T6u7Y6ds6OyqmGked3mG33be0zCSAFHBwJpDVmFAZm8Ydj5QlCb0T8ws77LPNVh3B9Krc8YSbT6jvEEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxc3ujUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxc3ujUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22C3C4CEE2;
	Wed, 23 Apr 2025 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421597;
	bh=0GZXIhZNBoZ2LtgfzN76jZ2hamwEZDFvtN/AmUKRce4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxc3ujUBatL5RWSVw3nrx9qlfmNVsQ2FqKm/TAt5czhxwoEUe4rcr4ktHcogRqnty
	 DMXsP6Pf58l6lTMg3Uuhh+vO/EG6i58zU4g/qm4gQWSdF1r1GWcXxL7vD9H0zTBcrt
	 g149aYsiJO22qOAwEC2xUWDO7kf5GMeFApTmkgyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.1 156/291] PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()
Date: Wed, 23 Apr 2025 16:42:25 +0200
Message-ID: <20250423142630.764177302@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

commit 2df181e1aea4628a8fd257f866026625d0519627 upstream.

A call to of_parse_phandle() is incrementing the refcount, and as such,
the of_node_put() must be called when the reference is no longer needed.

Thus, refactor the existing code and add a missing of_node_put() call
following the check to ensure that "msi_np" matches "pcie->np" and after
MSI initialization, but only if the MSI support is enabled system-wide.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 40ca1bf580ef ("PCI: brcmstb: Add MSI support")
Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250122222955.1752778-1-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-brcmstb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1488,7 +1488,7 @@ static struct pci_ops brcm7425_pcie_ops
 
 static int brcm_pcie_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *msi_np;
+	struct device_node *np = pdev->dev.of_node;
 	struct pci_host_bridge *bridge;
 	const struct pcie_cfg_data *data;
 	struct brcm_pcie *pcie;
@@ -1563,9 +1563,14 @@ static int brcm_pcie_probe(struct platfo
 		goto fail;
 	}
 
-	msi_np = of_parse_phandle(pcie->np, "msi-parent", 0);
-	if (pci_msi_enabled() && msi_np == pcie->np) {
-		ret = brcm_pcie_enable_msi(pcie);
+	if (pci_msi_enabled()) {
+		struct device_node *msi_np = of_parse_phandle(pcie->np, "msi-parent", 0);
+
+		if (msi_np == pcie->np)
+			ret = brcm_pcie_enable_msi(pcie);
+
+		of_node_put(msi_np);
+
 		if (ret) {
 			dev_err(pcie->dev, "probe of internal MSI failed");
 			goto fail;


