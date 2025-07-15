Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5E72E718E;
	Tue, 15 Jul 2025 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587724; cv=none; b=q8XgUfCpo/I3B3sXb/avxDG++++Xe67vroYFEgGUr6S4+fhBWglx8fMT0IJhe7yniZBSLkK7/W64tu9YEJI5Gju1m02EFFp7WNb8J2QN+Qiy1txdqXqB9yeaiXrZ1h0GKVadh8cU4ce4dwKuh3L/u9cOGlIY5pE4CjLvfDFM55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587724; c=relaxed/simple;
	bh=u23/mNFEJgK8viNDxgIFrVcOcDQs0jOQxHNN5T01/9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bOxJ5hlaZpGJhyTdbfyJcL0N16EmyTgRXNYNchkNNdl2vFZrJr2w3UP0jEGmKo995H39aD5uiCMkyBR4E2VVFUmOzErTQqpMlbQULiHFjUVKEtPiphRueuieUUyOE9Okq3tU5BEb4aXR+zGodqtoSU2N/0IMPsRgRq0pbMqTH1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuA//h8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuA//h8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33805C4CEE3;
	Tue, 15 Jul 2025 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587724;
	bh=u23/mNFEJgK8viNDxgIFrVcOcDQs0jOQxHNN5T01/9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuA//h8Mh4jOTAdO02dNs+lFdQZ9zAp+vv2ueIWBOfFINs5L3rRe0dKseZDgjWAK7
	 DcZMab9mJ3XX3mfZznI0/k4Dya8uIoxh1Mj3OyBmz5/+j8cl6yMSh3poy31LyaQsvU
	 tyGC+IpWKvJWeKLEbtoEOfM6vPP0CDIukD3dM8zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/208] dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
Date: Tue, 15 Jul 2025 15:13:48 +0200
Message-ID: <20250715130815.711951665@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 28d137cc8c0bd2c9501b8eb0855b631289c7b4a3 ]

Rename the dpaa2_eth_xdp_release_buf function into dpaa2_eth_recycle_buf
since in the next patches we'll be using the same recycle mechanism for
the normal stack path beside for XDP_DROP.

Also, rename the array which holds the buffers to be recycled so that it
does not have any reference to XDP.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2def09ead4ad ("dpaa2-eth: fix xdp_rxq_info leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 26 +++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  6 +++--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fa202fea537f8..fa799cc044426 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -223,31 +223,31 @@ static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
 	}
 }
 
-static void dpaa2_eth_xdp_release_buf(struct dpaa2_eth_priv *priv,
-				      struct dpaa2_eth_channel *ch,
-				      dma_addr_t addr)
+static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+				  struct dpaa2_eth_channel *ch,
+				  dma_addr_t addr)
 {
 	int retries = 0;
 	int err;
 
-	ch->xdp.drop_bufs[ch->xdp.drop_cnt++] = addr;
-	if (ch->xdp.drop_cnt < DPAA2_ETH_BUFS_PER_CMD)
+	ch->recycled_bufs[ch->recycled_bufs_cnt++] = addr;
+	if (ch->recycled_bufs_cnt < DPAA2_ETH_BUFS_PER_CMD)
 		return;
 
 	while ((err = dpaa2_io_service_release(ch->dpio, priv->bpid,
-					       ch->xdp.drop_bufs,
-					       ch->xdp.drop_cnt)) == -EBUSY) {
+					       ch->recycled_bufs,
+					       ch->recycled_bufs_cnt)) == -EBUSY) {
 		if (retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
 			break;
 		cpu_relax();
 	}
 
 	if (err) {
-		dpaa2_eth_free_bufs(priv, ch->xdp.drop_bufs, ch->xdp.drop_cnt);
-		ch->buf_count -= ch->xdp.drop_cnt;
+		dpaa2_eth_free_bufs(priv, ch->recycled_bufs, ch->recycled_bufs_cnt);
+		ch->buf_count -= ch->recycled_bufs_cnt;
 	}
 
-	ch->xdp.drop_cnt = 0;
+	ch->recycled_bufs_cnt = 0;
 }
 
 static int dpaa2_eth_xdp_flush(struct dpaa2_eth_priv *priv,
@@ -300,7 +300,7 @@ static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
 		ch->stats.xdp_tx++;
 	}
 	for (i = enqueued; i < fq->xdp_tx_fds.num; i++) {
-		dpaa2_eth_xdp_release_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
+		dpaa2_eth_recycle_buf(priv, ch, dpaa2_fd_get_addr(&fds[i]));
 		percpu_stats->tx_errors++;
 		ch->stats.xdp_tx_err++;
 	}
@@ -386,7 +386,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
 		fallthrough;
 	case XDP_DROP:
-		dpaa2_eth_xdp_release_buf(priv, ch, addr);
+		dpaa2_eth_recycle_buf(priv, ch, addr);
 		ch->stats.xdp_drop++;
 		break;
 	case XDP_REDIRECT:
@@ -407,7 +407,7 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 				free_pages((unsigned long)vaddr, 0);
 			} else {
 				ch->buf_count++;
-				dpaa2_eth_xdp_release_buf(priv, ch, addr);
+				dpaa2_eth_recycle_buf(priv, ch, addr);
 			}
 			ch->stats.xdp_drop++;
 		} else {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 2825f53e7e9b1..e143d66ca2474 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -438,8 +438,6 @@ struct dpaa2_eth_fq {
 
 struct dpaa2_eth_ch_xdp {
 	struct bpf_prog *prog;
-	u64 drop_bufs[DPAA2_ETH_BUFS_PER_CMD];
-	int drop_cnt;
 	unsigned int res;
 };
 
@@ -457,6 +455,10 @@ struct dpaa2_eth_channel {
 	struct dpaa2_eth_ch_xdp xdp;
 	struct xdp_rxq_info xdp_rxq;
 	struct list_head *rx_list;
+
+	/* Buffers to be recycled back in the buffer pool */
+	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
+	int recycled_bufs_cnt;
 };
 
 struct dpaa2_eth_dist_fields {
-- 
2.39.5



