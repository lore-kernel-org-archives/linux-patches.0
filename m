Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032CE265602;
	Tue,  8 Apr 2025 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111938; cv=none; b=iq5hv2rTvUhZEjlINFpF5ET5NQoDK4NkdHxTPtY5fFZJBuEc6yS+OwlVkZyrK9dFXfhNr3086kslvRdBpDMmfmtheuWr+VhV1GcQKcHlRiN/Qf7i5fylxYu2bBBmUtY1bjaTWp6g1/K/0GjtPs49u59rWy8Ce8kdTnfkkycd68M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111938; c=relaxed/simple;
	bh=MfvP61HoywvA1zoE00ksgoT1c8LUvRM+2okj9pxfSDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azyk1ERzmA9lUw3OoF+facUr3NxDQjiXyL+4SmMYA727Arm2ePttekpGSxiPPn2UwGNIefz4IH++LNTUG2MGrwrbqXjl6WwYVf1uw5I8yHjbE+X0b/GxusGRDBI3XFFwawO5pnblgPHm5LCG56zND2fu96yhNBOXogWG0EVCwCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2bHYYTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2bHYYTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863D3C4CEE5;
	Tue,  8 Apr 2025 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111937;
	bh=MfvP61HoywvA1zoE00ksgoT1c8LUvRM+2okj9pxfSDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2bHYYTitmEFjA1WWrR6KhTFEhqrOaWkjENK7Qq4PXTaSB1QkK1W0hZKzy28Y5p+Z
	 TvUaE4AbDYQlCsaDb0s2nwHOP1GFvjsfqUioajH5QMf9e+9c7TTBEah68QNoVfNDUF
	 5aegRd1CeJeIeJ4bl+OHVgKJf8pfe31qq/ei3YqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 615/731] e1000e: change k1 configuration on MTP and later platforms
Date: Tue,  8 Apr 2025 12:48:32 +0200
Message-ID: <20250408104928.577999544@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

[ Upstream commit efaaf344bc2917cbfa5997633bc18a05d3aed27f ]

Starting from Meteor Lake, the Kumeran interface between the integrated
MAC and the I219 PHY works at a different frequency. This causes sporadic
MDI errors when accessing the PHY, and in rare circumstances could lead
to packet corruption.

To overcome this, introduce minor changes to the Kumeran idle
state (K1) parameters during device initialization. Hardware reset
reverts this configuration, therefore it needs to be applied in a few
places.

Fixes: cc23f4f0b6b9 ("e1000e: Add support for Meteor Lake")
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/defines.h |  3 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 80 +++++++++++++++++++--
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  4 ++
 3 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/defines.h b/drivers/net/ethernet/intel/e1000e/defines.h
index 5e2cfa73f8891..8294a7c4f122c 100644
--- a/drivers/net/ethernet/intel/e1000e/defines.h
+++ b/drivers/net/ethernet/intel/e1000e/defines.h
@@ -803,4 +803,7 @@
 /* SerDes Control */
 #define E1000_GEN_POLL_TIMEOUT          640
 
+#define E1000_FEXTNVM12_PHYPD_CTRL_MASK	0x00C00000
+#define E1000_FEXTNVM12_PHYPD_CTRL_P1	0x00800000
+
 #endif /* _E1000_DEFINES_H_ */
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 2f9655cf5dd9e..364378133526a 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -285,6 +285,45 @@ static void e1000_toggle_lanphypc_pch_lpt(struct e1000_hw *hw)
 	}
 }
 
+/**
+ * e1000_reconfigure_k1_exit_timeout - reconfigure K1 exit timeout to
+ * align to MTP and later platform requirements.
+ * @hw: pointer to the HW structure
+ *
+ * Context: PHY semaphore must be held by caller.
+ * Return: 0 on success, negative on failure
+ */
+static s32 e1000_reconfigure_k1_exit_timeout(struct e1000_hw *hw)
+{
+	u16 phy_timeout;
+	u32 fextnvm12;
+	s32 ret_val;
+
+	if (hw->mac.type < e1000_pch_mtp)
+		return 0;
+
+	/* Change Kumeran K1 power down state from P0s to P1 */
+	fextnvm12 = er32(FEXTNVM12);
+	fextnvm12 &= ~E1000_FEXTNVM12_PHYPD_CTRL_MASK;
+	fextnvm12 |= E1000_FEXTNVM12_PHYPD_CTRL_P1;
+	ew32(FEXTNVM12, fextnvm12);
+
+	/* Wait for the interface the settle */
+	usleep_range(1000, 1100);
+
+	/* Change K1 exit timeout */
+	ret_val = e1e_rphy_locked(hw, I217_PHY_TIMEOUTS_REG,
+				  &phy_timeout);
+	if (ret_val)
+		return ret_val;
+
+	phy_timeout &= ~I217_PHY_TIMEOUTS_K1_EXIT_TO_MASK;
+	phy_timeout |= 0xF00;
+
+	return e1e_wphy_locked(hw, I217_PHY_TIMEOUTS_REG,
+				  phy_timeout);
+}
+
 /**
  *  e1000_init_phy_workarounds_pchlan - PHY initialization workarounds
  *  @hw: pointer to the HW structure
@@ -327,15 +366,22 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	 * LANPHYPC Value bit to force the interconnect to PCIe mode.
 	 */
 	switch (hw->mac.type) {
+	case e1000_pch_mtp:
+	case e1000_pch_lnp:
+	case e1000_pch_ptp:
+	case e1000_pch_nvp:
+		/* At this point the PHY might be inaccessible so don't
+		 * propagate the failure
+		 */
+		if (e1000_reconfigure_k1_exit_timeout(hw))
+			e_dbg("Failed to reconfigure K1 exit timeout\n");
+
+		fallthrough;
 	case e1000_pch_lpt:
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
-	case e1000_pch_mtp:
-	case e1000_pch_lnp:
-	case e1000_pch_ptp:
-	case e1000_pch_nvp:
 		if (e1000_phy_is_accessible_pchlan(hw))
 			break;
 
@@ -419,8 +465,20 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 		 *  the PHY is in.
 		 */
 		ret_val = hw->phy.ops.check_reset_block(hw);
-		if (ret_val)
+		if (ret_val) {
 			e_err("ME blocked access to PHY after reset\n");
+			goto out;
+		}
+
+		if (hw->mac.type >= e1000_pch_mtp) {
+			ret_val = hw->phy.ops.acquire(hw);
+			if (ret_val) {
+				e_err("Failed to reconfigure K1 exit timeout\n");
+				goto out;
+			}
+			ret_val = e1000_reconfigure_k1_exit_timeout(hw);
+			hw->phy.ops.release(hw);
+		}
 	}
 
 out:
@@ -4888,6 +4946,18 @@ static s32 e1000_init_hw_ich8lan(struct e1000_hw *hw)
 	u16 i;
 
 	e1000_initialize_hw_bits_ich8lan(hw);
+	if (hw->mac.type >= e1000_pch_mtp) {
+		ret_val = hw->phy.ops.acquire(hw);
+		if (ret_val)
+			return ret_val;
+
+		ret_val = e1000_reconfigure_k1_exit_timeout(hw);
+		hw->phy.ops.release(hw);
+		if (ret_val) {
+			e_dbg("Error failed to reconfigure K1 exit timeout\n");
+			return ret_val;
+		}
+	}
 
 	/* Initialize identification LED */
 	ret_val = mac->ops.id_led_init(hw);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 2504b11c3169f..5feb589a9b5ff 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -219,6 +219,10 @@
 #define I217_PLL_CLOCK_GATE_REG	PHY_REG(772, 28)
 #define I217_PLL_CLOCK_GATE_MASK	0x07FF
 
+/* PHY Timeouts */
+#define I217_PHY_TIMEOUTS_REG                   PHY_REG(770, 21)
+#define I217_PHY_TIMEOUTS_K1_EXIT_TO_MASK       0x0FC0
+
 #define SW_FLAG_TIMEOUT		1000	/* SW Semaphore flag timeout in ms */
 
 /* Inband Control */
-- 
2.39.5



