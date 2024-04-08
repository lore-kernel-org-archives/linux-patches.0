Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B78512D1FD;
	Mon,  8 Apr 2024 13:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583036; cv=none; b=bZDcjwDRpjmYOnIg2fSmALcEaD2374f90kTBqdS04YrJgmsXxKx2HyGQiUL7r2Qd/F7fuisA6VIpOS5JXGT0Qy63D9/7n9DMvYZkkdJYS6f0mEt8kEAiTW9oziX4DbaFZ18XJtDZXWzyLg2TFe/vbBwjpJzY5iPcPESYcnNsS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583036; c=relaxed/simple;
	bh=+eqeKU8T9TcOha1V1jgvfKbMTWGuMyHTYtfqUKk04rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls40ReTcjl+uVPZ+l0SNu9sExGz0X5DsCqeWsRGFMCc2Bsl2QAOFiMG69DfXicJcOkLYqceLn8752sVdpQu3dZHHu+9eX2pNtk8wZZoIp8UbxAbWxy0FsfVaEj/kYhqEF0b2MN4NYLfaF0EA2vMKj+5UMq+WlgLbaGfIKxesA3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFTPb0Jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFTPb0Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351D2C433C7;
	Mon,  8 Apr 2024 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583035;
	bh=+eqeKU8T9TcOha1V1jgvfKbMTWGuMyHTYtfqUKk04rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFTPb0Jgu5Fv4L/qRNxTp+ju4TJh00Qu7BAkIu+PQo9NQdqetEb2iyx1wpAm8Cpaf
	 TRE97UTvwM4ElUJvD9CgnFjNH6JonxsE67iPNQDVul7sqz+cA2XdcX6WXBac7g/crN
	 u0ADukDGfU+NefgTS7qB3P05m+oF9lYFpDe/iEt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Mushayev <nikolay.mushayev@intel.com>,
	Nir Efrati <nir.efrati@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Naama Meir <naamax.meir@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/252] e1000e: Workaround for sporadic MDI error on Meteor Lake systems
Date: Mon,  8 Apr 2024 14:57:29 +0200
Message-ID: <20240408125311.312676780@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit 6dbdd4de0362c37e54e8b049781402e5a409e7d0 ]

On some Meteor Lake systems accessing the PHY via the MDIO interface may
result in an MDI error. This issue happens sporadically and in most cases
a second access to the PHY via the MDIO interface results in success.

As a workaround, introduce a retry counter which is set to 3 on Meteor
Lake systems. The driver will only return an error if 3 consecutive PHY
access attempts fail. The retry mechanism is disabled in specific flows,
where MDI errors are expected.

Fixes: cc23f4f0b6b9 ("e1000e: Add support for Meteor Lake")
Suggested-by: Nikolay Mushayev <nikolay.mushayev@intel.com>
Co-developed-by: Nir Efrati <nir.efrati@intel.com>
Signed-off-by: Nir Efrati <nir.efrati@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/hw.h      |   2 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c |  33 ++++
 drivers/net/ethernet/intel/e1000e/phy.c     | 182 ++++++++++++--------
 drivers/net/ethernet/intel/e1000e/phy.h     |   2 +
 4 files changed, 150 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 1fef6bb5a5fbc..4b6e7536170ab 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -628,6 +628,7 @@ struct e1000_phy_info {
 	u32 id;
 	u32 reset_delay_us;	/* in usec */
 	u32 revision;
+	u32 retry_count;
 
 	enum e1000_media_type media_type;
 
@@ -644,6 +645,7 @@ struct e1000_phy_info {
 	bool polarity_correction;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
+	bool retry_enabled;
 };
 
 struct e1000_nvm_info {
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index a2788fd5f8bb8..717c52913e84b 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -222,11 +222,18 @@ static bool e1000_phy_is_accessible_pchlan(struct e1000_hw *hw)
 	if (hw->mac.type >= e1000_pch_lpt) {
 		/* Only unforce SMBus if ME is not active */
 		if (!(er32(FWSM) & E1000_ICH_FWSM_FW_VALID)) {
+			/* Switching PHY interface always returns MDI error
+			 * so disable retry mechanism to avoid wasting time
+			 */
+			e1000e_disable_phy_retry(hw);
+
 			/* Unforce SMBus mode in PHY */
 			e1e_rphy_locked(hw, CV_SMB_CTRL, &phy_reg);
 			phy_reg &= ~CV_SMB_CTRL_FORCE_SMBUS;
 			e1e_wphy_locked(hw, CV_SMB_CTRL, phy_reg);
 
+			e1000e_enable_phy_retry(hw);
+
 			/* Unforce SMBus mode in MAC */
 			mac_reg = er32(CTRL_EXT);
 			mac_reg &= ~E1000_CTRL_EXT_FORCE_SMBUS;
@@ -310,6 +317,11 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 		goto out;
 	}
 
+	/* There is no guarantee that the PHY is accessible at this time
+	 * so disable retry mechanism to avoid wasting time
+	 */
+	e1000e_disable_phy_retry(hw);
+
 	/* The MAC-PHY interconnect may be in SMBus mode.  If the PHY is
 	 * inaccessible and resetting the PHY is not blocked, toggle the
 	 * LANPHYPC Value bit to force the interconnect to PCIe mode.
@@ -380,6 +392,8 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 		break;
 	}
 
+	e1000e_enable_phy_retry(hw);
+
 	hw->phy.ops.release(hw);
 	if (!ret_val) {
 
@@ -449,6 +463,11 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 
 	phy->id = e1000_phy_unknown;
 
+	if (hw->mac.type == e1000_pch_mtp) {
+		phy->retry_count = 2;
+		e1000e_enable_phy_retry(hw);
+	}
+
 	ret_val = e1000_init_phy_workarounds_pchlan(hw);
 	if (ret_val)
 		return ret_val;
@@ -1146,6 +1165,11 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	if (ret_val)
 		goto out;
 
+	/* Switching PHY interface always returns MDI error
+	 * so disable retry mechanism to avoid wasting time
+	 */
+	e1000e_disable_phy_retry(hw);
+
 	/* Force SMBus mode in PHY */
 	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &phy_reg);
 	if (ret_val)
@@ -1153,6 +1177,8 @@ s32 e1000_enable_ulp_lpt_lp(struct e1000_hw *hw, bool to_sx)
 	phy_reg |= CV_SMB_CTRL_FORCE_SMBUS;
 	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
 
+	e1000e_enable_phy_retry(hw);
+
 	/* Force SMBus mode in MAC */
 	mac_reg = er32(CTRL_EXT);
 	mac_reg |= E1000_CTRL_EXT_FORCE_SMBUS;
@@ -1313,6 +1339,11 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 		/* Toggle LANPHYPC Value bit */
 		e1000_toggle_lanphypc_pch_lpt(hw);
 
+	/* Switching PHY interface always returns MDI error
+	 * so disable retry mechanism to avoid wasting time
+	 */
+	e1000e_disable_phy_retry(hw);
+
 	/* Unforce SMBus mode in PHY */
 	ret_val = e1000_read_phy_reg_hv_locked(hw, CV_SMB_CTRL, &phy_reg);
 	if (ret_val) {
@@ -1333,6 +1364,8 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
 	phy_reg &= ~CV_SMB_CTRL_FORCE_SMBUS;
 	e1000_write_phy_reg_hv_locked(hw, CV_SMB_CTRL, phy_reg);
 
+	e1000e_enable_phy_retry(hw);
+
 	/* Unforce SMBus mode in MAC */
 	mac_reg = er32(CTRL_EXT);
 	mac_reg &= ~E1000_CTRL_EXT_FORCE_SMBUS;
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index 96ff0ca561b6c..395746bcf8f7c 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -107,6 +107,16 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw *hw)
 	return e1e_wphy(hw, M88E1000_PHY_GEN_CONTROL, 0);
 }
 
+void e1000e_disable_phy_retry(struct e1000_hw *hw)
+{
+	hw->phy.retry_enabled = false;
+}
+
+void e1000e_enable_phy_retry(struct e1000_hw *hw)
+{
+	hw->phy.retry_enabled = true;
+}
+
 /**
  *  e1000e_read_phy_reg_mdic - Read MDI control register
  *  @hw: pointer to the HW structure
@@ -118,55 +128,73 @@ s32 e1000e_phy_reset_dsp(struct e1000_hw *hw)
  **/
 s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
 {
+	u32 i, mdic = 0, retry_counter, retry_max;
 	struct e1000_phy_info *phy = &hw->phy;
-	u32 i, mdic = 0;
+	bool success;
 
 	if (offset > MAX_PHY_REG_ADDRESS) {
 		e_dbg("PHY Address %d is out of range\n", offset);
 		return -E1000_ERR_PARAM;
 	}
 
+	retry_max = phy->retry_enabled ? phy->retry_count : 0;
+
 	/* Set up Op-code, Phy Address, and register offset in the MDI
 	 * Control register.  The MAC will take care of interfacing with the
 	 * PHY to retrieve the desired data.
 	 */
-	mdic = ((offset << E1000_MDIC_REG_SHIFT) |
-		(phy->addr << E1000_MDIC_PHY_SHIFT) |
-		(E1000_MDIC_OP_READ));
+	for (retry_counter = 0; retry_counter <= retry_max; retry_counter++) {
+		success = true;
 
-	ew32(MDIC, mdic);
+		mdic = ((offset << E1000_MDIC_REG_SHIFT) |
+			(phy->addr << E1000_MDIC_PHY_SHIFT) |
+			(E1000_MDIC_OP_READ));
 
-	/* Poll the ready bit to see if the MDI read completed
-	 * Increasing the time out as testing showed failures with
-	 * the lower time out
-	 */
-	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
-		udelay(50);
-		mdic = er32(MDIC);
-		if (mdic & E1000_MDIC_READY)
-			break;
-	}
-	if (!(mdic & E1000_MDIC_READY)) {
-		e_dbg("MDI Read PHY Reg Address %d did not complete\n", offset);
-		return -E1000_ERR_PHY;
-	}
-	if (mdic & E1000_MDIC_ERROR) {
-		e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
-		return -E1000_ERR_PHY;
-	}
-	if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
-		e_dbg("MDI Read offset error - requested %d, returned %d\n",
-		      offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
-		return -E1000_ERR_PHY;
+		ew32(MDIC, mdic);
+
+		/* Poll the ready bit to see if the MDI read completed
+		 * Increasing the time out as testing showed failures with
+		 * the lower time out
+		 */
+		for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
+			usleep_range(50, 60);
+			mdic = er32(MDIC);
+			if (mdic & E1000_MDIC_READY)
+				break;
+		}
+		if (!(mdic & E1000_MDIC_READY)) {
+			e_dbg("MDI Read PHY Reg Address %d did not complete\n",
+			      offset);
+			success = false;
+		}
+		if (mdic & E1000_MDIC_ERROR) {
+			e_dbg("MDI Read PHY Reg Address %d Error\n", offset);
+			success = false;
+		}
+		if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
+			e_dbg("MDI Read offset error - requested %d, returned %d\n",
+			      offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
+			success = false;
+		}
+
+		/* Allow some time after each MDIC transaction to avoid
+		 * reading duplicate data in the next MDIC transaction.
+		 */
+		if (hw->mac.type == e1000_pch2lan)
+			usleep_range(100, 150);
+
+		if (success) {
+			*data = (u16)mdic;
+			return 0;
+		}
+
+		if (retry_counter != retry_max) {
+			e_dbg("Perform retry on PHY transaction...\n");
+			mdelay(10);
+		}
 	}
-	*data = (u16)mdic;
 
-	/* Allow some time after each MDIC transaction to avoid
-	 * reading duplicate data in the next MDIC transaction.
-	 */
-	if (hw->mac.type == e1000_pch2lan)
-		udelay(100);
-	return 0;
+	return -E1000_ERR_PHY;
 }
 
 /**
@@ -179,56 +207,72 @@ s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data)
  **/
 s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data)
 {
+	u32 i, mdic = 0, retry_counter, retry_max;
 	struct e1000_phy_info *phy = &hw->phy;
-	u32 i, mdic = 0;
+	bool success;
 
 	if (offset > MAX_PHY_REG_ADDRESS) {
 		e_dbg("PHY Address %d is out of range\n", offset);
 		return -E1000_ERR_PARAM;
 	}
 
+	retry_max = phy->retry_enabled ? phy->retry_count : 0;
+
 	/* Set up Op-code, Phy Address, and register offset in the MDI
 	 * Control register.  The MAC will take care of interfacing with the
 	 * PHY to retrieve the desired data.
 	 */
-	mdic = (((u32)data) |
-		(offset << E1000_MDIC_REG_SHIFT) |
-		(phy->addr << E1000_MDIC_PHY_SHIFT) |
-		(E1000_MDIC_OP_WRITE));
+	for (retry_counter = 0; retry_counter <= retry_max; retry_counter++) {
+		success = true;
 
-	ew32(MDIC, mdic);
+		mdic = (((u32)data) |
+			(offset << E1000_MDIC_REG_SHIFT) |
+			(phy->addr << E1000_MDIC_PHY_SHIFT) |
+			(E1000_MDIC_OP_WRITE));
 
-	/* Poll the ready bit to see if the MDI read completed
-	 * Increasing the time out as testing showed failures with
-	 * the lower time out
-	 */
-	for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
-		udelay(50);
-		mdic = er32(MDIC);
-		if (mdic & E1000_MDIC_READY)
-			break;
-	}
-	if (!(mdic & E1000_MDIC_READY)) {
-		e_dbg("MDI Write PHY Reg Address %d did not complete\n", offset);
-		return -E1000_ERR_PHY;
-	}
-	if (mdic & E1000_MDIC_ERROR) {
-		e_dbg("MDI Write PHY Red Address %d Error\n", offset);
-		return -E1000_ERR_PHY;
-	}
-	if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
-		e_dbg("MDI Write offset error - requested %d, returned %d\n",
-		      offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
-		return -E1000_ERR_PHY;
-	}
+		ew32(MDIC, mdic);
 
-	/* Allow some time after each MDIC transaction to avoid
-	 * reading duplicate data in the next MDIC transaction.
-	 */
-	if (hw->mac.type == e1000_pch2lan)
-		udelay(100);
+		/* Poll the ready bit to see if the MDI read completed
+		 * Increasing the time out as testing showed failures with
+		 * the lower time out
+		 */
+		for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
+			usleep_range(50, 60);
+			mdic = er32(MDIC);
+			if (mdic & E1000_MDIC_READY)
+				break;
+		}
+		if (!(mdic & E1000_MDIC_READY)) {
+			e_dbg("MDI Write PHY Reg Address %d did not complete\n",
+			      offset);
+			success = false;
+		}
+		if (mdic & E1000_MDIC_ERROR) {
+			e_dbg("MDI Write PHY Reg Address %d Error\n", offset);
+			success = false;
+		}
+		if (FIELD_GET(E1000_MDIC_REG_MASK, mdic) != offset) {
+			e_dbg("MDI Write offset error - requested %d, returned %d\n",
+			      offset, FIELD_GET(E1000_MDIC_REG_MASK, mdic));
+			success = false;
+		}
 
-	return 0;
+		/* Allow some time after each MDIC transaction to avoid
+		 * reading duplicate data in the next MDIC transaction.
+		 */
+		if (hw->mac.type == e1000_pch2lan)
+			usleep_range(100, 150);
+
+		if (success)
+			return 0;
+
+		if (retry_counter != retry_max) {
+			e_dbg("Perform retry on PHY transaction...\n");
+			mdelay(10);
+		}
+	}
+
+	return -E1000_ERR_PHY;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/e1000e/phy.h b/drivers/net/ethernet/intel/e1000e/phy.h
index c48777d095235..049bb325b4b14 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.h
+++ b/drivers/net/ethernet/intel/e1000e/phy.h
@@ -51,6 +51,8 @@ s32 e1000e_read_phy_reg_bm2(struct e1000_hw *hw, u32 offset, u16 *data);
 s32 e1000e_write_phy_reg_bm2(struct e1000_hw *hw, u32 offset, u16 data);
 void e1000_power_up_phy_copper(struct e1000_hw *hw);
 void e1000_power_down_phy_copper(struct e1000_hw *hw);
+void e1000e_disable_phy_retry(struct e1000_hw *hw);
+void e1000e_enable_phy_retry(struct e1000_hw *hw);
 s32 e1000e_read_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 *data);
 s32 e1000e_write_phy_reg_mdic(struct e1000_hw *hw, u32 offset, u16 data);
 s32 e1000_read_phy_reg_hv(struct e1000_hw *hw, u32 offset, u16 *data);
-- 
2.43.0



