Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E2535502C;
	Tue, 16 Dec 2025 11:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885945; cv=none; b=PCA8Ji5gSQuyz5yuK8VcLyt5GOCwwApsUrUwk6xn4IssJQ25MDMhmjX3HgoKURLM8Lb4VG4FJwWMPQTVmRtcj+6Kv/axTRFJN9Vwqcb8VpRPeG4FVJNYuCMAf/2lo81eRfSUap7Vo8psOQrZLrdQrZi6QGp9w17VHwtOkyoRuto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885945; c=relaxed/simple;
	bh=gGpwBJhD7Ce5KXM9V1ImQN2VKT5y99y8h+9SC/6ecYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4WK8yl+zhCpG5GFMe2SLqHfwxLf8vwbZtk69Yw8QNEqSkrWdLdR2KPB0Htg5yV3pV2pH55HzMoYqho+CD6sGW9JBus7AeWoup1R9RU/pd+cFk5jhY4rg3gnSWzv9j76S+gkqrKwTjEUUUY2rk5u2wWa/t8eAmCBg2yXHCxdCCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6loC7ZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6loC7ZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DB2C4CEF1;
	Tue, 16 Dec 2025 11:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885945;
	bh=gGpwBJhD7Ce5KXM9V1ImQN2VKT5y99y8h+9SC/6ecYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6loC7ZFy1z4sFk1PGueFZ1uLaDKX/FNO4yd8WPf8hvW3PbKsddfuyhtLYCOuq7Ws
	 6aWbDtl8vaUSnmhhPHJVy9ji7xIXzjvQfNwBUZC+DSZeTCFh4S7gYJ+Ke0TYH7ZVNh
	 chQs9AT2jMvHKDj8NOocuw4eWdVRS2b6+wWf2GFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 292/507] phy: freescale: Initialize priv->lock
Date: Tue, 16 Dec 2025 12:12:13 +0100
Message-ID: <20251216111356.054714327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 95e5905698983df94069e185f9eb3c67c7cf75d5 ]

Initialize priv->lock to fix the following warning.

WARNING: CPU: 0 PID: 12 at kernel/locking/mutex.c:577 __mutex_lock+0x70c/0x8b8
 Modules linked in:
 Hardware name: Freescale i.MX8QM MEK (DT)
 Call trace:
  __mutex_lock+0x70c/0x8b8 (P)
  mutex_lock_nested+0x24/0x30
  imx_hsio_power_on+0x4c/0x764
  phy_power_on+0x7c/0x12c
  imx_pcie_host_init+0x1d0/0x4d4
  dw_pcie_host_init+0x188/0x4b0
  imx_pcie_probe+0x324/0x6f4
  platform_probe+0x5c/0x98
  really_probe+0xbc/0x29c
  __driver_probe_device+0x78/0x12c
  driver_probe_device+0xd8/0x160
  __device_attach_driver+0xb8/0x138
  bus_for_each_drv+0x84/0xe4
  __device_attach_async_helper+0xb8/0xdc
  async_run_entry_fn+0x34/0xe0
  process_one_work+0x220/0x694
  worker_thread+0x1c0/0x36c
  kthread+0x14c/0x224

Fixes: 82c56b6dd24f ("phy: freescale: imx8qm-hsio: Add i.MX8QM HSIO PHY driver support")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20250925013806.569658-1-xiaolei.wang@windriver.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8qm-hsio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
index 5dca93cd325c8..977d21d753a59 100644
--- a/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
+++ b/drivers/phy/freescale/phy-fsl-imx8qm-hsio.c
@@ -533,7 +533,7 @@ static struct phy *imx_hsio_xlate(struct device *dev,
 
 static int imx_hsio_probe(struct platform_device *pdev)
 {
-	int i;
+	int i, ret;
 	void __iomem *off;
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
@@ -545,6 +545,9 @@ static int imx_hsio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	priv->dev = &pdev->dev;
 	priv->drvdata = of_device_get_match_data(dev);
+	ret = devm_mutex_init(dev, &priv->lock);
+	if (ret)
+		return ret;
 
 	/* Get HSIO configuration mode */
 	if (of_property_read_string(np, "fsl,hsio-cfg", &priv->hsio_cfg))
-- 
2.51.0



