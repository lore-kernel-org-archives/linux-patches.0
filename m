Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B225331220;
	Wed, 20 May 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298182; cv=none; b=tHcUcU8cW0Uu7OjABXuR53rKRlH73pYElCjSBUopFPKx0FZ+rHGIsFoFaVLopf3d6nMxWJk2DiPSiCqzf0dcub1I+bCkdF8pLRhGZNPsZwsj5JILLATxWzC3UxY2r8aI1w8F4OG8lVENsdiBE/DK9513GfIt1R9AHAwDNausDVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298182; c=relaxed/simple;
	bh=h8cjxhjkZvU1BSBs/UL4hAQ874T1GucsdepRAoMuPuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1dsCEBUeQiLYltN7zpV6+7QIx7AAUQUCnU8+08Uh9J2Cvo76Y9/7Nt91MRXQPwUEl9Tx0Geh3/JQolaJn01MbPTf2freAbPk2a78Of5H6p2XGkRO+hcUTbTsJdoLf9G7jXG/vilDtGfXiZl4yt2Ea8X4mpzBvSKBHRrxvk5/i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvEIBkMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvEIBkMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4CF1F000E9;
	Wed, 20 May 2026 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298181;
	bh=13mF9auGYGilW/s0h2Pq1vlEkww82tw97TnRNw1KEHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvEIBkMgZliEHvMEWtEMf3oZ7o0DqJDEFGotmaaz0pLCgDN7LErGSsG4Pl/z4gb0/
	 GX9TWyeHuR4T5EEwRDscZhTTb05Og++Ei82wz0ZUd2UFJhEwSVD8zALFcxIhjCUZni
	 DN5eeXrEKWlU2mvca+brLHD/gqquAmcfLaQLv9Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/957] PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found
Date: Wed, 20 May 2026 18:13:09 +0200
Message-ID: <20260520162141.167543470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 5573c44cb3fd01a9f62d569ae9ac870ef5f0e0ba ]

In mtk_pcie_setup_irq(), the IRQ domains are allocated before the
controller's IRQ is fetched. If the latter fails, the function
directly returns an error, without cleaning up the allocated domains.

Hence, reverse the order so that the IRQ domains are allocated after the
controller's IRQ is found.

This was flagged by Sashiko during a review of "[PATCH v6 0/7] PCI:
mediatek-gen3: add power control support".

Fixes: 814cceebba9b ("PCI: mediatek-gen3: Add INTx support")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://sashiko.dev/#/patchset/20260324052002.4072430-1-wenst%40chromium.org
Link: https://patch.msgid.link/20260324093542.18523-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index 75ddb8bee168f..e45c43ccc84c2 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -851,14 +851,14 @@ static int mtk_pcie_setup_irq(struct mtk_gen3_pcie *pcie)
 	struct platform_device *pdev = to_platform_device(dev);
 	int err;
 
-	err = mtk_pcie_init_irq_domains(pcie);
-	if (err)
-		return err;
-
 	pcie->irq = platform_get_irq(pdev, 0);
 	if (pcie->irq < 0)
 		return pcie->irq;
 
+	err = mtk_pcie_init_irq_domains(pcie);
+	if (err)
+		return err;
+
 	irq_set_chained_handler_and_data(pcie->irq, mtk_pcie_irq_handler, pcie);
 
 	return 0;
-- 
2.53.0



