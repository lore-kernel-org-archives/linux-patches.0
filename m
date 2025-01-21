Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103E21F669F;
	Tue, 21 Jan 2025 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482318; cv=none; b=CNmAVeFjmsw37q9Idg7V2tzst7wy1ocEf7LglyAdz+kFSlT1rpBFwdaOCtbyBmdM+4bJeAMDVl/p5sf9xCJfQsBatnd+5OrzRFZLXmbAQnVO7Y/Ok+6QA3XCYprlZdvxwUT1kz2LNAkqHyn+f2c+LqYwnkZIvEEsgg8fBZ1zWow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482318; c=relaxed/simple;
	bh=+y481ZHyJuFM/2IUtNA2DXSFSpHDoGX1mxzxc3W5YcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPB3x7/B5DsJesBru+aebECA7b9FuJJaDI7DKqgLJsWXNuK+AXwDU3KBdia16u1gSqD8HAytGmhb/GXpH2jGTVNllJg7Xf7yCR5owoSSeJxfmTZW2Vw0bodAgNTwwllZpiGuYQDwlPu36c92tGGrsvGrRmgFoI4fzNGMYlOB3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJqRJ8EX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJqRJ8EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C242C4CEDF;
	Tue, 21 Jan 2025 17:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482317;
	bh=+y481ZHyJuFM/2IUtNA2DXSFSpHDoGX1mxzxc3W5YcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJqRJ8EXRv4Y/y6nWzSo1hJFJhatulT7Ssmikb4GIg/8zcISWW5qxG4tUeHyuC+1U
	 /YpSNQpKmc4uiOLYCDX1xOzsZPi3DWw94GUsiM5UjPjq98w08n9bvt4ctmVX2m5AKH
	 QXGLDLJfROm3YAAXEbdivpQsjnFLH6BXXvkb9RLw=
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
Subject: [PATCH 6.12 008/122] ice: Fix E825 initialization
Date: Tue, 21 Jan 2025 18:50:56 +0100
Message-ID: <20250121174533.316285360@linuxfoundation.org>
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

[ Upstream commit d79c304c76e9b30ff5527afc176b5c4f9f0374b6 ]

Current implementation checks revision of all PHYs on all PFs, which is
incorrect and may result in initialization failure. Check only the
revision of the current PHY.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 22 +++++++++------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 3816e45b6ab44..f6816c2f71438 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2664,14 +2664,15 @@ static bool ice_is_muxed_topo(struct ice_hw *hw)
 }
 
 /**
- * ice_ptp_init_phy_e825c - initialize PHY parameters
+ * ice_ptp_init_phy_e825 - initialize PHY parameters
  * @hw: pointer to the HW struct
  */
-static void ice_ptp_init_phy_e825c(struct ice_hw *hw)
+static void ice_ptp_init_phy_e825(struct ice_hw *hw)
 {
 	struct ice_ptp_hw *ptp = &hw->ptp;
 	struct ice_eth56g_params *params;
-	u8 phy;
+	u32 phy_rev;
+	int err;
 
 	ptp->phy_model = ICE_PHY_ETH56G;
 	params = &ptp->phy.eth56g;
@@ -2685,15 +2686,10 @@ static void ice_ptp_init_phy_e825c(struct ice_hw *hw)
 	ptp->num_lports = params->num_phys * ptp->ports_per_phy;
 
 	ice_sb_access_ena_eth56g(hw, true);
-	for (phy = 0; phy < params->num_phys; phy++) {
-		u32 phy_rev;
-		int err;
-
-		err = ice_read_phy_eth56g(hw, phy, PHY_REG_REVISION, &phy_rev);
-		if (err || phy_rev != PHY_REVISION_ETH56G) {
-			ptp->phy_model = ICE_PHY_UNSUP;
-			return;
-		}
+	err = ice_read_phy_eth56g(hw, hw->pf_id, PHY_REG_REVISION, &phy_rev);
+	if (err || phy_rev != PHY_REVISION_ETH56G) {
+		ptp->phy_model = ICE_PHY_UNSUP;
+		return;
 	}
 
 	ptp->is_2x50g_muxed_topo = ice_is_muxed_topo(hw);
@@ -5395,7 +5391,7 @@ void ice_ptp_init_hw(struct ice_hw *hw)
 	else if (ice_is_e810(hw))
 		ice_ptp_init_phy_e810(ptp);
 	else if (ice_is_e825c(hw))
-		ice_ptp_init_phy_e825c(hw);
+		ice_ptp_init_phy_e825(hw);
 	else
 		ptp->phy_model = ICE_PHY_UNSUP;
 }
-- 
2.39.5



