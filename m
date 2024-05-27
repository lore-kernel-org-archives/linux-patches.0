Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C7917727;
	Mon, 27 May 2024 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838506; cv=none; b=K9s0JFbRYBWzyyDAG+/nYGR4g7AQ51uQiZK8hiHIBFblr5OpDMmV1WccSBsusNAnxEOp8Li8xocL4KPN5+18QB7TixzBapWhQylsajwbSpFSjSWnJKNmXtdjwFLhz8L+EcLHFB3DbHvCq2Rde2z4YHS/ulCRsy0MAzGpoUNldj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838506; c=relaxed/simple;
	bh=nh+N0xaj9Jrokr70jYXLfpVJHMNIDeh2eWuS1baMuSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWM+QOe/9jI6f6bLrkrGT3FJIJU084KazEmSWfZGF660/+PSF6/e4inKdMOc52hLfWUT5RB+6T074GvCrn/Biw1ZkmJF3bXvEj73n5/PxhGW8COLsXntXTvvuqTpEL0JHpcCIV1XCKPTFxkgMkzy+hv25Ce+kDALZltiJ2SG9TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlZXml6X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlZXml6X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF534C2BBFC;
	Mon, 27 May 2024 19:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838506;
	bh=nh+N0xaj9Jrokr70jYXLfpVJHMNIDeh2eWuS1baMuSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlZXml6XpkUNo7/9+GtpN1CKr3HkDmmsqbmj0hPXnDfX9k9WTcn4E/qSX5DbO/FgP
	 tr1bh0YWqCI0GH6MD/S563/JKUBOupgWAvVefBJ5c08LXp4XF0AX5VgDMHYr8lhXP2
	 42537sZU9CFYhLomrIjbAkzzE2Qiutrs8y6EGt/M=
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
Subject: [PATCH 6.8 419/493] media: cadence: csi2rx: configure DPHY before starting source stream
Date: Mon, 27 May 2024 20:57:01 +0200
Message-ID: <20240527185643.995502720@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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
index 0ea5fa956fe9a..5be75bd4add39 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -235,10 +235,6 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
 	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
 
-	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
-	if (ret)
-		goto err_disable_pclk;
-
 	/* Enable DPHY clk and data lanes. */
 	if (csi2rx->dphy) {
 		reg = CSI2RX_DPHY_CL_EN | CSI2RX_DPHY_CL_RST;
@@ -248,6 +244,13 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
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
@@ -287,14 +290,9 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
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
 
@@ -308,6 +306,10 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
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



