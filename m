Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E6E15EA3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnN4vZHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ADDC433C8;
	Mon, 23 Oct 2023 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061181;
	bh=SVAx4ZqVTPJvK3CfK7isfNlAmwd/D+qlXAOuVhmxVvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnN4vZHoCo306E3Pw0iMYkUn3nVEOFvjro7XBPLSRpuNYUYkGpTCmIlpDTYI/pbAC
	 i8M2WQRlGaQN9yS4Pv6uQazxxfgO1qgfI3iDmV/6C2x/HKxkkESRxEpaGScegF1nlH
	 hZZdtnu2cEzkGO6T7gyryUWHohSu3nIxcfkpvBSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/137] net: introduce a function to check if a netdev name is in use
Date: Mon, 23 Oct 2023 12:57:36 +0200
Message-ID: <20231023104824.206159481@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 75ea27d0d62281c31ee259c872dfdeb072cf5e39 ]

__dev_get_by_name is currently used to either retrieve a net device
reference using its name or to check if a name is already used by a
registered net device (per ns). In the later case there is no need to
return a reference to a net device.

Introduce a new helper, netdev_name_in_use, to check if a name is
currently used by a registered net device without leaking a reference
the corresponding net device. This helper uses netdev_name_node_lookup
instead of __dev_get_by_name as we don't need the extra logic retrieving
a reference to the corresponding net device.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 311cca40661f ("net: fix ifname in netlink ntf during netns move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b5df2e59a51d3..132f4344fee9f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2978,6 +2978,7 @@ struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
+bool netdev_name_in_use(struct net *net, const char *name);
 int dev_alloc_name(struct net_device *dev, const char *name);
 int dev_open(struct net_device *dev, struct netlink_ext_ack *extack);
 void dev_close(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4d698ccf41726..d269c1760fa45 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -303,6 +303,12 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
 	return NULL;
 }
 
+bool netdev_name_in_use(struct net *net, const char *name)
+{
+	return netdev_name_node_lookup(net, name);
+}
+EXPORT_SYMBOL(netdev_name_in_use);
+
 int netdev_name_node_alt_create(struct net_device *dev, const char *name)
 {
 	struct netdev_name_node *name_node;
@@ -1135,7 +1141,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 	}
 
 	snprintf(buf, IFNAMSIZ, name, i);
-	if (!__dev_get_by_name(net, buf))
+	if (!netdev_name_in_use(net, buf))
 		return i;
 
 	/* It is possible to run out of possible slots
@@ -1189,7 +1195,7 @@ static int dev_get_valid_name(struct net *net, struct net_device *dev,
 
 	if (strchr(name, '%'))
 		return dev_alloc_name_ns(net, dev, name);
-	else if (__dev_get_by_name(net, name))
+	else if (netdev_name_in_use(net, name))
 		return -EEXIST;
 	else if (dev->name != name)
 		strlcpy(dev->name, name, IFNAMSIZ);
@@ -11170,7 +11176,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	 * we can use it in the destination network namespace.
 	 */
 	err = -EEXIST;
-	if (__dev_get_by_name(net, dev->name)) {
+	if (netdev_name_in_use(net, dev->name)) {
 		/* We get here if we can't use the current device name */
 		if (!pat)
 			goto out;
@@ -11522,7 +11528,7 @@ static void __net_exit default_device_exit(struct net *net)
 
 		/* Push remaining network devices to init_net */
 		snprintf(fb_name, IFNAMSIZ, "dev%d", dev->ifindex);
-		if (__dev_get_by_name(&init_net, fb_name))
+		if (netdev_name_in_use(&init_net, fb_name))
 			snprintf(fb_name, IFNAMSIZ, "dev%%d");
 		err = dev_change_net_namespace(dev, &init_net, fb_name);
 		if (err) {
-- 
2.40.1



