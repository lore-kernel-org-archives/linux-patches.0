Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5543F3D5642;
	Wed, 20 May 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298195; cv=none; b=oG5Zu96hk82oArMIxfiyRxZjPvD9UJ1KZvTmPeMOEGT7Xpv2OI728AE0Ys0NSaPM3/qqw9s3ohbio3qvkjcQ5CD9L0GodQjUboEClFJQht7cv4SHrGYea+A3Ljl8GtkKypPKI/Un+PSsyLgSArk1F8HpkgzedWgAxe9zy3OZS0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298195; c=relaxed/simple;
	bh=Y/9xAeFQg/S7e7C0pn0VO2JCQUXdb6p1JzLOyujQG/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYQbGrYWrGzO4DK6uWtv+hoQiMEN2J/+aT1MNRsr5XOoeqbfjLyNbcV0Qn3Yswb/5vXOCLjDg15ZjIRwlY3wA48G5b+HTMvOStmjOsa4g08CQ5LSx8hEKKFwNUd99ajmu+QXpE6zjkSbqZtYDuHftLDnHqd7GFnyTZIiyDhb91o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCLJB0kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCLJB0kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1011F000E9;
	Wed, 20 May 2026 17:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298194;
	bh=h6OPKn4yxezDNIqrVua6JOrGBqCUeXfCxbzVoxZEmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCLJB0kzzgWELL8xPX3UMdXAbn6OmsLicLsE0okzhUapw/Du0mr9zoYLE2hvgWKs/
	 gXMrbh0EeSCXXi1ycFRxMfSFCoOUmiZNpSWwnKyHYJSc7YX46r+baJGvHkuu/JsClV
	 sUYP+xit649oJoo0edIRotU/6FGEmjeKqDn7ATDM=
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
Subject: [PATCH 6.18 319/957] PCI: tegra194: Increase LTSSM poll time on surprise link down
Date: Wed, 20 May 2026 18:13:22 +0200
Message-ID: <20260520162141.449847112@linuxfoundation.org>
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

From: Manikanta Maddireddy <mmaddireddy@nvidia.com>

[ Upstream commit 74dd8efe4d6cead433162147333af989a568aac7 ]

On surprise link down, LTSSM state transits from L0 -> Recovery.RcvrLock ->
Recovery.RcvrSpeed -> Gen1 Recovery.RcvrLock -> Detect. Recovery.RcvrLock
and Recovery.RcvrSpeed transit times are 24 ms and 48 ms respectively, so
the total time from L0 to Detect is ~96 ms. Increase the poll timeout to
120 ms to account for this.

While at it, add LTSSM state defines for Detect-related states and use them
in the poll condition. Use readl_poll_timeout() instead of
readl_poll_timeout_atomic() in tegra_pcie_dw_pme_turnoff() since that path
runs in non-atomic context.

Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-3-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 36 +++++++++++++---------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index d2d3139e81d36..d2fefd5c8b08f 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -137,7 +137,11 @@
 #define APPL_DEBUG_PM_LINKST_IN_L0		0x11
 #define APPL_DEBUG_LTSSM_STATE_MASK		GENMASK(8, 3)
 #define APPL_DEBUG_LTSSM_STATE_SHIFT		3
-#define LTSSM_STATE_PRE_DETECT			5
+#define LTSSM_STATE_DETECT_QUIET		0x00
+#define LTSSM_STATE_DETECT_ACT			0x08
+#define LTSSM_STATE_PRE_DETECT_QUIET		0x28
+#define LTSSM_STATE_DETECT_WAIT			0x30
+#define LTSSM_STATE_L2_IDLE			0xa8
 
 #define APPL_RADM_STATUS			0xE4
 #define APPL_PM_XMT_TURNOFF_STATE		BIT(0)
@@ -198,7 +202,8 @@
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_MASK	GENMASK(11, 8)
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_SHIFT	8
 
-#define LTSSM_TIMEOUT 50000	/* 50ms */
+#define LTSSM_DELAY_US		10000	/* 10 ms */
+#define LTSSM_TIMEOUT_US	120000	/* 120 ms */
 
 #define GEN3_GEN4_EQ_PRESET_INIT	5
 
@@ -1626,15 +1631,14 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
 		data &= ~APPL_CTRL_LTSSM_EN;
 		writel(data, pcie->appl_base + APPL_CTRL);
 
-		err = readl_poll_timeout_atomic(pcie->appl_base + APPL_DEBUG,
-						data,
-						((data &
-						APPL_DEBUG_LTSSM_STATE_MASK) >>
-						APPL_DEBUG_LTSSM_STATE_SHIFT) ==
-						LTSSM_STATE_PRE_DETECT,
-						1, LTSSM_TIMEOUT);
+		err = readl_poll_timeout(pcie->appl_base + APPL_DEBUG, data,
+			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_QUIET) ||
+			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_ACT) ||
+			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_PRE_DETECT_QUIET) ||
+			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_WAIT),
+			LTSSM_DELAY_US, LTSSM_TIMEOUT_US);
 		if (err)
-			dev_info(pcie->dev, "Link didn't go to detect state\n");
+			dev_info(pcie->dev, "LTSSM state: 0x%x detect timeout: %d\n", data, err);
 	}
 	/*
 	 * DBI registers may not be accessible after this as PLL-E would be
@@ -1714,12 +1718,14 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
 	appl_writel(pcie, val, APPL_CTRL);
 
 	ret = readl_poll_timeout(pcie->appl_base + APPL_DEBUG, val,
-				 ((val & APPL_DEBUG_LTSSM_STATE_MASK) >>
-				 APPL_DEBUG_LTSSM_STATE_SHIFT) ==
-				 LTSSM_STATE_PRE_DETECT,
-				 1, LTSSM_TIMEOUT);
+		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_QUIET) ||
+		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_ACT) ||
+		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_PRE_DETECT_QUIET) ||
+		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_WAIT) ||
+		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_L2_IDLE),
+		LTSSM_DELAY_US, LTSSM_TIMEOUT_US);
 	if (ret)
-		dev_err(pcie->dev, "Failed to go Detect state: %d\n", ret);
+		dev_info(pcie->dev, "LTSSM state: 0x%x detect timeout: %d\n", val, ret);
 
 	reset_control_assert(pcie->core_rst);
 
-- 
2.53.0



