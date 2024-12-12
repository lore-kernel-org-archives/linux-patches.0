Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D31D1632E6;
	Thu, 12 Dec 2024 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023926; cv=none; b=ry2T/CxhNYibfJcDYtnehUhRKu2UCvoMuZF7m6nBvZVCB248dd8CriNMl1ZfBgMUSqRYRrTzEgb2RaH8EaVW2JZFyy215w1UVGyueKtwuW7v9THkHUGDRdDtanaV0PQKbNsxLTwgbDlenig+9p/XHi5FrkWMFWBUCl9VS9TIWIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023926; c=relaxed/simple;
	bh=pNYxAcGRp7+VAO0U3/6uXUbtipbTwDZyNeQuyC7Vywk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vogy/5kW34NQ0bzQ1cGs2TgSRM1utOi9HRr4Gyn53p1l4SGVUhVL8CefdESKMb5iq5Xu0Ik4dJ9AymFFJ1H6j1YBTDc0TRtfdsTwzs39sCHcnhjDavzgLrcOIEFTbkNu7CsvJr41C3ZuguNkPuNvAYyaRHyys1mVvOCJ7ig06ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU4JiF6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU4JiF6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9842C4CECE;
	Thu, 12 Dec 2024 17:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023926;
	bh=pNYxAcGRp7+VAO0U3/6uXUbtipbTwDZyNeQuyC7Vywk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU4JiF6csXreMS7PxFyUe/Qwdp43Qy37saz9n5D0XgDNAWUlrQr/a1+NLhhWZWTqz
	 TL/RlK++ZbrBpYKlhvnMa2PCpcMuBNT0WTg/xPt85mrO2n4rKjeVULoOly80TfCfGE
	 kJlBkPpBbVY0cQ3LMEm4fj5advrjj9K0LrnMn/d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christina Jacob <cjacob@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/459] octeontx2-pf: ethtool fec mode support
Date: Thu, 12 Dec 2024 15:57:47 +0100
Message-ID: <20241212144258.600453175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christina Jacob <cjacob@marvell.com>

[ Upstream commit d0cf9503e908ee7b235a5efecedeb74aabc482f3 ]

Add ethtool support to configure fec modes baser/rs and
support to fecth FEC stats from CGX as well PHY.

Configure fec mode
	- ethtool --set-fec eth0 encoding rs/baser/off/auto
Query fec mode
	- ethtool --show-fec eth0

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e26f8eac6bb2 ("octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       |  20 +++
 .../marvell/octeontx2/nic/otx2_common.h       |   6 +
 .../marvell/octeontx2/nic/otx2_ethtool.c      | 160 +++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   3 +
 4 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 3b4530bc30378..2b6baf0ad3f7d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -60,6 +60,19 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 }
 
+void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf)
+{
+	struct msg_req *req;
+
+	if (!netif_running(pfvf->netdev))
+		return;
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_fec_stats(&pfvf->mbox);
+	if (req)
+		otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+}
+
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)
 {
 	struct otx2_rcv_queue *rq = &pfvf->qset.rq[qidx];
@@ -1492,6 +1505,13 @@ void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 		pfvf->hw.cgx_tx_stats[id] = rsp->tx_stats[id];
 }
 
+void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
+				struct cgx_fec_stats_rsp *rsp)
+{
+	pfvf->hw.cgx_fec_corr_blks += rsp->fec_corr_blks;
+	pfvf->hw.cgx_fec_uncorr_blks += rsp->fec_uncorr_blks;
+}
+
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 386cb08497e48..866b1a2cc9a12 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -197,6 +197,8 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
+	u64			cgx_fec_corr_blks;
+	u64			cgx_fec_uncorr_blks;
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
 };
@@ -627,6 +629,9 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
 void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 			    struct cgx_stats_rsp *rsp);
+void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
+				struct cgx_fec_stats_rsp *rsp);
+void otx2_set_fec_stats_count(struct otx2_nic *pfvf);
 void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
 				struct nix_bp_cfg_rsp *rsp);
 
@@ -635,6 +640,7 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf);
 void otx2_get_stats64(struct net_device *netdev,
 		      struct rtnl_link_stats64 *stats);
 void otx2_update_lmac_stats(struct otx2_nic *pfvf);
+void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf);
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
 int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
 void otx2_set_ethtool_ops(struct net_device *netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index fc4ca8246df24..540a16d0a3274 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -66,6 +66,8 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
 static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
 static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
 
+static struct cgx_fw_data *otx2_get_fwdata(struct otx2_nic *pfvf);
+
 static void otx2_get_drvinfo(struct net_device *netdev,
 			     struct ethtool_drvinfo *info)
 {
@@ -128,6 +130,10 @@ static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 
 	strcpy(data, "reset_count");
 	data += ETH_GSTRING_LEN;
+	sprintf(data, "Fec Corrected Errors: ");
+	data += ETH_GSTRING_LEN;
+	sprintf(data, "Fec Uncorrected Errors: ");
+	data += ETH_GSTRING_LEN;
 }
 
 static void otx2_get_qset_stats(struct otx2_nic *pfvf,
@@ -160,11 +166,30 @@ static void otx2_get_qset_stats(struct otx2_nic *pfvf,
 	}
 }
 
+static int otx2_get_phy_fec_stats(struct otx2_nic *pfvf)
+{
+	struct msg_req *req;
+	int rc = -ENOMEM;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_get_phy_fec_stats(&pfvf->mbox);
+	if (!req)
+		goto end;
+
+	if (!otx2_sync_mbox_msg(&pfvf->mbox))
+		rc = 0;
+end:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
 /* Get device and per queue statistics */
 static void otx2_get_ethtool_stats(struct net_device *netdev,
 				   struct ethtool_stats *stats, u64 *data)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	u64 fec_corr_blks, fec_uncorr_blks;
+	struct cgx_fw_data *rsp;
 	int stat;
 
 	otx2_get_dev_stats(pfvf);
@@ -183,6 +208,32 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 	for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
 		*(data++) = pfvf->hw.cgx_tx_stats[stat];
 	*(data++) = pfvf->reset_count;
+
+	fec_corr_blks = pfvf->hw.cgx_fec_corr_blks;
+	fec_uncorr_blks = pfvf->hw.cgx_fec_uncorr_blks;
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
+	    !otx2_get_phy_fec_stats(pfvf)) {
+		/* Fetch fwdata again because it's been recently populated with
+		 * latest PHY FEC stats.
+		 */
+		rsp = otx2_get_fwdata(pfvf);
+		if (!IS_ERR(rsp)) {
+			struct fec_stats_s *p = &rsp->fwdata.phy.fec_stats;
+
+			if (pfvf->linfo.fec == OTX2_FEC_BASER) {
+				fec_corr_blks   = p->brfec_corr_blks;
+				fec_uncorr_blks = p->brfec_uncorr_blks;
+			} else {
+				fec_corr_blks   = p->rsfec_corr_cws;
+				fec_uncorr_blks = p->rsfec_uncorr_cws;
+			}
+		}
+	}
+
+	*(data++) = fec_corr_blks;
+	*(data++) = fec_uncorr_blks;
 }
 
 static int otx2_get_sset_count(struct net_device *netdev, int sset)
@@ -195,9 +246,11 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 
 	qstats_count = otx2_n_queue_stats *
 		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
+	otx2_update_lmac_fec_stats(pfvf);
 
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
-		CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + 1;
+	       CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + OTX2_FEC_STATS_CNT
+	       + 1;
 }
 
 /* Get no of queues device supports and current queue count */
@@ -700,6 +753,109 @@ static int otx2_get_ts_info(struct net_device *netdev,
 	return 0;
 }
 
+static struct cgx_fw_data *otx2_get_fwdata(struct otx2_nic *pfvf)
+{
+	struct cgx_fw_data *rsp = NULL;
+	struct msg_req *req;
+	int err = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_get_aux_link_info(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (!err) {
+		rsp = (struct cgx_fw_data *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	} else {
+		rsp = ERR_PTR(err);
+	}
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return rsp;
+}
+
+static int otx2_get_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp;
+	const int fec[] = {
+		ETHTOOL_FEC_OFF,
+		ETHTOOL_FEC_BASER,
+		ETHTOOL_FEC_RS,
+		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
+#define FEC_MAX_INDEX 4
+	if (pfvf->linfo.fec < FEC_MAX_INDEX)
+		fecparam->active_fec = fec[pfvf->linfo.fec];
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
+		if (!rsp->fwdata.supported_fec)
+			fecparam->fec = ETHTOOL_FEC_NONE;
+		else
+			fecparam->fec = fec[rsp->fwdata.supported_fec];
+	}
+	return 0;
+}
+
+static int otx2_set_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct mbox *mbox = &pfvf->mbox;
+	struct fec_mode *req, *rsp;
+	int err = 0, fec = 0;
+
+	switch (fecparam->fec) {
+	/* Firmware does not support AUTO mode consider it as FEC_OFF */
+	case ETHTOOL_FEC_OFF:
+	case ETHTOOL_FEC_AUTO:
+		fec = OTX2_FEC_OFF;
+		break;
+	case ETHTOOL_FEC_RS:
+		fec = OTX2_FEC_RS;
+		break;
+	case ETHTOOL_FEC_BASER:
+		fec = OTX2_FEC_BASER;
+		break;
+	default:
+		netdev_warn(pfvf->netdev, "Unsupported FEC mode: %d",
+			    fecparam->fec);
+		return -EINVAL;
+	}
+
+	if (fec == pfvf->linfo.fec)
+		return 0;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto end;
+	}
+	req->fec = fec;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto end;
+
+	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+						   0, &req->hdr);
+	if (rsp->fec >= 0)
+		pfvf->linfo.fec = rsp->fec;
+	else
+		err = rsp->fec;
+end:
+	mutex_unlock(&mbox->lock);
+	return err;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -725,6 +881,8 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_ts_info		= otx2_get_ts_info,
+	.get_fecparam		= otx2_get_fecparam,
+	.set_fecparam		= otx2_set_fecparam,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index aada28868ac59..1516f24837754 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -787,6 +787,9 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 	case MBOX_MSG_CGX_STATS:
 		mbox_handler_cgx_stats(pf, (struct cgx_stats_rsp *)msg);
 		break;
+	case MBOX_MSG_CGX_FEC_STATS:
+		mbox_handler_cgx_fec_stats(pf, (struct cgx_fec_stats_rsp *)msg);
+		break;
 	default:
 		if (msg->rc)
 			dev_err(pf->dev,
-- 
2.43.0



