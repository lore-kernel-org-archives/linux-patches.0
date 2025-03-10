Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF24422B8D0;
	Mon, 10 Mar 2025 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626850; cv=none; b=NIX+a3BThQfodzAwEiCvTl/wY/y44cSrpfD6M2keaL1dVmMrLue+8Ga8oFENJexVvP5BEi+il19KaHiSwSCMVDaUKqs1P1Y3P8r+ewQDAndfANfHI+DjA94KyILep8/Ah6kTKBrIss+tKjdrh2di49E0IC/wzdieybsDDKCrNe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626850; c=relaxed/simple;
	bh=OXumr60NOCNUDR4+qyqdvCdD2IWuNBCHgYrHGUubjVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfnR8vkNHzdlCxwVIEhB2X7a0S9KiCrUqP2Thn3Olen2G1p6887gcq8r5igLpLxwTIHtMPxM/k31Y85gfuxS2jderXiX+O8r4LADjZClGmrIKeROZdbG3J4l4OZVBylEmLlFwodM9WMAbU+ddpoNWXB4TJ/6tN1B8OzHGMpgUo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QguRn73A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QguRn73A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37135C4CEE5;
	Mon, 10 Mar 2025 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626850;
	bh=OXumr60NOCNUDR4+qyqdvCdD2IWuNBCHgYrHGUubjVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QguRn73ADu6LvTeQFf20e17huzGqXQAGngSmXQn6QT9m8YmicwQdyr+asibWeA6r/
	 qpdh297w+3TGqw/E1aK27RolJifzGacBohHxbVnGi4UrjbUkqZ1ulmCqbAimq3H8zu
	 e0Uv4Ld8maXJjJnByRDOi5uJVZxFmP+f0uH4QKsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 133/207] ethtool: linkstate: migrate linkstate functions to support multi-PHY setups
Date: Mon, 10 Mar 2025 18:05:26 +0100
Message-ID: <20250310170453.088466395@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit fe55b1d401c697c2ef126fe3ebbcaa6885fced5a ]

Adapt linkstate_get_sqi() and linkstate_get_sqi_max() to take a
phy_device argument directly, enabling support for setups with
multiple PHYs. The previous assumption of a single PHY attached to
a net_device no longer holds.

Use ethnl_req_get_phydev() to identify the appropriate PHY device
for the operation. Update linkstate_prepare_data() and related
logic to accommodate this change, ensuring compatibility with
multi-PHY configurations.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 637399bf7e77 ("net: ethtool: netlink: Allow NULL nlattrs when getting a phy_device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/linkstate.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 34d76e87847d0..459cfea7652d4 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -26,9 +26,8 @@ const struct nla_policy ethnl_linkstate_get_policy[] = {
 		NLA_POLICY_NESTED(ethnl_header_policy_stats),
 };
 
-static int linkstate_get_sqi(struct net_device *dev)
+static int linkstate_get_sqi(struct phy_device *phydev)
 {
-	struct phy_device *phydev = dev->phydev;
 	int ret;
 
 	if (!phydev)
@@ -46,9 +45,8 @@ static int linkstate_get_sqi(struct net_device *dev)
 	return ret;
 }
 
-static int linkstate_get_sqi_max(struct net_device *dev)
+static int linkstate_get_sqi_max(struct phy_device *phydev)
 {
-	struct phy_device *phydev = dev->phydev;
 	int ret;
 
 	if (!phydev)
@@ -100,19 +98,28 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 {
 	struct linkstate_reply_data *data = LINKSTATE_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
+	struct nlattr **tb = info->attrs;
+	struct phy_device *phydev;
 	int ret;
 
+	phydev = ethnl_req_get_phydev(req_base, tb[ETHTOOL_A_LINKSTATE_HEADER],
+				      info->extack);
+	if (IS_ERR(phydev)) {
+		ret = PTR_ERR(phydev);
+		goto out;
+	}
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 	data->link = __ethtool_get_link(dev);
 
-	ret = linkstate_get_sqi(dev);
+	ret = linkstate_get_sqi(phydev);
 	if (linkstate_sqi_critical_error(ret))
 		goto out;
 	data->sqi = ret;
 
-	ret = linkstate_get_sqi_max(dev);
+	ret = linkstate_get_sqi_max(phydev);
 	if (linkstate_sqi_critical_error(ret))
 		goto out;
 	data->sqi_max = ret;
@@ -127,9 +134,9 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 			   sizeof(data->link_stats) / 8);
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS) {
-		if (dev->phydev)
+		if (phydev)
 			data->link_stats.link_down_events =
-				READ_ONCE(dev->phydev->link_down_events);
+				READ_ONCE(phydev->link_down_events);
 
 		if (dev->ethtool_ops->get_link_ext_stats)
 			dev->ethtool_ops->get_link_ext_stats(dev,
-- 
2.39.5



