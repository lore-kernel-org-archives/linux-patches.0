Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206AC1E0B86;
	Wed, 19 Mar 2025 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395028; cv=none; b=Fm7IwqLE9R9Up+/0o6NEjXhsX9kDhLg7XROEH79jQecHWJJ+Tal2weQNz7nySPs4jTryRMfC3/KvcvksAmTrYVkeqpeQ8ZN129eQEEerFshdJan4BpqJ2U1xbMYUs6L/EqDPU9JVuVYO7JkAvXvJ4LEPSzjg3iLJ/E+1ZW7hzQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395028; c=relaxed/simple;
	bh=DOW5HACyR5X1AIvshTv4ytNdZURUKzYRx5J4xeb5iiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hig/4xMGyFMUSbE9e8Mki0KYK61QgQox+R2dIWBBSy4hvdi6iVsOlaF60xw4Kj0E1ZJ1rZy45EKIbRVHmDa9Yu57cmMUkNI/nN9/r5TPbeooXEaZ4fF/KZjk68ANkIu1yBzYSlGnddXdAd0WOJs/ywCGlO77RXZ6XHIbCdWx62w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zD/5Pukv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD/5Pukv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC6C4CEE4;
	Wed, 19 Mar 2025 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395027;
	bh=DOW5HACyR5X1AIvshTv4ytNdZURUKzYRx5J4xeb5iiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zD/5PukvRA3ZifMYwXPfp9Pv7NDyujBq+OQ11c7t6pq16eoRJ0stM/ZhBxgYrUXQb
	 hVvbTooL1J7mIMtA5QZFAJRXX3G2Vdw+5+etAEPmGaE9ol+tXc9O2aFQul08obxE4y
	 fefq2HDiDZEZMPO/40fjv5GylFSkFsHqL9+PTL/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/231] ice: do not configure destination override for switchdev
Date: Wed, 19 Mar 2025 07:28:21 -0700
Message-ID: <20250319143027.068872786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 3be83ee9de0298f8321aa0b148d8f9995102e40f ]

After switchdev is enabled and disabled later, LLDP packets sending stops,
despite working perfectly fine before and during switchdev state.
To reproduce (creating/destroying VF is what triggers the reconfiguration):

devlink dev eswitch set pci/<address> mode switchdev
echo '2' > /sys/class/net/<ifname>/device/sriov_numvfs
echo '0' > /sys/class/net/<ifname>/device/sriov_numvfs

This happens because LLDP relies on the destination override functionality.
It needs to 1) set a flag in the descriptor, 2) set the VSI permission to
make it valid. The permissions are set when the PF VSI is first configured,
but switchdev then enables it for the uplink VSI (which is always the PF)
once more when configured and disables when deconfigured, which leads to
software-generated LLDP packets being blocked.

Do not modify the destination override permissions when configuring
switchdev, as the enabled state is the default configuration that is never
modified.

Fixes: 1a1c40df2e80 ("ice: set and release switchdev environment")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  6 ------
 drivers/net/ethernet/intel/ice/ice_lib.c     | 18 ------------------
 drivers/net/ethernet/intel/ice/ice_lib.h     |  4 ----
 3 files changed, 28 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index d649c197cf673..ed21d7f55ac11 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -49,9 +49,6 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 	if (vlan_ops->dis_rx_filtering(uplink_vsi))
 		goto err_vlan_filtering;
 
-	if (ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_set_allow_override))
-		goto err_override_uplink;
-
 	if (ice_vsi_update_local_lb(uplink_vsi, true))
 		goto err_override_local_lb;
 
@@ -63,8 +60,6 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 err_up:
 	ice_vsi_update_local_lb(uplink_vsi, false);
 err_override_local_lb:
-	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
-err_override_uplink:
 	vlan_ops->ena_rx_filtering(uplink_vsi);
 err_vlan_filtering:
 	ice_cfg_dflt_vsi(uplink_vsi->port_info, uplink_vsi->idx, false,
@@ -275,7 +270,6 @@ static void ice_eswitch_release_env(struct ice_pf *pf)
 	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
 
 	ice_vsi_update_local_lb(uplink_vsi, false);
-	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
 	vlan_ops->ena_rx_filtering(uplink_vsi);
 	ice_cfg_dflt_vsi(uplink_vsi->port_info, uplink_vsi->idx, false,
 			 ICE_FLTR_TX);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d4e74f96a8ad5..121a5ad5c8e10 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3928,24 +3928,6 @@ void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx)
 				 ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S);
 }
 
-/**
- * ice_vsi_ctx_set_allow_override - allow destination override on VSI
- * @ctx: pointer to VSI ctx structure
- */
-void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx)
-{
-	ctx->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
-}
-
-/**
- * ice_vsi_ctx_clear_allow_override - turn off destination override on VSI
- * @ctx: pointer to VSI ctx structure
- */
-void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx)
-{
-	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
-}
-
 /**
  * ice_vsi_update_local_lb - update sw block in VSI with local loopback bit
  * @vsi: pointer to VSI structure
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 1a6cfc8693ce4..2b27998fd1be3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -106,10 +106,6 @@ ice_vsi_update_security(struct ice_vsi *vsi, void (*fill)(struct ice_vsi_ctx *))
 void ice_vsi_ctx_set_antispoof(struct ice_vsi_ctx *ctx);
 
 void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx);
-
-void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx);
-
-void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx);
 int ice_vsi_update_local_lb(struct ice_vsi *vsi, bool set);
 int ice_vsi_add_vlan_zero(struct ice_vsi *vsi);
 int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
-- 
2.39.5



