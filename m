Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767A151596E;
	Wed, 30 Sep 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787161; cv=none; b=ffvIiPkUOF4eQ9KjIArgNc5/h2PHZF9sU04BTwCAYydjbL7Ik8xuybnKpzExsLy9qn9MjaFE229MfbccdIvy88MPIlZajueGcHjyfV+iAn8Qr5gsy6owxhRgOk+rBvNuuV77r0kAf5BuBuNZMHadiZDvsD4bBpFGVzbe5wKJrKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787161; c=relaxed/simple;
	bh=3Hi0GxhaMVViE2hmviaqaZ6kbR9/19eGORVblQFyJvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8eyWMtfHJlL061eYVBdgteKC8DOUyVzQV4wcQkO56KgitLrMDZa5LENpmUjunZIgfri1ppAb7jXhq/WEF1GKc+HonoivoF18CBpNQk/YG6eBbEiKkeQyNIA8y7YUJrxrU/WUdS9QBn1ZqC5ONaCPtoLI9iRFt71Ns1+C9sLAMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJhdOKWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJhdOKWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A611F00899;
	Wed, 30 Sep 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787160;
	bh=1WiNTAlh1CAiRoLLvQ0gvMVnvo2tJaDFADA4VBY0Jlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJhdOKWUEFFssNYJVYbLKrM+5n1LBPxKFqsmTIlbZs+qm31a3hMoTK/u0Tk+gJXlN
	 XbEfNLMEZL0zfA2UNkZtAjETFOqSLuzdnOMzLzlzhvESarAnkzg5/o+qlOaYAQimRV
	 8s930VrmBk/e13qX54dWq6QvwOY6mBoTiwBX7eQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 133/457] net: dont require the hwtstamp NDOs when a PHY provides timestamping
Date: Wed, 30 Sep 2026 17:23:58 +0200
Message-ID: <20260930152348.918575083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 31995571219c8ac30913d9c0dccad033fbb0b3da ]

Removing the legacy ioctl fallback made both hwtstamp NDOs mandatory. A
device that only timestamps in its PHY implements neither, so
SIOCSHWTSTAMP fails with EOPNOTSUPP before anything looks at the PHY and
PTP stops working there.

The check only ever picked the legacy path. That path is gone, so drop it
and test where the NDOs are actually called.

SIOCGHWTSTAMP is new here, not restored. The old path went through
phy_mii_ioctl(), which only handled SIOCSHWTSTAMP.

Such a device now returns -ENODEV while absent instead of -EOPNOTSUPP,
like the ones that do implement the NDOs.

Fixes: 5062245a5a7f ("net: remove legacy way to get/set HW timestamp config")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260918095540.34286-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev_ioctl.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index a320e264eaaf0..164643140a523 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -276,19 +276,18 @@ int dev_get_hwtstamp_phylib(struct net_device *dev,
 	if (phy_is_default_hwtstamp(dev->phydev))
 		return phy_hwtstamp_get(dev->phydev, cfg);
 
+	if (!dev->netdev_ops->ndo_hwtstamp_get)
+		return -EOPNOTSUPP;
+
 	return dev->netdev_ops->ndo_hwtstamp_get(dev, cfg);
 }
 
 static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	struct kernel_hwtstamp_config kernel_cfg = {};
 	struct hwtstamp_config cfg;
 	int err;
 
-	if (!ops->ndo_hwtstamp_get)
-		return -EOPNOTSUPP;
-
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
@@ -359,12 +358,18 @@ int dev_set_hwtstamp_phylib(struct net_device *dev,
 	cfg->source = phy_ts ? HWTSTAMP_SOURCE_PHYLIB : HWTSTAMP_SOURCE_NETDEV;
 
 	if (phy_ts && dev->see_all_hwtstamp_requests) {
+		if (!ops->ndo_hwtstamp_get)
+			return -EOPNOTSUPP;
+
 		err = ops->ndo_hwtstamp_get(dev, &old_cfg);
 		if (err)
 			return err;
 	}
 
 	if (!phy_ts || dev->see_all_hwtstamp_requests) {
+		if (!ops->ndo_hwtstamp_set)
+			return -EOPNOTSUPP;
+
 		err = ops->ndo_hwtstamp_set(dev, cfg, extack);
 		if (err) {
 			if (extack->_msg)
@@ -390,7 +395,6 @@ int dev_set_hwtstamp_phylib(struct net_device *dev,
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	struct kernel_hwtstamp_config kernel_cfg = {};
 	struct netlink_ext_ack extack = {};
 	struct hwtstamp_config cfg;
@@ -413,9 +417,6 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return err;
 	}
 
-	if (!ops->ndo_hwtstamp_set)
-		return -EOPNOTSUPP;
-
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
@@ -441,15 +442,11 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 int generic_hwtstamp_get_lower(struct net_device *dev,
 			       struct kernel_hwtstamp_config *kernel_cfg)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
-	if (!ops->ndo_hwtstamp_get)
-		return -EOPNOTSUPP;
-
 	netdev_lock_ops(dev);
 	err = dev_get_hwtstamp_phylib(dev, kernel_cfg);
 	netdev_unlock_ops(dev);
@@ -462,15 +459,11 @@ int generic_hwtstamp_set_lower(struct net_device *dev,
 			       struct kernel_hwtstamp_config *kernel_cfg,
 			       struct netlink_ext_ack *extack)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
 	int err;
 
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
-	if (!ops->ndo_hwtstamp_set)
-		return -EOPNOTSUPP;
-
 	netdev_lock_ops(dev);
 	err = dev_set_hwtstamp_phylib(dev, kernel_cfg, extack);
 	netdev_unlock_ops(dev);
-- 
2.53.0



