Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8371DED58;
	Wed,  6 Nov 2024 12:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895933; cv=none; b=q8M9Hcid5iEFgVsIi/z9Z3zCNYsjx/ufgLjXDPD6ohVDM9PKjAELHxvY/Bk4wxXPF5vu9gwamJAz9DCZrc2GH9wympkJDdT5NO3Y7QGsxv66UGODBZNq6DUei/urDVUz1jy2N7eYJe1zdJwxco9jWF+tumaHytKHuOvxjc9BCI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895933; c=relaxed/simple;
	bh=gg+6koYsN6uh7bKJQ9HbT1ujcr4qECJp4lM/NqrJXUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxUuCUVxPoYfI/ymBYNQRusWA7GEwpIX4tIoyprOkXlvNr9lM5eDkqVXn50Ys02gj+k4RF3ZmI17eFPr4f5HjZP1c20YDtu5DfQO2ckSyFwHftvjefOiz93RBCAqcy1sKMHvNJNs7xB7FshV7tQDSpcp42uA3a0gnUmWrpz+wuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAt3WVcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAt3WVcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91D5C4CECD;
	Wed,  6 Nov 2024 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895933;
	bh=gg+6koYsN6uh7bKJQ9HbT1ujcr4qECJp4lM/NqrJXUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAt3WVcOygrl5jzAs1VnF/YR9+wIZPhSremVcG+NSTQCx3oxphu3t/aweTl6pDKmd
	 NuwQ/BXW9qb1JsvOaWc4etq/ZnWGCsLdD8NSBcDmDV4TLoYRJ81udwwmqYKPjhaTaO
	 hHrIzy3RRNYC1Y1FyzGt8m8OH3YKWaTJZD+Rgj4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 032/245] ice: add callbacks for Embedded SYNC enablement on dpll pins
Date: Wed,  6 Nov 2024 13:01:25 +0100
Message-ID: <20241106120320.018623534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 87abc5666ab753e8c31a2d39df3b5233f4e47b43 ]

Allow the user to get and set configuration of Embedded SYNC feature
on the ice driver dpll pins.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20240822222513.255179-3-arkadiusz.kubalewski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6e58c3310622 ("ice: fix crash on probe for DPLL enabled E810 LOM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 223 +++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_dpll.h |   1 +
 2 files changed, 221 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index cc35d29ac9e6c..74c0e7319a4ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -9,6 +9,7 @@
 #define ICE_CGU_STATE_ACQ_ERR_THRESHOLD		50
 #define ICE_DPLL_PIN_IDX_INVALID		0xff
 #define ICE_DPLL_RCLK_NUM_PER_PF		1
+#define ICE_DPLL_PIN_ESYNC_PULSE_HIGH_PERCENT	25
 
 /**
  * enum ice_dpll_pin_type - enumerate ice pin types:
@@ -30,6 +31,10 @@ static const char * const pin_type_name[] = {
 	[ICE_DPLL_PIN_TYPE_RCLK_INPUT] = "rclk-input",
 };
 
+static const struct dpll_pin_frequency ice_esync_range[] = {
+	DPLL_PIN_FREQUENCY_RANGE(0, DPLL_PIN_FREQUENCY_1_HZ),
+};
+
 /**
  * ice_dpll_is_reset - check if reset is in progress
  * @pf: private board structure
@@ -394,8 +399,8 @@ ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
 
 	switch (pin_type) {
 	case ICE_DPLL_PIN_TYPE_INPUT:
-		ret = ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, NULL, NULL,
-					       NULL, &pin->flags[0],
+		ret = ice_aq_get_input_pin_cfg(&pf->hw, pin->idx, &pin->status,
+					       NULL, NULL, &pin->flags[0],
 					       &pin->freq, &pin->phase_adjust);
 		if (ret)
 			goto err;
@@ -430,7 +435,7 @@ ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
 			goto err;
 
 		parent &= ICE_AQC_GET_CGU_OUT_CFG_DPLL_SRC_SEL;
-		if (ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0]) {
+		if (ICE_AQC_GET_CGU_OUT_CFG_OUT_EN & pin->flags[0]) {
 			pin->state[pf->dplls.eec.dpll_idx] =
 				parent == pf->dplls.eec.dpll_idx ?
 				DPLL_PIN_STATE_CONNECTED :
@@ -1100,6 +1105,214 @@ ice_dpll_phase_offset_get(const struct dpll_pin *pin, void *pin_priv,
 	return 0;
 }
 
+/**
+ * ice_dpll_output_esync_set - callback for setting embedded sync
+ * @pin: pointer to a pin
+ * @pin_priv: private data pointer passed on pin registration
+ * @dpll: registered dpll pointer
+ * @dpll_priv: private data pointer passed on dpll registration
+ * @freq: requested embedded sync frequency
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Handler for setting embedded sync frequency value
+ * on output pin.
+ *
+ * Context: Acquires pf->dplls.lock
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+static int
+ice_dpll_output_esync_set(const struct dpll_pin *pin, void *pin_priv,
+			  const struct dpll_device *dpll, void *dpll_priv,
+			  u64 freq, struct netlink_ext_ack *extack)
+{
+	struct ice_dpll_pin *p = pin_priv;
+	struct ice_dpll *d = dpll_priv;
+	struct ice_pf *pf = d->pf;
+	u8 flags = 0;
+	int ret;
+
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+	mutex_lock(&pf->dplls.lock);
+	if (p->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_OUT_EN)
+		flags = ICE_AQC_SET_CGU_OUT_CFG_OUT_EN;
+	if (freq == DPLL_PIN_FREQUENCY_1_HZ) {
+		if (p->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN) {
+			ret = 0;
+		} else {
+			flags |= ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN;
+			ret = ice_aq_set_output_pin_cfg(&pf->hw, p->idx, flags,
+							0, 0, 0);
+		}
+	} else {
+		if (!(p->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN)) {
+			ret = 0;
+		} else {
+			flags &= ~ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN;
+			ret = ice_aq_set_output_pin_cfg(&pf->hw, p->idx, flags,
+							0, 0, 0);
+		}
+	}
+	mutex_unlock(&pf->dplls.lock);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_output_esync_get - callback for getting embedded sync config
+ * @pin: pointer to a pin
+ * @pin_priv: private data pointer passed on pin registration
+ * @dpll: registered dpll pointer
+ * @dpll_priv: private data pointer passed on dpll registration
+ * @esync: on success holds embedded sync pin properties
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Handler for getting embedded sync frequency value
+ * and capabilities on output pin.
+ *
+ * Context: Acquires pf->dplls.lock
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+static int
+ice_dpll_output_esync_get(const struct dpll_pin *pin, void *pin_priv,
+			  const struct dpll_device *dpll, void *dpll_priv,
+			  struct dpll_pin_esync *esync,
+			  struct netlink_ext_ack *extack)
+{
+	struct ice_dpll_pin *p = pin_priv;
+	struct ice_dpll *d = dpll_priv;
+	struct ice_pf *pf = d->pf;
+
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+	mutex_lock(&pf->dplls.lock);
+	if (!(p->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_ABILITY) ||
+	    p->freq != DPLL_PIN_FREQUENCY_10_MHZ) {
+		mutex_unlock(&pf->dplls.lock);
+		return -EOPNOTSUPP;
+	}
+	esync->range = ice_esync_range;
+	esync->range_num = ARRAY_SIZE(ice_esync_range);
+	if (p->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN) {
+		esync->freq = DPLL_PIN_FREQUENCY_1_HZ;
+		esync->pulse = ICE_DPLL_PIN_ESYNC_PULSE_HIGH_PERCENT;
+	} else {
+		esync->freq = 0;
+		esync->pulse = 0;
+	}
+	mutex_unlock(&pf->dplls.lock);
+
+	return 0;
+}
+
+/**
+ * ice_dpll_input_esync_set - callback for setting embedded sync
+ * @pin: pointer to a pin
+ * @pin_priv: private data pointer passed on pin registration
+ * @dpll: registered dpll pointer
+ * @dpll_priv: private data pointer passed on dpll registration
+ * @freq: requested embedded sync frequency
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Handler for setting embedded sync frequency value
+ * on input pin.
+ *
+ * Context: Acquires pf->dplls.lock
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+static int
+ice_dpll_input_esync_set(const struct dpll_pin *pin, void *pin_priv,
+			 const struct dpll_device *dpll, void *dpll_priv,
+			 u64 freq, struct netlink_ext_ack *extack)
+{
+	struct ice_dpll_pin *p = pin_priv;
+	struct ice_dpll *d = dpll_priv;
+	struct ice_pf *pf = d->pf;
+	u8 flags_en = 0;
+	int ret;
+
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+	mutex_lock(&pf->dplls.lock);
+	if (p->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_INPUT_EN)
+		flags_en = ICE_AQC_SET_CGU_IN_CFG_FLG2_INPUT_EN;
+	if (freq == DPLL_PIN_FREQUENCY_1_HZ) {
+		if (p->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN) {
+			ret = 0;
+		} else {
+			flags_en |= ICE_AQC_SET_CGU_IN_CFG_FLG2_ESYNC_EN;
+			ret = ice_aq_set_input_pin_cfg(&pf->hw, p->idx, 0,
+						       flags_en, 0, 0);
+		}
+	} else {
+		if (!(p->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN)) {
+			ret = 0;
+		} else {
+			flags_en &= ~ICE_AQC_SET_CGU_IN_CFG_FLG2_ESYNC_EN;
+			ret = ice_aq_set_input_pin_cfg(&pf->hw, p->idx, 0,
+						       flags_en, 0, 0);
+		}
+	}
+	mutex_unlock(&pf->dplls.lock);
+
+	return ret;
+}
+
+/**
+ * ice_dpll_input_esync_get - callback for getting embedded sync config
+ * @pin: pointer to a pin
+ * @pin_priv: private data pointer passed on pin registration
+ * @dpll: registered dpll pointer
+ * @dpll_priv: private data pointer passed on dpll registration
+ * @esync: on success holds embedded sync pin properties
+ * @extack: error reporting
+ *
+ * Dpll subsystem callback. Handler for getting embedded sync frequency value
+ * and capabilities on input pin.
+ *
+ * Context: Acquires pf->dplls.lock
+ * Return:
+ * * 0 - success
+ * * negative - error
+ */
+static int
+ice_dpll_input_esync_get(const struct dpll_pin *pin, void *pin_priv,
+			 const struct dpll_device *dpll, void *dpll_priv,
+			 struct dpll_pin_esync *esync,
+			 struct netlink_ext_ack *extack)
+{
+	struct ice_dpll_pin *p = pin_priv;
+	struct ice_dpll *d = dpll_priv;
+	struct ice_pf *pf = d->pf;
+
+	if (ice_dpll_is_reset(pf, extack))
+		return -EBUSY;
+	mutex_lock(&pf->dplls.lock);
+	if (!(p->status & ICE_AQC_GET_CGU_IN_CFG_STATUS_ESYNC_CAP) ||
+	    p->freq != DPLL_PIN_FREQUENCY_10_MHZ) {
+		mutex_unlock(&pf->dplls.lock);
+		return -EOPNOTSUPP;
+	}
+	esync->range = ice_esync_range;
+	esync->range_num = ARRAY_SIZE(ice_esync_range);
+	if (p->flags[0] & ICE_AQC_GET_CGU_IN_CFG_FLG2_ESYNC_EN) {
+		esync->freq = DPLL_PIN_FREQUENCY_1_HZ;
+		esync->pulse = ICE_DPLL_PIN_ESYNC_PULSE_HIGH_PERCENT;
+	} else {
+		esync->freq = 0;
+		esync->pulse = 0;
+	}
+	mutex_unlock(&pf->dplls.lock);
+
+	return 0;
+}
+
 /**
  * ice_dpll_rclk_state_on_pin_set - set a state on rclk pin
  * @pin: pointer to a pin
@@ -1224,6 +1437,8 @@ static const struct dpll_pin_ops ice_dpll_input_ops = {
 	.phase_adjust_get = ice_dpll_pin_phase_adjust_get,
 	.phase_adjust_set = ice_dpll_input_phase_adjust_set,
 	.phase_offset_get = ice_dpll_phase_offset_get,
+	.esync_set = ice_dpll_input_esync_set,
+	.esync_get = ice_dpll_input_esync_get,
 };
 
 static const struct dpll_pin_ops ice_dpll_output_ops = {
@@ -1234,6 +1449,8 @@ static const struct dpll_pin_ops ice_dpll_output_ops = {
 	.direction_get = ice_dpll_output_direction,
 	.phase_adjust_get = ice_dpll_pin_phase_adjust_get,
 	.phase_adjust_set = ice_dpll_output_phase_adjust_set,
+	.esync_set = ice_dpll_output_esync_set,
+	.esync_get = ice_dpll_output_esync_get,
 };
 
 static const struct dpll_device_ops ice_dpll_ops = {
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.h b/drivers/net/ethernet/intel/ice/ice_dpll.h
index 93172e93995b9..c320f1bf7d6d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.h
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.h
@@ -31,6 +31,7 @@ struct ice_dpll_pin {
 	struct dpll_pin_properties prop;
 	u32 freq;
 	s32 phase_adjust;
+	u8 status;
 };
 
 /** ice_dpll - store info required for DPLL control
-- 
2.43.0



