Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19319F121;
	Wed,  5 Feb 2025 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767650; cv=none; b=knKC5M3DtmlmsoHEL/RPMOOozpxdGMQnDRxAcM4z9W4vqO/CgvhQulXoaWAv9IVLeLLOa6u8X+N9dZYlEl0gzr/3VoY/4zcODd3DvLm/83G6uilCX9/Ai5J7uGxVU06y0z8AITnZ4nrpZFsCSPs++yHMEbWhgoMhn/5X86Ec8oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767650; c=relaxed/simple;
	bh=RlmjpRXdkBdEQ2VpmY2Zl2OVS0bjQL5HR6EE1HvJSv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOsdGDw3azu59VbtZr+2Z1nhyof+GlAksjlxPAQ9TvhaNZXByUTq7cK6+097zE38yzwwr3KOGe5hMB9crjAaOgENW0/2IrF1srzH/USThj0xkdzcHUjnnWDuxIEiarOYaRJDC2fWundQGEEi8M95fu++1Ck+ngzO+iejbwbpY3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZtQfAh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZtQfAh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EC5C4CED6;
	Wed,  5 Feb 2025 15:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767650;
	bh=RlmjpRXdkBdEQ2VpmY2Zl2OVS0bjQL5HR6EE1HvJSv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZtQfAh94KnL9f/Q9EdQJBUk2FYEwMosDE3WglM6D4woPCPWVIxwmCtR+4ib1EDhS
	 jU43SN01TKWTCDOczTBE41tMHc0NT2y+HlhgoWozuq18yMG+ITfqw790Iazdy8z3Iz
	 f+oaMhlLzVwWsGfJAExshl7u5uw5XxjhxJBXkkXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.12 487/590] ice: rework of dump serdes equalizer values feature
Date: Wed,  5 Feb 2025 14:44:02 +0100
Message-ID: <20250205134513.892910883@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Mateusz Polchlopek <mateusz.polchlopek@intel.com>

[ Upstream commit 8ea085937dad2d0b5399bc58722934f562b9abef ]

Refactor function ice_get_tx_rx_equa() to iterate over new table of
params instead of multiple calls to ice_aq_get_phy_equalization().

Subsequent commit will extend that function by add more serdes equalizer
values to dump.

Shorten the fields of struct ice_serdes_equalization_to_ethtool for
readability purposes.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: c5cc2a27e04f ("ice: remove invalid parameter of equalizer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 93 ++++++--------------
 drivers/net/ethernet/intel/ice/ice_ethtool.h | 22 ++---
 2 files changed, 38 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index d5cc934d13594..e011966e94502 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -693,75 +693,36 @@ static int ice_get_port_topology(struct ice_hw *hw, u8 lport,
 static int ice_get_tx_rx_equa(struct ice_hw *hw, u8 serdes_num,
 			      struct ice_serdes_equalization_to_ethtool *ptr)
 {
+	static const int tx = ICE_AQC_OP_CODE_TX_EQU;
+	static const int rx = ICE_AQC_OP_CODE_RX_EQU;
+	struct {
+		int data_in;
+		int opcode;
+		int *out;
+	} aq_params[] = {
+		{ ICE_AQC_TX_EQU_PRE1, tx, &ptr->tx_equ_pre1 },
+		{ ICE_AQC_TX_EQU_PRE3, tx, &ptr->tx_equ_pre3 },
+		{ ICE_AQC_TX_EQU_ATTEN, tx, &ptr->tx_equ_atten },
+		{ ICE_AQC_TX_EQU_POST1, tx, &ptr->tx_equ_post1 },
+		{ ICE_AQC_TX_EQU_PRE2, tx, &ptr->tx_equ_pre2 },
+		{ ICE_AQC_RX_EQU_PRE2, rx, &ptr->rx_equ_pre2 },
+		{ ICE_AQC_RX_EQU_PRE1, rx, &ptr->rx_equ_pre1 },
+		{ ICE_AQC_RX_EQU_POST1, rx, &ptr->rx_equ_post1 },
+		{ ICE_AQC_RX_EQU_BFLF, rx, &ptr->rx_equ_bflf },
+		{ ICE_AQC_RX_EQU_BFHF, rx, &ptr->rx_equ_bfhf },
+		{ ICE_AQC_RX_EQU_DRATE, rx, &ptr->rx_equ_drate },
+	};
 	int err;
 
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_TX_EQU_PRE1,
-					  ICE_AQC_OP_CODE_TX_EQU, serdes_num,
-					  &ptr->tx_equalization_pre1);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_TX_EQU_PRE3,
-					  ICE_AQC_OP_CODE_TX_EQU, serdes_num,
-					  &ptr->tx_equalization_pre3);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_TX_EQU_ATTEN,
-					  ICE_AQC_OP_CODE_TX_EQU, serdes_num,
-					  &ptr->tx_equalization_atten);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_TX_EQU_POST1,
-					  ICE_AQC_OP_CODE_TX_EQU, serdes_num,
-					  &ptr->tx_equalization_post1);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_TX_EQU_PRE2,
-					  ICE_AQC_OP_CODE_TX_EQU, serdes_num,
-					  &ptr->tx_equalization_pre2);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_PRE2,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_pre2);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_PRE1,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_pre1);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_POST1,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_post1);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_BFLF,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_bflf);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_BFHF,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_bfhf);
-	if (err)
-		return err;
-
-	err = ice_aq_get_phy_equalization(hw, ICE_AQC_RX_EQU_DRATE,
-					  ICE_AQC_OP_CODE_RX_EQU, serdes_num,
-					  &ptr->rx_equalization_drate);
-	if (err)
-		return err;
+	for (int i = 0; i < ARRAY_SIZE(aq_params); i++) {
+		err = ice_aq_get_phy_equalization(hw, aq_params[i].data_in,
+						  aq_params[i].opcode,
+						  serdes_num, aq_params[i].out);
+		if (err)
+			break;
+	}
 
-	return 0;
+	return err;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.h b/drivers/net/ethernet/intel/ice/ice_ethtool.h
index 9acccae38625a..98eb9c51d687c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.h
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.h
@@ -10,17 +10,17 @@ struct ice_phy_type_to_ethtool {
 };
 
 struct ice_serdes_equalization_to_ethtool {
-	int rx_equalization_pre2;
-	int rx_equalization_pre1;
-	int rx_equalization_post1;
-	int rx_equalization_bflf;
-	int rx_equalization_bfhf;
-	int rx_equalization_drate;
-	int tx_equalization_pre1;
-	int tx_equalization_pre3;
-	int tx_equalization_atten;
-	int tx_equalization_post1;
-	int tx_equalization_pre2;
+	int rx_equ_pre2;
+	int rx_equ_pre1;
+	int rx_equ_post1;
+	int rx_equ_bflf;
+	int rx_equ_bfhf;
+	int rx_equ_drate;
+	int tx_equ_pre1;
+	int tx_equ_pre3;
+	int tx_equ_atten;
+	int tx_equ_post1;
+	int tx_equ_pre2;
 };
 
 struct ice_regdump_to_ethtool {
-- 
2.39.5



