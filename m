Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D32EAE5;
	Thu, 12 Dec 2024 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015759; cv=none; b=qwn90rBwNueg8oj8pLEEPFv8lGh9UVlSEHL9OPlr1PHGa0wGtymsjxhua0f2CUpnGHt7dj9DWXhkcPauvwisXiP5soqcRcF6npwaX3nZbp5tCwYzv+Y5DFyprqbAGy8gWi7eVh0le5loi26WEfNRZXXDHkVkE/wI9CjUSJ0q3/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015759; c=relaxed/simple;
	bh=HFoHrRmw9ybQqepn6nMlHRLphEV+tqJqX31kkxLWYZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1QGSVooT788kaoybimoX5CN/tbUGYfL7DPKnwW5RCUuS4AIQtd+oy8l50jUsuQJuhQ7rkUAAOaaV85wb6qTnqDwWFS8fq7JsTPLyKigJIyyeWbYvS2GZ3WWhe8LYAEKk1DKBue2/C1I5LJX2Ygi9T2UaPaNp9g66f+CQcz/wD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYXLL8Jo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYXLL8Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1CAC4CED4;
	Thu, 12 Dec 2024 15:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015759;
	bh=HFoHrRmw9ybQqepn6nMlHRLphEV+tqJqX31kkxLWYZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYXLL8JoIQsJDJzij+wUZ4cGbwBV7/bRwk+iZDzRUJ9AMKyT5D0es+hpniRfervfb
	 EFIXjCH6LjMAxf0Bgxw8KUtIL3CnAn01M54dDBaCVeJ/3PHt2j+21/c5DPjwyEQ/+x
	 i+nKIMpfZRCzg//znb7XjHfLPDjQREIsF83AfClI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 037/466] ice: fix PHY Clock Recovery availability check
Date: Thu, 12 Dec 2024 15:53:26 +0100
Message-ID: <20241212144308.150691056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 01fd68e54794fb1e1fe95be38facf9bbafee9ca3 ]

To check if PHY Clock Recovery mechanic is available for a device, there
is a need to verify if given PHY is available within the netlist, but the
netlist node type used for the search is wrong, also the search context
shall be specified.

Modify the search function to allow specifying the context in the
search.

Use the PHY node type instead of CLOCK CONTROLLER type, also use proper
search context which for PHY search is PORT, as defined in E810
Datasheet [1] ('3.3.8.2.4 Node Part Number and Node Options (0x0003)' and
'Table 3-105. Program Topology Device NVM Admin Command').

[1] https://cdrdv2.intel.com/v1/dl/getContent/613875?explicitVersion=true

Fixes: 91e43ca0090b ("ice: fix linking when CONFIG_PTP_1588_CLOCK=n")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 25 ++++++++++++++-------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 009716a12a26a..f1324e25b2af1 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -542,7 +542,8 @@ ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
 /**
  * ice_find_netlist_node
  * @hw: pointer to the hw struct
- * @node_type_ctx: type of netlist node to look for
+ * @node_type: type of netlist node to look for
+ * @ctx: context of the search
  * @node_part_number: node part number to look for
  * @node_handle: output parameter if node found - optional
  *
@@ -552,10 +553,12 @@ ice_aq_get_netlist_node(struct ice_hw *hw, struct ice_aqc_get_link_topo *cmd,
  * valid if the function returns zero, and should be ignored on any non-zero
  * return value.
  *
- * Returns: 0 if the node is found, -ENOENT if no handle was found, and
- * a negative error code on failure to access the AQ.
+ * Return:
+ * * 0 if the node is found,
+ * * -ENOENT if no handle was found,
+ * * negative error code on failure to access the AQ.
  */
-static int ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx,
+static int ice_find_netlist_node(struct ice_hw *hw, u8 node_type, u8 ctx,
 				 u8 node_part_number, u16 *node_handle)
 {
 	u8 idx;
@@ -566,8 +569,8 @@ static int ice_find_netlist_node(struct ice_hw *hw, u8 node_type_ctx,
 		int status;
 
 		cmd.addr.topo_params.node_type_ctx =
-			FIELD_PREP(ICE_AQC_LINK_TOPO_NODE_TYPE_M,
-				   node_type_ctx);
+			FIELD_PREP(ICE_AQC_LINK_TOPO_NODE_TYPE_M, node_type) |
+			FIELD_PREP(ICE_AQC_LINK_TOPO_NODE_CTX_M, ctx);
 		cmd.addr.topo_params.index = idx;
 
 		status = ice_aq_get_netlist_node(hw, &cmd,
@@ -2726,9 +2729,11 @@ bool ice_is_pf_c827(struct ice_hw *hw)
  */
 bool ice_is_phy_rclk_in_netlist(struct ice_hw *hw)
 {
-	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_PHY,
+				  ICE_AQC_LINK_TOPO_NODE_CTX_PORT,
 				  ICE_AQC_GET_LINK_TOPO_NODE_NR_C827, NULL) &&
-	    ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+	    ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_PHY,
+				  ICE_AQC_LINK_TOPO_NODE_CTX_PORT,
 				  ICE_AQC_GET_LINK_TOPO_NODE_NR_E822_PHY, NULL))
 		return false;
 
@@ -2744,6 +2749,7 @@ bool ice_is_phy_rclk_in_netlist(struct ice_hw *hw)
 bool ice_is_clock_mux_in_netlist(struct ice_hw *hw)
 {
 	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_MUX,
+				  ICE_AQC_LINK_TOPO_NODE_CTX_GLOBAL,
 				  ICE_AQC_GET_LINK_TOPO_NODE_NR_GEN_CLK_MUX,
 				  NULL))
 		return false;
@@ -2764,12 +2770,14 @@ bool ice_is_clock_mux_in_netlist(struct ice_hw *hw)
 bool ice_is_cgu_in_netlist(struct ice_hw *hw)
 {
 	if (!ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+				   ICE_AQC_LINK_TOPO_NODE_CTX_GLOBAL,
 				   ICE_AQC_GET_LINK_TOPO_NODE_NR_ZL30632_80032,
 				   NULL)) {
 		hw->cgu_part_number = ICE_AQC_GET_LINK_TOPO_NODE_NR_ZL30632_80032;
 		return true;
 	} else if (!ice_find_netlist_node(hw,
 					  ICE_AQC_LINK_TOPO_NODE_TYPE_CLK_CTRL,
+					  ICE_AQC_LINK_TOPO_NODE_CTX_GLOBAL,
 					  ICE_AQC_GET_LINK_TOPO_NODE_NR_SI5383_5384,
 					  NULL)) {
 		hw->cgu_part_number = ICE_AQC_GET_LINK_TOPO_NODE_NR_SI5383_5384;
@@ -2788,6 +2796,7 @@ bool ice_is_cgu_in_netlist(struct ice_hw *hw)
 bool ice_is_gps_in_netlist(struct ice_hw *hw)
 {
 	if (ice_find_netlist_node(hw, ICE_AQC_LINK_TOPO_NODE_TYPE_GPS,
+				  ICE_AQC_LINK_TOPO_NODE_CTX_GLOBAL,
 				  ICE_AQC_GET_LINK_TOPO_NODE_NR_GEN_GPS, NULL))
 		return false;
 
-- 
2.43.0



