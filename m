Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891B84D9EA;
	Wed, 19 Jun 2024 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803577; cv=none; b=Wljh4kZrejbEDB00lUi8PBVVH5pUkQ6iyVSgIgiiPu+qk+aWdxfXa+g8YGXKb6llxuFKzGh4vJhkfCtVyzO+wz44op+CM0UPOy4PygkC2UjTRioqfWsYOWBy3pfpvejETaq3awEcky1k93cXLtesvcGNyVK2IosASKoHvqbOCfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803577; c=relaxed/simple;
	bh=p0h2VXxoKthXlXYlMCvPg5xrLQIs6X+CL47HdgZ66y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKFD2cRtxoPUDdSauMjbYnx1yTZ94pNddRHfbeTLrslbnYK1ggOJmdAi3LWwXF+M5jaO0Q1X8s2Ei54p8LbLHfzUHZpqHN5GHfuqhyj7j07w2b7MzWi/6ozm+/YrmPFSKSFdEdiKbRABATVAM+JX/xFagMo9j7XXlc2jCeV5Dxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxIRuLeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxIRuLeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1031FC2BBFC;
	Wed, 19 Jun 2024 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803577;
	bh=p0h2VXxoKthXlXYlMCvPg5xrLQIs6X+CL47HdgZ66y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxIRuLeXONb0JEJtsmpTtwGzrBx177q5ZAN2zl3yADW92XYJhmHuBOVYjFSMmImIH
	 MJyHH4CSiPKxZoPbDflm0x3pjxDi6qW+P7uiKNwdS5gPYQmOyEBihoI9UPdSYVLVUR
	 hhkWuHUQKvKhHZaA6J0npuGOgHsEtP63iBQmNDj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/217] ice: Introduce new parameters in ice_sched_node
Date: Wed, 19 Jun 2024 14:54:34 +0200
Message-ID: <20240619125557.851642872@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wilczynski <michal.wilczynski@intel.com>

[ Upstream commit 16dfa49406bc5e1f4cbb115027cbd719d7e6c930 ]

To support new devlink-rate API ice_sched_node struct needs to store
a number of additional parameters. This includes tx_max, tx_share,
tx_weight, and tx_priority.

Add new fields to ice_sched_node struct. Add new functions to configure
the hardware with new parameters. Introduce new xarray to identify
nodes uniquely.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: adbf5a42341f ("ice: remove af_xdp_zc_qps bitmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  4 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  3 +
 drivers/net/ethernet/intel/ice/ice_sched.c    | 81 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sched.h    | 27 +++++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 ++
 5 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index fe48164dce1e1..4d53c40a9de27 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -848,9 +848,9 @@ struct ice_aqc_txsched_elem {
 	u8 generic;
 #define ICE_AQC_ELEM_GENERIC_MODE_M		0x1
 #define ICE_AQC_ELEM_GENERIC_PRIO_S		0x1
-#define ICE_AQC_ELEM_GENERIC_PRIO_M	(0x7 << ICE_AQC_ELEM_GENERIC_PRIO_S)
+#define ICE_AQC_ELEM_GENERIC_PRIO_M	        GENMASK(3, 1)
 #define ICE_AQC_ELEM_GENERIC_SP_S		0x4
-#define ICE_AQC_ELEM_GENERIC_SP_M	(0x1 << ICE_AQC_ELEM_GENERIC_SP_S)
+#define ICE_AQC_ELEM_GENERIC_SP_M	        GENMASK(4, 4)
 #define ICE_AQC_ELEM_GENERIC_ADJUST_VAL_S	0x5
 #define ICE_AQC_ELEM_GENERIC_ADJUST_VAL_M	\
 	(0x3 << ICE_AQC_ELEM_GENERIC_ADJUST_VAL_S)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 039342a0ed15a..e2e661010176c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1105,6 +1105,9 @@ int ice_init_hw(struct ice_hw *hw)
 
 	hw->evb_veb = true;
 
+	/* init xarray for identifying scheduling nodes uniquely */
+	xa_init_flags(&hw->port_info->sched_node_ids, XA_FLAGS_ALLOC);
+
 	/* Query the allocated resources for Tx scheduler */
 	status = ice_sched_query_res_alloc(hw);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2c62c1763ee0d..88e74835d0274 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018, Intel Corporation. */
 
+#include <net/devlink.h>
 #include "ice_sched.h"
 
 /**
@@ -355,6 +356,9 @@ void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node)
 	/* leaf nodes have no children */
 	if (node->children)
 		devm_kfree(ice_hw_to_dev(hw), node->children);
+
+	kfree(node->name);
+	xa_erase(&pi->sched_node_ids, node->id);
 	devm_kfree(ice_hw_to_dev(hw), node);
 }
 
@@ -875,7 +879,7 @@ void ice_sched_cleanup_all(struct ice_hw *hw)
  *
  * This function add nodes to HW as well as to SW DB for a given layer
  */
-static int
+int
 ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
 		    u16 *num_nodes_added, u32 *first_node_teid)
@@ -940,6 +944,22 @@ ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
 
 		new_node->sibling = NULL;
 		new_node->tc_num = tc_node->tc_num;
+		new_node->tx_weight = ICE_SCHED_DFLT_BW_WT;
+		new_node->tx_share = ICE_SCHED_DFLT_BW;
+		new_node->tx_max = ICE_SCHED_DFLT_BW;
+		new_node->name = kzalloc(SCHED_NODE_NAME_MAX_LEN, GFP_KERNEL);
+		if (!new_node->name)
+			return -ENOMEM;
+
+		status = xa_alloc(&pi->sched_node_ids, &new_node->id, NULL, XA_LIMIT(0, UINT_MAX),
+				  GFP_KERNEL);
+		if (status) {
+			ice_debug(hw, ICE_DBG_SCHED, "xa_alloc failed for sched node status =%d\n",
+				  status);
+			break;
+		}
+
+		snprintf(new_node->name, SCHED_NODE_NAME_MAX_LEN, "node_%u", new_node->id);
 
 		/* add it to previous node sibling pointer */
 		/* Note: siblings are not linked across branches */
@@ -2154,7 +2174,7 @@ ice_sched_get_free_vsi_parent(struct ice_hw *hw, struct ice_sched_node *node,
  * This function removes the child from the old parent and adds it to a new
  * parent
  */
-static void
+void
 ice_sched_update_parent(struct ice_sched_node *new_parent,
 			struct ice_sched_node *node)
 {
@@ -2188,7 +2208,7 @@ ice_sched_update_parent(struct ice_sched_node *new_parent,
  *
  * This function move the child nodes to a given parent.
  */
-static int
+int
 ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
 		     u16 num_items, u32 *list)
 {
@@ -3562,7 +3582,7 @@ ice_sched_set_eir_srl_excl(struct ice_port_info *pi,
  * node's RL profile ID of type CIR, EIR, or SRL, and removes old profile
  * ID from local database. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 		      enum ice_rl_type rl_type, u32 bw, u8 layer_num)
 {
@@ -3598,6 +3618,57 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
 				       ICE_AQC_RL_PROFILE_TYPE_M, old_id);
 }
 
+/**
+ * ice_sched_set_node_priority - set node's priority
+ * @pi: port information structure
+ * @node: tree node
+ * @priority: number 0-7 representing priority among siblings
+ *
+ * This function sets priority of a node among it's siblings.
+ */
+int
+ice_sched_set_node_priority(struct ice_port_info *pi, struct ice_sched_node *node,
+			    u16 priority)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+
+	buf = node->info;
+	data = &buf.data;
+
+	data->valid_sections |= ICE_AQC_ELEM_VALID_GENERIC;
+	data->generic |= FIELD_PREP(ICE_AQC_ELEM_GENERIC_PRIO_M, priority);
+
+	return ice_sched_update_elem(pi->hw, node, &buf);
+}
+
+/**
+ * ice_sched_set_node_weight - set node's weight
+ * @pi: port information structure
+ * @node: tree node
+ * @weight: number 1-200 representing weight for WFQ
+ *
+ * This function sets weight of the node for WFQ algorithm.
+ */
+int
+ice_sched_set_node_weight(struct ice_port_info *pi, struct ice_sched_node *node, u16 weight)
+{
+	struct ice_aqc_txsched_elem_data buf;
+	struct ice_aqc_txsched_elem *data;
+
+	buf = node->info;
+	data = &buf.data;
+
+	data->valid_sections = ICE_AQC_ELEM_VALID_CIR | ICE_AQC_ELEM_VALID_EIR |
+			       ICE_AQC_ELEM_VALID_GENERIC;
+	data->cir_bw.bw_alloc = cpu_to_le16(weight);
+	data->eir_bw.bw_alloc = cpu_to_le16(weight);
+
+	data->generic |= FIELD_PREP(ICE_AQC_ELEM_GENERIC_SP_M, 0x0);
+
+	return ice_sched_update_elem(pi->hw, node, &buf);
+}
+
 /**
  * ice_sched_set_node_bw_lmt - set node's BW limit
  * @pi: port information structure
@@ -3608,7 +3679,7 @@ ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
  * It updates node's BW limit parameters like BW RL profile ID of type CIR,
  * EIR, or SRL. The caller needs to hold scheduler lock.
  */
-static int
+int
 ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
 			  enum ice_rl_type rl_type, u32 bw)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.h b/drivers/net/ethernet/intel/ice/ice_sched.h
index 4f91577fed56b..920db43ed4fa6 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.h
+++ b/drivers/net/ethernet/intel/ice/ice_sched.h
@@ -6,6 +6,8 @@
 
 #include "ice_common.h"
 
+#define SCHED_NODE_NAME_MAX_LEN 32
+
 #define ICE_QGRP_LAYER_OFFSET	2
 #define ICE_VSI_LAYER_OFFSET	4
 #define ICE_AGG_LAYER_OFFSET	6
@@ -69,6 +71,28 @@ int
 ice_aq_query_sched_elems(struct ice_hw *hw, u16 elems_req,
 			 struct ice_aqc_txsched_elem_data *buf, u16 buf_size,
 			 u16 *elems_ret, struct ice_sq_cd *cd);
+
+int
+ice_sched_set_node_bw_lmt(struct ice_port_info *pi, struct ice_sched_node *node,
+			  enum ice_rl_type rl_type, u32 bw);
+
+int
+ice_sched_set_node_bw(struct ice_port_info *pi, struct ice_sched_node *node,
+		      enum ice_rl_type rl_type, u32 bw, u8 layer_num);
+
+int
+ice_sched_add_elems(struct ice_port_info *pi, struct ice_sched_node *tc_node,
+		    struct ice_sched_node *parent, u8 layer, u16 num_nodes,
+		    u16 *num_nodes_added, u32 *first_node_teid);
+
+int
+ice_sched_move_nodes(struct ice_port_info *pi, struct ice_sched_node *parent,
+		     u16 num_items, u32 *list);
+
+int ice_sched_set_node_priority(struct ice_port_info *pi, struct ice_sched_node *node,
+				u16 priority);
+int ice_sched_set_node_weight(struct ice_port_info *pi, struct ice_sched_node *node, u16 weight);
+
 int ice_sched_init_port(struct ice_port_info *pi);
 int ice_sched_query_res_alloc(struct ice_hw *hw);
 void ice_sched_get_psm_clk_freq(struct ice_hw *hw);
@@ -82,6 +106,9 @@ ice_sched_find_node_by_teid(struct ice_sched_node *start_node, u32 teid);
 int
 ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		   struct ice_aqc_txsched_elem_data *info);
+void
+ice_sched_update_parent(struct ice_sched_node *new_parent,
+			struct ice_sched_node *node);
 void ice_free_sched_node(struct ice_port_info *pi, struct ice_sched_node *node);
 struct ice_sched_node *ice_sched_get_tc_node(struct ice_port_info *pi, u8 tc);
 struct ice_sched_node *
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e1abfcee96dcd..daf86cf561bc7 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -524,7 +524,14 @@ struct ice_sched_node {
 	struct ice_sched_node *sibling; /* next sibling in the same layer */
 	struct ice_sched_node **children;
 	struct ice_aqc_txsched_elem_data info;
+	char *name;
+	struct devlink_rate *rate_node;
+	u64 tx_max;
+	u64 tx_share;
 	u32 agg_id;			/* aggregator group ID */
+	u32 id;
+	u32 tx_priority;
+	u32 tx_weight;
 	u16 vsi_handle;
 	u8 in_use;			/* suspended or in use */
 	u8 tx_sched_layer;		/* Logical Layer (1-9) */
@@ -706,6 +713,7 @@ struct ice_port_info {
 	/* List contain profile ID(s) and other params per layer */
 	struct list_head rl_prof_list[ICE_AQC_TOPO_MAX_LEVEL_NUM];
 	struct ice_qos_cfg qos_cfg;
+	struct xarray sched_node_ids;
 	u8 is_vf:1;
 };
 
-- 
2.43.0



