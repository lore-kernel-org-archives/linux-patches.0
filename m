Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88087471252;
	Tue, 21 Jul 2026 19:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660990; cv=none; b=TEgaNiFOjNZPLpJ1NLVRmCN77ItA8KTh0/hudFPDCoLAu+Mv5c0iQb4IHWZTyB4VwpRreNVHENiF2AGgT1XiIbUeQ7lF7lcYqWJx6PG2BYAqhI/NgyhbSyxtI5GxdZH5TfQQukTvd1wVoQ2/F+WyVJtdMs2fl2L6u9E6xSsi8b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660990; c=relaxed/simple;
	bh=LPlm67sk75cNh5UH9vnkLn3mqU1b770FBO7GfvltN1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOo+LdR9QixP5ZALov2tWM7uSEyvi+xOYTa5493+Ay8ayeJlQ26Nve2e9j8bYsPVICJwKfk8TcX9vGgEFJjmarEKH80Bk1lVasVn39etpRY+0SwkrhLhmAobIPtVHxdjU60tudLvuIA92K640LcItzOv/muWtBSqu7BvS6fYgRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+F3XBeE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+F3XBeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5121F000E9;
	Tue, 21 Jul 2026 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660989;
	bh=7r4XhsGLiZI6SES63zdhXg+VJBvcfPAklWgYTBlBL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+F3XBeEEJ52uFguPSPdNZXd/0Zv27bRIGSMbmX4Z5eEDuTjV3U9i5naPH8yALT5J
	 +vQ1wk5iMzLgRUm84pTXj7mPFVkJo2oMpGVBtkbE9g9kzvu+5B6OMQGBfzSgBtRXy4
	 ciigtZwIi7LhLwSvYULtcavoVwkT27w4CxXxMCJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1188/2077] dpaa2-switch: do not accept VLAN uppers while bridged
Date: Tue, 21 Jul 2026 17:14:21 +0200
Message-ID: <20260721152620.839753316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46ae81c2fa013a..fa4e4f47978234 100644
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



