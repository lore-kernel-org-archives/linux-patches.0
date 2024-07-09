Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1303F157A48;
	Tue,  9 Jul 2024 11:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523676; cv=none; b=LMPH9F67IDjmNxavFAkiddIo7nUb/tSZnAjTGolNqwbUEZ7P3oDoA8tKtiJEKZaX3vok0UAlz+/M/pJW7dJYpYufvDmJc0fxUQ97d41SwgtSWRYr5psSouCojYM8VQXvF8YKgpK66BxJjHAf9/aCLKS4LIwSp4dUkcBzspA4UG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523676; c=relaxed/simple;
	bh=YhxFF4fE2qkQhzjV81OWQVOrGFnVXx3r50qUA3udT/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYbEPwPt7mIoOHAKydd+pATncmguzMp/G+F1chHbYOo3H1fT9XivDdf6Auz3xJE56f91naxmH5YgFhwD2AvcpH4FC98LcOBtAdz0HH5iYOTwe84PSHX9B10UKI8me4CSsnA8flwRDghSvoTw0XHhTPywvbv7wzSw/g5B5Pz+T4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JV+EmuBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JV+EmuBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8A0C3277B;
	Tue,  9 Jul 2024 11:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523675;
	bh=YhxFF4fE2qkQhzjV81OWQVOrGFnVXx3r50qUA3udT/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JV+EmuBvEizpVikovZxDKk9/bPG0YuuJj8InVad27Z90WkKXfqnBXqnl057Lr6rtg
	 2UeiKx1Deo932OZGQi+5UBRhhcTJ8soMI+MaxFe5OBcumEpoI0/zmcO6Z0fAqYhdY/
	 5OfVKSMGJwWXifU6e1O0wqmkbobicWszh70SPbdQ=
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
Subject: [PATCH 6.6 072/139] e1000e: Fix S0ix residency on corporate systems
Date: Tue,  9 Jul 2024 13:09:32 +0200
Message-ID: <20240709110700.959858492@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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
index 3692fce201959..334f652c60601 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6363,49 +6363,49 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
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
@@ -6498,33 +6498,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
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
@@ -6537,13 +6510,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
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
@@ -6581,6 +6547,40 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
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



