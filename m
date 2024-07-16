Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870BF19E801;
	Tue, 16 Jul 2024 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144836; cv=none; b=nhnJ39RN/7nmUGskTcPxmlg1ZANUp2DDetggvblpwTMDDvsomY8QY7Xo0AI17l49uEzla8WAREuhXDrhds25ru3fJH7/MzD4QIq58o9xnND9LciUrTtwzzFhcRhUjLZXHix0Z4Pz1gOt4A4Fr97LcPhv33/DCQogc0f8mWheYTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144836; c=relaxed/simple;
	bh=iS9Mijg5bRK15tmBRb8BfUnrcWJe/k/FBn7ESMERnKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFUzIg5ii1Myf6LGLEaIIGJXdY7gH/0yWgolllAZyxRggJYCm0n0qvaxY5f471riJhxrxxpiNDVs3S+HH3gpk7aXqWYBxrETC3ER9eJZUVQVNE9rda4m1BKiHBD4rCDEQW2PZ6mJ+Qw4NFOFrhnMuJx4FGVyWJon7Yu/eEBygAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6OtHo9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6OtHo9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC338C4AF0E;
	Tue, 16 Jul 2024 15:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144836;
	bh=iS9Mijg5bRK15tmBRb8BfUnrcWJe/k/FBn7ESMERnKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6OtHo9GCrBex+Ta0zs9fhwhA49tL2V0nsXKUn/IKaFz8ihb3Xxex1KbZawGze4m6
	 +BeTIuZshl+WfqkU048QZ8t5bXxhaPP1ZaPMUbCKGZw6oa3xj+WB0LletnspwF9LRp
	 EnaTuyu+4yDloTzR/Tc30/mbVTd/la+pMoAIY/C8=
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
Subject: [PATCH 6.9 012/143] net: dsa: introduce dsa_phylink_to_port()
Date: Tue, 16 Jul 2024 17:30:08 +0200
Message-ID: <20240716152756.461086951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 7c0da9effe4e9..f228b479a5fd2 100644
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
index c42dac87671b1..02bf1c306bdca 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1558,7 +1558,7 @@ static struct phylink_pcs *
 dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 				phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct phylink_pcs *pcs = ERR_PTR(-EOPNOTSUPP);
 	struct dsa_switch *ds = dp->ds;
 
@@ -1572,7 +1572,7 @@ static int dsa_port_phylink_mac_prepare(struct phylink_config *config,
 					unsigned int mode,
 					phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 	int err = 0;
 
@@ -1587,7 +1587,7 @@ static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_config)
@@ -1600,7 +1600,7 @@ static int dsa_port_phylink_mac_finish(struct phylink_config *config,
 				       unsigned int mode,
 				       phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 	int err = 0;
 
@@ -1615,7 +1615,7 @@ static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 					   unsigned int mode,
 					   phy_interface_t interface)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
@@ -1638,7 +1638,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 					 int speed, int duplex,
 					 bool tx_pause, bool rx_pause)
 {
-	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_port *dp = dsa_phylink_to_port(config);
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->phylink_mac_link_up) {
-- 
2.43.0



