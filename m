Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0E44C641;
	Thu, 30 Jul 2026 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427949; cv=none; b=ar0JdQznJHxCn5lJBM9HUH++IFIgdAsnJZpfONMAIwGOmgKM9LzyWwLxOzbfJQlL1vDk6En8XgfcPqYG7DhI53s9f5Whn39LFOR4nYNxyMHoF+mSWmD30W7sBjDKvTDiesxfN0PQ9aKZqof9gUi8N0avOnnSz8JAauwAwRu0xWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427949; c=relaxed/simple;
	bh=4rxkiQeRQ63nROJrzz40j9B+Kwza+FxaY5cdGm4emtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNb+VigWXf9TK+QfDRI/ax2DB4FStHwTRhYXhMonhrglyNnEeI66LxA2CYwNQeaRu3UUMzPjqiPyiKAc3zN+fcdwwHa0jd995gRCpw5bXF9xjWRa4X+FvXP8Siwk5kTu7wjAWxDSOHRngZjkreQPrhd6htV74CWkxL7NYvDoEX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjIt0YJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjIt0YJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F21F000E9;
	Thu, 30 Jul 2026 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427948;
	bh=F7HtYlc20TSGzwGjHBwCsegOzkS2gQQE9M7RRQtTdww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gjIt0YJEqL/KVWXRFY9K4kO+FRirXo5LFsaqH/zfb5EN8/Uq8gpmQPKzprZ6SVqC6
	 Y4Gohp1btPe/vFhSZdERHi5GL840HqX0N3uUuOe7elMpmaBfWCK9185HaDlxHpgfw0
	 IS0u5swCccFItRAh8jH8ogWocBgRBmjSSIcJQQPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 350/484] ipv6: ndisc: fix NULL deref in accept_untracked_na()
Date: Thu, 30 Jul 2026 16:14:07 +0200
Message-ID: <20260730141431.081651152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit d186e942365acece7c56d39da05dd63bf95b280a upstream.

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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index ee34831f5621a8..342e7066f765f5 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -973,10 +973,8 @@ static enum skb_drop_reason ndisc_recv_ns(struct sk_buff *skb)
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
@@ -986,7 +984,7 @@ static int accept_untracked_na(struct net_device *dev, struct in6_addr *saddr)
 		 * same subnet as an address configured on the interface that
 		 * received the na
 		 */
-		return !!ipv6_chk_prefix(saddr, dev);
+		return !!ipv6_chk_prefix(saddr, idev->dev);
 	default:
 		return 0;
 	}
@@ -1085,7 +1083,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 	 */
 	new_state = msg->icmph.icmp6_solicited ? NUD_REACHABLE : NUD_STALE;
 	if (!neigh && lladdr && idev && idev->cnf.forwarding) {
-		if (accept_untracked_na(dev, saddr)) {
+		if (accept_untracked_na(idev, saddr)) {
 			neigh = neigh_create(&nd_tbl, &msg->target, dev);
 			new_state = NUD_STALE;
 		}
-- 
2.53.0



