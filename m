Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDC9D534
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEECEC433D2;
	Mon, 15 May 2023 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169411;
	bh=zDoQlLO3OGRBnIqushllJndEF7OK84cmdFGvhQBmmms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+NAqeTTuh1CIozCBBS11GXz+ZpRY7XA8B4SAYocM093ihwj2J8o40OUR5X6cubat
	 RAAJybh0ZycZ31DCZ6QymBnSN+leKOG5sxTSTBSimC34ECiksNVFGOyiOo6QmEd89K
	 rY0+11rafPdB/1Mbb/rnF/LUCBOSpfn32t00ZRzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 048/246] r8152: fix the poor throughput for 2.5G devices
Date: Mon, 15 May 2023 18:24:20 +0200
Message-Id: <20230515161724.027831405@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 61b0ad6f58e2066e054c6d4839d67974d2861a7d ]

Fix the poor throughput for 2.5G devices, when changing the speed from
auto mode to force mode. This patch is used to notify the MAC when the
mode is changed.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index afd50e90d1fee..58670a65b840d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -199,6 +199,7 @@
 #define OCP_EEE_AR		0xa41a
 #define OCP_EEE_DATA		0xa41c
 #define OCP_PHY_STATUS		0xa420
+#define OCP_INTR_EN		0xa424
 #define OCP_NCTL_CFG		0xa42c
 #define OCP_POWER_CFG		0xa430
 #define OCP_EEE_CFG		0xa432
@@ -620,6 +621,9 @@ enum spd_duplex {
 #define PHY_STAT_LAN_ON		3
 #define PHY_STAT_PWRDN		5
 
+/* OCP_INTR_EN */
+#define INTR_SPEED_FORCE	BIT(3)
+
 /* OCP_NCTL_CFG */
 #define PGA_RETURN_EN		BIT(1)
 
@@ -7554,6 +7558,11 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
 				      ((swap_a & 0x1f) << 8) |
 				      ((swap_a >> 8) & 0x1f));
 		}
+
+		/* Notify the MAC when the speed is changed to force mode. */
+		data = ocp_reg_read(tp, OCP_INTR_EN);
+		data |= INTR_SPEED_FORCE;
+		ocp_reg_write(tp, OCP_INTR_EN, data);
 		break;
 	default:
 		break;
@@ -7949,6 +7958,11 @@ static void r8156b_hw_phy_cfg(struct r8152 *tp)
 		break;
 	}
 
+	/* Notify the MAC when the speed is changed to force mode. */
+	data = ocp_reg_read(tp, OCP_INTR_EN);
+	data |= INTR_SPEED_FORCE;
+	ocp_reg_write(tp, OCP_INTR_EN, data);
+
 	if (rtl_phy_patch_request(tp, true, true))
 		return;
 
-- 
2.39.2



