Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEEB46C4BD;
	Tue, 21 Jul 2026 19:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663085; cv=none; b=KZC6tPZYxWWFvqsqtkcNLalxZJG6SqJq8pGK5yQVjiwTfJBsNLU70hl4eY7s3s44TJC4GkS13AlyVOiLbMZhm/tVI4qzeWFxvLrqnEi9TVFbHV9cR7FMbsVWFT7Jp4fD+YtPIP6FLE2K6H1pUWIsHFegPyWwrP4AQAHQEoN2eDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663085; c=relaxed/simple;
	bh=JRHQNWdF5fA+hnnnMX853H8g2rLMoytjCVj3VwX7Wm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSGjSIStbYZYTiPw/OSJS3zraxjITGtcI/lwfN74s1EhR62jogyx0MjxZsdTXVBl52Ruowd3NP70ugk2FxPhLLPE+pBZFHKwEQHVqpn0XnqeMRWJc8kigNQWWMGEhvjIZ3bcNQp78lpZ+HpolHvFPHVzTJpe2sln12IfVAolXhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMSYQJn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMSYQJn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4C21F00A3A;
	Tue, 21 Jul 2026 19:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663083;
	bh=6uWXXliAKSFIHjOzAXRrzLux4Jg4JDAgCCaxU8pzR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMSYQJn1YhCer4cR0HEM2iBnYvQLoxiMt4F+Ol9gh3coA3S9X/lUnI/+ODMymeutD
	 jHqJ/A1Mq1Khu4FMIdnp8mdAGVWYbpeyaTpZWXo452Sjvo566y5trVJPNtWuBvDMrv
	 Fz+sVKG34iugMYWE2r/1ri0GaQPnQ+vJddjIDkC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0687/1276] net: hns3: refactor MAC autoneg and speed configuration
Date: Tue, 21 Jul 2026 17:18:50 +0200
Message-ID: <20260721152501.468874784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuaisong Yang <yangshuaisong@h-partners.com>

[ Upstream commit c01f6e6bdc1ccd21b2d07d23f50b82437b8cbf88 ]

Extract the MAC autoneg and speed/duplex/lane configuration logic out
of hclge_mac_init() and encapsulate it into a new dedicated helper
function hclge_set_autoneg_speed_dup().

In the init path (hclge_init_ae_dev), this helper is now called after
hclge_update_port_info() so that firmware-reported autoneg values are
already populated before applying the link configuration.

Introduce a separate req_lane_num field in struct hclge_mac to isolate
the user-requested lane count from mac.lane_num, which firmware may
overwrite via hclge_get_sfp_info() with stale values from a prior link
lifecycle (e.g., lane_num=4 from 100G). During probe, req_lane_num is
initialized to 0, which instructs firmware to auto-select the correct
lane count for the current speed, rather than reusing the firmware-
reported mac.lane_num that may be inconsistent with the target speed.
This prevents probe failures from mismatched (speed, lane_num) pairs.

In the reset path (hclge_reset_ae_dev), it runs immediately after
hclge_mac_init(), using the previously cached req_* values to restore
the link without re-querying firmware.

Signed-off-by: Shuaisong Yang <yangshuaisong@h-partners.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260624141319.271439-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c711f6d1cee9 ("net: hns3: fix permanent link down deadlock after reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 55 ++++++++++++++-----
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  1 +
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dd49d169951391..7d69b8fb473804 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1577,6 +1577,11 @@ static int hclge_configure(struct hclge_dev *hdev)
 	hdev->hw.mac.req_autoneg = AUTONEG_ENABLE;
 	hdev->hw.mac.req_duplex = DUPLEX_FULL;
 
+	/* When lane_num is 0, the firmware will automatically
+	 * select the appropriate lane_num based on the speed.
+	 */
+	hdev->hw.mac.req_lane_num = 0;
+
 	hclge_parse_link_mode(hdev, cfg.speed_ability);
 
 	hdev->hw.mac.max_speed = hclge_get_max_speed(cfg.speed_ability);
@@ -2652,6 +2657,7 @@ static int hclge_cfg_mac_speed_dup_h(struct hnae3_handle *handle, int speed,
 	if (ret)
 		return ret;
 
+	hdev->hw.mac.req_lane_num = lane_num;
 	hdev->hw.mac.req_speed = (u32)speed;
 	hdev->hw.mac.req_duplex = duplex;
 
@@ -2957,20 +2963,6 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 	if (!test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
 		hdev->hw.mac.duplex = HCLGE_MAC_FULL;
 
-	if (hdev->hw.mac.support_autoneg) {
-		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
-		if (ret)
-			return ret;
-	}
-
-	if (!hdev->hw.mac.autoneg) {
-		ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.req_speed,
-						 hdev->hw.mac.req_duplex,
-						 hdev->hw.mac.lane_num);
-		if (ret)
-			return ret;
-	}
-
 	mac->link = 0;
 
 	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
@@ -11748,6 +11740,27 @@ static int hclge_set_wol(struct hnae3_handle *handle,
 	return ret;
 }
 
+static int hclge_set_autoneg_speed_dup(struct hclge_dev *hdev)
+{
+	int ret;
+
+	if (hdev->hw.mac.support_autoneg) {
+		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
+		if (ret)
+			return ret;
+	}
+
+	if (!hdev->hw.mac.autoneg) {
+		ret = hclge_cfg_mac_speed_dup_hw(hdev, hdev->hw.mac.req_speed,
+						 hdev->hw.mac.req_duplex,
+						 hdev->hw.mac.req_lane_num);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -11909,6 +11922,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_ptp_uninit;
 
+	ret = hclge_set_autoneg_speed_dup(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to set autoneg speed duplex, ret = %d\n", ret);
+		goto err_ptp_uninit;
+	}
+
 	INIT_KFIFO(hdev->mac_tnl_log);
 
 	hclge_dcb_ops_set(hdev);
@@ -12239,6 +12259,13 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	ret = hclge_set_autoneg_speed_dup(hdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"failed to set autoneg speed duplex, ret = %d\n", ret);
+		return ret;
+	}
+
 	ret = hclge_tp_port_init(hdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to init tp port, ret = %d\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index b9fc719880bb52..af50ad906fcfc1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -287,6 +287,7 @@ struct hclge_mac {
 	u8 support_autoneg;
 	u8 speed_type;	/* 0: sfp speed, 1: active speed */
 	u8 lane_num;
+	u8 req_lane_num;
 	u32 speed;
 	u32 req_speed;
 	u32 max_speed;
-- 
2.53.0



