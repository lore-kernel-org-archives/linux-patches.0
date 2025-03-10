Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB472309A6;
	Mon, 10 Mar 2025 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627616; cv=none; b=Y+umvCbupys7OsFnad+WmhaxxD8lJ/By2WfVXfv8M77loxIc483Q/5EYyPTMK755h3JcB4URIdKYs5hDkfVL6v4/rl3v8tQ4Pxr4fudQa23TXv4Ts/E1m7NwKxfaOT8I0zXZHLF1qog6Y5g5Ng/TBnym2lX5SKQvr6RbotVA2rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627616; c=relaxed/simple;
	bh=w33aMUadY2+1CJ99HkZaX8ZTOgeHkDZsn6VDwtL1+So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjfpKI2TKaNZlh06q8gMneDW1fvhQfCoJpUmvLOdZl7u2hABt+2Qq8pQBsX9gCKDnJG4sirekJ0DW6NZyMSAlJZwmcwqTiL/U+uDtmZp7B7hXvYI9Hjf8V6C3RbQ+ipcLbKYANeDoFW/f8Fu35C+6QrKasG4vqXTzOJQkxhe9zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTrMywOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTrMywOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED1C4CEE5;
	Mon, 10 Mar 2025 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627616;
	bh=w33aMUadY2+1CJ99HkZaX8ZTOgeHkDZsn6VDwtL1+So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTrMywOoS6NhEB8B5eRXjn+GT9fQA71l04dx0RtSwjh3NTJVMKlhPQrBM054Z3DRD
	 jd83dSfifu/TzJOxMg1gKFW8QpdQC1Bq5BUts9KZV9m5l9CEmiEYaQz+bOHB4hgfNT
	 n6o96IsXClV032b/9NbQaqLYjK0uLd8XaZDoW/7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/269] net: ethtool: netlink: Allow NULL nlattrs when getting a phy_device
Date: Mon, 10 Mar 2025 18:05:44 +0100
Message-ID: <20250310170505.318124279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 637399bf7e77797811adf340090b561a8f9d1213 ]

ethnl_req_get_phydev() is used to lookup a phy_device, in the case an
ethtool netlink command targets a specific phydev within a netdev's
topology.

It takes as a parameter a const struct nlattr *header that's used for
error handling :

       if (!phydev) {
               NL_SET_ERR_MSG_ATTR(extack, header,
                                   "no phy matching phyindex");
               return ERR_PTR(-ENODEV);
       }

In the notify path after a ->set operation however, there's no request
attributes available.

The typical callsite for the above function looks like:

	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_XXX_HEADER],
				      info->extack);

So, when tb is NULL (such as in the ethnl notify path), we have a nice
crash.

It turns out that there's only the PLCA command that is in that case, as
the other phydev-specific commands don't have a notification.

This commit fixes the crash by passing the cmd index and the nlattr
array separately, allowing NULL-checking it directly inside the helper.

Fixes: c15e065b46dc ("net: ethtool: Allow passing a phy index for some commands")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Reported-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Link: https://patch.msgid.link/20250301141114.97204-1-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cabletest.c | 8 ++++----
 net/ethtool/linkstate.c | 2 +-
 net/ethtool/netlink.c   | 6 +++---
 net/ethtool/netlink.h   | 5 +++--
 net/ethtool/phy.c       | 2 +-
 net/ethtool/plca.c      | 6 +++---
 net/ethtool/pse-pd.c    | 4 ++--
 net/ethtool/stats.c     | 2 +-
 net/ethtool/strset.c    | 2 +-
 9 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
index f22051f33868a..84096f6b0236e 100644
--- a/net/ethtool/cabletest.c
+++ b/net/ethtool/cabletest.c
@@ -72,8 +72,8 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	phydev = ethnl_req_get_phydev(&req_info,
-				      tb[ETHTOOL_A_CABLE_TEST_HEADER],
+	phydev = ethnl_req_get_phydev(&req_info, tb,
+				      ETHTOOL_A_CABLE_TEST_HEADER,
 				      info->extack);
 	if (IS_ERR_OR_NULL(phydev)) {
 		ret = -EOPNOTSUPP;
@@ -339,8 +339,8 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
 		goto out_dev_put;
 
 	rtnl_lock();
-	phydev = ethnl_req_get_phydev(&req_info,
-				      tb[ETHTOOL_A_CABLE_TEST_TDR_HEADER],
+	phydev = ethnl_req_get_phydev(&req_info, tb,
+				      ETHTOOL_A_CABLE_TEST_TDR_HEADER,
 				      info->extack);
 	if (IS_ERR_OR_NULL(phydev)) {
 		ret = -EOPNOTSUPP;
diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index af19e1bed303f..05a5f72c99fab 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -103,7 +103,7 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_LINKSTATE_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_LINKSTATE_HEADER,
 				      info->extack);
 	if (IS_ERR(phydev)) {
 		ret = PTR_ERR(phydev);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 4d18dc29b3043..e233dfc8ca4be 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -210,7 +210,7 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 }
 
 struct phy_device *ethnl_req_get_phydev(const struct ethnl_req_info *req_info,
-					const struct nlattr *header,
+					struct nlattr **tb, unsigned int header,
 					struct netlink_ext_ack *extack)
 {
 	struct phy_device *phydev;
@@ -224,8 +224,8 @@ struct phy_device *ethnl_req_get_phydev(const struct ethnl_req_info *req_info,
 		return req_info->dev->phydev;
 
 	phydev = phy_link_topo_get_phy(req_info->dev, req_info->phy_index);
-	if (!phydev) {
-		NL_SET_ERR_MSG_ATTR(extack, header,
+	if (!phydev && tb) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[header],
 				    "no phy matching phyindex");
 		return ERR_PTR(-ENODEV);
 	}
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 203b08eb6c6f6..5e176938d6d22 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -275,7 +275,8 @@ static inline void ethnl_parse_header_dev_put(struct ethnl_req_info *req_info)
  * ethnl_req_get_phydev() - Gets the phy_device targeted by this request,
  *			    if any. Must be called under rntl_lock().
  * @req_info:	The ethnl request to get the phy from.
- * @header:	The netlink header, used for error reporting.
+ * @tb:		The netlink attributes array, for error reporting.
+ * @header:	The netlink header index, used for error reporting.
  * @extack:	The netlink extended ACK, for error reporting.
  *
  * The caller must hold RTNL, until it's done interacting with the returned
@@ -289,7 +290,7 @@ static inline void ethnl_parse_header_dev_put(struct ethnl_req_info *req_info)
  *	   is returned.
  */
 struct phy_device *ethnl_req_get_phydev(const struct ethnl_req_info *req_info,
-					const struct nlattr *header,
+					struct nlattr **tb, unsigned int header,
 					struct netlink_ext_ack *extack);
 
 /**
diff --git a/net/ethtool/phy.c b/net/ethtool/phy.c
index ed8f690f6bac8..e067cc234419d 100644
--- a/net/ethtool/phy.c
+++ b/net/ethtool/phy.c
@@ -125,7 +125,7 @@ static int ethnl_phy_parse_request(struct ethnl_req_info *req_base,
 	struct phy_req_info *req_info = PHY_REQINFO(req_base);
 	struct phy_device *phydev;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_PHY_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PHY_HEADER,
 				      extack);
 	if (!phydev)
 		return 0;
diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index d95d92f173a6d..e1f7820a6158f 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -62,7 +62,7 @@ static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_PLCA_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PLCA_HEADER,
 				      info->extack);
 	// check that the PHY device is available and connected
 	if (IS_ERR_OR_NULL(phydev)) {
@@ -152,7 +152,7 @@ ethnl_set_plca(struct ethnl_req_info *req_info, struct genl_info *info)
 	bool mod = false;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_info, tb[ETHTOOL_A_PLCA_HEADER],
+	phydev = ethnl_req_get_phydev(req_info, tb, ETHTOOL_A_PLCA_HEADER,
 				      info->extack);
 	// check that the PHY device is available and connected
 	if (IS_ERR_OR_NULL(phydev))
@@ -211,7 +211,7 @@ static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_PLCA_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PLCA_HEADER,
 				      info->extack);
 	// check that the PHY device is available and connected
 	if (IS_ERR_OR_NULL(phydev)) {
diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index a0705edca22a1..71843de832cca 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -64,7 +64,7 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_PSE_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PSE_HEADER,
 				      info->extack);
 	if (IS_ERR(phydev))
 		return -ENODEV;
@@ -261,7 +261,7 @@ ethnl_set_pse(struct ethnl_req_info *req_info, struct genl_info *info)
 	struct phy_device *phydev;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_info, tb[ETHTOOL_A_PSE_HEADER],
+	phydev = ethnl_req_get_phydev(req_info, tb, ETHTOOL_A_PSE_HEADER,
 				      info->extack);
 	ret = ethnl_set_pse_validate(phydev, info);
 	if (ret)
diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index f4d822c225db6..273ae4ff343fe 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -128,7 +128,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_STATS_HEADER],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_STATS_HEADER,
 				      info->extack);
 	if (IS_ERR(phydev))
 		return PTR_ERR(phydev);
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index b3382b3cf325c..b9400d18f01d5 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -299,7 +299,7 @@ static int strset_prepare_data(const struct ethnl_req_info *req_base,
 		return 0;
 	}
 
-	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_HEADER_FLAGS],
+	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_HEADER_FLAGS,
 				      info->extack);
 
 	/* phydev can be NULL, check for errors only */
-- 
2.39.5



