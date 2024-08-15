Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0211714D0;
	Thu, 15 Aug 2024 13:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728606; cv=none; b=bkYsZ6mCVerAX2NH0Z8CU39DwUY762fOCzgDZ2E1rC/uWL4vURRMt9YoBLt1DbikP8rxLba1OwSMC0ImgnTYZatp4BA1n45Qi3KKRNwqecn9ONY6Yzajqksr0MZW+3gfphOm3lhpVef/QliB2pF2GoJQz0Hqz9iXOP9TzulJa2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728606; c=relaxed/simple;
	bh=nuejmWtq2x+68voBFiFmBZKG/AnE83J5QdcRWVJ3lgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4kEfiEBDHIRnmBcEE+TAOiMuOpdAc4mwnXfFwynrygaWP7DdVtwiTRCSmt/dkGDzfqkDe80y4cb6I4bcWUv6ho9FjXqew6Vj9nRUMkAWCCsSWNfdAwiNiKg6ET85FoYJtoE3G8471fu74ftDi8XMeS2LgJiJHA0pZkhINHFYoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFW0KjPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFW0KjPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32D3C4AF0A;
	Thu, 15 Aug 2024 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728606;
	bh=nuejmWtq2x+68voBFiFmBZKG/AnE83J5QdcRWVJ3lgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFW0KjPvexzNaH1I+5Xpi66KYMaNfkYtiA0HTRDcRvGvI9s3P2z5jWHmr1we011Cx
	 hq7MDx7SeGxnxfO6uTOSCxVlVcXTd837iF3Pb7EvqsEh+qhx5TSac4QWUbooHof0dr
	 qVP8anbI1SwE84W+9TlnamnGJPzvHwIR9NUAfxvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
	Tony Brelinski <tonyx.brelinski@intel.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/196] ice: Rework flex descriptor programming
Date: Thu, 15 Aug 2024 15:22:50 +0200
Message-ID: <20240815131854.109703267@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit 22ef683b48182f4d6125a2fb2725eb8a141514ff ]

The driver can support two flex descriptor profiles, ICE_RXDID_FLEX_NIC
and ICE_RXDID_FLEX_NIC_2. This patch reworks the current flex programming
logic to add support for the latter profile.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Stable-dep-of: 782161895eb4 ("netfilter: ctnetlink: use helper function to calculate expect ID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 102 ++++++++++++++----
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  24 +++--
 2 files changed, 92 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index f8d00263d9019..72a6f22ee423f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -7,16 +7,16 @@
 
 #define ICE_PF_RESET_WAIT_COUNT	200
 
-#define ICE_NIC_FLX_ENTRY(hw, mdid, idx) \
-	wr32((hw), GLFLXP_RXDID_FLX_WRD_##idx(ICE_RXDID_FLEX_NIC), \
+#define ICE_PROG_FLEX_ENTRY(hw, rxdid, mdid, idx) \
+	wr32((hw), GLFLXP_RXDID_FLX_WRD_##idx(rxdid), \
 	     ((ICE_RX_OPC_MDID << \
 	       GLFLXP_RXDID_FLX_WRD_##idx##_RXDID_OPCODE_S) & \
 	      GLFLXP_RXDID_FLX_WRD_##idx##_RXDID_OPCODE_M) | \
 	     (((mdid) << GLFLXP_RXDID_FLX_WRD_##idx##_PROT_MDID_S) & \
 	      GLFLXP_RXDID_FLX_WRD_##idx##_PROT_MDID_M))
 
-#define ICE_NIC_FLX_FLG_ENTRY(hw, flg_0, flg_1, flg_2, flg_3, idx) \
-	wr32((hw), GLFLXP_RXDID_FLAGS(ICE_RXDID_FLEX_NIC, idx), \
+#define ICE_PROG_FLG_ENTRY(hw, rxdid, flg_0, flg_1, flg_2, flg_3, idx) \
+	wr32((hw), GLFLXP_RXDID_FLAGS(rxdid, idx), \
 	     (((flg_0) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S) & \
 	      GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M) | \
 	     (((flg_1) << GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_1_S) & \
@@ -290,30 +290,85 @@ ice_aq_get_link_info(struct ice_port_info *pi, bool ena_lse,
 }
 
 /**
- * ice_init_flex_parser - initialize rx flex parser
+ * ice_init_flex_flags
  * @hw: pointer to the hardware structure
+ * @prof_id: Rx Descriptor Builder profile ID
  *
- * Function to initialize flex descriptors
+ * Function to initialize Rx flex flags
  */
-static void ice_init_flex_parser(struct ice_hw *hw)
+static void ice_init_flex_flags(struct ice_hw *hw, enum ice_rxdid prof_id)
 {
 	u8 idx = 0;
 
-	ICE_NIC_FLX_ENTRY(hw, ICE_RX_MDID_HASH_LOW, 0);
-	ICE_NIC_FLX_ENTRY(hw, ICE_RX_MDID_HASH_HIGH, 1);
-	ICE_NIC_FLX_ENTRY(hw, ICE_RX_MDID_FLOW_ID_LOWER, 2);
-	ICE_NIC_FLX_ENTRY(hw, ICE_RX_MDID_FLOW_ID_HIGH, 3);
-	ICE_NIC_FLX_FLG_ENTRY(hw, ICE_RXFLG_PKT_FRG, ICE_RXFLG_UDP_GRE,
-			      ICE_RXFLG_PKT_DSI, ICE_RXFLG_FIN, idx++);
-	ICE_NIC_FLX_FLG_ENTRY(hw, ICE_RXFLG_SYN, ICE_RXFLG_RST,
-			      ICE_RXFLG_PKT_DSI, ICE_RXFLG_PKT_DSI, idx++);
-	ICE_NIC_FLX_FLG_ENTRY(hw, ICE_RXFLG_PKT_DSI, ICE_RXFLG_PKT_DSI,
-			      ICE_RXFLG_EVLAN_x8100, ICE_RXFLG_EVLAN_x9100,
-			      idx++);
-	ICE_NIC_FLX_FLG_ENTRY(hw, ICE_RXFLG_VLAN_x8100, ICE_RXFLG_TNL_VLAN,
-			      ICE_RXFLG_TNL_MAC, ICE_RXFLG_TNL0, idx++);
-	ICE_NIC_FLX_FLG_ENTRY(hw, ICE_RXFLG_TNL1, ICE_RXFLG_TNL2,
-			      ICE_RXFLG_PKT_DSI, ICE_RXFLG_PKT_DSI, idx);
+	/* Flex-flag fields (0-2) are programmed with FLG64 bits with layout:
+	 * flexiflags0[5:0] - TCP flags, is_packet_fragmented, is_packet_UDP_GRE
+	 * flexiflags1[3:0] - Not used for flag programming
+	 * flexiflags2[7:0] - Tunnel and VLAN types
+	 * 2 invalid fields in last index
+	 */
+	switch (prof_id) {
+	/* Rx flex flags are currently programmed for the NIC profiles only.
+	 * Different flag bit programming configurations can be added per
+	 * profile as needed.
+	 */
+	case ICE_RXDID_FLEX_NIC:
+	case ICE_RXDID_FLEX_NIC_2:
+		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_RXFLG_PKT_FRG,
+				   ICE_RXFLG_UDP_GRE, ICE_RXFLG_PKT_DSI,
+				   ICE_RXFLG_FIN, idx++);
+		/* flex flag 1 is not used for flexi-flag programming, skipping
+		 * these four FLG64 bits.
+		 */
+		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_RXFLG_SYN, ICE_RXFLG_RST,
+				   ICE_RXFLG_PKT_DSI, ICE_RXFLG_PKT_DSI, idx++);
+		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_RXFLG_PKT_DSI,
+				   ICE_RXFLG_PKT_DSI, ICE_RXFLG_EVLAN_x8100,
+				   ICE_RXFLG_EVLAN_x9100, idx++);
+		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_RXFLG_VLAN_x8100,
+				   ICE_RXFLG_TNL_VLAN, ICE_RXFLG_TNL_MAC,
+				   ICE_RXFLG_TNL0, idx++);
+		ICE_PROG_FLG_ENTRY(hw, prof_id, ICE_RXFLG_TNL1, ICE_RXFLG_TNL2,
+				   ICE_RXFLG_PKT_DSI, ICE_RXFLG_PKT_DSI, idx);
+		break;
+
+	default:
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Flag programming for profile ID %d not supported\n",
+			  prof_id);
+	}
+}
+
+/**
+ * ice_init_flex_flds
+ * @hw: pointer to the hardware structure
+ * @prof_id: Rx Descriptor Builder profile ID
+ *
+ * Function to initialize flex descriptors
+ */
+static void ice_init_flex_flds(struct ice_hw *hw, enum ice_rxdid prof_id)
+{
+	enum ice_flex_rx_mdid mdid;
+
+	switch (prof_id) {
+	case ICE_RXDID_FLEX_NIC:
+	case ICE_RXDID_FLEX_NIC_2:
+		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_HASH_LOW, 0);
+		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_HASH_HIGH, 1);
+		ICE_PROG_FLEX_ENTRY(hw, prof_id, ICE_RX_MDID_FLOW_ID_LOWER, 2);
+
+		mdid = (prof_id == ICE_RXDID_FLEX_NIC_2) ?
+			ICE_RX_MDID_SRC_VSI : ICE_RX_MDID_FLOW_ID_HIGH;
+
+		ICE_PROG_FLEX_ENTRY(hw, prof_id, mdid, 3);
+
+		ice_init_flex_flags(hw, prof_id);
+		break;
+
+	default:
+		ice_debug(hw, ICE_DBG_INIT,
+			  "Field init for profile ID %d not supported\n",
+			  prof_id);
+	}
 }
 
 /**
@@ -494,7 +549,8 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
 
-	ice_init_flex_parser(hw);
+	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC);
+	ice_init_flex_flds(hw, ICE_RXDID_FLEX_NIC_2);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 068dbc740b766..94504023d86e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -188,23 +188,25 @@ struct ice_32b_rx_flex_desc_nic {
  * with a specific metadata (profile 7 reserved for HW)
  */
 enum ice_rxdid {
-	ICE_RXDID_START			= 0,
-	ICE_RXDID_LEGACY_0		= ICE_RXDID_START,
-	ICE_RXDID_LEGACY_1,
-	ICE_RXDID_FLX_START,
-	ICE_RXDID_FLEX_NIC		= ICE_RXDID_FLX_START,
-	ICE_RXDID_FLX_LAST		= 63,
-	ICE_RXDID_LAST			= ICE_RXDID_FLX_LAST
+	ICE_RXDID_LEGACY_0		= 0,
+	ICE_RXDID_LEGACY_1		= 1,
+	ICE_RXDID_FLEX_NIC		= 2,
+	ICE_RXDID_FLEX_NIC_2		= 6,
+	ICE_RXDID_HW			= 7,
+	ICE_RXDID_LAST			= 63,
 };
 
 /* Receive Flex Descriptor Rx opcode values */
 #define ICE_RX_OPC_MDID		0x01
 
 /* Receive Descriptor MDID values */
-#define ICE_RX_MDID_FLOW_ID_LOWER	5
-#define ICE_RX_MDID_FLOW_ID_HIGH	6
-#define ICE_RX_MDID_HASH_LOW		56
-#define ICE_RX_MDID_HASH_HIGH		57
+enum ice_flex_rx_mdid {
+	ICE_RX_MDID_FLOW_ID_LOWER	= 5,
+	ICE_RX_MDID_FLOW_ID_HIGH,
+	ICE_RX_MDID_SRC_VSI		= 19,
+	ICE_RX_MDID_HASH_LOW		= 56,
+	ICE_RX_MDID_HASH_HIGH,
+};
 
 /* Rx Flag64 packet flag bits */
 enum ice_rx_flg64_bits {
-- 
2.43.0



