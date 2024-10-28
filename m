Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AC18FC89;
	Mon, 28 Oct 2024 06:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097526; cv=none; b=ITXCZO/nCkmFrtN31xqSVmY+iuxKGJJWXGY6RCrE82suggz7bX5ep96dc4xAQkBM3YlCsLpm4zvMY50Ukc8RjawFKkd7KkjI5kF39DBftwVTVNGmvDK4O5RBkRCAeiTI7qvbsxOWeovwvy3WhQ56A1vl8OlZEne1WXmrmrLRutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097526; c=relaxed/simple;
	bh=TNfdy5WtjmRvbsPzp6IiO8kQbSYVm+VtruONcHCRv/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oc28Giaxyd/Kmh9Lq7JDteRxPWTvTsQuRU041dWOWEMuGnNH5aqU3DRSK0BzpM2uw0WojLPe1JLJXi0JZK0jqyqSGax1XM3llerARvMBARek8Qq/SAwpJJCbqJRV9/y1l2qbUWv0J14p+uQKH+YutV+Hg98CpgpMrSGBPjoXQQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hmi2X4ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hmi2X4ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A5C4CEC3;
	Mon, 28 Oct 2024 06:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097526;
	bh=TNfdy5WtjmRvbsPzp6IiO8kQbSYVm+VtruONcHCRv/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hmi2X4ulLKGT3+eec4TVc8ypUPB5o91QtOf+osWJf4lWsRLLJLbw6DbMqyJysxwTp
	 P/TTu6v/Bj1tJKcqtVlTBbvfmPj8GpBq6aUlS/x9SwKPQVzbzYP0ZtrItX5e6nT9dm
	 oD4B2BCKQtpK/rBIRdtCP7mT0hlgjpOfbmx4lKx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/208] ipv4: give an IPv4 dev to blackhole_netdev
Date: Mon, 28 Oct 2024 07:23:32 +0100
Message-ID: <20241028062307.448678472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 22600596b6756b166fd052d5facb66287e6f0bad ]

After commit 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to
invalidate dst entries"), blackhole_netdev was introduced to invalidate
dst cache entries on the TX path whenever the cache times out or is
flushed.

When two UDP sockets (sk1 and sk2) send messages to the same destination
simultaneously, they are using the same dst cache. If the dst cache is
invalidated on one path (sk2) while the other (sk1) is still transmitting,
sk1 may try to use the invalid dst entry.

         CPU1                   CPU2

      udp_sendmsg(sk1)       udp_sendmsg(sk2)
      udp_send_skb()
      ip_output()
                                             <--- dst timeout or flushed
                             dst_dev_put()
      ip_finish_output2()
      ip_neigh_for_gw()

This results in a scenario where ip_neigh_for_gw() returns -EINVAL because
blackhole_dev lacks an in_dev, which is needed to initialize the neigh in
arp_constructor(). This error is then propagated back to userspace,
breaking the UDP application.

The patch fixes this issue by assigning an in_dev to blackhole_dev for
IPv4, similar to what was done for IPv6 in commit e5f80fcf869a ("ipv6:
give an IPv6 dev to blackhole_netdev"). This ensures that even when the
dst entry is invalidated with blackhole_dev, it will not fail to create
the neigh entry.

As devinet_init() is called ealier than blackhole_netdev_init() in system
booting, it can not assign the in_dev to blackhole_dev in devinet_init().
As Paolo suggested, add a separate late_initcall() in devinet.c to ensure
inet_blackhole_dev_init() is called after blackhole_netdev_init().

Fixes: 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to invalidate dst entries")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/3000792d45ca44e16c785ebe2b092e610e5b3df1.1728499633.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index cb0c80328eebf..4822f68edbf08 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -283,17 +283,19 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	/* Account for reference dev->ip_ptr (below) */
 	refcount_set(&in_dev->refcnt, 1);
 
-	err = devinet_sysctl_register(in_dev);
-	if (err) {
-		in_dev->dead = 1;
-		neigh_parms_release(&arp_tbl, in_dev->arp_parms);
-		in_dev_put(in_dev);
-		in_dev = NULL;
-		goto out;
+	if (dev != blackhole_netdev) {
+		err = devinet_sysctl_register(in_dev);
+		if (err) {
+			in_dev->dead = 1;
+			neigh_parms_release(&arp_tbl, in_dev->arp_parms);
+			in_dev_put(in_dev);
+			in_dev = NULL;
+			goto out;
+		}
+		ip_mc_init_dev(in_dev);
+		if (dev->flags & IFF_UP)
+			ip_mc_up(in_dev);
 	}
-	ip_mc_init_dev(in_dev);
-	if (dev->flags & IFF_UP)
-		ip_mc_up(in_dev);
 
 	/* we can receive as soon as ip_ptr is set -- do this last */
 	rcu_assign_pointer(dev->ip_ptr, in_dev);
@@ -332,6 +334,19 @@ static void inetdev_destroy(struct in_device *in_dev)
 	in_dev_put(in_dev);
 }
 
+static int __init inet_blackhole_dev_init(void)
+{
+	int err = 0;
+
+	rtnl_lock();
+	if (!inetdev_init(blackhole_netdev))
+		err = -ENOMEM;
+	rtnl_unlock();
+
+	return err;
+}
+late_initcall(inet_blackhole_dev_init);
+
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
 {
 	const struct in_ifaddr *ifa;
-- 
2.43.0



