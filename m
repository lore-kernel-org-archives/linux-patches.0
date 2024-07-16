Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A2B19B59C;
	Tue, 16 Jul 2024 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145319; cv=none; b=NUR8JxdxMrJc3kgK7ejVzSdh45Vy0/EE96pFyIM99/XBiui4qn2CsFjlMpqLkMegLCwtWXuEqRac12cphkA+8BZKcGP9B0IGuMqdKxYlvrr5glvwZyv0cum6tXuPxse0B9Rq+Sh63IJm7sGEN/v5cxrbKz7K3fqNZEyIl7F4trM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145319; c=relaxed/simple;
	bh=mjnqPaFUDn/3vIaWSlopmuYNDzNEHpL3Tv+pL+Zvu1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sG77aDopo963qfjrxnaReQsUPQvQIe+pNkTooTFQE4AhTkXDtU2JS07XyicXPwsaOfjNylqAD14NuKCIi8kUIieSBYo7lCh1vCBWtYIrlmS24d6LPpatWl0QSJ14eca38u1YIiAEqIX1POSxF+50VBv7d7TGIyBCjcnM1r2X3NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUjUmtvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUjUmtvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FA3C4AF0B;
	Tue, 16 Jul 2024 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145318;
	bh=mjnqPaFUDn/3vIaWSlopmuYNDzNEHpL3Tv+pL+Zvu1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUjUmtvLxXblQH9zKVAGGNp4Sq4LKHCV6UnoJIb9UsVunJEp386isQIc4qzMSJsl1
	 VcRyqfYyNSQsf+AQkJ0A2Oq6twnuJvs1KyOiKwHpCpZDfuBzC9scOS3UwuJKRzM6zb
	 2+gcZ8Gd+WhlHbgygQa9GddKXN10URpbVKY3+iG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Woojung Huh <woojung.huh@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/96] ethtool: netlink: do not return SQI value if link is down
Date: Tue, 16 Jul 2024 17:31:37 +0200
Message-ID: <20240716152747.522111828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit c184cf94e73b04ff7048d045f5413899bc664788 ]

Do not attach SQI value if link is down. "SQI values are only valid if
link-up condition is present" per OpenAlliance specification of
100Base-T1 Interoperability Test suite [1]. The same rule would apply
for other link types.

[1] https://opensig.org/automotive-ethernet-specifications/#

Fixes: 806602191592 ("ethtool: provide UAPI for PHY Signal Quality Index (SQI)")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Woojung Huh <woojung.huh@microchip.com>
Link: https://patch.msgid.link/20240709061943.729381-1-o.rempel@pengutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/linkstate.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index fb676f349455a..470582a70ccbe 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -36,6 +36,8 @@ static int linkstate_get_sqi(struct net_device *dev)
 	mutex_lock(&phydev->lock);
 	if (!phydev->drv || !phydev->drv->get_sqi)
 		ret = -EOPNOTSUPP;
+	else if (!phydev->link)
+		ret = -ENETDOWN;
 	else
 		ret = phydev->drv->get_sqi(phydev);
 	mutex_unlock(&phydev->lock);
@@ -54,6 +56,8 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	mutex_lock(&phydev->lock);
 	if (!phydev->drv || !phydev->drv->get_sqi_max)
 		ret = -EOPNOTSUPP;
+	else if (!phydev->link)
+		ret = -ENETDOWN;
 	else
 		ret = phydev->drv->get_sqi_max(phydev);
 	mutex_unlock(&phydev->lock);
@@ -61,6 +65,17 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	return ret;
 };
 
+static bool linkstate_sqi_critical_error(int sqi)
+{
+	return sqi < 0 && sqi != -EOPNOTSUPP && sqi != -ENETDOWN;
+}
+
+static bool linkstate_sqi_valid(struct linkstate_reply_data *data)
+{
+	return data->sqi >= 0 && data->sqi_max >= 0 &&
+	       data->sqi <= data->sqi_max;
+}
+
 static int linkstate_get_link_ext_state(struct net_device *dev,
 					struct linkstate_reply_data *data)
 {
@@ -92,12 +107,12 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 	data->link = __ethtool_get_link(dev);
 
 	ret = linkstate_get_sqi(dev);
-	if (ret < 0 && ret != -EOPNOTSUPP)
+	if (linkstate_sqi_critical_error(ret))
 		goto out;
 	data->sqi = ret;
 
 	ret = linkstate_get_sqi_max(dev);
-	if (ret < 0 && ret != -EOPNOTSUPP)
+	if (linkstate_sqi_critical_error(ret))
 		goto out;
 	data->sqi_max = ret;
 
@@ -122,11 +137,10 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
 	len = nla_total_size(sizeof(u8)) /* LINKSTATE_LINK */
 		+ 0;
 
-	if (data->sqi != -EOPNOTSUPP)
-		len += nla_total_size(sizeof(u32));
-
-	if (data->sqi_max != -EOPNOTSUPP)
-		len += nla_total_size(sizeof(u32));
+	if (linkstate_sqi_valid(data)) {
+		len += nla_total_size(sizeof(u32)); /* LINKSTATE_SQI */
+		len += nla_total_size(sizeof(u32)); /* LINKSTATE_SQI_MAX */
+	}
 
 	if (data->link_ext_state_provided)
 		len += nla_total_size(sizeof(u8)); /* LINKSTATE_EXT_STATE */
@@ -147,13 +161,14 @@ static int linkstate_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_LINKSTATE_LINK, !!data->link))
 		return -EMSGSIZE;
 
-	if (data->sqi != -EOPNOTSUPP &&
-	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI, data->sqi))
-		return -EMSGSIZE;
+	if (linkstate_sqi_valid(data)) {
+		if (nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI, data->sqi))
+			return -EMSGSIZE;
 
-	if (data->sqi_max != -EOPNOTSUPP &&
-	    nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX, data->sqi_max))
-		return -EMSGSIZE;
+		if (nla_put_u32(skb, ETHTOOL_A_LINKSTATE_SQI_MAX,
+				data->sqi_max))
+			return -EMSGSIZE;
+	}
 
 	if (data->link_ext_state_provided) {
 		if (nla_put_u8(skb, ETHTOOL_A_LINKSTATE_EXT_STATE,
-- 
2.43.0



