Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDBC314A64;
	Wed,  3 Dec 2025 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776270; cv=none; b=bhYDs1cXgI1rtd4PB4s675iAx2pghjkcsJ6hXNBFe/Qs5eTMwlhigN+hIsEBCcyfmniGxF8I3zfp84/VKhMFwyJmDHspykEpoSkNU2SfoLb3UGrN2J93uJ/Xauom2Ccx1nRmme8nnDB094ZXz4ReVvz6kX3Z9B4RuZgbn67B+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776270; c=relaxed/simple;
	bh=g2r0VXFmH8F5z39gZXZ3e1/XERIBkEXvOXLvo9SpFMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7hjpwu3DACT+rx4Cr6CXHYw4VaJNU+g3IQ5J1jIh1Sgpy+cVjiOI5bYX797q5oB5tfc2O0TEkaLbdLkpvBdpY80G9JBwpmCeuRsL9IPNLSC1Nm6Zj+qda4CuNa4YzXdlvsQbskxQGMHDLsHxm6g3vduiCOmH24lF/tKv8P/ofQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cbq9cEpg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cbq9cEpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD39C4CEF5;
	Wed,  3 Dec 2025 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776270;
	bh=g2r0VXFmH8F5z39gZXZ3e1/XERIBkEXvOXLvo9SpFMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cbq9cEpgc+GXMHfqxu3QIA0E5pVfmFL7p8FMOGm5hIUuWJcW9fzdGLKrSH4mhTdcr
	 T2OOTq3ZjyxPx9ktVsx44SFdWnsmsGyaSkMZJtYrS/edm51H2r+yQPIVWRQ05cuqa5
	 guyshPk/h3FNPkW+u2CcwC2K+NQSa2pHBpczw+ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Wang <unicorn_wang@outlook.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/300] PCI: cadence: Check for the existence of cdns_pcie::ops before using it
Date: Wed,  3 Dec 2025 16:25:35 +0100
Message-ID: <20251203152405.464861821@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c29176bdecd19..28e1497a4fc40 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -444,7 +444,7 @@ static int cdns_pcie_host_init_address_translation(struct cdns_pcie_rc *rc)
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_PCI_ADDR1(0), addr1);
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(0), desc1);
 
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(12) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index 52767f26048fd..7b4d403569ecd 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -89,7 +89,7 @@ void cdns_pcie_set_outbound_region(struct cdns_pcie *pcie, u8 busnr, u8 fn,
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(r), desc1);
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(nbits) |
@@ -119,7 +119,7 @@ void cdns_pcie_set_outbound_region_for_normal_msg(struct cdns_pcie *pcie,
 	}
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(17) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 3139ea9f02c89..f01f683d1cb95 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -471,7 +471,7 @@ static inline u32 cdns_pcie_ep_fn_readl(struct cdns_pcie *pcie, u8 fn, u32 reg)
 
 static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 {
-	if (pcie->ops->start_link)
+	if (pcie->ops && pcie->ops->start_link)
 		return pcie->ops->start_link(pcie);
 
 	return 0;
@@ -479,13 +479,13 @@ static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 
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



