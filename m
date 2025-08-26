Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CEF221DA5;
	Tue, 26 Aug 2025 12:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212956; cv=none; b=hwljgXvPuToa/LYlz62UiMW/kIbPwCn/zZxV+jw4RGFfaClCBREPVXXN28rG9rhhPiFDSSkNvyeiLbF3b+iPfzYx7/wzn6eL7NVi/ToPNZ6c2ex9nmcnqF2y7fDbYzauzb9T5+sGvbDrFFs89kmeZve5fH1lrQPqO0zI3DcCZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212956; c=relaxed/simple;
	bh=pkBLlfIg+/Zo4Dx5LU3Sh+NfodsgUPL8/vFz5ajqyhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyGYtk3wrOl9EvzQ5Q7XoQwHZjhrPbAPERi9SpMgvQUy6XUT1hT/NOwPYo8aENK366IymPb6BdYA0qs5CHXoogMzZ/zlGrgVYIaO1vSHujDds2R44yiQUBcfRRMj2HwWpzGDTzIaTdVMPwASb/Pb5MGa9/1nHH+rlUsmfm5bZSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuZC11gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuZC11gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6EEC19421;
	Tue, 26 Aug 2025 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212956;
	bh=pkBLlfIg+/Zo4Dx5LU3Sh+NfodsgUPL8/vFz5ajqyhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuZC11gk8Wnc8Pk/nBlLCEWEXDrjxxcg3rL2CQa7Fp3X5CzDefbQ/vg0tVH1VA77E
	 XOjYT5/NrR99xL6ZwgTJCQdDE2On1yx5ya7UJH9qADcJL064RUCKQRmlA7Tw+pVr4w
	 f8PoWQw6uOkuUkDIAFYgB5wkLwAfSRfOXCNlKYD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/587] ipv6: mcast: Check inet6_dev->dead under idev->mc_lock in __ipv6_dev_mc_inc().
Date: Tue, 26 Aug 2025 13:05:16 +0200
Message-ID: <20250826110957.193865882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit dbd40f318cf2f59759bd170c401adc20ba360a3e ]

Since commit 63ed8de4be81 ("mld: add mc_lock for protecting
per-interface mld data"), every multicast resource is protected
by inet6_dev->mc_lock.

RTNL is unnecessary in terms of protection but still needed for
synchronisation between addrconf_ifdown() and __ipv6_dev_mc_inc().

Once we removed RTNL, there would be a race below, where we could
add a multicast address to a dead inet6_dev.

  CPU1                            CPU2
  ====                            ====
  addrconf_ifdown()               __ipv6_dev_mc_inc()
                                    if (idev->dead) <-- false
    dead = true                       return -ENODEV;
    ipv6_mc_destroy_dev() / ipv6_mc_down()
      mutex_lock(&idev->mc_lock)
      ...
      mutex_unlock(&idev->mc_lock)
                                    mutex_lock(&idev->mc_lock)
                                    ...
                                    mutex_unlock(&idev->mc_lock)

The race window can be easily closed by checking inet6_dev->dead
under inet6_dev->mc_lock in __ipv6_dev_mc_inc() as addrconf_ifdown()
will acquire it after marking inet6_dev dead.

Let's check inet6_dev->dead under mc_lock in __ipv6_dev_mc_inc().

Note that now __ipv6_dev_mc_inc() no longer depends on RTNL and
we can remove ASSERT_RTNL() there and the RTNL comment above
addrconf_join_solict().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250702230210.3115355-4-kuni1840@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c |  7 +++----
 net/ipv6/mcast.c    | 11 +++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f6188bd9f55b..1c3b0ba289fb 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2193,13 +2193,12 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 	in6_ifa_put(ifp);
 }
 
-/* Join to solicited addr multicast group.
- * caller must hold RTNL */
+/* Join to solicited addr multicast group. */
 void addrconf_join_solict(struct net_device *dev, const struct in6_addr *addr)
 {
 	struct in6_addr maddr;
 
-	if (dev->flags&(IFF_LOOPBACK|IFF_NOARP))
+	if (READ_ONCE(dev->flags) & (IFF_LOOPBACK | IFF_NOARP))
 		return;
 
 	addrconf_addr_solict_mult(addr, &maddr);
@@ -3834,7 +3833,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	 *	   Do not dev_put!
 	 */
 	if (unregister) {
-		idev->dead = 1;
+		WRITE_ONCE(idev->dead, 1);
 
 		/* protected by rtnl_lock */
 		RCU_INIT_POINTER(dev->ip6_ptr, NULL);
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index e153dac47a53..160b452f75e7 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -906,23 +906,22 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 static int __ipv6_dev_mc_inc(struct net_device *dev,
 			     const struct in6_addr *addr, unsigned int mode)
 {
-	struct ifmcaddr6 *mc;
 	struct inet6_dev *idev;
-
-	ASSERT_RTNL();
+	struct ifmcaddr6 *mc;
 
 	/* we need to take a reference on idev */
 	idev = in6_dev_get(dev);
-
 	if (!idev)
 		return -EINVAL;
 
-	if (idev->dead) {
+	mutex_lock(&idev->mc_lock);
+
+	if (READ_ONCE(idev->dead)) {
+		mutex_unlock(&idev->mc_lock);
 		in6_dev_put(idev);
 		return -ENODEV;
 	}
 
-	mutex_lock(&idev->mc_lock);
 	for_each_mc_mclock(idev, mc) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
 			mc->mca_users++;
-- 
2.39.5



