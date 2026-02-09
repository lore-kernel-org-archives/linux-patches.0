Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA40125B2;
	Mon,  9 Feb 2026 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647583; cv=none; b=nHfk6btleq3J+yOUgvM5fP0sxxEm78hm1giRxkH9tRCsDUSPGdp4f7JPw4l9Bd3NF2Qv33rGBTgQTonVm1ib3C8b56cljltMNSHIh76ijGjYw8O/5/0EOkfHumNraJ0cvHwZeAsKXWAvbvoicgga2053qyPHzqDc5OUoBmqq3bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647583; c=relaxed/simple;
	bh=BlOWLNgDxSW39V+Fvb1m54PLj8TaVl3Hjn1Gr+p0v5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ixap0ZR/E89srWIEeSnyIgr5KBYIKIy2B9meFRIL/Toc675C1sOPYDYmbxgxOUoz2rhWGkb/s5r8cpfdjgZDM1sGGIjB2HL3gRFSAGM5DJOC7nWPPs+vDp40cp0FPrhhR491inrpGG6K5y5mD/BqBZC3DIqzidDbAhTdsfXCsjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOOmNZoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOOmNZoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27589C116C6;
	Mon,  9 Feb 2026 14:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647583;
	bh=BlOWLNgDxSW39V+Fvb1m54PLj8TaVl3Hjn1Gr+p0v5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOOmNZoIe2pthDeZhSSlI79kYq909wxSW1zU7SNgYaYTW+UHlkb0T2Lef4gEJmSoL
	 PLOY+bvDBrhGJJJ2A9qZEg6a9K95vHNz52xKuzxEh7eZKo9r9o3ryoFT/9Wm+93mXi
	 qL5VfbqkUuK3cD/LIEQskhCr5uszjk50c/0hKgYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/175] net: enetc: Convert 16-bit register reads to 32-bit for ENETC v4
Date: Mon,  9 Feb 2026 15:23:36 +0100
Message-ID: <20260209142325.651514757@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit c28d765ec5da160d3a48d0928528084cef97bf19 ]

It is not recommended to access the 32‑bit registers of this hardware IP
using lower‑width accessors (i.e. 16‑bit), and the only exception to
this rule was introduced in the initial ENETC v1 driver for the PMAR1
register, which holds the lower 16 bits of the primary MAC address of
an SI. Meanwhile, this exception has been replicated in the v4 driver
code as well.

Since LS1028 (the only SoC with ENETC v1) is not affected by this issue,
the current patch converts the 16‑bit reads from PMAR1 starting with
ENETC v4.

Fixes: 99100d0d9922 ("net: enetc: add preliminary support for i.MX95 ENETC PF")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260130141035.272471-5-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc4_pf.c    |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
index b270a01f5b718..7dbfbc6fbdcb0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -63,7 +63,7 @@ static void enetc4_pf_get_si_primary_mac(struct enetc_hw *hw, int si,
 	u16 lower;
 
 	upper = __raw_readl(hw->port + ENETC4_PSIPMAR0(si));
-	lower = __raw_readw(hw->port + ENETC4_PSIPMAR1(si));
+	lower = __raw_readl(hw->port + ENETC4_PSIPMAR1(si));
 
 	put_unaligned_le32(upper, addr);
 	put_unaligned_le16(lower, addr + 4);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 377c963258147..d382220ef2f0d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -707,13 +707,24 @@ struct enetc_cmd_rfse {
 #define ENETC_RFSE_EN	BIT(15)
 #define ENETC_RFSE_MODE_BD	2
 
+static inline void enetc_get_primary_mac_addr(struct enetc_hw *hw, u8 *addr)
+{
+	u32 upper;
+	u16 lower;
+
+	upper = __raw_readl(hw->reg + ENETC_SIPMAR0);
+	lower = __raw_readl(hw->reg + ENETC_SIPMAR1);
+
+	put_unaligned_le32(upper, addr);
+	put_unaligned_le16(lower, addr + 4);
+}
+
 static inline void enetc_load_primary_mac_addr(struct enetc_hw *hw,
 					       struct net_device *ndev)
 {
-	u8 addr[ETH_ALEN] __aligned(4);
+	u8 addr[ETH_ALEN];
 
-	*(u32 *)addr = __raw_readl(hw->reg + ENETC_SIPMAR0);
-	*(u16 *)(addr + 4) = __raw_readw(hw->reg + ENETC_SIPMAR1);
+	enetc_get_primary_mac_addr(hw, addr);
 	eth_hw_addr_set(ndev, addr);
 }
 
-- 
2.51.0



