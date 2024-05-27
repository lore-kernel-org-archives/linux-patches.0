Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5A17E90E;
	Mon, 27 May 2024 19:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837197; cv=none; b=YUUvCukqviojLfaukE1n0AgbDnHXKLzxp3Xyf5FJVasyor1r/DTQgmhZtZpwtfoMt502bZY5xQkU0UHF5cNIrz7OuTHSA2A0uSqy2V2eHyJsyM/oWHYKn8SaLz0CaM9adXAWsB8xf3iBxmRp9bZ3d6nLak5GSgv4cegHE43TpIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837197; c=relaxed/simple;
	bh=vxtCYhS8MWRh3jpaLRKsKpcOpjXWa2J2UrGa8pzd4P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQIC+NBRQn/b7h5GRHXpvVibEXd6k8xDuHmdy3BFhet1cwxhi0CblHnyN6WJF+QDJ5+7VPnKUJPYGu8dv1FBAJYi7YEmIwxW6O++aC2lwFt9pO1pYCGtCMu0Wb7+zWbz6Lh4hffg/N08XcaO+MHgfOtRE4FDxx0iRkmd5n/ShdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjOWyHvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjOWyHvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA8EC2BBFC;
	Mon, 27 May 2024 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837197;
	bh=vxtCYhS8MWRh3jpaLRKsKpcOpjXWa2J2UrGa8pzd4P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjOWyHvrGmDvGmDoFx1pKNh6rd5mtajNtvgswoyp2S++YQJBxaWmZu9sOHdD/FzrB
	 Yip2JDyBVlO1Kd+cOzrPnEXCBvpaDBXapWZkoYIS8TTgQ/gmu9SFpcF5IFU7mG8xVM
	 fqijkiv7q8V3WiNZms5Dd1QHxFifyNS0eJHZINVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Julien Massot <julien.massot@collabora.com>,
	Changhuang Liang <Changhuang.liang@starfivetech.com>,
	Jai Luthra <j-luthra@ti.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 346/427] media: cadence: csi2rx: configure DPHY before starting source stream
Date: Mon, 27 May 2024 20:56:33 +0200
Message-ID: <20240527185633.214545505@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit fd64dda48f7e3f67ada1e1fe47e784ab350da72e ]

When the source device is operating above 1.5 Gbps per lane, it needs to
send the Skew Calibration Sequence before sending any HS data. If the
DPHY is initialized after the source stream is started, then it might
miss the sequence and not be able to receive data properly. Move the
start of source subdev to the end of the sequence to make sure
everything is ready to receive data before the source starts streaming.

Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Fixes: 3295cf1241d3 ("media: cadence: Add support for external dphy")
Tested-by: Julien Massot <julien.massot@collabora.com>
Tested-by: Changhuang Liang <Changhuang.liang@starfivetech.com>
Reviewed-by: Julien Massot <julien.massot@collabora.com>
Reviewed-by: Changhuang Liang <Changhuang.liang@starfivetech.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/cadence/cdns-csi2rx.c | 26 +++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 2d7b0508cc9af..6f7d27a48eff0 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -239,10 +239,6 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
 	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
 
-	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
-	if (ret)
-		goto err_disable_pclk;
-
 	/* Enable DPHY clk and data lanes. */
 	if (csi2rx->dphy) {
 		reg = CSI2RX_DPHY_CL_EN | CSI2RX_DPHY_CL_RST;
@@ -252,6 +248,13 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 		}
 
 		writel(reg, csi2rx->base + CSI2RX_DPHY_LANE_CTRL_REG);
+
+		ret = csi2rx_configure_ext_dphy(csi2rx);
+		if (ret) {
+			dev_err(csi2rx->dev,
+				"Failed to configure external DPHY: %d\n", ret);
+			goto err_disable_pclk;
+		}
 	}
 
 	/*
@@ -291,14 +294,9 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
 	reset_control_deassert(csi2rx->sys_rst);
 
-	if (csi2rx->dphy) {
-		ret = csi2rx_configure_ext_dphy(csi2rx);
-		if (ret) {
-			dev_err(csi2rx->dev,
-				"Failed to configure external DPHY: %d\n", ret);
-			goto err_disable_sysclk;
-		}
-	}
+	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
+	if (ret)
+		goto err_disable_sysclk;
 
 	clk_disable_unprepare(csi2rx->p_clk);
 
@@ -312,6 +310,10 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 		clk_disable_unprepare(csi2rx->pixel_clk[i - 1]);
 	}
 
+	if (csi2rx->dphy) {
+		writel(0, csi2rx->base + CSI2RX_DPHY_LANE_CTRL_REG);
+		phy_power_off(csi2rx->dphy);
+	}
 err_disable_pclk:
 	clk_disable_unprepare(csi2rx->p_clk);
 
-- 
2.43.0



