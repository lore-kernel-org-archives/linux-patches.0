Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A939B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302555; cv=none; b=QhS2oOhIBLOAhdGOrcczlYd39LbifVjOioB2pr7cha8U1YbVq5DDf/q563kq8bzso7g/uiHPMkEF1NHsRGQaU/vYag7KLe7llPBnr/3TddO2apc7aC7uoaYuPz2R2vsOftSp6OlszSTgzwOuSblT4cbHUb7weKW+3NQN7pq/kR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302555; c=relaxed/simple;
	bh=OIo5NQZu9DuP+f03A0u3A1v4kyTCFCCojTQQE2w/eEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuTpl6s1kalLJdNzAPAmF2SKOpLFZ7MNw52NIL8TLOq+S7F3tAmNDUBiEXaPGU+D+f6PTuuKhJAn9Z/ZM5gm6NW0WicpI8zlQjAZQXT8+fNzBTGOauDIMZV9x2JNohBVDWLnw6109q4NAqEJZfW363WEAUAZPpXtmV6mNqEeu3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORmD8qd7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORmD8qd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912AFC116D0;
	Sat, 28 Feb 2026 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302555;
	bh=OIo5NQZu9DuP+f03A0u3A1v4kyTCFCCojTQQE2w/eEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORmD8qd7KmrTSqVOw6i7SSurEDydmOT0K01yKqKQBRyP5VAyyElqFt1FDTwRncvaj
	 RupHWjVJCUj+EF9xADrF1dj9a3AcmcaWzFFRcESdp7sqmkS8boZAQ45NZs8u5Y2AiI
	 kW2jFn+kGKTAvjaLpxqi9fhYVtLmpDbnRZArnyjn2wvWo8amtk4pmrfBMoklUqaFoL
	 dW0A1uz5Gt56zM8IA/tFhvqAT0XBLs//LVu4WQldJ7Dmiz+DkDH8eVsn4lRuP2cK3g
	 iREdv527pO60lFpUuHYGV++Ebysq1XdxxAiL8dYroPhIqSQWgDJicIIVO+CUwJMnl6
	 gMyjX+uTowA9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/164] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Sat, 28 Feb 2026 13:13:18 -0500
Message-ID: <20260228181505.1600663-59-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 3200d776e34d8..787783345129f 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -594,8 +594,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
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

