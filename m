Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95454F93A1;
	Thu, 17 Sep 2026 17:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667912; cv=none; b=EkOUtVGsnfi3VwiyGTtOXVPLnszfEndwCrsY0gTCl9zPZF4fevawWzEsHtywa2wSWdnqbFCnFNAT2d7rQvC3xSgI7XNBXnJr5Ucyvys3TT42Jc7dXINKc21e4h6jDOj6skEZTaJqj3Jki5YC7LOsTnhp+Dbv/gsTHyxvw3IJK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667912; c=relaxed/simple;
	bh=HrqdAAIBlb8I5n3ZC8mRIP4XOhK4SLPOKz2oot7SppE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bF+qlu/tWYWbfU87f80pDT0U/fsgHss63ZNZ7nmCfcZktJ54ukZ3xK0WxjxpZDqYjE5u4qLY5SBLt5Gzi80T+7rhfIETEMfuasgQQdsPqyl19r9T62oz2aF1Bp83j3ycXuxBhdIXFLpHHgV4ogowva0chLzv5yqBFgWh4j3vlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXJzGWPJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXJzGWPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442AD1F00893;
	Thu, 17 Sep 2026 17:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667910;
	bh=Re0tVe+w8r2Y4ZyP7QkZSM45h4cyt4kzzv7xGbOmQbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXJzGWPJ/0YzMmFzr/FswuSEuvwwb+IN0u3VMbylPngLrgZ9sn6Qj/P2dnL3irJYA
	 wr07hmJp0cUrec5d0LE2mnLBLN5kwVq/drM/Q16TOelLV5FBTOLT0u362AO55NpR59
	 DQFmlWluyy+XgwxX2G/YyNUp7aRR3nhbK3DGEb6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0214/1102] dpaa2-switch: fix the error path in dpaa2_switch_rx()
Date: Thu, 17 Sep 2026 16:02:37 +0100
Message-ID: <20260917151544.950176443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 74c1c9f5c0c30bbd0c2cf87b6e3507e7ea46c13d ]

In case of an error in dpaa2_switch_rx(), the dpaa2_switch_free_fd()
function is called in order to free the FD. This is incorrect since the
dpaa2_switch_free_fd() is intended to be used on Tx frame descriptors,
meaning that it expects in the software annotation area of the FD data
to find a valid skb pointer on which to call dev_kfree_skb().

Fix this by extracting the dma_unmap_page() from
dpaa2_switch_build_linear_skb() directly into the dpaa2_switch_rx()
function. This allows us to directly use free_pages() in case of an
error before an SKB was created and kfree_skb() afterwards.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-3-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d2e1dffe6e0c6..ff3a71c4419f2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2437,18 +2437,13 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 
 /* Build a linear skb based on a single-buffer frame descriptor */
 static struct sk_buff *dpaa2_switch_build_linear_skb(struct ethsw_core *ethsw,
-						     const struct dpaa2_fd *fd)
+						     const struct dpaa2_fd *fd,
+						     void *fd_vaddr)
 {
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
-	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	u32 fd_length = dpaa2_fd_get_len(fd);
 	struct device *dev = ethsw->dev;
 	struct sk_buff *skb = NULL;
-	void *fd_vaddr;
-
-	fd_vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
-	dma_unmap_page(dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
-		       DMA_FROM_DEVICE);
 
 	skb = build_skb(fd_vaddr, DPAA2_SWITCH_RX_BUF_SIZE +
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
@@ -2474,6 +2469,7 @@ static void dpaa2_switch_tx_conf(struct dpaa2_switch_fq *fq,
 static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 			    const struct dpaa2_fd *fd)
 {
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	struct ethsw_core *ethsw = fq->ethsw;
 	struct ethsw_port_priv *port_priv;
 	struct net_device *netdev;
@@ -2481,10 +2477,14 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	struct sk_buff *skb;
 	u16 vlan_tci, vid;
 	int if_id, err;
+	void *vaddr;
+
+	vaddr = dpaa2_iova_to_virt(ethsw->iommu_domain, addr);
+	dma_unmap_page(ethsw->dev, addr, DPAA2_SWITCH_RX_BUF_SIZE,
+		       DMA_FROM_DEVICE);
 
 	/* get switch ingress interface ID */
 	if_id = upper_32_bits(dpaa2_fd_get_flc(fd)) & 0x0000FFFF;
-
 	if (if_id >= ethsw->sw_attr.num_ifs) {
 		dev_err(ethsw->dev, "Frame received from unknown interface!\n");
 		goto err_free_fd;
@@ -2500,7 +2500,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		}
 	}
 
-	skb = dpaa2_switch_build_linear_skb(ethsw, fd);
+	skb = dpaa2_switch_build_linear_skb(ethsw, fd, vaddr);
 	if (unlikely(!skb))
 		goto err_free_fd;
 
@@ -2518,7 +2518,8 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		err = __skb_vlan_pop(skb, &vlan_tci);
 		if (err) {
 			dev_info(ethsw->dev, "__skb_vlan_pop() returned %d", err);
-			goto err_free_fd;
+			kfree_skb(skb);
+			return;
 		}
 	}
 
@@ -2533,7 +2534,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	return;
 
 err_free_fd:
-	dpaa2_switch_free_fd(ethsw, fd);
+	free_pages((unsigned long)vaddr, 0);
 }
 
 static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
-- 
2.53.0



