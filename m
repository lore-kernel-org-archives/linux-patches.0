Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07BF431488;
	Thu, 30 Jul 2026 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422164; cv=none; b=dIYc10X95G12azdrd+FKX0oTq0hxSI61+Js/ktRk/vXO+rox6zxwaw7+wKxYTVixwVNqfDR8hObZd9asB7FzA4glw56oznTjamME6KB47c4+iKSmIjTvZ6xmvZk80f88rlpj7GhbT1NMwjUBziYxyf7+IH27k9KTyxOgFWmP2Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422164; c=relaxed/simple;
	bh=95uXDGW0jXBWhIVUIv3wOZx+vPmucR7UxtQo7USthmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNQkLA0GEkPp6hmfhOTECGAujUZoKBuYvr+kg/cA7UlwrwkkWUfRYQAm86onyVdkWXv7U4zIdwTyTEw6CcL9YwvtUX0yEDbhAhH/qgL3L0/6TctAfHrz6q08vEoekfuVSfzidk+n+th2AWy/XeXw+JncyXYHI8kRBbFWb++raKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPUJmjFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPUJmjFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1461F00A3A;
	Thu, 30 Jul 2026 14:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422163;
	bh=WIBJVUPAmjgS20KTpC6yJz7ONFyacIYb2GsbNvJU1Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dPUJmjFZKvsOZEjkWpKXRjTXV6uanhhRJ02ondCtjZVwKKWzU7aP6QbNzF/xh3u91
	 yVwrof/WSeq6kyvJJbGBfEJLDhfzYUb1yJmqanlVozPi/jquuCjk2NHo+DK2yAE059
	 nqT6QvIW5lUk6wl0l5cjvFBvZV6GiRKR7+FkWdlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+84d4a405ed798b40c96d@syzkaller.appspotmail.com,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 345/744] ipv6: Change allocation flags to match rcu_read_lock section requirements
Date: Thu, 30 Jul 2026 16:10:18 +0200
Message-ID: <20260730141451.618393512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit 313a123e1fca8827bb463db1f4bb211309764563 ]

Since the call to __ip6_del_rt_siblings has been converted under
rcu read lock and it only has one call point
we should no longer block or yield.

Our stack trace from the syzbot reproducer looks as follows:

__ip6_del_rt_siblings
  rtnl_notify (Here we pass gfp_any() -> GFP_KERNEL)
    nlmsg_notify
      nlmsg_multicast
        nlmsg_multicast_filtered
          netlink_broadcast_filtered (GFP_KERNEL passed from earlier)

netlink_broadcast_filtered can yield if GFP_KERNEL
is passed, which we do not want to happen.

Fix this by changing the allocation flag of rtnl_notify.

Also change the flag passed to nlmsg_new. Even though it
is not related to the syzbot generated bug it still falls
under the same requirements.

Reported-by: syzbot+84d4a405ed798b40c96d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=84d4a405ed798b40c96d
Fixes: bd11ff421d36 ("ipv6: Get rid of RTNL for SIOCDELRT and RTM_DELROUTE.")
Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260719105759.558050-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 88b46967bb67dc..d4edc133c045c4 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4020,7 +4020,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 		struct fib6_node *fn;
 
 		/* prefer to send a single notification with all hops */
-		skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
+		skb = nlmsg_new(rt6_nlmsg_size(rt), GFP_ATOMIC);
 		if (skb) {
 			u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
 
@@ -4076,7 +4076,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 
 	if (skb) {
 		rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
-			    info->nlh, gfp_any());
+			    info->nlh, GFP_ATOMIC);
 	}
 	return err;
 }
-- 
2.53.0



