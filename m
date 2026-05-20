Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F1A2F363F;
	Wed, 20 May 2026 18:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300594; cv=none; b=piXNyjuGWOWayqQt4ge22nU30oAnKFvoXY5LEhjODOmMv+wowp6ogojtogDvU0ah95ijiAbrLKnEOZfKjGjE/xyhFC+RX5gNcU5Y5/LWWEQA1Qn90rGFAybyBfEJLN0qob2tHjd4Y7xSxV/dqtJC6NhQY7+UuR1KwGcfuQydsSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300594; c=relaxed/simple;
	bh=xi5IbUuQeYqJkIX20P5CKr1RL+/sd708VJXzT54HW3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlWUX9sCK1MM8BdE37F0/3mjInB+0GzuxZd4fw8DiQ1NqnoOHQipj0c0mvfEiFt3k65J042ylQM86rIgQTb1ticHFTiqvjOdNVzjyd5HaHo2Rc6yVkzVrwnU4keyLYjE5p0n/fVwcwHelUKa90On6RNRIPIFwkQjATJZrkv199I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3yLmqX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3yLmqX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295E61F000E9;
	Wed, 20 May 2026 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300593;
	bh=xuIe7y0Zj140dz+NdxDLE+q0yHkltpsAvyWJRzKxMDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3yLmqX2YTWtdrbFzg+XL81k2FQKE2NTfvkR1iH3T3j4pGK7efGe5Xx/mq8id5fYf
	 bZEWe3V36fJZb4k4HlfaHnVljwfG6o61BQz5Ko7s/tySfMXYSc62D9CAvu0V99aEEP
	 SSNieA0WZBiq92BgFh7IZfUPgtLChyhiqSi144ZU=
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
Subject: [PATCH 6.12 234/666] PCI: tegra194: Disable LTSSM after transition to Detect on surprise link down
Date: Wed, 20 May 2026 18:17:25 +0200
Message-ID: <20260520162116.285485332@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e64a0360c7ce7..c83457adf5782 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1611,14 +1611,6 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
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
@@ -1627,6 +1619,14 @@ static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
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
@@ -1708,11 +1708,6 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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
@@ -1723,6 +1718,14 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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



