Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D602DC76C;
	Wed, 20 May 2026 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298198; cv=none; b=rpsUx9VG4V8Gap6mcKun+rZ+0z434OaLSVFaGrMNpzmhLb8GpNC46/ONQhJHkGua7JwXy8cGIluezYo46mCe9Gyxb266Ha3r1ZKDEiLSeIO8m5zGMbh4fK/NTFKp4NOtwOeraowa3nh3CzhX8ei5Bl03M/34cxquJ64YkI9eP1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298198; c=relaxed/simple;
	bh=dHexL81BEQZ+KDgLgoleCnLmylgF9WWaCMJnr7RktnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRYbCoQfRnBJMv1gW3Up9QsXrsZJYhxIRicWJjC3WVbpRDVQsOkBdIm6Uev0X4AyoRR2UJ55F1ZW3kozYrGS+dWplq4PothpPFthnjDZKFSfkUhb2FGMaytwN8CO9WUVr9xFfRcxy1MVC7zwNfGP8pWnCnLCr7NvgOYT+4gE7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t76cqjV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t76cqjV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8001F000E9;
	Wed, 20 May 2026 17:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298196;
	bh=l15Ds5irTEuax838cnYeg9txh12X63a8W+8wYKJr5zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t76cqjV1yHQ8rfedEyF7aEGyD3LW7l1XrITtnIew3+otu2sY2FYQrFzLWTzmEk9l2
	 JO2MYPBnWFoOWdm6CPwz2fc3rXEXqi2L9Vb5ec1VKOpqFMS5XxIQXB3FxxQjRWPB3o
	 pgnENcQT2juXaD5tRhkvt3mrA/cNnavTlt0+YX6k=
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
Subject: [PATCH 6.18 320/957] PCI: tegra194: Disable LTSSM after transition to Detect on surprise link down
Date: Wed, 20 May 2026 18:13:23 +0200
Message-ID: <20260520162141.470880121@linuxfoundation.org>
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

[ Upstream commit 9fa0c242f8d7acf1b124d4462d18f4023573ac1c ]

After the link reaches a Detect-related LTSSM state, disable LTSSM so it
does not keep toggling between Polling and Detect. Do this by polling for
the Detect state first, then clearing APPL_CTRL_LTSSM_EN in both
tegra_pcie_dw_pme_turnoff() and pex_ep_event_pex_rst_assert().

Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-4-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 29 ++++++++++++----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index d2fefd5c8b08f..b3a1161f49daf 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1623,14 +1623,6 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
 		data &= ~APPL_PINMUX_PEX_RST;
 		appl_writel(pcie, data, APPL_PINMUX);
 
-		/*
-		 * Some cards do not go to detect state even after de-asserting
-		 * PERST#. So, de-assert LTSSM to bring link to detect state.
-		 */
-		data = readl(pcie->appl_base + APPL_CTRL);
-		data &= ~APPL_CTRL_LTSSM_EN;
-		writel(data, pcie->appl_base + APPL_CTRL);
-
 		err = readl_poll_timeout(pcie->appl_base + APPL_DEBUG, data,
 			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_QUIET) ||
 			((data & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_ACT) ||
@@ -1639,6 +1631,14 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
 			LTSSM_DELAY_US, LTSSM_TIMEOUT_US);
 		if (err)
 			dev_info(pcie->dev, "LTSSM state: 0x%x detect timeout: %d\n", data, err);
+
+		/*
+		 * Deassert LTSSM state to stop the state toggling between
+		 * Polling and Detect.
+		 */
+		data = readl(pcie->appl_base + APPL_CTRL);
+		data &= ~APPL_CTRL_LTSSM_EN;
+		writel(data, pcie->appl_base + APPL_CTRL);
 	}
 	/*
 	 * DBI registers may not be accessible after this as PLL-E would be
@@ -1712,11 +1712,6 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
 	if (pcie->ep_state == EP_STATE_DISABLED)
 		return;
 
-	/* Disable LTSSM */
-	val = appl_readl(pcie, APPL_CTRL);
-	val &= ~APPL_CTRL_LTSSM_EN;
-	appl_writel(pcie, val, APPL_CTRL);
-
 	ret = readl_poll_timeout(pcie->appl_base + APPL_DEBUG, val,
 		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_QUIET) ||
 		((val & APPL_DEBUG_LTSSM_STATE_MASK) == LTSSM_STATE_DETECT_ACT) ||
@@ -1727,6 +1722,14 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
 	if (ret)
 		dev_info(pcie->dev, "LTSSM state: 0x%x detect timeout: %d\n", val, ret);
 
+	/*
+	 * Deassert LTSSM state to stop the state toggling between
+	 * Polling and Detect.
+	 */
+	val = appl_readl(pcie, APPL_CTRL);
+	val &= ~APPL_CTRL_LTSSM_EN;
+	appl_writel(pcie, val, APPL_CTRL);
+
 	reset_control_assert(pcie->core_rst);
 
 	tegra_pcie_disable_phy(pcie);
-- 
2.53.0



