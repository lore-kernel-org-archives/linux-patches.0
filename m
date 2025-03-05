Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCEB2512FA;
	Wed,  5 Mar 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197152; cv=none; b=gwxLoi6D6EVEt3FMJVvIAaPdjmwXRhNUa05fdHe/0VmTpoPi/ASPgtN1jAJqqYAY1VZJqBJjZ4DSeZpv7xp6y1ponDpv3RqBOhsnhXk1hKfiysajPHE7/tHiLEOfZA8ljP7y4E8Z9uzHZ1mHpCdpJpZxqpTxUWjC4sWSWqcB9X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197152; c=relaxed/simple;
	bh=Hb6X0QZ7InjxgEkLtrgbD0FDfcly8dTvudjl86n7jy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyjJ2n79pTc0PttGwFnI9lALVAJCLevw9lAkR5SiaUAtBSgsgnvi1VNcAHurx0pcveRNUCmyTZzG1c0S2YlIva6R8E60ldWztFKNdqtJT3l1UNEl3DJPKWIxIip0ki+NMHSlcFmicBCdipbIwucjAZykp9QKjgv2nAsPm3djJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiOSDijP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiOSDijP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DDCC4CEE2;
	Wed,  5 Mar 2025 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197152;
	bh=Hb6X0QZ7InjxgEkLtrgbD0FDfcly8dTvudjl86n7jy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiOSDijPWUA2fFBW3cOpz/G+m+DSZXvE42tD06DKClK+weKgwzST1FxN5A04b677n
	 H5Aj7mRtyJy/eoUKbs+BVWd6J4syFtL0EcRpCMf/UrCugu4BfkPSCCS5Af0P1qF7mh
	 cdfWdg0WEgMpqdxy8Cc2FXL0KzhW2XP0duJ70Kiw=
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
Subject: [PATCH 6.1 057/176] net: Add non-RCU dev_getbyhwaddr() helper
Date: Wed,  5 Mar 2025 18:47:06 +0100
Message-ID: <20250305174507.748533697@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d0b4920dee730..f44701b82ea80 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3011,6 +3011,8 @@ static inline struct net_device *first_net_device_rcu(struct net *net)
 }
 
 int netdev_boot_setup_check(struct net_device *dev);
+struct net_device *dev_getbyhwaddr(struct net *net, unsigned short type,
+				   const char *hwaddr);
 struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
 				       const char *hwaddr);
 struct net_device *dev_getfirstbyhwtype(struct net *net, unsigned short type);
diff --git a/net/core/dev.c b/net/core/dev.c
index 90559cb668039..212a909b48405 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -921,6 +921,12 @@ int netdev_get_name(struct net *net, char *name, int ifindex)
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
@@ -929,7 +935,7 @@ int netdev_get_name(struct net *net, char *name, int ifindex)
  *
  *	Search for an interface by MAC address. Returns NULL if the device
  *	is not found or a pointer to the device.
- *	The caller must hold RCU or RTNL.
+ *	The caller must hold RCU.
  *	The returned device has not had its ref count increased
  *	and the caller must therefore be careful about locking
  *
@@ -941,14 +947,39 @@ struct net_device *dev_getbyhwaddr_rcu(struct net *net, unsigned short type,
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



