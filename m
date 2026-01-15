Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E293BFE4C;
	Thu, 15 Jan 2026 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497882; cv=none; b=bS4VbkX/R2g5+hhx64+lDprA9Z9K9kS6ZeDsQ4x5gg1cM0paD0ldDI0r5P6zj/p/SgdOJIfukacSqeK4YUBBH3Z8a91cv2B5zPeayJs5jfXmKm7K+KIzMuppLOC2hwgdx8LSfwowETv3RE7TRj1sxA1SYEoVNvgavQ0xBEqLS/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497882; c=relaxed/simple;
	bh=GhoOc95BrMnqJJbc6eUEczfYo1BLtF4obJDA148uHBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9dIG7r+jy3V8KIk6bxo/KZaCEl0BSoTFja8bYN1Z7dtFzpitG7mz9ZBXLuIHoEbOOcoqC6ps5g9mf0V33djheT7aanCICyDrBTt3dprBf4SM1k4E3PYkOMZEUinMKIQMgufTFu2p2aR9bdrqcttwXFNeF/8M1NRI1cYJM3bnRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/s3/oUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/s3/oUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F3FC116D0;
	Thu, 15 Jan 2026 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497881;
	bh=GhoOc95BrMnqJJbc6eUEczfYo1BLtF4obJDA148uHBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/s3/oUSiyhuYi+vq2Z8nMDEWNe3Z1730dEanRaoBxWk4xt0bwMLSf6giu3w5POAz
	 qRkLgNQt73cHQe3ZC6hDOZKQX82OSCUb7+TIYL9IhWeM7B9xjW2nA1LGIQSldzBawe
	 4nV5YpUsSM0B5wYbqvGtvTEiFfZArWJFkDiLB2HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/554] ethtool: use phydev variable
Date: Thu, 15 Jan 2026 17:45:01 +0100
Message-ID: <20260115164254.752138345@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

[ Upstream commit ccd21ec5b8dd9b8a528a70315cee95fc1dd79d20 ]

In ethtool_get_phy_stats(), the phydev varaible is set to
dev->phydev but dev->phydev is still used.  Replace
dev->phydev uses with phydev.

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 1e9e70a633d1c..4b736385912ef 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2068,9 +2068,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
 		return -EOPNOTSUPP;
 
-	if (dev->phydev && !ops->get_ethtool_phy_stats &&
+	if (phydev && !ops->get_ethtool_phy_stats &&
 	    phy_ops && phy_ops->get_sset_count)
-		n_stats = phy_ops->get_sset_count(dev->phydev);
+		n_stats = phy_ops->get_sset_count(phydev);
 	else
 		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 	if (n_stats < 0)
@@ -2090,9 +2090,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		if (!data)
 			return -ENOMEM;
 
-		if (dev->phydev && !ops->get_ethtool_phy_stats &&
+		if (phydev && !ops->get_ethtool_phy_stats &&
 		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(dev->phydev, &stats, data);
+			ret = phy_ops->get_stats(phydev, &stats, data);
 			if (ret < 0)
 				goto out;
 		} else {
-- 
2.51.0



