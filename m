Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179006FAA
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D4CC433EF;
	Mon,  3 Apr 2023 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533139;
	bh=scMJ6mOJ64dVhHby72mzmk4DdYyhecWVVsGNPiO+58U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sw9Nsv4sOc41feu464lSLLwYaWf3zOIcs9020m2D5uhvNLCv7mKSGienY5dgDZzvC
	 4mAFaf2J82A4RhDCXzOwjemTaAB9kcFUXRE5FnrKulj4mwy3jQHRtoQvcPx71Xv6PE
	 5smz40gy/+9WfbwJr5juApAqYcd+Hjb6xVcvQT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 069/187] PCI: dwc: Fix PORT_LINK_CONTROL update when CDM check enabled
Date: Mon,  3 Apr 2023 16:08:34 +0200
Message-Id: <20230403140418.221308887@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit cdce67099117ece371582f706c6eff7d3a65326d ]

If CDM_CHECK is enabled (by the DT "snps,enable-cdm-check" property), 'val'
is overwritten by PCIE_PL_CHK_REG_CONTROL_STATUS initialization.  Commit
ec7b952f453c ("PCI: dwc: Always enable CDM check if "snps,enable-cdm-check"
exists") did not account for further usage of 'val', so we wrote improper
values to PCIE_PORT_LINK_CONTROL when the CDM check is enabled.

Move the PCIE_PORT_LINK_CONTROL update to be completely after the
PCIE_PL_CHK_REG_CONTROL_STATUS register initialization.

[bhelgaas: commit log adapted from Serge's version]
Fixes: ec7b952f453c ("PCI: dwc: Always enable CDM check if "snps,enable-cdm-check" exists")
Link: https://lore.kernel.org/r/20230310123510.675685-2-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 6d5d619ab2e94..346f67d2fdae2 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -806,11 +806,6 @@ void dw_pcie_setup(struct dw_pcie *pci)
 		dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
 	}
 
-	val = dw_pcie_readl_dbi(pci, PCIE_PORT_LINK_CONTROL);
-	val &= ~PORT_LINK_FAST_LINK_MODE;
-	val |= PORT_LINK_DLL_LINK_EN;
-	dw_pcie_writel_dbi(pci, PCIE_PORT_LINK_CONTROL, val);
-
 	if (dw_pcie_cap_is(pci, CDM_CHECK)) {
 		val = dw_pcie_readl_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS);
 		val |= PCIE_PL_CHK_REG_CHK_REG_CONTINUOUS |
@@ -818,6 +813,11 @@ void dw_pcie_setup(struct dw_pcie *pci)
 		dw_pcie_writel_dbi(pci, PCIE_PL_CHK_REG_CONTROL_STATUS, val);
 	}
 
+	val = dw_pcie_readl_dbi(pci, PCIE_PORT_LINK_CONTROL);
+	val &= ~PORT_LINK_FAST_LINK_MODE;
+	val |= PORT_LINK_DLL_LINK_EN;
+	dw_pcie_writel_dbi(pci, PCIE_PORT_LINK_CONTROL, val);
+
 	if (!pci->num_lanes) {
 		dev_dbg(pci->dev, "Using h/w default number of lanes\n");
 		return;
-- 
2.39.2



