Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414B234D916;
	Wed, 30 Sep 2026 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785712; cv=none; b=kTNiiUs49jmqZa26XEtpNZTNu11q0gBK8QRCIXLadEstbz3b4xghF6PEhUvWwPYjo0aH8SsLF1JDmBHG91Wks7Zw1TP1S5MK9XHkWcvrcdQH5paJCk5UvfNlZ1JIkbX386Q2mrIoGSlhtm3+5wmdGtoHgse3Qya73W85MYu0TuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785712; c=relaxed/simple;
	bh=F0uq63q32YIVW96/RU+xO1E7hWXIJmPGrdYlBljcBK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZbjGirQ7zm4Dz5Z2w5iSjl9P7U3030FVr6k4M0lDavZn87weQvHK0hKXs22/rWwT6756+9lRUEM/t1HoJAX6jGTjY67GtX5nDKixCXDurWncYa5/pDaTFAPngXt5OiQlcXzS2BeCRoLCcdF5PFGPULGiOSFvf36f0omCg5fCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCX6SxOV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCX6SxOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6421F000FF;
	Wed, 30 Sep 2026 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785705;
	bh=FAXbYxNJUKbcXYPhpeVDfhn6MO/lulxy8egxRwu5lYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCX6SxOVi2t1dqkHPL1HpExEJMXqi1vEp6RX4ofGzRB/d2GndWZzNv52VVzfALdqs
	 8LbsFTUmar+mycaGBiAhRYUJzJ3oOzvgpys26fMi0u5CA5ozlc+NQFjExgSPvu4off
	 PV68pPK6HD5tcNF9mzxFIzF1EkxDYdl901nxkAw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 604/982] net: convert dev->reg_state to u8
Date: Wed, 30 Sep 2026 17:22:20 +0200
Message-ID: <20260930152429.754061878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 37c1109bf1543..e97967ca27601 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1756,6 +1756,15 @@ enum netdev_stat_type {
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
@@ -2272,13 +2281,7 @@ struct net_device {
 
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
 
@@ -5169,7 +5172,9 @@ static inline bool netdev_unregistering(const struct net_device *dev)
 
 static inline const char *netdev_reg_state(const struct net_device *dev)
 {
-	switch (dev->reg_state) {
+	u8 reg_state = READ_ONCE(dev->reg_state);
+
+	switch (reg_state) {
 	case NETREG_UNINITIALIZED: return " (uninitialized)";
 	case NETREG_REGISTERED: return "";
 	case NETREG_UNREGISTERING: return " (unregistering)";
@@ -5178,7 +5183,7 @@ static inline const char *netdev_reg_state(const struct net_device *dev)
 	case NETREG_DUMMY: return " (dummy)";
 	}
 
-	WARN_ONCE(1, "%s: unknown reg_state %d\n", dev->name, dev->reg_state);
+	WARN_ONCE(1, "%s: unknown reg_state %d\n", dev->name, reg_state);
 	return " (unknown)";
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 270689c9f351a..1f5d42c726d8b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10242,7 +10242,7 @@ int register_netdevice(struct net_device *dev)
 
 	ret = netdev_register_kobject(dev);
 	write_lock(&dev_base_lock);
-	dev->reg_state = ret ? NETREG_UNREGISTERED : NETREG_REGISTERED;
+	WRITE_ONCE(dev->reg_state, ret ? NETREG_UNREGISTERED : NETREG_REGISTERED);
 	write_unlock(&dev_base_lock);
 	if (ret)
 		goto err_free_pcpu;
@@ -10531,7 +10531,7 @@ void netdev_run_todo(void)
 		}
 
 		write_lock(&dev_base_lock);
-		dev->reg_state = NETREG_UNREGISTERED;
+		WRITE_ONCE(dev->reg_state, NETREG_UNREGISTERED);
 		write_unlock(&dev_base_lock);
 		linkwatch_forget_dev(dev);
 	}
@@ -10911,7 +10911,7 @@ void free_netdev(struct net_device *dev)
 	}
 
 	BUG_ON(dev->reg_state != NETREG_UNREGISTERED);
-	dev->reg_state = NETREG_RELEASED;
+	WRITE_ONCE(dev->reg_state, NETREG_RELEASED);
 
 	/* will free via device release */
 	put_device(&dev->dev);
@@ -11000,7 +11000,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
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



