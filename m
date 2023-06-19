Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EE8538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45133C433C0;
	Mon, 19 Jun 2023 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171718;
	bh=2tamyKIfjOWDZ+m0BMMMNh/RZR9xpgh14xTAtdzML5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eARRbL+AoezcEyv01VdaLSrdHe8FiEw6npgzN+jWOF+m2NTMm7JMaexvP7z7ovrrf
	 BXR20icQihfb0uLyEyuHOhaKT8jC9FllzrEOaDWKWiJdiDfW2vUzEc7ctFVWeWZ1Hx
	 IGG9yX1bB0bq8xz9Xq5mu7ttNrMhL7mFAnvFXOZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/166] net: phylink: use a dedicated helper to parse usgmii control word
Date: Mon, 19 Jun 2023 12:30:08 +0200
Message-ID: <20230619102201.146238648@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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
index acd3405ddc9c6..5b064a1de92f0 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3263,6 +3263,41 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
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
@@ -3299,9 +3334,11 @@ void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 
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



