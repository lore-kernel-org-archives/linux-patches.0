Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114C730F548;
	Mon, 13 Oct 2025 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367821; cv=none; b=dL1bZ5hJ06nEREkE0QwKRCdbAoH9TjZITpqMuHSCVgzQmtoXdSotLIxAwC+sgtkulS4GeC87LUwAbziMqjQKQTkIxgmA5FNhXz0GJAaGPGsfD1Apm32f1dNbL5FJWGLRN3anPrPBOaU1dWZd31kc/JcLHaINICOWGb4m5Kv/Ljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367821; c=relaxed/simple;
	bh=i9Jv2tX0Tk7YIpNhy04V1M4rtJX10is/8tpXmZ4Qa8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIxPaR8nzxatYIFdDgtJTXmQGHQ2LR1RnEBZtqhHIaqvCuUEU+ZddE2kkvIWiJ7rAlt6gVQ0XwEA0nWhmw103Lasn+c8DWdk9B6aU5xX5TxOzogt5iviZMMgMnwWe2lRhEwUrIUNn1MPsjSXQapzFk/shTfHky3owUGgR/8SLAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/cFbk7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/cFbk7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7148CC4CEE7;
	Mon, 13 Oct 2025 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367820;
	bh=i9Jv2tX0Tk7YIpNhy04V1M4rtJX10is/8tpXmZ4Qa8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/cFbk7t/IZKw5VOE1chmNhEcdZrVipqh7OTnHRrtGpjnoFp6y0P/Jx3MDjNpN7Dw
	 esnEXyHbVkP/nptzsDu7kO1owcH+3+HgibnoEGGKuDqX9kGC7P3sPB/K4T1YvlvYX4
	 bxpHVkfzOjJRWB2nz7maGfb/YnwRNbkXIjgf1zjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nagarjuna Kristam <nkristam@nvidia.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/196] PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()
Date: Mon, 13 Oct 2025 16:45:29 +0200
Message-ID: <20251013144320.307139675@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nagarjuna Kristam <nkristam@nvidia.com>

[ Upstream commit 4f152338e384a3a47dd61909e1457539fa93f5a4 ]

During PERST# assertion tegra_pcie_bpmp_set_pll_state() is currently
called twice.

pex_ep_event_pex_rst_assert() should do the opposite of
pex_ep_event_pex_rst_deassert(), so it is obvious that the duplicate
tegra_pcie_bpmp_set_pll_state() is a mistake, and that the duplicate
tegra_pcie_bpmp_set_pll_state() call should instead be a call to
tegra_pcie_bpmp_set_ctrl_state().

With this, the uninitialization sequence also matches that of
tegra_pcie_unconfig_controller().

Fixes: a54e19073718 ("PCI: tegra194: Add Tegra234 PCIe support")
Signed-off-by: Nagarjuna Kristam <nkristam@nvidia.com>
[cassel: improve commit log]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20250911093021.1454385-2-cassel@kernel.org
[mani: added Fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 416d6b45d1fe8..115a21cf869ae 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1734,9 +1734,9 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
 				ret);
 	}
 
-	ret = tegra_pcie_bpmp_set_pll_state(pcie, false);
+	ret = tegra_pcie_bpmp_set_ctrl_state(pcie, false);
 	if (ret)
-		dev_err(pcie->dev, "Failed to turn off UPHY: %d\n", ret);
+		dev_err(pcie->dev, "Failed to disable controller: %d\n", ret);
 
 	pcie->ep_state = EP_STATE_DISABLED;
 	dev_dbg(pcie->dev, "Uninitialization of endpoint is completed\n");
-- 
2.51.0



