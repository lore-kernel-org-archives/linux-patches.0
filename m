Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2F7143894;
	Sun,  1 Sep 2024 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209055; cv=none; b=TTZkcHmjZ9PAIFNuA0Y+wx8n5scMe7d4urjFUfaFdU9z3Jc7d0+y5Ol1rQ6kbBPOtyCH5k/lBns9hBReR50veUnbiQJhOT3ocRLAOQiTwNS6nFUGemXQZrseC4mp1JY/5H4sp444SmAr6x7YV3HMofgwJSWtOHXw7KlCmQkeDVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209055; c=relaxed/simple;
	bh=Ov+tD+6CgMtwHsC0GpJpf/YDK869fY/So0lOPKIFBBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4O1TYXKuQNQtLmoZ/9GTZ8aCA0NOjWAOoucsUhJK1SpiLhdYuhbkKduXdrTXy6ynMfvUVYNElkcI6p/v0chyoT1j3dhlexnPYYvhSjV3ahXXO41KP4/QF7lRs+g2PPCm5op2yMyJHjs5J9HDZpofgllI42+j/8ztEK4TNiDkwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TE9kHC1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TE9kHC1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD53C4CEC3;
	Sun,  1 Sep 2024 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209055;
	bh=Ov+tD+6CgMtwHsC0GpJpf/YDK869fY/So0lOPKIFBBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TE9kHC1wJ6ySzwDAy77wF3oMDEct8GpJsSjk9hREZrGPTqUVZX4FpoH65a/iKuM9t
	 TlxDdmhxGn4YGdCPLEtg1QcczRfGOfUBDM3urLKVO8UeFr0Xdx4ptKGE2esTsh4uSb
	 Z/8rDxdSJb6KAlsPOaI0TwV7r1Fb242ArCWQWG3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/134] r8152: Factor out OOB link list waits
Date: Sun,  1 Sep 2024 18:17:44 +0200
Message-ID: <20240901160814.521706463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 5f71c84038d39def573744a145c573758f52a949 ]

The same for-loop check for the LINK_LIST_READY bit of an OOB_CTRL
register is used in several places. Factor these out into a single
function to reduce the lines of code.

Change-Id: I20e8f327045a72acc0a83e2d145ae2993ab62915
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Acked-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a699781c79ec ("ethtool: check device is present when getting link settings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 73 ++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 472b02bcfcbf4..92b51c4c46f57 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3372,11 +3372,23 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
 	set_bit(PHY_RESET, &tp->flags);
 }
 
-static void r8152b_exit_oob(struct r8152 *tp)
+static void wait_oob_link_list_ready(struct r8152 *tp)
 {
 	u32 ocp_data;
 	int i;
 
+	for (i = 0; i < 1000; i++) {
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+		if (ocp_data & LINK_LIST_READY)
+			break;
+		usleep_range(1000, 2000);
+	}
+}
+
+static void r8152b_exit_oob(struct r8152 *tp)
+{
+	u32 ocp_data;
+
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
@@ -3394,23 +3406,13 @@ static void r8152b_exit_oob(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	rtl8152_nic_reset(tp);
 
@@ -3452,7 +3454,6 @@ static void r8152b_exit_oob(struct r8152 *tp)
 static void r8152b_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -3464,23 +3465,13 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
 	rtl_disable(tp);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
@@ -3705,7 +3696,6 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
@@ -3725,23 +3715,13 @@ static void r8153_first_init(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
@@ -3766,7 +3746,6 @@ static void r8153_first_init(struct r8152 *tp)
 static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -3775,23 +3754,13 @@ static void r8153_enter_oob(struct r8152 *tp)
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
-- 
2.43.0



