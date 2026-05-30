Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94D4481DD;
	Sat, 30 May 2026 17:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161183; cv=none; b=EHwRqFix0+PIwHlue1XWCl40gpcr9N2Y7mfyfE3si5SHssyrkmhGJVH+dKHyVoIZeUlUr40nW/4nlCSoiyR45etHWpr7xdESsA2KDZ3SV/6TCH2+KJiNGw17BQXXio0z+wr/3DCwQhf60Du1PtMFD0jIv9HoHyYP8RcJuudhk84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161183; c=relaxed/simple;
	bh=/5sPSaEg0XCecZx66A/Vg3UuKpkhbxAX4tcMyZfuvK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPie66DsbTkkmS+KzUwl3k8YJuoxzh04U/ahDJguQQRohCdIRP7ci0uNI40Ha9muK6jcuKGiL7vxEb/K0b+34o+YbfoQyL0VzcSSO/LEzYsr4EbqqUUvqZcwkWm50v2KcZfh6ddi37WcfYbuwXnd+aMiO/XVrHBsFWuJztRM07A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLfU2fL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLfU2fL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137941F00893;
	Sat, 30 May 2026 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161182;
	bh=bI7qnBZxqsKiuqeaSfZhzpTZbiQY5r8C/gIcgF77IB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLfU2fL8yZoXB6z1l+9txmJl3RizrykvpNy9rmWb0XSy+Ovr2bdZJN8tFc1B+ijz0
	 2GNl+xzqn7CGQIkRMaM5QzsV9aF23VKEUtuHU/MEVgL5pi1rQ/OYqv2p8xbL+WS3WE
	 yyni7hP5odPnY0kZUcR4Hg6UgPsHJhXkY6Wm5uyw=
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
Subject: [PATCH 6.1 550/969] PCI: tegra194: Fix polling delay for L2 state
Date: Sat, 30 May 2026 18:01:14 +0200
Message-ID: <20260530160315.567600222@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit adaffed907f14f954096555665ad6af2ae724d83 ]

As per PCIe r7.0, sec 5.3.3.2.1, after sending PME_Turn_Off message, Root
Port should wait for 1-10 msec for PME_TO_Ack message. Currently, driver is
polling for 10 msec with 1 usec delay which is aggressive.  Use existing
macro PCIE_PME_TO_L2_TIMEOUT_US to poll for 10 msec with 1 msec delay.
Since this function is used in non-atomic context only, use non-atomic poll
function.

Fixes: 56e15a238d92 ("PCI: tegra: Add Tegra194 PCIe support")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324190755.1094879-2-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 0dca4baad0dac..e6124eeb824d4 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -206,8 +206,6 @@
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_MASK	GENMASK(11, 8)
 #define CAP_SPCIE_CAP_OFF_USP_TX_PRESET0_SHIFT	8
 
-#define PME_ACK_TIMEOUT 10000
-
 #define LTSSM_TIMEOUT 50000	/* 50ms */
 
 #define GEN3_GEN4_EQ_PRESET_INIT	5
@@ -1569,9 +1567,10 @@ static int tegra_pcie_try_link_l2(struct tegra_pcie_dw *pcie)
 	val |= APPL_PM_XMT_TURNOFF_STATE;
 	appl_writel(pcie, val, APPL_RADM_STATUS);
 
-	return readl_poll_timeout_atomic(pcie->appl_base + APPL_DEBUG, val,
-				 val & APPL_DEBUG_PM_LINKST_IN_L2_LAT,
-				 1, PME_ACK_TIMEOUT);
+	return readl_poll_timeout(pcie->appl_base + APPL_DEBUG, val,
+				  val & APPL_DEBUG_PM_LINKST_IN_L2_LAT,
+				  PCIE_PME_TO_L2_TIMEOUT_US/10,
+				  PCIE_PME_TO_L2_TIMEOUT_US);
 }
 
 static void tegra_pcie_dw_pme_turnoff(struct tegra_pcie_dw *pcie)
-- 
2.53.0



