Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05CA35AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302703; cv=none; b=HiFXUru0fDlW+Yk83rPJnQ5v0WrD88d/OD7Pbd/ipec53sW2SZ3om/+yx8FGvmFMPKIDOxWQj1ZF/fZcbeuQmN5OTbCPpAJyNOgbK4dnOskoEw4RZ94XhnRgmyBLkwVHvChbkWu2nq+1o0xRlMqYOQOlbOgqMufZFHSFMez7AEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302703; c=relaxed/simple;
	bh=Mp9BNF6AFda0ln1i3C7NqOEwFrr1haYCQwFlJgPOHck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC0HuVaLb+vChzvYMsQI68WAVymh7tMWWBMMONLm3AMLsd2bmy/LtpU25Qudba+IHma2iS5DNgHeI1YmY1aC5YIQW8kpVU1KFfSpRm0CNEX77yVb79/X5642+SCuECQK5OZiChm4hR6bbIrij+byUad+KQlLIkQnv21vtli3ilM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqtBWozA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqtBWozA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EC4C116D0;
	Sat, 28 Feb 2026 18:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302703;
	bh=Mp9BNF6AFda0ln1i3C7NqOEwFrr1haYCQwFlJgPOHck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqtBWozAJZoBIVNoTlRiONImVdF5w45OVwHkOS0AKSnqy6a65YiH0H/XILTnTjsnI
	 TEIXYXGfdgpit5pjE0WScskE20aUz/e7wZ8wuDBbVJ6DvtzDztIDYHaW1df6Fg9fxJ
	 LzqY9gw4zBiYNfyFPaK1Yn8/6RB21+Uc0Si9fwqiB1dxfvSxYfX9nCzf/k/rwEo77A
	 G6YIqJzZa/QKjhyZ49UlOGbU4ua5XrMV4P0++HP3wZ0DPFsjTeGGT1wh2+loXMTrG6
	 ZSnMQxXTpRjMwR0ujJenVqIzsJR/TD5whOtAR59ccRO5nZGdSTGvlUt61bg/3sZRwy
	 teZY91HZfExHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/147] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Sat, 28 Feb 2026 13:16:08 -0500
Message-ID: <20260228181736.1605592-60-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index ea91d63c8be15..bab962ec7ab46 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -588,8 +588,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
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

