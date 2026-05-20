Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC7F3C6A5C;
	Wed, 20 May 2026 17:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298192; cv=none; b=MGWGzurkyS1hzKPL5GbqWnJkVJTSzkQQwK3jt1blusgLl4gYB23YmiTwo7BPC3JN3yfBkAPROV6Z93DmhV9tNzv3u+VKcjATZnB5E3Zu64IQTZS3ZdRLUYKhyKfLdq0el4IaoKiv7QMPh/A1dSt3Jq8B69zqfxINw8spJwSGIDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298192; c=relaxed/simple;
	bh=2ugaQbucOyPtOAMkUNF7HoNnjNNxlYqwBqMQTEXMAm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYlX4trTeB9MD3jc07Q1xl2vFwTAMuQSk9eYs7qUTs3jxLR8yYOpi9uudnJES5+G54dlRG+8MqnHMc3wj9nrh+MLEMW6axkCI9w7zCCAPbqw6G+MUfzXobUjJF4BusP8OkKFi6RV76jVbo923KKj9SPduyTA136ZYGijfwsPjEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMDfbFJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMDfbFJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2431A1F000E9;
	Wed, 20 May 2026 17:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298191;
	bh=JTK7tlvDJ4jDUi2SBilYt+NyMgDW7AIifRY9788l+/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMDfbFJJBFX0b4aIvh4R7wMKGmNZkfvm0zPwoKYcHwUxD3oaQEWV8rh7Xdipc5BYT
	 ctwAsTEPuLFisXzTOCHDhX8thXPF65Onyx2U3Ythk3ATQvdLHmbX4JJ+5muNrrCDLf
	 G1DMBxflUicxMg+F8ZGbbzIxbirnEjzvP1dgiMl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/957] PCI: tegra194: Fix polling delay for L2 state
Date: Wed, 20 May 2026 18:13:21 +0200
Message-ID: <20260520162141.428592931@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit adaffed907f14f954096555665ad6af2ae724d83 ]

As per PCIe r7.0, sec 5.3.3.2.1, after sending PME_Turn_Off message, Root
Port should wait for 1-10 msec for PME_TO_Ack message. Currently, driver is
polling for 10 msec with 1 usec delay which is aggressive.  Use existing
macro PCIE_PME_TO_L2_TIMEOUT_US to poll for 10 msec with 1 msec delay.
Since this function is used in non-atomic context only, use non-atomic poll
function.

Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-2-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 3934757baa30c..d2d3139e81d36 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -198,8 +198,6 @@
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_MASK	GENMASK(11, 8)
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_SHIFT	8
 
-#define PME_ACK_TIMEOUT 10000
-
 #define LTSSM_TIMEOUT 50000	/* 50ms */
 
 #define GEN3_GEN4_EQ_PRESET_INIT	5
@@ -1582,9 +1580,10 @@ static int tegra_pcie_try_link_l2(struct tegra_pcie_dw *pcie)
 	val |= APPL_PM_XMT_TURNOFF_STATE;
 	appl_writel(pcie, val, APPL_RADM_STATUS);
 
-	return readl_poll_timeout_atomic(pcie->appl_base + APPL_DEBUG, val,
-				 val & APPL_DEBUG_PM_LINKST_IN_L2_LAT,
-				 1, PME_ACK_TIMEOUT);
+	return readl_poll_timeout(pcie->appl_base + APPL_DEBUG, val,
+				  val & APPL_DEBUG_PM_LINKST_IN_L2_LAT,
+				  PCIE_PME_TO_L2_TIMEOUT_US/10,
+				  PCIE_PME_TO_L2_TIMEOUT_US);
 }
 
 static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
-- 
2.53.0



