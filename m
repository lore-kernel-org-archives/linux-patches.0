Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15313AFCE3;
	Sat, 30 May 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164517; cv=none; b=uj9zHkA3Fg4LoxtjOUKb0aVNVSY+ROJx+VTBMxfNS6bwQUiiMQD1W7ho7uLs7G1hsb5CM2B1RHvYuj9wrd9JY2QngtXXBJqEHy3EtE5TQZG88eEjohTx4GxHMQ/exMUaINyVZBfjl8jRpV5tZnMXQtC4yEaA9GpeO5v7HeSpkFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164517; c=relaxed/simple;
	bh=S4tXdE5B6AiguL8g/I48HSlpZ53whSHzOAM5Snf02PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eymXdKeMW0VyoYedbVUiW+sHF0BIHZk+dQ4sGK1vZCI4OO7WQXEkh3AOQj1e3ieT+covB6rvd1Jf6mM+/bkqTueDKavdkhGcs3x+kTQs9Rux0Se3Q4Rp2vVXJAb8X3N2CKOe0T7fysPB7bbBEL8iBgqp//1blxlA0u/7F8raqEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRLy/x2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRLy/x2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077291F00893;
	Sat, 30 May 2026 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164516;
	bh=vv0gAIJCDxVS+zXp6gCPcZZWhmhWEhQZQAaiMdO4yh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FRLy/x2yO1k62rubgLR8PFYqs5W7rXjx5H6c2ZdrF83AmTY9k9baRccfCs30t8wcB
	 W1fXRRN9NjyR6AJIWwARoJEtx5V8SVqRf7bznGxboJPTHHZGo7MyOUpABqJwD07Nhc
	 ZzxnIjBE9T/dBqZOtN/A66I812neuDmB9qqeqsZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kito Xu (veritas501)" <hxzene@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 578/776] netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check
Date: Sat, 30 May 2026 18:04:52 +0200
Message-ID: <20260530160255.028218444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 711987ba281fd806322a7cd244e98e2a81903114 ]

The nf_osf_ttl() function accessed skb->dev to perform a local interface
address lookup without verifying that the device pointer was valid.

Additionally, the implementation utilized an in_dev_for_each_ifa_rcu
loop to match the packet source address against local interface
addresses. It assumed that packets from the same subnet should not see a
decrement on the initial TTL. A packet might appear it is from the same
subnet but it actually isn't especially in modern environments with
containers and virtual switching.

Remove the device dereference and interface loop. Replace the logic with
a switch statement that evaluates the TTL according to the ttl_check.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Kito Xu (veritas501) <hxzene@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/20260414074556.2512750-1-hxzene@gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 2207bda442d54..6d3dfbeb398cb 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -31,26 +31,18 @@ EXPORT_SYMBOL_GPL(nf_osf_fingers);
 static inline int nf_osf_ttl(const struct sk_buff *skb,
 			     int ttl_check, unsigned char f_ttl)
 {
-	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
 	const struct iphdr *ip = ip_hdr(skb);
-	const struct in_ifaddr *ifa;
-	int ret = 0;
 
-	if (ttl_check == NF_OSF_TTL_TRUE)
+	switch (ttl_check) {
+	case NF_OSF_TTL_TRUE:
 		return ip->ttl == f_ttl;
-	if (ttl_check == NF_OSF_TTL_NOCHECK)
-		return 1;
-	else if (ip->ttl <= f_ttl)
+		break;
+	case NF_OSF_TTL_NOCHECK:
 		return 1;
-
-	in_dev_for_each_ifa_rcu(ifa, in_dev) {
-		if (inet_ifa_match(ip->saddr, ifa)) {
-			ret = (ip->ttl == f_ttl);
-			break;
-		}
+	case NF_OSF_TTL_LESS:
+	default:
+		return ip->ttl <= f_ttl;
 	}
-
-	return ret;
 }
 
 struct nf_osf_hdr_ctx {
-- 
2.53.0



