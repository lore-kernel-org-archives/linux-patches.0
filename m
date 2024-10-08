Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5901DE890;
	Tue,  8 Oct 2024 12:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389602; cv=none; b=ZU8zzuw7r/JpCI/mIveitD1Y5CFMUQVUoEqY1r9mZhxE/BkDhYlTSOUL6cNs89xxBEHAAG2QVJ7jef5zfzpoMHntRM0Rr92WaeemPSSVJw1K+pDO4oIczpLV3WjBsq4DseND0rNdO0US+1MCqJ8142jH7Zooua+EXUOSLvUnY7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389602; c=relaxed/simple;
	bh=AzA9a5/xhtwuom3w8Mo8nxRTScWFHnHTLOUpwmttEO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BN0X56emS6yT7mpGfFjPUqBBT4AvC/lMgbMcYf3UrHKfLZ0Q//v0V7OEElGPDfhvipDTwt997EBFZlQZZlWxPQOftfCjj1UjNccQEjh+Y0NLFEkQLs0bZFUGry1BjEh5hk98XY9DA8U+GMy8LK3WBj5JxQsEEWJp48YgL/FGSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuXukiSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuXukiSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA46C4CECC;
	Tue,  8 Oct 2024 12:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389601;
	bh=AzA9a5/xhtwuom3w8Mo8nxRTScWFHnHTLOUpwmttEO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuXukiSCPO6uRzyOOZFm15zss3BqaKT/gZg8liuXMpE8p60/x3VHRfrd60snWQV6A
	 qYEuxemRg76lfYx7tPwIgqEWbtpaxvu1ofYoChyzWiF7XRlslrIvCnXWeQBKxJY8+N
	 /NtG3TywOXcQH3B9kFRvNup7rNHJJ60s4+JSNgLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 041/482] net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check
Date: Tue,  8 Oct 2024 14:01:44 +0200
Message-ID: <20241008115649.920761545@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 4c1b56671b68ffcbe6b78308bfdda6bcce6491ae ]

Increase the timeout for checking the busy bit of the VLAN Tag register
from 10µs to 500ms. This change is necessary to accommodate scenarios
where Energy Efficient Ethernet (EEE) is enabled.

Overnight testing revealed that when EEE is active, the busy bit can
remain set for up to approximately 300ms. The new 500ms timeout provides
a safety margin.

Fixes: ed64639bc1e0 ("net: stmmac: Add support for VLAN Rx filtering")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Link: https://patch.msgid.link/20240924205424.573913-1-shenwei.wang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8e2049ed60159..c79d70899493b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
 #include "dwmac4.h"
@@ -475,7 +476,7 @@ static int dwmac4_write_vlan_filter(struct net_device *dev,
 				    u8 index, u32 data)
 {
 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
-	int i, timeout = 10;
+	int ret;
 	u32 val;
 
 	if (index >= hw->num_vlan)
@@ -491,16 +492,15 @@ static int dwmac4_write_vlan_filter(struct net_device *dev,
 
 	writel(val, ioaddr + GMAC_VLAN_TAG);
 
-	for (i = 0; i < timeout; i++) {
-		val = readl(ioaddr + GMAC_VLAN_TAG);
-		if (!(val & GMAC_VLAN_TAG_CTRL_OB))
-			return 0;
-		udelay(1);
+	ret = readl_poll_timeout(ioaddr + GMAC_VLAN_TAG, val,
+				 !(val & GMAC_VLAN_TAG_CTRL_OB),
+				 1000, 500000);
+	if (ret) {
+		netdev_err(dev, "Timeout accessing MAC_VLAN_Tag_Filter\n");
+		return -EBUSY;
 	}
 
-	netdev_err(dev, "Timeout accessing MAC_VLAN_Tag_Filter\n");
-
-	return -EBUSY;
+	return 0;
 }
 
 static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
-- 
2.43.0



