Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE412DEA6B;
	Tue, 21 Jul 2026 19:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661289; cv=none; b=MT6kuSp7bjk76PgQttSe9N0F/MhdgWz0CAfsaXgPCLzBju1/LSYOttRScT39xD+bDoFll1E+Efc8ye3uRcfbdNdypVgBjo2nG+epk7ZBaahMCMRPLcOIiQy2EKFb9g53cF7nU+oKQ899oHpCmRyDgeB72AJPCwaeTnL4V+gG4QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661289; c=relaxed/simple;
	bh=r0UvtKdJ319mVnuuQLWPHnGGt1ghSVOl8mLpACO2vls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7by4DWRBqa+2X8ectQwqQhq8+yFSHg6HSXVSce80Ux2TxClSpwtDL6nfD96PyZfij0a5JPrFjqTn6mab+FhyBXerXwgBCH7Rqm7mJ50xmKB0hCAXoVrRMLW2thboC7cQzO5ub+2ycmzFIxYTv8kYsFjOyQoNyFLMtYWWc6EHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rx0D/lq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rx0D/lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880451F000E9;
	Tue, 21 Jul 2026 19:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661288;
	bh=KKNTht1LJYEFf6Gt34ZiDv7F5OH8YajBsgNod5+BqE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rx0D/lqn4FcnxF2MK5sw1AIH37fisNRIVHfFimoynDSwgOmDyf8XtotaFtRpLnEY
	 kivzYzdakZJq+9rGeoYM4Gn98SwP5P+Eb+pfuFi7FYPGW27IBrj9rwbss0TpSmtzuD
	 Sr2ytuk8mNS9HwkKavotlFXN8DcijYYQ0sKhlhRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1303/2077] net: hns3: fix permanent link down deadlock after reset
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152623.552444524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuaisong Yang <yangshuaisong@h-partners.com>

[ Upstream commit c711f6d1cee955e04d1cd1f76cd8abd024b27a72 ]

Fix a critical race condition deadlock where the network interface
remains permanently Link Down after a hardware reset under specific
ethtool sequences.

This issue exclusively manifests in firmware-controlled PHY topologies
where the driver relies on the IMP firmware to arbitrate link parameters.
Standard devices driven by the kernel's native PHY_LIB are unaffected.

The deadlock occurs via the following path:
1. User disables autoneg and forces an unmatched speed, forcing link
   down: `ethtool -s ethx autoneg off speed 10 duplex full`
2. User re-enables autoneg: `ethtool -s ethx autoneg on`. The netdev
   stack passes cmd->base.speed as SPEED_UNKNOWN (0xffffffff).
3. Driver saves req_autoneg=1, but before the interface can link up,
   a hardware reset is triggered.
4. During reset recovery, MAC init reads the un-synchronized runtime
   state mac.autoneg (which is still 0/OFF), misinterprets it as
   forced mode, and pushes the cached SPEED_UNKNOWN into the hardware
   registers, causing the MAC firmware state machine to freeze.
   Meanwhile, PHY init reads req_autoneg=1 and enables PHY autoneg.

Since the MAC is frozen with 0xffffffff and PHY is running autoneg,
they mismatch permanently.

Fix this by:
1. Intercepting SPEED_UNKNOWN/DUPLEX_UNKNOWN in
   hclge_set_phy_link_ksettings() and hclge_cfg_mac_speed_dup_h() to
   prevent it from corrupting the driver's cached valid configuration.
2. Save req_autoneg in hclge_set_autoneg().
3. Aligning the state judgment in hclge_set_autoneg_speed_dup() to use
   req_autoneg instead of the un-synchronized runtime mac.autoneg,
   ensuring both MAC and PHY consistently enter the autoneg branch to
   eliminate configuration discrepancies during reset recovery.

Fixes: 05eb60e9648c ("net: hns3: using user configure after hardware reset")
Signed-off-by: Shuaisong Yang <yangshuaisong@h-partners.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260624141319.271439-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cd1aed19d4a732..b8563ac34ad198 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2658,8 +2658,10 @@ static int hclge_cfg_mac_speed_dup_h(struct hnae3_handle *handle, int speed,
 		return ret;
 
 	hdev->hw.mac.req_lane_num = lane_num;
-	hdev->hw.mac.req_speed = (u32)speed;
-	hdev->hw.mac.req_duplex = duplex;
+	if (speed != SPEED_UNKNOWN)
+		hdev->hw.mac.req_speed = (u32)speed;
+	if (duplex != DUPLEX_UNKNOWN)
+		hdev->hw.mac.req_duplex = duplex;
 
 	return 0;
 }
@@ -2690,6 +2692,7 @@ static int hclge_set_autoneg(struct hnae3_handle *handle, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	int ret;
 
 	if (!hdev->hw.mac.support_autoneg) {
 		if (enable) {
@@ -2701,7 +2704,10 @@ static int hclge_set_autoneg(struct hnae3_handle *handle, bool enable)
 		}
 	}
 
-	return hclge_set_autoneg_en(hdev, enable);
+	ret = hclge_set_autoneg_en(hdev, enable);
+	if (!ret)
+		hdev->hw.mac.req_autoneg = enable;
+	return ret;
 }
 
 static int hclge_get_autoneg(struct hnae3_handle *handle)
@@ -3416,8 +3422,10 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
 		return ret;
 
 	hdev->hw.mac.req_autoneg = cmd->base.autoneg;
-	hdev->hw.mac.req_speed = cmd->base.speed;
-	hdev->hw.mac.req_duplex = cmd->base.duplex;
+	if (cmd->base.speed != SPEED_UNKNOWN)
+		hdev->hw.mac.req_speed = cmd->base.speed;
+	if (cmd->base.duplex != DUPLEX_UNKNOWN)
+		hdev->hw.mac.req_duplex = cmd->base.duplex;
 
 	return 0;
 }
@@ -11741,12 +11749,12 @@ static int hclge_set_autoneg_speed_dup(struct hclge_dev *hdev)
 	int ret;
 
 	if (hdev->hw.mac.support_autoneg) {
-		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
+		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.req_autoneg);
 		if (ret)
 			return ret;
 	}
 
-	if (!hdev->hw.mac.autoneg) {
+	if (!hdev->hw.mac.req_autoneg) {
 		ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.req_speed,
 						 hdev->hw.mac.req_duplex,
 						 hdev->hw.mac.req_lane_num);
-- 
2.53.0



