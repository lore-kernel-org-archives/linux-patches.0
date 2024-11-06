Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ED81922DB;
	Wed,  6 Nov 2024 12:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895309; cv=none; b=lUfYqtlxAr5OUwNDuOeeb2MvXyLjsLd6rSY4RlgMQYW9i4uvgNcuzgI7Cqrdsf4h21ExqxQQYeV4AgzsjpC9DQWE9+nJ99t2D6DrEsgDaGtKjIsFWqWYBE0W6H2pyUPPw/N9BzAj71vdUFeAFoiOCG5GeM0J9b0dlQ0eE0gYnSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895309; c=relaxed/simple;
	bh=C57wBlc0Iouga4MYXnlG/LxiWx5ORfZtsM2lQ1wfCNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPx+HjSbvaoM1lIet6a1A+g0PWOxsu+ZaWV2WoyILPyZ1EJJP4RzY6YZbZhcFji4GFvOvb3LcJgbA88eKjzG5wykCpTup8FTaEpcAX5/wgJQjwRgEUhgE20CiZzgXbr9bMvO5l6QN4IuIGe2FWw3xOqe1teeAJCqDmn2f4lF3zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVhreFgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVhreFgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA4CC4CECD;
	Wed,  6 Nov 2024 12:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895308;
	bh=C57wBlc0Iouga4MYXnlG/LxiWx5ORfZtsM2lQ1wfCNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVhreFgzFjln9ed5PtKN8XLyxnn9wMb2w5M9IKVzk/7rcuoX4UqnVkTv7vDBpzFpv
	 UBvch1x4pVplU9V2TPUlsMjS040wKgRcw3zGsLNTu6tRe93RrEXMpkNTpPH8IsA9rj
	 lIPD+LuPVjmHwUDkVNy/jHyGv/2VRxWeiLtJ8A6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	Hayes Wang <hayeswang@realtek.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/350] r8152: Factor out OOB link list waits
Date: Wed,  6 Nov 2024 13:01:05 +0100
Message-ID: <20241106120324.290561735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 45c0de18ff2d ("net: ethernet: lantiq_etop: fix memory disclosure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 73 ++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 9c17332c19fd3..2f9daf077e8a7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3007,11 +3007,23 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
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
@@ -3029,23 +3041,13 @@ static void r8152b_exit_oob(struct r8152 *tp)
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
 
@@ -3087,7 +3089,6 @@ static void r8152b_exit_oob(struct r8152 *tp)
 static void r8152b_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -3099,23 +3100,13 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
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
 
@@ -3388,7 +3379,6 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
@@ -3408,23 +3398,13 @@ static void r8153_first_init(struct r8152 *tp)
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
 
@@ -3449,7 +3429,6 @@ static void r8153_first_init(struct r8152 *tp)
 static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -3458,23 +3437,13 @@ static void r8153_enter_oob(struct r8152 *tp)
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



