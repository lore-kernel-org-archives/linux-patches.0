Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F791AF0C0;
	Wed, 19 Feb 2025 08:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954536; cv=none; b=BoGnMoo7fIT7zOh4/AdKclqChgRdkwrIoseJ9oGIVvVrGiJQTcMFUw6H02HZKgvOM9dR/D+pZ9JGCGO8SAdl73g7t4LjBPVE3OFqu3ozkEwUz672n9NaaicjHKsOCmLTCHg5QPnv2crlJYIxYG0Dk5D1hqcaiGh+KqXWY27kwLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954536; c=relaxed/simple;
	bh=jjzw1kmhezodiER2xMW+2x0NHsd3E7gPZvWTWo8Ebs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+uiHeRHaNJ+w1GTd9LQEn9mxvuRCyOLTGXzleL3JQL+BJPyFcJazAaBI46w8WxMKZzPTaMmYKCFMqcF5eR7n+jCQsxVxUaUDTRvhQkMayx5qW/rMcX9WXDEDq98K89tWNsbctDMjET2FeFgoeGLuPfTt0NF+pUrxK5BBatPZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geR+XHlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geR+XHlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAE9C4CED1;
	Wed, 19 Feb 2025 08:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954536;
	bh=jjzw1kmhezodiER2xMW+2x0NHsd3E7gPZvWTWo8Ebs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geR+XHlUFCfKTzN7ejBf4pWTbeY991c5fKYDr/ahpvssZ9rBMLiKZhrdNmIY1kri2
	 tiayKKjPBIK6WIqAAxg0Hr/j8K3xM6gCvXdjcWK9o1VV3EBpJibOLqIOsUliF+HGoY
	 V2OpfM+CH2Q0247DLmWWpL7pSbgLWHYs3TeCBUSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 233/274] net: add netdev->up protected by netdev_lock()
Date: Wed, 19 Feb 2025 09:28:07 +0100
Message-ID: <20250219082618.698868926@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5112457f3d8e41f987908266068af88ef9f3ab78 ]

Some uAPI (netdev netlink) hide net_device's sub-objects while
the interface is down to ensure uniform behavior across drivers.
To remove the rtnl_lock dependency from those uAPIs we need a way
to safely tell if the device is down or up.

Add an indication of whether device is open or closed, protected
by netdev->lock. The semantics are the same as IFF_UP, but taking
netdev_lock around every write to ->flags would be a lot of code
churn.

We don't want to blanket the entire open / close path by netdev_lock,
because it will prevent us from applying it to specific structures -
core helpers won't be able to take that lock from any function
called by the drivers on open/close paths.

So the state of the flag is "pessimistic", as in it may report false
negatives, but never false positives.

Reviewed-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250115035319.559603-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 14 +++++++++++++-
 net/core/dev.c            |  4 ++--
 net/core/dev.h            | 12 ++++++++++++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 47f817bcea503..64013fd389f28 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2441,12 +2441,24 @@ struct net_device {
 	unsigned long		gro_flush_timeout;
 	u32			napi_defer_hard_irqs;
 
+	/**
+	 * @up: copy of @state's IFF_UP, but safe to read with just @lock.
+	 *	May report false negatives while the device is being opened
+	 *	or closed (@lock does not protect .ndo_open, or .ndo_close).
+	 */
+	bool			up;
+
 	/**
 	 * @lock: netdev-scope lock, protects a small selection of fields.
 	 * Should always be taken using netdev_lock() / netdev_unlock() helpers.
 	 * Drivers are free to use it for other protection.
 	 *
-	 * Protects: @reg_state, @net_shaper_hierarchy.
+	 * Protects:
+	 *	@net_shaper_hierarchy, @reg_state
+	 *
+	 * Partially protects (writers must hold both @lock and rtnl_lock):
+	 *	@up
+	 *
 	 * Ordering: take after rtnl_lock.
 	 */
 	struct mutex		lock;
diff --git a/net/core/dev.c b/net/core/dev.c
index 75996e1aac46c..67f2bb84db543 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1512,7 +1512,7 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (ret)
 		clear_bit(__LINK_STATE_START, &dev->state);
 	else {
-		dev->flags |= IFF_UP;
+		netif_set_up(dev, true);
 		dev_set_rx_mode(dev);
 		dev_activate(dev);
 		add_device_randomness(dev->dev_addr, dev->addr_len);
@@ -1591,7 +1591,7 @@ static void __dev_close_many(struct list_head *head)
 		if (ops->ndo_stop)
 			ops->ndo_stop(dev);
 
-		dev->flags &= ~IFF_UP;
+		netif_set_up(dev, false);
 		netpoll_poll_enable(dev);
 	}
 }
diff --git a/net/core/dev.h b/net/core/dev.h
index deb5eae5749fa..e17c640c05fb9 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -111,6 +111,18 @@ void __dev_notify_flags(struct net_device *dev, unsigned int old_flags,
 void unregister_netdevice_many_notify(struct list_head *head,
 				      u32 portid, const struct nlmsghdr *nlh);
 
+static inline void netif_set_up(struct net_device *dev, bool value)
+{
+	if (value)
+		dev->flags |= IFF_UP;
+	else
+		dev->flags &= ~IFF_UP;
+
+	netdev_lock(dev);
+	dev->up = value;
+	netdev_unlock(dev);
+}
+
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
-- 
2.39.5



