Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3009358D38;
	Fri,  9 Jan 2026 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962144; cv=none; b=g7Y/NvYcjFeguiv6bRCK9t6UZY4mwyq0LJSWeE3e/f1syQp3rtTgpYuM8q3T63Tz422Crmfib5ZY5MdPmCacffkIw45eLDLG1hmHp524+/04TAjyRVwt39ydnC6FspUZJBu8N0X8CLo8t/8Oxb2Wjp+y3pgPQ3A9hs1umwAL4DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962144; c=relaxed/simple;
	bh=6HCcKbTu9U38f+eO1UQr7kJnHfGHV+vDWZ2KnNIBqpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVxttIdULrQTG1M+SXksPo/PawKZvoDlgMTUH/4MM+Ni0rCqLfPWc4BlYKeW7YMu31DyUTKz8nFQwR1GwVBSGMm53OdD6sgC2v+DS9MPgYlHkdETSK+GVswWJ2IvFRJPhS9HdiH2bh6Xa9xv0CERTHo++ke+2R8rcP8f5c2Q49k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4byWu8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4byWu8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BF2C4CEF1;
	Fri,  9 Jan 2026 12:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962143;
	bh=6HCcKbTu9U38f+eO1UQr7kJnHfGHV+vDWZ2KnNIBqpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4byWu8mKqRAX+hAkiVZO6rTzol/JfPYcyW5G5eROuInWoR0q/8k24JaTwaDRU/NS
	 LUa5YcuV3UDi2VPhqtT+KWf1mVF29pVOc72Ml00t7bMMbJHpuLESnSTpcbQstnJTi6
	 u5VCqyQFHBflkC8Rx6EX/K7eqUv0Y/vRt4A1xFnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/634] net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers
Date: Fri,  9 Jan 2026 12:38:59 +0100
Message-ID: <20260109112127.358450667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 201ed315f9676809cd5b20a39206e964106d4f27 ]

So that it's easier to follow and make sense of the branching and
various conditions.

Stats retrieval has been split into two separate functions
ethtool_get_phy_stats_phydev & ethtool_get_phy_stats_ethtool.
The former attempts to retrieve the stats using phydev & phy_ops, while
the latter uses ethtool_ops.

Actual n_stats validation & array allocation has been moved into a new
ethtool_vzalloc_stats_array helper.

This also fixes a potential NULL dereference of
ops->get_ethtool_phy_stats where it was getting called in an else branch
unconditionally without making sure it was actually present.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 102 ++++++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 33 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b85f055767035..208a40ae4ccbb 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2077,23 +2077,8 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
-static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+static int ethtool_vzalloc_stats_array(int n_stats, u64 **data)
 {
-	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
-	struct phy_device *phydev = dev->phydev;
-	struct ethtool_stats stats;
-	u64 *data;
-	int ret, n_stats;
-
-	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
-		return -EOPNOTSUPP;
-
-	if (phydev && !ops->get_ethtool_phy_stats &&
-	    phy_ops && phy_ops->get_sset_count)
-		n_stats = phy_ops->get_sset_count(phydev);
-	else
-		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 	if (n_stats < 0)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
@@ -2101,31 +2086,82 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	if (WARN_ON_ONCE(!n_stats))
 		return -EOPNOTSUPP;
 
+	*data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!*data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int ethtool_get_phy_stats_phydev(struct phy_device *phydev,
+					 struct ethtool_stats *stats,
+					 u64 **data)
+ {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
+	int n_stats, ret;
+
+	if (!phy_ops || !phy_ops->get_sset_count || !phy_ops->get_stats)
+		return -EOPNOTSUPP;
+
+	n_stats = phy_ops->get_sset_count(phydev);
+
+	ret = ethtool_vzalloc_stats_array(n_stats, data);
+	if (ret)
+		return ret;
+
+	stats->n_stats = n_stats;
+	return phy_ops->get_stats(phydev, stats, *data);
+}
+
+static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
+					  struct ethtool_stats *stats,
+					  u64 **data)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int n_stats, ret;
+
+	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+		return -EOPNOTSUPP;
+
+	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
+
+	ret = ethtool_vzalloc_stats_array(n_stats, data);
+	if (ret)
+		return ret;
+
+	stats->n_stats = n_stats;
+	ops->get_ethtool_phy_stats(dev, stats, *data);
+
+	return 0;
+}
+
+static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+{
+	struct phy_device *phydev = dev->phydev;
+	struct ethtool_stats stats;
+	u64 *data = NULL;
+	int ret = -EOPNOTSUPP;
+
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
 
-	stats.n_stats = n_stats;
+	if (phydev)
+		ret = ethtool_get_phy_stats_phydev(phydev, &stats, &data);
 
-	data = vzalloc(array_size(n_stats, sizeof(u64)));
-	if (!data)
-		return -ENOMEM;
+	if (ret == -EOPNOTSUPP)
+		ret = ethtool_get_phy_stats_ethtool(dev, &stats, &data);
 
-	if (phydev && !ops->get_ethtool_phy_stats &&
-		phy_ops && phy_ops->get_stats) {
-		ret = phy_ops->get_stats(phydev, &stats, data);
-		if (ret < 0)
-			goto out;
-	} else {
-		ops->get_ethtool_phy_stats(dev, &stats, data);
-	}
+	if (ret)
+		goto out;
 
-	ret = -EFAULT;
-	if (copy_to_user(useraddr, &stats, sizeof(stats)))
+	if (copy_to_user(useraddr, &stats, sizeof(stats))) {
+		ret = -EFAULT;
 		goto out;
+	}
+
 	useraddr += sizeof(stats);
-	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
-		goto out;
-	ret = 0;
+	if (copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))))
+		ret = -EFAULT;
 
  out:
 	vfree(data);
-- 
2.51.0



