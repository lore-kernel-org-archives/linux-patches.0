Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AC83C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE12EC433C8;
	Mon, 19 Jun 2023 10:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171194;
	bh=mlQ/2IpwAJTzLuTBpuQwYiSybCg+QLFECnSqPMW3/JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkmffxei/P0DwrnTneV/Q08joC3EvZWtjoOpsUH48s6OWo8dbo378P6/C1SCZtBjg
	 GamZe5ilyb04lJ4C43AChQSQvfjnU3idgGz/i0X9cAc67303wpXwwNYPN5dqNUk4NZ
	 07RGsqnqdUBHybjKtqVueBP13IdnmxZUIOB71Pxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 155/187] net: phylink: use a dedicated helper to parse usgmii control word
Date: Mon, 19 Jun 2023 12:29:33 +0200
Message-ID: <20230619102205.095119583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 923454c0368b8092e9d05c020f50abca577e7290 ]

Q-USGMII is a derivative of USGMII, that uses a specific formatting for
the control word. The layout is close to the USXGMII control word, but
doesn't support speeds over 1Gbps. Use a dedicated decoding logic for
the USGMII control word, re-using USXGMII definitions but only considering
10/100/1000Mbps speeds

Fixes: 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 65ff118f22314..0598debb93dea 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3297,6 +3297,41 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
 }
 EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
 
+/**
+ * phylink_decode_usgmii_word() - decode the USGMII word from a MAC PCS
+ * @state: a pointer to a struct phylink_link_state.
+ * @lpa: a 16 bit value which stores the USGMII auto-negotiation word
+ *
+ * Helper for MAC PCS supporting the USGMII protocol and the auto-negotiation
+ * code word.  Decode the USGMII code word and populate the corresponding fields
+ * (speed, duplex) into the phylink_link_state structure. The structure for this
+ * word is the same as the USXGMII word, except it only supports speeds up to
+ * 1Gbps.
+ */
+static void phylink_decode_usgmii_word(struct phylink_link_state *state,
+				       uint16_t lpa)
+{
+	switch (lpa & MDIO_USXGMII_SPD_MASK) {
+	case MDIO_USXGMII_10:
+		state->speed = SPEED_10;
+		break;
+	case MDIO_USXGMII_100:
+		state->speed = SPEED_100;
+		break;
+	case MDIO_USXGMII_1000:
+		state->speed = SPEED_1000;
+		break;
+	default:
+		state->link = false;
+		return;
+	}
+
+	if (lpa & MDIO_USXGMII_FULL_DUPLEX)
+		state->duplex = DUPLEX_FULL;
+	else
+		state->duplex = DUPLEX_HALF;
+}
+
 /**
  * phylink_mii_c22_pcs_decode_state() - Decode MAC PCS state from MII registers
  * @state: a pointer to a &struct phylink_link_state.
@@ -3333,9 +3368,11 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
 		phylink_decode_sgmii_word(state, lpa);
 		break;
+	case PHY_INTERFACE_MODE_QUSGMII:
+		phylink_decode_usgmii_word(state, lpa);
+		break;
 
 	default:
 		state->link = false;
-- 
2.39.2



