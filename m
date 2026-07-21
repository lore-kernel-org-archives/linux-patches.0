Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22536471248;
	Tue, 21 Jul 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657727; cv=none; b=lfNr0NvWXOr5iKjopPUmllNAGtQqvDbLaatbKJavYXui2TZRAeh7OjrLutle0jLLEjuVGAMq165LSTY9w9M8F6ull6doH8Z+c/JcaE14gboZcIv4bphGiEIkaB2j/WILdD20EEUdr9A/ZZYp+sC6F674zbdjvuaatAW1RpDR14M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657727; c=relaxed/simple;
	bh=5071v/dK7FWR6LJ5lCzK03WZkfuO/vmKED0JfZU+Wrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wpko/+QD384znBx5THeDDx6S8axHJP08VI0ZedB3fvDdkHyZZO+CrC9F2f+b0wFv/6tHTfmiS9BzheH6ZgHScpfNKEzjF3h82akCCzFU/4Cw+zpc4vUPEBgCA+syABbKHPxODyohLs0bBoE8Cu4OLf2VWh4sWDi0fYKH1BI01dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYDJ4Pcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYDJ4Pcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C791F000E9;
	Tue, 21 Jul 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657725;
	bh=6kzrGvG/dQR/eUxGufVnVOIsSLZEo9ymukHNy9yUqec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYDJ4Pccb8ggFGJDBLvVuJSbhC6ZH1r1N3AoIIB4Yd8Z2kz9PAb5JY84QhitUVd7b
	 nIdQNqow0Qbls+Yv23zdHaMmk8gBl51G0BHdRfoFqkZSynRuRGuRbsBDFVInwcyMUL
	 1pkoGMh1CKo3yTzm1uCuHX/eHsX4HCP+LbxZozG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0873/1611] dpaa2-switch: do not accept VLAN uppers while bridged
Date: Tue, 21 Jul 2026 17:16:29 +0200
Message-ID: <20260721152535.027494838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit d07d80b6a129a44538cda1549b7acf95154fb197 ]

The dpaa2-switch driver does not support VLAN uppers while its ports are
bridged. This scenario tried to be prevented by rejecting a bridge join
while VLAN uppers exist but the reverse order was still possible.

This patches adds a check so that the dpaa2-switch also does not accept
VLAN uppers while bridged.

Fixes: f48298d3fbfa ("staging: dpaa2-switch: move the driver out of staging")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260618092813.432535-2-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 28ac76b8783c3c..789a46f6938eea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2198,6 +2198,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 static int dpaa2_switch_port_prechangeupper(struct net_device *netdev,
 					    struct netdev_notifier_changeupper_info *info)
 {
+	struct ethsw_port_priv *port_priv;
 	struct netlink_ext_ack *extack;
 	struct net_device *upper_dev;
 	int err;
@@ -2216,6 +2217,13 @@ static int dpaa2_switch_port_prechangeupper(struct net_device *netdev,
 
 		if (!info->linking)
 			dpaa2_switch_port_pre_bridge_leave(netdev);
+	} else if (is_vlan_dev(upper_dev)) {
+		port_priv = netdev_priv(netdev);
+		if (port_priv->fdb->bridge_dev) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot accept VLAN uppers while bridged");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
-- 
2.53.0



