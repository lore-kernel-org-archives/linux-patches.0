Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8B42F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE4C433EF;
	Wed, 12 Apr 2023 08:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288802;
	bh=lF9XBFsTzjKeyLPIHoB8C8mkasUVZRgzvwLpqJMzskE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOFfzIpSy6HbgwHbm9RZpeDRVhH6FTdvwdLoBbBfV57goKwF1oMv3DRNj4bs6zJRn
	 +YDON66aDpk3AEk0PVMyWI9Jv+0HZr8++Slmhgd4ksymFN5NcSAwvXKaB5IOeuM2KN
	 omPwCX0vYwqfLPjpq8indIBHeWpYJYOXoC8NO76w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/164] net: phylink: add phylink_expects_phy() method
Date: Wed, 12 Apr 2023 10:32:25 +0200
Message-Id: <20230412082837.889883792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

[ Upstream commit 653a180957a85c3fc30320cc7e84f5dc913a64f8 ]

Provide phylink_expects_phy() to allow MAC drivers to check if it
is expecting a PHY to attach to. Since fixed-linked setups do not
need to attach to a PHY.

Provides a boolean value as to if the MAC should expect a PHY.
Returns true if a PHY is expected.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 19 +++++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a202ce6611fde..4073e8243df3f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1552,6 +1552,25 @@ void phylink_destroy(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_destroy);
 
+/**
+ * phylink_expects_phy() - Determine if phylink expects a phy to be attached
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * When using fixed-link mode, or in-band mode with 1000base-X or 2500base-X,
+ * no PHY is needed.
+ *
+ * Returns true if phylink will be expecting a PHY.
+ */
+bool phylink_expects_phy(struct phylink *pl)
+{
+	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
+	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
+	     phy_interface_mode_is_8023z(pl->link_config.interface)))
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(phylink_expects_phy);
+
 static void phylink_phy_change(struct phy_device *phydev, bool up)
 {
 	struct phylink *pl = phydev->phylink;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 3f01ac8017e06..6d62c9ea2e040 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -566,6 +566,7 @@ struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops);
 void phylink_destroy(struct phylink *);
+bool phylink_expects_phy(struct phylink *pl);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
-- 
2.39.2



