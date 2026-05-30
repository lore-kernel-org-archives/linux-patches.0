Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1156A23392B;
	Sat, 30 May 2026 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164163; cv=none; b=HuFMtDzfHj7RjQHaPAkWph49Op5JPRrAxEYKGuwtvWHcYOPcUlSTPidSrJDX5qh2qzwjXDAihARFBjPY7q9+r0A/9nFmLUs9mkGeeo+ILVqZfQNqOKLTjVjgGFDiQF7LeMplreuv9A1r5OV9oDpipiqyyYLbhN2mbym/7yAAcAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164163; c=relaxed/simple;
	bh=tJJVLUPIPTVnziNlZdMZMrWpYPs9dk4hDkvNd7X7PTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRqpFNSP5hAC9N3WRS6h+CqOfOXSnZIpCUku+r2Kdr5KhrAACnjdP70WgD6kKfrPglofiY4Qy+L8Af7wZFN6CpEw1qCDy9whu3Bbg/CutULc96ffg3qe5eqGlCXeqSVuzTqWJ2+a7OpoKkpRYvWIOx8BAn2cw4nn6QkrA9YcaIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CosHtZmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CosHtZmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554691F00893;
	Sat, 30 May 2026 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164162;
	bh=R8tttKc25KHhvWlnTyBupQxMX8JLSVAwagiDRQdBYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CosHtZmVBTr5NV/a2PhrKY7nZocVi3mWEDKrv0f50Vn3hmBr/8nPGyByapRIzuijk
	 ZVtC3orikr6M10WmJ3bhoNK6Xb49yxuZlXUO9bxvFLEyFIr3YqaUUKM7pywiaRWljj
	 iXgmdh/ByUOuBzkiAHjrUy4JYLrrlhV3JC1UJSTo=
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
Subject: [PATCH 5.15 473/776] PCI: tegra194: Disable LTSSM after transition to Detect on surprise link down
Date: Sat, 30 May 2026 18:03:07 +0200
Message-ID: <20260530160252.568811696@linuxfoundation.org>
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
index a7ab82067d538..c32184e8e5636 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1539,14 +1539,6 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
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
@@ -1555,6 +1547,14 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
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
@@ -1636,11 +1636,6 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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
@@ -1651,6 +1646,14 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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



