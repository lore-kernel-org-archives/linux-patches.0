Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C794221F2F;
	Wed, 20 May 2026 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295204; cv=none; b=jO3P11iK6L652ci0T4kH1/QMF7N4An2lZji6Zii7hNMWaRtiLv0LhcWmtFncSvNP2SOlcDBgeBLagihhIr6Y3Kz/rg0McKMslJRxmuKozVBv4Icq0tbuMAlsPllrAqfSrqqXG5lkzKkgz+mpraJlzD9KbBubGNpqACAainQlMmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295204; c=relaxed/simple;
	bh=t9VM728qd/TFMhbmtgTXVqOIBLcDC55Y9ZY90OfLEhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSCWLKo9LSX6M4GzmhHmS8d9wnftsvM9o7Nsg+Zdgjki1UluVS7u8s7RV2ejynIEDTYvplrC5jW4dOmJSlfYcCF/mk6x6h/qwdiTwuHwaqJsWNgGhkhMBzzRFKARh0X3HBygxA+sZDNm+0vkl71Wlcqs8BjVH/5LDmc4dOUdb+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxjVVs8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxjVVs8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F9E1F000E9;
	Wed, 20 May 2026 16:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295203;
	bh=GtkoCc94NdwJkIffZeCiRpaTaSzNc83pg+jskIB9NqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxjVVs8hXYHH75YijlzO6vB5V/tsxgJXCH90Rnr2yq5VCbvAASWTe6LXGcuACkSdn
	 l9O+wEDYHYWKy+OXu/lUmt33hqoMhznxYyu1Z4whcXcs99fRuvuGmbYpNR70kbguWK
	 azFHEYz+y2vN33q5WlbU5msCn0u6MpJ7RYAQXxsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0329/1146] PCI: qcom: Advertise Hotplug Slot Capability with no Command Completion support
Date: Wed, 20 May 2026 18:09:39 +0200
Message-ID: <20260520162155.642689283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 33a76fc3c3e61386524479b99f35423bd3d9a895 ]

Qcom PCIe Root Ports advertise hotplug capability in hardware, but do not
support hotplug command completion. As a result, the hotplug commands
issued by the pciehp driver never gets completion notification, leading to
repeated timeout warnings and multi-second delays during boot and
suspend/resume.

Commit a54db86ddc153 ("PCI: qcom: Do not advertise hotplug capability for
IPs v2.7.0 and v1.9.0") mistakenly assumed that the Root Ports doesn't
support Hotplug due to timeouts and disabled the Hotplug functionality
altogether. But the Root Ports does support reporting Hotplug events like
DL_Up/Down events.

So to fix the command completion timeout issues, just set the No Command
Completed Support (NCCS) bit and enable Hotplug in Slot Capability field
back.

Fixes: a54db86ddc153 ("PCI: qcom: Do not advertise hotplug capability for IPs v2.7.0 and v1.9.0")
Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
[mani: renamed function, commit log and added comment]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com> # Hamoa CRD, tunneled link
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260314-hotplug-v1-1-96ac87d93867@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 67a16af69ddc7..9fdfc88ac1512 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -350,15 +350,20 @@ static void qcom_pcie_clear_aspm_l0s(struct dw_pcie *pci)
 	dw_pcie_dbi_ro_wr_dis(pci);
 }
 
-static void qcom_pcie_clear_hpc(struct dw_pcie *pci)
+static void qcom_pcie_set_slot_nccs(struct dw_pcie *pci)
 {
 	u16 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
 	u32 val;
 
 	dw_pcie_dbi_ro_wr_en(pci);
 
+	/*
+	 * Qcom PCIe Root Ports do not support generating command completion
+	 * notifications for the Hot-Plug commands. So set the NCCS field to
+	 * avoid waiting for the completions.
+	 */
 	val = readl(pci->dbi_base + offset + PCI_EXP_SLTCAP);
-	val &= ~PCI_EXP_SLTCAP_HPC;
+	val |= PCI_EXP_SLTCAP_NCCS;
 	writel(val, pci->dbi_base + offset + PCI_EXP_SLTCAP);
 
 	dw_pcie_dbi_ro_wr_dis(pci);
@@ -558,7 +563,7 @@ static int qcom_pcie_post_init_2_1_0(struct qcom_pcie *pcie)
 	writel(CFG_BRIDGE_SB_INIT,
 	       pci->dbi_base + AXI_MSTR_RESP_COMP_CTRL1);
 
-	qcom_pcie_clear_hpc(pcie->pci);
+	qcom_pcie_set_slot_nccs(pcie->pci);
 
 	return 0;
 }
@@ -638,7 +643,7 @@ static int qcom_pcie_post_init_1_0_0(struct qcom_pcie *pcie)
 		writel(val, pcie->parf + PARF_AXI_MSTR_WR_ADDR_HALT);
 	}
 
-	qcom_pcie_clear_hpc(pcie->pci);
+	qcom_pcie_set_slot_nccs(pcie->pci);
 
 	return 0;
 }
@@ -731,7 +736,7 @@ static int qcom_pcie_post_init_2_3_2(struct qcom_pcie *pcie)
 	val |= EN;
 	writel(val, pcie->parf + PARF_AXI_MSTR_WR_ADDR_HALT_V2);
 
-	qcom_pcie_clear_hpc(pcie->pci);
+	qcom_pcie_set_slot_nccs(pcie->pci);
 
 	return 0;
 }
@@ -1037,7 +1042,7 @@ static int qcom_pcie_post_init_2_7_0(struct qcom_pcie *pcie)
 		writel(WR_NO_SNOOP_OVERRIDE_EN | RD_NO_SNOOP_OVERRIDE_EN,
 				pcie->parf + PARF_NO_SNOOP_OVERRIDE);
 
-	qcom_pcie_clear_hpc(pcie->pci);
+	qcom_pcie_set_slot_nccs(pcie->pci);
 
 	return 0;
 }
-- 
2.53.0



