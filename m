Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798671292C8;
	Tue, 30 Apr 2024 10:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474078; cv=none; b=V6CEq27yrK1qY/AzdwdrhwYJLUzMgK5Vnhh4FTKexua3j6t1o3VpmbclF66zoQjUrrCo1bBfi/T8ULKls3oNMvFnSpyJPgZhRUlE8orAb7on/MourtxY9uikF0fQACtX6MaN/MtN2HbcI8KvO7A2EYRT0iF8rwVHkkDsP4zZFrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474078; c=relaxed/simple;
	bh=NnuoOS6HsQ6Tzehuf7M5jdwblLIwp7dDKaDXdAz5nLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hggFL5h7uOzI4mlt6mqI5MkQ28bO05+T4I+neMfKBIuGgC10eiAw+5/ZR+cKXspUHGtm/oEu/jwackOWedSKfgZgUzfc2rO1SqGApJDAEDbmncTvMLmmCpfKsk2rVqz7YEXdIUIEN9ik5BehCbx9Hnoiu8ESDV+7Uc687HOHqLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwAyp/NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwAyp/NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AEBC4AF18;
	Tue, 30 Apr 2024 10:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474078;
	bh=NnuoOS6HsQ6Tzehuf7M5jdwblLIwp7dDKaDXdAz5nLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwAyp/NLOPcpJdGdHPONsnkF85+pLLpOGZBJQZlSTyeLuZGJeMeInfvXgKaW/v+Pq
	 ukE9GpBwi6B1LCRhG1j596S4b3mExXa5Z+D8UOYNlL/P9ZcKH0kfGoSE7d93o51Ccc
	 FnkCl29cWHunWKYiI0wAjCWr51UEGovQj19ZQ//g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 050/228] net: bcmasp: fix memory leak when bringing down interface
Date: Tue, 30 Apr 2024 12:37:08 +0200
Message-ID: <20240430103105.255949367@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 9f898fc2c31fbf0ac5ecd289f528a716464cb005 ]

When bringing down the TX rings we flush the rings but forget to
reclaimed the flushed packets. This leads to a memory leak since we
do not free the dma mapped buffers. This also leads to tx control
block corruption when bringing down the interface for power
management.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240418180541.2271719-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/asp2/bcmasp_intf.c  | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 78901e2e73032..529172a87ae50 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -435,10 +435,8 @@ static void umac_init(struct bcmasp_intf *intf)
 	umac_wl(intf, 0x800, UMC_RX_MAX_PKT_SZ);
 }
 
-static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
+static int bcmasp_tx_reclaim(struct bcmasp_intf *intf)
 {
-	struct bcmasp_intf *intf =
-		container_of(napi, struct bcmasp_intf, tx_napi);
 	struct bcmasp_intf_stats64 *stats = &intf->stats64;
 	struct device *kdev = &intf->parent->pdev->dev;
 	unsigned long read, released = 0;
@@ -481,10 +479,16 @@ static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
 							DESC_RING_COUNT);
 	}
 
-	/* Ensure all descriptors have been written to DRAM for the hardware
-	 * to see updated contents.
-	 */
-	wmb();
+	return released;
+}
+
+static int bcmasp_tx_poll(struct napi_struct *napi, int budget)
+{
+	struct bcmasp_intf *intf =
+		container_of(napi, struct bcmasp_intf, tx_napi);
+	int released = 0;
+
+	released = bcmasp_tx_reclaim(intf);
 
 	napi_complete(&intf->tx_napi);
 
@@ -796,6 +800,7 @@ static int bcmasp_init_tx(struct bcmasp_intf *intf)
 
 	intf->tx_spb_index = 0;
 	intf->tx_spb_clean_index = 0;
+	memset(intf->tx_cbs, 0, sizeof(struct bcmasp_tx_cb) * DESC_RING_COUNT);
 
 	netif_napi_add_tx(intf->ndev, &intf->tx_napi, bcmasp_tx_poll);
 
@@ -906,6 +911,8 @@ static void bcmasp_netif_deinit(struct net_device *dev)
 	} while (timeout-- > 0);
 	tx_spb_dma_wl(intf, 0x0, TX_SPB_DMA_FIFO_CTRL);
 
+	bcmasp_tx_reclaim(intf);
+
 	umac_enable_set(intf, UMC_CMD_TX_EN, 0);
 
 	phy_stop(dev->phydev);
-- 
2.43.0



