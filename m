Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE361D4154;
	Tue, 15 Oct 2024 11:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993366; cv=none; b=RD6vzB5BaarnNd75JJY7hbmmX6HkFY6jeW3lP3VQreKGGSYcMwxNXI3eQFRJ7lrgiezDmGG4u2wLVomGlkovQyzW7XDM0lEOkV/7pxFijs38lPveqByhWF39qOYoGRsiSj/tt7gJzSiu4m9PLErixn/To6oao0SHAoKO4BgHebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993366; c=relaxed/simple;
	bh=Zkz1jhhoE6YqzwaK1K+CVIjlh5bTQxPDL4wAiBfU+JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nl5a1oVGO6QIrph0UDqZUkuZQ0dgk6Z2uAoRISHBH9tskH0TYmGel3NUVwHspbJ+qBq2W7MQFTcnqIa+yZ2x1WuM5Y9reb+S8JAnleTO0vtdP4w7TH6SHl6gfGmBHY0yfT7Q3xA0jo0skEEubXBxUDPQWx8Ndc6IiTtB1pFjv5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tc6Un/86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tc6Un/86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41157C4CEC6;
	Tue, 15 Oct 2024 11:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993365;
	bh=Zkz1jhhoE6YqzwaK1K+CVIjlh5bTQxPDL4wAiBfU+JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc6Un/86l69YNlqOdzbPxkXn2nM0ShjRqXdau1C541PbXGznUlNOgIccsZBnMy1y0
	 Yvgx4rrVxeXEwKk2wXSHlmuuD9V2wj2a0ihM3E1ld6pWVAsHDhL3baswcZGBEOIFPg
	 4YkAqmt6Ft+Q3kKdGOrvrhs//PGPftGXFhgDCvUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/691] net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check
Date: Tue, 15 Oct 2024 13:25:38 +0200
Message-ID: <20241015112455.820271873@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 687eb17e41c6e..c75868f3ceae1 100644
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
@@ -469,7 +470,7 @@ static int dwmac4_write_vlan_filter(struct net_device *dev,
 				    u8 index, u32 data)
 {
 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
-	int i, timeout = 10;
+	int ret;
 	u32 val;
 
 	if (index >= hw->num_vlan)
@@ -485,16 +486,15 @@ static int dwmac4_write_vlan_filter(struct net_device *dev,
 
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



