Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3444B27713;
	Tue,  9 Jul 2024 11:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524246; cv=none; b=Z3z+ctHnYwbhJL/Bobj0aVshG5TQUDDJoxNmX79Gi13OwyI+bTUbkxn/YKklVmZSi5Uu2S2OiX/G/7bqMib4LI6mY8lm+xgIAVk75HkmTTfN1+NBzZqpxpMjsv6uyUBRluKver0vPOzqAgyuukNi7YI6p/3HUs0ArX2HCG/ARRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524246; c=relaxed/simple;
	bh=Z98LmlHZ+qXgNrwJKoadstfI1b1HMubYRlZGYxQteXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exDa/d0gGIdC5Q5BFYv20tzG/XDitVkfgKXMhgeNNmqsGGxeqGRVJ8MqhyhHhBKVcNDk9ttgoVSVTWfXsRyFiPLEZ435XPH89yV1N2VJU37Tx5DucB45a/1mV0O1f6Xf7YWb+sAsM7bsVfO/u23iaJi5TWEvm2b0XHK3OodJS4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiMd5pfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiMd5pfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A504FC3277B;
	Tue,  9 Jul 2024 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524246;
	bh=Z98LmlHZ+qXgNrwJKoadstfI1b1HMubYRlZGYxQteXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiMd5pfD6HsV9bxu/Bf2YmxvHm3SML3GJppxtm1LR0GAxLj0M9//bobK8z7SQq6Ec
	 b6C/rPweojF/JEG93KAHrinsbGgz8OO7XHfXBhad01XwGJ4xstL0V9jn3Qgi8Wf6rw
	 SZRgCFXUY4I8csinyQrDnnj4LmmvfPEnBh0kFFzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Milena Olech <milena.olech@intel.com>,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.9 119/197] ice: Fix improper extts handling
Date: Tue,  9 Jul 2024 13:09:33 +0200
Message-ID: <20240709110713.554287799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milena Olech <milena.olech@intel.com>

[ Upstream commit 00d3b4f54582d4e4a02cda5886bb336eeab268cc ]

Extts events are disabled and enabled by the application ts2phc.
However, in case where the driver is removed when the application is
running, a specific extts event remains enabled and can cause a kernel
crash.
As a side effect, when the driver is reloaded and application is started
again, remaining extts event for the channel from a previous run will
keep firing and the message "extts on unexpected channel" might be
printed to the user.

To avoid that, extts events shall be disabled when PTP is released.

Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Milena Olech <milena.olech@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20240702171459.2606611-2-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 105 ++++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.h |   8 ++
 2 files changed, 91 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index c11eba07283c6..ee741a1d13cf0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1603,27 +1603,24 @@ void ice_ptp_extts_event(struct ice_pf *pf)
 /**
  * ice_ptp_cfg_extts - Configure EXTTS pin and channel
  * @pf: Board private structure
- * @ena: true to enable; false to disable
  * @chan: GPIO channel (0-3)
- * @gpio_pin: GPIO pin
- * @extts_flags: request flags from the ptp_extts_request.flags
+ * @config: desired EXTTS configuration.
+ * @store: If set to true, the values will be stored
+ *
+ * Configure an external timestamp event on the requested channel.
  */
-static int
-ice_ptp_cfg_extts(struct ice_pf *pf, bool ena, unsigned int chan, u32 gpio_pin,
-		  unsigned int extts_flags)
+static void ice_ptp_cfg_extts(struct ice_pf *pf, unsigned int chan,
+			      struct ice_extts_channel *config, bool store)
 {
 	u32 func, aux_reg, gpio_reg, irq_reg;
 	struct ice_hw *hw = &pf->hw;
 	u8 tmr_idx;
 
-	if (chan > (unsigned int)pf->ptp.info.n_ext_ts)
-		return -EINVAL;
-
 	tmr_idx = hw->func_caps.ts_func_info.tmr_index_owned;
 
 	irq_reg = rd32(hw, PFINT_OICR_ENA);
 
-	if (ena) {
+	if (config->ena) {
 		/* Enable the interrupt */
 		irq_reg |= PFINT_OICR_TSYN_EVNT_M;
 		aux_reg = GLTSYN_AUX_IN_0_INT_ENA_M;
@@ -1632,9 +1629,9 @@ ice_ptp_cfg_extts(struct ice_pf *pf, bool ena, unsigned int chan, u32 gpio_pin,
 #define GLTSYN_AUX_IN_0_EVNTLVL_FALLING_EDGE	BIT(1)
 
 		/* set event level to requested edge */
-		if (extts_flags & PTP_FALLING_EDGE)
+		if (config->flags & PTP_FALLING_EDGE)
 			aux_reg |= GLTSYN_AUX_IN_0_EVNTLVL_FALLING_EDGE;
-		if (extts_flags & PTP_RISING_EDGE)
+		if (config->flags & PTP_RISING_EDGE)
 			aux_reg |= GLTSYN_AUX_IN_0_EVNTLVL_RISING_EDGE;
 
 		/* Write GPIO CTL reg.
@@ -1655,9 +1652,47 @@ ice_ptp_cfg_extts(struct ice_pf *pf, bool ena, unsigned int chan, u32 gpio_pin,
 
 	wr32(hw, PFINT_OICR_ENA, irq_reg);
 	wr32(hw, GLTSYN_AUX_IN(chan, tmr_idx), aux_reg);
-	wr32(hw, GLGEN_GPIO_CTL(gpio_pin), gpio_reg);
+	wr32(hw, GLGEN_GPIO_CTL(config->gpio_pin), gpio_reg);
 
-	return 0;
+	if (store)
+		memcpy(&pf->ptp.extts_channels[chan], config, sizeof(*config));
+}
+
+/**
+ * ice_ptp_disable_all_extts - Disable all EXTTS channels
+ * @pf: Board private structure
+ */
+static void ice_ptp_disable_all_extts(struct ice_pf *pf)
+{
+	struct ice_extts_channel extts_cfg = {};
+	int i;
+
+	for (i = 0; i < pf->ptp.info.n_ext_ts; i++) {
+		if (pf->ptp.extts_channels[i].ena) {
+			extts_cfg.gpio_pin = pf->ptp.extts_channels[i].gpio_pin;
+			extts_cfg.ena = false;
+			ice_ptp_cfg_extts(pf, i, &extts_cfg, false);
+		}
+	}
+
+	synchronize_irq(pf->oicr_irq.virq);
+}
+
+/**
+ * ice_ptp_enable_all_extts - Enable all EXTTS channels
+ * @pf: Board private structure
+ *
+ * Called during reset to restore user configuration.
+ */
+static void ice_ptp_enable_all_extts(struct ice_pf *pf)
+{
+	int i;
+
+	for (i = 0; i < pf->ptp.info.n_ext_ts; i++) {
+		if (pf->ptp.extts_channels[i].ena)
+			ice_ptp_cfg_extts(pf, i, &pf->ptp.extts_channels[i],
+					  false);
+	}
 }
 
 /**
@@ -1814,7 +1849,6 @@ ice_ptp_gpio_enable_e810(struct ptp_clock_info *info,
 			 struct ptp_clock_request *rq, int on)
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
-	struct ice_perout_channel clk_cfg = {0};
 	bool sma_pres = false;
 	unsigned int chan;
 	u32 gpio_pin;
@@ -1825,6 +1859,9 @@ ice_ptp_gpio_enable_e810(struct ptp_clock_info *info,
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PEROUT:
+	{
+		struct ice_perout_channel clk_cfg = {};
+
 		chan = rq->perout.index;
 		if (sma_pres) {
 			if (chan == ice_pin_desc_e810t[SMA1].chan)
@@ -1852,7 +1889,11 @@ ice_ptp_gpio_enable_e810(struct ptp_clock_info *info,
 
 		err = ice_ptp_cfg_clkout(pf, chan, &clk_cfg, true);
 		break;
+	}
 	case PTP_CLK_REQ_EXTTS:
+	{
+		struct ice_extts_channel extts_cfg = {};
+
 		chan = rq->extts.index;
 		if (sma_pres) {
 			if (chan < ice_pin_desc_e810t[SMA2].chan)
@@ -1868,9 +1909,13 @@ ice_ptp_gpio_enable_e810(struct ptp_clock_info *info,
 			gpio_pin = chan;
 		}
 
-		err = ice_ptp_cfg_extts(pf, !!on, chan, gpio_pin,
-					rq->extts.flags);
-		break;
+		extts_cfg.flags = rq->extts.flags;
+		extts_cfg.gpio_pin = gpio_pin;
+		extts_cfg.ena = !!on;
+
+		ice_ptp_cfg_extts(pf, chan, &extts_cfg, true);
+		return 0;
+	}
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1888,21 +1933,31 @@ static int ice_ptp_gpio_enable_e823(struct ptp_clock_info *info,
 				    struct ptp_clock_request *rq, int on)
 {
 	struct ice_pf *pf = ptp_info_to_pf(info);
-	struct ice_perout_channel clk_cfg = {0};
 	int err;
 
 	switch (rq->type) {
 	case PTP_CLK_REQ_PPS:
+	{
+		struct ice_perout_channel clk_cfg = {};
+
 		clk_cfg.gpio_pin = PPS_PIN_INDEX;
 		clk_cfg.period = NSEC_PER_SEC;
 		clk_cfg.ena = !!on;
 
 		err = ice_ptp_cfg_clkout(pf, PPS_CLK_GEN_CHAN, &clk_cfg, true);
 		break;
+	}
 	case PTP_CLK_REQ_EXTTS:
-		err = ice_ptp_cfg_extts(pf, !!on, rq->extts.index,
-					TIME_SYNC_PIN_INDEX, rq->extts.flags);
-		break;
+	{
+		struct ice_extts_channel extts_cfg = {};
+
+		extts_cfg.flags = rq->extts.flags;
+		extts_cfg.gpio_pin = TIME_SYNC_PIN_INDEX;
+		extts_cfg.ena = !!on;
+
+		ice_ptp_cfg_extts(pf, rq->extts.index, &extts_cfg, true);
+		return 0;
+	}
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2745,6 +2800,10 @@ static int ice_ptp_rebuild_owner(struct ice_pf *pf)
 		ice_ptp_restart_all_phy(pf);
 	}
 
+	/* Re-enable all periodic outputs and external timestamp events */
+	ice_ptp_enable_all_clkout(pf);
+	ice_ptp_enable_all_extts(pf);
+
 	return 0;
 }
 
@@ -3300,6 +3359,8 @@ void ice_ptp_release(struct ice_pf *pf)
 
 	ice_ptp_release_tx_tracker(pf, &pf->ptp.port.tx);
 
+	ice_ptp_disable_all_extts(pf);
+
 	kthread_cancel_delayed_work_sync(&pf->ptp.work);
 
 	ice_ptp_port_phy_stop(&pf->ptp.port);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 3af20025043a6..f1171cdd93c86 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -33,6 +33,12 @@ struct ice_perout_channel {
 	u64 start_time;
 };
 
+struct ice_extts_channel {
+	bool ena;
+	u32 gpio_pin;
+	u32 flags;
+};
+
 /* The ice hardware captures Tx hardware timestamps in the PHY. The timestamp
  * is stored in a buffer of registers. Depending on the specific hardware,
  * this buffer might be shared across multiple PHY ports.
@@ -226,6 +232,7 @@ enum ice_ptp_state {
  * @ext_ts_irq: the external timestamp IRQ in use
  * @kworker: kwork thread for handling periodic work
  * @perout_channels: periodic output data
+ * @extts_channels: channels for external timestamps
  * @info: structure defining PTP hardware capabilities
  * @clock: pointer to registered PTP clock device
  * @tstamp_config: hardware timestamping configuration
@@ -249,6 +256,7 @@ struct ice_ptp {
 	u8 ext_ts_irq;
 	struct kthread_worker *kworker;
 	struct ice_perout_channel perout_channels[GLTSYN_TGT_H_IDX_MAX];
+	struct ice_extts_channel extts_channels[GLTSYN_TGT_H_IDX_MAX];
 	struct ptp_clock_info info;
 	struct ptp_clock *clock;
 	struct hwtstamp_config tstamp_config;
-- 
2.43.0



