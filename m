Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CDA346E66
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302112; cv=none; b=ousFSd4mUfV7x8xwioXMoEJomqlly7kDTLQxSXjiZIKLOilnOij549+YAw3siW7+/pvT8OVD0+H7OMSsEEA1sz5PFW0E6cJxBR0j5XW45OCmJBiFzOjZ0R0O340Z1gqHZrXfDlwq2X8ttDShYJYJi40/2cw0rE59QVFHFcHCj4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302112; c=relaxed/simple;
	bh=eTEdybmVyh4YSnH0nWc2J+06Viji9ODcThhvzPdPsdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEuEDtoY9bl6tGW+jTX+QuLdDsMgJNLn1uNfzpfhhQvUq0w6QrCtTl+iaIGUE6mbegHzP6F3MtD4Db/zz9SE5oQ2oY30gi61kucpxKF19UKeAQ2V1M7NB1KzgGSZYm/gPodwNnGiNwq/meDw3i1sct99L2CcgbeOMkdd6/81tNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyUZILkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyUZILkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2017C19423;
	Sat, 28 Feb 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302112;
	bh=eTEdybmVyh4YSnH0nWc2J+06Viji9ODcThhvzPdPsdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TyUZILkBOwga9zyiMiMp9Z87odwk6PMfw4cPhdJbdy04HLp+f+WcufcacgurAeuQn
	 lnP+MZWU/VYq+er0Z8hE3l0tQB5ndngOT4IqkTmLeo5Lv8B56qBymCTZZ6yfyHE5kP
	 x3heriuZLtqLvT9v8+Zwa003Bbc4rQlZRZKk8EQbXX9md8Khd+kFSTea7h8S7/oqMA
	 F2OwGIISzPjveoLevo2+cSo9UiVG52nWgUKsSIqEwxts24XFKO5v1muGTOP3Ed78Rl
	 VORlM537pdfBdqjeGwF3MT4nlR8KLI4Ou10T8G4BqA/XNyp5E7IifRjmT5EyEYeJnj
	 kDIZgkqVzkzKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/283] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Sat, 28 Feb 2026 13:04:03 -0500
Message-ID: <20260228180709.1583486-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 48372013f26d2..82e575e4d3877 100644
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

