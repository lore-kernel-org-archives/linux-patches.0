Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00214A4C7;
	Wed,  7 May 2025 18:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643422; cv=none; b=H1gBr6ssAWOlrp24l3/+MHTMYEV+d/lvGNt0BR/fJMl0/7spzWMbuSRqh6YoYulf2J6SCjHTVlReD856/t6ESt0QTCn21uWynG5BhiKZZUkftAJKDrBokaJw7fNcIlPn/GXdk0JvobfdvflkmGd98leC0wKqdIfoYWxRh3Xhj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643422; c=relaxed/simple;
	bh=Y1BLRq3uPhOanrC/BkSRAaK37cUl1h8hu+wfhQqN2yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1+bSJ9GJI3FdmkERgbtujZqfHDhvsfQPTZbpvdExlvRHInL4Sp18Sp0dg3Nwkne53eDFhnVGeK/pAZ5HMRgtJI1VTW8bJEtRYT0Nwj4kU6UP9xRw6LGULLxm7XX5rmcoCT7uJANeyGO3lig5u0CQj1eH6nATUZ1InvHFH2JOps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtgqdzIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtgqdzIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D6C4CEE2;
	Wed,  7 May 2025 18:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643422;
	bh=Y1BLRq3uPhOanrC/BkSRAaK37cUl1h8hu+wfhQqN2yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtgqdzIrHimk+KrDTwucU9BSmeJeb325usH82jvJ2V7bQSVg8x3m9NghN8ir6+Chx
	 0CUhHGKE0DbNh9SIgoQ5BFNYoM1SYHrSbAnQ680CKl9ppKz1/s99KyGDuAw5RG+TSy
	 3dzNMA95NyXPgNJeYvUJauoOjz7MYpy47EJfi74E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@intel.com>,
	Konrad Jankowski <konrad0.jankowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/55] ice: Refactor promiscuous functions
Date: Wed,  7 May 2025 20:39:28 +0200
Message-ID: <20250507183800.135207201@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit fabf480bf95d71c9cfe8a8d6307e0035df963a6a ]

Some of the promiscuous mode functions take a boolean to indicate
set/clear, which affects readability. Refactor and provide an
interface for the promiscuous mode code with explicit set and clear
promiscuous mode operations.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 425c5f266b2e ("ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_fltr.c     |  58 ++++++++
 drivers/net/ethernet/intel/ice/ice_fltr.h     |  12 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  49 +++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 139 +++++++-----------
 4 files changed, 156 insertions(+), 102 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c b/drivers/net/ethernet/intel/ice/ice_fltr.c
index e27b4de7e7aa3..7536451cb09ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.c
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
@@ -46,6 +46,64 @@ ice_fltr_add_entry_to_list(struct device *dev, struct ice_fltr_info *info,
 	return 0;
 }
 
+/**
+ * ice_fltr_set_vlan_vsi_promisc
+ * @hw: pointer to the hardware structure
+ * @vsi: the VSI being configured
+ * @promisc_mask: mask of promiscuous config bits
+ *
+ * Set VSI with all associated VLANs to given promiscuous mode(s)
+ */
+enum ice_status
+ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+			      u8 promisc_mask)
+{
+	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
+}
+
+/**
+ * ice_fltr_clear_vlan_vsi_promisc
+ * @hw: pointer to the hardware structure
+ * @vsi: the VSI being configured
+ * @promisc_mask: mask of promiscuous config bits
+ *
+ * Clear VSI with all associated VLANs to given promiscuous mode(s)
+ */
+enum ice_status
+ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+				u8 promisc_mask)
+{
+	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
+}
+
+/**
+ * ice_fltr_clear_vsi_promisc - clear specified promiscuous mode(s)
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: VSI handle to clear mode
+ * @promisc_mask: mask of promiscuous config bits to clear
+ * @vid: VLAN ID to clear VLAN promiscuous
+ */
+enum ice_status
+ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			   u16 vid)
+{
+	return ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+}
+
+/**
+ * ice_fltr_set_vsi_promisc - set given VSI to given promiscuous mode(s)
+ * @hw: pointer to the hardware structure
+ * @vsi_handle: VSI handle to configure
+ * @promisc_mask: mask of promiscuous config bits
+ * @vid: VLAN ID to set VLAN promiscuous
+ */
+enum ice_status
+ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			 u16 vid)
+{
+	return ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
+}
+
 /**
  * ice_fltr_add_mac_list - add list of MAC filters
  * @vsi: pointer to VSI struct
diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.h b/drivers/net/ethernet/intel/ice/ice_fltr.h
index 361cb4da9b43b..a0e8226f64f61 100644
--- a/drivers/net/ethernet/intel/ice/ice_fltr.h
+++ b/drivers/net/ethernet/intel/ice/ice_fltr.h
@@ -6,6 +6,18 @@
 
 void ice_fltr_free_list(struct device *dev, struct list_head *h);
 enum ice_status
+ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+			      u8 promisc_mask);
+enum ice_status
+ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
+				u8 promisc_mask);
+enum ice_status
+ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			   u16 vid);
+enum ice_status
+ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_mask,
+			 u16 vid);
+enum ice_status
 ice_fltr_add_mac_to_list(struct ice_vsi *vsi, struct list_head *list,
 			 const u8 *mac, enum ice_sw_fwd_act_type action);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 329bf24a3f0e5..735f8cef6bfa4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -222,32 +222,45 @@ static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
 }
 
 /**
- * ice_cfg_promisc - Enable or disable promiscuous mode for a given PF
+ * ice_set_promisc - Enable promiscuous mode for a given PF
  * @vsi: the VSI being configured
  * @promisc_m: mask of promiscuous config bits
- * @set_promisc: enable or disable promisc flag request
  *
  */
-static int ice_cfg_promisc(struct ice_vsi *vsi, u8 promisc_m, bool set_promisc)
+static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 {
-	struct ice_hw *hw = &vsi->back->hw;
-	enum ice_status status = 0;
+	enum ice_status status;
 
 	if (vsi->type != ICE_VSI_PF)
 		return 0;
 
-	if (vsi->num_vlan > 1) {
-		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
-						  set_promisc);
-	} else {
-		if (set_promisc)
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     0);
-		else
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       0);
-	}
+	if (vsi->num_vlan > 1)
+		status = ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
+	else
+		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
+	if (status)
+		return -EIO;
+
+	return 0;
+}
 
+/**
+ * ice_clear_promisc - Disable promiscuous mode for a given PF
+ * @vsi: the VSI being configured
+ * @promisc_m: mask of promiscuous config bits
+ *
+ */
+static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
+{
+	enum ice_status status;
+
+	if (vsi->type != ICE_VSI_PF)
+		return 0;
+
+	if (vsi->num_vlan > 1)
+		status = ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi, promisc_m);
+	else
+		status = ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx, promisc_m, 0);
 	if (status)
 		return -EIO;
 
@@ -343,7 +356,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
 
-			err = ice_cfg_promisc(vsi, promisc_m, true);
+			err = ice_set_promisc(vsi, promisc_m);
 			if (err) {
 				netdev_err(netdev, "Error setting Multicast promiscuous mode on VSI %i\n",
 					   vsi->vsi_num);
@@ -357,7 +370,7 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 			else
 				promisc_m = ICE_MCAST_PROMISC_BITS;
 
-			err = ice_cfg_promisc(vsi, promisc_m, false);
+			err = ice_clear_promisc(vsi, promisc_m);
 			if (err) {
 				netdev_err(netdev, "Error clearing Multicast promiscuous mode on VSI %i\n",
 					   vsi->vsi_num);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9d4d58757e040..e4e25f3ba8493 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -286,37 +286,6 @@ static int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
 	return 0;
 }
 
-/**
- * ice_err_to_virt_err - translate errors for VF return code
- * @ice_err: error return code
- */
-static enum virtchnl_status_code ice_err_to_virt_err(enum ice_status ice_err)
-{
-	switch (ice_err) {
-	case ICE_SUCCESS:
-		return VIRTCHNL_STATUS_SUCCESS;
-	case ICE_ERR_BAD_PTR:
-	case ICE_ERR_INVAL_SIZE:
-	case ICE_ERR_DEVICE_NOT_SUPPORTED:
-	case ICE_ERR_PARAM:
-	case ICE_ERR_CFG:
-		return VIRTCHNL_STATUS_ERR_PARAM;
-	case ICE_ERR_NO_MEMORY:
-		return VIRTCHNL_STATUS_ERR_NO_MEMORY;
-	case ICE_ERR_NOT_READY:
-	case ICE_ERR_RESET_FAILED:
-	case ICE_ERR_FW_API_VER:
-	case ICE_ERR_AQ_ERROR:
-	case ICE_ERR_AQ_TIMEOUT:
-	case ICE_ERR_AQ_FULL:
-	case ICE_ERR_AQ_NO_WORK:
-	case ICE_ERR_AQ_EMPTY:
-		return VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
-	default:
-		return VIRTCHNL_STATUS_ERR_NOT_SUPPORTED;
-	}
-}
-
 /**
  * ice_vc_vf_broadcast - Broadcast a message to all VFs on PF
  * @pf: pointer to the PF structure
@@ -1301,45 +1270,50 @@ static void ice_clear_vf_reset_trigger(struct ice_vf *vf)
 	ice_flush(hw);
 }
 
-/**
- * ice_vf_set_vsi_promisc - set given VF VSI to given promiscuous mode(s)
- * @vf: pointer to the VF info
- * @vsi: the VSI being configured
- * @promisc_m: mask of promiscuous config bits
- * @rm_promisc: promisc flag request from the VF to remove or add filter
- *
- * This function configures VF VSI promiscuous mode, based on the VF requests,
- * for Unicast, Multicast and VLAN
- */
-static enum ice_status
-ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m,
-		       bool rm_promisc)
+static int
+ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 {
-	struct ice_pf *pf = vf->pf;
-	enum ice_status status = 0;
-	struct ice_hw *hw;
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
 
-	hw = &pf->hw;
-	if (vsi->num_vlan) {
-		status = ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_m,
-						  rm_promisc);
-	} else if (vf->port_vlan_info) {
-		if (rm_promisc)
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       vf->port_vlan_info);
-		else
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     vf->port_vlan_info);
-	} else {
-		if (rm_promisc)
-			status = ice_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						       0);
-		else
-			status = ice_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						     0);
+	if (vf->port_vlan_info)
+		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m,
+						  vf->port_vlan_info & VLAN_VID_MASK);
+	else if (vsi->num_vlan > 1)
+		status = ice_fltr_set_vlan_vsi_promisc(hw, vsi, promisc_m);
+	else
+		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m, 0);
+
+	if (status && status != ICE_ERR_ALREADY_EXISTS) {
+		dev_err(ice_pf_to_dev(vsi->back), "enable Tx/Rx filter promiscuous mode on VF-%u failed, error: %s\n",
+			vf->vf_id, ice_stat_str(status));
+		return ice_status_to_errno(status);
+	}
+
+	return 0;
+}
+
+static int
+ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	enum ice_status status;
+
+	if (vf->port_vlan_info)
+		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m,
+						    vf->port_vlan_info & VLAN_VID_MASK);
+	else if (vsi->num_vlan > 1)
+		status = ice_fltr_clear_vlan_vsi_promisc(hw, vsi, promisc_m);
+	else
+		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m, 0);
+
+	if (status && status != ICE_ERR_DOES_NOT_EXIST) {
+		dev_err(ice_pf_to_dev(vsi->back), "disable Tx/Rx filter promiscuous mode on VF-%u failed, error: %s\n",
+			vf->vf_id, ice_stat_str(status));
+		return ice_status_to_errno(status);
 	}
 
-	return status;
+	return 0;
 }
 
 static void ice_vf_clear_counters(struct ice_vf *vf)
@@ -1700,7 +1674,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
 
-		if (ice_vf_set_vsi_promisc(vf, vsi, promisc_m, true))
+		if (ice_vf_clear_vsi_promisc(vf, vsi, promisc_m))
 			dev_err(dev, "disabling promiscuous mode failed\n");
 	}
 
@@ -2952,10 +2926,10 @@ bool ice_is_any_vf_in_promisc(struct ice_pf *pf)
 static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 {
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
-	enum ice_status mcast_status = 0, ucast_status = 0;
 	bool rm_promisc, alluni = false, allmulti = false;
 	struct virtchnl_promisc_info *info =
 	    (struct virtchnl_promisc_info *)msg;
+	int mcast_err = 0, ucast_err = 0;
 	struct ice_pf *pf = vf->pf;
 	struct ice_vsi *vsi;
 	struct device *dev;
@@ -3052,24 +3026,21 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 			ucast_m = ICE_UCAST_PROMISC_BITS;
 		}
 
-		ucast_status = ice_vf_set_vsi_promisc(vf, vsi, ucast_m,
-						      !alluni);
-		if (ucast_status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
-				alluni ? "en" : "dis", vf->vf_id);
-			v_ret = ice_err_to_virt_err(ucast_status);
-		}
+		if (alluni)
+			ucast_err = ice_vf_set_vsi_promisc(vf, vsi, ucast_m);
+		else
+			ucast_err = ice_vf_clear_vsi_promisc(vf, vsi, ucast_m);
 
-		mcast_status = ice_vf_set_vsi_promisc(vf, vsi, mcast_m,
-						      !allmulti);
-		if (mcast_status) {
-			dev_err(dev, "%sable Tx/Rx filter promiscuous mode on VF-%d failed\n",
-				allmulti ? "en" : "dis", vf->vf_id);
-			v_ret = ice_err_to_virt_err(mcast_status);
-		}
+		if (allmulti)
+			mcast_err = ice_vf_set_vsi_promisc(vf, vsi, mcast_m);
+		else
+			mcast_err = ice_vf_clear_vsi_promisc(vf, vsi, mcast_m);
+
+		if (ucast_err || mcast_err)
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 	}
 
-	if (!mcast_status) {
+	if (!mcast_err) {
 		if (allmulti &&
 		    !test_and_set_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set multicast promiscuous mode\n",
@@ -3079,7 +3050,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 				 vf->vf_id);
 	}
 
-	if (!ucast_status) {
+	if (!ucast_err) {
 		if (alluni && !test_and_set_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states))
 			dev_info(dev, "VF %u successfully set unicast promiscuous mode\n",
 				 vf->vf_id);
-- 
2.39.5



