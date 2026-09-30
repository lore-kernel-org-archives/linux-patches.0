Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562DE3D9526;
	Wed, 30 Sep 2026 19:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795928; cv=none; b=e/pmLYOQummk4U1QIXmZygr6b4PaZ2dwTVy3vkRKC+hIUFAUJ4nf6AjVh1u/nynnWK9EWz/G8WzIlUZWKlS33vAvKKdpeHCuO5PzWbfFx+YU8y8WaotUzdeJelnlYGFS9S1154IMims6OCB/6TJhSV3AChcqvTZwxrvs2e2UiWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795928; c=relaxed/simple;
	bh=BqVlQGXvWj/+V6B4CcRFB9UFujXRRrjg8Ve87k/O5Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF3bRh0Ysjz7zdIKiiIXp2X9xqAeDlcx2d9E0eQrHc5ZkTkgSwvMQDveRgUB58hnWUgz6LbkgBNBfm2uskOEdxrOtbO8plDgGtJ04gqJreD5bLBEHuuE7TxDV/s2FHZfaLNT5KyWhF2AzbspiMxFrL27z6JQytv5KH+rFJcExQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqI6i/Bc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqI6i/Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90E11F000FF;
	Wed, 30 Sep 2026 19:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795927;
	bh=sDeMD8fVSaEoY8VsCKcvVoG/UPeLUTq7AqNDBP1nvZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqI6i/BcympKdaoYNz/EoMTv6ooLpPJPux37yd7x3J9TyiRveefN0TJfOxbHr0ujf
	 2RTc0axU+QHKSzt8Qinl0gj6CpEgCMyvFlhLehVszyZ0KxsshWc9/GgBznaMyMvUc5
	 9jdjXegHzhZaSiKARhPUl8vT3hUTw8my5W1yfqHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0733/1193] net: convert dev->reg_state to u8
Date: Wed, 30 Sep 2026 17:23:37 +0200
Message-ID: <20260930152450.539214704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4d42b37def70327b2bb19f823d42289aed2cd7c7 ]

Prepares things so that dev->reg_state reads can be lockless,
by adding WRITE_ONCE() on write side.

READ_ONCE()/WRITE_ONCE() do not support bitfields.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ef9fbe1b93f3 ("RDMA/core: Reject unregistering netdevs in ib_get_eth_speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 23 ++++++++++++++---------
 net/core/dev.c            |  8 ++++----
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b6e63bcfff30a..fdd3ae0a506ea 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1795,6 +1795,15 @@ enum netdev_stat_type {
 	NETDEV_PCPU_STAT_DSTATS, /* struct pcpu_dstats */
 };
 
+enum netdev_reg_state {
+	NETREG_UNINITIALIZED = 0,
+	NETREG_REGISTERED,	/* completed register_netdevice */
+	NETREG_UNREGISTERING,	/* called unregister_netdevice */
+	NETREG_UNREGISTERED,	/* completed unregister todo */
+	NETREG_RELEASED,	/* called free_netdev */
+	NETREG_DUMMY,		/* dummy device for NAPI poll */
+};
+
 /**
  *	struct net_device - The DEVICE structure.
  *
@@ -2325,13 +2334,7 @@ struct net_device {
 
 	struct list_head	link_watch_list;
 
-	enum { NETREG_UNINITIALIZED=0,
-	       NETREG_REGISTERED,	/* completed register_netdevice */
-	       NETREG_UNREGISTERING,	/* called unregister_netdevice */
-	       NETREG_UNREGISTERED,	/* completed unregister todo */
-	       NETREG_RELEASED,		/* called free_netdev */
-	       NETREG_DUMMY,		/* dummy device for NAPI poll */
-	} reg_state:8;
+	u8 reg_state;
 
 	bool dismantle;
 
@@ -5277,7 +5280,9 @@ static inline const char *netdev_name(const struct net_device *dev)
 
 static inline const char *netdev_reg_state(const struct net_device *dev)
 {
-	switch (dev->reg_state) {
+	u8 reg_state = READ_ONCE(dev->reg_state);
+
+	switch (reg_state) {
 	case NETREG_UNINITIALIZED: return " (uninitialized)";
 	case NETREG_REGISTERED: return "";
 	case NETREG_UNREGISTERING: return " (unregistering)";
@@ -5286,7 +5291,7 @@ static inline const char *netdev_reg_state(const struct net_device *dev)
 	case NETREG_DUMMY: return " (dummy)";
 	}
 
-	WARN_ONCE(1, "%s: unknown reg_state %d\n", dev->name, dev->reg_state);
+	WARN_ONCE(1, "%s: unknown reg_state %d\n", dev->name, reg_state);
 	return " (unknown)";
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 290fb19c5dd76..36a6d621c10a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10341,7 +10341,7 @@ int register_netdevice(struct net_device *dev)
 
 	ret = netdev_register_kobject(dev);
 	write_lock(&dev_base_lock);
-	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	WRITE_ONCE(dev->reg_state, ret ? NETREG_UNREGISTERED : NETREG_REGISTERED);
 	write_unlock(&dev_base_lock);
 	if (ret)
 		goto err_uninit_notify;
@@ -10634,7 +10634,7 @@ void netdev_run_todo(void)
 		}
 
 		write_lock(&dev_base_lock);
-		dev->reg_state = NETREG_UNREGISTERED;
+		WRITE_ONCE(dev->reg_state, NETREG_UNREGISTERED);
 		write_unlock(&dev_base_lock);
 		linkwatch_forget_dev(dev);
 	}
@@ -11049,7 +11049,7 @@ void free_netdev(struct net_device *dev)
 	}
 
 	BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
-	dev->reg_state = NETREG_RELEASED;
+	WRITE_ONCE(dev->reg_state, NETREG_RELEASED);
 
 	/* will free via device release */
 	put_device(&dev->dev);
@@ -11138,7 +11138,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		/* And unlink it from device chain. */
 		write_lock(&dev_base_lock);
 		unlist_netdevice(dev, false);
-		dev->reg_state = NETREG_UNREGISTERING;
+		WRITE_ONCE(dev->reg_state, NETREG_UNREGISTERING);
 		write_unlock(&dev_base_lock);
 	}
 	flush_all_backlogs();
-- 
2.53.0



