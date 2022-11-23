Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8CE1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC29AC433C1;
	Wed, 23 Nov 2022 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196883;
	bh=1nDiu51BcouoQu9gSf8emitN7XxEOTSnRgz2cvPZO5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKyvHnFQOR1H4eOPUKhFsKxwejcDjgKyRZY6yzh9J819lhgrtqmX6vVdkBXA+FY/e
	 CJFaxcUto/Zk4xengr4mmv7Mg5B4z5tf8Oz1U7Isapdb2LvEOzLA2Uth/r29SvNtmJ
	 +cz2Bqq9cuhu5rZO522uXD0qtSepfKdq3dRgXlqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 151/314] net: phy: dp83867: Fix SGMII FIFO depth for non OF devices
Date: Wed, 23 Nov 2022 09:49:56 +0100
Message-Id: <20221123084632.407753817@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit e2a54350dc9642e7dfc07335ca355581caa9dbfe ]

Current driver code will read device tree node information,
and set default values if there is no info provided.

This is not done in non-OF devices leading to SGMII fifo depths being
set to the smallest size.

This patch sets the value to the default value of the PHY as stated in the
PHY datasheet.

Fixes: 4dc08dcc9f6f ("net: phy: dp83867: introduce critical chip default init for non-of platform")
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221110054938.925347-1-michael.wei.hong.sit@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 417527f8bbf5..7446d5c6c714 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -682,6 +682,13 @@ static int dp83867_of_init(struct phy_device *phydev)
 	 */
 	dp83867->io_impedance = DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN / 2;
 
+	/* For non-OF device, the RX and TX FIFO depths are taken from
+	 * default value. So, we init RX & TX FIFO depths here
+	 * so that it is configured correctly later in dp83867_config_init();
+	 */
+	dp83867->tx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+	dp83867->rx_fifo_depth = DP83867_PHYCR_FIFO_DEPTH_4_B_NIB;
+
 	return 0;
 }
 #endif /* CONFIG_OF_MDIO */
-- 
2.35.1



