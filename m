Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EC6282F17;
	Thu, 28 May 2026 20:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999572; cv=none; b=uYlF3MfCDN3NFzjoJoaWw575LyPmcwAu0uLedkgFRjgq8MvjW+4oUHhC+ct4Bwgi/slhbLTizjq53EaKbKISDskIcwsp9ofI8Ks6A189wP0sGHLuMAsckr4VptOles5xiXZUHTWpOCrQeMHyjtaCNjbPAm/c3EN33r8oRl3uj+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999572; c=relaxed/simple;
	bh=NN0GtpwL5zbwn9ouzInVHmVIrFTlqcL60KwyA3oRawY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZrPzD7XbRNvg3bTRdjxW3NLExOt3L5hMnfGqW+OZm1p2WwCHv3UXeedH8bjMB1gXSXB9UPQ5PDoNWbFl9bUL5NzE9RMNf9eYUCNM1X5HCx1psmx9MFOAq2voJ3RlssC0W7S7ijVmJ+3JSDoVxupBeYIzOQCweZfXHBvYRl9nZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4sDPaA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4sDPaA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319731F000E9;
	Thu, 28 May 2026 20:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999571;
	bh=qQNB1fSGVEE33DCPK54UL+YzwViqhM1rMCTV5Bwroz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4sDPaA+PLGRZgCcBHw6T/j/TfVRvebEP+ZS87su57lh6+oEfaKAs/uDs30PdZrWg
	 Oh1TNbc1jeBVLT1/7JmFCPwpzVGeTl5XAMzhp/+YjkbWgTBYJtqcLf6HnlqwvAiMqW
	 YNmRBIYvFQCkdeb4u6nhVcEQaJenF7K8D5OYrOX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/377] net: ethtool: phy: avoid NULL deref when PHY driver is unbound
Date: Thu, 28 May 2026 21:45:15 +0200
Message-ID: <20260528194640.602747042@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit e3adf69f8eb121a9128c2b0029efd050d3649153 ]

phydev->drv can become NULL while the phy_device is still attached to
its net_device, namely after the PHY driver is unbound via sysfs:

	echo <mdio_id> > /sys/bus/mdio_bus/drivers/<phy_drv>/unbind

phy_remove() clears phydev->drv but doesn't call phy_detach(), so the
phy_device stays in the link topology xarray and ethnl_req_get_phydev()
still hands it back. ETHTOOL_MSG_PHY_GET then oopses on:

	rep_data->drvname = kstrdup(phydev->drv->name, GFP_KERNEL);

drvname is already treated as optional by phy_reply_size(),
phy_fill_reply() and phy_cleanup_data(), so just skip the allocation
when there is no driver bound.

Fixes: 9dd2ad5e92b9 ("net: ethtool: phy: Convert the PHY_GET command to generic phy dump")
Cc: stable@vger.kernel.org # 6.13.x
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260509215046.107157-1-devnexen@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ethtool/phy.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/ethtool/phy.c
+++ b/net/ethtool/phy.c
@@ -94,10 +94,12 @@ static int phy_prepare_data(const struct
 	if (!rep_data->name)
 		return -ENOMEM;
 
-	rep_data->drvname = kstrdup(phydev->drv->name, GFP_KERNEL);
-	if (!rep_data->drvname) {
-		ret = -ENOMEM;
-		goto err_free_name;
+	if (phydev->drv) {
+		rep_data->drvname = kstrdup(phydev->drv->name, GFP_KERNEL);
+		if (!rep_data->drvname) {
+			ret = -ENOMEM;
+			goto err_free_name;
+		}
 	}
 
 	rep_data->upstream_type = pdn->upstream_type;


