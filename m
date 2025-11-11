Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC12D979C;
	Tue, 11 Nov 2025 01:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824111; cv=none; b=lWImhBsP9WdgKfFVSO8uo6etAnYAbkvWoXVZ1nmMH+T40kbEB7TcEc0v99RUHvnio6BrBrym2JGzgjDS6efyiIVOW+kN/L/JMq5ZtsLFZ0yPTsjWVzgOJ8lyBw/tzkG6fRIsQ+gEBd32efE7O7jH/XBkEGhQ+cevZe0KqnGAeWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824111; c=relaxed/simple;
	bh=Ke2Rohbq/7XkB97B+1oYH3zMogC5vwr4zwPOygFSZ6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5txiUptHO0omL0xBkWU4Gb0QIo3aEi3M4nIcjdMrhyNO+GIVz5OIyWDqBcgDnhcEKTnPeHbaOu9+Ln9c7M9ANTXrKhaQxXKpAqOxWgUW06P9QN6V4GrHOdPKSEUOAnfzmOIvygIaYgiKXb6JNfy9WiJl8aGOaVBK/lpNnPJNak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQxgXgzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQxgXgzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31445C16AAE;
	Tue, 11 Nov 2025 01:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824111;
	bh=Ke2Rohbq/7XkB97B+1oYH3zMogC5vwr4zwPOygFSZ6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQxgXgzLVG7cyD6GU9UDR8qtQnSZrBY0zI1I6hk397+RBqkIW72o5WpWVIzoKdYPv
	 XJZ3pMSFkfJAGzoqB+2MTj6FMOWDHp7svfZd5Por7L2lKw+tr54ZpbAIKkvNXGajQ+
	 tzaXK4q+d3xmVxMcBD9BGI4n9twA5au1PYEGQS/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/565] IB/ipoib: Ignore L3 master device
Date: Tue, 11 Nov 2025 09:44:05 +0900
Message-ID: <20251111004535.621967574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Dumitrescu <vdumitrescu@nvidia.com>

[ Upstream commit 42f993d3439827c4959ea77e60620d7ebfb3a477 ]

Currently, all master upper netdevices (e.g., bond, VRF) are treated
equally.

When a VRF netdevice is used over an IPoIB netdevice, the expected
netdev resolution is on the lower IPoIB device which has the IP address
assigned to it and not the VRF device.

The rdma_cm module (CMA) tries to match incoming requests to a
particular netdevice. When successful, it also validates that the return
path points to the same device by performing a routing table lookup.
Currently, the former would resolve to the VRF netdevice, while the
latter to the correct lower IPoIB netdevice, leading to failure in
rdma_cm.

Improve this by ignoring the VRF master netdevice, if it exists, and
instead return the lower IPoIB device.

Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916111103.84069-5-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 4e31bb0b6466d..d65f3a5963651 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -317,26 +317,27 @@ static bool ipoib_is_dev_match_addr_rcu(const struct sockaddr *addr,
 }
 
 /*
- * Find the master net_device on top of the given net_device.
+ * Find the L2 master net_device on top of the given net_device.
  * @dev: base IPoIB net_device
  *
- * Returns the master net_device with a reference held, or the same net_device
- * if no master exists.
+ * Returns the L2 master net_device with reference held if the L2 master
+ * exists (such as bond netdevice), or returns same netdev with reference
+ * held when master does not exist or when L3 master (such as VRF netdev).
  */
 static struct net_device *ipoib_get_master_net_dev(struct net_device *dev)
 {
 	struct net_device *master;
 
 	rcu_read_lock();
+
 	master = netdev_master_upper_dev_get_rcu(dev);
+	if (!master || netif_is_l3_master(master))
+		master = dev;
+
 	dev_hold(master);
 	rcu_read_unlock();
 
-	if (master)
-		return master;
-
-	dev_hold(dev);
-	return dev;
+	return master;
 }
 
 struct ipoib_walk_data {
@@ -485,7 +486,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 	if (ret)
 		return NULL;
 
-	/* See if we can find a unique device matching the L2 parameters */
+	/* See if we can find a unique device matching the pkey and GID */
 	matches = __ipoib_get_net_dev_by_params(dev_list, port, pkey_index,
 						gid, NULL, &net_dev);
 
@@ -498,7 +499,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 
 	dev_put(net_dev);
 
-	/* Couldn't find a unique device with L2 parameters only. Use L3
+	/* Couldn't find a unique device with pkey and GID only. Use L3
 	 * address to uniquely match the net device */
 	matches = __ipoib_get_net_dev_by_params(dev_list, port, pkey_index,
 						gid, addr, &net_dev);
-- 
2.51.0



