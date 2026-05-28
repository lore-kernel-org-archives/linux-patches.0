Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB3033F5B4;
	Thu, 28 May 2026 19:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998122; cv=none; b=l3lWyat4fSCtuef7HrqFwKiRLgeeAZDzGsnpR3gjNkQMMSkswg5V0mKV0itaHMHIfbYuw3XBQeQXP4r+XGEalVQBtntbYETNpNhb4UZqkJrrDzFvl7YJNTf96f6d8wMhJaNWvybHhleKMEQK1UWO2HN1rwPTYKNuxY7VnlNZ734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998122; c=relaxed/simple;
	bh=UAkWGcEgsBRZPS+u9bzHoIB9QeYqJ5ku8vHqoRk5g3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYGr0BuPDrSgzN4j9wt7mdnEwL33UNumvxnioHr0pVpoQ23D590CCchVClKRcaNzO8rjNTTPzoAl3BjXNKk80isSM0C9U1FybevunWOrzLeIJLu45uN/dWe+237p9hP9lemV501tXXYgHbcQPTFW255C93g6PiJksklh1jAOOfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWVGjgSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWVGjgSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0773C1F000E9;
	Thu, 28 May 2026 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998121;
	bh=ClFNWMDIr6l62gUspDnDzPQFjF29xgRGE04/FVpwA1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWVGjgSFSgFrK6UH4cFFAtk8l2hDKc2bHHxw9Ho0h0O+JJ4AsLGvhJLNRY0Z4GZ/n
	 y0qeAY8q767+zh/JrwNAttYBb+zRGW/py92jbpb1uZUPDGdsO6So9nu4RKh/FAR9SD
	 /1jV2pLwdWwabWwtRuPIPv6+X2YxSITjHhGJubr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 061/461] net: ethtool: fix NULL pointer dereference in phy_reply_size
Date: Thu, 28 May 2026 21:43:10 +0200
Message-ID: <20260528194648.680218030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


