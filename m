Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063599;
	b=vsvxPd3OMmtuQudThVSsAt1d1EeaW+ItqWUZAQYojGUh6yviuD7GHzpY6HzmZn7Dk1jK
	 L6lYmsu5HVMYnHVXxlRsQR2nrcvpAUjAzyG1yLuv0NFNHzLttypRQkvMf6y2Ry7Z/+I2p
	 G5/bKKgbQWMF+Y8ocub1wqF4OAN9xSd+nd0myBGhrsYtCIDHXrMDS5dFgWnUOnK8n6hzd
	 e549BhKs0MxSX5ZdU+jw28wiY987CWlb090Vc0NRgKjD1eJR7moJIDDk19MO79ROY+W84
	 dsWYc5T+9X/EaFM01qw8YGsddLkYy9+lTtkMP4GeLRmyRA8Pn1ph947VNpgOXyIDlVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrDZUAJhPiVF3lMDfeYn8uL28pudLz75733sPdfRAw8=;
	b=EeQF0KXaXnxPGSbpvqSYErXMHVn4KzrEOQqGxAYbnu4l9P0JvPE+A4YeChH82yMxMitt
	 Tsc0hDunUH7U22fCiVRiY1dGH0mzdvJtSLvtLzBZlB/VZWTr9QLNgaP1zh443wX1ETQMN
	 EPLu0c72amPBb4TV5CE10DTcwhE/wBjWSp8kkeenikW6pqCTkQIfiV7KmgQRBYOgDYjJd
	 fJop4sUZ/qHJw10x4IJM/sDimHX8r8GxruxaMK6x5YvX+Tv8SOxuWwRrBDoxvIjdRfZYL
	 fkDleS9DWpMTgehFKBzosygmVj6xdCAeL2MNKuUvEN3Himid6GJvVGm15IgvS/bJltw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oO1rBKlI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C466082BD7;
	Sat,  7 Nov 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oO1rBKlI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F481F0089F;
	Sat,  7 Nov 2026 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063599;
	bh=WrDZUAJhPiVF3lMDfeYn8uL28pudLz75733sPdfRAw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oO1rBKlIiqXNRFgFlQraa0S3MVCfSsmvMj4NemACq/Rq3VDPKJgj3IKF2Hd0LJAtw
	 pedniUxxyUVnlNtAzz7g6WbkIW28goVkgYyu4uIpZ5kIzeLxhoOxF3YhD1BOwS/AP6
	 iTtGeZQUAS7erFOo/hB/U6NHaUHvR+bWmqYTcVmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 686/869] ipv6: serialize address publication with device teardown
Date: Sat,  7 Nov 2026 08:56:08 -0500
Message-ID: <20261107134916.295112149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 06227034e2d93942119b922cf05f2de9da0ad848 ]

ipv6_add_addr() checks idev state before allocating an ifaddr, but
publishes the object later. addrconf_ifdown() can mark and detach the
idev between the check and publication.

This happens when a non-loopback device MTU falls below IPV6_MIN_MTU. A
forced interleaving published an address on a dead idev, and
ipv6_get_ifaddr() still returned it after teardown. Later device deletion
remained blocked with:

  unregister_netdevice: waiting for ac0 to become free. Usage count = 3

Protect the dead indication with idev->lock and keep that lock across
both hash and device-list publication. Recheck dead before publishing;
if teardown wins the lock, reject the unpublished object.

Non-unregister teardown does not set dead. The preceding change covers an
add that misses the initial hash scan but reaches the per-device list
snapshot. Both changes are required when backporting this fix.

Fixes: 8814c4b53381 ("[IPV6] ADDRCONF: Convert addrconf_lock to RCU.")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/179161099408.434549.14449036924552933828@kernel.org
Link: https://lore.kernel.org/r/20261012145306.GB779501@shredder
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-3-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 067d325291b9f..caf8f3bd2372f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1168,14 +1168,18 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 
 	rcu_read_lock();
 
-	err = ipv6_add_addr_hash(idev->dev, ifa);
+	write_lock_bh(&idev->lock);
+
+	if (idev->dead)
+		err = -ENODEV;
+	else
+		err = ipv6_add_addr_hash(idev->dev, ifa);
 	if (err < 0) {
+		write_unlock_bh(&idev->lock);
 		rcu_read_unlock();
 		goto out;
 	}
 
-	write_lock_bh(&idev->lock);
-
 	/* Add to inet6_dev unicast addr list. */
 	ipv6_link_dev_addr(idev, ifa);
 
@@ -3884,7 +3888,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	 *	   Do not dev_put!
 	 */
 	if (unregister) {
+		write_lock_bh(&idev->lock);
 		WRITE_ONCE(idev->dead, 1);
+		write_unlock_bh(&idev->lock);
 
 		/* protected by rtnl_lock */
 		RCU_INIT_POINTER(dev->ip6_ptr, NULL);
-- 
2.53.0



