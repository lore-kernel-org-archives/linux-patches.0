Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA6269825;
	Tue,  8 Apr 2025 12:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114445; cv=none; b=CD8Tyak+PbfkxINXc4y3KcatE7g2gjdaPflMpatKtLVGwBivX4qbp0UnonV8ECOmoZ5MkZiIGiYfcxPcRFAS4gjgb8DiB9sl6bnVVeU6tb37YIxUi0Q2hjjRYQBP0vFQJfFf1ha1glbxNxEgRxKqAQ9DWc5JIv1fk6FlDYFllOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114445; c=relaxed/simple;
	bh=AOxgt+nlJst0oa1c/semfwCHOQX7qNYcMe4cc/3GUsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=il1zNDvSgrLJxxNGFSzdvi+VWRpmNTbUzh+WdGEHsD0C+OHEzZY2P77WxaHR3JBAZd3pfapuR2LiarS6tgyjzLazYYkZEaLWRtFEQ0fDN6VT6vKG4X4kNIsXnlydatXQWQ7nfJZEV07nr4bg3xJegPi4BzUEAjoYY/5ZWG4rd0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cn46Bm9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cn46Bm9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA90C4CEE7;
	Tue,  8 Apr 2025 12:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114444;
	bh=AOxgt+nlJst0oa1c/semfwCHOQX7qNYcMe4cc/3GUsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cn46Bm9Hb/o3DkZNvBFMsxZJVxtkWZpg/Yz3fR2DizUwlPPs9U8c+6VDAlD91Ee5P
	 VEEwqEqhCO15kPolEMi9zOOYBES4J9nzDr4OQNif/eS59V4W/BFm5YHIZ4mckoOOIg
	 mS9P4ay82r0ncCPivMo7rkJMnBqQThuRjqftiWh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 109/499] PCI: histb: Fix an error handling path in histb_pcie_probe()
Date: Tue,  8 Apr 2025 12:45:21 +0200
Message-ID: <20250408104853.924288033@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b36fb50701619efca5f5450b355d42575cf532ed ]

If an error occurs after a successful phy_init() call, then phy_exit()
should be called.

Add the missing call, as already done in the remove function.

Fixes: bbd11bddb398 ("PCI: hisi: Add HiSilicon STB SoC PCIe controller driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[kwilczynski: remove unnecessary hipcie->phy NULL check from
histb_pcie_probe() and squash a patch that removes similar NULL
check for hipcie-phy from histb_pcie_remove() from
https://lore.kernel.org/linux-pci/c369b5d25e17a44984ae5a889ccc28a59a0737f7.1742058005.git.christophe.jaillet@wanadoo.fr]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Link: https://lore.kernel.org/r/8301fc15cdea5d2dac21f57613e8e6922fb1ad95.1740854531.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-histb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-histb.c b/drivers/pci/controller/dwc/pcie-histb.c
index 615a0e3e6d7eb..1f2f4c28a9495 100644
--- a/drivers/pci/controller/dwc/pcie-histb.c
+++ b/drivers/pci/controller/dwc/pcie-histb.c
@@ -409,16 +409,21 @@ static int histb_pcie_probe(struct platform_device *pdev)
 	ret = histb_pcie_host_enable(pp);
 	if (ret) {
 		dev_err(dev, "failed to enable host\n");
-		return ret;
+		goto err_exit_phy;
 	}
 
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "failed to initialize host\n");
-		return ret;
+		goto err_exit_phy;
 	}
 
 	return 0;
+
+err_exit_phy:
+	phy_exit(hipcie->phy);
+
+	return ret;
 }
 
 static void histb_pcie_remove(struct platform_device *pdev)
@@ -427,8 +432,7 @@ static void histb_pcie_remove(struct platform_device *pdev)
 
 	histb_pcie_host_disable(hipcie);
 
-	if (hipcie->phy)
-		phy_exit(hipcie->phy);
+	phy_exit(hipcie->phy);
 }
 
 static const struct of_device_id histb_pcie_of_match[] = {
-- 
2.39.5



