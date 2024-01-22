Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999CA50A81;
	Tue, 23 Jan 2024 00:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970192; cv=none; b=ZSqxAON2beDijjv2xteGdR3g/Pk4inDl1iDq++eW+rm99h1ziT0Eh7/lyHxRwYNJrulPrDhd+rm5oYWjAyIZAzVCnwonQ3qoCcCJbEWGQ8Ms4tUItFq7JsVWqRiCPYFm8yQVh14X0TW8kbfKwTFfzjRvjiWA4Cg5INgsVbsFEFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970192; c=relaxed/simple;
	bh=mAR3KR06DFXa3IdyCc4SqfCh6lm7ZVYs6xR2/RYQsYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljdK1tVUCo8jAOUbd1mz/0XJNMiDCbhzmz61IKU8YLli8XVKuPUEOU18DVIBOOkKCobetxRLcdpV8V/5LKbfOJ6eE1RAAqKFWBgsJiRBEfA6IqUqezRH4u/csSFgOPlahuK21D2S3Oa5DxjBH8j1lHji+ngn3YuYTDHoOY99FDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUnMWwY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUnMWwY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E72C433C7;
	Tue, 23 Jan 2024 00:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970192;
	bh=mAR3KR06DFXa3IdyCc4SqfCh6lm7ZVYs6xR2/RYQsYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUnMWwY3V5bcqLEBnZLjH3XLSehzDdbNdYDqoJaaly06rihUOmWHBYkmXhvUxUdGp
	 YXCrcFRyqIKeUkCatwVcOHUej5m0cWZs3EKY29o6VCdQTrlfJQfjTyWpfsVooDR2ta
	 FqIhuzUdl5ee6UHjok1EOygYsnb8vweljg1sF6EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Divya Koppera <divya.koppera@microchip.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 588/641] net: micrel: Fix PTP frame parsing for lan8841
Date: Mon, 22 Jan 2024 15:58:12 -0800
Message-ID: <20240122235836.613089348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit acd66c2126eb9b5da2d89ae07dbcd73b909c2111 ]

The HW has the capability to check each frame if it is a PTP frame,
which domain it is, which ptp frame type it is, different ip address in
the frame. And if one of these checks fail then the frame is not
timestamp. Most of these checks were disabled except checking the field
minorVersionPTP inside the PTP header. Meaning that once a partner sends
a frame compliant to 8021AS which has minorVersionPTP set to 1, then the
frame was not timestamp because the HW expected by default a value of 0
in minorVersionPTP.
Fix this issue by removing this check so the userspace can decide on this.

Fixes: cafc3662ee3f ("net: micrel: Add PHC support for lan8841")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Divya Koppera <divya.koppera@microchip.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 08e3915001c3..73ee81c583ef 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3335,8 +3335,10 @@ static int lan8814_probe(struct phy_device *phydev)
 #define LAN8841_ADC_CHANNEL_MASK		198
 #define LAN8841_PTP_RX_PARSE_L2_ADDR_EN		370
 #define LAN8841_PTP_RX_PARSE_IP_ADDR_EN		371
+#define LAN8841_PTP_RX_VERSION			374
 #define LAN8841_PTP_TX_PARSE_L2_ADDR_EN		434
 #define LAN8841_PTP_TX_PARSE_IP_ADDR_EN		435
+#define LAN8841_PTP_TX_VERSION			438
 #define LAN8841_PTP_CMD_CTL			256
 #define LAN8841_PTP_CMD_CTL_PTP_ENABLE		BIT(2)
 #define LAN8841_PTP_CMD_CTL_PTP_DISABLE		BIT(1)
@@ -3380,6 +3382,12 @@ static int lan8841_config_init(struct phy_device *phydev)
 	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
 		      LAN8841_PTP_RX_PARSE_IP_ADDR_EN, 0);
 
+	/* Disable checking for minorVersionPTP field */
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_RX_VERSION, 0xff00);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_TX_VERSION, 0xff00);
+
 	/* 100BT Clause 40 improvenent errata */
 	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
 		      LAN8841_ANALOG_CONTROL_1,
-- 
2.43.0



