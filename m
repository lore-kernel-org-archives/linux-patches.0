Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9153B19DE;
	Fri,  9 Oct 2026 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556154; cv=none; b=Edmn6PON1A53RetbGcpDyBhOVyQNjFbUicl9I6OAzHkWq7kjPIckZrMOIkz3XQgCmwJEaCfd0vRWauZNL762TVxoHkWnal0u41ikKgMfyTUtg6bPnDCxUaAFKu+vNZxt8jrO6SJ5kL3k5ZEEkTepvq7OzEycB8szoMe38A/uqTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556154; c=relaxed/simple;
	bh=kOmLoUUBg0a0R/4unlq9Tt6bgxLj9pKXDeh/Z3DL0/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjPCo6uMDZX1zrsPgAm/Hrxz3sDr+J9NXa+gQzCbCSKNrf3MVMF9IB1WYAlC9HZHQHrV/Jba16fnFQozkWhH8P0IbdCxuZ5kQkXXx5JBk8Zc+uENV46nMu/qUClQcC6UZVqJnDt5zvWzcKYWcGduuJMkZ5x8L8788W4AZf48vPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dypi4N7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dypi4N7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475731F000FF;
	Fri,  9 Oct 2026 14:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556152;
	bh=GbjpoRtWg2ciV9PK6Wd4ckRTOGadlA83tiiLQvdNpkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dypi4N7jhQnAlKPWqoxr5bkb7IP/U0xahweeFVWGq9rdUgYq0ItLcGJtgOAWM49yR
	 UgCvYepH53ZT9L9S3Pnp4x8y8sgExr/EGHgJttURbArDTTI1PoDvnJmBRtxQ/Hhk7K
	 2ChGxJZJdYYp8k2iW/IOTyViFp6wI/9d7YH9z2yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 129/428] net: ethtool: let tsconfig reach a PHY-only timestamp provider
Date: Fri,  9 Oct 2026 16:07:46 +0200
Message-ID: <20261009140949.019514419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

[ Upstream commit 036778a4fad19b54b73ae229a1901665aa8750a2 ]

TSCONFIG_GET and TSCONFIG_SET reject a device that implements neither
hwtstamp NDO, even when its PHY can serve the request. The ioctls they
meant to replace handle it, so the two interfaces disagree on the same
hardware and user space has to pick one.

Accept the default timestamping PHY and an already installed provider on
both sides. On the set side the test moves into ethnl_set_tsconfig() as
the validate callback runs without rtnl. On the get side it stays ahead
of ethnl_ops_begin(), so a device that can serve nothing keeps failing
with EOPNOTSUPP and a dump still skips it rather than stopping there.

A netdev provider needs ndo_hwtstamp_set to be programmed at all, so
don't pick that source without it, and test for ndo_hwtstamp_get before
calling it.

Fixes: 6e9e2eed4f39 ("net: ethtool: Add support for tsconfig command to get/set hwtstamp config")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260925135237.3432266-3-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev_ioctl.c   |  3 ++-
 net/ethtool/tsconfig.c | 24 ++++++++++--------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 164643140a523..f6029f60c1dc9 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -267,7 +267,8 @@ int dev_get_hwtstamp_phylib(struct net_device *dev,
 		    hwprov->phydev)
 			return phy_hwtstamp_get(hwprov->phydev, cfg);
 
-		if (hwprov->source == HWTSTAMP_SOURCE_NETDEV)
+		if (hwprov->source == HWTSTAMP_SOURCE_NETDEV &&
+		    dev->netdev_ops->ndo_hwtstamp_get)
 			return dev->netdev_ops->ndo_hwtstamp_get(dev, cfg);
 
 		return -EOPNOTSUPP;
diff --git a/net/ethtool/tsconfig.c b/net/ethtool/tsconfig.c
index 24b64862011f0..a2848ef0ddc4a 100644
--- a/net/ethtool/tsconfig.c
+++ b/net/ethtool/tsconfig.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/net_tstamp.h>
+#include <linux/phy.h>
 #include <linux/ptp_clock_kernel.h>
 #include <net/netdev_lock.h>
 
@@ -42,7 +43,9 @@ static int tsconfig_prepare_data(const struct ethnl_req_info *req_base,
 	struct kernel_hwtstamp_config cfg = {};
 	int ret;
 
-	if (!dev->netdev_ops->ndo_hwtstamp_get)
+	if (!dev->netdev_ops->ndo_hwtstamp_get &&
+	    !phy_is_default_hwtstamp(dev->phydev) &&
+	    !netdev_ops_lock_dereference(dev->hwprov, dev))
 		return -EOPNOTSUPP;
 
 	ret = ethnl_ops_begin(dev);
@@ -248,17 +251,6 @@ static int tsconfig_send_reply(struct net_device *dev, struct genl_info *info)
 	return ret;
 }
 
-static int ethnl_set_tsconfig_validate(struct ethnl_req_info *req_base,
-				       struct genl_info *info)
-{
-	const struct net_device_ops *ops = req_base->dev->netdev_ops;
-
-	if (!ops->ndo_hwtstamp_set || !ops->ndo_hwtstamp_get)
-		return -EOPNOTSUPP;
-
-	return 1;
-}
-
 static struct hwtstamp_provider *
 tsconfig_set_hwprov_from_desc(struct net_device *dev,
 			      struct genl_info *info,
@@ -272,7 +264,7 @@ tsconfig_set_hwprov_from_desc(struct net_device *dev,
 	int ret;
 
 	ret = ethtool_net_get_ts_info_by_phc(dev, &ts_info, hwprov_desc);
-	if (!ret) {
+	if (!ret && dev->netdev_ops->ndo_hwtstamp_set) {
 		/* Found */
 		source = HWTSTAMP_SOURCE_NETDEV;
 	} else {
@@ -313,6 +305,11 @@ static int ethnl_set_tsconfig(struct ethnl_req_info *req_base,
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
+	if (!dev->netdev_ops->ndo_hwtstamp_set &&
+	    !phy_is_default_hwtstamp(dev->phydev) &&
+	    !netdev_ops_lock_dereference(dev->hwprov, dev))
+		return -EOPNOTSUPP;
+
 	if (tb[ETHTOOL_A_TSCONFIG_HWTSTAMP_PROVIDER]) {
 		struct hwtstamp_provider_desc __hwprov_desc = {.index = -1};
 		struct hwtstamp_provider *__hwprov;
@@ -455,6 +452,5 @@ const struct ethnl_request_ops ethnl_tsconfig_request_ops = {
 	.reply_size		= tsconfig_reply_size,
 	.fill_reply		= tsconfig_fill_reply,
 
-	.set_validate		= ethnl_set_tsconfig_validate,
 	.set			= ethnl_set_tsconfig,
 };
-- 
2.53.0



