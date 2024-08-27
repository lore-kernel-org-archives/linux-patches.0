Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D626B1C7B97;
	Tue, 27 Aug 2024 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769944; cv=none; b=YScZY9ds4OlHSmnuc+prxdgiI0p5kUk43CR1Pqa0ZzkZIa9fXZXWYmOhilaRAx0tAjs3x/btNLW8dKj68XJva8jw28F5S03MK+WSWb5n8DAECyJ0HmCND3UVALfgaaTYjn7JIrkdFEuXyVqbCNxBRNCYJjeLdtrrLM98l1WL1K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769944; c=relaxed/simple;
	bh=L9ZFRmJnr4rRZ27mcFVCGDazX8SDAZaPE69W3dapNUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnwNEhsoS+mSNtHvUbXOtfHdUEQVXFDpbPjkC5X+YWeUwjw+BUzltqXoNusPSMGD2zmLh8jucsPTPn0q7paDXRh/5qBOJHOTeRP6gnNvQueDhp6n22zvj77qMP0cFibgVAjPPjX9xvZdJs54Xh051/cTE9ZHa3EeZAjvAoBttTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGV041ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGV041ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4C6C61063;
	Tue, 27 Aug 2024 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769944;
	bh=L9ZFRmJnr4rRZ27mcFVCGDazX8SDAZaPE69W3dapNUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGV041ek64XryS6VopJEqE83CYwhjkNe5Tmne1Ur80Ec8BSYPr7W9ts94101Zig4P
	 fuLPQG33TInqkz2yxeACNOZ4cTDeuHbV6vdeBWWr2dAA4LJ/BbxMbhYDYvHM7hfWgy
	 3PIRiC4Kk7/jDYXbKJ5UlBFT1bAlnqofOQnuEBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/341] net: hns3: use the users cfg after reset
Date: Tue, 27 Aug 2024 16:35:10 +0200
Message-ID: <20240827143846.417547086@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index ad8e56234b284..92c592c177e67 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2598,8 +2598,17 @@ static int hclge_cfg_mac_speed_dup_h(struct hnae3_handle *handle, int speed,
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
@@ -2901,17 +2910,20 @@ static int hclge_mac_init(struct hclge_dev *hdev)
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



