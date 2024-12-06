Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A118148314;
	Fri,  6 Dec 2024 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497679; cv=none; b=GalChMtI2G0iNotQwpukMP3BP/75SCPv5ybGXWdF97RzuG4K7mqwWRXNXqj943ENjyfAUiVb6O129t/FO6H9H8rnt9ATXeT3+cq4xOK1v1wpSyRprwaefmnHtJCvWHchQoaXfaA3KJ49RLju8JNm8DF7dSsbYiah1lzwBlRChuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497679; c=relaxed/simple;
	bh=Sezc1wNetrnzd6so01HP3nbNTyKzvyI/5eH/+xjEgOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bjw8EJWaXea9/c+esWkovukW5Of2GIto8QNh8Z0jhz3a4n9n7bD8EK9e00kacAzACzmEoG4X9kMCgC573/OsWs4zwlE+14g2S8Eymw6x3YiyOhJbWRLCT4Du79N86Is7IPoib6C09erFQ9fTKZUFhSW//lS7EMBPeN3V4a0h048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/5i+bR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/5i+bR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A94C4CED1;
	Fri,  6 Dec 2024 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497679;
	bh=Sezc1wNetrnzd6so01HP3nbNTyKzvyI/5eH/+xjEgOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/5i+bR5Ot+I6FhE0Jq2tgD48dafvc8oFF0Cy7ETB04+tLjKS2e237bngEoduq6Bh
	 jmKE+cbpZM6+y40uA6Q+GCLKlzZEHaSXqWRMtkGGfaR93i+di5RPIVfSiTIbQA4+Am
	 wPmgVFaR+lVmfCwu6C3WQF4tDJWg+ocDZGtPm1Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/676] PCI: cadence: Extract link setup sequence from cdns_pcie_host_setup()
Date: Fri,  6 Dec 2024 15:33:00 +0100
Message-ID: <20241206143707.448265445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit d1b6f2e2ce4d8b17d9f3558c98a1517b864bfd03 ]

The function cdns_pcie_host_setup() mixes probe structure and link setup.

The link setup must be done during the resume sequence. So extract it from
cdns_pcie_host_setup() and create a dedicated function.

Link: https://lore.kernel.org/linux-pci/20240102-j7200-pcie-s2r-v7-1-a2f9156da6c3@bootlin.com
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../controller/cadence/pcie-cadence-host.c    | 39 ++++++++++++-------
 drivers/pci/controller/cadence/pcie-cadence.h |  6 +++
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 5b14f7ee3c798..93d9922730af5 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -497,6 +497,30 @@ static int cdns_pcie_host_init(struct device *dev,
 	return cdns_pcie_host_init_address_translation(rc);
 }
 
+int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc)
+{
+	struct cdns_pcie *pcie = &rc->pcie;
+	struct device *dev = rc->pcie.dev;
+	int ret;
+
+	if (rc->quirk_detect_quiet_flag)
+		cdns_pcie_detect_quiet_min_delay_set(&rc->pcie);
+
+	cdns_pcie_host_enable_ptm_response(pcie);
+
+	ret = cdns_pcie_start_link(pcie);
+	if (ret) {
+		dev_err(dev, "Failed to start link\n");
+		return ret;
+	}
+
+	ret = cdns_pcie_host_start_link(rc);
+	if (ret)
+		dev_dbg(dev, "PCIe link never came up\n");
+
+	return 0;
+}
+
 int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 {
 	struct device *dev = rc->pcie.dev;
@@ -533,20 +557,9 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 		return PTR_ERR(rc->cfg_base);
 	rc->cfg_res = res;
 
-	if (rc->quirk_detect_quiet_flag)
-		cdns_pcie_detect_quiet_min_delay_set(&rc->pcie);
-
-	cdns_pcie_host_enable_ptm_response(pcie);
-
-	ret = cdns_pcie_start_link(pcie);
-	if (ret) {
-		dev_err(dev, "Failed to start link\n");
-		return ret;
-	}
-
-	ret = cdns_pcie_host_start_link(rc);
+	ret = cdns_pcie_host_link_setup(rc);
 	if (ret)
-		dev_dbg(dev, "PCIe link never came up\n");
+		return ret;
 
 	for (bar = RP_BAR0; bar <= RP_NO_BAR; bar++)
 		rc->avail_ib_bar[bar] = true;
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 373cb50fcd159..4c687aeb810e8 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -515,10 +515,16 @@ static inline bool cdns_pcie_link_up(struct cdns_pcie *pcie)
 }
 
 #ifdef CONFIG_PCIE_CADENCE_HOST
+int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc);
 int cdns_pcie_host_setup(struct cdns_pcie_rc *rc);
 void __iomem *cdns_pci_map_bus(struct pci_bus *bus, unsigned int devfn,
 			       int where);
 #else
+static inline int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc)
+{
+	return 0;
+}
+
 static inline int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 {
 	return 0;
-- 
2.43.0



