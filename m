Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72DB1779B1;
	Tue,  8 Oct 2024 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391213; cv=none; b=UMEPtUGhcTEvjhk8bFizHrA4LXDY9Y5lCb2wuSMjfVgp5xb36+vn4zWe/fMO+WjEeIQwy1pr9SK2EtDYVUs+1xgiX9fx/Qjj1zn7y+k9/32xFeDdtLucfW4LB2dJ/00a/b1HjD2x0OM8BBUPq3Y4gCw1aRXxgBSgwzhyEY9jLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391213; c=relaxed/simple;
	bh=Bdg/FbGZ4bxaVNlXZ97s/waUuYBdsO7oB7wxj3FHz80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fx+AkGqNjh7PIvtMvqKkT3+xxie02JXodFpUXcgTNffiy86ZafOaoz/UU5Tmnx0yJvd+RDinzK1RtdHfAzqpibVV3tDHMHxw6eV3c2w7LqAgIRnI7tYvKNNIKo2Ftez6uVI5uZHhIluoDKDHIiW3aij4NHYK2ymN9SML66IwAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxKxfqW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxKxfqW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FD7C4CEC7;
	Tue,  8 Oct 2024 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391213;
	bh=Bdg/FbGZ4bxaVNlXZ97s/waUuYBdsO7oB7wxj3FHz80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxKxfqW5s8DJV7jn+kDZyMixpi2oiijuex8t6I9FFyZTi7EnfwnKMQSipb2za8Ibp
	 Rg0bBDhkDy63Dkofaqzijf95vSuqH004nsSmsCUrKdedaZ5KaxBZ8H6ks98cpnlgg+
	 C8MZryhC7joX/CkMLFdEptoEw2fKc/LG5R0m83fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 044/558] net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check
Date: Tue,  8 Oct 2024 14:01:14 +0200
Message-ID: <20241008115703.958712499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 31c387cc5f269..5e64cf15670b1 100644
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



