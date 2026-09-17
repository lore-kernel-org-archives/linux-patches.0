Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949403939A3;
	Thu, 17 Sep 2026 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659915; cv=none; b=DqteO+SMo1aUy1NECd2M3wkHhasXi3jFqAIlwviLMpkKiyHLvdpyixqWZz2d2F6xatmF5GyFHfG+pWiZxuUkY5/v3LM00eKM/IjGRYB0CAAExOy8ujPT/pOxtyActiDv7MSg59uJszA1ZEfPpnvRpjov1KfDhfDno4ndr+1MREo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659915; c=relaxed/simple;
	bh=breTymteXrBRiQrpE1GCc63uln6nGGQgHn2GzLt7AWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVUajbwU55vI47sE6BmHJgII+e7PPov0no4K8dQ7nAEYlNJFadYP291vi5Bpm5jplSKbBlhzmcC1afuLdJybfEq+DR1AluqnXMQZOFKPdx8jlPmq1dg3QrGzDw6DMaVk4WbfEUKpz+EPXVbSolqEXHkag3LKAAdGj9LVbk92vOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wc9UUxN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wc9UUxN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E786D1F00898;
	Thu, 17 Sep 2026 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659902;
	bh=nPXbzN3HrCtSz+GFKyE4r+gkIHYRUGJ8V/sfpTHIvok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wc9UUxN3jNZQ3XKENNFHU0L7kwcOCPJ2V0zEMPrxAI5Lwr8Bknww6zw1d+6+G7IEe
	 7PqbuXiNsdUV/PbVC2BgNe/QWzQmxVyy47lEEtV9fmXjMPxIxAXmGwBUDEHQNyNLq8
	 snRwd8Cv/fia0Z4sOZ6kTucJIeS6xaYqdqYi3ldg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.2 373/733] ice: add missing xa_destroy for sched_node_ids
Date: Thu, 17 Sep 2026 16:11:21 +0100
Message-ID: <20260917151400.942911361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 53432c4c3e869076350aef319534431af8ba99c1 ]

Commit 16dfa49406bc ("ice: Introduce new parameters in ice_sched_node")
added a sched_node_ids xarray to the port info structure, but never called
xa_destroy on it.

Since xarrays can allocate internal memory, this can result in a memory
leak even if every element in the xarray has been removed.

The xarray is currently embedded in the port_info structure. This appears
to have been done because its use is within functions that take the
port_info as a primary argument.

However, this complicates managing the lifecycle of the field. The
port_info structure is allocated in ice_init_hw() using devm, and it is
not released until the devm cleanup when the driver is unloaded.

The ice_init_hw() function is called in many places, including devlink
reload, and possibly during DDP load after updating the Tx scheduler
layout.

Adding a call of xa_destroy to the ice_deinit_hw() causes Sashiko to raise
multiple concerns due to potential ordering issues and possible ways that
port_info could be a dangling reference.

To handle this, move the sched_node_ids out of port_info and into the hw
structure. All users of the array already have a pointer to hw anyways, and
there is only one sched_node_ids per adapter. While here, remove the overly
verbose comment explaining the nature of the sched_node_ids xarray.

Add the missing xa_destroy to the cleanup path and to ice_deinit_hw(),
ensuring that we properly release the xarray memory.

This was caught by Sashiko during development of unrelated code.

Fixes: 16dfa49406bc ("ice: Introduce new parameters in ice_sched_node")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 9 ++++++---
 drivers/net/ethernet/intel/ice/ice_sched.c  | 4 ++--
 drivers/net/ethernet/intel/ice/ice_type.h   | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index ef1ce106f81b5..04633103e3e61 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1051,14 +1051,13 @@ int ice_init_hw(struct ice_hw *hw)
 
 	hw->evb_veb = true;
 
-	/* init xarray for identifying scheduling nodes uniquely */
-	xa_init_flags(&hw->port_info->sched_node_ids, XA_FLAGS_ALLOC);
+	xa_init_flags(&hw->sched_node_ids, XA_FLAGS_ALLOC);
 
 	/* Query the allocated resources for Tx scheduler */
 	status = ice_sched_query_res_alloc(hw);
 	if (status) {
 		ice_debug(hw, ICE_DBG_SCHED, "Failed to get scheduler allocated resources\n");
-		goto err_unroll_alloc;
+		goto err_unroll_xarray;
 	}
 	ice_sched_get_psm_clk_freq(hw);
 
@@ -1146,6 +1145,8 @@ int ice_init_hw(struct ice_hw *hw)
 	ice_cleanup_fltr_mgmt_struct(hw);
 err_unroll_sched:
 	ice_sched_cleanup_all(hw);
+err_unroll_xarray:
+	xa_destroy(&hw->sched_node_ids);
 err_unroll_alloc:
 	devm_kfree(ice_hw_to_dev(hw), hw->port_info);
 err_unroll_cqinit:
@@ -1186,6 +1187,8 @@ void ice_deinit_hw(struct ice_hw *hw)
 
 	/* Clear VSI contexts if not already cleared */
 	ice_clear_all_vsi_ctx(hw);
+
+	xa_destroy(&hw->sched_node_ids);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index fff0c1afdb414..ffa18d86729a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -371,7 +371,7 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 
 	devm_kfree(ice_hw_to_dev(hw), node->children);
 	kfree(node->name);
-	xa_erase(&pi->sched_node_ids, node->id);
+	xa_erase(&hw->sched_node_ids, node->id);
 	devm_kfree(ice_hw_to_dev(hw), node);
 }
 
@@ -977,7 +977,7 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		if (!new_node->name)
 			return -ENOMEM;
 
-		status = xa_alloc(&pi->sched_node_ids, &new_node->id, NULL, XA_LIMIT(0, UINT_MAX),
+		status = xa_alloc(&hw->sched_node_ids, &new_node->id, NULL, XA_LIMIT(0, UINT_MAX),
 				  GFP_KERNEL);
 		if (status) {
 			ice_debug(hw, ICE_DBG_SCHED, "xa_alloc failed for sched node status =%d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index d9a5c1aae7c23..cf147a2127071 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -765,7 +765,6 @@ struct ice_port_info {
 	/* List contain profile ID(s) and other params per layer */
 	struct list_head rl_prof_list[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_qos_cfg qos_cfg;
-	struct xarray sched_node_ids;
 	u8 is_vf:1;
 	u8 is_custom_tx_enabled:1;
 };
@@ -930,6 +929,7 @@ struct ice_hw {
 	u8 sw_entry_point_layer;
 	u16 max_children[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct list_head agg_list;	/* lists all aggregator */
+	struct xarray sched_node_ids;
 
 	struct ice_vsi_ctx *vsi_ctx[ICE_MAX_VSI];
 	u8 evb_veb;		/* true for VEB, false for VEPA */
-- 
2.53.0



