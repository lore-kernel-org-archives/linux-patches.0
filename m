Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC52BB17;
	Tue, 11 Nov 2025 01:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824957; cv=none; b=SxSP7KOhpvCMyWmqmzONsAlZ4RGbNN4NhFLmBA2M6stdsDg0G9Y3vmVKr2500UMGhyeJ/kuN3LdefXvCmjjGy7lcWsepsOZbpApxJQ43ka4inX3qvWPV8ANzP/Stl4rYXpmyTXrpVBsRAP3Ojg8ccKVLDEZe9INlQbloqR1T6FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824957; c=relaxed/simple;
	bh=c7p/Qci0vkUXYMf2FUvfBxYYebZUPuWJCUEpTCZESu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II4QopvxOCVodQ6z62ygK7bmX57eKxmBfnvQKcyrDqQcBr4aEZ4SAe/Jopc24ROAw7J115Gyup//bmV7XSYLKlFXqltJ+TDsH/SZrn1JjxsLEKj5yiyOjx4OTi10a6FrUZux7oHZxcse/Zv8GJxH9+N0YmosKWrsMrCkUMlhAqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUo7Iqqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUo7Iqqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4ECC4AF09;
	Tue, 11 Nov 2025 01:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824957;
	bh=c7p/Qci0vkUXYMf2FUvfBxYYebZUPuWJCUEpTCZESu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUo7Iqqhhu637aAMI9YUN3+Tdd6tFK61nkXv3axVS3tMKP/77CToBCvDZ+J9C79N6
	 tsfU42fkey5s9vi9JAbTkXif890c5Niv2cANVKXHKTaDQFbYly4vOsVw1IbFPa0LrQ
	 b58EMsk44td2pm9gCCVY/veYyM5dYYTfvjaRmB7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Wang <unicorn_wang@outlook.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 605/849] PCI: cadence: Check for the existence of cdns_pcie::ops before using it
Date: Tue, 11 Nov 2025 09:42:55 +0900
Message-ID: <20251111004551.048066397@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 59a4631de79fe..fffd63d6665e8 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -531,7 +531,7 @@ static int cdns_pcie_host_init_address_translation(struct cdns_pcie_rc *rc)
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_PCI_ADDR1(0), addr1);
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(0), desc1);
 
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(12) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.c b/drivers/pci/controller/cadence/pcie-cadence.c
index 70a19573440ee..61806bbd8aa32 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.c
+++ b/drivers/pci/controller/cadence/pcie-cadence.c
@@ -92,7 +92,7 @@ void cdns_pcie_set_outbound_region(struct cdns_pcie *pcie, u8 busnr, u8 fn,
 	cdns_pcie_writel(pcie, CDNS_PCIE_AT_OB_REGION_DESC1(r), desc1);
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(nbits) |
@@ -123,7 +123,7 @@ void cdns_pcie_set_outbound_region_for_normal_msg(struct cdns_pcie *pcie,
 	}
 
 	/* Set the CPU address */
-	if (pcie->ops->cpu_addr_fixup)
+	if (pcie->ops && pcie->ops->cpu_addr_fixup)
 		cpu_addr = pcie->ops->cpu_addr_fixup(pcie, cpu_addr);
 
 	addr0 = CDNS_PCIE_AT_OB_REGION_CPU_ADDR0_NBITS(17) |
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 1d81c4bf6c6db..2f07ba661bda7 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -468,7 +468,7 @@ static inline u32 cdns_pcie_ep_fn_readl(struct cdns_pcie *pcie, u8 fn, u32 reg)
 
 static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 {
-	if (pcie->ops->start_link)
+	if (pcie->ops && pcie->ops->start_link)
 		return pcie->ops->start_link(pcie);
 
 	return 0;
@@ -476,13 +476,13 @@ static inline int cdns_pcie_start_link(struct cdns_pcie *pcie)
 
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



