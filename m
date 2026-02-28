Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E56346FDB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302361; cv=none; b=qbYFuQjrQ9L7+quHWinkR83u46PdIrZnho6FR8E+4lrxIJ6IRLZnvF8KaoLNgzgjwpA/NjuK49ozUf+RuGjqJdXFSlqTTNN9GnI1iSZB2lqIz4j75/EXJoniM4eBfe/B8OQkk5CJu5IKu6tlTaE4Dk1uQm5XUG74bCkSL6oUrtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302361; c=relaxed/simple;
	bh=58pXLN1/QObjqIk7n1w5I1TeBu/by+t323+X8kwPaiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLAXFu4iIzJda9FL6Mhc49pwOeY9rpaAwl+gGeZJogLAYbgq1vqFreVnsl8wK9tYk+m97YrWTwZcbPFq8/ITn4+A+4dSX19SIz4+nkUHsaF5EuKHRmLfAH1NzT6fOYBnvvxt+gnVMFQXTxw/4gZRNGlf8mvnisiNnZEF5+0nJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZ9WaURH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZ9WaURH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BB9C19423;
	Sat, 28 Feb 2026 18:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302361;
	bh=58pXLN1/QObjqIk7n1w5I1TeBu/by+t323+X8kwPaiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ9WaURHauQs5Jkptlr2o8LGWb56rwQf7VjgEUlEP9tc3yOfXrzn0YKRQcDW4WnvO
	 aDy4fYqGsQj/k1jAAszg3hcmNkMHscxP7Npylk0Lxn7+2pnoSX2osg4VhZJ2cG3XOq
	 tw2KjhAY95E+6MwVaiELQKkh4Sy47iebfWqKrrQkivTsyfn+CBjvZO2PSMk++J56aG
	 AXrrx3sB8A66eTVviuJSA6eVHKe+xBiNC5KURH0A4cV+eEbXkcbdao6by4UEdlPq0c
	 UW/T7jiErGDfyLtV3HVopW17r6HuY0fVM+mD9edjMbfcdaNf8T3feheSpI9oRUiGDE
	 QCNFtTZmkbTOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/232] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Sat, 28 Feb 2026 13:09:01 -0500
Message-ID: <20260228181127.1592657-88-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 7f0cdcddf8bef1c8c18f9be6708073fd3790a20f ]

In mtk_pcie_init_irq_domain(), if mtk_pcie_allocate_msi_domains()
fails after port->irq_domain has been successfully created via
irq_domain_create_linear(), the function returns directly without
cleaning up the allocated IRQ domain, resulting in a resource leak.

Add irq_domain_remove() call in the error path to properly release the
INTx IRQ domain before returning the error.

Fixes: 43e6409db64d ("PCI: mediatek: Add MSI support for MT2712 and MT7622")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251119023308.476-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek.c b/drivers/pci/controller/pcie-mediatek.c
index 11bdef206d120..03ac5df9bb129 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -587,8 +587,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		ret = mtk_pcie_allocate_msi_domains(port);
-		if (ret)
+		if (ret) {
+			irq_domain_remove(port->irq_domain);
 			return ret;
+		}
 	}
 
 	return 0;
-- 
2.51.0

