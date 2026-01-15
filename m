Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036FB3D1CB9;
	Thu, 15 Jan 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499306; cv=none; b=ASDORV/Wvq5e1fk3Q2eiGHRvzru8HK6Mba07X4Ap2ua6woXO8pPg2KzqgxtFceeJYg2mXCnNczZZPqe3qW/xLgU3iDmJhZ8w8gbACVtfBhGAaDSN9bKc90N4YyuAc/usHcir+ANLzrmDh6DRnAuhs3OZGps6FkhHPELi5AhGnbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499306; c=relaxed/simple;
	bh=PJKBPRxK0s1eHcf5XOkHCZrfxRksy60KtfxpD/6BwIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OoxJh0snHdZpEI4pok67nP5Q5If79IQCTbA9EIAb9Zx33grY1ZuZvHyhfTOlcA8pTs5X7NTtDGHyQdOqVMsclWHkXvOgOJK1eF8IHtBSDaNXW5jvLyG950sztaJv10oTKwL0WBH814XuGlMPz1SS9YjCqAoFnhymJYMiIWzEm+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSN4pR9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSN4pR9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C96C2BC86;
	Thu, 15 Jan 2026 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499305;
	bh=PJKBPRxK0s1eHcf5XOkHCZrfxRksy60KtfxpD/6BwIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSN4pR9HiFAYH2lXeVT9X+PdNsMvAkhw2Kn+t2JOyLywEm2H0drn50vgec3nRfNiz
	 a22ABjqa8MkxCpMrIwn5M2wIBpmCdKwkvJV+BedSuz51rl/AGYAcDo4s5S5253Ipv5
	 evT/oQXd0jO0PiUchKStAXIMueLPO+n/Z+mXEvK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Rix <trix@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/451] ethtool: use phydev variable
Date: Thu, 15 Jan 2026 17:46:21 +0100
Message-ID: <20260115164237.416199608@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0a588545d3526..ede11854f493f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2046,9 +2046,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
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
@@ -2068,9 +2068,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
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



