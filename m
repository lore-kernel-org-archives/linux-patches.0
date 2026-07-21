Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8246C4C0;
	Tue, 21 Jul 2026 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657721; cv=none; b=seFbogO0Gtp7K5Qx6Z0iRUBmKTl3qnKG2yo8asP6rY60SXzWHpMlh0ntkX8mCyLVtFhaLzt4Dv8iChif6DXxSGATl0BIWCRAEj2Jsz4YHwnRqeLptYIipwlsgod5vIDOUl4qKJbq/sdtjqiFBUI6mJw3fnlBUduRhYq9+Je3Lb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657721; c=relaxed/simple;
	bh=i8dX51NzbN4u+6FCvuSZJBvxUlmZIRYelLo1YFeeE90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjgWrxeSos26DoPMVzM0EurOIHWyjg2stkVNtJ4EDWyssKTwAHeS8keDl9Uy6GX0rlgLot53moxVwhhrF7IUPj8CzuLzYPeP6a+ymVZZMZFzhi5L50JrRcRpw6gavFKJkOAHTitB16FeWbbJth0hUYJed2pcRSR22R/W3SYUgow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2ozXL/S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2ozXL/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF311F000E9;
	Tue, 21 Jul 2026 18:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657720;
	bh=hEjAii3xMciVLNx/DmV9MA4krFcILTKB+aqWRwVm2+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2ozXL/SOVu5VZJrJvPAeezEiUxg4BhqX+VGbs3AR1PaiZp7QTp/TRAhOGcaM6sJR
	 g3TXzRF1QsDxGvv2rXkDljYrpJlWuw8wOlHXkc/6vQfnMYOAlLk6hOQnzGNb06RDJq
	 rxZ03hOwCuiKjxfuWBcHGWAOKTJM2VWuh/yqbKcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0871/1611] ipv6: ndisc: fix NULL deref in accept_untracked_na()
Date: Tue, 21 Jul 2026 17:16:27 +0200
Message-ID: <20260721152534.982910683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit d186e942365acece7c56d39da05dd63bf95b280a ]

accept_untracked_na() re-fetches the inet6_dev with __in6_dev_get(dev)
and dereferences idev->cnf.accept_untracked_na without a NULL check,
even though its only caller ndisc_recv_na() already fetched and
NULL-checked idev for the same device.

Both reads of dev->ip6_ptr run in the same RCU read-side critical
section, but a concurrent addrconf_ifdown() can clear dev->ip6_ptr
between them: lowering the MTU below IPV6_MIN_MTU calls addrconf_ifdown()
without the synchronize_net() that orders the unregister path, so the
re-fetch returns NULL and oopses:

 BUG: KASAN: null-ptr-deref in ndisc_recv_na (net/ipv6/ndisc.c:974)
 Read of size 4 at addr 0000000000000364
 Call Trace:
  <IRQ>
  ndisc_recv_na (net/ipv6/ndisc.c:974)
  icmpv6_rcv (net/ipv6/icmp.c:1193)
  ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:479)
  ip6_input_finish (net/ipv6/ip6_input.c:534)
  ip6_input (net/ipv6/ip6_input.c:545)
  ip6_mc_input (net/ipv6/ip6_input.c:635)
  ipv6_rcv (net/ipv6/ip6_input.c:351)
  </IRQ>

It is reachable by an unprivileged user via a network namespace.

Pass the caller's already validated idev instead of re-fetching it; the
idev stays alive for the whole RCU critical section, so it is safe even
after dev->ip6_ptr has been cleared.

Fixes: aaa5f515b16b ("net: ipv6: new accept_untracked_na option to accept na only if in-network")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20260617065512.2529757-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index ded2d3a0660c3e..9df1fba967c6e8 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -966,10 +966,8 @@ static enum skb_drop_reason ndisc_recv_ns(struct sk_buff *skb)
 	return reason;
 }
 
-static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
+static int accept_untracked_na(struct inet6_dev *idev, struct in6_addr *saddr)
 {
-	struct inet6_dev *idev = __in6_dev_get(dev);
-
 	switch (READ_ONCE(idev->cnf.accept_untracked_na)) {
 	case 0: /* Don't accept untracked na (absent in neighbor cache) */
 		return 0;
@@ -979,7 +977,7 @@ static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
 		 * same subnet as an address configured on the interface that
 		 * received the na
 		 */
-		return !!ipv6_chk_prefix(saddr, dev);
+		return !!ipv6_chk_prefix(saddr, idev->dev);
 	default:
 		return 0;
 	}
@@ -1077,7 +1075,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 	 */
 	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
 	if (!neigh && lladdr && idev && READ_ONCE(idev->cnf.forwarding)) {
-		if (accept_untracked_na(dev, saddr)) {
+		if (accept_untracked_na(idev, saddr)) {
 			neigh = neigh_create(&nd_tbl, &msg->target, dev);
 			new_state = NUD_STALE;
 		}
-- 
2.53.0



