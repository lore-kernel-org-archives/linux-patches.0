Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74CF17A93F;
	Tue, 16 Jul 2024 15:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144916; cv=none; b=IsGqiGYZP1qHRJeFtF9TgXlWGynGqK1/zvYUiYfMGIxLGldmXI37xr+0AMwsSsCE9bAloPlT723XdEEx39aVfYQiMlXCQbFXr/g+V+oHXbN4otb0mkNQjSuBVBUqQa2RJcYT4YB1AOeXgmFfS4ON1E/jiQ6xnRTEhjXt3rJltwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144916; c=relaxed/simple;
	bh=Ai2M2RMi73FktqSm8sxYt+zw6vvAhpz5MumpE0YqvFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB1r8GpGB7wuPQlU6csbAG+g5rb+hR6RHClNfbeAwzcgw3ervuioFDAvQ4GqfomFdxCEzQfCVMJmeAq9T76C0SnD3xWCpINjS1mf+hUDKgnpwWJ8sZKWqJ5Rd2zD9XRL4gZX/i7pxiRsVvdKacX2BTlwBGL2B2RyhCWIYTuhsCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WCoC1qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WCoC1qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD56C116B1;
	Tue, 16 Jul 2024 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144916;
	bh=Ai2M2RMi73FktqSm8sxYt+zw6vvAhpz5MumpE0YqvFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WCoC1qMMip0IUrrKkGUMwW8ADfOZpKbrSZSGp508I+J+6vGXMygCE+eE/2xJixGm
	 j/MXIdDWUmkStVMm0Fm+N73FtOiJP+kcKmgfMRYbP394/kQdlsCVRbgI/cfhffevWv
	 VwbI14oKunQ+VTNW3cSvTiMaoLDfNB5hFoV8vF+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Woojung Huh <woojung.huh@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 039/143] ethtool: netlink: do not return SQI value if link is down
Date: Tue, 16 Jul 2024 17:30:35 +0200
Message-ID: <20240716152757.492499422@linuxfoundation.org>
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
index b2de2108b356a..34d76e87847d0 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -37,6 +37,8 @@ static int linkstate_get_sqi(struct net_device *dev)
 	mutex_lock(&phydev->lock);
 	if (!phydev->drv || !phydev->drv->get_sqi)
 		ret = -EOPNOTSUPP;
+	else if (!phydev->link)
+		ret = -ENETDOWN;
 	else
 		ret = phydev->drv->get_sqi(phydev);
 	mutex_unlock(&phydev->lock);
@@ -55,6 +57,8 @@ static int linkstate_get_sqi_max(struct net_device *dev)
 	mutex_lock(&phydev->lock);
 	if (!phydev->drv || !phydev->drv->get_sqi_max)
 		ret = -EOPNOTSUPP;
+	else if (!phydev->link)
+		ret = -ENETDOWN;
 	else
 		ret = phydev->drv->get_sqi_max(phydev);
 	mutex_unlock(&phydev->lock);
@@ -62,6 +66,17 @@ static int linkstate_get_sqi_max(struct net_device *dev)
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
@@ -93,12 +108,12 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
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
 
@@ -136,11 +151,10 @@ static int linkstate_reply_size(const struct ethnl_req_info *req_base,
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
@@ -164,13 +178,14 @@ static int linkstate_fill_reply(struct sk_buff *skb,
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



