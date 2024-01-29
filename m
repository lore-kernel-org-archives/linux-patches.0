Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333B915AAA8;
	Mon, 29 Jan 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548351; cv=none; b=YDp7KDFslrWaELDkqE8vToBmO7OhIGdYHBgCu8sfprdtiDhksQbJg5/TqPY6MyWoyYUoq9cKCJVNMkQZ3jZT6H2qMkjFq+pyLhu9r8h4ClHoE8BLsv82/WZ4U7DDoKSE7oNnlwMjnI/tC54MKa3wKlaHCWYO/IntAYBQy0VRGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548351; c=relaxed/simple;
	bh=wvpxdsKXfXsKXg2v8fwu65Is2UHqCfZXnaziK827dP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqsJCjNP8HH4eG7b5TosrFmPzZwVoSfjYokc98psP7XFrjAOODSiuBD+PynTk9Tn7goB5dE53/04bC+g9jfrQfkjCMXLTBTqoay6vFVeaACq4d0kFfdp4CW3yb874AdNJtgXU+S4ke6SQYGhOS3zIVGA3qlTHe+PaWZELGBPoRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6tS3nk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6tS3nk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF281C43394;
	Mon, 29 Jan 2024 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548351;
	bh=wvpxdsKXfXsKXg2v8fwu65Is2UHqCfZXnaziK827dP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6tS3nk6m24fERLpLYw7JY8JI5FluhwhXMmKZAwbTXynps42GIOXxbwZuY5CXt9qD
	 e+kHCSFA1ZxQa665p1kPq/Fya8MYcTlFmvCMsGF81z1GR3dBVDkS5OXMtoizP7jMcL
	 zsL3cLdaPsmCNSk5wQJ5CIae5u5TrUs88dHiFKKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Divya Koppera <divya.koppera@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/185] net: micrel: Fix PTP frame parsing for lan8814
Date: Mon, 29 Jan 2024 09:04:47 -0800
Message-ID: <20240129170001.397202044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7cbcf51bae92..9481f172830f 100644
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
@@ -2922,6 +2927,12 @@ static void lan8814_ptp_init(struct phy_device *phydev)
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



