Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B112D210;
	Tue, 30 Apr 2024 11:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475269; cv=none; b=l5Me/J94MjfVxOQvtTRglU9smYgk9VbhR6gqycLiePHMHsyJ0IFYNXU4lttnaUIrAAqvBX/wKWPpx6obYbd9qN1/JykaywNgzmFyqYwEHzVECKoWFYU5/a7shHedHZ7/V0iLJEWEkY0FOnQjtLUax1VAvcbmMRFi7ZPzIK4bX/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475269; c=relaxed/simple;
	bh=j+SUTutyCciRHI+WUuS3GGR2RZ0zQ1YB8x+CaAdRjJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beSM0XOMf3SbRL9q78J+98pG5Xw4LTzRl2c/Rjal4wiDPY8y8LmjhWh9ZTwrDakDOd1L3C4wceEC8SXEnjifrGlC1A8QLHV91ekcwTmCq31fU1bZ/w5JAmJ06xMg1nCGJhIFJoZB2Mkrf8xRZzuwnvvcmRJdcz0er4Jj51Yh5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwejM/Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwejM/Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED21CC2BBFC;
	Tue, 30 Apr 2024 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475269;
	bh=j+SUTutyCciRHI+WUuS3GGR2RZ0zQ1YB8x+CaAdRjJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwejM/DvcBkrpq5M7B99GWABL4K3Bd2YTtWYkZj4tyDO9wz7dK7kLD4PcHBN2PTSX
	 fOJ745mNocfrFXCEcpzZ9fJCMiZa62ujiG5Tdssf1JlMxkBTdtbEOH58+OWW9GXDUs
	 W0idrqkpI77ydu8KUskLVtMP3Y7JX0wCV5v++z38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/186] net: bcmasp: fix memory leak when bringing down interface
Date: Tue, 30 Apr 2024 12:38:18 +0200
Message-ID: <20240430103059.368794743@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3d04f49f77e9..6bf149d645941 100644
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
 
@@ -794,6 +798,7 @@ static int bcmasp_init_tx(struct bcmasp_intf *intf)
 
 	intf->tx_spb_index = 0;
 	intf->tx_spb_clean_index = 0;
+	memset(intf->tx_cbs, 0, sizeof(struct bcmasp_tx_cb) * DESC_RING_COUNT);
 
 	netif_napi_add_tx(intf->ndev, &intf->tx_napi, bcmasp_tx_poll);
 
@@ -904,6 +909,8 @@ static void bcmasp_netif_deinit(struct net_device *dev)
 	} while (timeout-- > 0);
 	tx_spb_dma_wl(intf, 0x0, TX_SPB_DMA_FIFO_CTRL);
 
+	bcmasp_tx_reclaim(intf);
+
 	umac_enable_set(intf, UMC_CMD_TX_EN, 0);
 
 	phy_stop(dev->phydev);
-- 
2.43.0



