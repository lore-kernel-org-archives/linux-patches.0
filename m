Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25AE4EDCBB;
	Tue, 13 Oct 2026 11:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892595; cv=none; b=jy1BQllnOXiP6T2s6Q97sgu9JgXNXM18OESuAy2jcv2aKmn29YDsGG4PZrkfSW5y87G1xWdtusszYvM4sdFgzhqhOeTCk9WH9meKIS4g5v7AfZN3yEQKC7P00vde4+ZWYYiiOWkpLFT6weF/K4ICo0XiHFLIRKH58CiLBD/sJfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892595; c=relaxed/simple;
	bh=LoJCTNbB/dkOWMAQkDb5JUd7YiIk2xpbu7pS4nSsaHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8exuVx/Owf2VK+f641rbRd3lfD7XAfYAinnVqY07SjZ+HfZama5L7i5AnMpdU1/NeH0LoE/zohd1fcZJL/I64mlTyjymK8Cl4dya7HthAVAJXhgorQpgxwGnRCNRaOjKRgy35q2z11dt6DQUnTmwCUNo5ZncYmKyJOVzlnOwYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZTI+2eA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZTI+2eA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D16B1F000FF;
	Tue, 13 Oct 2026 11:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892593;
	bh=TV5xmh7hLiJUCmhrU9UVzr071pmAzkA1PTHbbVoBDKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZTI+2eApEgtzLBYwJBoEUVH1CKjnXFkiREvu3NQwK2Gvnj3WKaqmexFn1Z3SVyEN
	 Si9bkNJwGqalHRfagp6UsJj8uSveVGPWEs0jokZnuMNmPGh5HQXT1E0Bd0Pw1Ga+hm
	 eajDQ2Ah/pYFFB2kafOPF0+MF+5p8MB/SOmEoSFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 226/281] Revert "net: stmmac: propagate PTP addend and system time programming errors"
Date: Tue, 13 Oct 2026 13:39:02 +0200
Message-ID: <20261013112900.640999518@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d5a007b9b457c915ab1a53227e8939e4018aa97a ]

This reverts commit 232d49dd4b40a666283de9e722899f088ed581b2.

Anirudh reports a regression from this change.

It is not appropriate for net this late in the release cycle
in the first place, so let's revert and revisit in net-next.

Reported-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Link: https://lore.kernel.org/CAEev2e8+fr1tJnSErD+2TtLDw5fGJbQOMcM5eefMnLyFUR+m7w@mail.gmail.com
Fixes: 232d49dd4b40 ("net: stmmac: propagate PTP addend and system time programming errors")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 106 +++++-------------
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |  10 +-
 2 files changed, 32 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 22c94fca01822..0da3da7d0d1b8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -601,64 +601,31 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
 	}
 }
 
-static void stmmac_restore_subsecond_increment(struct stmmac_priv *priv,
-					       u32 default_addend)
+static void stmmac_update_subsecond_increment(struct stmmac_priv *priv)
 {
 	bool xmac = dwmac_is_xmac(priv->plat->core_type);
 	u32 sec_inc = 0;
-
-	stmmac_config_addend(priv, priv->ptpaddr, default_addend);
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
-	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
-					   priv->plat->clk_ptp_rate,
-					   xmac, &sec_inc);
-	priv->default_addend = default_addend;
-	priv->sub_second_inc = sec_inc;
-}
-
-static int stmmac_update_subsecond_increment(struct stmmac_priv *priv,
-					     u32 systime_flags)
-{
-	bool xmac = dwmac_is_xmac(priv->plat->core_type);
-	u32 sec_inc = 0, val;
 	u64 temp = 0;
-	int ret;
 
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
 
 	/* program Sub Second Increment reg */
 	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
 					   priv->plat->clk_ptp_rate,
 					   xmac, &sec_inc);
-	if (!sec_inc) {
-		ret = -EINVAL;
-		goto error;
-	}
+	temp = div_u64(1000000000ULL, sec_inc);
+
+	/* Store sub second increment for later use */
+	priv->sub_second_inc = sec_inc;
 
 	/* calculate default added value:
 	 * formula is :
 	 * addend = (2^32)/freq_div_ratio;
 	 * where, freq_div_ratio = 1e9ns/sec_inc
 	 */
-	temp = div_u64(1000000000ULL, sec_inc);
 	temp = (u64)(temp << 32);
-	val = div_u64(temp, priv->plat->clk_ptp_rate);
-
-	ret = stmmac_config_addend(priv, priv->ptpaddr, val);
-	if (ret)
-		goto error;
-
-	priv->sub_second_inc = sec_inc;
-	priv->default_addend = val;
-
-	return 0;
-error:
-	/* Restore previous configuration */
-	stmmac_config_hw_tstamping(priv, priv->ptpaddr, priv->systime_flags);
-	stmmac_config_sub_second_increment(priv, priv->ptpaddr,
-					   priv->plat->clk_ptp_rate, xmac,
-					   NULL);
-	return ret;
+	priv->default_addend = div_u64(temp, priv->plat->clk_ptp_rate);
+	stmmac_config_addend(priv, priv->ptpaddr, priv->default_addend);
 }
 
 /**
@@ -887,42 +854,35 @@ static int stmmac_hwtstamp_get(struct net_device *dev,
 /**
  * stmmac_init_tstamp_counter - init hardware timestamping counter
  * @priv: driver private structure
+ * @systime_flags: timestamping flags
  * Description:
  * Initialize hardware counter for packet timestamping.
  * This is valid as long as the interface is open and not suspended.
  * Will be rerun after resuming from suspend, case in which the timestamping
  * flags updated by stmmac_hwtstamp_set() also need to be restored.
  */
-static int stmmac_init_tstamp_counter(struct stmmac_priv *priv)
+static int stmmac_init_tstamp_counter(struct stmmac_priv *priv,
+				      u32 systime_flags)
 {
-	u32 default_addend = priv->default_addend;
 	struct timespec64 now;
-	int ret;
 
 	if (!priv->plat->clk_ptp_rate) {
 		netdev_err(priv->dev, "Invalid PTP clock rate");
 		return -EINVAL;
 	}
 
-	ret = stmmac_update_subsecond_increment(priv, priv->systime_flags);
-	if (ret)
-		return ret;
+	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
+	priv->systime_flags = systime_flags;
+
+	stmmac_update_subsecond_increment(priv);
 
 	/* initialize system time */
 	ktime_get_real_ts64(&now);
 
 	/* lower 32 bits of tv_sec are safe until y2106 */
-	ret = stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec,
-				  now.tv_nsec);
-	if (ret)
-		goto error;
+	stmmac_init_systime(priv, priv->ptpaddr, (u32)now.tv_sec, now.tv_nsec);
 
 	return 0;
-error:
-	/* Restore previous configuration */
-	stmmac_restore_subsecond_increment(priv, default_addend);
-
-	return ret;
 }
 
 /**
@@ -945,14 +905,8 @@ static int stmmac_init_timestamping(struct stmmac_priv *priv)
 		return -EOPNOTSUPP;
 	}
 
-	/* Reset hw ts configuration */
-	memset(&priv->tstamp_config, 0, sizeof(priv->tstamp_config));
-	priv->systime_flags = STMMAC_HWTS_ACTIVE | PTP_TCR_TSCFUPDT;
-	priv->tsfupdt_coarse = false;
-	priv->hwts_tx_en = 0;
-	priv->hwts_rx_en = 0;
-
-	ret = stmmac_init_tstamp_counter(priv);
+	ret = stmmac_init_tstamp_counter(priv, STMMAC_HWTS_ACTIVE |
+					       PTP_TCR_TSCFUPDT);
 	if (ret) {
 		netdev_warn(priv->dev, "PTP init failed\n");
 		return ret;
@@ -973,6 +927,10 @@ static int stmmac_init_timestamping(struct stmmac_priv *priv)
 		netdev_info(priv->dev,
 			    "IEEE 1588-2008 Advanced Timestamp supported\n");
 
+	memset(&priv->tstamp_config, 0, sizeof(priv->tstamp_config));
+	priv->hwts_tx_en = 0;
+	priv->hwts_rx_en = 0;
+
 	if (priv->plat->flags & STMMAC_FLAG_HWTSTAMP_CORRECT_LATENCY)
 		stmmac_hwtstamp_correct_latency(priv, priv);
 
@@ -7767,26 +7725,18 @@ static int stmmac_dl_ts_coarse_set(struct devlink *dl, u32 id,
 {
 	struct stmmac_devlink_priv *dl_priv = devlink_priv(dl);
 	struct stmmac_priv *priv = dl_priv->stmmac_priv;
-	u32 systime_flags = priv->systime_flags;
-	int ret;
 
-	if (ctx->val.vbool)
-		systime_flags &= ~PTP_TCR_TSCFUPDT;
+	priv->tsfupdt_coarse = ctx->val.vbool;
+
+	if (priv->tsfupdt_coarse)
+		priv->systime_flags &= ~PTP_TCR_TSCFUPDT;
 	else
-		systime_flags |= PTP_TCR_TSCFUPDT;
+		priv->systime_flags |= PTP_TCR_TSCFUPDT;
 
 	/* In Coarse mode, we can use a smaller subsecond increment, let's
 	 * reconfigure the systime, subsecond increment and addend.
 	 */
-	ret = stmmac_update_subsecond_increment(priv, systime_flags);
-	if (ret) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "failed to reconfigure PTP adjustment");
-		return ret;
-	}
-
-	priv->tsfupdt_coarse = ctx->val.vbool;
-	priv->systime_flags = systime_flags;
+	stmmac_update_subsecond_increment(priv);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 493c5d81a36bf..3bfcc9760dce7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -28,15 +28,14 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, long scaled_ppm)
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
 	u32 addend;
-	int ret;
 
 	addend = adjust_by_scaled_ppm(priv->default_addend, scaled_ppm);
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
-	ret = stmmac_config_addend(priv, priv->ptpaddr, addend);
+	stmmac_config_addend(priv, priv->ptpaddr, addend);
 	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -154,13 +153,12 @@ static int stmmac_set_time(struct ptp_clock_info *ptp,
 	struct stmmac_priv *priv =
 	    container_of(ptp, struct stmmac_priv, ptp_clock_ops);
 	unsigned long flags;
-	int ret;
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
-	ret = stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
+	stmmac_init_systime(priv, priv->ptpaddr, ts->tv_sec, ts->tv_nsec);
 	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int stmmac_enable(struct ptp_clock_info *ptp,
-- 
2.53.0



