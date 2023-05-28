Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802C611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17555C4339B;
	Sun, 28 May 2023 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302952;
	bh=nOswqaiATASNph2GXkDyqsnNHvgtgVv6BJToAoOiJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKhb1QNpkqeSaOb5wpmHnRYxerPWpfmddufJHY9vTBZNDbM5sJBE6ULD/zkH0LzbT
	 bJeaRiS6YqDye/Xz3bdY1PAxB74WivnY+x4j6k/JMpX95EhqRXDxLXbSD+50OfLSgi
	 lcNyGSRqlrvPRLVvlFAUjaAQFQ0R3wfPqAJYjzAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/211] net: phy: dp83867: add w/a for packet errors seen with short cables
Date: Sun, 28 May 2023 20:10:15 +0100
Message-Id: <20230528190845.939503114@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 0b01db274028f5acd207332686ffc92ac77491ac ]

Introduce the W/A for packet errors seen with short cables (<1m) between
two DP83867 PHYs.

The W/A recommended by DM requires FFE Equalizer Configuration tuning by
writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
and soft resets as follows:

write_reg(0x001F, 0x8000); //hard reset
write_reg(DSP_FFE_CFG, 0x0E81);
write_reg(0x001F, 0x4000); //soft reset

Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
affect Long Cable performance.", enable the W/A by default.

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index c8031e297faf4..5fabcd15ef77a 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -41,6 +41,7 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_STRAP_STS2	0x006f
 #define DP83867_RGMIIDCTL	0x0086
+#define DP83867_DSP_FFE_CFG	0x012c
 #define DP83867_RXFCFG		0x0134
 #define DP83867_RXFPMD1	0x0136
 #define DP83867_RXFPMD2	0x0137
@@ -807,8 +808,27 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
+	if (err < 0)
+		return err;
+
+	/* Configure the DSP Feedforward Equalizer Configuration register to
+	 * improve short cable (< 1 meter) performance. This will not affect
+	 * long cable performance.
+	 */
+	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
+			    0x0e81);
+	if (err < 0)
+		return err;
+
+	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
+	if (err < 0)
+		return err;
+
+	usleep_range(10, 20);
+
+	return 0;
 }
 
 static void dp83867_link_change_notify(struct phy_device *phydev)
-- 
2.39.2



