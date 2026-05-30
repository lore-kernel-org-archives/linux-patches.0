Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7217C23392B;
	Sat, 30 May 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164156; cv=none; b=lQcy970y2+heb48PL1eL8bJs+e61jWiOpuYflX/rRm+9vEeWi6JyJD7CZayHRxUDXCg23fCvegfvADJ2mOeKeC9G5MAyXj0+zbcDFAzN5BI+YFhZwOer/gOYEw4Q3p9z+TuDaqfEhZH10wWLAxbPsLZKTJSCYmhLz0aVR+UBlKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164156; c=relaxed/simple;
	bh=pcMm/nkCcOK00rdLJVd1S55bB8KK+8iPHBLqzchCiKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqoLD+ja9Qp83gDaCA3CBlZOPCxry+7NVciG//w3h+eOgPupZOlbXzIBlVfn0SbXrEXgtlcKKhhZwqGJ1/egKV0tx7zNaFOQf4oED2W/G6PTUzNnV5nAAXRRHrFdX71Q6IX/e1qbeLb1RAfN+E2izNMtAMLPLQHsky+sM9bj5Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFHaL2Z2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFHaL2Z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCB51F00893;
	Sat, 30 May 2026 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164155;
	bh=sBEOdY7325/hTyJ8z/K85yckifulLV/qJR3UUz8jxaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFHaL2Z2wmp8NPW8z3gZ1YA4/WL5pZLH1wFi3t9uy6pxBoR56jKwkEWhw30N5RviU
	 VSVZ7QxiOuf/O+7kIOhXY5Z9T1jIBHWXbRj7atIR1Lqnn5CCH9suF89fCjqBenaFO/
	 ODd2LRKvR4s0pBTU4o5gsrWztYLPT/5DgaRe84FU=
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
Subject: [PATCH 5.15 471/776] PCI: tegra194: Fix polling delay for L2 state
Date: Sat, 30 May 2026 18:03:05 +0200
Message-ID: <20260530160252.518462974@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 882e739d00128..8782ad616caa1 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -221,8 +221,6 @@
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_MASK	GENMASK(11, 8)
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_SHIFT	8
 
-#define PME_ACK_TIMEOUT 10000
-
 #define LTSSM_TIMEOUT 50000	/* 50ms */
 
 #define GEN3_GEN4_EQ_PRESET_INIT	5
@@ -1498,9 +1496,10 @@ static int tegra_pcie_try_link_l2(struct tegra_pcie_dw *pcie)
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



