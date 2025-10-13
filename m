Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ADF30DD37;
	Mon, 13 Oct 2025 15:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370018; cv=none; b=WgO1j0aBs3Y6dLzjjnwK3y3Y5QZa/K7/07qILWAIsM2MVSSfTO93a80t+E2mzDilc5+SX2N9ukKaUWtjTpKh3fDMP/xzRwhsoj89B+SAHePj70img00BjXobPpSEYER5g414YW8j+O3NiAQ+SIHks86kDnzpwwklw6msJsEJHkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370018; c=relaxed/simple;
	bh=k+00cH5KZwXwecU/hZRfHv3n1X/+cUN9t3I/X/ytJ8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rn2vDJN8+8QxWzskB881/Ht/wsghRJRn3589JzsVosIPdeoVhpZs3ZUjNCwbDLub/B/w3TSy5YpvLr+ampVkuD6NP8jCIug7t+erNzUmKdBm2Hdt7voU7AguHuHL+vBcxyDCw48NoqF1wEI0b8iOlVxH1dybHCDyNCTAdogE2I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dE+0Oh1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dE+0Oh1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC4BC4CEFE;
	Mon, 13 Oct 2025 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370018;
	bh=k+00cH5KZwXwecU/hZRfHv3n1X/+cUN9t3I/X/ytJ8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dE+0Oh1tE+u820MfbLdMI5aFiys8UvuJPIp+4Q0eoBrh65wXlOS/0LhKm7QsP4sdp
	 W77nkT8IcgihzQuD0tXkdFy9S+6DfYIAaaxjkAjKV2DAGyUFEnMrze5O5woap3vmYA
	 ARA3m7eh0DMQ5WRdq4a0czznjXNLPf27Ge9kDjoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nagarjuna Kristam <nkristam@nvidia.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 416/563] PCI: tegra194: Fix duplicate PLL disable in pex_ep_event_pex_rst_assert()
Date: Mon, 13 Oct 2025 16:44:37 +0200
Message-ID: <20251013144426.358531611@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4f26086f25daf..0c0734aa14b68 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1722,9 +1722,9 @@ static void pex_ep_event_pex_rst_assert(struct tegra_pcie_dw *pcie)
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



