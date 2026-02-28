Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4A8340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301069; cv=none; b=uq0eIhNszdiwz9LG93Svw0VFf0kFxCeYpf3+aAh0MwQ25afIDZrFq7gHyqTkFppkT5jrnKfXHlz6SYP8F5tdOZN7+8xeeNP6I80GGBXiIyG2tswZIvC+2XVn1faNqDE6vNAt/jseqi7KDgEGmdJPgz2f4F2G3eul5SBrbnV1ZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301069; c=relaxed/simple;
	bh=ZmBFudN+ml7FtXGu39SukifsTx3Q4fi2NzVgwq4D4fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTwHKQDXDD7SL6AR7bzgoLeKrUqftrd0ng6hpWjzFAZcsJ0sk9jIGRwaNrpfQnynFBvuqDsO+/bPBb/3BadsTMmUGQvGKAlxRWemWJle8fYrUoYLWm1keLKjhUT2gWYfH53aikZbpnGa7A/xKU7MdNpne1gd32auXblCur9uqsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djtwGi3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djtwGi3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD24C116D0;
	Sat, 28 Feb 2026 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301069;
	bh=ZmBFudN+ml7FtXGu39SukifsTx3Q4fi2NzVgwq4D4fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djtwGi3IQqx/wkORLoIosPTxV4A58UzgtaNqcV9yFom47clBDANfivlIIXk46I1Tg
	 U14QYXOvPLtTiChrzkV9WfYE17DC14iV0dWjrrFeA8yEnJlH9GLH5SX8d1oixPK6Uc
	 NCAEEK0FsAhF1sxQQl7hq9pIm1RBZoRXO0nrZ5Ry+ozRIsPiUuaR7M3EZqdYtAAG+F
	 rKqa5G7bDRDg5hWauuiRmjAxMwmdhBJ9MBZQpz+iLT5Gk6g4yfMnFeDJK/5c6DtZ6K
	 gmROfJ3KlXUd3ltd0TiJKry3I1WWGTusNv+FDHhm/m44qKzMOTuC6KMpLW/B6TdS62
	 UTKkCRDXe7HvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 213/752] PCI: dwc: Skip PME_Turn_Off broadcast and L2/L3 transition during suspend if link is not up
Date: Sat, 28 Feb 2026 12:38:44 -0500
Message-ID: <20260228174750.1542406-213-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit cfd2fdfd0a8da2e5bbfdc4009b9c4b8bf164c937 ]

During system suspend, if the PCIe link is not up, then there is no need
to broadcast PME_Turn_Off message and wait for L2/L3 transition. So skip
them.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/20251218-pci-dwc-suspend-rework-v2-1-5a7778c6094a@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index e92513c5bda51..702885c53f467 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1146,8 +1146,11 @@ static int dw_pcie_pme_turn_off(struct dw_pcie *pci)
 int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 {
 	u8 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	int ret = 0;
 	u32 val;
-	int ret;
+
+	if (!dw_pcie_link_up(pci))
+		goto stop_link;
 
 	/*
 	 * If L1SS is supported, then do not put the link into L2 as some
@@ -1182,6 +1185,7 @@ int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 	 */
 	udelay(1);
 
+stop_link:
 	dw_pcie_stop_link(pci);
 	if (pci->pp.ops->deinit)
 		pci->pp.ops->deinit(&pci->pp);
-- 
2.51.0

