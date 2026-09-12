Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2093F417BD2;
	Sat, 12 Sep 2026 09:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205289; cv=none; b=DPh+17c/D8U54pB5GX2qiL+r6TaHSpz63ODFjqh9cPnS7AnCdQ6wj/nDfR+RD9KpyV3WVlh3mvI2oRt/dvCW25BwUCaugf/WHS+LNIUmioqCrwCYRtXAZ0QNILE0Ql7dP1N6Yl+KledEovB02j+a3xESKUdasxwtXB1fF8bvIs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205289; c=relaxed/simple;
	bh=4xeOVnHkzV0s2lhKxPVOgY3vLzGNDal3EtNIY/kC3A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccyB/hQehTg/iPqHCV7Cnyg0uuJQ/9W1qiAYSGER/QczwQlZstRGNdpbieEe6JbisSMDm+3nItl0WX/3kgTkZp9I0EfCK8HZdLU3k37g4ArRAYuQJ/5lgfNqj5/K9CKG+fFkoYN709IdNnuHWpfwAAwcBPRqfUOb5Wzy91/twEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UO6Rgej2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UO6Rgej2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C919B1F000FF;
	Sat, 12 Sep 2026 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205287;
	bh=nxQc71LnBkPNQbY+KT8TE0RF7oBcfbKHGkWiD/m2jKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UO6Rgej2t0r9JANPmPxusnasb123jkNlYM81OoYJif11WljGZ0k/qO3hu8VOydDst
	 UYD7DQU5X2Kd6xnXqmc9igAXnBAytHWUYSAoyJDlx7dTCtITp5anCPvRCwL2A9Kblp
	 eab9ei4upXBVXg7mCiw8KWoMSPs6kWWaKzBLck6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1745/1815] octeontx2-pf: fix NULL deref of af_xdp_zc_qidx on rep setup
Date: Sat, 12 Sep 2026 08:58:15 +0200
Message-ID: <20260912065729.948386977@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit b09a0503c755b6609fad59a84cc7f05b6843a03c ]

af_xdp_zc_qidx tracks receive queues using AF_XDP zero-copy and is
allocated during PF/VF probe. Representors and other non-AF_XDP paths
leave the pointer NULL, but several call sites used test_bit() on it
unconditionally.

Switching to devlink eswitch mode creates representors and runs
otx2_init_hw_resources(), which reaches otx2_pool_aq_init() and oopses
when dereferencing the NULL bitmap. Add NULL checks before every
af_xdp_zc_qidx test_bit() use in the RSS, ethtool, XSK, and pool init
paths.

Fixes: efabce290151 ("octeontx2-pf: AF_XDP zero copy receive support")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260821105536.2998765-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 6 ++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_xsk.c     | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 3d253132a17f0..52980c4afb54b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -333,7 +333,8 @@ int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id, const u32 *ind_tbl)
 	/* Get memory to put this msg */
 	for (idx = 0; idx < rss->rss_size; idx++) {
 		/* Ignore the queue if AF_XDP zero copy is enabled */
-		if (test_bit(ind_tbl[idx], pfvf->af_xdp_zc_qidx))
+		if (pfvf->af_xdp_zc_qidx &&
+		    test_bit(ind_tbl[idx], pfvf->af_xdp_zc_qidx))
 			continue;
 
 		aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);
@@ -1510,7 +1511,8 @@ int otx2_pool_aq_init(struct otx2_nic *pfvf, u16 pool_id,
 	if (type != AURA_NIX_RQ)
 		return 0;
 
-	if (!test_bit(pool_id, pfvf->af_xdp_zc_qidx)) {
+	if (!pfvf->af_xdp_zc_qidx ||
+	    !test_bit(pool_id, pfvf->af_xdp_zc_qidx)) {
 		pp_params.order = get_order(buf_size);
 		pp_params.flags = PP_FLAG_DMA_MAP;
 		pp_params.pool_size = min(OTX2_PAGE_POOL_SZ, numptrs);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index a0340f3422bf9..9bee1b91eeaa6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -939,7 +939,8 @@ static int otx2_get_rxfh(struct net_device *dev,
 
 	for (idx = 0; idx < rss->rss_size; idx++) {
 		/* Ignore if the rx queue is AF_XDP zero copy enabled */
-		if (test_bit(rss->ind_tbl[idx], pfvf->af_xdp_zc_qidx))
+		if (pfvf->af_xdp_zc_qidx &&
+		    test_bit(rss->ind_tbl[idx], pfvf->af_xdp_zc_qidx))
 			continue;
 		indir[idx] = rss->ind_tbl[idx];
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_xsk.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_xsk.c
index 7d67b4cbaf716..0e8a6a6486c4a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_xsk.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_xsk.c
@@ -193,7 +193,8 @@ int otx2_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 
 void otx2_attach_xsk_buff(struct otx2_nic *pfvf, struct otx2_snd_queue *sq, int qidx)
 {
-	if (test_bit(qidx, pfvf->af_xdp_zc_qidx))
+	if (pfvf->af_xdp_zc_qidx &&
+	    test_bit(qidx, pfvf->af_xdp_zc_qidx))
 		sq->xsk_pool = xsk_get_pool_from_qid(pfvf->netdev, qidx);
 }
 
-- 
2.53.0



