Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DE42BAF7;
	Wed, 25 Feb 2026 01:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983110; cv=none; b=S1A1SmAG5fmgrlxuyFRw01jNF1LevR3fyLJ6Q+wD55QYOUkrPZTNS45aCLLTktH+ZeawjlQ956YdKN9RKo+GLFSrQ6XciDJJxP7b7B1zckHBSgl0B7qvgebjUY7E9eCg7A88GeIsrGPTGFgwoGryRSU25nSOzf82bU1LgCZlKY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983110; c=relaxed/simple;
	bh=IKV0T7jIg/4caY61v3a561mRbnirGwYCmIsbTDT1W9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOJe3GM5hAiVscpXAFxFFC1n0jrllaJ1Q24VzgRC8nP4/8ol4GnE1qhzOnozGea746jAsSbulvCSwG02yClS+cAfqaV45pOCDO79l2g46DobEXi4BL+FLCr+Y/gPVlE+Ontdg001N0wB+UPQ9DC/9hccR09VA8SgvhRVWWtC+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlDPWxQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlDPWxQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160A7C19424;
	Wed, 25 Feb 2026 01:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983110;
	bh=IKV0T7jIg/4caY61v3a561mRbnirGwYCmIsbTDT1W9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlDPWxQ7xSu1za8LG3mhtyDHEeH5MpIcLnM240v8kfYEf55rvDH7HP5EEfjG23p9x
	 lHUJyGiQewIZLdoRyktQLlc/vKZonsaR9pvLc8Ke0cH/6GM5KiC44sswiDdplsfcWx
	 8VR7JwnTuva+lSHMr+/VP6PPWJXOeu0nsKwjKOCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baihan Li <libaihan@huawei.com>,
	Yongbang Shi <shiyongbang@huawei.com>,
	Tao Tian <tiantao6@hisilicon.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 271/781] drm/hisilicon/hibmc: fix dp probabilistical detect errors after HPD irq
Date: Tue, 24 Feb 2026 17:16:20 -0800
Message-ID: <20260225012406.343268777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baihan Li <libaihan@huawei.com>

[ Upstream commit 3906e7a3b26d683868704fe262db443207f392fe ]

The issue is that drm_connector_helper_detect_from_ddc() returns wrong
status when plugging or unplugging the monitor, which may cause the link
failed err.[0] Use HPD pin status in DP's detect_ctx() for real physical
monitor in/out, and implement a complete DP detection including read DPCD,
check if it's a branch device and its sink count for different situations.

[0]:
	hibme-drm 0000:83:00.0: [drm] *ERROR* channel equalization failed 5 times
	hibme-drm 0000:83:00.0: [drm] *ERROR* channel equalization failed 5 times
	hibme-drm 0000:83:00.0: [drm] *ERROR* dp link training failed, ret: -16
	hibmc-drm 0000:83:00.0: [drm] *ERROR* hibme dp mode set failed: -16

Fixes: 3c7623fb5bb6 ("drm/hisilicon/hibmc: Enable this hot plug detect of irq feature")
Signed-off-by: Baihan Li <libaihan@huawei.com>
Signed-off-by: Yongbang Shi <shiyongbang@huawei.com>
Reviewed-by: Tao Tian <tiantao6@hisilicon.com>
Link: https://patch.msgid.link/20251210023759.3944834-2-shiyongbang@huawei.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h  |  4 ++
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c    | 19 +++++++
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h    |  6 +++
 drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h   |  3 ++
 .../gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c    | 52 +++++++++++++++++--
 5 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
index 4add05c7f161a..f9ee7ebfec55c 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_comm.h
@@ -40,6 +40,10 @@ struct hibmc_dp_dev {
 	struct mutex lock; /* protects concurrent RW in hibmc_dp_reg_write_field() */
 	struct hibmc_dp_link link;
 	u8 dpcd[DP_RECEIVER_CAP_SIZE];
+	u8 downstream_ports[DP_MAX_DOWNSTREAM_PORTS];
+	struct drm_dp_desc desc;
+	bool is_branch;
+	int hpd_status;
 	void __iomem *serdes_base;
 };
 
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
index 8f0daec7d1749..0ec6ace2d0822 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2024 Hisilicon Limited.
 
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include "dp_config.h"
 #include "dp_comm.h"
@@ -305,3 +306,21 @@ void hibmc_dp_set_cbar(struct hibmc_dp *dp, const struct hibmc_dp_cbar_cfg *cfg)
 	hibmc_dp_reg_write_field(dp_dev, HIBMC_DP_COLOR_BAR_CTRL, BIT(0), cfg->enable);
 	writel(HIBMC_DP_SYNC_EN_MASK, dp_dev->base + HIBMC_DP_TIMING_SYNC_CTRL);
 }
+
+bool hibmc_dp_check_hpd_status(struct hibmc_dp *dp, int exp_status)
+{
+	u32 status;
+	int ret;
+
+	ret = readl_poll_timeout(dp->dp_dev->base + HIBMC_DP_HPD_STATUS, status,
+				 FIELD_GET(HIBMC_DP_HPD_CUR_STATE, status) == exp_status,
+				 1000, 100000); /* DP spec says 100ms */
+	if (ret) {
+		drm_dbg_dp(dp->drm_dev, "wait hpd status timeout");
+		return false;
+	}
+
+	dp->dp_dev->hpd_status = exp_status;
+
+	return true;
+}
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
index 665f5b166dfb5..59c1eae153c55 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_hw.h
@@ -14,6 +14,11 @@
 
 struct hibmc_dp_dev;
 
+enum hibmc_hpd_status {
+	HIBMC_HPD_OUT,
+	HIBMC_HPD_IN,
+};
+
 enum hibmc_dp_cbar_pattern {
 	CBAR_COLOR_BAR,
 	CBAR_WHITE,
@@ -60,5 +65,6 @@ void hibmc_dp_reset_link(struct hibmc_dp *dp);
 void hibmc_dp_hpd_cfg(struct hibmc_dp *dp);
 void hibmc_dp_enable_int(struct hibmc_dp *dp);
 void hibmc_dp_disable_int(struct hibmc_dp *dp);
+bool hibmc_dp_check_hpd_status(struct hibmc_dp *dp, int exp_status);
 
 #endif
diff --git a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h
index 394b1e933c3ae..64306abcd9866 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h
+++ b/drivers/gpu/drm/hisilicon/hibmc/dp/dp_reg.h
@@ -24,6 +24,9 @@
 #define HIBMC_DP_CFG_AUX_READY_DATA_BYTE	GENMASK(16, 12)
 #define HIBMC_DP_CFG_AUX			GENMASK(24, 17)
 
+#define HIBMC_DP_HPD_STATUS			0x98
+#define HIBMC_DP_HPD_CUR_STATE		GENMASK(7, 4)
+
 #define HIBMC_DP_PHYIF_CTRL0			0xa0
 #define HIBMC_DP_CFG_SCRAMBLE_EN		BIT(0)
 #define HIBMC_DP_CFG_PAT_SEL			GENMASK(7, 4)
diff --git a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
index d06832e62e966..4a66a107900a1 100644
--- a/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
+++ b/drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_dp.c
@@ -12,6 +12,7 @@
 
 #include "hibmc_drm_drv.h"
 #include "dp/dp_hw.h"
+#include "dp/dp_comm.h"
 
 #define DP_MASKED_SINK_HPD_PLUG_INT	BIT(2)
 
@@ -31,12 +32,53 @@ static int hibmc_dp_connector_get_modes(struct drm_connector *connector)
 	return count;
 }
 
+static bool hibmc_dp_get_dpcd(struct hibmc_dp_dev *dp_dev)
+{
+	int ret;
+
+	ret = drm_dp_read_dpcd_caps(dp_dev->aux, dp_dev->dpcd);
+	if (ret)
+		return false;
+
+	dp_dev->is_branch = drm_dp_is_branch(dp_dev->dpcd);
+
+	ret = drm_dp_read_desc(dp_dev->aux, &dp_dev->desc, dp_dev->is_branch);
+	if (ret)
+		return false;
+
+	ret = drm_dp_read_downstream_info(dp_dev->aux, dp_dev->dpcd, dp_dev->downstream_ports);
+	if (ret)
+		return false;
+
+	return true;
+}
+
 static int hibmc_dp_detect(struct drm_connector *connector,
 			   struct drm_modeset_acquire_ctx *ctx, bool force)
 {
-	mdelay(200);
+	struct hibmc_dp *dp = to_hibmc_dp(connector);
+	struct hibmc_dp_dev *dp_dev = dp->dp_dev;
+	int ret;
+
+	if (dp->irq_status) {
+		if (dp_dev->hpd_status != HIBMC_HPD_IN)
+			return connector_status_disconnected;
+	}
+
+	if (!hibmc_dp_get_dpcd(dp_dev))
+		return connector_status_disconnected;
+
+	if (!dp_dev->is_branch)
+		return connector_status_connected;
+
+	if (drm_dp_read_sink_count_cap(connector, dp_dev->dpcd, &dp_dev->desc) &&
+	    dp_dev->downstream_ports[0] & DP_DS_PORT_HPD) {
+		ret = drm_dp_read_sink_count(dp_dev->aux);
+		if (ret > 0)
+			return connector_status_connected;
+	}
 
-	return drm_connector_helper_detect_from_ddc(connector, ctx, force);
+	return connector_status_disconnected;
 }
 
 static const struct drm_connector_helper_funcs hibmc_dp_conn_helper_funcs = {
@@ -115,7 +157,7 @@ irqreturn_t hibmc_dp_hpd_isr(int irq, void *arg)
 {
 	struct drm_device *dev = (struct drm_device *)arg;
 	struct hibmc_drm_private *priv = to_hibmc_drm_private(dev);
-	int idx;
+	int idx, exp_status;
 
 	if (!drm_dev_enter(dev, &idx))
 		return -ENODEV;
@@ -123,12 +165,14 @@ irqreturn_t hibmc_dp_hpd_isr(int irq, void *arg)
 	if (priv->dp.irq_status & DP_MASKED_SINK_HPD_PLUG_INT) {
 		drm_dbg_dp(&priv->dev, "HPD IN isr occur!\n");
 		hibmc_dp_hpd_cfg(&priv->dp);
+		exp_status = HIBMC_HPD_IN;
 	} else {
 		drm_dbg_dp(&priv->dev, "HPD OUT isr occur!\n");
 		hibmc_dp_reset_link(&priv->dp);
+		exp_status = HIBMC_HPD_OUT;
 	}
 
-	if (dev->registered)
+	if (hibmc_dp_check_hpd_status(&priv->dp, exp_status))
 		drm_connector_helper_hpd_irq_event(&priv->dp.connector);
 
 	drm_dev_exit(idx);
-- 
2.51.0



