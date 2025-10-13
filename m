Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFE830C611;
	Mon, 13 Oct 2025 14:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367259; cv=none; b=FpZbu+zP7NmI0sJO+D0zbePnwHBQkaw9O23pD368f0ymEL3zbnYwYVjqnIbe4Wd6i14/eNbhICuzo8/vZ5fzQ7HDgoXWkZstcA5BX1QFZqOFaH4VwW70KuO6k9NXxrR9g5N3vkd+8ANUx0LTcoPTorFAtwSbo/2tjYMiY1ky2d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367259; c=relaxed/simple;
	bh=sDG3BOs6IXiGqIqJMiq8ApyOT05qfFKp6roIi7uEJHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLyX8WDkHZ50a20jAaw27vgZLSsFa6Wg6hhrzvDlls5quKrOQgdJZNMXUXbF0WlRuVdAVMWVAhplJjTKGjWscR5yPTlhFVXb88DibhVy+gKoW/w0FRF+bByukWtye7mdl9PXeehQ4nSKVS4cE/fwimmYk1PQd1PSduz9nceCiuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWbBlIh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWbBlIh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF15C4CEE7;
	Mon, 13 Oct 2025 14:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367257;
	bh=sDG3BOs6IXiGqIqJMiq8ApyOT05qfFKp6roIi7uEJHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWbBlIh6+HS8bKySAHanIO+FjkBmbGVQAAeBQKLq5XUupAYYGSE03XQqW/KT7Qz3k
	 L/15BU3vtP1cVtdL77iWp+Tr2kI16IoHPzc5JxVbFYN+KBzp4YJMxjnQYeHGYEXIIo
	 FfRRBcuZuBVgKZV1Q5C1RZP/kuruu5Lvn2OBLTd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nagarjuna Kristam <nkristam@nvidia.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/196] PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()
Date: Mon, 13 Oct 2025 16:45:19 +0200
Message-ID: <20251013144319.980049890@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0839454fe4994..5100d2a53b8ab 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1720,9 +1720,9 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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



