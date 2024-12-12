Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6F0226545;
	Thu, 12 Dec 2024 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020660; cv=none; b=eF7ztiDxdoy2lFwhVT+xmpxYL3XqyP+XBz35edANFVy2hsxJr6vFr6zFeelb+qRfkAWcee8Plujg1n5fBIXVAXUNwS9XoEi8kW01tC8pxc/NTSh8Iw0Ku+NcBFpb6wx//Q7GrV1rug9fIyw/WnswP+vlt78mt7x/2ZLSbOcvDjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020660; c=relaxed/simple;
	bh=zrGoihaV3n1ipeCbmUCsIZB1OlK67U/xur6HIWZnl0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeZaFd5hFOFL+ZCXyexexIv8brBHqgxCe2TqYnRHysp5TPowo2a75QtDljqQIAFeNBgSsokpx7XSJEbiNq/qoSDDYZUKyKsKvZZfML6icyZZ+c4kftNhHbKEeF8OoC1cVL2px9k08obu2zGIgrr4mk/5aYnGgLymQ8HxCOo2hXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xZ6DjN8g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xZ6DjN8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CD0C4CECE;
	Thu, 12 Dec 2024 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020660;
	bh=zrGoihaV3n1ipeCbmUCsIZB1OlK67U/xur6HIWZnl0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZ6DjN8gB4C3E1p+ppq5/6GMgfSw/A9t8hWgLcAb+hsiPFiKc/CTPn4SKSYL0X9JW
	 hrxYHsRvlkUYYHyLeH7459vftJ4kqcE1ves1oKLVOvxbWeuuT5R3HYsoXgRlEi6VO7
	 bSyiIHd+AB2LYSkSIfoUW3dmCx7mL8VxB6pG7ts0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>,
	Derek Chickles <dchickles@marvell.com>,
	Satanand Burla <sburla@marvell.com>,
	Felix Manlunas <fmanlunas@marvell.com>,
	Raju Rangoju <rajur@chelsio.com>,
	Joakim Zhang <qiangqing.zhang@nxp.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 527/772] ptp: convert remaining drivers to adjfine interface
Date: Thu, 12 Dec 2024 15:57:52 +0100
Message-ID: <20241212144411.737286990@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit e2bd9c76c89fbe25df351fc5902cbbcca6a7d372 ]

Convert all remaining drivers that still use .adjfreq to the newer .adjfine
implementation. These drivers are not straightforward, as they use
non-standard methods of programming their hardware. They are all converted
to use scaled_ppm_to_ppb to get the parts per billion value that their
logic depends on.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Sudarsana Kalluru <skalluru@marvell.com>
Cc: Manish Chopra <manishc@marvell.com>
Cc: Derek Chickles <dchickles@marvell.com>
Cc: Satanand Burla <sburla@marvell.com>
Cc: Felix Manlunas <fmanlunas@marvell.com>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 98337d7c8757 ("ptp: Add error handling for adjfine callback in ptp_clock_adjtime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  9 +++++----
 drivers/net/ethernet/cavium/liquidio/lio_main.c  | 11 +++++++----
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c   | 13 ++++++++-----
 drivers/net/ethernet/freescale/fec_ptp.c         | 13 ++++++++-----
 drivers/net/ethernet/qlogic/qede/qede_ptp.c      | 13 ++++++++-----
 drivers/net/ethernet/sfc/ptp.c                   |  7 ++++---
 drivers/net/ethernet/sfc/siena/ptp.c             |  7 ++++---
 drivers/net/ethernet/ti/am65-cpts.c              |  5 +++--
 drivers/ptp/ptp_dte.c                            |  5 +++--
 9 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index a1783faf4fe99..afa591ec7a13b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13671,19 +13671,20 @@ static int bnx2x_send_update_drift_ramrod(struct bnx2x *bp, int drift_dir,
 	return bnx2x_func_state_change(bp, &func_params);
 }
 
-static int bnx2x_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int bnx2x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct bnx2x *bp = container_of(ptp, struct bnx2x, ptp_clock_info);
 	int rc;
 	int drift_dir = 1;
 	int val, period, period1, period2, dif, dif1, dif2;
 	int best_dif = BNX2X_MAX_PHC_DRIFT, best_period = 0, best_val = 0;
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 
-	DP(BNX2X_MSG_PTP, "PTP adjfreq called, ppb = %d\n", ppb);
+	DP(BNX2X_MSG_PTP, "PTP adjfine called, ppb = %d\n", ppb);
 
 	if (!netif_running(bp->dev)) {
 		DP(BNX2X_MSG_PTP,
-		   "PTP adjfreq called while the interface is down\n");
+		   "PTP adjfine called while the interface is down\n");
 		return -ENETDOWN;
 	}
 
@@ -13818,7 +13819,7 @@ void bnx2x_register_phc(struct bnx2x *bp)
 	bp->ptp_clock_info.n_ext_ts = 0;
 	bp->ptp_clock_info.n_per_out = 0;
 	bp->ptp_clock_info.pps = 0;
-	bp->ptp_clock_info.adjfreq = bnx2x_ptp_adjfreq;
+	bp->ptp_clock_info.adjfine = bnx2x_ptp_adjfine;
 	bp->ptp_clock_info.adjtime = bnx2x_ptp_adjtime;
 	bp->ptp_clock_info.gettime64 = bnx2x_ptp_gettime;
 	bp->ptp_clock_info.settime64 = bnx2x_ptp_settime;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 98793b2ac2c72..fd7c80edb6e8a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1512,14 +1512,17 @@ static void free_netsgbuf_with_resp(void *buf)
 }
 
 /**
- * liquidio_ptp_adjfreq - Adjust ptp frequency
+ * liquidio_ptp_adjfine - Adjust ptp frequency
  * @ptp: PTP clock info
- * @ppb: how much to adjust by, in parts-per-billion
+ * @scaled_ppm: how much to adjust by, in scaled parts-per-million
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int liquidio_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int liquidio_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lio *lio = container_of(ptp, struct lio, ptp_info);
 	struct octeon_device *oct = (struct octeon_device *)lio->oct_dev;
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	u64 comp, delta;
 	unsigned long flags;
 	bool neg_adj = false;
@@ -1643,7 +1646,7 @@ static void oct_ptp_open(struct net_device *netdev)
 	lio->ptp_info.n_ext_ts = 0;
 	lio->ptp_info.n_per_out = 0;
 	lio->ptp_info.pps = 0;
-	lio->ptp_info.adjfreq = liquidio_ptp_adjfreq;
+	lio->ptp_info.adjfine = liquidio_ptp_adjfine;
 	lio->ptp_info.adjtime = liquidio_ptp_adjtime;
 	lio->ptp_info.gettime64 = liquidio_ptp_gettime;
 	lio->ptp_info.settime64 = liquidio_ptp_settime;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 5bf117d2179f4..cbd06d9b95d4e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -194,17 +194,20 @@ int cxgb4_ptp_redirect_rx_packet(struct adapter *adapter, struct port_info *pi)
 }
 
 /**
- * cxgb4_ptp_adjfreq - Adjust frequency of PHC cycle counter
+ * cxgb4_ptp_adjfine - Adjust frequency of PHC cycle counter
  * @ptp: ptp clock structure
- * @ppb: Desired frequency change in parts per billion
+ * @scaled_ppm: Desired frequency in scaled parts per billion
  *
- * Adjust the frequency of the PHC cycle counter by the indicated ppb from
+ * Adjust the frequency of the PHC cycle counter by the indicated amount from
  * the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  */
-static int cxgb4_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int cxgb4_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct adapter *adapter = (struct adapter *)container_of(ptp,
 				   struct adapter, ptp_clock_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	struct fw_ptp_cmd c;
 	int err;
 
@@ -404,7 +407,7 @@ static const struct ptp_clock_info cxgb4_ptp_clock_info = {
 	.n_ext_ts       = 0,
 	.n_per_out      = 0,
 	.pps            = 0,
-	.adjfreq        = cxgb4_ptp_adjfreq,
+	.adjfine        = cxgb4_ptp_adjfine,
 	.adjtime        = cxgb4_ptp_adjtime,
 	.gettime64      = cxgb4_ptp_gettime,
 	.settime64      = cxgb4_ptp_settime,
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 37d83ff5b30be..ade1d5041ae4e 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -262,18 +262,21 @@ void fec_ptp_start_cyclecounter(struct net_device *ndev)
 }
 
 /**
- * fec_ptp_adjfreq - adjust ptp cycle frequency
+ * fec_ptp_adjfine - adjust ptp cycle frequency
  * @ptp: the ptp clock structure
- * @ppb: parts per billion adjustment from base
+ * @scaled_ppm: scaled parts per million adjustment from base
  *
  * Adjust the frequency of the ptp cycle counter by the
- * indicated ppb from the base frequency.
+ * indicated amount from the base frequency.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  *
  * Because ENET hardware frequency adjust is complex,
  * using software method to do that.
  */
-static int fec_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int fec_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	unsigned long flags;
 	int neg_adj = 0;
 	u32 i, tmp;
@@ -588,7 +591,7 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	fep->ptp_caps.n_per_out = 0;
 	fep->ptp_caps.n_pins = 0;
 	fep->ptp_caps.pps = 1;
-	fep->ptp_caps.adjfreq = fec_ptp_adjfreq;
+	fep->ptp_caps.adjfine = fec_ptp_adjfine;
 	fep->ptp_caps.adjtime = fec_ptp_adjtime;
 	fep->ptp_caps.gettime64 = fec_ptp_gettime;
 	fep->ptp_caps.settime64 = fec_ptp_settime;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index c9c8225f04d6e..747cc5e2bb788 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -28,16 +28,19 @@ struct qede_ptp {
 };
 
 /**
- * qede_ptp_adjfreq() - Adjust the frequency of the PTP cycle counter.
+ * qede_ptp_adjfine() - Adjust the frequency of the PTP cycle counter.
  *
  * @info: The PTP clock info structure.
- * @ppb: Parts per billion adjustment from base.
+ * @scaled_ppm: Scaled parts per million adjustment from base.
+ *
+ * Scaled parts per million is ppm with a 16-bit binary fractional field.
  *
  * Return: Zero on success, negative errno otherwise.
  */
-static int qede_ptp_adjfreq(struct ptp_clock_info *info, s32 ppb)
+static int qede_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
 {
 	struct qede_ptp *ptp = container_of(info, struct qede_ptp, clock_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	struct qede_dev *edev = ptp->edev;
 	int rc;
 
@@ -47,7 +50,7 @@ static int qede_ptp_adjfreq(struct ptp_clock_info *info, s32 ppb)
 		rc = ptp->ops->adjfreq(edev->cdev, ppb);
 		spin_unlock_bh(&ptp->lock);
 	} else {
-		DP_ERR(edev, "PTP adjfreq called while interface is down\n");
+		DP_ERR(edev, "PTP adjfine called while interface is down\n");
 		rc = -EFAULT;
 	}
 	__qede_unlock(edev);
@@ -462,7 +465,7 @@ int qede_ptp_enable(struct qede_dev *edev)
 	ptp->clock_info.n_ext_ts = 0;
 	ptp->clock_info.n_per_out = 0;
 	ptp->clock_info.pps = 0;
-	ptp->clock_info.adjfreq = qede_ptp_adjfreq;
+	ptp->clock_info.adjfine = qede_ptp_adjfine;
 	ptp->clock_info.adjtime = qede_ptp_adjtime;
 	ptp->clock_info.gettime64 = qede_ptp_gettime;
 	ptp->clock_info.settime64 = qede_ptp_settime;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 692c7f132e9f9..4eb6234292b1e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -351,7 +351,7 @@ struct efx_ptp_data {
 	void (*xmit_skb)(struct efx_nic *efx, struct sk_buff *skb);
 };
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta);
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
 static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta);
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts);
 static int efx_phc_settime(struct ptp_clock_info *ptp,
@@ -1509,7 +1509,7 @@ static const struct ptp_clock_info efx_phc_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
-	.adjfreq	= efx_phc_adjfreq,
+	.adjfine	= efx_phc_adjfine,
 	.adjtime	= efx_phc_adjtime,
 	.gettime64	= efx_phc_gettime,
 	.settime64	= efx_phc_settime,
@@ -2138,11 +2138,12 @@ void __efx_rx_skb_attach_timestamp(struct efx_channel *channel,
 					ptp->ts_corrections.general_rx);
 }
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct efx_ptp_data *ptp_data = container_of(ptp,
 						     struct efx_ptp_data,
 						     phc_clock_info);
+	s32 delta = scaled_ppm_to_ppb(scaled_ppm);
 	struct efx_nic *efx = ptp_data->efx;
 	MCDI_DECLARE_BUF(inadj, MC_CMD_PTP_IN_ADJUST_LEN);
 	s64 adjustment_ns;
diff --git a/drivers/net/ethernet/sfc/siena/ptp.c b/drivers/net/ethernet/sfc/siena/ptp.c
index 7c46752e6eae8..38e666561bcd9 100644
--- a/drivers/net/ethernet/sfc/siena/ptp.c
+++ b/drivers/net/ethernet/sfc/siena/ptp.c
@@ -347,7 +347,7 @@ struct efx_ptp_data {
 	void (*xmit_skb)(struct efx_nic *efx, struct sk_buff *skb);
 };
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta);
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm);
 static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta);
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts);
 static int efx_phc_settime(struct ptp_clock_info *ptp,
@@ -1429,7 +1429,7 @@ static const struct ptp_clock_info efx_phc_clock_info = {
 	.n_per_out	= 0,
 	.n_pins		= 0,
 	.pps		= 1,
-	.adjfreq	= efx_phc_adjfreq,
+	.adjfine	= efx_phc_adjfine,
 	.adjtime	= efx_phc_adjtime,
 	.gettime64	= efx_phc_gettime,
 	.settime64	= efx_phc_settime,
@@ -2044,11 +2044,12 @@ void __efx_siena_rx_skb_attach_timestamp(struct efx_channel *channel,
 					ptp->ts_corrections.general_rx);
 }
 
-static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
+static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct efx_ptp_data *ptp_data = container_of(ptp,
 						     struct efx_ptp_data,
 						     phc_clock_info);
+	s32 delta = scaled_ppm_to_ppb(scaled_ppm);
 	struct efx_nic *efx = ptp_data->efx;
 	MCDI_DECLARE_BUF(inadj, MC_CMD_PTP_IN_ADJUST_LEN);
 	s64 adjustment_ns;
diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
index c1bdf045e9815..d7ebc6e12143b 100644
--- a/drivers/net/ethernet/ti/am65-cpts.c
+++ b/drivers/net/ethernet/ti/am65-cpts.c
@@ -381,9 +381,10 @@ static irqreturn_t am65_cpts_interrupt(int irq, void *dev_id)
 }
 
 /* PTP clock operations */
-static int am65_cpts_ptp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int am65_cpts_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct am65_cpts *cpts = container_of(ptp, struct am65_cpts, ptp_info);
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	int neg_adj = 0;
 	u64 adj_period;
 	u32 val;
@@ -615,7 +616,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp);
 static struct ptp_clock_info am65_ptp_info = {
 	.owner		= THIS_MODULE,
 	.name		= "CTPS timer",
-	.adjfreq	= am65_cpts_ptp_adjfreq,
+	.adjfine	= am65_cpts_ptp_adjfine,
 	.adjtime	= am65_cpts_ptp_adjtime,
 	.gettimex64	= am65_cpts_ptp_gettimex,
 	.settime64	= am65_cpts_ptp_settime,
diff --git a/drivers/ptp/ptp_dte.c b/drivers/ptp/ptp_dte.c
index 8641fd060491a..7cc5a00e625bc 100644
--- a/drivers/ptp/ptp_dte.c
+++ b/drivers/ptp/ptp_dte.c
@@ -134,8 +134,9 @@ static s64 dte_read_nco_with_ovf(struct ptp_dte *ptp_dte)
 	return ns;
 }
 
-static int ptp_dte_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+static int ptp_dte_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
+	s32 ppb = scaled_ppm_to_ppb(scaled_ppm);
 	u32 nco_incr;
 	unsigned long flags;
 	struct ptp_dte *ptp_dte = container_of(ptp, struct ptp_dte, caps);
@@ -219,7 +220,7 @@ static const struct ptp_clock_info ptp_dte_caps = {
 	.n_ext_ts	= 0,
 	.n_pins		= 0,
 	.pps		= 0,
-	.adjfreq	= ptp_dte_adjfreq,
+	.adjfine	= ptp_dte_adjfine,
 	.adjtime	= ptp_dte_adjtime,
 	.gettime64	= ptp_dte_gettime,
 	.settime64	= ptp_dte_settime,
-- 
2.43.0



