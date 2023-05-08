Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1E0168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0456DC433D2;
	Mon,  8 May 2023 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540897;
	bh=RnbYLio/HZ2O9e4zxIUvXb2b6l0nsKuNsF7jMEQyRJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBxn6QI2WfW1G4wyTdneZZKikD5oBLjpq1pVE8BKPgyWw7djq7JqICaZU3j3dM7aQ
	 ESt8hk7orkBQSCc6ab1RZ2qdBkaS2bUOMcZjYf80fYDJEPCbwRyg/EgdyjiDbjgDOa
	 bJKVyaJXtOJ0KiBrAe7rA9c/syhLD64JqehVfGF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 539/611] phy: ti: j721e-wiz: Fix unreachable code in wiz_mode_select()
Date: Mon,  8 May 2023 11:46:21 +0200
Message-Id: <20230508094439.526122229@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index 41725c6bcdf6f..6a63380f6a71f 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -422,18 +422,17 @@ static int wiz_mode_select(struct wiz *wiz)
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



