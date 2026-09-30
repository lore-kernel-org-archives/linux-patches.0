Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB54BFE95;
	Wed, 30 Sep 2026 17:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788281; cv=none; b=CaVgDivTXHvYdqD+nNdQcNALTHaxqdZwkQizFmBnoM8VPksCPJyE0vYpXS7dh9NUTUxuOfc5DS9STk5sViCCJErbEZZAwe5/CefnK9+nb6G+hFFIJOC/mJBp+HQ3j8Jlu31GbqEXA4d9Sr/csumg0/cwh87abmU6iYtyLTLxrsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788281; c=relaxed/simple;
	bh=MQfmGyYZfMCWjDTTh3FLg1CHBIMMRKxU5+VH720n1xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBFWl1MBp/gVfcS0eD+hQrpcPC5BUxm0ltiF2quIMPgaeioDVjXEuhPoPlmoZJ/hijnU9GScHT8iROhtMLhQGeAXWLRgO84UKEdPYauk/wUGSoasqEPNTMVDy7g+DY0s/AyNw5+k8SmZzcFWPR5ld+ppZR5INMyo7FXhf9YDiIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njt77hU0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njt77hU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD71F000FF;
	Wed, 30 Sep 2026 17:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788280;
	bh=fCo7LX5Qsi4NSdoBJXUQ3HYktlNSJuDpNiYadwx2z+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njt77hU0t2Ovph5Vi2cAMPWGInqjYUv8JANL0GN79QnGWJd5Wy8opXeNkNOAPWana
	 5TiXIhIQxlAR6vajVdd/XutemvLr/TDts4OIAhPDOPPIYk6qSfNUBmrXrn01/nYY62
	 V4I57XgBmon/hX78Rti16JW5asiBtBZAyrvPZm1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/877] ipv6: mcast: Use in6_dev_get() in ipv6_dev_mc_dec().
Date: Wed, 30 Sep 2026 17:15:25 +0200
Message-ID: <20260930152415.053324791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ef938fb1d7549..fb239e8f83593 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2255,12 +2255,11 @@ void addrconf_join_solict(struct net_device *dev, const struct in6_addr *addr)
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
index c060954c52757..212c2d8efe0f5 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -972,9 +972,8 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 {
 	struct ifmcaddr6 *ma, __rcu **map;
 
-	ASSERT_RTNL();
-
 	mutex_lock(&idev->mc_lock);
+
 	for (map = &idev->mc_list;
 	     (ma = mc_dereference(*map, idev));
 	     map = &ma->next) {
@@ -1003,13 +1002,12 @@ int ipv6_dev_mc_dec(struct net_device *dev, const struct in6_addr *addr)
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



