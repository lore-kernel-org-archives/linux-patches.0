Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376E61DF736;
	Wed,  6 Nov 2024 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895936; cv=none; b=DjU6NaBQXV+/I0mydMFGgKzrS10Jrh1eUm42pix33LbXw63U+H04PMs2mazWGdOe9Em8bC7qgwN1fE8LvfP3uxf85PT8fyMWUQ+OWqhzKdKUSiiPHx13P+2avmiinMOEX2NQcjxtzGtLS0B5T9C+FjtxO2rjulVLUD8IYBgWfsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895936; c=relaxed/simple;
	bh=IvzwzGx5aQIoiKHNE/ef0S9waXQR/TPt/yyv72VR59Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZgxXzMRJkx4HHzN7LGKkhdcRDz27YbeQYLzeJnUfHmoCOyi8HY0/EUnjS7r5iwk3tKMV1T12D43l4ewLsWZ9Nu+B40LPRpKRnMJwV64LDW55czH2BWHe6UJfoclR0V7dIVGydXfF8zoztTPVlZBY/O/2ey5uDYrfJ0FI+wCgwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaiHL70g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaiHL70g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9DBC4CECD;
	Wed,  6 Nov 2024 12:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895936;
	bh=IvzwzGx5aQIoiKHNE/ef0S9waXQR/TPt/yyv72VR59Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaiHL70gT/2tTNRXznD7bCwGnGGtSP3/+kDDZX54/u4SVf5vG7WjgyFuVXWSIOngG
	 GCdar+zeQCa5XFuxz9FA61HaL+bc1UmEc/9NexVjwzFcE5b9V/q13Aoy71HfxHf62U
	 AGjMaiBHv1raD3FkF0Wcs8BUAPVi0bCoXmxtmaoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 033/245] ice: fix crash on probe for DPLL enabled E810 LOM
Date: Wed,  6 Nov 2024 13:01:26 +0100
Message-ID: <20241106120320.041879215@linuxfoundation.org>
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

[ Upstream commit 6e58c33106220c6c0c8fbee9ab63eae76ad8f260 ]

The E810 Lan On Motherboard (LOM) design is vendor specific. Intel
provides the reference design, but it is up to vendor on the final
product design. For some cases, like Linux DPLL support, the static
values defined in the driver does not reflect the actual LOM design.
Current implementation of dpll pins is causing the crash on probe
of the ice driver for such DPLL enabled E810 LOM designs:

WARNING: (...) at drivers/dpll/dpll_core.c:495 dpll_pin_get+0x2c4/0x330
...
Call Trace:
 <TASK>
 ? __warn+0x83/0x130
 ? dpll_pin_get+0x2c4/0x330
 ? report_bug+0x1b7/0x1d0
 ? handle_bug+0x42/0x70
 ? exc_invalid_op+0x18/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? dpll_pin_get+0x117/0x330
 ? dpll_pin_get+0x2c4/0x330
 ? dpll_pin_get+0x117/0x330
 ice_dpll_get_pins.isra.0+0x52/0xe0 [ice]
...

The number of dpll pins enabled by LOM vendor is greater than expected
and defined in the driver for Intel designed NICs, which causes the crash.

Prevent the crash and allow generic pin initialization within Linux DPLL
subsystem for DPLL enabled E810 LOM designs.

Newly designed solution for described issue will be based on "per HW
design" pin initialization. It requires pin information dynamically
acquired from the firmware and is already in progress, planned for
next-tree only.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Reviewed-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c   | 70 +++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 21 ++++++-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  1 +
 3 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 74c0e7319a4ca..d5ad6d84007c2 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -10,6 +10,7 @@
 #define ICE_DPLL_PIN_IDX_INVALID		0xff
 #define ICE_DPLL_RCLK_NUM_PER_PF		1
 #define ICE_DPLL_PIN_ESYNC_PULSE_HIGH_PERCENT	25
+#define ICE_DPLL_PIN_GEN_RCLK_FREQ		1953125
 
 /**
  * enum ice_dpll_pin_type - enumerate ice pin types:
@@ -2063,6 +2064,73 @@ static int ice_dpll_init_worker(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_dpll_init_info_pins_generic - initializes generic pins info
+ * @pf: board private structure
+ * @input: if input pins initialized
+ *
+ * Init information for generic pins, cache them in PF's pins structures.
+ *
+ * Return:
+ * * 0 - success
+ * * negative - init failure reason
+ */
+static int ice_dpll_init_info_pins_generic(struct ice_pf *pf, bool input)
+{
+	struct ice_dpll *de = &pf->dplls.eec, *dp = &pf->dplls.pps;
+	static const char labels[][sizeof("99")] = {
+		"0", "1", "2", "3", "4", "5", "6", "7", "8",
+		"9", "10", "11", "12", "13", "14", "15" };
+	u32 cap = DPLL_PIN_CAPABILITIES_STATE_CAN_CHANGE;
+	enum ice_dpll_pin_type pin_type;
+	int i, pin_num, ret = -EINVAL;
+	struct ice_dpll_pin *pins;
+	u32 phase_adj_max;
+
+	if (input) {
+		pin_num = pf->dplls.num_inputs;
+		pins = pf->dplls.inputs;
+		phase_adj_max = pf->dplls.input_phase_adj_max;
+		pin_type = ICE_DPLL_PIN_TYPE_INPUT;
+		cap |= DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE;
+	} else {
+		pin_num = pf->dplls.num_outputs;
+		pins = pf->dplls.outputs;
+		phase_adj_max = pf->dplls.output_phase_adj_max;
+		pin_type = ICE_DPLL_PIN_TYPE_OUTPUT;
+	}
+	if (pin_num > ARRAY_SIZE(labels))
+		return ret;
+
+	for (i = 0; i < pin_num; i++) {
+		pins[i].idx = i;
+		pins[i].prop.board_label = labels[i];
+		pins[i].prop.phase_range.min = phase_adj_max;
+		pins[i].prop.phase_range.max = -phase_adj_max;
+		pins[i].prop.capabilities = cap;
+		pins[i].pf = pf;
+		ret = ice_dpll_pin_state_update(pf, &pins[i], pin_type, NULL);
+		if (ret)
+			break;
+		if (input && pins[i].freq == ICE_DPLL_PIN_GEN_RCLK_FREQ)
+			pins[i].prop.type = DPLL_PIN_TYPE_MUX;
+		else
+			pins[i].prop.type = DPLL_PIN_TYPE_EXT;
+		if (!input)
+			continue;
+		ret = ice_aq_get_cgu_ref_prio(&pf->hw, de->dpll_idx, i,
+					      &de->input_prio[i]);
+		if (ret)
+			break;
+		ret = ice_aq_get_cgu_ref_prio(&pf->hw, dp->dpll_idx, i,
+					      &dp->input_prio[i]);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
 /**
  * ice_dpll_init_info_direct_pins - initializes direct pins info
  * @pf: board private structure
@@ -2101,6 +2169,8 @@ ice_dpll_init_info_direct_pins(struct ice_pf *pf,
 	default:
 		return -EINVAL;
 	}
+	if (num_pins != ice_cgu_get_num_pins(hw, input))
+		return ice_dpll_init_info_pins_generic(pf, input);
 
 	for (i = 0; i < num_pins; i++) {
 		caps = 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 3a33e6b9b313d..ec8db830ac73a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -34,7 +34,6 @@ static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_inputs[] = {
 		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
 	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
 		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
-	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR, 0, },
 };
 
 static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_inputs[] = {
@@ -52,7 +51,6 @@ static const struct ice_cgu_pin_desc ice_e810t_qsfp_cgu_inputs[] = {
 		ARRAY_SIZE(ice_cgu_pin_freq_common), ice_cgu_pin_freq_common },
 	{ "GNSS-1PPS",	  ZL_REF4P, DPLL_PIN_TYPE_GNSS,
 		ARRAY_SIZE(ice_cgu_pin_freq_1_hz), ice_cgu_pin_freq_1_hz },
-	{ "OCXO",	  ZL_REF4N, DPLL_PIN_TYPE_INT_OSCILLATOR, },
 };
 
 static const struct ice_cgu_pin_desc ice_e810t_sfp_cgu_outputs[] = {
@@ -5964,6 +5962,25 @@ ice_cgu_get_pin_desc(struct ice_hw *hw, bool input, int *size)
 	return t;
 }
 
+/**
+ * ice_cgu_get_num_pins - get pin description array size
+ * @hw: pointer to the hw struct
+ * @input: if request is done against input or output pins
+ *
+ * Return: size of pin description array for given hw.
+ */
+int ice_cgu_get_num_pins(struct ice_hw *hw, bool input)
+{
+	const struct ice_cgu_pin_desc *t;
+	int size;
+
+	t = ice_cgu_get_pin_desc(hw, input, &size);
+	if (t)
+		return size;
+
+	return 0;
+}
+
 /**
  * ice_cgu_get_pin_type - get pin's type
  * @hw: pointer to the hw struct
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 0852a34ade918..6cedc1a906afb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -404,6 +404,7 @@ int ice_read_sma_ctrl_e810t(struct ice_hw *hw, u8 *data);
 int ice_write_sma_ctrl_e810t(struct ice_hw *hw, u8 data);
 int ice_read_pca9575_reg_e810t(struct ice_hw *hw, u8 offset, u8 *data);
 bool ice_is_pca9575_present(struct ice_hw *hw);
+int ice_cgu_get_num_pins(struct ice_hw *hw, bool input);
 enum dpll_pin_type ice_cgu_get_pin_type(struct ice_hw *hw, u8 pin, bool input);
 struct dpll_pin_frequency *
 ice_cgu_get_pin_freq_supp(struct ice_hw *hw, u8 pin, bool input, u8 *num);
-- 
2.43.0



