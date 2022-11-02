Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4B633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAFCC433D7;
	Wed,  2 Nov 2022 03:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360791;
	bh=A+3HssKSdeDxHrQfZLvEScsp8a4hjSHVsROCqAYfT+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8krNiEEGO7j+wQEtkQdRsLceDSb8FJbSA8UNg+m5u50OTZSSbXqAvBZCXfgsGvJo
	 NN0KL7KkZT6z8b7ZHZg9CLo/PtP2ZvgmEYgbcqx1W7vtA/cGPdxgKuwaPVtqsuCPL5
	 ukuU5vjjcTCP9JhjmcLXnVL7HlqfVGpXeI3+c0Hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slawomir Laba <slawomirx.laba@intel.com>,
	Michal Jaron <michalx.jaron@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 4.9 38/44] i40e: Fix ethtool rx-flow-hash setting for X722
Date: Wed,  2 Nov 2022 03:35:24 +0100
Message-Id: <20221102022050.407156209@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 54b5af5a438076082d482cab105b1bd484ab5074 ]

When enabling flow type for RSS hash via ethtool:

ethtool -N $pf rx-flow-hash tcp4|tcp6|udp4|udp6 s|d

the driver would fail to setup this setting on X722
device since it was using the mask on the register
dedicated for X710 devices.

Apply a different mask on the register when setting the
RSS hash for the X722 device.

When displaying the flow types enabled via ethtool:

ethtool -n $pf rx-flow-hash tcp4|tcp6|udp4|udp6

the driver would print wrong values for X722 device.

Fix this issue by testing masks for X722 device in
i40e_get_rss_hash_opts function.

Fixes: eb0dd6e4a3b3 ("i40e: Allow RSS Hash set with less than four parameters")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20221024100526.1874914-1-jacob.e.keller@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 31 ++++++++++++++-----
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  4 +++
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index f4569461dcb8..71105a6c231d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2263,10 +2263,17 @@ static int i40e_get_rss_hash_opts(struct i40e_pf *pf, struct ethtool_rxnfc *cmd)
 
 		if (cmd->flow_type == TCP_V4_FLOW ||
 		    cmd->flow_type == UDP_V4_FLOW) {
-			if (i_set & I40E_L3_SRC_MASK)
-				cmd->data |= RXH_IP_SRC;
-			if (i_set & I40E_L3_DST_MASK)
-				cmd->data |= RXH_IP_DST;
+			if (hw->mac.type == I40E_MAC_X722) {
+				if (i_set & I40E_X722_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_X722_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			} else {
+				if (i_set & I40E_L3_SRC_MASK)
+					cmd->data |= RXH_IP_SRC;
+				if (i_set & I40E_L3_DST_MASK)
+					cmd->data |= RXH_IP_DST;
+			}
 		} else if (cmd->flow_type == TCP_V6_FLOW ||
 			  cmd->flow_type == UDP_V6_FLOW) {
 			if (i_set & I40E_L3_V6_SRC_MASK)
@@ -2419,12 +2426,15 @@ static int i40e_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 
 /**
  * i40e_get_rss_hash_bits - Read RSS Hash bits from register
+ * @hw: hw structure
  * @nfc: pointer to user request
  * @i_setc bits currently set
  *
  * Returns value of bits to be set per user request
  **/
-static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
+static u64 i40e_get_rss_hash_bits(struct i40e_hw *hw,
+				  struct ethtool_rxnfc *nfc,
+				  u64 i_setc)
 {
 	u64 i_set = i_setc;
 	u64 src_l3 = 0, dst_l3 = 0;
@@ -2443,8 +2453,13 @@ static u64 i40e_get_rss_hash_bits(struct ethtool_rxnfc *nfc, u64 i_setc)
 		dst_l3 = I40E_L3_V6_DST_MASK;
 	} else if (nfc->flow_type == TCP_V4_FLOW ||
 		  nfc->flow_type == UDP_V4_FLOW) {
-		src_l3 = I40E_L3_SRC_MASK;
-		dst_l3 = I40E_L3_DST_MASK;
+		if (hw->mac.type == I40E_MAC_X722) {
+			src_l3 = I40E_X722_L3_SRC_MASK;
+			dst_l3 = I40E_X722_L3_DST_MASK;
+		} else {
+			src_l3 = I40E_L3_SRC_MASK;
+			dst_l3 = I40E_L3_DST_MASK;
+		}
 	} else {
 		/* Any other flow type are not supported here */
 		return i_set;
@@ -2553,7 +2568,7 @@ static int i40e_set_rss_hash_opt(struct i40e_pf *pf, struct ethtool_rxnfc *nfc)
 					       flow_pctype)) |
 			((u64)i40e_read_rx_ctl(hw, I40E_GLQF_HASH_INSET(1,
 					       flow_pctype)) << 32);
-		i_set = i40e_get_rss_hash_bits(nfc, i_setc);
+		i_set = i40e_get_rss_hash_bits(&pf->hw, nfc, i_setc);
 		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(0, flow_pctype),
 				  (u32)i_set);
 		i40e_write_rx_ctl(hw, I40E_GLQF_HASH_INSET(1, flow_pctype),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index bd5f13bef83c..a855de9ff1c1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -1542,6 +1542,10 @@ struct i40e_lldp_variables {
 #define I40E_PFQF_CTL_0_HASHLUTSIZE_512	0x00010000
 
 /* INPUT SET MASK for RSS, flow director, and flexible payload */
+#define I40E_X722_L3_SRC_SHIFT		49
+#define I40E_X722_L3_SRC_MASK		(0x3ULL << I40E_X722_L3_SRC_SHIFT)
+#define I40E_X722_L3_DST_SHIFT		41
+#define I40E_X722_L3_DST_MASK		(0x3ULL << I40E_X722_L3_DST_SHIFT)
 #define I40E_L3_SRC_SHIFT		47
 #define I40E_L3_SRC_MASK		(0x3ULL << I40E_L3_SRC_SHIFT)
 #define I40E_L3_V6_SRC_SHIFT		43
-- 
2.35.1



