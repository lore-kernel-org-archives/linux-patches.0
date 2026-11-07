Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062486;
	b=2pkJLXes18pFSKeAZHnawznM2qSq4dWNzv5067EXrHC2BmZ9fG1z7McHuKqKAKKlhZWX
	 Xf/W0uf12I27spHR9MvikFo5RFk7h5LP7YHr13xqf0Qupa5rLkK95dfGhRzXUSJyb2/fx
	 wN4IdAFNhs/jnn6MCzri6VRhxxaVpsKLzASkbGR9+1rUc0Pl5gQ9T3be+qibLh39ntzjz
	 P4QQeCmdVJxwfp92K28PfwcGsNl5yGFCjNKi+8afuLLW1QpL6pObQh9jHwq2P4Mw4lkJp
	 TxFW5Ur5TOzsSWsQZb+mkJg1wocKhyuEB5V3RiMqRZXuQqhmvlGdIXtCMHYqZEs1WrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NalxCSj6DaXvSiwt5BhLYCGKqHDoNEsoRIzzxfeKqHM=;
	b=pOVksWmZb+KVhZwNlG/UHJQEmAJpEiPhG155viuwlO/9Y8aEW0qoRP4V640QPlEtYV24
	 MfKSB89y/GD4K0127vFm83WQUmw93F46B9XvyEYqH4UsZIyJ0RUvZGTws8INqLjJhnmfv
	 MUHV9k+NouawuF8f7Guv7Gp4E1KXAsV7U/rbCsqrkvUFII8wJcfZ9vtETlIp9yyffesCG
	 wbwhEHzJNF9GvCkT5nXa0bLYotXlobh5ZJQQDAzLWWb/NMALUfSEaPjI8+lnnsWM841tS
	 OlfbMtyOXrEOC+0KQjG3zmE4tEqcdvauBEk8YuxRZ/Dy+2HRDNKYtVHOhbgZjj6ETmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCA9Odqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C6B6082BD0;
	Sat,  7 Nov 2026 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCA9Odqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504831F0089F;
	Sat,  7 Nov 2026 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062486;
	bh=NalxCSj6DaXvSiwt5BhLYCGKqHDoNEsoRIzzxfeKqHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCA9OdqkSyir/QkOO//hgr4gBCBCDS8S6M19iyXUX9lCuGKCc7erh26fwMfw70Z/D
	 XINAdfah7Ezcu7HcEkepAv2qaSEiZQ17EXbwmcocbHXTl8Yp++Zx+vtP7+q7g2VC+x
	 fISBQrrUtVqnlSITJh15KQvvOavkbmyCFMhYfBYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1387/1536] ipv6: serialize address publication with device teardown
Date: Sat,  7 Nov 2026 08:56:43 -0500
Message-ID: <20261107135036.785708953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d7865f915d25d..d6474f3ea114a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1161,14 +1161,18 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 
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
 
@@ -3903,7 +3907,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



