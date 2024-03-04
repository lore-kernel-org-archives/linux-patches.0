Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4341CA94;
	Mon,  4 Mar 2024 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587581; cv=none; b=M5ioo8oKtzj5booyBOTl7Z5gM+oXSTDN8eSSnlr+8Z6dR3FIxQuM/N6K1RyrgUZJYjP9eX0ipgGcgGezfoA7HVHCEvZCYI1cOwG+CikmWuprFBH1l6chmW2rWpLT/qGaYiDMkjFKcqhGisbG6zB7wjuH7Z5L/rLmvXc4Eyq8qEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587581; c=relaxed/simple;
	bh=81Fnk2Y65/Bej8VtPG6FhsW/tQTOCI3vUBDrzz2+dIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuKqFS3s6kcXKalLWa15n0SyhEi3jaOabfNb++0MGBbP5NspVCRrrBybft7UKQ4xL26Q1peRl4RV6mJebAxmkr+jW5gOrO87E+SAXSOCyMN7uHLiNGqqyizF9SrRACb4ZmVXqbyUbvo1Wp8ppSjd1D+Shdt0qnvzmHMBKXu7bJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSUiAaz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSUiAaz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3060C433F1;
	Mon,  4 Mar 2024 21:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587581;
	bh=81Fnk2Y65/Bej8VtPG6FhsW/tQTOCI3vUBDrzz2+dIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSUiAaz7mxxarXVgDiM1nyD9Kuh4/l7pSltuP7aUcfBz8ZzNWNLDat7y/kb4cIrqw
	 EqM2wjbaIyTc32+1blJCCaU7X0vfC3hVLY5XmBdyBor+fhvd+Lw4KQ87E7tTwZxl3u
	 xA4k8vz5LfEZaiqnaq44E50FfkbD180te91LywDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Yochai Hagvi <yochai.hagvi@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.7 003/162] ice: fix connection state of DPLL and out pin
Date: Mon,  4 Mar 2024 21:21:08 +0000
Message-ID: <20240304211551.944481957@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yochai Hagvi <yochai.hagvi@intel.com>

[ Upstream commit e8335ef57c6816d81b24173ba88cc9b3f043687f ]

Fix the connection state between source DPLL and output pin, updating the
attribute 'state' of 'parent_device'. Previously, the connection state
was broken, and didn't reflect the correct state.

When 'state_on_dpll_set' is called with the value
'DPLL_PIN_STATE_CONNECTED' (1), the output pin will switch to the given
DPLL, and the state of the given DPLL will be set to connected.
E.g.:
	--do pin-set --json '{"id":2, "parent-device":{"parent-id":1,
						       "state": 1 }}'
This command will connect DPLL device with id 1 to output pin with id 2.

When 'state_on_dpll_set' is called with the value
'DPLL_PIN_STATE_DISCONNECTED' (2) and the given DPLL is currently
connected, then the output pin will be disabled.
E.g:
	--do pin-set --json '{"id":2, "parent-device":{"parent-id":1,
						       "state": 2 }}'
This command will disable output pin with id 2 if DPLL device with ID 1 is
connected to it; otherwise, the command is ignored.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Yochai Hagvi <yochai.hagvi@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 43 +++++++++++++++++------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index 86b180cb32a02..0f836adc0e587 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -254,6 +254,7 @@ ice_dpll_output_frequency_get(const struct dpll_pin *pin, void *pin_priv,
  * ice_dpll_pin_enable - enable a pin on dplls
  * @hw: board private hw structure
  * @pin: pointer to a pin
+ * @dpll_idx: dpll index to connect to output pin
  * @pin_type: type of pin being enabled
  * @extack: error reporting
  *
@@ -266,7 +267,7 @@ ice_dpll_output_frequency_get(const struct dpll_pin *pin, void *pin_priv,
  */
 static int
 ice_dpll_pin_enable(struct ice_hw *hw, struct ice_dpll_pin *pin,
-		    enum ice_dpll_pin_type pin_type,
+		    u8 dpll_idx, enum ice_dpll_pin_type pin_type,
 		    struct netlink_ext_ack *extack)
 {
 	u8 flags = 0;
@@ -280,10 +281,12 @@ ice_dpll_pin_enable(struct ice_hw *hw, struct ice_dpll_pin *pin,
 		ret = ice_aq_set_input_pin_cfg(hw, pin->idx, 0, flags, 0, 0);
 		break;
 	case ICE_DPLL_PIN_TYPE_OUTPUT:
+		flags = ICE_AQC_SET_CGU_OUT_CFG_UPDATE_SRC_SEL;
 		if (pin->flags[0] & ICE_AQC_GET_CGU_OUT_CFG_ESYNC_EN)
 			flags |= ICE_AQC_SET_CGU_OUT_CFG_ESYNC_EN;
 		flags |= ICE_AQC_SET_CGU_OUT_CFG_OUT_EN;
-		ret = ice_aq_set_output_pin_cfg(hw, pin->idx, flags, 0, 0, 0);
+		ret = ice_aq_set_output_pin_cfg(hw, pin->idx, flags, dpll_idx,
+						0, 0);
 		break;
 	default:
 		return -EINVAL;
@@ -398,14 +401,27 @@ ice_dpll_pin_state_update(struct ice_pf *pf, struct ice_dpll_pin *pin,
 		break;
 	case ICE_DPLL_PIN_TYPE_OUTPUT:
 		ret = ice_aq_get_output_pin_cfg(&pf->hw, pin->idx,
-						&pin->flags[0], NULL,
+						&pin->flags[0], &parent,
 						&pin->freq, NULL);
 		if (ret)
 			goto err;
-		if (ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0])
-			pin->state[0] = DPLL_PIN_STATE_CONNECTED;
-		else
-			pin->state[0] = DPLL_PIN_STATE_DISCONNECTED;
+
+		parent &= ICE_AQC_GET_CGU_OUT_CFG_DPLL_SRC_SEL;
+		if (ICE_AQC_SET_CGU_OUT_CFG_OUT_EN & pin->flags[0]) {
+			pin->state[pf->dplls.eec.dpll_idx] =
+				parent == pf->dplls.eec.dpll_idx ?
+				DPLL_PIN_STATE_CONNECTED :
+				DPLL_PIN_STATE_DISCONNECTED;
+			pin->state[pf->dplls.pps.dpll_idx] =
+				parent == pf->dplls.pps.dpll_idx ?
+				DPLL_PIN_STATE_CONNECTED :
+				DPLL_PIN_STATE_DISCONNECTED;
+		} else {
+			pin->state[pf->dplls.eec.dpll_idx] =
+				DPLL_PIN_STATE_DISCONNECTED;
+			pin->state[pf->dplls.pps.dpll_idx] =
+				DPLL_PIN_STATE_DISCONNECTED;
+		}
 		break;
 	case ICE_DPLL_PIN_TYPE_RCLK_INPUT:
 		for (parent = 0; parent < pf->dplls.rclk.num_parents;
@@ -595,7 +611,8 @@ ice_dpll_pin_state_set(const struct dpll_pin *pin, void *pin_priv,
 
 	mutex_lock(&pf->dplls.lock);
 	if (enable)
-		ret = ice_dpll_pin_enable(&pf->hw, p, pin_type, extack);
+		ret = ice_dpll_pin_enable(&pf->hw, p, d->dpll_idx, pin_type,
+					  extack);
 	else
 		ret = ice_dpll_pin_disable(&pf->hw, p, pin_type, extack);
 	if (!ret)
@@ -628,6 +645,11 @@ ice_dpll_output_state_set(const struct dpll_pin *pin, void *pin_priv,
 			  struct netlink_ext_ack *extack)
 {
 	bool enable = state == DPLL_PIN_STATE_CONNECTED;
+	struct ice_dpll_pin *p = pin_priv;
+	struct ice_dpll *d = dpll_priv;
+
+	if (!enable && p->state[d->dpll_idx] == DPLL_PIN_STATE_DISCONNECTED)
+		return 0;
 
 	return ice_dpll_pin_state_set(pin, pin_priv, dpll, dpll_priv, enable,
 				      extack, ICE_DPLL_PIN_TYPE_OUTPUT);
@@ -694,10 +716,9 @@ ice_dpll_pin_state_get(const struct dpll_pin *pin, void *pin_priv,
 	ret = ice_dpll_pin_state_update(pf, p, pin_type, extack);
 	if (ret)
 		goto unlock;
-	if (pin_type == ICE_DPLL_PIN_TYPE_INPUT)
+	if (pin_type == ICE_DPLL_PIN_TYPE_INPUT ||
+	    pin_type == ICE_DPLL_PIN_TYPE_OUTPUT)
 		*state = p->state[d->dpll_idx];
-	else if (pin_type == ICE_DPLL_PIN_TYPE_OUTPUT)
-		*state = p->state[0];
 	ret = 0;
 unlock:
 	mutex_unlock(&pf->dplls.lock);
-- 
2.43.0



