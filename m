Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73306198A3B;
	Thu,  6 Jun 2024 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683407; cv=none; b=pRceY0LkD7HqSGvFPB/DNX7l7JslYT27AUfPW/89Ynd2c9JovGixoQ5GLnvIC4fi66QwR+jd+AS54aWMGDRRVUeYr1+4nV6X3LZTXgpF3lnZEV7KYa0jby/IPHWu4yDs6IMXRsZ8dieMhXwgv7mfxHRzONcGI4N5B2IaMOIBWsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683407; c=relaxed/simple;
	bh=k6aI907yW6D3TEuClFSeoctO121Qr9wKPTeTNRQqi80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Osk4H3XTxL0WqXn7iVbYrGHV5JubdGhWTU/Ng+8mXmXz/JIQkSfuwbKEsdVlPCGMxP2XUv6yMCCo/+wHLjEUWn06AayNDfc+HklfWh/qlONZHVjmxgFjsGrCwCSXYZdkoVSudzVOesRRQ82nDCfl+5BE28peSRwPHiruZfMzESg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mm2BgBnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mm2BgBnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB6C2BD10;
	Thu,  6 Jun 2024 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683407;
	bh=k6aI907yW6D3TEuClFSeoctO121Qr9wKPTeTNRQqi80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mm2BgBnCD9EmHO6mT1qzaQS4/Bj3UAK2bAmcaWxobc5iFmHA7fZFyR7Fs+e7pNL1m
	 tISJ24wgrqVh4Y/Fuhf9OjPMq/kSsIcc4MQWnKlkqbhClnCqxQjc1Sq34SevIwS2Mk
	 R0fMrxjyLzW4gb4YsaWeNp1rmTmGTkXB8YFVhQ/w=
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
Subject: [PATCH 6.6 333/744] media: cadence: csi2rx: configure DPHY before starting source stream
Date: Thu,  6 Jun 2024 16:00:05 +0200
Message-ID: <20240606131743.138708380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index f2ce458ebb1df..2d803cf31e9d1 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -164,10 +164,6 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
 	writel(reg, csi2rx->base + CSI2RX_STATIC_CFG_REG);
 
-	ret = v4l2_subdev_call(csi2rx->source_subdev, video, s_stream, true);
-	if (ret)
-		goto err_disable_pclk;
-
 	/* Enable DPHY clk and data lanes. */
 	if (csi2rx->dphy) {
 		reg = CSI2RX_DPHY_CL_EN | CSI2RX_DPHY_CL_RST;
@@ -177,6 +173,13 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
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
@@ -213,14 +216,9 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
 
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
 
@@ -234,6 +232,10 @@ static int csi2rx_start(struct csi2rx_priv *csi2rx)
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



