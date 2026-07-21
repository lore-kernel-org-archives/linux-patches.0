Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07846C4A6;
	Tue, 21 Jul 2026 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662886; cv=none; b=onpjtHNmKG1pwu+0AoLk3/YHiNKjprtR+l19TwhpcuUUoYRYe5GQUdYpSSsbzN8V7mVnVNrql5+axf7U946O43hJlvq+m6ncYckWmkoTA48YqBpA8YgFZINVqwU1gtikZkoD3iSCrmXVldbflV9230dEp/+G57wMMNCa3hAyYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662886; c=relaxed/simple;
	bh=lxZDdA8ohP/iNZaTXKalfVmbBSGaJtXWqZRDCSVol2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZJkyR9hAhdeme2q4jWST/OHVDmOFDd6dmo1lKpZAOwVNHLSHDpwgvfBB1QrSPAE012ZLpytHgveU16wcT8j7AQZWWUNbQE2gtXXD5KdmtTIbmPP4uluQgH89MwSaAE/uzWveGA/rDj+EFU9snBiTq3ZiyFESbaXutfVoTYC/9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2++kHWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2++kHWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E05F1F000E9;
	Tue, 21 Jul 2026 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662885;
	bh=tzlDtpVQIVwKncGxIyt9R0se/tIaruubp/bBrGybuo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2++kHWg++QtQGLiyVXULnqNi4csxzI4Gl/oArthe1P5s1znKE5UW3tNeXaN2neiW
	 +mq9AgZoOeuzMHSXyWXBvgVwGwJs2+/wm1M6uus7NI4wKA+LZi34uj/5YBa2csku8/
	 l8D3aFanWTS9iJCJH/VLUe6U+WJH1xdNMHi22tXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0615/1276] dpaa2-switch: do not accept VLAN uppers while bridged
Date: Tue, 21 Jul 2026 17:17:38 +0200
Message-ID: <20260721152459.871816618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5faf48a63c857c..4520c2788b1c56 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2197,6 +2197,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 static int dpaa2_switch_port_prechangeupper(struct net_device *netdev,
 					    struct netdev_notifier_changeupper_info *info)
 {
+	struct ethsw_port_priv *port_priv;
 	struct netlink_ext_ack *extack;
 	struct net_device *upper_dev;
 	int err;
@@ -2215,6 +2216,13 @@ static int dpaa2_switch_port_prechangeupper(struct net_device *netdev,
 
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



