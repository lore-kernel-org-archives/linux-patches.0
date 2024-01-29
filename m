Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3807373722;
	Mon, 29 Jan 2024 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548541; cv=none; b=eXD/tloaL0BvhIMYXNaxwSc8rxGmdrJobd3uJ3/M/lLjVuMTXo75zrVBLiiN8uR9fHCnmu/SFN9Z5LNHehBXMawJBOBBsvDF3YnJrgyANshuNLHxGkoD4HcS+qtiY/Iq/GHW9jWDq7QFDMnsQHYaQVf8Icaa/adrr59RC127eRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548541; c=relaxed/simple;
	bh=3ZTIC8O0dJyu7DdrswS8e7zoo1/LgCQ5LJ0fBrJWI/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG+13p2Sx+jtWYwWusLtc9ecf3i2Daa2A8Ufw4mkk82vnQMoyJHvAcbnWuCyk895NUvPM0TXya6zleeMFwnyF3O2ZhEaWe8RpDxarZFXntxxvZ3BbmpqWKAdsrCsBGOWhRqeKBz0bMyQvj4n5Hl3K5lkBvZRJXxlBRci5DVpl1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK+VHq5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK+VHq5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F419DC433F1;
	Mon, 29 Jan 2024 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548541;
	bh=3ZTIC8O0dJyu7DdrswS8e7zoo1/LgCQ5LJ0fBrJWI/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PK+VHq5kqctOeT0+mp5Dd5nYazgc8KyLbmFpsmdC6Hl5Os3+v9bGnACNKfECJ7d3l
	 FivRWmMuJcSLDRRWA5EgSABqNLKVsOHChuY6Rv0nyVcOiH9L6qejwyNxeTNwVKXVH3
	 9iiImlSygYkTSBUywXXVBcAtgNtbP2Zj7RDA5hk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Divya Koppera <divya.koppera@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/331] net: micrel: Fix PTP frame parsing for lan8814
Date: Mon, 29 Jan 2024 09:04:05 -0800
Message-ID: <20240129170020.200123690@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit aaf632f7ab6dec57bc9329a438f94504fe8034b9 ]

The HW has the capability to check each frame if it is a PTP frame,
which domain it is, which ptp frame type it is, different ip address in
the frame. And if one of these checks fail then the frame is not
timestamp. Most of these checks were disabled except checking the field
minorVersionPTP inside the PTP header. Meaning that once a partner sends
a frame compliant to 8021AS which has minorVersionPTP set to 1, then the
frame was not timestamp because the HW expected by default a value of 0
in minorVersionPTP. This is exactly the same issue as on lan8841.
Fix this issue by removing this check so the userspace can decide on this.

Fixes: ece19502834d ("net: phy: micrel: 1588 support for LAN8814 phy")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Divya Koppera <divya.koppera@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index dfd5f8e78e29..27ca25bbd141 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -120,6 +120,11 @@
  */
 #define LAN8814_1PPM_FORMAT			17179
 
+#define PTP_RX_VERSION				0x0248
+#define PTP_TX_VERSION				0x0288
+#define PTP_MAX_VERSION(x)			(((x) & GENMASK(7, 0)) << 8)
+#define PTP_MIN_VERSION(x)			((x) & GENMASK(7, 0))
+
 #define PTP_RX_MOD				0x024F
 #define PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_ BIT(3)
 #define PTP_RX_TIMESTAMP_EN			0x024D
@@ -3125,6 +3130,12 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 	lanphy_write_page_reg(phydev, 5, PTP_TX_PARSE_IP_ADDR_EN, 0);
 	lanphy_write_page_reg(phydev, 5, PTP_RX_PARSE_IP_ADDR_EN, 0);
 
+	/* Disable checking for minorVersionPTP field */
+	lanphy_write_page_reg(phydev, 5, PTP_RX_VERSION,
+			      PTP_MAX_VERSION(0xff) | PTP_MIN_VERSION(0x0));
+	lanphy_write_page_reg(phydev, 5, PTP_TX_VERSION,
+			      PTP_MAX_VERSION(0xff) | PTP_MIN_VERSION(0x0));
+
 	skb_queue_head_init(&ptp_priv->tx_queue);
 	skb_queue_head_init(&ptp_priv->rx_queue);
 	INIT_LIST_HEAD(&ptp_priv->rx_ts_list);
-- 
2.43.0



