Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E0F9D4;
	Tue, 14 May 2024 11:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687913; cv=none; b=Pz64OtGDi3mw3IgCYIWeG5zoK/Ev75WybKUFVJ/mumzE6si0LwsT+5wBt/r4wzBGVSGi/eJKQZt3Kqrx0HY1Co6x2z+GB06XuOHWcMhfdvem6X7QzgAqCZHle4oJpqMr38vAqarUAW0FaYBSk7T1DFFgAV3nBakY8doyxMAooqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687913; c=relaxed/simple;
	bh=fRxdtUG4HpxCMSxIJ36XgbK8vGypXmu1oOYrERiq4Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUZYxmh5dI0DHi1jEm0hHWZGA5XVdAuPtaayAd0OUAkU+DLcEii9xAeK5Lji/sgVEnVDvnyu47cenIsm7CIEwcU4eRh6A8ROm7cRkjCPBoTmRTcuyoB9P0EJTDe2PuJsmpJqvxwxnuRD7BlBvlNrTaWHheRQ9yQyJhsweZ1sP5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxODZJus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxODZJus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE45C2BD10;
	Tue, 14 May 2024 11:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687913;
	bh=fRxdtUG4HpxCMSxIJ36XgbK8vGypXmu1oOYrERiq4Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxODZJusi3fasN3VIRwW/xMWkRX9ORRGbRR56U+6rUmelJIh1M9vknmF2ccePc9hV
	 Vq41F2JZL28REEXeSrOuhdPub8aq8pduKnLlFYugmTcdZciWTEW64d/A8RegK4koNe
	 G0Ea2ObM+ugu6Kw2PpirwSQH5frD5vRTzb7uvfOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/168] net: hns3: using user configure after hardware reset
Date: Tue, 14 May 2024 12:20:15 +0200
Message-ID: <20240514101011.101005927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 05eb60e9648cca0beeebdbcd263b599fb58aee48 ]

When a reset occurring, it's supposed to recover user's configuration.
Currently, the port info(speed, duplex and autoneg) is stored in hclge_mac
and will be scheduled updated. Consider the case that reset was happened
consecutively. During the first reset, the port info is configured with
a temporary value cause the PHY is reset and looking for best link config.
Second reset start and use pervious configuration which is not the user's.
The specific process is as follows:

+------+               +----+                +----+
| USER |               | PF |                | HW |
+---+--+               +-+--+                +-+--+
    |  ethtool --reset   |                     |
    +------------------->|    reset command    |
    |  ethtool --reset   +-------------------->|
    +------------------->|                     +---+
    |                    +---+                 |   |
    |                    |   |reset currently  |   | HW RESET
    |                    |   |and wait to do   |   |
    |                    |<--+                 |   |
    |                    | send pervious cfg   |<--+
    |                    | (1000M FULL AN_ON)  |
    |                    +-------------------->|
    |                    | read cfg(time task) |
    |                    | (10M HALF AN_OFF)   +---+
    |                    |<--------------------+   | cfg take effect
    |                    |    reset command    |<--+
    |                    +-------------------->|
    |                    |                     +---+
    |                    | send pervious cfg   |   | HW RESET
    |                    | (10M HALF AN_OFF)   |<--+
    |                    +-------------------->|
    |                    | read cfg(time task) |
    |                    |  (10M HALF AN_OFF)  +---+
    |                    |<--------------------+   | cfg take effect
    |                    |                     |   |
    |                    | read cfg(time task) |<--+
    |                    |  (10M HALF AN_OFF)  |
    |                    |<--------------------+
    |                    |                     |
    v                    v                     v

To avoid aboved situation, this patch introduced req_speed, req_duplex,
req_autoneg to store user's configuration and it only be used after
hardware reset and to recover user's configuration

Fixes: f5f2b3e4dcc0 ("net: hns3: add support for imp-controlled PHYs")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h   |  3 +++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3423b8e278e3a..71b498aa327bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1572,6 +1572,9 @@ static int hclge_configure(struct hclge_dev *hdev)
 			cfg.default_speed, ret);
 		return ret;
 	}
+	hdev->hw.mac.req_speed = hdev->hw.mac.speed;
+	hdev->hw.mac.req_autoneg = AUTONEG_ENABLE;
+	hdev->hw.mac.req_duplex = DUPLEX_FULL;
 
 	hclge_parse_link_mode(hdev, cfg.speed_ability);
 
@@ -3163,9 +3166,9 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
 		return ret;
 	}
 
-	hdev->hw.mac.autoneg = cmd->base.autoneg;
-	hdev->hw.mac.speed = cmd->base.speed;
-	hdev->hw.mac.duplex = cmd->base.duplex;
+	hdev->hw.mac.req_autoneg = cmd->base.autoneg;
+	hdev->hw.mac.req_speed = cmd->base.speed;
+	hdev->hw.mac.req_duplex = cmd->base.duplex;
 	linkmode_copy(hdev->hw.mac.advertising, cmd->link_modes.advertising);
 
 	return 0;
@@ -3198,9 +3201,9 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
 	if (!hnae3_dev_phy_imp_supported(hdev))
 		return 0;
 
-	cmd.base.autoneg = hdev->hw.mac.autoneg;
-	cmd.base.speed = hdev->hw.mac.speed;
-	cmd.base.duplex = hdev->hw.mac.duplex;
+	cmd.base.autoneg = hdev->hw.mac.req_autoneg;
+	cmd.base.speed = hdev->hw.mac.req_speed;
+	cmd.base.duplex = hdev->hw.mac.req_duplex;
 	linkmode_copy(cmd.link_modes.advertising, hdev->hw.mac.advertising);
 
 	return hclge_set_phy_link_ksettings(&hdev->vport->nic, &cmd);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index a716027df0ed1..ba0d41091b1da 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -275,10 +275,13 @@ struct hclge_mac {
 	u8 media_type;	/* port media type, e.g. fibre/copper/backplane */
 	u8 mac_addr[ETH_ALEN];
 	u8 autoneg;
+	u8 req_autoneg;
 	u8 duplex;
+	u8 req_duplex;
 	u8 support_autoneg;
 	u8 speed_type;	/* 0: sfp speed, 1: active speed */
 	u32 speed;
+	u32 req_speed;
 	u32 max_speed;
 	u32 speed_ability; /* speed ability supported by current media */
 	u32 module_type; /* sub media type, e.g. kr/cr/sr/lr */
-- 
2.43.0



