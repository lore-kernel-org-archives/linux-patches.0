Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5522417D67;
	Tue, 21 Jul 2026 19:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661284; cv=none; b=PYzwk5ZEpWUEYTCq7FIXBa/hryfU8QH4vl+1QTSnTx00QLK+8gdo+4bfRPr1cjWC57ZrtW6Kblb6X+kp39tIsxmYlND18sH1GzqHz9NjCXU5e8BeAenHZJt2DRUG0VDRhl14IZ29OSFmdTUptsCNgp6LiHH9aKhyDk1CFM6zkoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661284; c=relaxed/simple;
	bh=25CeE8WBYftnBSa4GYuMayW0C4le9Wo7rZtwREigjWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrPEOn7Ny0af1Kf8lu74QqdguwWUm3CXMTsuLbDgqTQCbwpuZV15KH8RX+hJDAmuQgV69CAaxHm1IitsWwXSCT/j8Bopvkcl+6n5cdNCQyE4kcq+dJBhFNI8zkYZTTa66tQEfj9OUGo4r1B9bMAQjrgOeLNrJKO81gOatE1SQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgx8PVYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgx8PVYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342581F000E9;
	Tue, 21 Jul 2026 19:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661282;
	bh=K+zaZ7IxwEVj0tzzCsSHrnarKbvHDDbwD3rsAA4+M3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgx8PVYfQaaQ5WYTbBtn65Y6GKUAEbSHf49fk/pzFA0K2W7jNHGMld9JD/cmxlgyi
	 aOVI50JRW18iscNfUAggxdoF6qeFMRBIDl8FSuiRpklz0iCB2O6CQzesjCc3zcZ9ht
	 ibgOczBa+ukxSE0mcXMd2Ls4uyfdGlrfSSSutgek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1301/2077] net: hns3: unify copper port ksettings configuration path
Date: Tue, 21 Jul 2026 17:16:14 +0200
Message-ID: <20260721152623.507366428@linuxfoundation.org>
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

[ Upstream commit d77e98f8b2b382b06be7f17e482480dd8c4c5046 ]

Refactor hns3_set_link_ksettings() and hclge_set_phy_link_ksettings()
to unify the configuration path for copper ports.

Previously, netdevs with a native kernel phy attached bypassed the main
MAC parameter caching logic and returned early via
phy_ethtool_ksettings_set(). This prevented the driver from updating
hdev->hw.mac.req_xxx variables for kernel PHY setups, leaving them
out-of-sync during reset recovery.

Clean this up by routing all copper port configurations through
ops->set_phy_link_ksettings(), and perform driver-level or kernel-level
PHY arbitration inside hclge_set_phy_link_ksettings() via
hnae3_dev_phy_imp_supported(). This ensures that the user's intended link
profiles (req_speed, req_duplex, req_autoneg) are uniformly recorded
across all copper and fiber deployment topologies, laying the groundwork
for stable reset recovery.

For copper ports where neither IMP firmware nor a kernel PHY is available
(e.g. PHY_INEXISTENT), hclge_set_phy_link_ksettings() returns -ENODEV.
In hns3_set_link_ksettings(), this is caught so the configuration falls
through to the existing MAC-level path (check_ksettings_param ->
cfg_mac_speed_dup_h), preserving compatibility with PHY-less copper
deployments.

Signed-off-by: Shuaisong Yang <yangshuaisong@h-partners.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260624141319.271439-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c711f6d1cee9 ("net: hns3: fix permanent link down deadlock after reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 31 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 28 +++++++++++++++--
 2 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 9cb7ce9fd311c6..442f15476af32a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -811,12 +811,11 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 }
 
 static int hns3_check_ksettings_param(const struct net_device *netdev,
-				      const struct ethtool_link_ksettings *cmd)
+				      const struct ethtool_link_ksettings *cmd,
+				      u8 media_type)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
-	u8 module_type = HNAE3_MODULE_TYPE_UNKNOWN;
-	u8 media_type = HNAE3_MEDIA_TYPE_UNKNOWN;
 	u32 lane_num;
 	u8 autoneg;
 	u32 speed;
@@ -836,9 +835,6 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 			return 0;
 	}
 
-	if (ops->get_media_type)
-		ops->get_media_type(handle, &media_type, &module_type);
-
 	if (cmd->base.duplex == DUPLEX_HALF &&
 	    media_type != HNAE3_MEDIA_TYPE_COPPER) {
 		netdev_err(netdev,
@@ -863,6 +859,8 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
 	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
+	u8 module_type = HNAE3_MODULE_TYPE_UNKNOWN;
+	u8 media_type = HNAE3_MEDIA_TYPE_UNKNOWN;
 	int ret;
 
 	/* Chip don't support this mode. */
@@ -878,22 +876,23 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 		  cmd->base.autoneg, cmd->base.speed, cmd->base.duplex,
 		  cmd->lanes);
 
-	/* Only support ksettings_set for netdev with phy attached for now */
-	if (netdev->phydev) {
-		if (cmd->base.speed == SPEED_1000 &&
-		    cmd->base.autoneg == AUTONEG_DISABLE)
-			return -EINVAL;
+	if (!ops->get_media_type)
+		return -EOPNOTSUPP;
+	ops->get_media_type(handle, &media_type, &module_type);
 
-		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
-	} else if (test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, ae_dev->caps) &&
-		   ops->set_phy_link_ksettings) {
-		return ops->set_phy_link_ksettings(handle, cmd);
+	if (media_type == HNAE3_MEDIA_TYPE_COPPER) {
+		if (!ops->set_phy_link_ksettings)
+			return -EOPNOTSUPP;
+		ret = ops->set_phy_link_ksettings(handle, cmd);
+		if (ret != -ENODEV)
+			return ret;
+		/* PHY_INEXISTENT, use MAC-level configuration */
 	}
 
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
-	ret = hns3_check_ksettings_param(netdev, cmd);
+	ret = hns3_check_ksettings_param(netdev, cmd, media_type);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dd4045c773d43e..9a31939fec4cc2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3358,8 +3358,8 @@ static int hclge_get_phy_link_ksettings(struct hnae3_handle *handle,
 }
 
 static int
-hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
-			     const struct ethtool_link_ksettings *cmd)
+hclge_ethtool_ksettings_set(struct hnae3_handle *handle,
+			    const struct ethtool_link_ksettings *cmd)
 {
 	struct hclge_desc desc[HCLGE_PHY_LINK_SETTING_BD_NUM];
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -3400,10 +3400,32 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
 		return ret;
 	}
 
+	linkmode_copy(hdev->hw.mac.advertising, cmd->link_modes.advertising);
+	return 0;
+}
+
+static int
+hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
+			     const struct ethtool_link_ksettings *cmd)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int ret = -ENODEV;
+
+	if (hnae3_dev_phy_imp_supported(hdev)) {
+		ret = hclge_ethtool_ksettings_set(handle, cmd);
+	} else if (handle->netdev->phydev) {
+		if (cmd->base.speed == SPEED_1000 &&
+		    cmd->base.autoneg == AUTONEG_DISABLE)
+			return -EINVAL;
+		ret = phy_ethtool_ksettings_set(handle->netdev->phydev, cmd);
+	}
+	if (ret)
+		return ret;
+
 	hdev->hw.mac.req_autoneg = cmd->base.autoneg;
 	hdev->hw.mac.req_speed = cmd->base.speed;
 	hdev->hw.mac.req_duplex = cmd->base.duplex;
-	linkmode_copy(hdev->hw.mac.advertising, cmd->link_modes.advertising);
 
 	return 0;
 }
-- 
2.53.0



