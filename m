Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3C5101A;
	Mon, 11 Dec 2023 18:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKoB2PWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE651C433C9;
	Mon, 11 Dec 2023 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319340;
	bh=Ue0n3hDCFnFqRGfccqTge09Sj1kjMN7Tx3KDjDbXugA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKoB2PWnC9Id8K7pA7TdPgHUsCG3+dbpGpowJ6v5OEbpqPWbqKx3ilLvWNrCyioxj
	 /McK7K1zhDEfifQd97uyJB+XVTKLLc8YCmZk9iJ7z+lYQGr0IBL4KF4upIzPDH9o71
	 MSeyra8tfd/9/cCJTN1Nb9VXZMZbTsWrW7/gMVC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Michal Smulski <michal.smulski@ooma.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Tobias Waldekranz <tobias@waldekranz.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/244] net: dsa: mv88e6xxx: Restore USXGMII support for 6393X
Date: Mon, 11 Dec 2023 19:19:21 +0100
Message-ID: <20231211182048.855547006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 0c7ed1f9197aecada33a08b022e484a97bf584ba ]

In 4a56212774ac, USXGMII support was added for 6393X, but this was
lost in the PCS conversion (the blamed commit), most likely because
these efforts where more or less done in parallel.

Restore this feature by porting Michal's patch to fit the new
implementation.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Michal Smulski <michal.smulski@ooma.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Fixes: e5b732a275f5 ("net: dsa: mv88e6xxx: convert 88e639x to phylink_pcs")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Link: https://lore.kernel.org/r/20231205221359.3926018-1-tobias@waldekranz.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/pcs-639x.c | 31 ++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/pcs-639x.c b/drivers/net/dsa/mv88e6xxx/pcs-639x.c
index ba373656bfe14..c31f0e54f1e64 100644
--- a/drivers/net/dsa/mv88e6xxx/pcs-639x.c
+++ b/drivers/net/dsa/mv88e6xxx/pcs-639x.c
@@ -465,6 +465,7 @@ mv88e639x_pcs_select(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_XAUI:
 	case PHY_INTERFACE_MODE_RXAUI:
+	case PHY_INTERFACE_MODE_USXGMII:
 		return &mpcs->xg_pcs;
 
 	default:
@@ -873,7 +874,8 @@ static int mv88e6393x_xg_pcs_post_config(struct phylink_pcs *pcs,
 	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
 	int err;
 
-	if (interface == PHY_INTERFACE_MODE_10GBASER) {
+	if (interface == PHY_INTERFACE_MODE_10GBASER ||
+	    interface == PHY_INTERFACE_MODE_USXGMII) {
 		err = mv88e6393x_erratum_5_2(mpcs);
 		if (err)
 			return err;
@@ -886,12 +888,37 @@ static int mv88e6393x_xg_pcs_post_config(struct phylink_pcs *pcs,
 	return mv88e639x_xg_pcs_enable(mpcs);
 }
 
+static void mv88e6393x_xg_pcs_get_state(struct phylink_pcs *pcs,
+					struct phylink_link_state *state)
+{
+	struct mv88e639x_pcs *mpcs = xg_pcs_to_mv88e639x_pcs(pcs);
+	u16 status, lp_status;
+	int err;
+
+	if (state->interface != PHY_INTERFACE_MODE_USXGMII)
+		return mv88e639x_xg_pcs_get_state(pcs, state);
+
+	state->link = false;
+
+	err = mv88e639x_read(mpcs, MV88E6390_USXGMII_PHY_STATUS, &status);
+	err = err ? : mv88e639x_read(mpcs, MV88E6390_USXGMII_LP_STATUS, &lp_status);
+	if (err) {
+		dev_err(mpcs->mdio.dev.parent,
+			"can't read USXGMII status: %pe\n", ERR_PTR(err));
+		return;
+	}
+
+	state->link = !!(status & MDIO_USXGMII_LINK);
+	state->an_complete = state->link;
+	phylink_decode_usxgmii_word(state, lp_status);
+}
+
 static const struct phylink_pcs_ops mv88e6393x_xg_pcs_ops = {
 	.pcs_enable = mv88e6393x_xg_pcs_enable,
 	.pcs_disable = mv88e6393x_xg_pcs_disable,
 	.pcs_pre_config = mv88e6393x_xg_pcs_pre_config,
 	.pcs_post_config = mv88e6393x_xg_pcs_post_config,
-	.pcs_get_state = mv88e639x_xg_pcs_get_state,
+	.pcs_get_state = mv88e6393x_xg_pcs_get_state,
 	.pcs_config = mv88e639x_xg_pcs_config,
 };
 
-- 
2.42.0



