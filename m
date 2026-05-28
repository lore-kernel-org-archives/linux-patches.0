Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034232C11F9;
	Thu, 28 May 2026 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999570; cv=none; b=DzA5BJvSyE3nfHb9LbJnZ35VolsSab8bBDxW0yvTOTQrp8roa37SQmm4BtDiRypjsQ1JX00Ym6g9wcCf7t8LDFkueddGlgqCAeVAg1GaRrOVI3LCXDIbgQd6RQ0LGJspCqu0TLYsYiDXUz/pxHy3WDqVbTy3qST3YogUDt4xw08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999570; c=relaxed/simple;
	bh=Iwpq+qY7y8jEv6CO7tL3vSKc8J9cduYjMMZUg80itiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqSUqfwf0yzmJ3VN6ZGdaMge7m1b3DXHANqwGwJSUF1gg4MjhTyP0Sl8KuB1yh8YiemlRNTkBikOqKlQMr3Y923/Bg2eAdS8LTx/DZtL2ZJMo3gKvcxLSvc0T42XkSyHPoVb8scojVAs94S2l0stCicWVIuvDRH5HRD8gDkRSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPwu36Fy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPwu36Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDA11F000E9;
	Thu, 28 May 2026 20:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999568;
	bh=kyqCEejJQPvkyh1xgvBf6a/l+mT4WSTSrMREE98DQQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPwu36FyM78kc4nqinJrvk/EcSIb33gGR0LFK/EQdOcPTkOStQfJQa5d4YH1zlRUh
	 Zp5HCNuASZEryC5jzdehb0JIiVbVPOQlyBUftDm6Beia32ijx9Vl1LVqj1vGS/axNH
	 eIpEFwWONLEVksqvgJJBb+LJfrZwoXvQj1LFMXnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/377] net: ethtool: fix NULL pointer dereference in phy_reply_size
Date: Thu, 28 May 2026 21:45:14 +0200
Message-ID: <20260528194640.572132464@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Sun <2022090917019@std.uestc.edu.cn>

[ Upstream commit 4908f1395fb1b832ceec11584af649874a2732ea ]

In phy_prepare_data(), several strings such as 'name', 'drvname',
'upstream_sfp_name', and 'downstream_sfp_name' are allocated using
kstrdup(). However, these allocations were not checked  for failure.

If kstrdup() fails for 'name', it returns NULL while the function
continues. This leads to a kernel NULL pointer dereference and panic
later in phy_reply_size() when it unconditionally calls strlen() on
the NULL pointer.

While other strings like 'upstream_sfp_name' might be checked before
access in certain code paths, failing to handle these allocations
consistently can lead to incomplete data reporting or hidden bugs.

Fix this by adding proper NULL checks for all kstrdup() calls in
phy_prepare_data() and implement a centralized error handling path
using goto labels to ensure all previously allocated resources are
freed on failure.

Fixes: 9dd2ad5e92b9 ("net: ethtool: phy: Convert the PHY_GET command to generic phy dump")
Signed-off-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260507131738.1173835-1-2022090917019@std.uestc.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e3adf69f8eb1 ("net: ethtool: phy: avoid NULL deref when PHY driver is unbound")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/phy.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/net/ethtool/phy.c
+++ b/net/ethtool/phy.c
@@ -76,6 +76,7 @@ static int phy_prepare_data(const struct
 	struct nlattr **tb = info->attrs;
 	struct phy_device_node *pdn;
 	struct phy_device *phydev;
+	int ret;
 
 	/* RTNL is held by the caller */
 	phydev = ethnl_req_get_phydev(req_info, tb, ETHTOOL_A_PHY_HEADER,
@@ -88,8 +89,17 @@ static int phy_prepare_data(const struct
 		return -EOPNOTSUPP;
 
 	rep_data->phyindex = phydev->phyindex;
+
 	rep_data->name = kstrdup(dev_name(&phydev->mdio.dev), GFP_KERNEL);
+	if (!rep_data->name)
+		return -ENOMEM;
+
 	rep_data->drvname = kstrdup(phydev->drv->name, GFP_KERNEL);
+	if (!rep_data->drvname) {
+		ret = -ENOMEM;
+		goto err_free_name;
+	}
+
 	rep_data->upstream_type = pdn->upstream_type;
 
 	if (pdn->upstream_type == PHY_UPSTREAM_PHY) {
@@ -97,15 +107,33 @@ static int phy_prepare_data(const struct
 		rep_data->upstream_index = upstream->phyindex;
 	}
 
-	if (pdn->parent_sfp_bus)
+	if (pdn->parent_sfp_bus) {
 		rep_data->upstream_sfp_name = kstrdup(sfp_get_name(pdn->parent_sfp_bus),
 						      GFP_KERNEL);
+		if (!rep_data->upstream_sfp_name) {
+			ret = -ENOMEM;
+			goto err_free_drvname;
+		}
+	}
 
-	if (phydev->sfp_bus)
+	if (phydev->sfp_bus) {
 		rep_data->downstream_sfp_name = kstrdup(sfp_get_name(phydev->sfp_bus),
 							GFP_KERNEL);
+		if (!rep_data->downstream_sfp_name) {
+			ret = -ENOMEM;
+			goto err_free_upstream_sfp;
+		}
+	}
 
 	return 0;
+
+err_free_upstream_sfp:
+	kfree(rep_data->upstream_sfp_name);
+err_free_drvname:
+	kfree(rep_data->drvname);
+err_free_name:
+	kfree(rep_data->name);
+	return ret;
 }
 
 static int phy_fill_reply(struct sk_buff *skb,


