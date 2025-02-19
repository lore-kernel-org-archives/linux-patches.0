Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFFD1ADC84;
	Wed, 19 Feb 2025 08:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954682; cv=none; b=VKMPnI1IbL+xvuVr2OGtNSvcGLvMZHxSGPcODO+59aTh2M79/X/L4M19afcZKcZmTgiFT7L1Rk6IvOjjJWZNGeYhGeDzPQYpGXrYKnhG6UNShmep8axa5xm/UCQNNSSQojPVsha/bltsizXF7XPTcnVNborF+lYWXhyEfqoAREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954682; c=relaxed/simple;
	bh=OLOrwV3yP4nGBcbjESegT/kEwja0+KCMh4bLHys4dzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSy293jD+I9T4C/XOouwEXx3xBgvODWU9EsAdO5X0xkZt4b7sbHHk1fRGkfhc8XtrQzEUzrPfAOaEaaW7mPZDH0Lzl+mQUPKawRGYo8zBqa1+GjittRyBooEDmhh/PqlYYYjRzg9vNLnTI2tlPodrNTR7MJuy3Qgl6gEeaLL74o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lX3O06v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lX3O06v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A78C4CED1;
	Wed, 19 Feb 2025 08:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954681;
	bh=OLOrwV3yP4nGBcbjESegT/kEwja0+KCMh4bLHys4dzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lX3O06v34RaJ7hJxhs8vL2/zQmC0SVNG65tieAa94cIzEsg+DJEvPZLmRhTlYCXJ1
	 3FWAQg1eZ7UEfgjVSUMV/VgMT2hcrgX8aDwujTDeDtFytS+UjfvoQWQJ7STUIWaXWn
	 lvOhjiNjPmRAhWXg8zsZU/D+VtXt5q2zkynSQgzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 248/274] ipv6: mcast: add RCU protection to mld_newpack()
Date: Wed, 19 Feb 2025 09:28:22 +0100
Message-ID: <20250219082619.285752957@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a527750d877fd334de87eef81f1cb5f0f0ca3373 ]

mld_newpack() can be called without RTNL or RCU being held.

Note that we no longer can use sock_alloc_send_skb() because
ipv6.igmp_sk uses GFP_KERNEL allocations which can sleep.

Instead use alloc_skb() and charge the net->ipv6.igmp_sk
socket under RCU protection.

Fixes: b8ad0cbc58f7 ("[NETNS][IPV6] mcast - handle several network namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250212141021.1663666-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6551648512585..b7b62e5a562e5 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1730,21 +1730,19 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 	struct net_device *dev = idev->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	struct net *net = dev_net(dev);
 	const struct in6_addr *saddr;
 	struct in6_addr addr_buf;
 	struct mld2_report *pmr;
 	struct sk_buff *skb;
 	unsigned int size;
 	struct sock *sk;
-	int err;
+	struct net *net;
 
-	sk = net->ipv6.igmp_sk;
 	/* we assume size > sizeof(ra) here
 	 * Also try to not allocate high-order pages for big MTU
 	 */
 	size = min_t(int, mtu, PAGE_SIZE / 2) + hlen + tlen;
-	skb = sock_alloc_send_skb(sk, size, 1, &err);
+	skb = alloc_skb(size, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 
@@ -1752,6 +1750,12 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 	skb_reserve(skb, hlen);
 	skb_tailroom_reserve(skb, mtu, tlen);
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(dev);
+	sk = net->ipv6.igmp_sk;
+	skb_set_owner_w(skb, sk);
+
 	if (ipv6_get_lladdr(dev, &addr_buf, IFA_F_TENTATIVE)) {
 		/* <draft-ietf-magma-mld-source-05.txt>:
 		 * use unspecified address as the source address
@@ -1763,6 +1767,8 @@ static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 
 	ip6_mc_hdr(sk, skb, dev, saddr, &mld2_all_mcr, NEXTHDR_HOP, 0);
 
+	rcu_read_unlock();
+
 	skb_put_data(skb, ra, sizeof(ra));
 
 	skb_set_transport_header(skb, skb_tail_pointer(skb) - skb->data);
-- 
2.39.5



