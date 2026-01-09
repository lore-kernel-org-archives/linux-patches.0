Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BE8336EDA;
	Fri,  9 Jan 2026 12:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962140; cv=none; b=niLQmkyeOord3pjCYRrz5pahADeOXLiaad6G1AeQl6G+IN/PiAVJpUZcbBupeXRLqGSBD20YL/9BhLTS/D7DMv9NsFkRWPUHUUbLDOryCt/64pSGqyZDu/eLyzSvdeRzOcCAJCyhJK5KuN8gwtQsGvZ9l1Al9LGE4wF537N/kq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962140; c=relaxed/simple;
	bh=3+0i3IG483jgwaWl0x8MXg43hzWdKRicPilMt9J5fMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvrnCTUD3X6Ou509wTlJMjdWO1mXK9oq0cB4omJ7h77ufiVUvLjMi2IenSxqvr+IF0bpOZVYauOulkcmT+Wpmg45LUgHarFJIkYtWvm18eyxIuXAI2r0MTMj6tfkgaSQWMQ5HgKf4rVU2asB1USixddA7jlKSsdTqKmY3GMGNGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia38q03D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia38q03D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65465C4CEF1;
	Fri,  9 Jan 2026 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962140;
	bh=3+0i3IG483jgwaWl0x8MXg43hzWdKRicPilMt9J5fMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia38q03DKPj94KQvNyow6QSOXdkv756WiaNBf4d9p8tzgRih9VsU0fYfU3dUevumm
	 CG/FAspiGxZl/h1QX0aocnaRGGhzFMKN77zMiyY6IT1sbNi1gF8gf0p5b0bIQiO0qe
	 yec3LaROfggU3sUzHW4bVPzcYRSzdigo4NpjLevs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/634] net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
Date: Fri,  9 Jan 2026 12:38:58 +0100
Message-ID: <20260109112127.321173238@linuxfoundation.org>
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

[ Upstream commit fd4778581d61d8848b532f8cdc9b325138748437 ]

Now that we always early return if we don't have any stats we can remove
these checks as they're no longer necessary.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7b07be1ff1cb ("ethtool: Avoid overflowing userspace buffer on stats query")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 442c4c343e155..b85f055767035 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2106,28 +2106,24 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
 	stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
-		if (!data)
-			return -ENOMEM;
+	data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!data)
+		return -ENOMEM;
 
-		if (phydev && !ops->get_ethtool_phy_stats &&
-		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(phydev, &stats, data);
-			if (ret < 0)
-				goto out;
-		} else {
-			ops->get_ethtool_phy_stats(dev, &stats, data);
-		}
+	if (phydev && !ops->get_ethtool_phy_stats &&
+		phy_ops && phy_ops->get_stats) {
+		ret = phy_ops->get_stats(phydev, &stats, data);
+		if (ret < 0)
+			goto out;
 	} else {
-		data = NULL;
+		ops->get_ethtool_phy_stats(dev, &stats, data);
 	}
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
-- 
2.51.0



