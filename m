Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2881328ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F9C433EF;
	Mon, 12 Dec 2022 13:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852532;
	bh=s0LUIJvPpkur9LY6RxVIboEMBRomuSPgB+BetF6F2XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHzGtm6OiS+iuo6ABX3o2awi3O7EKrYfKBGnEcY7GbEnjBxPzrYC+76tSAeEhKQnK
	 tXm6r3MusCLJPfSlUSgi0Cd2DPge2dSYgpU8hNw5bzy4MIbTIbEuDjvGk+boaYoDn7
	 zVAIw9YhYlMynv5IvjTy9ur+0W7YT9YK5nIkOLZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Schuyler Patton <spatton@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 100/157] net: ethernet: ti: am65-cpsw: Fix RGMII configuration at SPEED_10
Date: Mon, 12 Dec 2022 14:17:28 +0100
Message-Id: <20221212130938.850463482@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

[ Upstream commit 6c681f899e0360803b924ac8c96ee21965118649 ]

The am65-cpsw driver supports configuring all RGMII variants at interface
speed of 10 Mbps. However, in the process of shifting to the PHYLINK
framework, the support for all variants of RGMII except the
PHY_INTERFACE_MODE_RGMII variant was accidentally removed.

Fix this by using phy_interface_mode_is_rgmii() to check for all variants
of RGMII mode.

Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
Reported-by: Schuyler Patton <spatton@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20221129050639.111142-1-s-vadapalli@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 95baacd6c761..47da11b9ac28 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1450,7 +1450,7 @@ static void am65_cpsw_nuss_mac_link_up(struct phylink_config *config, struct phy
 
 	if (speed == SPEED_1000)
 		mac_control |= CPSW_SL_CTL_GIG;
-	if (speed == SPEED_10 && interface == PHY_INTERFACE_MODE_RGMII)
+	if (speed == SPEED_10 && phy_interface_mode_is_rgmii(interface))
 		/* Can be used with in band mode only */
 		mac_control |= CPSW_SL_CTL_EXT_EN;
 	if (speed == SPEED_100 && interface == PHY_INTERFACE_MODE_RMII)
-- 
2.35.1



