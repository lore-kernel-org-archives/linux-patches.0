Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7783A16B6;
	Wed, 20 May 2026 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296531; cv=none; b=JDr4CBH+C2sbjTXOttY1X0B8e+iTtG7h38rjouIfhX4YdFI9V+7UVf9c1aSx7+mgiHFqic/ZFat5/oKPX253BtfcOxLdZgMUrk0g5G8/yUFVqdlMkAfoE9DDldDEZoCr4+GKzvCSH8A5z81pf2CweKV8vGikYUvGMpEKdnZTXEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296531; c=relaxed/simple;
	bh=StNza34w/IsAJydUYgSd7IIhdusAvUXe7sgAxPIw62M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3Zop/Dt8CdZPiykX5IiqNP8iDU7U7kHYYNPUSkh1bEQeGuX0w/RpKlBZndzHCKCYDVA59z1kRvYVXpvMDaMc6kqCbvc2Jq3rk5ohtI+RBu1sNbN4rRSaCtAQz/Ct0LX31XWLis3f2aOmWVLkOFQLv0q/CnK4miw61E1fayGih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJyPxbv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJyPxbv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AE1F000E9;
	Wed, 20 May 2026 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296529;
	bh=leiHUKrhHuj3EAEmJloRthN08A5+v/ECWhTWUeRVI68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJyPxbv5Nb16uRte/wuprNN7YuXHv/0tG1dFyzvia0OgT9J9fNQW+gZ1HGXvRDuXa
	 UAAwDUcz8OscrOckD84dsabHCKXIBQakHno4K6oI/hE/CK47iSUCTWMW1hMPPZ0Wbu
	 0BNvHbDLKi0UEj6H0MBvbprZYWf3pv7v7T2rMVmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Petr Oros <poros@redhat.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0835/1146] ice: fix timestamp interrupt configuration for E825C
Date: Wed, 20 May 2026 18:18:05 +0200
Message-ID: <20260520162207.125894040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit c0a575a801a2040eb1e0db54b488f8c548c8458a ]

The E825C ice_phy_cfg_intr_eth56g() function is responsible for programming
the PHY interrupt for a given port. This function writes to the
PHY_REG_TS_INT_CONFIG register of the port. The register is responsible for
configuring whether the port interrupt logic is enabled, as well as
programming the threshold of waiting timestamps that will trigger an
interrupt from this port.

This threshold value must not be programmed to zero while the interrupt is
enabled. Doing so puts the port in a misconfigured state where the PHY
timestamp interrupt for the quad of connected ports will become stuck.

This occurs, because a threshold of zero results in the timestamp interrupt
status for the port becoming stuck high. The four ports in the connected
quad have their timestamp status indicators muxed together. A new interrupt
cannot be generated until the timestamp status indicators return low for
all four ports.

Normally, the timestamp status for a port will clear once there are fewer
timestamps in that ports timestamp memory bank than the threshold. A
threshold of zero makes this impossible, so the timestamp status for the
port does not clear.

The ice driver never intentionally programs the threshold to zero, indeed
the driver always programs it to a value of 1, intending to get an
interrupt immediately as soon as even a single packet is waiting for a
timestamp.

However, there is a subtle flaw in the programming logic in the
ice_phy_cfg_intr_eth56g() function. Due to the way that the hardware
handles enabling the PHY interrupt. If the threshold value is modified at
the same time as the interrupt is enabled, the HW PHY state machine might
enable the interrupt before the new threshold value is actually updated.
This leaves a potential race condition caused by the hardware logic where
a PHY timestamp interrupt might be triggered before the non-zero threshold
is written, resulting in the PHY timestamp logic becoming stuck.

Once the PHY timestamp status is stuck high, it will remain stuck even
after attempting to reprogram the PHY block by changing its threshold or
disabling the interrupt. Even a typical PF or CORE reset will not reset the
particular block of the PHY that becomes stuck. Even a warm power cycle is
not guaranteed to cause the PHY block to reset, and a cold power cycle is
required.

Prevent this by always writing the PHY_REG_TS_INT_CONFIG in two stages.
First write the threshold value with the interrupt disabled, and only write
the enable bit after the threshold has been programmed. When disabling the
interrupt, leave the threshold unchanged. Additionally, re-read the
register after writing it to guarantee that the write to the PHY has been
flushed upon exit of the function.

While we're modifying this function implementation, explicitly reject
programming a threshold of 0 when enabling the interrupt. No caller does
this today, but the consequences of doing so are significant. An explicit
rejection in the code makes this clear.

Fixes: 7cab44f1c35f ("ice: Introduce ETH56G PHY model for E825C products")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Petr Oros <poros@redhat.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260420-jk-iwl-net-2026-04-20-ptp-e825c-phy-interrupt-fixes-v1-1-bc2240f42251@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 36 ++++++++++++++++++---
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 5a5c511ccbb6e..7f2f7440e705c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -1847,6 +1847,8 @@ static int ice_phy_cfg_mac_eth56g(struct ice_hw *hw, u8 port)
  * @ena: enable or disable interrupt
  * @threshold: interrupt threshold
  *
+ * The threshold cannot be 0 while the interrupt is enabled.
+ *
  * Configure TX timestamp interrupt for the specified port
  *
  * Return:
@@ -1858,19 +1860,45 @@ int ice_phy_cfg_intr_eth56g(struct ice_hw *hw, u8 port, bool ena, u8 threshold)
 	int err;
 	u32 val;
 
+	if (ena && !threshold)
+		return -EINVAL;
+
 	err = ice_read_ptp_reg_eth56g(hw, port, PHY_REG_TS_INT_CONFIG, &val);
 	if (err)
 		return err;
 
+	val &= ~PHY_TS_INT_CONFIG_ENA_M;
 	if (ena) {
-		val |= PHY_TS_INT_CONFIG_ENA_M;
 		val &= ~PHY_TS_INT_CONFIG_THRESHOLD_M;
 		val |= FIELD_PREP(PHY_TS_INT_CONFIG_THRESHOLD_M, threshold);
-	} else {
-		val &= ~PHY_TS_INT_CONFIG_ENA_M;
+		err = ice_write_ptp_reg_eth56g(hw, port, PHY_REG_TS_INT_CONFIG,
+					       val);
+		if (err) {
+			ice_debug(hw, ICE_DBG_PTP,
+				  "Failed to update 'threshold' PHY_REG_TS_INT_CONFIG port=%u ena=%u threshold=%u\n",
+				  port, !!ena, threshold);
+			return err;
+		}
+		val |= PHY_TS_INT_CONFIG_ENA_M;
 	}
 
-	return ice_write_ptp_reg_eth56g(hw, port, PHY_REG_TS_INT_CONFIG, val);
+	err = ice_write_ptp_reg_eth56g(hw, port, PHY_REG_TS_INT_CONFIG, val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP,
+			  "Failed to update 'ena' PHY_REG_TS_INT_CONFIG port=%u ena=%u threshold=%u\n",
+			  port, !!ena, threshold);
+		return err;
+	}
+
+	err = ice_read_ptp_reg_eth56g(hw, port, PHY_REG_TS_INT_CONFIG, &val);
+	if (err) {
+		ice_debug(hw, ICE_DBG_PTP,
+			  "Failed to read PHY_REG_TS_INT_CONFIG port=%u ena=%u threshold=%u\n",
+			  port, !!ena, threshold);
+		return err;
+	}
+
+	return 0;
 }
 
 /**
-- 
2.53.0



