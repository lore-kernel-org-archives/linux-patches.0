Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621606;
	b=gGWwBkt0HqAMOQbx6+SqQXSVoE6L60XX4qf0LOsj4/czJv2ZOxZyTdDYW8WOv7xs3asn
	 +HyiIUtMLFHL2ZRj1B/pn2mb5v3BncQ51RMZqTaaGwKxSSLfEc1W5E+jI6Ug9eq/0JE44
	 xbT4KANiM+yDzuWCc1Ipgjf3GQfdvzDp660XW9aeiwUHzUnv2q0rlJcAOlzuekPrMS4Tm
	 E0VkuGnZo429CRQ40f3SL5wa2eNJTFnhWKKF1xt9sqIQhkuZhqdbmsMrU/7/vyO06aKpC
	 shMUVuR/VfhjatlERrsjAyyHlAOAS0zMnxWrzi58xx8T15HJdlWZkl3/lmzXGxXq9kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ouc93kVm2sJYTKblfdSUJF0C6Ws3/O3XppwRa7Vxy0=;
	b=N6mKqy4IBbGu5XNDMvnKWdtGW8euiwaXlG/8PxFfJid1SUrd89RCs15xbu1ffgKEPtGd
	 g62g+HIfwYENC8prCZrR8KSltVoZW0LLxee8zjVsE/Q+27dDSP0bwQ6ZfT/M59a00+4xE
	 uDXHesj16msuuXOzA9wG/EF/VP63QAwIUpt1zeXzr/RUL3dDxkqmf1/JRvZtNeL7vz/fN
	 JUm2DBhVJ7IUoIUe5Tk2DWAjPJ2kVLcRm7dFEJSwUrzl8/SPowSI4f5baTJFZUH00UtuF
	 noVCeZ+LhZ3lVeMPLYhieKw9ZP7XCwflGG+6bBE73fhFIrfJxFv6vq3ruOX76YRumWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jMm9UX/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889CA606A335;
	Wed, 25 Nov 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMm9UX/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C117A1F0156E;
	Wed, 25 Nov 2026 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621606;
	bh=7ouc93kVm2sJYTKblfdSUJF0C6Ws3/O3XppwRa7Vxy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMm9UX/wFgulTM0mT561oRq0j5aF2ZYk/NY3TRn0v7NrRdG9RpRgYgZ512Y/ia7K8
	 JtWlnw/x9MXAExabZbK3wA4nH9us+zdfaePUTwF9xp0QH+QUMnvnIhEvZtrbU+Dq+8
	 WdADLqO7j6mGqM1SuG9BmQah6mqDjuZEFVbwTWYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/990] net: ethtool: add netif_get_link_ksettings() for correct ops-locked use
Date: Wed, 25 Nov 2026 15:27:26 +0100
Message-ID: <20261125143828.621505089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit f32fe1d79a18592b96342a0016cd62cf9601a054 ]

__ethtool_get_link_ksettings() is exported and called from sysfs
and many drivers. It invokes ethtool_ops->get_link_ksettings
so by our own docs it should be holding netdev lock for ops locked
devices. Looks like commit 2bcf4772e45a ("net: ethtool:
try to protect all callback with netdev instance lock")
missed adding the ops lock here.

There's a number of callers we need to fix up so let's add the
netif_get_link_ksettings() helper first, without any actual
locking changes (this commit is a nop).

Not treating this as a fix because I don't think any driver cares
at this point, but if we want to remove the rtnl_lock protection
this will become critical.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260603012840.2254293-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a76ab5e733b4 ("bonding: fix missing down path on speed/duplex failure after FAIL->UP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ethtool.h |  2 ++
 net/ethtool/ioctl.c     | 17 ++++++++++++++---
 net/ethtool/linkinfo.c  |  4 ++--
 net/ethtool/linkmodes.c |  4 ++--
 4 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 5c9162193d269..8c850fb53530b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -285,6 +285,8 @@ struct ethtool_link_ksettings {
 extern int
 __ethtool_get_link_ksettings(struct net_device *dev,
 			     struct ethtool_link_ksettings *link_ksettings);
+int netif_get_link_ksettings(struct net_device *dev,
+			     struct ethtool_link_ksettings *link_ksettings);
 
 struct ethtool_keee {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9431e305b2333..cb5d910844589 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -435,10 +435,10 @@ struct ethtool_link_usettings {
 };
 
 /* Internal kernel helper to query a device ethtool_link_settings. */
-int __ethtool_get_link_ksettings(struct net_device *dev,
-				 struct ethtool_link_ksettings *link_ksettings)
+int netif_get_link_ksettings(struct net_device *dev,
+			     struct ethtool_link_ksettings *link_ksettings)
 {
-	ASSERT_RTNL();
+	/* once callers fixed - assert ops locked */
 
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
@@ -449,6 +449,17 @@ int __ethtool_get_link_ksettings(struct net_device *dev,
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
 	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 }
+EXPORT_SYMBOL(netif_get_link_ksettings);
+
+/* Convenience helper for callers that hold only rtnl_lock(). */
+int __ethtool_get_link_ksettings(struct net_device *dev,
+				 struct ethtool_link_ksettings *link_ksettings)
+{
+	ASSERT_RTNL();
+
+	/* once callers fixed - take the ops lock around this call */
+	return netif_get_link_ksettings(dev, link_ksettings);
+}
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
 
 /* convert ethtool_link_usettings in user space to a kernel internal
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 30b8ce2751594..2d729acdaf031 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -34,7 +34,7 @@ static int linkinfo_prepare_data(const struct ethnl_req_info *req_base,
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
-	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
+	ret = netif_get_link_ksettings(dev, &data->ksettings);
 	if (ret < 0)
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 	ethnl_ops_complete(dev);
@@ -104,7 +104,7 @@ ethnl_set_linkinfo(struct ethnl_req_info *req_info, struct genl_info *info)
 	bool mod = false;
 	int ret;
 
-	ret = __ethtool_get_link_ksettings(dev, &ksettings);
+	ret = netif_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		return ret;
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 259cd9ef1f2a1..4ce4f29d2a7a0 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -39,7 +39,7 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
-	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
+	ret = netif_get_link_ksettings(dev, &data->ksettings);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		goto out;
@@ -324,7 +324,7 @@ ethnl_set_linkmodes(struct ethnl_req_info *req_info, struct genl_info *info)
 	bool mod = false;
 	int ret;
 
-	ret = __ethtool_get_link_ksettings(dev, &ksettings);
+	ret = netif_get_link_ksettings(dev, &ksettings);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
 		return ret;
-- 
2.53.0



