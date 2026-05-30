Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0BD29B78B;
	Sat, 30 May 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164159; cv=none; b=kC/1+Sl3ZQ/DkVqBBLGY/69PkbckJ6d2xpj+RDqhE4bxqvraAhSRuYyaMizKdUsXQimFO7ZLc3Yy6/39R6gofe1DYkgMr84epyitYOOSwFBypFozVzgpdDa8nNxo7nyqgzWNtRzbeT5ixc4RV05J3R8CdRiPW4oLlQqKVY2gSOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164159; c=relaxed/simple;
	bh=6zlswoD0xqwc+52xwUxSqaSTdHpCDuwafcmqE595xRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmuuV3CRUPadfHpbNT/REqfpUzMOaVTyMt/8WHy46BSozHBfEmYNib9yNat+BgM6ZIA6uVVRcjDYz15qyVPEUpZKtMCakvbHJCthlj45HrH0uR0ZrWXcMvpIHESB4tktXeDTkba0c5SnkxHTQKDik1XGa+FfHpT+Ne5ZUs+DY0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtGZrdOY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtGZrdOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD061F00893;
	Sat, 30 May 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164158;
	bh=gDAEyJVsRyMs8dPEadTb1JDa8fyuLhmCUyMv2ggrKZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtGZrdOYetAcc24USEM4x7PYJpjMW4YJX8D/sgfjiL9+qb8SCJBA/fdtmrXUwP2sK
	 PudVPAt6xRgtg7amFuMB6JHBzg+vVEuV8/v4UkQVUEj4RCkeFaQ6FKU6ZItWdQOGF0
	 dZj5FOhwR36AZ0+hRuPw8p0U7vFROa8qbAa6imk4=
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
Subject: [PATCH 5.15 472/776] PCI: tegra194: Increase LTSSM poll time on surprise link down
Date: Sat, 30 May 2026 18:03:06 +0200
Message-ID: <20260530160252.543744192@linuxfoundation.org>
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
index 8782ad616caa1..a7ab82067d538 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -134,7 +134,11 @@
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
@@ -221,7 +225,8 @@
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_MASK	GENMASK(11, 8)
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_SHIFT	8
 
-#define LTSSM_TIMEOUT 50000	/* 50ms */
+#define LTSSM_DELAY_US		10000	/* 10 ms */
+#define LTSSM_TIMEOUT_US	120000	/* 120 ms */
 
 #define GEN3_GEN4_EQ_PRESET_INIT	5
 
@@ -1542,15 +1547,14 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
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
@@ -1638,12 +1642,14 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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



