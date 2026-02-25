Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1541D5ABA;
	Wed, 25 Feb 2026 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983164; cv=none; b=gRyS/9MdqW9JQqKVXwbzW/rWCp7YJ7eDC55vMPA2Yci6Yq/FMQY9xMtn6uRJPmhyfNULgDicJ3T+iPLqpSf8/w6R4t63vgLp4zbmxgJ+sp+NPHlNZE5AFX+ShgWfrVE5V75H6QkmZ3bwqHUMEjLOdNtJR17N/oiDlQMMh76zA1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983164; c=relaxed/simple;
	bh=cASPEWjLYYc+vPuLU9U4BL+X10cqK4hJut5Rrb+TeIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py3gAhZIaPMtyX9YPcrimphA8wi+IT6xsDi02zhzrGj3ZBs0py86GNzjMF3Tfcv+ZFqnKClrtwYafgyZSUnbZqTviAurbEJyz5Z3JAI+k7FLPK6C/AbKjjgsuUuScGe3Atm0opOdc1H3hRd3e+YI4MenI+uabrB0ASnNMuegXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgsk6TYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgsk6TYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC13EC116D0;
	Wed, 25 Feb 2026 01:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983164;
	bh=cASPEWjLYYc+vPuLU9U4BL+X10cqK4hJut5Rrb+TeIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgsk6TYMG6PNW2tkMU7R+jwEzPhn2LW3FKiYcMAS+jtPhrV/4iEjINFCcUiPWZGRY
	 Z8LW/7tgJ04GTjJsXmNU8Thyh+smuXvMixa+QHo1zsUHpRdiSrCbM3Yt2gC0e77MHP
	 cj0Y/Tb9aYZC/vtPPfthBPdJ1dB/242ZambL9H8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 317/781] PCI: xilinx: Fix INTx IRQ domain leak in error paths
Date: Tue, 24 Feb 2026 17:17:06 -0800
Message-ID: <20260225012407.475824873@linuxfoundation.org>
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



