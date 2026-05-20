Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBE331220;
	Wed, 20 May 2026 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300610; cv=none; b=cHgQ0GkLSO43Xucs4cGmWNJGzQ3/J33AQO0GAAIMRE7qJoULs82OydB2Yk7C/gB0bNxlv6u1H/EPYUlcdT+H4LPGT38pv8Cax8gs5cmEuIUtFzwRqdpAb4sz6D9oC553bCEBAcNZYM8vHCYlAx8MSKZXByEqAsp02Jdgv/XkHdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300610; c=relaxed/simple;
	bh=Vbje/nDibAb5xoAENDNZYRPo8CFhk0HkUnLHZpBMl5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N55deYNYRzN2AyDYSC6TgOCBI4l1XG7H8ZmYjpGo0mpb77WsppH9/+r8L6xP23214hfMOEKg5xoeOGuYbBQp6kDrLyN7V5dgtwtglXiq0aI79aW4nnmOPHO8DG336mSWjuEzz00m4YqCsMyWHhu+xfWyOyS9W2KsCeX5+wvfFkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnjTEvfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnjTEvfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEB11F000E9;
	Wed, 20 May 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300609;
	bh=O1XKcR3AuFe+5WAShhvvfRFWANGkMDmzTX/I+yE7Dcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnjTEvfnlIDitVAIonzSd2k592eqkujCFR2EcATkRL3iz+SrLiW2ClncWaUGqkL2A
	 RS8BMvN/WrdJLco9t5mWeLf8Qhv4+lVeoYNdrz7CHVQmaF0hLByNtWizHVOTBeTSE9
	 w68vp5zzAconGPGxafOrPBrL60BTlJgWOrV3nKrk=
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
Subject: [PATCH 6.12 239/666] PCI: tegra194: Disable direct speed change for Endpoint mode
Date: Wed, 20 May 2026 18:17:30 +0200
Message-ID: <20260520162116.395480339@linuxfoundation.org>
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
index fcc9f724147c4..42a8bbfee3f9a 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1830,6 +1830,10 @@ static void pex_ep_event_pex_rst_deassert(struct tegra_pcie_dw *pcie)
 
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



