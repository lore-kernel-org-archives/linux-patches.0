Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265C62571DC;
	Thu, 17 Apr 2025 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916157; cv=none; b=guDjIHdjQPBShqxKgdxw7eRAwSUnWIPL43xMCyT8c3VIrZE1wcef3k5hrT/WtRwQkcWDC1/h7mDHXEryqb3Y4wgkLPF1OxLNttDTWku0zWEuuJkcbQ4v9EMhLyLeesKQgsVE/PpIO+vTTJRt/hKEqg0n6KLxFxzz5tRleSGJeKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916157; c=relaxed/simple;
	bh=k4oyq1wbMmxio7zz0v8iqdO7eaNI/VpQOlYSADF0E9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObmB/Oxx8tWT1t2PKu+dogdrrFJjsd4ZxM/za3emeH2fv3d2HMGqlwk4MMzqaTaiHAXAv4dxOoa6oNcbR60B3R4xcCry3qeazIyuxrRZCewkSccAE7M222VWFV59Ja7+nkeWyaaGuQT4cxGmoXpP44FSc8iOoP7z6g6ZUpAS0Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IEg3HoqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IEg3HoqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952D7C4CEEA;
	Thu, 17 Apr 2025 18:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916157;
	bh=k4oyq1wbMmxio7zz0v8iqdO7eaNI/VpQOlYSADF0E9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IEg3HoqWWF7Ya1Wde8eDY5IkNf+Amf4t0VzntAhDZiwKs76tuRvqhOKywCUDrrd2e
	 FA0MrmymkFDnXT7oKTHsRAf+wXPXOCn8SRC/hqrwspaFl+t9Fv3mf1nPSeDUWYZAoB
	 79/orOUGsBaCxuzw+bT02eg5C6JCA3+p9hgV9D+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 362/393] PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()
Date: Thu, 17 Apr 2025 19:52:51 +0200
Message-ID: <20250417175122.160521722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1786,7 +1786,7 @@ static struct pci_ops brcm7425_pcie_ops
 
 static int brcm_pcie_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *msi_np;
+	struct device_node *np = pdev->dev.of_node;
 	struct pci_host_bridge *bridge;
 	const struct pcie_cfg_data *data;
 	struct brcm_pcie *pcie;
@@ -1890,9 +1890,14 @@ static int brcm_pcie_probe(struct platfo
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


