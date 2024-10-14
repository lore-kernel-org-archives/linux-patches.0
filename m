Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94219E802;
	Mon, 14 Oct 2024 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916099; cv=none; b=LrS4zRlHHQBrsrB3m6126BG0xahovEKF9Gd1urDSeMP4SZ0088IVqkgYB65+/31ff1XgaEViDiIG/XLoWW5IZu3brsdj9NAmI1rm07NNMj93I1yYm7SmlkghRhLVfMWQ+3XvABhmvhS7Fi8bMve103RRoxpk7O2YzAkaHCLq2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916099; c=relaxed/simple;
	bh=NzLIxInj8LicsPcBxNLGGVl0R6a9PhsvfW2TV2phyMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcfBSrlr6MFbu4aIBB6F/XlxvKKVCLCCdGo8bXVwHE7BKUbXoDZt6q/hxt343v1E4v/Jqb2yXw/DZArzkNJeyLTTWwMsfPGuSUge/xQtvYN2q59thcYA7rjUYYwRBDqIbnKXDMAu/TBYNdJ8pFXs2/Z9AsuZWSIsrBGYs0AYX80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLZ6uJ5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLZ6uJ5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2705CC4CEC3;
	Mon, 14 Oct 2024 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916099;
	bh=NzLIxInj8LicsPcBxNLGGVl0R6a9PhsvfW2TV2phyMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLZ6uJ5KJyH3hGMvGLiq2BxawnCXzBUpbw6q2AUnS59OadDujeeL+4WWN3Fc0v0hY
	 P3AYFYnHvfXYjLIk7D0U9E7bPJX6CgU9nBXdoJXaXf5VP9is7n8WvD/dhVCxNFcYg7
	 6P8uFusBETUuR+jCCDWA6QcclPEs7c1EmyHd9ZdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Piotr Tyda <piotr.tyda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 084/214] ice: clear port vlan config during reset
Date: Mon, 14 Oct 2024 16:19:07 +0200
Message-ID: <20241014141048.269685188@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit d019b1a9128d65956f04679ec2bb8b0800f13358 ]

Since commit 2a2cb4c6c181 ("ice: replace ice_vf_recreate_vsi() with
ice_vf_reconfig_vsi()") VF VSI is only reconfigured instead of
recreated. The context configuration from previous setting is still the
same. If any of the config needs to be cleared it needs to be cleared
explicitly.

Previously there was assumption that port vlan will be cleared
automatically. Now, when VSI is only reconfigured we have to do it in the
code.

Not clearing port vlan configuration leads to situation when the driver
VSI config is different than the VSI config in HW. Traffic can't be
passed after setting and clearing port vlan, because of invalid VSI
config in HW.

Example reproduction:
> ip a a dev $(VF) $(VF_IP_ADDRESS)
> ip l s dev $(VF) up
> ping $(VF_IP_ADDRESS)
ping is working fine here
> ip link set eth5 vf 0 vlan 100
> ip link set eth5 vf 0 vlan 0
> ping $(VF_IP_ADDRESS)
ping isn't working

Fixes: 2a2cb4c6c181 ("ice: replace ice_vf_recreate_vsi() with ice_vf_reconfig_vsi()")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Piotr Tyda <piotr.tyda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  7 +++
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.c | 57 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_vsi_vlan_lib.h |  1 +
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 5635e9da2212b..9fe2a309c5ffa 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -335,6 +335,13 @@ static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf, struct ice_vsi *vsi)
 
 		err = vlan_ops->add_vlan(vsi, &vf->port_vlan_info);
 	} else {
+		/* clear possible previous port vlan config */
+		err = ice_vsi_clear_port_vlan(vsi);
+		if (err) {
+			dev_err(dev, "failed to clear port VLAN via VSI parameters for VF %u, error %d\n",
+				vf->vf_id, err);
+			return err;
+		}
 		err = ice_vsi_add_vlan_zero(vsi);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
index 6e8f2aab60801..5291f2888ef89 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
@@ -787,3 +787,60 @@ int ice_vsi_clear_outer_port_vlan(struct ice_vsi *vsi)
 	kfree(ctxt);
 	return err;
 }
+
+int ice_vsi_clear_port_vlan(struct ice_vsi *vsi)
+{
+	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_vsi_ctx *ctxt;
+	int err;
+
+	ctxt = kzalloc(sizeof(*ctxt), GFP_KERNEL);
+	if (!ctxt)
+		return -ENOMEM;
+
+	ctxt->info = vsi->info;
+
+	ctxt->info.port_based_outer_vlan = 0;
+	ctxt->info.port_based_inner_vlan = 0;
+
+	ctxt->info.inner_vlan_flags =
+		FIELD_PREP(ICE_AQ_VSI_INNER_VLAN_TX_MODE_M,
+			   ICE_AQ_VSI_INNER_VLAN_TX_MODE_ALL);
+	if (ice_is_dvm_ena(hw)) {
+		ctxt->info.inner_vlan_flags |=
+			FIELD_PREP(ICE_AQ_VSI_INNER_VLAN_EMODE_M,
+				   ICE_AQ_VSI_INNER_VLAN_EMODE_NOTHING);
+		ctxt->info.outer_vlan_flags =
+			FIELD_PREP(ICE_AQ_VSI_OUTER_VLAN_TX_MODE_M,
+				   ICE_AQ_VSI_OUTER_VLAN_TX_MODE_ALL);
+		ctxt->info.outer_vlan_flags |=
+			FIELD_PREP(ICE_AQ_VSI_OUTER_TAG_TYPE_M,
+				   ICE_AQ_VSI_OUTER_TAG_VLAN_8100);
+		ctxt->info.outer_vlan_flags |=
+			ICE_AQ_VSI_OUTER_VLAN_EMODE_NOTHING <<
+			ICE_AQ_VSI_OUTER_VLAN_EMODE_S;
+	}
+
+	ctxt->info.sw_flags2 &= ~ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+	ctxt->info.valid_sections =
+		cpu_to_le16(ICE_AQ_VSI_PROP_OUTER_TAG_VALID |
+			    ICE_AQ_VSI_PROP_VLAN_VALID |
+			    ICE_AQ_VSI_PROP_SW_VALID);
+
+	err = ice_update_vsi(hw, vsi->idx, ctxt, NULL);
+	if (err) {
+		dev_err(ice_pf_to_dev(vsi->back), "update VSI for clearing port based VLAN failed, err %d aq_err %s\n",
+			err, ice_aq_str(hw->adminq.sq_last_status));
+	} else {
+		vsi->info.port_based_outer_vlan =
+			ctxt->info.port_based_outer_vlan;
+		vsi->info.port_based_inner_vlan =
+			ctxt->info.port_based_inner_vlan;
+		vsi->info.outer_vlan_flags = ctxt->info.outer_vlan_flags;
+		vsi->info.inner_vlan_flags = ctxt->info.inner_vlan_flags;
+		vsi->info.sw_flags2 = ctxt->info.sw_flags2;
+	}
+
+	kfree(ctxt);
+	return err;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
index f0d84d11bd5b1..12b227621a7dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
@@ -36,5 +36,6 @@ int ice_vsi_ena_outer_insertion(struct ice_vsi *vsi, u16 tpid);
 int ice_vsi_dis_outer_insertion(struct ice_vsi *vsi);
 int ice_vsi_set_outer_port_vlan(struct ice_vsi *vsi, struct ice_vlan *vlan);
 int ice_vsi_clear_outer_port_vlan(struct ice_vsi *vsi);
+int ice_vsi_clear_port_vlan(struct ice_vsi *vsi);
 
 #endif /* _ICE_VSI_VLAN_LIB_H_ */
-- 
2.43.0



