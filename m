Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5015A2C0F97;
	Wed, 25 Feb 2026 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002550; cv=none; b=sorfoEzkCWwMXB1HnuyU1xqLv8iguvooUvtyKo3eT7P4Xn2PGdQDZ9YDIB/h4s0ZsVQ8VhkDBCM4Zmlinqso/BrvVAbGjC4gFW+hThDnDaODJxpRKIovxDHBncJozY35ZzSKGV2JzD2E07awY/BNsFqfMX66paJOPDNSBDCP4kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002550; c=relaxed/simple;
	bh=ibMsJcQ7U1VWy5gzdadNoMC8+pJa5GaqnMjLfjKC1rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1ANs9gCqxzc3Xoz48m4lgFqVwvb9fBK76is/+YGTiKrd9ooek56R6MKAAK+eoqOjEB2zQiFrIyZkvaSn5tZWgZniNKmQonWpaib1SfjN7VEcPUq7D9PCaNNdkvFqtjJ2jwt4Hzy1QS+kl45tMi6FPNuAHwp8Ewt57AIBCM7XSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueMCi8KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueMCi8KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C562FC116D0;
	Wed, 25 Feb 2026 06:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002549;
	bh=ibMsJcQ7U1VWy5gzdadNoMC8+pJa5GaqnMjLfjKC1rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueMCi8KS+OHWBGGAqLEJRbHbb5jD4Ib1DqJJ1OTgsuELHeuZw/QpjluGWYv/9e9L8
	 h60uPTvoUND0ZUEFSXVprDrur7i4cl7mN4rY8FNJidIIXW7sJHLKiNM62Qs9lv95iL
	 Lq/foUn8QKiyOogbaO/c1UL1/ERrLjl1k8Fj10/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/641] PCI: xilinx: Fix INTx IRQ domain leak in error paths
Date: Tue, 24 Feb 2026 17:19:21 -0800
Message-ID: <20260225012354.581085583@linuxfoundation.org>
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

[ Upstream commit f42b3c053b1554d66af6fe45bb1ef357464c0456 ]

In xilinx_pcie_init_irq_domain(), if xilinx_allocate_msi_domains() fails
after pcie->leg_domain has been successfully created via
irq_domain_create_linear(), the function returns directly without cleaning
up the allocated IRQ domain, resulting in a resource leak. In
xilinx_free_msi_domains(), pcie->leg_domain is also neglected.

Add irq_domain_remove() call in the error path to properly release the
IRQ domain before returning the error. Also rename
xilinx_free_msi_domains() to xilinx_free_irq_domains() and add the release
of pcie->leg_domain to it.

Fixes: 313b64c3ae52 ("PCI: xilinx: Convert to MSI domains")
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251219021615.965-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx.c b/drivers/pci/controller/pcie-xilinx.c
index 937ea6ae1ac48..4aa139abac16e 100644
--- a/drivers/pci/controller/pcie-xilinx.c
+++ b/drivers/pci/controller/pcie-xilinx.c
@@ -302,9 +302,10 @@ static int xilinx_allocate_msi_domains(struct xilinx_pcie *pcie)
 	return 0;
 }
 
-static void xilinx_free_msi_domains(struct xilinx_pcie *pcie)
+static void xilinx_free_irq_domains(struct xilinx_pcie *pcie)
 {
 	irq_domain_remove(pcie->msi_domain);
+	irq_domain_remove(pcie->leg_domain);
 }
 
 /* INTx Functions */
@@ -480,8 +481,10 @@ static int xilinx_pcie_init_irq_domain(struct xilinx_pcie *pcie)
 		phys_addr_t pa = ALIGN_DOWN(virt_to_phys(pcie), SZ_4K);
 
 		ret = xilinx_allocate_msi_domains(pcie);
-		if (ret)
+		if (ret) {
+			irq_domain_remove(pcie->leg_domain);
 			return ret;
+		}
 
 		pcie_write(pcie, upper_32_bits(pa), XILINX_PCIE_REG_MSIBASE1);
 		pcie_write(pcie, lower_32_bits(pa), XILINX_PCIE_REG_MSIBASE2);
@@ -600,7 +603,7 @@ static int xilinx_pcie_probe(struct platform_device *pdev)
 
 	err = pci_host_probe(bridge);
 	if (err)
-		xilinx_free_msi_domains(pcie);
+		xilinx_free_irq_domains(pcie);
 
 	return err;
 }
-- 
2.51.0



