Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7349C8DD;
	Sat, 13 Jan 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj0fR5bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BABC433F1;
	Sat, 13 Jan 2024 10:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140043;
	bh=yGliNyXmMq7953sYMgWEXBdYhtgy9F3mT6rXFcocTW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj0fR5bInK76YpP1fqYB3UVC6sXe3WJ6vUzgeFlyJH6klXSZWSgwa/GZuoKC9bToz
	 TCLVjn+PhKAfygCUgHssI0xSK3cbvVejU5L06EG196Ror2M1PCBFu9Zq+0Sz2sb+70
	 rlO1aWtmQla9KIx0GNkaqQsyyQZ7Q2TZ0nBW+xlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/59] octeontx2-af: Dont enable Pause frames by default
Date: Sat, 13 Jan 2024 10:50:06 +0100
Message-ID: <20240113094210.386136085@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit d957b51f7ed66dbe6102f1bba0587fdfc0119a94 ]

Current implementation is such that 802.3x pause frames are
enabled by default.  As CGX and RPM blocks support PFC
(priority flow control) also, instead of driver enabling one
between them enable them upon request from PF or its VFs.
Also add support to disable pause frames in driver unbind.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a0d9528f6daf ("octeontx2-af: Always configure NIX TX link credits based on max frame size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 41 ++++++----------
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 47 +++++--------------
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  8 ----
 .../marvell/octeontx2/nic/otx2_common.c       |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 15 +++---
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 12 +++--
 6 files changed, 44 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 8ac95cb7bbb74..098504aa0fd2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -789,21 +789,8 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return;
-	if (enable) {
-		/* Enable receive pause frames */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
-		cfg |= CGX_SMUX_RX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
-
-		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
-		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
-
-		/* Enable pause frames transmission */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
-		cfg |= CGX_SMUX_TX_CTL_L2P_BP_CONV;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
 
+	if (enable) {
 		/* Set pause time and interval */
 		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_TIME,
 			  DEFAULT_PAUSE_TIME);
@@ -820,21 +807,21 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 		cfg &= ~0xFFFFULL;
 		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL,
 			  cfg | (DEFAULT_PAUSE_TIME / 2));
-	} else {
-		/* ALL pause frames received are completely ignored */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
-		cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+	}
 
-		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
-		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+	/* ALL pause frames received are completely ignored */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
 
-		/* Disable pause frames transmission */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
-		cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
-	}
+	cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+	cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+	cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+	/* Disable pause frames transmission */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+	cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
 }
 
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 9ea2f6ac38ec1..8c0b35a868cfe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -167,26 +167,6 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	u64 cfg;
 
 	if (enable) {
-		/* Enable 802.3 pause frame mode */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable receive pause frames */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable forward pause to TX block */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable pause frames transmission */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
 		/* Set pause time and interval */
 		cfg = rpm_read(rpm, lmac_id,
 			       RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA);
@@ -199,23 +179,22 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 		cfg &= ~0xFFFFULL;
 		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_QUANTA_THRESH,
 			  cfg | (RPM_DEFAULT_PAUSE_TIME / 2));
+	}
 
-	} else {
-		/* ALL pause frames received are completely ignored */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	/* ALL pause frames received are completely ignored */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-		/* Disable forward pause to TX block */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	/* Disable forward pause to TX block */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-		/* Disable pause frames transmission */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-	}
+	/* Disable pause frames transmission */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 }
 
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 5f9f6da5c45bb..1ab9dc544eeea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -296,7 +296,6 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct sdp_node_info *sdp_info;
 	int pkind, pf, vf, lbkid, vfid;
-	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	bool from_vf;
 	int err;
@@ -326,13 +325,6 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
 
-		mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
-
-		/* By default we enable pause frames */
-		if ((pcifunc & RVU_PFVF_FUNC_MASK) == 0)
-			mac_ops->mac_enadis_pause_frm(rvu_cgx_pdata(cgx_id,
-								    rvu),
-						      lmac_id, true, true);
 		break;
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index b743646993ca2..572c981171bac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -262,6 +262,7 @@ int otx2_config_pause_frm(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
 }
+EXPORT_SYMBOL(otx2_config_pause_frm);
 
 int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f9bb0e9e73592..167b926196c83 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1785,9 +1785,6 @@ int otx2_open(struct net_device *netdev)
 	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
 		otx2_handle_link_event(pf);
 
-	/* Restore pause frame settings */
-	otx2_config_pause_frm(pf);
-
 	/* Install DMAC Filters */
 	if (pf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
 		otx2_dmacflt_reinstall_flows(pf);
@@ -2777,10 +2774,6 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
-	/* Enable pause frames by default */
-	pf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
-	pf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-
 	return 0;
 
 err_pf_sriov_init:
@@ -2924,6 +2917,14 @@ static void otx2_remove(struct pci_dev *pdev)
 	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED)
 		otx2_config_hw_rx_tstamp(pf, false);
 
+	/* Disable 802.3x pause frames */
+	if (pf->flags & OTX2_FLAG_RX_PAUSE_ENABLED ||
+	    (pf->flags & OTX2_FLAG_TX_PAUSE_ENABLED)) {
+		pf->flags &= ~OTX2_FLAG_RX_PAUSE_ENABLED;
+		pf->flags &= ~OTX2_FLAG_TX_PAUSE_ENABLED;
+		otx2_config_pause_frm(pf);
+	}
+
 	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index e69b0e2729cb2..689e0853ab9cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -695,10 +695,6 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
-	/* Enable pause frames by default */
-	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
-	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-
 	return 0;
 
 err_unreg_netdev:
@@ -732,6 +728,14 @@ static void otx2vf_remove(struct pci_dev *pdev)
 
 	vf = netdev_priv(netdev);
 
+	/* Disable 802.3x pause frames */
+	if (vf->flags & OTX2_FLAG_RX_PAUSE_ENABLED ||
+	    (vf->flags & OTX2_FLAG_TX_PAUSE_ENABLED)) {
+		vf->flags &= ~OTX2_FLAG_RX_PAUSE_ENABLED;
+		vf->flags &= ~OTX2_FLAG_TX_PAUSE_ENABLED;
+		otx2_config_pause_frm(vf);
+	}
+
 	cancel_work_sync(&vf->reset_task);
 	otx2_unregister_dl(vf);
 	unregister_netdev(netdev);
-- 
2.43.0



