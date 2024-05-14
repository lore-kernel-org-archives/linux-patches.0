Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903C513CA9B;
	Tue, 14 May 2024 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683485; cv=none; b=A7E4ztpVXdF5+vTGBR/3ul+VcS1a0MdqJZfOtYxPqVFaYwOmOkY0x/7WIqkLSyFQ4qarWfyoi/V3SBoTKGfag4udR2z76RYxCePkOSTynszQkcOPxcaEfUswTdb8p915xXTbaml4lFsG0ep6BF/NpbL/YUx+kqhMsNQ1AKLDVlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683485; c=relaxed/simple;
	bh=8naFb+4gGYHrphjNJNuYwwczOHvvuvVzfe2YNUc5WOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGK53qSm5ShO2IwP6XuWqEIDojQnXdB0FYkYUDEbdpUYMw1SLG36JL5hK+YtnNPenyyjMaHK40HhpU+ikreW3Q0B6dInXmXSOe3AQktZnGlPcTBm8xgVqdqPZDVs7+JSThbDadqiyMl+l5D0QWZAcBnSOv9oxs+KL2Qxei3IV3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQlHkf8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQlHkf8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4553C32782;
	Tue, 14 May 2024 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683485;
	bh=8naFb+4gGYHrphjNJNuYwwczOHvvuvVzfe2YNUc5WOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQlHkf8yTRlGJK1qtl924+Nup42XRi3dyrZh9mlEVq3PiK1HzuZ/bK6pqUNkEwT1h
	 iertGCLATNQ7HuliJCVzRnko5kPpWusJkWiYhTGmcbRS756TIZy+b7PEk1A2znmFF4
	 sJqo0s+txDpD0/z9QXcgjv4rsj1I8AGCyhESy2K8=
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
Subject: [PATCH 6.8 226/336] net: hns3: using user configure after hardware reset
Date: Tue, 14 May 2024 12:17:10 +0200
Message-ID: <20240514101047.148767999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index a3b7723a97bb1..895e07f5c4fc8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1524,6 +1524,9 @@ static int hclge_configure(struct hclge_dev *hdev)
 			cfg.default_speed, ret);
 		return ret;
 	}
+	hdev->hw.mac.req_speed = hdev->hw.mac.speed;
+	hdev->hw.mac.req_autoneg = AUTONEG_ENABLE;
+	hdev->hw.mac.req_duplex = DUPLEX_FULL;
 
 	hclge_parse_link_mode(hdev, cfg.speed_ability);
 
@@ -3329,9 +3332,9 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
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
@@ -3364,9 +3367,9 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
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
index 51979cf712623..0f06e94d6c180 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -270,11 +270,14 @@ struct hclge_mac {
 	u8 media_type;	/* port media type, e.g. fibre/copper/backplane */
 	u8 mac_addr[ETH_ALEN];
 	u8 autoneg;
+	u8 req_autoneg;
 	u8 duplex;
+	u8 req_duplex;
 	u8 support_autoneg;
 	u8 speed_type;	/* 0: sfp speed, 1: active speed */
 	u8 lane_num;
 	u32 speed;
+	u32 req_speed;
 	u32 max_speed;
 	u32 speed_ability; /* speed ability supported by current media */
 	u32 module_type; /* sub media type, e.g. kr/cr/sr/lr */
-- 
2.43.0



