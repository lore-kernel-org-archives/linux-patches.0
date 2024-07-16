Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA619F487;
	Tue, 16 Jul 2024 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146028; cv=none; b=f1F8jr+gMCvwqsG24AI7DtWPDIqSdlxKiVKE30d/QBg7euFFQu7Bg/+t2Uyf3HGHXNAUUhHMsRRRbeZUrUZf2aZv8mHpdEcJ0rlOZqMMPhGxMNcpzzstoH9l85GsolJAert9CQp1O4ROcdRs/eXUNT9yhq2leLNlsI2sLtAqPLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146028; c=relaxed/simple;
	bh=Z0uV4eJp1aB2dp5MP+IEpkf5DrkXnPdho+jsA3G6Oqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6jvttikoqICISQCDourre/Fyh2Re11Mzyux4YhKETKF6Ca3PjLI321e0X1qLjhS8hwaMv/G66kaYuudL1tAAlFO3QEgYO1xHyVPGWiuzM34kiChWtIYhTGkn6p2K6eocl7dHizo9gqn0mtT5BCG6x/efOzITTzTSVE4z0Q0CHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMymXNDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMymXNDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41FAC116B1;
	Tue, 16 Jul 2024 16:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146028;
	bh=Z0uV4eJp1aB2dp5MP+IEpkf5DrkXnPdho+jsA3G6Oqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMymXNDWqdUB9+/433wmfHv8TTrk9kEBLLeSbVbqYOl5XhivyNg1+2TtzFMfF1Usm
	 YVYOmxrhwb6XIYUjGBI6x77mtK5zfG7FC7JoXtXWbGalzmMN8GnNZSZt7s9jCLi+rs
	 fCXrUpe8GuoD8SEq5lf5gq8hdo9aRACZYJNx5Sy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/144] e1000e: Fix S0ix residency on corporate systems
Date: Tue, 16 Jul 2024 17:31:43 +0200
Message-ID: <20240716152753.853672416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dima Ruinskiy <dima.ruinskiy@intel.com>

[ Upstream commit c93a6f62cb1bd097aef2e4588648a420d175eee2 ]

On vPro systems, the configuration of the I219-LM to achieve power
gating and S0ix residency is split between the driver and the CSME FW.
It was discovered that in some scenarios, where the network cable is
connected and then disconnected, S0ix residency is not always reached.
This was root-caused to a subset of I219-LM register writes that are not
performed by the CSME FW. Therefore, the driver should perform these
register writes on corporate setups, regardless of the CSME FW state.

This was discovered on Meteor Lake systems; however it is likely to
appear on other platforms as well.

Fixes: cc23f4f0b6b9 ("e1000e: Add support for Meteor Lake")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218589
Signed-off-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240628201754.2744221-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 132 ++++++++++-----------
 1 file changed, 66 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6b7d162af3e5e..c153f44a6ab85 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6374,49 +6374,49 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 		mac_data |= E1000_EXTCNF_CTRL_GATE_PHY_CFG;
 		ew32(EXTCNF_CTRL, mac_data);
 
-		/* Enable the Dynamic Power Gating in the MAC */
-		mac_data = er32(FEXTNVM7);
-		mac_data |= BIT(22);
-		ew32(FEXTNVM7, mac_data);
-
 		/* Disable disconnected cable conditioning for Power Gating */
 		mac_data = er32(DPGFR);
 		mac_data |= BIT(2);
 		ew32(DPGFR, mac_data);
 
-		/* Don't wake from dynamic Power Gating with clock request */
-		mac_data = er32(FEXTNVM12);
-		mac_data |= BIT(12);
-		ew32(FEXTNVM12, mac_data);
-
-		/* Ungate PGCB clock */
-		mac_data = er32(FEXTNVM9);
-		mac_data &= ~BIT(28);
-		ew32(FEXTNVM9, mac_data);
-
-		/* Enable K1 off to enable mPHY Power Gating */
-		mac_data = er32(FEXTNVM6);
-		mac_data |= BIT(31);
-		ew32(FEXTNVM6, mac_data);
-
-		/* Enable mPHY power gating for any link and speed */
-		mac_data = er32(FEXTNVM8);
-		mac_data |= BIT(9);
-		ew32(FEXTNVM8, mac_data);
-
 		/* Enable the Dynamic Clock Gating in the DMA and MAC */
 		mac_data = er32(CTRL_EXT);
 		mac_data |= E1000_CTRL_EXT_DMA_DYN_CLK_EN;
 		ew32(CTRL_EXT, mac_data);
-
-		/* No MAC DPG gating SLP_S0 in modern standby
-		 * Switch the logic of the lanphypc to use PMC counter
-		 */
-		mac_data = er32(FEXTNVM5);
-		mac_data |= BIT(7);
-		ew32(FEXTNVM5, mac_data);
 	}
 
+	/* Enable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data |= BIT(22);
+	ew32(FEXTNVM7, mac_data);
+
+	/* Don't wake from dynamic Power Gating with clock request */
+	mac_data = er32(FEXTNVM12);
+	mac_data |= BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data &= ~BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Enable K1 off to enable mPHY Power Gating */
+	mac_data = er32(FEXTNVM6);
+	mac_data |= BIT(31);
+	ew32(FEXTNVM6, mac_data);
+
+	/* Enable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data |= BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* No MAC DPG gating SLP_S0 in modern standby
+	 * Switch the logic of the lanphypc to use PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data |= BIT(7);
+	ew32(FEXTNVM5, mac_data);
+
 	/* Disable the time synchronization clock */
 	mac_data = er32(FEXTNVM7);
 	mac_data |= BIT(31);
@@ -6508,33 +6508,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	} else {
 		/* Request driver unconfigure the device from S0ix */
 
-		/* Disable the Dynamic Power Gating in the MAC */
-		mac_data = er32(FEXTNVM7);
-		mac_data &= 0xFFBFFFFF;
-		ew32(FEXTNVM7, mac_data);
-
-		/* Disable mPHY power gating for any link and speed */
-		mac_data = er32(FEXTNVM8);
-		mac_data &= ~BIT(9);
-		ew32(FEXTNVM8, mac_data);
-
-		/* Disable K1 off */
-		mac_data = er32(FEXTNVM6);
-		mac_data &= ~BIT(31);
-		ew32(FEXTNVM6, mac_data);
-
-		/* Disable Ungate PGCB clock */
-		mac_data = er32(FEXTNVM9);
-		mac_data |= BIT(28);
-		ew32(FEXTNVM9, mac_data);
-
-		/* Cancel not waking from dynamic
-		 * Power Gating with clock request
-		 */
-		mac_data = er32(FEXTNVM12);
-		mac_data &= ~BIT(12);
-		ew32(FEXTNVM12, mac_data);
-
 		/* Cancel disable disconnected cable conditioning
 		 * for Power Gating
 		 */
@@ -6547,13 +6520,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 		mac_data &= 0xFFF7FFFF;
 		ew32(CTRL_EXT, mac_data);
 
-		/* Revert the lanphypc logic to use the internal Gbe counter
-		 * and not the PMC counter
-		 */
-		mac_data = er32(FEXTNVM5);
-		mac_data &= 0xFFFFFF7F;
-		ew32(FEXTNVM5, mac_data);
-
 		/* Enable the periodic inband message,
 		 * Request PCIe clock in K1 page770_17[10:9] =01b
 		 */
@@ -6591,6 +6557,40 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	mac_data &= ~BIT(31);
 	mac_data |= BIT(0);
 	ew32(FEXTNVM7, mac_data);
+
+	/* Disable the Dynamic Power Gating in the MAC */
+	mac_data = er32(FEXTNVM7);
+	mac_data &= 0xFFBFFFFF;
+	ew32(FEXTNVM7, mac_data);
+
+	/* Disable mPHY power gating for any link and speed */
+	mac_data = er32(FEXTNVM8);
+	mac_data &= ~BIT(9);
+	ew32(FEXTNVM8, mac_data);
+
+	/* Disable K1 off */
+	mac_data = er32(FEXTNVM6);
+	mac_data &= ~BIT(31);
+	ew32(FEXTNVM6, mac_data);
+
+	/* Disable Ungate PGCB clock */
+	mac_data = er32(FEXTNVM9);
+	mac_data |= BIT(28);
+	ew32(FEXTNVM9, mac_data);
+
+	/* Cancel not waking from dynamic
+	 * Power Gating with clock request
+	 */
+	mac_data = er32(FEXTNVM12);
+	mac_data &= ~BIT(12);
+	ew32(FEXTNVM12, mac_data);
+
+	/* Revert the lanphypc logic to use the internal Gbe counter
+	 * and not the PMC counter
+	 */
+	mac_data = er32(FEXTNVM5);
+	mac_data &= 0xFFFFFF7F;
+	ew32(FEXTNVM5, mac_data);
 }
 
 static int e1000e_pm_freeze(struct device *dev)
-- 
2.43.0



