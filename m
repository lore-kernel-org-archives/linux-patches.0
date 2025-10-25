Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F510304BB9;
	Sat, 25 Oct 2025 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409069; cv=none; b=K57NjhyEC4Bbuk5z/q+mh+pQ8Ji8jTJs/S5vwXCIMFTlYbYaJqPihUhzwYPCyJfXRz20UqPN6bGI6pNlPDq7TqtkJLElUGyRp7Fe4aku31bLLShsuadyppkSsKGUDzAKWklhuw3paRo/5bm/nAIJpXNDcb3na5mAiB4ZYXHPk/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409069; c=relaxed/simple;
	bh=JpirMs34FD6wy+fvqw/cHdEWdsr7PCRgy41lr9iA4G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F1RlUcxNkVWEkA+H2N8ahR6lNuQP1gFl8EPQ13FqHLE8FgpBcWna4Hp4zw8tq0vqEPj1peN3+N3iZb/+zgDUQvHgvjV0EzwP7QdZXy/QFKPbb9RAfGRYFRVV7R/cnFU5S2uY/wbR3KP2zoJDGmSads11cqDrzz+EprtqWAdFqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLeiNM7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLeiNM7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A2EC4CEF5;
	Sat, 25 Oct 2025 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409069;
	bh=JpirMs34FD6wy+fvqw/cHdEWdsr7PCRgy41lr9iA4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLeiNM7JtOEEGxKIbtaFpWABGbb94wEcDH4Dzk1Vh9wpdz0LS5fVC+t3Z9tlxI3BU
	 csncu2ZzkLXYGCApGF1pAje24V/naayPy+9wza1p+WKGNI967WOqm4CCUHkfG4iiHq
	 kdK7Rqr0HYmRKRaGQWbmH+UNcXM1XeSKDNehuk0kFFh0K8HEJZ5aCvuINxQFQJnQiI
	 TWG7C9nEpJWhKY1zjkfSIj4F6nN3UqEpe4RM7F4lKwAvCv9V1+UIKQQDF8kmrQg3Pw
	 Ef4tx3haPTUi2sDFtlQVQt+JCxSMw2u7AY7FG/Rg2Th/2D4CgbKDJ/XgPtlUFEPDv2
	 yaVVeZwO6NAtQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	tariqt@nvidia.com,
	kuba@kernel.org,
	cjubran@nvidia.com,
	cratiu@nvidia.com,
	mbloch@nvidia.com,
	gal@nvidia.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] IB/ipoib: Ignore L3 master device
Date: Sat, 25 Oct 2025 11:57:01 -0400
Message-ID: <20251025160905.3857885-190-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – this change fixes a real regression for VRF users with almost no
risk.

- `ipoib_get_master_net_dev()` now skips L3 masters and returns the
  underlying IPoIB device
  (`drivers/infiniband/ulp/ipoib/ipoib_main.c:361-374`). Without this,
  the helper hands `rdma_cm` the VRF device when matching by pkey/GID;
  the follow-up route validation in `validate_net_dev()` insists on the
  same device that the fib lookup returns
  (`drivers/infiniband/core/cma.c:1589-1616`), so requests fail today.
- With the new `netif_is_l3_master()` guard we still return true L2
  masters such as bonds, so existing bonding setups stay intact while
  VRF stacks finally resolve to the only device that actually carries
  the IP address (same file, same lines).
- This helper is static and only called via
  `ipoib_match_gid_pkey_addr()`
  (`drivers/infiniband/ulp/ipoib/ipoib_main.c:500-505`), so the fix is
  tightly scoped; the extra comment edits
  (`drivers/infiniband/ulp/ipoib/ipoib_main.c:526-541`) are
  clarifications only.
- The buggy behavior has been present since IPoIB added the connection-
  parameter matching helper (`ddde896e561a5`), so all maintained stable
  kernels inherit the failure. The fix relies only on long-existing
  helpers and keeps the same refcounting pattern, making the backport
  straightforward.

Next step: 1) Validate with an RDMA connection over an IPoIB device
enslaved to a VRF to confirm the CMA path succeeds after backport.

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

