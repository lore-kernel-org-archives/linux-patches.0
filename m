Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567CF30649C;
	Tue, 11 Nov 2025 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824867; cv=none; b=VkUkk1626XsxqU81SmWWLcbhXZ91CWJp6qjXkMtJqNlZ7gyKRFoVmaACgLmoYgLOWl7y7al4CMLzJz7/fs5/7T5RMvv+xVi53KO6HzYWrjFhZed3lpFyFVC43yAO4IvWu4bHHahvheOB0YXhMnjrsFvglVBC15BMXi9EqIZA7eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824867; c=relaxed/simple;
	bh=yPxLJ7fOjLunEcT2Zioy2wbl3ONiV8kJO6DRiw808EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsL05EIq+HDcX0s5pPBoUhduT9yENhjhW70ZNOw5s9UJFm3xiv63Vdu/u1MiF9zrecf1gFssSjK7RL5ADHXnX3nf8qMqugjfoHA7ZXdJTeAoen+7dOnOWY413qJRWZVsmiOaWc6NjN10RG8+7nQqNHgdQwSNGdRFqIWSsYULoeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSCR/kRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSCR/kRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78D9C16AAE;
	Tue, 11 Nov 2025 01:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824867;
	bh=yPxLJ7fOjLunEcT2Zioy2wbl3ONiV8kJO6DRiw808EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSCR/kRrusIUZvEI7/OWBNX7zRzXXr68psNfp0KyY6wH/10r4mNSnolK4NRXal5AM
	 R+RYbsReqWss/lzseIfm9iylIWS+ViX9rhu1Lep3hxIWZSru6mZ9wDwzW2w7f9aTEm
	 l5OAPsHXgQzhmfwC4br5RAEN2fUGrkGw3d+w00Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 588/849] IB/ipoib: Ignore L3 master device
Date: Tue, 11 Nov 2025 09:42:38 +0900
Message-ID: <20251111004550.638750813@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7acafc5c0e09a..5b4d76e97437d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -351,26 +351,27 @@ static bool ipoib_is_dev_match_addr_rcu(const struct sockaddr *addr,
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
@@ -522,7 +523,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 	if (ret)
 		return NULL;
 
-	/* See if we can find a unique device matching the L2 parameters */
+	/* See if we can find a unique device matching the pkey and GID */
 	matches = __ipoib_get_net_dev_by_params(dev_list, port, pkey_index,
 						gid, NULL, &net_dev);
 
@@ -535,7 +536,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 
 	dev_put(net_dev);
 
-	/* Couldn't find a unique device with L2 parameters only. Use L3
+	/* Couldn't find a unique device with pkey and GID only. Use L3
 	 * address to uniquely match the net device */
 	matches = __ipoib_get_net_dev_by_params(dev_list, port, pkey_index,
 						gid, addr, &net_dev);
-- 
2.51.0



