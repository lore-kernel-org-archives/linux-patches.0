Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0493D8912;
	Wed,  8 Apr 2026 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674479; cv=none; b=pvU3tlYJWo05DXs5mMCb1l4EZMw/JUYmWfCtQRI2Cz2fFNH7Q9UpAYOBhrgyPJQuWuiZBiLx6U3A9VNZX5V490CSnYDCsAZSusT1S5ySoaCmxPPNf42kf3Rb/fBQCfZF0RUK/zUKxnS70to2II4atbtMxcUXgbe5IJdTcPhQTAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674479; c=relaxed/simple;
	bh=2E6VDJhKOCOlrhMiPtt4PJNsvw3aPKqU5nkSOGlqgMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTAmsX1NDNrX4QkZvaI24TGI/1cYzuvo12oGR3k21zS2kqmNUi9diKXda88h1uAaBnQr4yVOZhaSxNBCk2iBJB24pQ9cpCKm0Gsa9uAdofZQDLfFqlKF59OToiVmrTQCqVmBhh7u64TUWMkqIQSSTElLJR9Ba9p7ryHkHo+uI+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAZuouPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAZuouPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F751C19421;
	Wed,  8 Apr 2026 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674479;
	bh=2E6VDJhKOCOlrhMiPtt4PJNsvw3aPKqU5nkSOGlqgMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAZuouPDz29yGuh2a+o+vd0mWdJ5IHom3E1Bn6uQs0LIgjGPCu7UhQhgnIyvkYUNw
	 aAnImMmryQ9bgAfd7IWJyhTkNndygaIIDy7XHdLugUw0szt58YOEqbJyckf5xd8KeH
	 KqBYdX7mjCv9bR1hFi5ihH4SnuiAcbiSw9pn55rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 114/311] bnxt_en: Refactor some basic ring setup and adjustment logic
Date: Wed,  8 Apr 2026 20:01:54 +0200
Message-ID: <20260408175943.671096973@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit ceee35e5674aa84cf9e504c2a9dae4587511556c ]

Refactor out the basic code that trims the default rings, sets up and
adjusts XDP TX rings and CP rings.  There is no change in behavior.
This is to prepare for the next bug fix patch.

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260331065138.948205-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e4bf81dcad0a ("bnxt_en: Don't assume XDP is never enabled in bnxt_init_dflt_ring_mode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 53 +++++++++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  5 +-
 4 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 300324ea1e8aa..bf888be2c54ed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12917,6 +12917,21 @@ static int bnxt_tx_nr_rings_per_tc(struct bnxt *bp)
 	return bp->num_tc ? bp->tx_nr_rings / bp->num_tc : bp->tx_nr_rings;
 }
 
+static void bnxt_set_xdp_tx_rings(struct bnxt *bp)
+{
+	bp->tx_nr_rings_xdp = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings += bp->tx_nr_rings_xdp;
+}
+
+static void bnxt_adj_tx_rings(struct bnxt *bp)
+{
+	/* Make adjustments if reserved TX rings are less than requested */
+	bp->tx_nr_rings -= bp->tx_nr_rings_xdp;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+	if (bp->tx_nr_rings_xdp)
+		bnxt_set_xdp_tx_rings(bp);
+}
+
 static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
@@ -12934,13 +12949,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (rc)
 		return rc;
 
-	/* Make adjustments if reserved TX rings are less than requested */
-	bp->tx_nr_rings -= bp->tx_nr_rings_xdp;
-	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
-	if (bp->tx_nr_rings_xdp) {
-		bp->tx_nr_rings_xdp = bp->tx_nr_rings_per_tc;
-		bp->tx_nr_rings += bp->tx_nr_rings_xdp;
-	}
+	bnxt_adj_tx_rings(bp);
 	rc = bnxt_alloc_mem(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
@@ -15377,11 +15386,19 @@ static int bnxt_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+void bnxt_set_cp_rings(struct bnxt *bp, bool sh)
+{
+	int tx_cp = bnxt_num_tx_to_cp(bp, bp->tx_nr_rings);
+
+	bp->cp_nr_rings = sh ? max_t(int, tx_cp, bp->rx_nr_rings) :
+			       tx_cp + bp->rx_nr_rings;
+}
+
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	bool sh = false;
-	int rc, tx_cp;
+	int rc;
 
 	if (tc > bp->max_tc) {
 		netdev_err(dev, "Too many traffic classes requested: %d. Max supported is %d.\n",
@@ -15414,9 +15431,7 @@ int bnxt_setup_mq_tc(struct net_device *dev, u8 tc)
 		bp->num_tc = 0;
 	}
 	bp->tx_nr_rings += bp->tx_nr_rings_xdp;
-	tx_cp = bnxt_num_tx_to_cp(bp, bp->tx_nr_rings);
-	bp->cp_nr_rings = sh ? max_t(int, tx_cp, bp->rx_nr_rings) :
-			       tx_cp + bp->rx_nr_rings;
+	bnxt_set_cp_rings(bp, sh);
 
 	if (netif_running(bp->dev))
 		return bnxt_open_nic(bp, true, false);
@@ -16421,6 +16436,15 @@ static void bnxt_trim_dflt_sh_rings(struct bnxt *bp)
 	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 }
 
+static void bnxt_adj_dflt_rings(struct bnxt *bp, bool sh)
+{
+	if (sh)
+		bnxt_trim_dflt_sh_rings(bp);
+	else
+		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
+}
+
 static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 {
 	int dflt_rings, max_rx_rings, max_tx_rings, rc;
@@ -16446,11 +16470,8 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		return rc;
 	bp->rx_nr_rings = min_t(int, dflt_rings, max_rx_rings);
 	bp->tx_nr_rings_per_tc = min_t(int, dflt_rings, max_tx_rings);
-	if (sh)
-		bnxt_trim_dflt_sh_rings(bp);
-	else
-		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
-	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
+
+	bnxt_adj_dflt_rings(bp, sh);
 
 	avail_msix = bnxt_get_max_func_irqs(bp) - bp->cp_nr_rings;
 	if (avail_msix >= BNXT_MIN_ROCE_CP_RINGS) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4d94bacf9f012..9413818788c4e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2971,6 +2971,7 @@ int bnxt_check_rings(struct bnxt *bp, int tx, int rx, bool sh, int tcs,
 		     int tx_xdp);
 int bnxt_fw_init_one(struct bnxt *bp);
 bool bnxt_hwrm_reset_permitted(struct bnxt *bp);
+void bnxt_set_cp_rings(struct bnxt *bp, bool sh);
 int bnxt_setup_mq_tc(struct net_device *dev, u8 tc);
 struct bnxt_ntuple_filter *bnxt_lookup_ntp_filter_from_idx(struct bnxt *bp,
 				struct bnxt_ntuple_filter *fltr, u32 idx);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index fa452d6272e0f..34d9264d51950 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -945,7 +945,6 @@ static int bnxt_set_channels(struct net_device *dev,
 	bool sh = false;
 	int tx_xdp = 0;
 	int rc = 0;
-	int tx_cp;
 
 	if (channel->other_count)
 		return -EINVAL;
@@ -1013,9 +1012,7 @@ static int bnxt_set_channels(struct net_device *dev,
 	if (tcs > 1)
 		bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tcs + tx_xdp;
 
-	tx_cp = bnxt_num_tx_to_cp(bp, bp->tx_nr_rings);
-	bp->cp_nr_rings = sh ? max_t(int, tx_cp, bp->rx_nr_rings) :
-			       tx_cp + bp->rx_nr_rings;
+	bnxt_set_cp_rings(bp, sh);
 
 	/* After changing number of rx channels, update NTUPLE feature. */
 	netdev_update_features(dev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c94a391b1ba5b..06f35a61c1774 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -384,7 +384,7 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 {
 	struct net_device *dev = bp->dev;
-	int tx_xdp = 0, tx_cp, rc, tc;
+	int tx_xdp = 0, rc, tc;
 	struct bpf_prog *old;
 
 	netdev_assert_locked(dev);
@@ -431,8 +431,7 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	}
 	bp->tx_nr_rings_xdp = tx_xdp;
 	bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tc + tx_xdp;
-	tx_cp = bnxt_num_tx_to_cp(bp, bp->tx_nr_rings);
-	bp->cp_nr_rings = max_t(int, tx_cp, bp->rx_nr_rings);
+	bnxt_set_cp_rings(bp, true);
 	bnxt_set_tpa_flags(bp);
 	bnxt_set_ring_params(bp);
 
-- 
2.53.0



