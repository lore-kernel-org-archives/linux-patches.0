Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0614F85AE;
	Thu, 17 Sep 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664334; cv=none; b=SPeHFfrzcYTCtWy4SvXz62TmTnxAR9FpMSY+j7/1k9c6jcDGD8zKNx2FbgeGlSatHEli6uieRmZCg5G3cj2BuxLG5paiZOnv/mY6WXjttnfFZLFj0rq1TQhtFdbTKSTmuvV3mAiqc9PPfLna4O+OYITUxD6qKtY2fTOXOtkC6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664334; c=relaxed/simple;
	bh=CAZqHIvIvsnhZK94yVBWUTk115bH3I4OysNfedD3AmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG592SJQd47eJMn2V9jg5HSIocjZGo7UgeVOENdkznbfAF31YbgrUXXpfIRK6+nvHNYB3imbOY6G/FPibLAz0aNNVsZoFSNv6tOxwgYjDqHPV7ztP8B14z1Kvx+RFzC5NnGc/gZQZqlLQ7rIpR9Qxe7GQV3hTkPgo0EisvYxlyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bh4mRW/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bh4mRW/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9295D1F000FF;
	Thu, 17 Sep 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664333;
	bh=hnCE6mVJS58qyvltEV0y1eP1ZUGiT+AVdI+AbC56YyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bh4mRW/f2uBrA6uIjh3V/NPxom/EEjf4WiRPY0QmxUB91BQVgLfjMOXWrUR3xELwy
	 C7N8R6ExJjzRddtawHkppVJZEg+PIF6I9JLnlwrODQSVzmFANhEK9oznZTF4p9Y+EY
	 j0cVBq0G9MZYYZy0HqO9tulIF+IpGyBqJAAC5UB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0298/1250] dpaa2-switch: fix the error path in dpaa2_switch_rx()
Date: Thu, 17 Sep 2026 16:01:33 +0100
Message-ID: <20260917151600.198004366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 13e9e0f34a1b9..c65ecb187af3d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2438,18 +2438,13 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 
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
@@ -2475,6 +2470,7 @@ static void dpaa2_switch_tx_conf(struct dpaa2_switch_fq *fq,
 static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 			    const struct dpaa2_fd *fd)
 {
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
 	struct ethsw_core *ethsw = fq->ethsw;
 	struct ethsw_port_priv *port_priv;
 	struct net_device *netdev;
@@ -2482,10 +2478,14 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
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
@@ -2501,7 +2501,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		}
 	}
 
-	skb = dpaa2_switch_build_linear_skb(ethsw, fd);
+	skb = dpaa2_switch_build_linear_skb(ethsw, fd, vaddr);
 	if (unlikely(!skb))
 		goto err_free_fd;
 
@@ -2519,7 +2519,8 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 		err = __skb_vlan_pop(skb, &vlan_tci);
 		if (err) {
 			dev_info(ethsw->dev, "__skb_vlan_pop() returned %d", err);
-			goto err_free_fd;
+			kfree_skb(skb);
+			return;
 		}
 	}
 
@@ -2534,7 +2535,7 @@ static void dpaa2_switch_rx(struct dpaa2_switch_fq *fq,
 	return;
 
 err_free_fd:
-	dpaa2_switch_free_fd(ethsw, fd);
+	free_pages((unsigned long)vaddr, 0);
 }
 
 static void dpaa2_switch_detect_features(struct ethsw_core *ethsw)
-- 
2.53.0



