Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292CF1F03D7;
	Fri, 21 Nov 2025 13:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731818; cv=none; b=iuO6FpYOv1wnolLSBcBlPgGJkSmYzmukfU87Zui3NlXueRNu610itfL7CrR5cuLDH+pak87gsEPwfvaItBuUJi4DFRcNT+tG/MIA245kjOjQCJG19R7do83m149EIf7V+m2hFe1XMFgiLlSXMNLiDToTcE/UqkCRwVeal3MUbXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731818; c=relaxed/simple;
	bh=phW7KzWlMnnCSJTfQVxF4+wdXt1kmDux9krINajj6ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+QGDEXk0D3WmTw3Bj/trPL6noPsY/eQl5Dc+/Y+1ULloT8s8UrK1A+JzEmUr5YvtGOzElyzeh6hVn6eWzCsgPR67m+froD8HS8PnJgwGRyNlmyfA9SQVZJILUSnLLppYr/KLDFo5sQ2MeatVLnW6y9nY1zXiF9fV3ZHbVvTO0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tm08y7n5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tm08y7n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD83C4CEF1;
	Fri, 21 Nov 2025 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731818;
	bh=phW7KzWlMnnCSJTfQVxF4+wdXt1kmDux9krINajj6ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tm08y7n51K3Cxz5/ffWDAaCmRu211NE11bTSiP0hvWQA9xhCIgzV44oe/zFD1a7ez
	 Cs9WYJJR7PSBy2skaYTCNQ67v81nHUq2zZvwpTSmDTIGqS+np7zFtr9Ka/uBoiHFVV
	 SK7Po24ThaPF4kV/VomC5mbeSQq56UD9Cx8P9uLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/185] net: ethernet: ti: am65-cpsw-qos: fix IET verify/response timeout
Date: Fri, 21 Nov 2025 14:11:14 +0100
Message-ID: <20251121130145.576897029@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 49b3916465176a5abcb29a0e464825f553d55d58 ]

The CPSW module uses the MAC_VERIFY_CNT bit field in the
CPSW_PN_IET_VERIFY_REG_k register to set the verify/response timeout
count. This register specifies the number of clock cycles to wait before
resending a verify packet if the verification fails.

The verify/response timeout count, as being set by the function
am65_cpsw_iet_set_verify_timeout_count() is hardcoded for 125MHz
clock frequency, which varies based on PHY mode and link speed.

The respective clock frequencies are as follows:
- RGMII mode:
  * 1000 Mbps: 125 MHz
  * 100 Mbps: 25 MHz
  * 10 Mbps: 2.5 MHz
- QSGMII/SGMII mode: 125 MHz (all speeds)

Fix this by adding logic to calculate the correct timeout counts
based on the actual PHY interface mode and link speed.

Fixes: 49a2eb9068246 ("net: ethernet: ti: am65-cpsw-qos: Add Frame Preemption MAC Merge support")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20251106092305.1437347-2-a-garg7@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index fa96db7c1a130..ad06942ce461a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -276,9 +276,31 @@ static int am65_cpsw_iet_set_verify_timeout_count(struct am65_cpsw_port *port)
 	/* The number of wireside clocks contained in the verify
 	 * timeout counter. The default is 0x1312d0
 	 * (10ms at 125Mhz in 1G mode).
+	 * The frequency of the clock depends on the link speed
+	 * and the PHY interface.
 	 */
-	val = 125 * HZ_PER_MHZ;	/* assuming 125MHz wireside clock */
+	switch (port->slave.phy_if) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (port->qos.link_speed == SPEED_1000)
+			val = 125 * HZ_PER_MHZ;	/* 125 MHz at 1000Mbps*/
+		else if (port->qos.link_speed == SPEED_100)
+			val = 25 * HZ_PER_MHZ;	/* 25 MHz at 100Mbps*/
+		else
+			val = (25 * HZ_PER_MHZ) / 10;	/* 2.5 MHz at 10Mbps*/
+		break;
+
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+		val = 125 * HZ_PER_MHZ;	/* 125 MHz */
+		break;
 
+	default:
+		netdev_err(port->ndev, "selected mode does not supported IET\n");
+		return -EOPNOTSUPP;
+	}
 	val /= MILLIHZ_PER_HZ;		/* count per ms timeout */
 	val *= verify_time_ms;		/* count for timeout ms */
 
-- 
2.51.0



