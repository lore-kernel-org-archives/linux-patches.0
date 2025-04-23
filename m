Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845AB29AB18;
	Wed, 23 Apr 2025 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421807; cv=none; b=q0OQN35a5+MGXFhnJKmB3bEabpz/zjzjRjigxw2XiH0cOM1FkcG2D2KnrU6nHjp8Wn2hto46wQKwam73ztN3tGPfubv7NsccINHkIgjQ/UxSOjFBVmtaWMQjo4xSP4Gg9JxwBxVf2OSL0uU7iWrhOB8M9h9jA9J017jQs+213+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421807; c=relaxed/simple;
	bh=tzHoeuz81eI1MsvulYa3NUphf8CdfCTu7NT/dP9DgEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bkqWM/TBfGloxjjFurv1nVmJg7h6/1bybakwFfcAfrA7GW8hieDY6ibmKa9SIdp2Q2A1A1bFx3zYYijLBhvjX0dQ4S+ZF9TltxZ7+nApQHaQG4YSAIrnazDSMJiHQcdhivJsHyLTzt6rvZRjAnnpmD+ABgpT1UOlpzkqZuEcBTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFfqXD5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFfqXD5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F0EC4CEE3;
	Wed, 23 Apr 2025 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421807;
	bh=tzHoeuz81eI1MsvulYa3NUphf8CdfCTu7NT/dP9DgEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tFfqXD5xeqFSHk1kB93ttR4ewcErrB/uDnwafFpXV5DrYrpihT1wPzcTHPFKRh+O9
	 dn6V4+HGwGrzxUApoRU6qn5ARn4kIFlzSqczKf7rXgOEWWcFvBJSMQT7yk3zAE28T8
	 4rSkFO4Ejk/NmEfEx4ArmxerfksnkDaHk69Nfy6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.6 226/393] PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()
Date: Wed, 23 Apr 2025 16:42:02 +0200
Message-ID: <20250423142652.725884922@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1501,7 +1501,7 @@ static struct pci_ops brcm7425_pcie_ops
 
 static int brcm_pcie_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *msi_np;
+	struct device_node *np = pdev->dev.of_node;
 	struct pci_host_bridge *bridge;
 	const struct pcie_cfg_data *data;
 	struct brcm_pcie *pcie;
@@ -1576,9 +1576,14 @@ static int brcm_pcie_probe(struct platfo
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


