Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708761C7013;
	Wed, 19 Feb 2025 08:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955372; cv=none; b=c1ExdLphX+gJC8tJH4S+ndnx1cBgPFSOl8lGp3o1bSog5y5HWv29SvLVICd5d+W0ENBMQYOGEpEmos4WoFhsmt6engpmF+ORZr4qKtEi/631DJKEpe/5yIff/aBy8hbF16UE4iHFn/dF2eLjhMZjqrLHnLjU4+lsP+Z83atlvos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955372; c=relaxed/simple;
	bh=lmmtaURWVhGfgTbkDl+uXA+V9pdUlY8mT6tm4RzuKyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGD6V30kZ7QkQTQ/iQSBWx4T7TDD8QW4JZIa2uS8evwHoyZrIJRA1FCKAARbll7xRDIwuxt8qmlvBhqmH6kUf6g9IISPPDF6AvqTwzMw2W9GRj4AQ9bEFizU3hRtNLh8GBzLRxGfMrIbhmKu742FuTU3vpwn8F+K53J/G6ybFxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0fuXFMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0fuXFMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6832C4CED1;
	Wed, 19 Feb 2025 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955372;
	bh=lmmtaURWVhGfgTbkDl+uXA+V9pdUlY8mT6tm4RzuKyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0fuXFMU9UXqHwFgayLp17yDidu882G453XXutGFYeqrmhrG+L1bfSLjjSWaOghVY
	 CuN+/t0I4CaIWBAZ5npXwCHas7fLv/Lommvg5FCanhDwdlJ+k/svw0XPnGRTciLrA/
	 3cSNcpYE+CeobrkEqjH3uHUKdUf4fKQxLgpNFVgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/230] arp: use RCU protection in arp_xmit()
Date: Wed, 19 Feb 2025 09:28:35 +0100
Message-ID: <20250219082609.441406064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a42b69f692165ec39db42d595f4f65a4c8f42e44 ]

arp_xmit() can be called without RTNL or RCU protection.

Use RCU protection to avoid potential UAF.

Fixes: 29a26a568038 ("netfilter: Pass struct net into the netfilter hooks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 11c1519b36993..59ffaa89d7b05 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -659,10 +659,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
  */
 void arp_xmit(struct sk_buff *skb)
 {
+	rcu_read_lock();
 	/* Send it off, maybe filter it using firewalling first.  */
 	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT,
-		dev_net(skb->dev), NULL, skb, NULL, skb->dev,
+		dev_net_rcu(skb->dev), NULL, skb, NULL, skb->dev,
 		arp_xmit_finish);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(arp_xmit);
 
-- 
2.39.5



