Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368F03BF306;
	Thu, 15 Jan 2026 17:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497890; cv=none; b=d+1lX6kTZVny8K5NCjBTFM0uw9JJI+XOuXKhknPEtz6M3HQ6fKQ+SC97bpXyZH66knuJPz4wJxOjrjqpgYfoL9Pn94JuVNHjLXz3m9z7VcwiQVamd2/enKk+OwBvaDP9FFZtBCIDHOuVUjvWNfnoambuTo47nFW6rCJIwwFfPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497890; c=relaxed/simple;
	bh=fyOHXi+fnaC6MoGBJAl4WlANg3nJLcL+VDp4ItRunH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+7BSrrN4+CDEkWPZSeZISRwdsKjkMt/DjwTi0ibFf1ZHH7fslK8nBj84KHV0TXqX6IGczbQKjmgM5CO3Od5s4bokzw3MNQvVMuNiKK8m5PoFXOxtYnD4nS+RbpTe07U1VZukda5lacUtq9lu9CCRiolhFfvBnmjVx/3naf1R8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idNQcfX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idNQcfX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9A5C116D0;
	Thu, 15 Jan 2026 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497890;
	bh=fyOHXi+fnaC6MoGBJAl4WlANg3nJLcL+VDp4ItRunH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=idNQcfX9+NivM9caEsNriqlpkAU9lHlvoUxNKxzKf1y32404oid5iSwEMwMuqim9r
	 VvGVfEnNWd0sioIvYqqLrRTiqA2meNG98GhqXmUdyff5rZQZLK88et7Gz3F7jgF8Ma
	 YhY+R4V+uT/2UZ0xJCWiJoQW4qlz740tMKMV08Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 238/554] ethtool: Avoid overflowing userspace buffer on stats query
Date: Thu, 15 Jan 2026 17:45:04 +0100
Message-ID: <20260115164254.859117919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 7b07be1ff1cb6c49869910518650e8d0abc7d25f ]

The ethtool -S command operates across three ioctl calls:
ETHTOOL_GSSET_INFO for the size, ETHTOOL_GSTRINGS for the names, and
ETHTOOL_GSTATS for the values.

If the number of stats changes between these calls (e.g., due to device
reconfiguration), userspace's buffer allocation will be incorrect,
potentially leading to buffer overflow.

Drivers are generally expected to maintain stable stat counts, but some
drivers (e.g., mlx5, bnx2x, bna, ksz884x) use dynamic counters, making
this scenario possible.

Some drivers try to handle this internally:
- bnad_get_ethtool_stats() returns early in case stats.n_stats is not
  equal to the driver's stats count.
- micrel/ksz884x also makes sure not to write anything beyond
  stats.n_stats and overflow the buffer.

However, both use stats.n_stats which is already assigned with the value
returned from get_sset_count(), hence won't solve the issue described
here.

Change ethtool_get_strings(), ethtool_get_stats(),
ethtool_get_phy_stats() to not return anything in case of a mismatch
between userspace's size and get_sset_size(), to prevent buffer
overflow.
The returned n_stats value will be equal to zero, to reflect that
nothing has been returned.

This could result in one of two cases when using upstream ethtool,
depending on when the size change is detected:
1. When detected in ethtool_get_strings():
    # ethtool -S eth2
    no stats available

2. When detected in get stats, all stats will be reported as zero.

Both cases are presumably transient, and a subsequent ethtool call
should succeed.

Other than the overflow avoidance, these two cases are very evident (no
output/cleared stats), which is arguably better than presenting
incorrect/shifted stats.
I also considered returning an error instead of a "silent" response, but
that seems more destructive towards userspace apps.

Notes:
- This patch does not claim to fix the inherent race, it only makes sure
  that we do not overflow the userspace buffer, and makes for a more
  predictable behavior.

- RTNL lock is held during each ioctl, the race window exists between
  the separate ioctl calls when the lock is released.

- Userspace ethtool always fills stats.n_stats, but it is likely that
  these stats ioctls are implemented in other userspace applications
  which might not fill it. The added code checks that it's not zero,
  to prevent any regressions.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20251208121901.3203692-1-gal@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 33b5c3d8f2f7f..81fe585ddfa91 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1919,7 +1919,10 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
 		return -ENOMEM;
 	WARN_ON_ONCE(!ret);
 
-	gstrings.len = ret;
+	if (gstrings.len && gstrings.len != ret)
+		gstrings.len = 0;
+	else
+		gstrings.len = ret;
 
 	if (gstrings.len) {
 		data = vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN));
@@ -2032,10 +2035,13 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
 
-	stats.n_stats = n_stats;
+	if (stats.n_stats && stats.n_stats != n_stats)
+		stats.n_stats = 0;
+	else
+		stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (stats.n_stats) {
+		data = vzalloc(array_size(stats.n_stats, sizeof(u64)));
 		if (!data)
 			return -ENOMEM;
 		ops->get_ethtool_stats(dev, &stats, data);
@@ -2047,7 +2053,9 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (stats.n_stats &&
+	    copy_to_user(useraddr, data,
+			 array_size(stats.n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
@@ -2083,6 +2091,10 @@ static int ethtool_get_phy_stats_phydev(struct phy_device *phydev,
 		return -EOPNOTSUPP;
 
 	n_stats = phy_ops->get_sset_count(phydev);
+	if (stats->n_stats && stats->n_stats != n_stats) {
+		stats->n_stats = 0;
+		return 0;
+	}
 
 	ret = ethtool_vzalloc_stats_array(n_stats, data);
 	if (ret)
@@ -2103,6 +2115,10 @@ static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
 		return -EOPNOTSUPP;
 
 	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
+	if (stats->n_stats && stats->n_stats != n_stats) {
+		stats->n_stats = 0;
+		return 0;
+	}
 
 	ret = ethtool_vzalloc_stats_array(n_stats, data);
 	if (ret)
@@ -2139,7 +2155,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	}
 
 	useraddr += sizeof(stats);
-	if (copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))))
+	if (stats.n_stats &&
+	    copy_to_user(useraddr, data,
+			 array_size(stats.n_stats, sizeof(u64))))
 		ret = -EFAULT;
 
  out:
-- 
2.51.0



