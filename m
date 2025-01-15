Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8C5248BBD;
	Wed, 15 Jan 2025 10:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938038; cv=none; b=QwvHEqYR2tu2Lhz+2rhABk++S452OYGeVrwqi/jyITBwl1Qk+HzNkojwGP5VZKjdgNrTFxxmtnefgHZwpXxXmzBi1mNOwMoyernMVFQ4ss9j26seGS24Jx8mOvP/6/3fq871ituDpjedG1TxT+wfYIz86xGJSVxWEZYmg4qj/8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938038; c=relaxed/simple;
	bh=9IK/r+o8lnSGofdbroeJxuty339Et87/8tOWmGpXMRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDHv90zGXUOo8upLFeRQ1RN+XV4X/uilJzp4dhW9Edks2unzin2OoUWS1dnA0Fs4wj+QiUbNNh237/kdz+qNX7hNHl86wiSMR/BPqL1gneQrX4pfufQwCB/lK++DXnSd8WXyNKcHxDCUzZV1ds0FZo4kUu0jqnVDFPJUtFJbqRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UXQrwqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UXQrwqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC2DC4CEDF;
	Wed, 15 Jan 2025 10:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938037;
	bh=9IK/r+o8lnSGofdbroeJxuty339Et87/8tOWmGpXMRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UXQrwqZuzs0o61X9Ew+iNRixO8Ill2R0a0vtTFBEtiW73/cmihhP0kp85GdbFOfs
	 6mbiUQPGOHVW+D48J0fOM5LSoD945AK37y2TtpZWfOeM4QGha4mRqhv81YFXdyMG2T
	 1Rx+O0yYw2XfAMmyx+DzE40RCm4PNLeD+H92qx7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 035/189] ice: fix max values for dpll pin phase adjust
Date: Wed, 15 Jan 2025 11:35:31 +0100
Message-ID: <20250115103607.761158457@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 65104599b3a8ed42d85b3f8f27be650afe1f3a7e ]

Mask admin command returned max phase adjust value for both input and
output pins. Only 31 bits are relevant, last released data sheet wrongly
points that 32 bits are valid - see [1] 3.2.6.4.1 Get CCU Capabilities
Command for reference. Fix of the datasheet itself is in progress.

Fix the min/max assignment logic, previously the value was wrongly
considered as negative value due to most significant bit being set.

Example of previous broken behavior:
$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml \
--do pin-get --json '{"id":1}'| grep phase-adjust
 'phase-adjust': 0,
 'phase-adjust-max': 16723,
 'phase-adjust-min': -16723,

Correct behavior with the fix:
$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml \
--do pin-get --json '{"id":1}'| grep phase-adjust
 'phase-adjust': 0,
 'phase-adjust-max': 2147466925,
 'phase-adjust-min': -2147466925,

[1] https://cdrdv2.intel.com/v1/dl/getContent/613875?explicitVersion=true

Fixes: 90e1c90750d7 ("ice: dpll: implement phase related callbacks")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  2 ++
 drivers/net/ethernet/intel/ice/ice_dpll.c     | 35 ++++++++++++-------
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 0be1a98d7cc1..79a6edd0be0e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -2238,6 +2238,8 @@ struct ice_aqc_get_pkg_info_resp {
 	struct ice_aqc_get_pkg_info pkg_info[];
 };
 
+#define ICE_AQC_GET_CGU_MAX_PHASE_ADJ	GENMASK(30, 0)
+
 /* Get CGU abilities command response data structure (indirect 0x0C61) */
 struct ice_aqc_get_cgu_abilities {
 	u8 num_inputs;
diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index d5ad6d84007c..38e151c7ea23 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -2064,6 +2064,18 @@ static int ice_dpll_init_worker(struct ice_pf *pf)
 	return 0;
 }
 
+/**
+ * ice_dpll_phase_range_set - initialize phase adjust range helper
+ * @range: pointer to phase adjust range struct to be initialized
+ * @phase_adj: a value to be used as min(-)/max(+) boundary
+ */
+static void ice_dpll_phase_range_set(struct dpll_pin_phase_adjust_range *range,
+				     u32 phase_adj)
+{
+	range->min = -phase_adj;
+	range->max = phase_adj;
+}
+
 /**
  * ice_dpll_init_info_pins_generic - initializes generic pins info
  * @pf: board private structure
@@ -2105,8 +2117,8 @@ static int ice_dpll_init_info_pins_generic(struct ice_pf *pf, bool input)
 	for (i = 0; i < pin_num; i++) {
 		pins[i].idx = i;
 		pins[i].prop.board_label = labels[i];
-		pins[i].prop.phase_range.min = phase_adj_max;
-		pins[i].prop.phase_range.max = -phase_adj_max;
+		ice_dpll_phase_range_set(&pins[i].prop.phase_range,
+					 phase_adj_max);
 		pins[i].prop.capabilities = cap;
 		pins[i].pf = pf;
 		ret = ice_dpll_pin_state_update(pf, &pins[i], pin_type, NULL);
@@ -2152,6 +2164,7 @@ ice_dpll_init_info_direct_pins(struct ice_pf *pf,
 	struct ice_hw *hw = &pf->hw;
 	struct ice_dpll_pin *pins;
 	unsigned long caps;
+	u32 phase_adj_max;
 	u8 freq_supp_num;
 	bool input;
 
@@ -2159,11 +2172,13 @@ ice_dpll_init_info_direct_pins(struct ice_pf *pf,
 	case ICE_DPLL_PIN_TYPE_INPUT:
 		pins = pf->dplls.inputs;
 		num_pins = pf->dplls.num_inputs;
+		phase_adj_max = pf->dplls.input_phase_adj_max;
 		input = true;
 		break;
 	case ICE_DPLL_PIN_TYPE_OUTPUT:
 		pins = pf->dplls.outputs;
 		num_pins = pf->dplls.num_outputs;
+		phase_adj_max = pf->dplls.output_phase_adj_max;
 		input = false;
 		break;
 	default:
@@ -2188,19 +2203,13 @@ ice_dpll_init_info_direct_pins(struct ice_pf *pf,
 				return ret;
 			caps |= (DPLL_PIN_CAPABILITIES_PRIORITY_CAN_CHANGE |
 				 DPLL_PIN_CAPABILITIES_STATE_CAN_CHANGE);
-			pins[i].prop.phase_range.min =
-				pf->dplls.input_phase_adj_max;
-			pins[i].prop.phase_range.max =
-				-pf->dplls.input_phase_adj_max;
 		} else {
-			pins[i].prop.phase_range.min =
-				pf->dplls.output_phase_adj_max;
-			pins[i].prop.phase_range.max =
-				-pf->dplls.output_phase_adj_max;
 			ret = ice_cgu_get_output_pin_state_caps(hw, i, &caps);
 			if (ret)
 				return ret;
 		}
+		ice_dpll_phase_range_set(&pins[i].prop.phase_range,
+					 phase_adj_max);
 		pins[i].prop.capabilities = caps;
 		ret = ice_dpll_pin_state_update(pf, &pins[i], pin_type, NULL);
 		if (ret)
@@ -2308,8 +2317,10 @@ static int ice_dpll_init_info(struct ice_pf *pf, bool cgu)
 	dp->dpll_idx = abilities.pps_dpll_idx;
 	d->num_inputs = abilities.num_inputs;
 	d->num_outputs = abilities.num_outputs;
-	d->input_phase_adj_max = le32_to_cpu(abilities.max_in_phase_adj);
-	d->output_phase_adj_max = le32_to_cpu(abilities.max_out_phase_adj);
+	d->input_phase_adj_max = le32_to_cpu(abilities.max_in_phase_adj) &
+		ICE_AQC_GET_CGU_MAX_PHASE_ADJ;
+	d->output_phase_adj_max = le32_to_cpu(abilities.max_out_phase_adj) &
+		ICE_AQC_GET_CGU_MAX_PHASE_ADJ;
 
 	alloc_size = sizeof(*d->inputs) * d->num_inputs;
 	d->inputs = kzalloc(alloc_size, GFP_KERNEL);
-- 
2.39.5



