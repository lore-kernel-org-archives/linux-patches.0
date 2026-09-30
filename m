Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CE53B443F;
	Wed, 30 Sep 2026 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796526; cv=none; b=mMRCFtYgmP/N/dtmnuZSW+ybiIbXFfV4pOeReLRVUmWGK2VczJCGW/GvUyI97dotC3oSl5w0eadR3SPuCe3p+XSsQqNZu03H0Q5xVvLzk1UAqOnkNv8CtEpRUkoa6Zr1rHBWU0kZybr7QomsUQYZWB6Qjflq0U5DSdOyOwhCG2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796526; c=relaxed/simple;
	bh=IA3VoL7XFLkGSuLMzBiW5U9WDUdyHoWFjBvmCpJq9zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmquOb5KJpsPPlp0ugOawcOsjRsOKEGRk6rBLbn1xSRw+6GeMxI3ocanK2ey5knOx2w18BMc69OrTVCyCuh3CbL2fv6ntBVYPvuldfmZe4Y6OO2PuxC9vCUb1pnn+bghCoguE6jvZMcHMZ2EAlieN2VaLE3eOx2oibG0yABruog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crQizM4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crQizM4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0031F000FF;
	Wed, 30 Sep 2026 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796524;
	bh=s5eXvsYCKfcIAwdnhj/8oUbhwnNeK03wlpJ1dWlx5VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crQizM4EHqlG3vI3Mmt6UmJFP83WCF5zjCieyPVn9tQs4xVyVapdN0cFAEJFZzT/C
	 ++HjA+K2QN98BZxT3DwFFv4t/F+/4a9CFWIgMqWURRQCrjps3+pDvtwyRlQw90Nq1K
	 KoGQUY+7DZc9NNk8FM7ZLbSqOrj0gEmYGN8/2eCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0942/1193] ipv6: mcast: Use in6_dev_get() in ipv6_dev_mc_dec().
Date: Wed, 30 Sep 2026 17:27:06 +0200
Message-ID: <20260930152455.165655326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e01b193e0b50ae849bf60067e111446f19ee2f20 ]

As well as __ipv6_dev_mc_inc(), all code in __ipv6_dev_mc_dec() are
protected by inet6_dev->mc_lock, and RTNL is not needed.

Let's use in6_dev_get() in ipv6_dev_mc_dec() and remove ASSERT_RTNL()
in __ipv6_dev_mc_dec().

Now, we can remove the RTNL comment above addrconf_leave_solict() too.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-6-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c |  3 +--
 net/ipv6/mcast.c    | 14 ++++++--------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d7a592bd32d19..24111053ebcea 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2226,12 +2226,11 @@ void addrconf_join_solict(struct net_device *dev, const struct in6_addr *addr)
 	ipv6_dev_mc_inc(dev, &maddr);
 }
 
-/* caller must hold RTNL */
 void addrconf_leave_solict(struct inet6_dev *idev, const struct in6_addr *addr)
 {
 	struct in6_addr maddr;
 
-	if (idev->dev->flags&(IFF_LOOPBACK|IFF_NOARP))
+	if (READ_ONCE(idev->dev->flags) & (IFF_LOOPBACK | IFF_NOARP))
 		return;
 
 	addrconf_addr_solict_mult(addr, &maddr);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 8306a96691698..5b427150cc416 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -971,9 +971,8 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
 	struct ifmcaddr6 *ma, __rcu **map;
 
-	ASSERT_RTNL();
-
 	mutex_lock(&idev->mc_lock);
+
 	for (map = &idev->mc_list;
 	     (ma = mc_dereference(*map, idev));
 	     map = &ma->next) {
@@ -1002,13 +1001,12 @@ int ipv6_dev_mc_dec(struct net_device *dev, const struct in6_addr *addr)
 	struct inet6_dev *idev;
 	int err;
 
-	ASSERT_RTNL();
-
-	idev = __in6_dev_get(dev);
+	idev = in6_dev_get(dev);
 	if (!idev)
-		err = -ENODEV;
-	else
-		err = __ipv6_dev_mc_dec(idev, addr);
+		return -ENODEV;
+
+	err = __ipv6_dev_mc_dec(idev, addr);
+	in6_dev_put(idev);
 
 	return err;
 }
-- 
2.53.0



