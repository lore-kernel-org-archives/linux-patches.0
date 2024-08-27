Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA351C4EDC;
	Tue, 27 Aug 2024 15:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772184; cv=none; b=SxK6OqmDM6zm3sadjhJ7Lh+TGM5w2lfHYyBOdmPTNpbC+axDRdjx3DjM+dVhkaFYrPa/fjQdLmM1/nbks8KtZnNIzSg64B8p0R7utQFupTVechdFHYQxPQ2tfxoqmMbMEkOx+YR1emhPidZg9ZvjhyLib3P0XjH80Pa75xFq68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772184; c=relaxed/simple;
	bh=3MavnfKMXVQTzAU+N5qthWzp3qAfCVzu/XpibsGU7mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPyfmEjZFpZUAuAodWXCnyPt/bLxnCSVS1oszi9Pwvp4EtNPlEAciUcLS8dVMNG6h76llpUTKzm9dMJ2NPH4u9bcERoaPD2GKx2lj+yDcGWFP4J90DcXWDQ+0UpUEIbIq19QxQA9Vr3reOyzUIMf+ZEgRpX1Zrb8IkoOtRQ/kWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnloxEHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnloxEHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BC7C6104A;
	Tue, 27 Aug 2024 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772183;
	bh=3MavnfKMXVQTzAU+N5qthWzp3qAfCVzu/XpibsGU7mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnloxEHE4ChPwe8n//sfjSR+KZE6wDP3lcbYdRPJEoYyOgBqR0wwtP3AI5AkOchmT
	 6fo9MER3NAyanUxoeyTjt4XphjOORE4PuuQN1BMGJV6gqXlUdMfEWSyPjn2qBnw1UY
	 yykgzTC8kkd5QPFMyvU9RN2cIVajVkND5fuuHkew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/321] net: hns3: use the users cfg after reset
Date: Tue, 27 Aug 2024 16:36:56 +0200
Message-ID: <20240827143842.357864062@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

[ Upstream commit 30545e17eac1f50c5ef49644daf6af205100a965 ]

Consider the followed case that the user change speed and reset the net
interface. Before the hw change speed successfully, the driver get old
old speed from hw by timer task. After reset, the previous speed is config
to hw. As a result, the new speed is configed successfully but lost after
PF reset. The followed pictured shows more dirrectly.

+------+              +----+                 +----+
| USER |              | PF |                 | HW |
+---+--+              +-+--+                 +-+--+
    |  ethtool -s 100G  |                      |
    +------------------>|   set speed 100G     |
    |                   +--------------------->|
    |                   |  set successfully    |
    |                   |<---------------------+---+
    |                   |query cfg (timer task)|   |
    |                   +--------------------->|   | handle speed
    |                   |     return 200G      |   | changing event
    |  ethtool --reset  |<---------------------+   | (100G)
    +------------------>|  cfg previous speed  |<--+
    |                   |  after reset (200G)  |
    |                   +--------------------->|
    |                   |                      +---+
    |                   |query cfg (timer task)|   |
    |                   +--------------------->|   | handle speed
    |                   |     return 100G      |   | changing event
    |                   |<---------------------+   | (200G)
    |                   |                      |<--+
    |                   |query cfg (timer task)|
    |                   +--------------------->|
    |                   |     return 200G      |
    |                   |<---------------------+
    |                   |                      |
    v                   v                      v

This patch save new speed if hw change speed successfully, which will be
used after reset successfully.

Fixes: 2d03eacc0b7e ("net: hns3: Only update mac configuation when necessary")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 24 ++++++++++++++-----
 .../hisilicon/hns3/hns3pf/hclge_mdio.c        |  3 +++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dfb428550ac03..45bd5c79e4da8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2696,8 +2696,17 @@ static int hclge_cfg_mac_speed_dup_h(struct hnae3_handle *handle, int speed,
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	ret = hclge_cfg_mac_speed_dup(hdev, speed, duplex, lane_num);
 
-	return hclge_cfg_mac_speed_dup(hdev, speed, duplex, lane_num);
+	if (ret)
+		return ret;
+
+	hdev->hw.mac.req_speed = speed;
+	hdev->hw.mac.req_duplex = duplex;
+
+	return 0;
 }
 
 static int hclge_set_autoneg_en(struct hclge_dev *hdev, bool enable)
@@ -2999,17 +3008,20 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	if (!test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
 		hdev->hw.mac.duplex = HCLGE_MAC_FULL;
 
-	ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.speed,
-					 hdev->hw.mac.duplex, hdev->hw.mac.lane_num);
-	if (ret)
-		return ret;
-
 	if (hdev->hw.mac.support_autoneg) {
 		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
 		if (ret)
 			return ret;
 	}
 
+	if (!hdev->hw.mac.autoneg) {
+		ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.req_speed,
+						 hdev->hw.mac.req_duplex,
+						 hdev->hw.mac.lane_num);
+		if (ret)
+			return ret;
+	}
+
 	mac->link = 0;
 
 	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 85fb11de43a12..80079657afebe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -191,6 +191,9 @@ static void hclge_mac_adjust_link(struct net_device *netdev)
 	if (ret)
 		netdev_err(netdev, "failed to adjust link.\n");
 
+	hdev->hw.mac.req_speed = (u32)speed;
+	hdev->hw.mac.req_duplex = (u8)duplex;
+
 	ret = hclge_cfg_flowctrl(hdev);
 	if (ret)
 		netdev_err(netdev, "failed to configure flow control.\n");
-- 
2.43.0



