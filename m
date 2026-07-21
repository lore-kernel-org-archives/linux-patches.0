Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1E46DFFD;
	Tue, 21 Jul 2026 18:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657906; cv=none; b=mMftDgzVtLq3f2ybzyOBaolhdGqn2VT1hRHjwHe+SfGSvAvMnOP6rd44bUyQmnjmG+ID3+VFa7f2xHVfwhxp8wK0jsJQ7NLZdm1xMVXdddsxB/1XFwV2s1VHy0kJDeRr2RR9GlEnjHHy0z9pwIclLG3McxX7XGcgs/P9KnOWWV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657906; c=relaxed/simple;
	bh=ph2Ulq48RpbyVifHZmkYAWTkVGTehvzZGHB66kVMxmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxfm9mCjdK6kCXtjd3y039gaqWwesOuMFR8ECH9XsdSVK7yrzlVxsOp6iR6bk93DNmLRbCZhGvB0l1q5G6OHSNeY564hErHfBFQSUHbny688yh+vsNK4X3c/mtHhnbt6gZkmVg9BSbJtBFnXe0wHbhTZ+nYK9Yys22FZZYtstJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZLSv6aJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZLSv6aJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABFA1F00A3A;
	Tue, 21 Jul 2026 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657904;
	bh=Q3YjHZVdSlQcbJ9QIwfT4KOL5dERHVnC5gY5+bFaumg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZLSv6aJjlwWMKgTwVbteUuUcFws8lBSfU3HINhVwREeEoZ9ID0aOsg7TPqmrRvx7
	 Sh4fimrnOZzJnVbftVaCbj/OkC/E7YZilFQkOEd14BqXsaymXe/w7jWu+yQzCeqW8B
	 Ujz/SLl4rQ+HtsQcF/3jLKE2d/1SzdAGki6q4NL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0943/1611] net: hns3: unify copper port ksettings configuration path
Date: Tue, 21 Jul 2026 17:17:39 +0200
Message-ID: <20260721152536.597577271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index a5eefa28454c04..483e87eabd139b 100644
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
index 54d0a9ba7879b5..39687e308fe00a 100644
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



