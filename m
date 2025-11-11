Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502952DCF6E;
	Tue, 11 Nov 2025 01:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824337; cv=none; b=WLGdCZI+Cju7NKwDrTKyCz7Pa4Ba7WTfWkcootogfmWKg6f28V/HSivEKcoOzDlBdEQiF9EvyPU5lfoZJFU6B0d6brtJSCAyfQVZxYsCk2FmsPSZdz8BVMPhE1YbJKazfzOb98+VimNTdkh73g1ku4MT+w0dRZ8fqOzdj8DWwt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824337; c=relaxed/simple;
	bh=miHueLiGyU0aHGJTFhH89sCdrMdni1fXzeNL1Oph+2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBPBtzZSXYrc7UbKHpDsN7GGt3bKy1JKC4YtQti6L0fLrBCHOR0X6UREW4bWycZ1sogblh+3CCclUYwpocjCZgHJmVejn/wDyYQ61fhQwMAlOcFDXEANIbUxSv1jbyC0zsfKfDTp4oK3RMdaYtEfk8zTxzKmRN48FS17qVuogV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQ5653/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQ5653/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E079BC19421;
	Tue, 11 Nov 2025 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824337;
	bh=miHueLiGyU0aHGJTFhH89sCdrMdni1fXzeNL1Oph+2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQ5653/JqsLgCsUst18d00MdFWC+fNIhS7U9kzRzMMNtmxtlgVyDia7s1njdLLMMt
	 EZ48ihOiOkUc55OC+1rbHLM0qGG55mTM+i5yzFfxRdaLJq12li1sbJEvYTqDprpH6S
	 PrvQaK36DGiWRGOBg8gouFLj4m9t+wu8iiBa5JBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Wang <unicorn_wang@outlook.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/565] PCI: cadence: Check for the existence of cdns_pcie::ops before using it
Date: Tue, 11 Nov 2025 09:44:18 +0900
Message-ID: <20251111004535.916505587@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Wang <unicorn_wang@outlook.com>

[ Upstream commit 49a6c160ad4812476f8ae1a8f4ed6d15adfa6c09 ]

cdns_pcie::ops might not be populated by all the Cadence glue drivers. This
is going to be true for the upcoming Sophgo platform which doesn't set the
ops.

Hence, add a check to prevent NULL pointer dereference.

Signed-off-by: Chen Wang <unicorn_wang@outlook.com>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/35182ee1d972dfcd093a964e11205efcebbdc044.1757643388.git.unicorn_wang@outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 2 +-
 drivers/pci/controller/cadence/pcie-cadence.c      | 4 ++--
 drivers/pci/controller/cadence/pcie-cadence.h      | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 741e10a575ec7..675b7ea6ff784 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -452,7 +452,7 @@ static int cdns_pcie_host_init_address_translation(struct cdns_pcie_rc *rc)
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_PCI_ADDR1(0), addr1);
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(0), desc1);
 
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(12) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index 4251fac5e3106..a1b66dbfc10f8 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -90,7 +90,7 @@ void cdns_pcie_set_outbound_region(struct cdns_pcie *pcie, u8 busnr, u8 fn,
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(r), desc1);
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(nbits) |
@@ -120,7 +120,7 @@ void cdns_pcie_set_outbound_region_for_normal_msg(struct cdns_pcie *pcie,
 	}
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(17) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 39ee9945c903e..c267566fa76ec 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -499,7 +499,7 @@ static inline u32 cdns_pcie_ep_fn_readl(struct cdns_pcie *pcie, u8 fn, u32 reg)
 
 static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 {
-	if (pcie->ops->start_link)
+	if (pcie->ops && pcie->ops->start_link)
 		return pcie->ops->start_link(pcie);
 
 	return 0;
@@ -507,13 +507,13 @@ static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 
 static inline void cdns_pcie_stop_link(struct cdns_pcie *pcie)
 {
-	if (pcie->ops->stop_link)
+	if (pcie->ops && pcie->ops->stop_link)
 		pcie->ops->stop_link(pcie);
 }
 
 static inline bool cdns_pcie_link_up(struct cdns_pcie *pcie)
 {
-	if (pcie->ops->link_up)
+	if (pcie->ops && pcie->ops->link_up)
 		return pcie->ops->link_up(pcie);
 
 	return true;
-- 
2.51.0



