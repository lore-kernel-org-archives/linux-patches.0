Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC536BFBB;
	Tue, 14 May 2024 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683471; cv=none; b=RdFhZ7HZtKgZayZr3HuvRLxhwlTZwKFnm/8cnJn2zH5f2TVp8VL+WpjQYoy6hl/y7L3VU58rlLGjPx5lISY+meCX+M4dZgiL5utt6A2VmFMs75IKTNqohyb1wB7kdAmSk/fbL1qJnRZB3H1GAMk78iYBMY1qjunSZlqxI8NxZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683471; c=relaxed/simple;
	bh=C9UOoRpsJPHYjS0pF1WI74lAUGZhjB4gPNKM++d4aOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG7A5zkeCwNxDr5mIbwcmpBnc0tQzxejQKFL6ktZX4AcNj+yl5OA3IuFjXCXLzwAWRJfjRH2YkYtCGHUYYzE79Skg+AP/opnMz+pmj6bFv8ooY80CQ8bv6wcUn1NF+OM54Hzbm0HohTagoSHq1gwFO1iBbqWisq8M0dSNeAiWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2h+uraRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2h+uraRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D51C2BD10;
	Tue, 14 May 2024 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683471;
	bh=C9UOoRpsJPHYjS0pF1WI74lAUGZhjB4gPNKM++d4aOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2h+uraRACxZWlsEqpphyXb8VoqU53SegEyef4dKVjrb2dX+zB21zac3MasOCZLx5+
	 GGxvjniy7Kbur3TSy5ht36iDu7g70OFfiRQ9kopZTdHWRSVqiXi/NgWbBQ2jZImBq+
	 321Qe6mWK34MSz+ZAA5gt0GcJzI8Vopz339TjToM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 223/336] ipv6: annotate data-races around cnf.disable_ipv6
Date: Tue, 14 May 2024 12:17:07 +0200
Message-ID: <20240514101047.036229670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d289ab65b89c1d4d88417cb6c03e923f21f95fae ]

disable_ipv6 is read locklessly, add appropriate READ_ONCE()
and WRITE_ONCE() annotations.

v2: do not preload net before rtnl_trylock() in
    addrconf_disable_ipv6() (Jiri)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 4db783d68b9b ("ipv6: prevent NULL dereference in ip6_output()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c   | 9 +++++----
 net/ipv6/ip6_input.c  | 4 ++--
 net/ipv6/ip6_output.c | 2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 775f51cbc539b..c4e2f9d35e687 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4164,7 +4164,7 @@ static void addrconf_dad_work(struct work_struct *w)
 			if (!ipv6_generate_eui64(addr.s6_addr + 8, idev->dev) &&
 			    ipv6_addr_equal(&ifp->addr, &addr)) {
 				/* DAD failed for link-local based on MAC */
-				idev->cnf.disable_ipv6 = 1;
+				WRITE_ONCE(idev->cnf.disable_ipv6, 1);
 
 				pr_info("%s: IPv6 being disabled!\n",
 					ifp->idev->dev->name);
@@ -6325,7 +6325,8 @@ static void addrconf_disable_change(struct net *net, __s32 newf)
 		idev = __in6_dev_get(dev);
 		if (idev) {
 			int changed = (!idev->cnf.disable_ipv6) ^ (!newf);
-			idev->cnf.disable_ipv6 = newf;
+
+			WRITE_ONCE(idev->cnf.disable_ipv6, newf);
 			if (changed)
 				dev_disable_change(idev);
 		}
@@ -6342,7 +6343,7 @@ static int addrconf_disable_ipv6(struct ctl_table *table, int *p, int newf)
 
 	net = (struct net *)table->extra2;
 	old = *p;
-	*p = newf;
+	WRITE_ONCE(*p, newf);
 
 	if (p == &net->ipv6.devconf_dflt->disable_ipv6) {
 		rtnl_unlock();
@@ -6350,7 +6351,7 @@ static int addrconf_disable_ipv6(struct ctl_table *table, int *p, int newf)
 	}
 
 	if (p == &net->ipv6.devconf_all->disable_ipv6) {
-		net->ipv6.devconf_dflt->disable_ipv6 = newf;
+		WRITE_ONCE(net->ipv6.devconf_dflt->disable_ipv6, newf);
 		addrconf_disable_change(net, newf);
 	} else if ((!newf) ^ (!old))
 		dev_disable_change((struct inet6_dev *)table->extra1);
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index b8378814532ce..1ba97933c74fb 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -168,9 +168,9 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 
 	SKB_DR_SET(reason, NOT_SPECIFIED);
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
-	    !idev || unlikely(idev->cnf.disable_ipv6)) {
+	    !idev || unlikely(READ_ONCE(idev->cnf.disable_ipv6))) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
-		if (idev && unlikely(idev->cnf.disable_ipv6))
+		if (idev && unlikely(READ_ONCE(idev->cnf.disable_ipv6)))
 			SKB_DR_SET(reason, IPV6DISABLED);
 		goto drop;
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 568065a015c41..e4b02e94c2eb3 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -234,7 +234,7 @@ int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
 
-	if (unlikely(idev->cnf.disable_ipv6)) {
+	if (unlikely(READ_ONCE(idev->cnf.disable_ipv6))) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 		kfree_skb_reason(skb, SKB_DROP_REASON_IPV6DISABLED);
 		return 0;
-- 
2.43.0



