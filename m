Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F250D1C07C2;
	Tue, 15 Oct 2024 12:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997065; cv=none; b=J/aCFdJrGbXd/FLDdaFEMRy+UCGACt9j6gOHtWcawZR9VYHdE0aPGlDTItnp6uPGE/ugaBAy0IbPOj4lXIWEoln1wZFqLbn1kHLxDtCSrf47pv20Wrw1sVSeVLEiMxlHUtLza60cyQakqjVNnFPyh9aJw8fmzak0Saq+jDK8qkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997065; c=relaxed/simple;
	bh=Mffuc3OtpdHEuDyqW3U/viqYYpnjCGlW6Ed8pDXcK2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrVhkJuPpmQzJuuZENtiMvUpx1PypDixQFCka2iVqFX8k/oxsi9aQ1s6ocACHhIgNiqq1YQNYeEcB+Fp8IWOKasdBB1xsTmAMJ7JjN66h+y9Bq9THLui1IQ3rhsAYFwGy3Q1ZvwadrGVGW+Q5Y3VR3puHsftOko8crMbBvYgyWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxJ4Bcca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxJ4Bcca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638FDC4CECF;
	Tue, 15 Oct 2024 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997064;
	bh=Mffuc3OtpdHEuDyqW3U/viqYYpnjCGlW6Ed8pDXcK2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxJ4BccaGzexMyoDg7/Yx6vBHnQSxDcD1jPd8/AJuYyi1+/en40DbXV1ujExW6jno
	 aoDoSVvNXYWqIRngjiefwcL2Z6QXeyyNRgsjHZouZDqVref2vJgDPelErNi//+yneK
	 xlEcKNSkvgzGT4ztwd1fC5FQLa9ngVGUM+VREcqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faiz Abbas <faiz_abbas@ti.com>,
	Aswath Govindraju <a-govindraju@ti.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/518] can: m_can: Add support for transceiver as phy
Date: Tue, 15 Oct 2024 14:39:42 +0200
Message-ID: <20241015123920.012137078@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit d836cb5fe045463cdab15ad6f278f7c7c194228f ]

Add support for implementing transceiver node as phy. The max_bitrate
is obtained by getting a phy attribute.

Link: https://lore.kernel.org/r/20210724174001.553047-1-mkl@pengutronix.de
Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: 2c09b50efcad ("can: m_can: m_can_close(): stop clocks after device has been shut down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c          | 11 ++++++++++-
 drivers/net/can/m_can/m_can.h          |  2 ++
 drivers/net/can/m_can/m_can_platform.c | 13 +++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 19a19a7b7deb8..f314d93aca0d9 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -21,6 +21,7 @@
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
@@ -1438,6 +1439,8 @@ static int m_can_close(struct net_device *dev)
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
+	phy_power_off(cdev->transceiver);
+
 	return 0;
 }
 
@@ -1624,10 +1627,14 @@ static int m_can_open(struct net_device *dev)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int err;
 
-	err = m_can_clk_start(cdev);
+	err = phy_power_on(cdev->transceiver);
 	if (err)
 		return err;
 
+	err = m_can_clk_start(cdev);
+	if (err)
+		goto out_phy_power_off;
+
 	/* open the can device */
 	err = open_candev(dev);
 	if (err) {
@@ -1679,6 +1686,8 @@ static int m_can_open(struct net_device *dev)
 	close_candev(dev);
 exit_disable_clks:
 	m_can_clk_stop(cdev);
+out_phy_power_off:
+	phy_power_off(cdev->transceiver);
 	return err;
 }
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index b2699a7c99973..8cad1235afa0b 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -27,6 +27,7 @@
 #include <linux/iopoll.h>
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/phy/phy.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
@@ -80,6 +81,7 @@ struct m_can_classdev {
 	struct workqueue_struct *tx_wq;
 	struct work_struct tx_work;
 	struct sk_buff *tx_skb;
+	struct phy *transceiver;
 
 	struct can_bittiming_const *bit_timing;
 	struct can_bittiming_const *data_timing;
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 161cb9be018c0..dbebb9bba545f 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -6,6 +6,7 @@
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
@@ -60,6 +61,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *addr;
 	void __iomem *mram_addr;
+	struct phy *transceiver;
 	int irq, ret = 0;
 
 	mcan_class = m_can_class_allocate_dev(&pdev->dev);
@@ -99,6 +101,16 @@ static int m_can_plat_probe(struct platform_device *pdev)
 		goto probe_fail;
 	}
 
+	transceiver = devm_phy_optional_get(&pdev->dev, NULL);
+	if (IS_ERR(transceiver)) {
+		ret = PTR_ERR(transceiver);
+		dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
+		goto probe_fail;
+	}
+
+	if (transceiver)
+		mcan_class->can.bitrate_max = transceiver->attrs.max_link_rate;
+
 	priv->base = addr;
 	priv->mram_base = mram_addr;
 
@@ -106,6 +118,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	mcan_class->pm_clock_support = 1;
 	mcan_class->can.clock.freq = clk_get_rate(mcan_class->cclk);
 	mcan_class->dev = &pdev->dev;
+	mcan_class->transceiver = transceiver;
 
 	mcan_class->ops = &m_can_plat_ops;
 
-- 
2.43.0



