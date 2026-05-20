Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321453F1AD9;
	Wed, 20 May 2026 17:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299155; cv=none; b=BHB3nk+hKR5E5usak5220SBJ7LniamBetAvh3XA3W00uZ7nbJ61a62Vf7MO3k98LnIJtMF8ziGC7tGckNCuNgIrP2/qCvctpsCutOlhyvde1HvlZBhLoOeWIzePAqdXKDRAViyy+WM54snkuqomgzS/+UABv++nrqUeKq4SiSm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299155; c=relaxed/simple;
	bh=3Z3HoFdp638EmGeG4nXnfrq6H13dDiE+wXxh82puoEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XI2eEhg3jAshh8yigu0Y7HDcfJH74csXZP0OnTHIdEl5ZRYiKgl2mpNWHS8++6dty9qGaTJ0/DlitnCZ84wlY5e2IwmiPBlTN+Xq7rAnxPP9t41vulQDHml/bOem1rv8s54vk2js+3X392e8ydPo51m5aH9wDyAwPfzVm/rFbws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfRElpeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfRElpeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6063A1F000E9;
	Wed, 20 May 2026 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299153;
	bh=eDhsWzX1ugULquEz7GGUtN/VtcNg+qZ0DuLsRlK66rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfRElpeo6c0ooGCj+935iDQ+i0A9mms7crrIxBI6PrkPwuFmMLXFBUSicC19cpgtP
	 w6lAo0fuh07v/q/AIyl0RExNibRFYyjiVskWkTnv/4ujTEh193/qkbgCTyvMSvf9m8
	 0Rjn5O3iyykqQrN58ZoIn5NF9f5vxw8eFBt0x35k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Miskell <timothy.miskell@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Petr Oros <poros@redhat.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 683/957] ice: perform PHY soft reset for E825C ports at initialization
Date: Wed, 20 May 2026 18:19:26 +0200
Message-ID: <20260520162149.350968589@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 3ec46e157c7fa420c77dfc23f7030e61f2f3fd55 ]

In some cases the PHY timestamp block of the E825C can become stuck. This
is known to occur if the software writes 0 to the Tx timestamp threshold,
and with older versions of the ice driver the threshold configuration is
buggy and can race in such that hardware briefly operates with a zero
threshold enabled. There are no other known ways to trigger this behavior,
but once it occurs, the hardware is not recovered by normal reset, a driver
reload, or even a warm power cycle of the system. A cold power cycle is
sufficient to recover hardware, but this is extremely invasive and can
result in significant downtime on customer deployments.

The PHY for each port has a timestamping block which has its own reset
functionality accessible by programming the PHY_REG_GLOBAL register.
Writing to the PHY_REG_GLOBAL_SOFT_RESET_BIT triggers the hardware to
perform a complete reset of the timestamping block of the PHY. This
includes clearing the timestamp status for the port, clearing all
outstanding timestamps in the memory bank, and resetting the PHY timer.

The new ice_ptp_phy_soft_reset_eth56g() function toggles the
PHY_REG_GLOBAL soft reset bit with the required delays, ensuring the
PHY is properly reinitialized without requiring a full device reset.
The sequence clears the reset bit, asserts it, then clears it again,
with short waits between transitions to allow hardware stabilization.

Call this function in the new ice_ptp_init_phc_e825c(), implementing the
E825C device specific variant of the ice_ptp_init_phc(). Note that if
ice_ptp_init_phc() fails, PTP functionality may be disabled, but the driver
will still load to allow basic functionality to continue.

This causes the clock owning PF driver to perform a PHY soft reset for
every port during initialization. This ensures the driver begins life in a
known functional state regardless of how it was previously programmed.

This ensures that we properly reconfigure the hardware after a device reset
or when loading the driver, even if it was previously misconfigured with an
out-of-date or modified driver.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Signed-off-by: Timothy Miskell <timothy.miskell@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260420-jk-iwl-net-2026-04-20-ptp-e825c-phy-interrupt-fixes-v1-2-bc2240f42251@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 90 ++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h |  4 +
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 0a20ae0c2901b..1ae795405ac3c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -377,6 +377,31 @@ static void ice_ptp_cfg_sync_delay(const struct ice_hw *hw, u32 delay)
  * The following functions operate on devices with the ETH 56G PHY.
  */
 
+/**
+ * ice_ptp_init_phc_e825c - Perform E825C specific PHC initialization
+ * @hw: pointer to HW struct
+ *
+ * Perform E825C-specific PTP hardware clock initialization steps.
+ *
+ * Return: 0 on success, or a negative error value on failure.
+ */
+static int ice_ptp_init_phc_e825c(struct ice_hw *hw)
+{
+	int err;
+
+	/* Soft reset all ports, to ensure everything is at a clean state */
+	for (int port = 0; port < hw->ptp.num_lports; port++) {
+		err = ice_ptp_phy_soft_reset_eth56g(hw, port);
+		if (err) {
+			ice_debug(hw, ICE_DBG_PTP, "Failed to soft reset port %d, err %d\n",
+				  port, err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * ice_ptp_get_dest_dev_e825 - get destination PHY for given port number
  * @hw: pointer to the HW struct
@@ -2179,6 +2204,69 @@ int ice_ptp_read_tx_hwtstamp_status_eth56g(struct ice_hw *hw, u32 *ts_status)
 	return 0;
 }
 
+/**
+ * ice_ptp_phy_soft_reset_eth56g - Perform a PHY soft reset on ETH56G
+ * @hw: pointer to the HW structure
+ * @port: PHY port number
+ *
+ * Trigger a soft reset of the ETH56G PHY by toggling the soft reset
+ * bit in the PHY global register. The reset sequence consists of:
+ *   1. Clearing the soft reset bit
+ *   2. Asserting the soft reset bit
+ *   3. Clearing the soft reset bit again
+ *
+ * Short delays are inserted between each step to allow the hardware
+ * to settle. This provides a controlled way to reinitialize the PHY
+ * without requiring a full device reset.
+ *
+ * Return: 0 on success, or a negative error code on failure when
+ *         reading or writing the PHY register.
+ */
+int ice_ptp_phy_soft_reset_eth56g(struct ice_hw *hw, u8 port)
+{
+	u32 global_val;
+	int err;
+
+	err = ice_read_ptp_reg_eth56g(hw, port, PHY_REG_GLOBAL, &global_val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to read PHY_REG_GLOBAL for port %d, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	global_val &= ~PHY_REG_GLOBAL_SOFT_RESET_M;
+	ice_debug(hw, ICE_DBG_PTP, "Clearing soft reset bit for port %d, val: 0x%x\n",
+		  port, global_val);
+	err = ice_write_ptp_reg_eth56g(hw, port, PHY_REG_GLOBAL, global_val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write PHY_REG_GLOBAL for port %d, err %d\n",
+			  port, err);
+		return err;
+	}
+
+	usleep_range(5000, 6000);
+
+	global_val |= PHY_REG_GLOBAL_SOFT_RESET_M;
+	ice_debug(hw, ICE_DBG_PTP, "Set soft reset bit for port %d, val: 0x%x\n",
+		  port, global_val);
+	err = ice_write_ptp_reg_eth56g(hw, port, PHY_REG_GLOBAL, global_val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write PHY_REG_GLOBAL for port %d, err %d\n",
+			  port, err);
+		return err;
+	}
+	usleep_range(5000, 6000);
+
+	global_val &= ~PHY_REG_GLOBAL_SOFT_RESET_M;
+	ice_debug(hw, ICE_DBG_PTP, "Clear soft reset bit for port %d, val: 0x%x\n",
+		  port, global_val);
+	err = ice_write_ptp_reg_eth56g(hw, port, PHY_REG_GLOBAL, global_val);
+	if (err)
+		ice_debug(hw, ICE_DBG_PTP, "Failed to write PHY_REG_GLOBAL for port %d, err %d\n",
+			  port, err);
+	return err;
+}
+
 /**
  * ice_get_phy_tx_tstamp_ready_eth56g - Read the Tx memory status register
  * @hw: pointer to the HW struct
@@ -5592,7 +5680,7 @@ int ice_ptp_init_phc(struct ice_hw *hw)
 	case ICE_MAC_GENERIC:
 		return ice_ptp_init_phc_e82x(hw);
 	case ICE_MAC_GENERIC_3K_E825:
-		return 0;
+		return ice_ptp_init_phc_e825c(hw);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
index 5896b346e5790..9d7acc7eb2ceb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.h
@@ -374,6 +374,7 @@ int ice_stop_phy_timer_eth56g(struct ice_hw *hw, u8 port, bool soft_reset);
 int ice_start_phy_timer_eth56g(struct ice_hw *hw, u8 port);
 int ice_phy_cfg_intr_eth56g(struct ice_hw *hw, u8 port, bool ena, u8 threshold);
 int ice_phy_cfg_ptp_1step_eth56g(struct ice_hw *hw, u8 port);
+int ice_ptp_phy_soft_reset_eth56g(struct ice_hw *hw, u8 port);
 
 #define ICE_ETH56G_NOMINAL_INCVAL	0x140000000ULL
 #define ICE_ETH56G_NOMINAL_PCS_REF_TUS	0x100000000ULL
@@ -676,6 +677,9 @@ static inline u64 ice_get_base_incval(struct ice_hw *hw)
 #define ICE_P0_GNSS_PRSNT_N	BIT(4)
 
 /* ETH56G PHY register addresses */
+#define PHY_REG_GLOBAL			0x0
+#define PHY_REG_GLOBAL_SOFT_RESET_M	BIT(11)
+
 /* Timestamp PHY incval registers */
 #define PHY_REG_TIMETUS_L		0x8
 #define PHY_REG_TIMETUS_U		0xC
-- 
2.53.0



