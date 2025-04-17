Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C138462;
	Thu, 17 Apr 2025 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913748; cv=none; b=Osm3pSpBeFCW3zrd7KcakCHgyeVOWr/RGCZgwVJZ9VKjxGPI4XFNBcj9AWnKpwEvSWyBnGKUtuYM5r6eXrkrGJuFlcAlhvoVCYSE06VAmGPkjweErMzrPFX2sP+rGKfihQmM3rixnFZvwVIViiPZotj2Ypb/r1A8Uvxy9rFXkf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913748; c=relaxed/simple;
	bh=jmhP5z0WEJPgG0yz+7cTzquxfic+tmmsKVPoUu5viik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIJuVi5CW0Qk6nw0Mb/37ZVyvQN7CcqtnrSBW49gx0Dycs8KbU9tvyqD+FLsfsbZ3tBUf48HfH95x4GWJhJXhNexlV0HNU+qXIyZ4L7uUCoSYzCnwn4Sn4tkQ6bgIA9GSZ+yMo7fVme9meoP0UXy7IDPMPw6X/PybipWtAb5lGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fg37jD0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fg37jD0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA76C4CEE4;
	Thu, 17 Apr 2025 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913748;
	bh=jmhP5z0WEJPgG0yz+7cTzquxfic+tmmsKVPoUu5viik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fg37jD0yuooS8Ftl23rHRvs+95L/gHNsv9WGls1kezepniddD32g7uMFZgWzrEQHa
	 y+TzWwXUXNws/PIcaY97qJeqeus8sZRJR4Gql2bpIaCMJ3/+Dssrr+dgoaQ/vSllo7
	 1ckl+tdyUqjPk6q8xAmYsOafIvYADBMImOQxojBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.14 423/449] PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()
Date: Thu, 17 Apr 2025 19:51:51 +0200
Message-ID: <20250417175135.317541971@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

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


