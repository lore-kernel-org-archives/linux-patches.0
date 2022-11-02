Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2FB7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA08C433D6;
	Wed,  2 Nov 2022 02:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357129;
	bh=N0maZI+dlNd0MKUr3JXI89eW/ayQTLXKm5YHHXG6Uxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSQEmRZ2prQtSlyMim7M9Wy0sgiyNVdhmm37ZipB3es6omGr3jRZhr9B+4AWJH4lY
	 zzLf59+48w8dOIXVy83RsyGm5/yxo10gHkq02upzh5o4AvUq9dBgdFvXkANfccuTCs
	 kQeXLXh+JJZ1OjuSErWeUXDl2qyFFWe2x7cZGuQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/240] media: sunxi: Fix some error handling path of sun6i_mipi_csi2_probe()
Date: Wed,  2 Nov 2022 03:31:32 +0100
Message-Id: <20221102022114.032962527@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 51e1440d309a74a3e4e252019a00f9d0df329945 ]

Release some resources in the error handling path of the probe and of
sun6i_mipi_csi2_resources_setup(), as already done in the remove
function.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c   | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
index a4e3f9a6b2ff..30d6c0c5161f 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
@@ -661,7 +661,8 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	csi2_dev->reset = devm_reset_control_get_shared(dev, NULL);
 	if (IS_ERR(csi2_dev->reset)) {
 		dev_err(dev, "failed to get reset controller\n");
-		return PTR_ERR(csi2_dev->reset);
+		ret = PTR_ERR(csi2_dev->reset);
+		goto error_clock_rate_exclusive;
 	}
 
 	/* D-PHY */
@@ -669,13 +670,14 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	csi2_dev->dphy = devm_phy_get(dev, "dphy");
 	if (IS_ERR(csi2_dev->dphy)) {
 		dev_err(dev, "failed to get MIPI D-PHY\n");
-		return PTR_ERR(csi2_dev->dphy);
+		ret = PTR_ERR(csi2_dev->dphy);
+		goto error_clock_rate_exclusive;
 	}
 
 	ret = phy_init(csi2_dev->dphy);
 	if (ret) {
 		dev_err(dev, "failed to initialize MIPI D-PHY\n");
-		return ret;
+		goto error_clock_rate_exclusive;
 	}
 
 	/* Runtime PM */
@@ -683,6 +685,11 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	pm_runtime_enable(dev);
 
 	return 0;
+
+error_clock_rate_exclusive:
+	clk_rate_exclusive_put(csi2_dev->clock_mod);
+
+	return ret;
 }
 
 static void
@@ -712,9 +719,14 @@ static int sun6i_mipi_csi2_probe(struct platform_device *platform_dev)
 
 	ret = sun6i_mipi_csi2_bridge_setup(csi2_dev);
 	if (ret)
-		return ret;
+		goto error_resources;
 
 	return 0;
+
+error_resources:
+	sun6i_mipi_csi2_resources_cleanup(csi2_dev);
+
+	return ret;
 }
 
 static int sun6i_mipi_csi2_remove(struct platform_device *platform_dev)
-- 
2.35.1



