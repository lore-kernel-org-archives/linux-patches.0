Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39378389104;
	Tue, 13 Oct 2026 11:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892528; cv=none; b=Tso5Dr2EwGkBFI6h+n5bqcT4wIdHprHUUgyal7BJhBxHOK/lBwnEG2ca0jWNpILoeZ4IjWexMLNO0+U2vgOQSrehZuL3RqoU/Wl4k7N9bE9PQsoc1z8lusWvEaCeNxGD67GQoWzoTnIH+i6NjEoJ0niSszFI8aGHK8/Wy+kLV+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892528; c=relaxed/simple;
	bh=4uBg+2Zy11A4FZih0nWAswFzxcdhhqDQl3h9awd+Vig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPxOGEQ6UYVfVJmwZxY/oeRmccNhTbshtyDpojRx3lwDDuSeU8/r/NsJgvwDDX9GMQbt/kAFFQdUV0NqvxN1wIwdG6DWC3pwnO3lDuQiQTq+0Ocw7XHhLRZ/yMaS4CWXtN+DefrAFcWFcsZrPxgbW4MwufQ0Ql7GGQPOJrjlUsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P111uI97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P111uI97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C25D1F000FF;
	Tue, 13 Oct 2026 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892527;
	bh=EE1dl3mxpXNvepunNOJFNvcE4Z+Sxx5AfK5LVugGxuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P111uI97GktUg139pbK2oKpkKQJmCPZmaVUMkF6R/BNshaef3Wifmfm8jqt8LIpnD
	 LK8W5cY8rLe5WtNILKb6C7ydB3uP3GSjdR8tYCMWh2VaiVGnKFXlUl62SvTRigMb9F
	 2USdCwWA3/viQ3N2UjvOCz1goi2EDVcoPjheg3wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 202/281] net: stmmac: propagate PTP addend and system time programming errors
Date: Tue, 13 Oct 2026 13:38:38 +0200
Message-ID: <20261013112900.065507143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 232d49dd4b40a666283de9e722899f088ed581b2 ]

stmmac_update_subsecond_increment() ignores the error returned by
stmmac_config_addend(), and stmmac_init_tstamp_counter() discards the
addend and system time programming errors, always returning success. A
failure to program the addend (PTP_TCR_TSADDREG) or to initialize the
system time counter (PTP_TCR_TSINIT) is therefore silently swallowed,
leaving the hardware timestamp counter in a non-running or partially
configured state while the driver keeps operating as if timestamping
were up. This matters for TAPRIO/EST offloading, which derives the gate
base time from the hardware timestamp counter.

The same hooks are also called from the PHC callbacks: settime64 and
adjfine drop the error and report success to clock_settime() and
clock_adjtime(), so a dead PTP reference clock goes unnoticed by
ptp4l/phc2sys.

Return error codes from stmmac_update_subsecond_increment(),
stmmac_init_tstamp_counter(), stmmac_dl_ts_coarse_set() and the
settime64/adjfine callbacks instead of silently returning success. On
failure, roll back the partially applied configuration so the hardware
and the driver bookkeeping stay consistent, and report the reason
through the devlink extack. Also guard against a zero sub-second
increment, which would otherwise divide by zero when computing the
addend.

Reset the persistent timestamping state (hwts_tx_en, hwts_rx_en,
tstamp_config, systime_flags and tsfupdt_coarse) when (re)initializing
timestamping, so a failed init does not leave TX/RX timestamping
enabled on a counter that never started.

Fixes: cc4c9001ce31 ("net: stmmac: Switch stmmac_hwtimestamp to generic HW Interface Helpers")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 106 +++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  10 +-
 2 files changed, 84 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 010fef79ec01e..034d9f941d402 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -601,31 +601,64 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
 	}
 }
 
-static void stmmac_update_subsecond_increment(struct stmmac_priv *priv)
+static void stmmac_restore_subsecond_increment(struct stmmac_priv *priv,
+					       u32 default_addend)
 {
 	bool xmac = dwmac_is_xmac(priv->plat->core_type);
 	u32 sec_inc = 0;
-	u64 temp = 0;
 
+	stmmac_config_addend(priv, priv->ptpaddr, default_addend);
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
+	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
+					   priv->plat->clk_ptp_rate,
+					   xmac, &sec_inc);
+	priv->default_addend = default_addend;
+	priv->sub_second_inc = sec_inc;
+}
+
+static int stmmac_update_subsecond_increment(struct stmmac_priv *priv,
+					     u32 systime_flags)
+{
+	bool xmac = dwmac_is_xmac(priv->plat->core_type);
+	u32 sec_inc = 0, val;
+	u64 temp = 0;
+	int ret;
+
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 
 	/* program Sub Second Increment reg */
 	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
 					   priv->plat->clk_ptp_rate,
 					   xmac, &sec_inc);
-	temp = div_u64(1000000000ULL, sec_inc);
-
-	/* Store sub second increment for later use */
-	priv->sub_second_inc = sec_inc;
+	if (!sec_inc) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	/* calculate default added value:
 	 * formula is :
 	 * addend = (2^32)/freq_div_ratio;
 	 * where, freq_div_ratio = 1e9ns/sec_inc
 	 */
+	temp = div_u64(1000000000ULL, sec_inc);
 	temp = (u64)(temp << 32);
-	priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
-	stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
+	val = div_u64(temp, priv->plat->clk_ptp_rate);
+
+	ret = stmmac_config_addend(priv, priv->ptpaddr, val);
+	if (ret)
+		goto error;
+
+	priv->sub_second_inc = sec_inc;
+	priv->default_addend = val;
+
+	return 0;
+error:
+	/* Restore previous configuration */
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
+	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
+					   priv->plat->clk_ptp_rate, xmac,
+					   NULL);
+	return ret;
 }
 
 /**
@@ -854,35 +887,42 @@ static int stmmac_hwtstamp_get(struct net_device *dev,
 /**
  * stmmac_init_tstamp_counter - init hardware timestamping counter
  * @priv: driver private structure
- * @systime_flags: timestamping flags
  * Description:
  * Initialize hardware counter for packet timestamping.
  * This is valid as long as the interface is open and not suspended.
  * Will be rerun after resuming from suspend, case in which the timestamping
  * flags updated by stmmac_hwtstamp_set() also need to be restored.
  */
-static int stmmac_init_tstamp_counter(struct stmmac_priv *priv,
-				      u32 systime_flags)
+static int stmmac_init_tstamp_counter(struct stmmac_priv *priv)
 {
+	u32 default_addend = priv->default_addend;
 	struct timespec64 now;
+	int ret;
 
 	if (!priv->plat->clk_ptp_rate) {
 		netdev_err(priv->dev, "Invalid PTP clock rate");
 		return -EINVAL;
 	}
 
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
-	priv->systime_flags = systime_flags;
-
-	stmmac_update_subsecond_increment(priv);
+	ret = stmmac_update_subsecond_increment(priv, priv->systime_flags);
+	if (ret)
+		return ret;
 
 	/* initialize system time */
 	ktime_get_real_ts64(&now);
 
 	/* lower 32 bits of tv_sec are safe until y2106 */
-	stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec, now.tv_nsec);
+	ret = stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec,
+				  now.tv_nsec);
+	if (ret)
+		goto error;
 
 	return 0;
+error:
+	/* Restore previous configuration */
+	stmmac_restore_subsecond_increment(priv, default_addend);
+
+	return ret;
 }
 
 /**
@@ -905,8 +945,14 @@ static int stmmac_init_timestamping(struct stmmac_priv *priv)
 		return -EOPNOTSUPP;
 	}
 
-	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE |
-					       PTP_TCR_TSCFUPDT);
+	/* Reset hw ts configuration */
+	memset(&priv->tstamp_config, 0, sizeof(priv->tstamp_config));
+	priv->systime_flags = STMMAC_HWTS_ACTIVE | PTP_TCR_TSCFUPDT;
+	priv->tsfupdt_coarse = false;
+	priv->hwts_tx_en = 0;
+	priv->hwts_rx_en = 0;
+
+	ret = stmmac_init_tstamp_counter(priv);
 	if (ret) {
 		netdev_warn(priv->dev, "PTP init failed\n");
 		return ret;
@@ -927,10 +973,6 @@ static int stmmac_init_timestamping(struct stmmac_priv *priv)
 		netdev_info(priv->dev,
 			    "IEEE 1588-2008 Advanced Timestamp supported\n");
 
-	memset(&priv->tstamp_config, 0, sizeof(priv->tstamp_config));
-	priv->hwts_tx_en = 0;
-	priv->hwts_rx_en = 0;
-
 	if (priv->plat->flags & STMMAC_FLAG_HWTSTAMP_CORRECT_LATENCY)
 		stmmac_hwtstamp_correct_latency(priv, priv);
 
@@ -7718,18 +7760,26 @@ static int stmmac_dl_ts_coarse_set(struct devlink *dl, u32 id,
 {
 	struct stmmac_devlink_priv *dl_priv = devlink_priv(dl);
 	struct stmmac_priv *priv = dl_priv->stmmac_priv;
+	u32 systime_flags = priv->systime_flags;
+	int ret;
 
-	priv->tsfupdt_coarse = ctx->val.vbool;
-
-	if (priv->tsfupdt_coarse)
-		priv->systime_flags &= ~PTP_TCR_TSCFUPDT;
+	if (ctx->val.vbool)
+		systime_flags &= ~PTP_TCR_TSCFUPDT;
 	else
-		priv->systime_flags |= PTP_TCR_TSCFUPDT;
+		systime_flags |= PTP_TCR_TSCFUPDT;
 
 	/* In Coarse mode, we can use a smaller subsecond increment, let's
 	 * reconfigure the systime, subsecond increment and addend.
 	 */
-	stmmac_update_subsecond_increment(priv);
+	ret = stmmac_update_subsecond_increment(priv, systime_flags);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "failed to reconfigure PTP adjustment");
+		return ret;
+	}
+
+	priv->tsfupdt_coarse = ctx->val.vbool;
+	priv->systime_flags = systime_flags;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 3bfcc9760dce7..493c5d81a36bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -28,14 +28,15 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, long scaled_ppm)
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
 	u32 addend;
+	int ret;
 
 	addend = adjust_by_scaled_ppm(priv->default_addend, scaled_ppm);
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
-	stmmac_config_addend(priv, priv->ptpaddr, addend);
+	ret = stmmac_config_addend(priv, priv->ptpaddr, addend);
 	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -153,12 +154,13 @@ static int stmmac_set_time(struct ptp_clock_info *ptp,
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
+	int ret;
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
-	stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
+	ret = stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
 	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
-	return 0;
+	return ret;
 }
 
 static int stmmac_enable(struct ptp_clock_info *ptp,
-- 
2.53.0



