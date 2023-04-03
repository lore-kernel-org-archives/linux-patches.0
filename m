Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586006FAA
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1C5C433EF;
	Mon,  3 Apr 2023 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532323;
	bh=Oe31jFkwIwVWhf1ZtSQRcotUfR/tWcj0+tuMIBtAu8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl7FVwnlRJ4m2+H/KQL5EDz7wAwLieD+fqwjOzT7A3ecNAny45fKEqjgnIQei/4Df
	 OpeH8oDsV8mPrjTMaWjSjihbcPMoHy+PGrFGaoVcMN3hP2tUHzCT/hl3PqwrrHmzeM
	 iOKyrlUpEUoaRyev58/xdKa4SHt8sNj28zHb/AGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChunHao Lin <hau@realtek.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/99] r8169: fix RTL8168H and RTL8107E rx crc error
Date: Mon,  3 Apr 2023 16:09:01 +0200
Message-Id: <20230403140404.650911362@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChunHao Lin <hau@realtek.com>

[ Upstream commit 33189f0a94b9639c058781fcf82e4ea3803b1682 ]

When link speed is 10 Mbps and temperature is under -20°C, RTL8168H and
RTL8107E may have rx crc error. Disable phy 10 Mbps pll off to fix this
issue.

Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Signed-off-by: ChunHao Lin <hau@realtek.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 50f0f621b1aa8..a84fd859aec9b 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -970,6 +970,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
+	/* disable 10m pll off */
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
+
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
-- 
2.39.2



