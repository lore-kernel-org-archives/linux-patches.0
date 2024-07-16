Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB5D1DA4D;
	Tue, 16 Jul 2024 15:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145567; cv=none; b=ERGQpPjnmaVklr5mJfc6lQ3feZ9L3BNM7+yaZDv4T2yR77atL2/M2lGYrIFkZtx0UizMD8vtEXhSuqwSIiy/5rVVbHv5OiYdRi1bPf7y4xrGUjpVWBuTwk8UhbfB+X2ZUvpnYiL5Qek/vZGgViLW7oOxNFXwi+8p1xtZRQW+k1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145567; c=relaxed/simple;
	bh=/U5mbj3bjIG73b7RSqMUII2CaF98Tu4zhXk8Nu1Bb9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8g2qnagT5QJlai1bX6sttJ54vyZG7zjsreDVU3dOR82Vz4JxeMUIGeIkmmS+zR1yRQRug8vn7IACr73I8mJYUSM/6p/wEt4PNsfQr8kkMefAzc3IB9TtDdSeiBo3nCcFMTr5lPl4R3XEzn8WyrS89UgG9KzRFRBKkar0qEBWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeamX4Rk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeamX4Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CC3C116B1;
	Tue, 16 Jul 2024 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145567;
	bh=/U5mbj3bjIG73b7RSqMUII2CaF98Tu4zhXk8Nu1Bb9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeamX4RklV/mXGmeA6IqQWAJoy/V0sVm4lszFovrFGzTY+0Zit9dQUjpdxBZ5Ms0k
	 P17rZbsdeU0Nc4yGTlZA9sOFXJNnKSRXELhg30dqChSJ9ueef6/KYoHrv9fvTtlrBh
	 FSo8sXVXWAQBF7oqHe4aawB+AsucTKRFKCed5yJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/121] net: dsa: introduce dsa_phylink_to_port()
Date: Tue, 16 Jul 2024 17:31:14 +0200
Message-ID: <20240716152751.792628497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit dd0c9855b41310470086500c9963bbb64bb90dd0 ]

We convert from a phylink_config struct to a dsa_port struct in many
places, let's provide a helper for this.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/E1rudqA-006K9B-85@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0005b2dc43f9 ("dsa: lan9303: Fix mapping between DSA port number and PHY address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/port.c    | 12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0b9c6aa270474..f643866300ed3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -327,6 +327,12 @@ struct dsa_port {
 	};
 };
 
+static inline struct dsa_port *
+dsa_phylink_to_port(struct phylink_config *config)
+{
+	return container_of(config, struct dsa_port, pl_config);
+}
+
 /* TODO: ideally DSA ports would have a single dp->link_dp member,
  * and no dst->rtable nor this struct dsa_link would be needed,
  * but this would require some more complex tree walking,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 37ab238e83042..c5e7b12aff5bf 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1572,7 +1572,7 @@ static struct phylink_pcs *
 dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 				phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct phylink_pcs *pcs = ERR_PTR(-EOPNOTSUPP);
 	struct dsa_switch *ds = dp->ds;
 
@@ -1586,7 +1586,7 @@ static int dsa_port_phylink_mac_prepare(struct phylink_config *config,
 					unsigned int mode,
 					phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 	int err = 0;
 
@@ -1601,7 +1601,7 @@ static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_config)
@@ -1614,7 +1614,7 @@ static int dsa_port_phylink_mac_finish(struct phylink_config *config,
 				       unsigned int mode,
 				       phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 	int err = 0;
 
@@ -1629,7 +1629,7 @@ static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 					   unsigned int mode,
 					   phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
@@ -1652,7 +1652,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 					 int speed, int duplex,
 					 bool tx_pause, bool rx_pause)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_link_up) {
-- 
2.43.0



