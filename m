Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE9117A2FC;
	Wed, 20 May 2026 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302170; cv=none; b=SPUcvO77mjpHpOD9GMW8muOxIin+nfv2eo1JVwW3L0o5pG8P139+QTvG7Nt+7cAOjdqgByx4C8hqEOQZJLZiBX3WWFfv9poDmVawmenAax9yG7mlSJUBwragx6jA39QCEGwBEki6SSOpWif4081NwCUZM9b3NuWQjrN6XexKwEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302170; c=relaxed/simple;
	bh=9R3WQ3UkMWX9xhTQSRWy394WZNSPbjR64jOHBySK4F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+WqDuf+HKo+wT55O6WZORj8wWYT1k/tsUCtOwF0O1nxAJHfXU+BCL5+so5jhCSx/BWS89ebzyxvjPj18vgcbGdSt1zXhmIn2Pe4gZelTS8DLnrd7djsxMCpgs+NU0f1k4ax0jgTrVbUDlMEfglFF+6lvHzbMX3d1dVifFJXE+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKnZd6mc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKnZd6mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324C81F000E9;
	Wed, 20 May 2026 18:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302169;
	bh=GnUfVifiE1M2mJqA7uzY/UXRFO05Uad3emfVEBx4Cnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKnZd6mczHlsjd9rInO7SbYc3A8k61o8Q86PQuufrkosO2NWty1sjDYBr3Y+KllRZ
	 o1+abr14ZnuarTMxsZAOS7DUeAg3UQ5UwsyUt8CchE8Vb6T6gGJQj9Y9DCAJFFqQuD
	 Rx7dNiiUBII2khhUXWVMJgEOv3urOrB6cuUdoz3Q=
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
Subject: [PATCH 6.6 163/508] PCI: tegra194: Disable direct speed change for Endpoint mode
Date: Wed, 20 May 2026 18:19:46 +0200
Message-ID: <20260520162102.170565344@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index dba73a0ea4210..b29d1edd4c9bd 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1839,6 +1839,10 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 
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



