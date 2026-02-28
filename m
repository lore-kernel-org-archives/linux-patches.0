Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C5A34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301766; cv=none; b=GKo05t3EHx/MGPkMvdPf23xOVBoGBVnj6S4QPkW00+YPT32etloLxSl+IvV2lvmkzHNm/W6wTYq+h30pxbfdUPF4EUaYZQjxbo1ChSFp8RbYAN+dmGnTgsIcZ10aqSzljI0liPNYZLtbHOd4hQgvTurRp17ixiuKtL12Zb22RWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301766; c=relaxed/simple;
	bh=mquo9ek5NcVQfRhVzK9gQ4MozhK/NjFHAl+AA4lTr9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmCQokXYHPRxcVLjM/AFJXSufUIXrNSRRUk9nYTcOs0/XslWzLT8HFHfgbEGFhHZfDMSwX/hYkLhdBXyWlZEDDEaQ84psZllKhjtz5dldcdcop+WSq9vCc5du7SYXoyxLsOb8z7Q3Xl3Xzo6jMgmpH7xpsDlbJkWAvrv9F4vD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cs42hKfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cs42hKfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1959EC19424;
	Sat, 28 Feb 2026 18:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301766;
	bh=mquo9ek5NcVQfRhVzK9gQ4MozhK/NjFHAl+AA4lTr9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs42hKflJSDapOXuT5yD5gXssX0GqSMgMoD+/rofBBkViaTtIAATSDRzBhf+ajbxD
	 OiowmpzaSGsFHeYNYne0+mMs5b8tcu9q1EYbPjS4KPSZT2/+3HT6I823NU7J/XP5QX
	 j86FOm3LwPaliD2TXAQSxH7yqeBP2Nn4VEyw2uffjBmgZ037wh5gRK8RekqYWK3TF1
	 nRfMn4KY2L/+7UMsuC3xB0HDq+8x8PLDhr6fWG0k9LcqYI0yCgKgP0HXmF5FJFSv88
	 ltgJ9vxdpXGEqV7RNI0uFVYbc6DIBc1E4QUQECZML0bVskMGk76FyjMoD8gA4P/VIB
	 0fwaRNagu8Kig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/385] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Sat, 28 Feb 2026 12:56:35 -0500
Message-ID: <20260228180011.1568201-173-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 7f7d04c2ea573..c4cc9d76b42a0 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -579,8 +579,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
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

