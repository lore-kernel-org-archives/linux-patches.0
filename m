Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47A01E2834;
	Wed, 25 Feb 2026 01:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983162; cv=none; b=bj+cIl2D5IVyj0brIln9sCFMgQDF6FoLtwCmISdsEu8G+88mvySQIoF0cxAZ8FcHwByRkUYAQr6z32ulVtj/ojUwenENQVfJLA3gi/yeLimHQJ6Sc1VwwONuw7QPZbNY/qM6slrqiQYeW3AaDOy15z8bIa5H4ZcoA+svy1RbeW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983162; c=relaxed/simple;
	bh=ltHw5KYznlgJK6QfsK+dypzk7ri8WwgbHHSzbYRspT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avhZUXZbdcX+7j2RzIRmhVXY1in7rdTUCJfNTaGOyBgwUEU885ZnUQTx/l13FYU0gcrrB/HfX4Ooisul5byqUzTp7qeOEaIy/Fy3KSUei1zof2d11nZazBLi3i+XYmpxNJ8qIph5fXblkU0vYq39FUDTianwJ1a7e0IZxA7UPHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXzLhOaS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXzLhOaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1C3C116D0;
	Wed, 25 Feb 2026 01:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983161;
	bh=ltHw5KYznlgJK6QfsK+dypzk7ri8WwgbHHSzbYRspT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXzLhOaS4JDJ2Zxsi25bo1iDOKLV6QmFCsWMATkcBJL6bJUR5t8TyDQue23B/qPU8
	 x78nlvedM/2E2BmEvv62swgxnE9HKAPbKR5WWWOraZhWVPooSm5apV1qiYmeJBLyhg
	 M70AOoHY+vV4diNN2HKB0P1K03M7RoBiCu+sqpQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 315/781] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Tue, 24 Feb 2026 17:17:04 -0800
Message-ID: <20260225012407.427464850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4b78b6528f9fd..5defa5cc4c2bd 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -585,8 +585,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
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



