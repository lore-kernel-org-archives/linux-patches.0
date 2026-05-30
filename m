Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A1733E36A;
	Sat, 30 May 2026 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161820; cv=none; b=X+/9TFudT3mddux1uunxDi9jUodb4WaYzigC7HPZzJtAFiRWe8oLMfyAGgwzWTbd/fb9Gh3frPK4t/MeMkLXd9DZ4NqzOtUqUdKXfoj4vTT63r8n4mnrJFKBE3NsHaBt8r13nfTxR1I3yQX/9p3z7wk2pi1LR7sFwvWn5nuFzM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161820; c=relaxed/simple;
	bh=CTfCbwUp0TwMA70soEGgTtzAYWNjcKSP0Flc9cF8RMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k94mujpxazLJluNMWhPmm5wx2NEe+P8Ax5plvni0G09g33fnE4kBsoD08sO1HuLpB16ZubraQH2hdi6a8uDy5D5I0rj09FvfAhrqdD+kz1kJSrhyRP9Rky7you7LtezAO3fRWOiupzvJC0AVAfZa2M5pwGG+qiWlB3oU9yi5dMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTu5wreM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTu5wreM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D0B1F00893;
	Sat, 30 May 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161819;
	bh=yPJN1e7rzPNkMCt0OApgNjIOF0U4KnW2mRPbIuZVB+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTu5wreMcZgOxp3nEJdu8qDE5yPK5ZzCo5aCVprLjn/wy/4iSobOWB1K6r1tQ8Gn5
	 0267ykDHnbhG0R3x8aJEuWNXz1/tEv+7XrOpu/eyoJkmvRpUqhu4Vd9ruu4EPP1vnv
	 TTWStJq87zpoH6dFMBdqa6P9aJjy9Mqq84FHhWDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Joe Damato <joe@dama.to>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 696/969] ipv6: fix possible UAF in icmpv6_rcv()
Date: Sat, 30 May 2026 18:03:40 +0200
Message-ID: <20260530160319.734648615@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f996edd7615e686ada141b7f3395025729ff8ccb ]

Caching saddr and daddr before pskb_pull() is problematic
since skb->head can change.

Remove these temporary variables:

- We only access &ipv6_hdr(skb)->saddr and &ipv6_hdr(skb)->daddr
  when net_dbg_ratelimited() is called in the slow path.

- Avoid potential future misuse after pskb_pull() call.

Fixes: 4b3418fba0fe ("ipv6: icmp: include addresses in debug messages")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260416103505.2380753-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 80eabb22d144f..877cb5e8ded7b 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -889,7 +889,6 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	struct net_device *dev = icmp6_dev(skb);
 	struct inet6_dev *idev = __in6_dev_get(dev);
-	const struct in6_addr *saddr, *daddr;
 	struct icmp6hdr *hdr;
 	u8 type;
 
@@ -920,12 +919,10 @@ static int icmpv6_rcv(struct sk_buff *skb)
 
 	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_INMSGS);
 
-	saddr = &ipv6_hdr(skb)->saddr;
-	daddr = &ipv6_hdr(skb)->daddr;
-
 	if (skb_checksum_validate(skb, IPPROTO_ICMPV6, ip6_compute_pseudo)) {
 		net_dbg_ratelimited("ICMPv6 checksum failed [%pI6c > %pI6c]\n",
-				    saddr, daddr);
+				    &ipv6_hdr(skb)->saddr,
+				    &ipv6_hdr(skb)->daddr);
 		goto csum_error;
 	}
 
@@ -1007,7 +1004,8 @@ static int icmpv6_rcv(struct sk_buff *skb)
 			break;
 
 		net_dbg_ratelimited("icmpv6: msg of unknown type [%pI6c > %pI6c]\n",
-				    saddr, daddr);
+				    &ipv6_hdr(skb)->saddr,
+				    &ipv6_hdr(skb)->daddr);
 
 		/*
 		 * error of unknown type.
-- 
2.53.0



