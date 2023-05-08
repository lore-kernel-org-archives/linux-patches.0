Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B90B168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638BAC43445;
	Mon,  8 May 2023 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545266;
	bh=mVq8lib7lHcUdripA4slfZUmtLyDyfU1sOGZ+16/xKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+dnC6KlQNfHbPiUi89Wn4d9qFTk2xzlNa6Ux3BTgS0t1kS+1IP6WgsQj6OBlC1MT
	 2X/rc53YQv1xnkxu1ZGYBlPM0CHnwuFi2y5rNwWwOfXqra4lwzhZ7pxezkCQZ7vjy4
	 l8wASr0fF4ACczlJaISTk1xlvvXeb+MoL2dO9tiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 648/694] phy: ti: j721e-wiz: Fix unreachable code in wiz_mode_select()
Date: Mon,  8 May 2023 11:48:03 +0200
Message-Id: <20230508094456.879504808@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 57c0e1362fdd57d0cea7ab1e583b58abf4bd8c2d ]

In the wiz_mode_select() function, the configuration performed for
PHY_TYPE_USXGMII is unreachable. Fix it.

Fixes: b64a85fb8f53 ("phy: ti: phy-j721e-wiz.c: Add usxgmii support in wiz driver")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230403094552.929108-1-s-vadapalli@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index 1b83c98a78f0f..1b5f1a5e2b3ba 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -443,18 +443,17 @@ static int wiz_mode_select(struct wiz *wiz)
 	int i;
 
 	for (i = 0; i < num_lanes; i++) {
-		if (wiz->lane_phy_type[i] == PHY_TYPE_DP)
+		if (wiz->lane_phy_type[i] == PHY_TYPE_DP) {
 			mode = LANE_MODE_GEN1;
-		else if (wiz->lane_phy_type[i] == PHY_TYPE_QSGMII)
+		} else if (wiz->lane_phy_type[i] == PHY_TYPE_QSGMII) {
 			mode = LANE_MODE_GEN2;
-		else
-			continue;
-
-		if (wiz->lane_phy_type[i] == PHY_TYPE_USXGMII) {
+		} else if (wiz->lane_phy_type[i] == PHY_TYPE_USXGMII) {
 			ret = regmap_field_write(wiz->p0_mac_src_sel[i], 0x3);
 			ret = regmap_field_write(wiz->p0_rxfclk_sel[i], 0x3);
 			ret = regmap_field_write(wiz->p0_refclk_sel[i], 0x3);
 			mode = LANE_MODE_GEN1;
+		} else {
+			continue;
 		}
 
 		ret = regmap_field_write(wiz->p_standard_mode[i], mode);
-- 
2.39.2



