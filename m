Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7968F53E30;
	Tue, 14 May 2024 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686523; cv=none; b=DqJDE6x8Qxx9GfQFz5lhYiTRHBSLOe6Cd26gl1IX8Hw2d/ZKMojLS0oakAL64Q9Mdz9eO+U4//YzEvGBv389TpdqKr/+7LPqHKHa9odtbUdFgzAzZb9GITN+uC90VSToAxtbLm7gFSDBhGKJodE3vanvevdGyiKV+TJMVKGREQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686523; c=relaxed/simple;
	bh=jfmX4PvHyfcCdScPjv1WvqRijtPUIDQbVbF+KvreRYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UILkh7y1voOmmCQNOXLGWlNI4uP1vMn91i9/4r/YdhWcNJ4WOOzXgDJcWslCrGhUqLuSUVZbZHZzgP/emB/MGW79LjnT7m0lgDoBEpYTVaWJAzOvLRVfmW4G4zMMAfdlUQ4U+DTqdE3VwZmlk66f+tzk2Z6nZ9nrq706CFImqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG6SShCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG6SShCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E3DC2BD10;
	Tue, 14 May 2024 11:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686523;
	bh=jfmX4PvHyfcCdScPjv1WvqRijtPUIDQbVbF+KvreRYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kG6SShCjGWk2NGSHXyoa8TtrwWCNrL+sERpmUimLW2tHMC9fdrFJfBoU7TpesSCl4
	 DQUL+gb3I66Vk9jO2gHqTSWeRhjSOUSLq12K3Ly5khNo1MjDvv3egG6gKEulCwq5KR
	 hga7Ey+0jFBvOhvuUKCOGJf0aoFtIiSSDTtMIsIE=
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
Subject: [PATCH 6.1 167/236] net: hns3: using user configure after hardware reset
Date: Tue, 14 May 2024 12:18:49 +0200
Message-ID: <20240514101026.697879808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9db363fbc34fd..a0ac1748f4ea4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1624,6 +1624,9 @@ static int hclge_configure(struct hclge_dev *hdev)
 			cfg.default_speed, ret);
 		return ret;
 	}
+	hdev->hw.mac.req_speed = hdev->hw.mac.speed;
+	hdev->hw.mac.req_autoneg = AUTONEG_ENABLE;
+	hdev->hw.mac.req_duplex = DUPLEX_FULL;
 
 	hclge_parse_link_mode(hdev, cfg.speed_ability);
 
@@ -3429,9 +3432,9 @@ hclge_set_phy_link_ksettings(struct hnae3_handle *handle,
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
@@ -3464,9 +3467,9 @@ static int hclge_tp_port_init(struct hclge_dev *hdev)
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
index f6fef790e16c1..5207cb132c33c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -256,11 +256,14 @@ struct hclge_mac {
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



