Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EBD26738C;
	Sat, 30 May 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166378; cv=none; b=AIRI/FJT47djqzrZjqO1n3wurlSrWEJmNcd52hs8d6/UMW3oni9f9yxPteW6bZdUt38Wrf+Y8TrBV6xe7EFLF17vNYdDyhZ8auwbQNprmVokGirD9imrXvBIgetk3hIWIdVPUAFEu9Tnb81IROjyZ7PS85Y4nfpx/KhvjXBO8ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166378; c=relaxed/simple;
	bh=sljzszU0LGWFJM0rs7Ee8sUXvABZidil/XUw1p/QgwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+Si3YrvUA1vpMLKSOTPfmQMuY59HIXMUunV+H0J9zqkO9qN77CX0/4AVJzXszYtpNI6WytYyj04yYA22+KqYenwgIhPAYYq82WnOUHbrfOYvm1jqM3rIYcoz0IKD6UV2FZA3mtvTCQGI5akT8+yIpIYVgOJxK8FSrpQeQOEAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mK9bKL59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mK9bKL59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178E61F00893;
	Sat, 30 May 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166377;
	bh=IoqZhp8Yj8mJRnex91WMBoQjEeW6Vpj9jQPlGksuieM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mK9bKL59BvV+Z5oGk0KIWTbQwkKhcwZM9cQimN9d4v2Eq5At3zfiba0iOe+WR5Yca
	 aMnv/GM1Jco2c4LJr7Oh9TORG35yDjNrc4kELMWadrtgekxP5xytuovm3nyg72mFh4
	 9egBRGoDyQ9KmynWeHgCRgRwBxICvZ0cTKuky6ZE=
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
Subject: [PATCH 5.10 354/589] PCI: tegra194: Disable direct speed change for Endpoint mode
Date: Sat, 30 May 2026 18:03:55 +0200
Message-ID: <20260530160234.165267229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 976f6763f57970388bcd7118931f33f447916927 ]

Pre-silicon simulation showed the controller operating in Endpoint mode
initiating link speed change after completing Secondary Bus Reset. Ideally,
the Root Port or the Switch Downstream Port should initiate the link speed
change post SBR, not the Endpoint.

So, as per the hardware team recommendation, disable direct speed change
for the Endpoint mode to prevent it from initiating speed change after the
physical layer link is up at Gen1, leaving speed change ownership with the
host.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-8-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index ee8f25c07f2e1..e59939ec2022c 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1771,6 +1771,10 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 
 	reset_control_deassert(pcie->core_rst);
 
+	val = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
+	val &= ~PORT_LOGIC_SPEED_CHANGE;
+	dw_pcie_writel_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL, val);
+
 	if (pcie->update_fc_fixup) {
 		val = dw_pcie_readl_dbi(pci, CFG_TIMER_CTRL_MAX_FUNC_NUM_OFF);
 		val |= 0x1 << CFG_TIMER_CTRL_ACK_NAK_SHIFT;
-- 
2.53.0



