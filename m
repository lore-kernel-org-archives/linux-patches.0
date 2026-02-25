Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739361F03DE;
	Wed, 25 Feb 2026 01:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983982; cv=none; b=DIhPYSyYHV7BpEH4vX0Y0IBzYNg+2eGVRtSRfDZr6jAnPBtQ+rbXRxZT1qmCA5RNVkM+KJfhuC90+rb0iJ7a34Y/jGspIRmZcwV4k6ynvQklq6OO9DgYCYrU7+ningavMzBuDQ8tKgKo1QNoTbBpwG0ywipf8OtjQSKfDKWDozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983982; c=relaxed/simple;
	bh=gPc9sPvnjvuuo8PiEnbHwDQRyNzdPfV6pzdudXW1/Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuPMx6ZdcY1OncExgpZtVRA8JUQ2eKwLT1Q4c455UNOY9/h/awNAFa+0wewTjbF95p2a2Xmq3CDtLfgSdTGnWu80AiW1BYDMLdxTgLIM+HDa/1N2cH/rKbCBZ5r5pKTx4No0lqd47Nx5tDW+KW7b4BguUKFgLVtW/a9ycoWrpzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMqzOU0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMqzOU0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D812C116D0;
	Wed, 25 Feb 2026 01:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983982;
	bh=gPc9sPvnjvuuo8PiEnbHwDQRyNzdPfV6pzdudXW1/Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMqzOU0q4/IT6KdB3wVX0/KDDWtd1+XAjMJUSTb+HyvPM2tn5eCi5+O22PwvSyO12
	 knfHbHsOticUxrTqRlpnVXRn1tyolBTC9qyUmb0gYqgTG7tYEOuFlV2LIgZem3yypI
	 908ktXj9ssTALDyrVEGmD0V30E2adEeMe1xjhPeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 234/641] PCI: mediatek: Fix IRQ domain leak when MSI allocation fails
Date: Tue, 24 Feb 2026 17:19:20 -0800
Message-ID: <20260225012354.558619443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 24cc30a2ab6c6..e0bf667c2b4c6 100644
--- a/drivers/pci/controller/pcie-mediatek.c
+++ b/drivers/pci/controller/pcie-mediatek.c
@@ -575,8 +575,10 @@ static int mtk_pcie_init_irq_domain(struct mtk_pcie_port *port,
 
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



