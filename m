Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036766;
	b=3EkRV3SB8NXCw1YLsLqSxAiUrTgf4mLKOf4FSSKJliRhtVkVMb23W8E2OiPBMzs0PdQ9
	 pX1UckDBp7FfBx+02vWRWx2dA1/PxGDSUyeNI1fwQBVyA0gKnKgeFtVMA9x8Z9eXqCrhc
	 WuEdYgPhUED+LY5dhZHb7yI36lfBTTimXj5fMnd45b3aID8opV9PX5IQfoCtOA1DRQm03
	 jTLcVR/0KFJvhaFx5LTzVLzY/fC2F6lTqNrz4pm5iVY/hmi3f1J6gePm8bktCX4Pcoz8a
	 p+yXhxLo8QKR8f0wwrv3PyU9e/FUuj8eSoDd5gZt2XMEXmtDo95XHUsP5d1/59YH/Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RO7MTla7ht9kiuEk/2FAKDyZS/bBX/HhklRaeTnHpfI=;
	b=UsKCz9WBJHNgVT2u+Ntqn9X4Wt6sXismmWxAXHZhRhcdxP4DdYuMq36h8NBEx9B1pUIq
	 0lz7Ceuy/m0DGMMHHOWMecZFUDQgKTMPcA/+/2WabH6bYGJTMHFJweu867R32fnEAcD3A
	 rr8qdffhMYUKmHf08ZpFG4hUIncBFtc5cstpQ6ZhBP//Bs56+8z9cTIdZjp9vaEdxVzmy
	 Z421bS3/f27iMn0+xJD19Sa6QWZ1tfxnWR4D7ajtQwGyEYcbgfGWQTQ8B5Yep2pgRoFrg
	 L3839OmFIPJe4o5ECqg6ARVzghlvtCVfzYp+HevxZDlM8vc+Zo+AFkqPlfaUbW2I3DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lONdhjJn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1D606A31C;
	Wed, 18 Nov 2026 21:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lONdhjJn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E68F1F000C4;
	Wed, 18 Nov 2026 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036766;
	bh=RO7MTla7ht9kiuEk/2FAKDyZS/bBX/HhklRaeTnHpfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lONdhjJn5kjO+vGCQk/wSvp/fwcHmIuRwlv35nvFW/JsEEw1h2Zqg8/Ar/8SZK3er
	 w6GrUq7CDrKo5UzA7yuPhgvHsPpbpVNVxcArg8EGmjPHlYoRQjTemi4LdAKyFt2iRv
	 QoDThWFMyCkSZ1+EWj+GuQH/rx2sQ0MPS19FkSFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1176/3318] ipv6: serialize address publication with device teardown
Date: Wed, 18 Nov 2026 15:29:58 +0100
Message-ID: <20261118150355.413060687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7310af712f91f..2a873d037dcca 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1165,14 +1165,18 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 
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
 
@@ -3870,7 +3874,9 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
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



