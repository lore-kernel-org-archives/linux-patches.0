Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D4233735;
	Mon, 10 Mar 2025 18:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630600; cv=none; b=uB/dxK6CkAo5yrfrAbOo+9JpzM8qJfF2FWBbe4kzNPbDR7VZ6iMotD2mFaMs3Md1RO6KPRXL70JlY80NViGroJXIv9yI0dG2V+L5NLn5rpvUdAkaESQrt4RY7hHlprbHnKgxCA3nPEnk3XtFTHKAazxO+odBo0DmxZ5MHjlXHvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630600; c=relaxed/simple;
	bh=wo8aHhft/orC3KrvTRrrX8UgiXf+F8q5Vp/wfq6Sovk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwrK2LVR0cjMs5IWT0UcBmrdphJoGLHRd9WfdrNMGavObRpwBCxrKjBJyW6jhBcGcmGQ1Z6MWp15VBi1u4mDaVVLd47QpAgExgcEU/aVVyAlETAW7XXz9qA7d4ZcFVxXwEZTYEwf0TicSUqD14csLR+yrUz+IsWeqbfnHNXzSWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwlVmV9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwlVmV9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0676DC4CEE5;
	Mon, 10 Mar 2025 18:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630600;
	bh=wo8aHhft/orC3KrvTRrrX8UgiXf+F8q5Vp/wfq6Sovk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwlVmV9hP343Rt2tXvElKrgWvGkpnk6ZAP8y1+jwIt8MceHOAvF8dmRfyHT7sX9W3
	 PToA1nyHFm9f1/SRg37VnpwtiY19Mwlo95BuTHIEsCwdWQ0FKFPea8Iu01e63f/vKE
	 b3OrN3ryNN2u6FUta/o6nvtpCpQihnR1XWivIg/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kuniyu@amazon.com,
	ushankar@purestorage.com,
	Eric Dumazet <edumazet@google.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 471/620] net: Add non-RCU dev_getbyhwaddr() helper
Date: Mon, 10 Mar 2025 18:05:17 +0100
Message-ID: <20250310170604.170003770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4b5a28b38c4a0106c64416a1b2042405166b26ce ]

Add dedicated helper for finding devices by hardware address when
holding rtnl_lock, similar to existing dev_getbyhwaddr_rcu(). This prevents
PROVE_LOCKING warnings when rtnl_lock is held but RCU read lock is not.

Extract common address comparison logic into dev_addr_cmp().

The context about this change could be found in the following
discussion:

Link: https://lore.kernel.org/all/20250206-scarlet-ermine-of-improvement-1fcac5@leitao/

Cc: kuniyu@amazon.com
Cc: ushankar@purestorage.com
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250218-arm_fix_selftest-v5-1-d3d6892db9e1@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4eae0ee0f1e6 ("arp: switch to dev_getbyhwaddr() in arp_req_set_public()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 79b528c128c14..179c569a55c42 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2966,6 +2966,8 @@ static inline struct net_device *first_net_device_rcu(struct net *net)
 }
 
 int netdev_boot_setup_check(struct net_device *dev);
+struct net_device *dev_getbyhwaddr(struct net *net, unsigned short type,
+				   const char *hwaddr);
 struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 				       const char *hwaddr);
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type);
diff --git a/net/core/dev.c b/net/core/dev.c
index 15ed4a79be46f..81f9fd0c5830a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -972,6 +972,12 @@ int netdev_get_name(struct net *net, char *name, int ifindex)
 	return ret;
 }
 
+static bool dev_addr_cmp(struct net_device *dev, unsigned short type,
+			 const char *ha)
+{
+	return dev->type == type && !memcmp(dev->dev_addr, ha, dev->addr_len);
+}
+
 /**
  *	dev_getbyhwaddr_rcu - find a device by its hardware address
  *	@net: the applicable net namespace
@@ -980,7 +986,7 @@ int netdev_get_name(struct net *net, char *name, int ifindex)
  *
  *	Search for an interface by MAC address. Returns NULL if the device
  *	is not found or a pointer to the device.
- *	The caller must hold RCU or RTNL.
+ *	The caller must hold RCU.
  *	The returned device has not had its ref count increased
  *	and the caller must therefore be careful about locking
  *
@@ -992,14 +998,39 @@ struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 	struct net_device *dev;
 
 	for_each_netdev_rcu(net, dev)
-		if (dev->type == type &&
-		    !memcmp(dev->dev_addr, ha, dev->addr_len))
+		if (dev_addr_cmp(dev, type, ha))
 			return dev;
 
 	return NULL;
 }
 EXPORT_SYMBOL(dev_getbyhwaddr_rcu);
 
+/**
+ * dev_getbyhwaddr() - find a device by its hardware address
+ * @net: the applicable net namespace
+ * @type: media type of device
+ * @ha: hardware address
+ *
+ * Similar to dev_getbyhwaddr_rcu(), but the owner needs to hold
+ * rtnl_lock.
+ *
+ * Context: rtnl_lock() must be held.
+ * Return: pointer to the net_device, or NULL if not found
+ */
+struct net_device *dev_getbyhwaddr(struct net *net, unsigned short type,
+				   const char *ha)
+{
+	struct net_device *dev;
+
+	ASSERT_RTNL();
+	for_each_netdev(net, dev)
+		if (dev_addr_cmp(dev, type, ha))
+			return dev;
+
+	return NULL;
+}
+EXPORT_SYMBOL(dev_getbyhwaddr);
+
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type)
 {
 	struct net_device *dev, *ret = NULL;
-- 
2.39.5



