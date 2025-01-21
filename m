Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470E1F55F7;
	Tue, 21 Jan 2025 17:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482321; cv=none; b=G67wJ/pJbRJMxh7a9prrYty3WDEzsTnBz3wxPr8SMgLzYmQB9ChxB3jz4GMuE58L4YgDHjZn/Y4qptOdw77gLeEXMNJQBrTpqcbEdoowjUCP+TbYm4I+drJmHBaQBxZXGXUC03Diqm3pWykv4Wq6l3u+JoUJeuN5vXQO1Dk2sws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482321; c=relaxed/simple;
	bh=XO2JK/Na0rMVoOUdyFphUhoe+xj8h0mo2FwvFWBtmzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d103val0AuV6Zil/5S+lEJp9UZhuWhGHKm88bVzW8J7CSHn/dGBAQt12q+TcLIaOB8QSiQNMgS7UjrOXKpsmfsAoWCpCtv/romZio/uqlwdVS9vVeFsq7RqCL6fxuAyYQlTBQ0hL4JEM+GmhXnnMkh49VRlhAEHz1qcsamlk4SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpPUi1ny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpPUi1ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F361C4CEDF;
	Tue, 21 Jan 2025 17:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482320;
	bh=XO2JK/Na0rMVoOUdyFphUhoe+xj8h0mo2FwvFWBtmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpPUi1nyqE3HT9ZM77HyQuVLRmMIG3UXadoqbySxt8rN78xGf/UneqU1SPJl77Txz
	 h+4RY5WCRz2XbaQselH+aMmiiJLPSweEOxCAlVdqrK1dUgbZmthlilxMUGzmYNqNu7
	 otezDiDvh9N4BbCN39kbrq9D1rbkDHz9qLn3Rq/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 009/122] ice: Fix quad registers read on E825
Date: Tue, 21 Jan 2025 18:50:57 +0100
Message-ID: <20250121174533.354568772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit dc26548d729e5f732197d2b210fb77c745b01495 ]

Quad registers are read/written incorrectly. E825 devices always use
quad 0 address and differentiate between the PHYs by changing SBQ
destination device (phy_0 or phy_0_peer).

Add helpers for reading/writing PTP registers shared per quad and use
correct quad address and SBQ destination device based on port.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 219 ++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_type.h   |   1 -
 2 files changed, 133 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index f6816c2f71438..64c36620a02f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -877,31 +877,46 @@ static void ice_ptp_exec_tmr_cmd(struct ice_hw *hw)
  * The following functions operate on devices with the ETH 56G PHY.
  */
 
+/**
+ * ice_ptp_get_dest_dev_e825 - get destination PHY for given port number
+ * @hw: pointer to the HW struct
+ * @port: destination port
+ *
+ * Return: destination sideband queue PHY device.
+ */
+static enum ice_sbq_msg_dev ice_ptp_get_dest_dev_e825(struct ice_hw *hw,
+						      u8 port)
+{
+	/* On a single complex E825, PHY 0 is always destination device phy_0
+	 * and PHY 1 is phy_0_peer.
+	 */
+	if (port >= hw->ptp.ports_per_phy)
+		return eth56g_phy_1;
+	else
+		return eth56g_phy_0;
+}
+
 /**
  * ice_write_phy_eth56g - Write a PHY port register
  * @hw: pointer to the HW struct
- * @phy_idx: PHY index
+ * @port: destination port
  * @addr: PHY register address
  * @val: Value to write
  *
  * Return: 0 on success, other error codes when failed to write to PHY
  */
-static int ice_write_phy_eth56g(struct ice_hw *hw, u8 phy_idx, u32 addr,
-				u32 val)
+static int ice_write_phy_eth56g(struct ice_hw *hw, u8 port, u32 addr, u32 val)
 {
-	struct ice_sbq_msg_input phy_msg;
+	struct ice_sbq_msg_input msg = {
+		.dest_dev = ice_ptp_get_dest_dev_e825(hw, port),
+		.opcode = ice_sbq_msg_wr,
+		.msg_addr_low = lower_16_bits(addr),
+		.msg_addr_high = upper_16_bits(addr),
+		.data = val
+	};
 	int err;
 
-	phy_msg.opcode = ice_sbq_msg_wr;
-
-	phy_msg.msg_addr_low = lower_16_bits(addr);
-	phy_msg.msg_addr_high = upper_16_bits(addr);
-
-	phy_msg.data = val;
-	phy_msg.dest_dev = hw->ptp.phy.eth56g.phy_addr[phy_idx];
-
-	err = ice_sbq_rw_reg(hw, &phy_msg, ICE_AQ_FLAG_RD);
-
+	err = ice_sbq_rw_reg(hw, &msg, ICE_AQ_FLAG_RD);
 	if (err)
 		ice_debug(hw, ICE_DBG_PTP, "PTP failed to send msg to phy %d\n",
 			  err);
@@ -912,41 +927,36 @@ static int ice_write_phy_eth56g(struct ice_hw *hw, u8 phy_idx, u32 addr,
 /**
  * ice_read_phy_eth56g - Read a PHY port register
  * @hw: pointer to the HW struct
- * @phy_idx: PHY index
+ * @port: destination port
  * @addr: PHY register address
  * @val: Value to write
  *
  * Return: 0 on success, other error codes when failed to read from PHY
  */
-static int ice_read_phy_eth56g(struct ice_hw *hw, u8 phy_idx, u32 addr,
-			       u32 *val)
+static int ice_read_phy_eth56g(struct ice_hw *hw, u8 port, u32 addr, u32 *val)
 {
-	struct ice_sbq_msg_input phy_msg;
+	struct ice_sbq_msg_input msg = {
+		.dest_dev = ice_ptp_get_dest_dev_e825(hw, port),
+		.opcode = ice_sbq_msg_rd,
+		.msg_addr_low = lower_16_bits(addr),
+		.msg_addr_high = upper_16_bits(addr)
+	};
 	int err;
 
-	phy_msg.opcode = ice_sbq_msg_rd;
-
-	phy_msg.msg_addr_low = lower_16_bits(addr);
-	phy_msg.msg_addr_high = upper_16_bits(addr);
-
-	phy_msg.data = 0;
-	phy_msg.dest_dev = hw->ptp.phy.eth56g.phy_addr[phy_idx];
-
-	err = ice_sbq_rw_reg(hw, &phy_msg, ICE_AQ_FLAG_RD);
-	if (err) {
+	err = ice_sbq_rw_reg(hw, &msg, ICE_AQ_FLAG_RD);
+	if (err)
 		ice_debug(hw, ICE_DBG_PTP, "PTP failed to send msg to phy %d\n",
 			  err);
-		return err;
-	}
-
-	*val = phy_msg.data;
+	else
+		*val = msg.data;
 
-	return 0;
+	return err;
 }
 
 /**
  * ice_phy_res_address_eth56g - Calculate a PHY port register address
- * @port: Port number to be written
+ * @hw: pointer to the HW struct
+ * @lane: Lane number to be written
  * @res_type: resource type (register/memory)
  * @offset: Offset from PHY port register base
  * @addr: The result address
@@ -955,17 +965,19 @@ static int ice_read_phy_eth56g(struct ice_hw *hw, u8 phy_idx, u32 addr,
  * * %0      - success
  * * %EINVAL - invalid port number or resource type
  */
-static int ice_phy_res_address_eth56g(u8 port, enum eth56g_res_type res_type,
-				      u32 offset, u32 *addr)
+static int ice_phy_res_address_eth56g(struct ice_hw *hw, u8 lane,
+				      enum eth56g_res_type res_type,
+				      u32 offset,
+				      u32 *addr)
 {
-	u8 lane = port % ICE_PORTS_PER_QUAD;
-	u8 phy = ICE_GET_QUAD_NUM(port);
-
 	if (res_type >= NUM_ETH56G_PHY_RES)
 		return -EINVAL;
 
-	*addr = eth56g_phy_res[res_type].base[phy] +
+	/* Lanes 4..7 are in fact 0..3 on a second PHY */
+	lane %= hw->ptp.ports_per_phy;
+	*addr = eth56g_phy_res[res_type].base[0] +
 		lane * eth56g_phy_res[res_type].step + offset;
+
 	return 0;
 }
 
@@ -985,19 +997,17 @@ static int ice_phy_res_address_eth56g(u8 port, enum eth56g_res_type res_type,
 static int ice_write_port_eth56g(struct ice_hw *hw, u8 port, u32 offset,
 				 u32 val, enum eth56g_res_type res_type)
 {
-	u8 phy_port = port % hw->ptp.ports_per_phy;
-	u8 phy_idx = port / hw->ptp.ports_per_phy;
 	u32 addr;
 	int err;
 
 	if (port >= hw->ptp.num_lports)
 		return -EINVAL;
 
-	err = ice_phy_res_address_eth56g(phy_port, res_type, offset, &addr);
+	err = ice_phy_res_address_eth56g(hw, port, res_type, offset, &addr);
 	if (err)
 		return err;
 
-	return ice_write_phy_eth56g(hw, phy_idx, addr, val);
+	return ice_write_phy_eth56g(hw, port, addr, val);
 }
 
 /**
@@ -1016,19 +1026,17 @@ static int ice_write_port_eth56g(struct ice_hw *hw, u8 port, u32 offset,
 static int ice_read_port_eth56g(struct ice_hw *hw, u8 port, u32 offset,
 				u32 *val, enum eth56g_res_type res_type)
 {
-	u8 phy_port = port % hw->ptp.ports_per_phy;
-	u8 phy_idx = port / hw->ptp.ports_per_phy;
 	u32 addr;
 	int err;
 
 	if (port >= hw->ptp.num_lports)
 		return -EINVAL;
 
-	err = ice_phy_res_address_eth56g(phy_port, res_type, offset, &addr);
+	err = ice_phy_res_address_eth56g(hw, port, res_type, offset, &addr);
 	if (err)
 		return err;
 
-	return ice_read_phy_eth56g(hw, phy_idx, addr, val);
+	return ice_read_phy_eth56g(hw, port, addr, val);
 }
 
 /**
@@ -1177,6 +1185,56 @@ static int ice_write_port_mem_eth56g(struct ice_hw *hw, u8 port, u16 offset,
 	return ice_write_port_eth56g(hw, port, offset, val, ETH56G_PHY_MEM_PTP);
 }
 
+/**
+ * ice_write_quad_ptp_reg_eth56g - Write a PHY quad register
+ * @hw: pointer to the HW struct
+ * @offset: PHY register offset
+ * @port: Port number
+ * @val: Value to write
+ *
+ * Return:
+ * * %0     - success
+ * * %EIO  - invalid port number or resource type
+ * * %other - failed to write to PHY
+ */
+static int ice_write_quad_ptp_reg_eth56g(struct ice_hw *hw, u8 port,
+					 u32 offset, u32 val)
+{
+	u32 addr;
+
+	if (port >= hw->ptp.num_lports)
+		return -EIO;
+
+	addr = eth56g_phy_res[ETH56G_PHY_REG_PTP].base[0] + offset;
+
+	return ice_write_phy_eth56g(hw, port, addr, val);
+}
+
+/**
+ * ice_read_quad_ptp_reg_eth56g - Read a PHY quad register
+ * @hw: pointer to the HW struct
+ * @offset: PHY register offset
+ * @port: Port number
+ * @val: Value to read
+ *
+ * Return:
+ * * %0     - success
+ * * %EIO  - invalid port number or resource type
+ * * %other - failed to read from PHY
+ */
+static int ice_read_quad_ptp_reg_eth56g(struct ice_hw *hw, u8 port,
+					u32 offset, u32 *val)
+{
+	u32 addr;
+
+	if (port >= hw->ptp.num_lports)
+		return -EIO;
+
+	addr = eth56g_phy_res[ETH56G_PHY_REG_PTP].base[0] + offset;
+
+	return ice_read_phy_eth56g(hw, port, addr, val);
+}
+
 /**
  * ice_is_64b_phy_reg_eth56g - Check if this is a 64bit PHY register
  * @low_addr: the low address to check
@@ -1896,7 +1954,6 @@ ice_phy_get_speed_eth56g(struct ice_link_status *li)
  */
 static int ice_phy_cfg_parpcs_eth56g(struct ice_hw *hw, u8 port)
 {
-	u8 port_blk = port & ~(ICE_PORTS_PER_QUAD - 1);
 	u32 val;
 	int err;
 
@@ -1911,8 +1968,8 @@ static int ice_phy_cfg_parpcs_eth56g(struct ice_hw *hw, u8 port)
 	switch (ice_phy_get_speed_eth56g(&hw->port_info->phy.link_info)) {
 	case ICE_ETH56G_LNK_SPD_1G:
 	case ICE_ETH56G_LNK_SPD_2_5G:
-		err = ice_read_ptp_reg_eth56g(hw, port_blk,
-					      PHY_GPCS_CONFIG_REG0, &val);
+		err = ice_read_quad_ptp_reg_eth56g(hw, port,
+						   PHY_GPCS_CONFIG_REG0, &val);
 		if (err) {
 			ice_debug(hw, ICE_DBG_PTP, "Failed to read PHY_GPCS_CONFIG_REG0, status: %d",
 				  err);
@@ -1923,8 +1980,8 @@ static int ice_phy_cfg_parpcs_eth56g(struct ice_hw *hw, u8 port)
 		val |= FIELD_PREP(PHY_GPCS_CONFIG_REG0_TX_THR_M,
 				  ICE_ETH56G_NOMINAL_TX_THRESH);
 
-		err = ice_write_ptp_reg_eth56g(hw, port_blk,
-					       PHY_GPCS_CONFIG_REG0, val);
+		err = ice_write_quad_ptp_reg_eth56g(hw, port,
+						    PHY_GPCS_CONFIG_REG0, val);
 		if (err) {
 			ice_debug(hw, ICE_DBG_PTP, "Failed to write PHY_GPCS_CONFIG_REG0, status: %d",
 				  err);
@@ -1965,50 +2022,47 @@ static int ice_phy_cfg_parpcs_eth56g(struct ice_hw *hw, u8 port)
  */
 int ice_phy_cfg_ptp_1step_eth56g(struct ice_hw *hw, u8 port)
 {
-	u8 port_blk = port & ~(ICE_PORTS_PER_QUAD - 1);
-	u8 blk_port = port & (ICE_PORTS_PER_QUAD - 1);
+	u8 quad_lane = port % ICE_PORTS_PER_QUAD;
+	u32 addr, val, peer_delay;
 	bool enable, sfd_ena;
-	u32 val, peer_delay;
 	int err;
 
 	enable = hw->ptp.phy.eth56g.onestep_ena;
 	peer_delay = hw->ptp.phy.eth56g.peer_delay;
 	sfd_ena = hw->ptp.phy.eth56g.sfd_ena;
 
-	/* PHY_PTP_1STEP_CONFIG */
-	err = ice_read_ptp_reg_eth56g(hw, port_blk, PHY_PTP_1STEP_CONFIG, &val);
+	addr = PHY_PTP_1STEP_CONFIG;
+	err = ice_read_quad_ptp_reg_eth56g(hw, port, addr, &val);
 	if (err)
 		return err;
 
 	if (enable)
-		val |= blk_port;
+		val |= BIT(quad_lane);
 	else
-		val &= ~blk_port;
+		val &= ~BIT(quad_lane);
 
 	val &= ~(PHY_PTP_1STEP_T1S_UP64_M | PHY_PTP_1STEP_T1S_DELTA_M);
 
-	err = ice_write_ptp_reg_eth56g(hw, port_blk, PHY_PTP_1STEP_CONFIG, val);
+	err = ice_write_quad_ptp_reg_eth56g(hw, port, addr, val);
 	if (err)
 		return err;
 
-	/* PHY_PTP_1STEP_PEER_DELAY */
+	addr = PHY_PTP_1STEP_PEER_DELAY(quad_lane);
 	val = FIELD_PREP(PHY_PTP_1STEP_PD_DELAY_M, peer_delay);
 	if (peer_delay)
 		val |= PHY_PTP_1STEP_PD_ADD_PD_M;
 	val |= PHY_PTP_1STEP_PD_DLY_V_M;
-	err = ice_write_ptp_reg_eth56g(hw, port_blk,
-				       PHY_PTP_1STEP_PEER_DELAY(blk_port), val);
+	err = ice_write_quad_ptp_reg_eth56g(hw, port, addr, val);
 	if (err)
 		return err;
 
 	val &= ~PHY_PTP_1STEP_PD_DLY_V_M;
-	err = ice_write_ptp_reg_eth56g(hw, port_blk,
-				       PHY_PTP_1STEP_PEER_DELAY(blk_port), val);
+	err = ice_write_quad_ptp_reg_eth56g(hw, port, addr, val);
 	if (err)
 		return err;
 
-	/* PHY_MAC_XIF_MODE */
-	err = ice_read_mac_reg_eth56g(hw, port, PHY_MAC_XIF_MODE, &val);
+	addr = PHY_MAC_XIF_MODE;
+	err = ice_read_mac_reg_eth56g(hw, port, addr, &val);
 	if (err)
 		return err;
 
@@ -2028,7 +2082,7 @@ int ice_phy_cfg_ptp_1step_eth56g(struct ice_hw *hw, u8 port)
 	       FIELD_PREP(PHY_MAC_XIF_TS_BIN_MODE_M, enable) |
 	       FIELD_PREP(PHY_MAC_XIF_TS_SFD_ENA_M, sfd_ena);
 
-	return ice_write_mac_reg_eth56g(hw, port, PHY_MAC_XIF_MODE, val);
+	return ice_write_mac_reg_eth56g(hw, port, addr, val);
 }
 
 /**
@@ -2070,21 +2124,22 @@ static u32 ice_ptp_calc_bitslip_eth56g(struct ice_hw *hw, u8 port, u32 bs,
 				       bool fc, bool rs,
 				       enum ice_eth56g_link_spd spd)
 {
-	u8 port_offset = port & (ICE_PORTS_PER_QUAD - 1);
-	u8 port_blk = port & ~(ICE_PORTS_PER_QUAD - 1);
 	u32 bitslip;
 	int err;
 
 	if (!bs || rs)
 		return 0;
 
-	if (spd == ICE_ETH56G_LNK_SPD_1G || spd == ICE_ETH56G_LNK_SPD_2_5G)
+	if (spd == ICE_ETH56G_LNK_SPD_1G || spd == ICE_ETH56G_LNK_SPD_2_5G) {
 		err = ice_read_gpcs_reg_eth56g(hw, port, PHY_GPCS_BITSLIP,
 					       &bitslip);
-	else
-		err = ice_read_ptp_reg_eth56g(hw, port_blk,
-					      PHY_REG_SD_BIT_SLIP(port_offset),
-					      &bitslip);
+	} else {
+		u8 quad_lane = port % ICE_PORTS_PER_QUAD;
+		u32 addr;
+
+		addr = PHY_REG_SD_BIT_SLIP(quad_lane);
+		err = ice_read_quad_ptp_reg_eth56g(hw, port, addr, &bitslip);
+	}
 	if (err)
 		return 0;
 
@@ -2679,8 +2734,6 @@ static void ice_ptp_init_phy_e825(struct ice_hw *hw)
 	params->onestep_ena = false;
 	params->peer_delay = 0;
 	params->sfd_ena = false;
-	params->phy_addr[0] = eth56g_phy_0;
-	params->phy_addr[1] = eth56g_phy_1;
 	params->num_phys = 2;
 	ptp->ports_per_phy = 4;
 	ptp->num_lports = params->num_phys * ptp->ports_per_phy;
@@ -2711,10 +2764,9 @@ static void ice_fill_phy_msg_e82x(struct ice_hw *hw,
 				  struct ice_sbq_msg_input *msg, u8 port,
 				  u16 offset)
 {
-	int phy_port, phy, quadtype;
+	int phy_port, quadtype;
 
 	phy_port = port % hw->ptp.ports_per_phy;
-	phy = port / hw->ptp.ports_per_phy;
 	quadtype = ICE_GET_QUAD_NUM(port) %
 		   ICE_GET_QUAD_NUM(hw->ptp.ports_per_phy);
 
@@ -2726,12 +2778,7 @@ static void ice_fill_phy_msg_e82x(struct ice_hw *hw,
 		msg->msg_addr_high = P_Q1_H(P_4_BASE + offset, phy_port);
 	}
 
-	if (phy == 0)
-		msg->dest_dev = rmn_0;
-	else if (phy == 1)
-		msg->dest_dev = rmn_1;
-	else
-		msg->dest_dev = rmn_2;
+	msg->dest_dev = rmn_0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 45768796691fe..479227bdff75e 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -850,7 +850,6 @@ struct ice_mbx_data {
 
 struct ice_eth56g_params {
 	u8 num_phys;
-	u8 phy_addr[2];
 	bool onestep_ena;
 	bool sfd_ena;
 	u32 peer_delay;
-- 
2.39.5



