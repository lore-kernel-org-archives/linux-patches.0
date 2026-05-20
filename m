Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34873ED5C5;
	Wed, 20 May 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295375; cv=none; b=BqWJ2x0ErHjIda4wn9th32Rh1m3wPutcKvRXac8GWKeaJSQJYJds7y4zXY/zUdzosFJvUSM+1u/lLZ413q0vG5yOQ2VaRkxRCkuI0+6o6VDkWGecdUtA0V7t7YPyEVBkVcrrVcSJNrrs2V37ufAmP6bCocXSKU1DWmdNvFGjcY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295375; c=relaxed/simple;
	bh=mQtZIXL44/DMqijN/CjAAePOS+B/koJBuykGCnFdiYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcTL7J7kw8ZUgHC5QTBDo53mcfttXevUz0kyZPswpiB1V5EwQQ8uW2rAb0XwkSOaI94HyHwjP2mCnhCcQoBpLUSW6t4JxM8J5/auOLc/vSnWW5bzIZoqS3zMReYbYA4d/6Q1nRUTr9BBVArscT3WeQPNJAQtgKvZZMYiWo3eIzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFKGez4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFKGez4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230AC1F000E9;
	Wed, 20 May 2026 16:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295374;
	bh=UOuyeTL2XQH5nw2NABMKxXXOzXG+YC90AnJZe8l/T+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFKGez4RswTLsfgTMYnxCbWiVkxQCjTw1RJ21DgnQ5E3Vcb0YC8Bm7ocdBw1RF63t
	 dPfis5wjl4rP5W0RBOPkbx3bvPgSXzt2eaGC4ihCCoI7MBvexP1HRllhA7ZT1YZWcT
	 OfaDc3D96J9PqlXLcpW3dfKx3mEvJhGTdIGkbWp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0396/1146] PCI: mediatek-gen3: Prevent leaking IRQ domains when IRQ not found
Date: Wed, 20 May 2026 18:10:46 +0200
Message-ID: <20260520162157.161351331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



