Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380C38F658;
	Sat, 17 Oct 2026 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259956; cv=none; b=Q63cgSch0tbenIJd62lVEPkM0WMt4yhIvXprl+rXe6NdxjL5/iTeq7Pa4kJAPoPgnuCi/pxVxcIMOxCn83u1bXjr4WdEFCMSt2O7vxF+MiMOAcDyqBIJNbXCXBf/TFrCjSg9x0dWVN/E2ZWGQBKAfRF3jp/IPzJN549HusqGBfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259956; c=relaxed/simple;
	bh=N27OOl7e4zmgsd+jyx93G9/xYX/x/2u2d+8Iid9wNE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9/tGv1YMya5DqOIjE//kSLe6rZt6PVGeqxyD04TtM0F4CtPcBXLjBD/OSszr1cPxUM0+AHXvQuRvdUCCeDIi8PstqXpjdSnZR4/ih+oPkhzWPYy4eMdjlid40MMfpZ0anUan6uAKCzMdTy4Z43ILC1GUnV9lwfUt4kU3hRu2Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=im1gOUU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="im1gOUU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1F31F000C4;
	Sat, 17 Oct 2026 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259954;
	bh=qQXfljo5vz+fIlmXpJ/pzP9LeKTOXqVZeboLhg7gQ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=im1gOUU5Lng+qkxtszULHNflVJssckUEq+tj9KMs8c2X6r9sTgCJ1UGTUFoIXkxta
	 gKxxn90W3J0BEt2TiIeH+Y84k7qsanRqmJfoylcGiquMuDK6UzdB256BNhASusdlnB
	 yJ0X08fkXtxQn6XamHFaBJV2fBb3Nz8ltA5JOLrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1385/1674] ip6mr: do not clone dst in ip6mr_cache_report()
Date: Sat, 17 Oct 2026 18:00:57 +0200
Message-ID: <20261017160506.714525645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 235b42b5860189eb8c27c36435ad932cae65a734 ]

IPv6 input attaches a non-refcounted (NOREF) dst to skbs under RCU.
When an ingress multicast packet misses MFC lookup,
ip6mr_cache_unresolved() places the skb onto the unresolved queue,
escaping the receive-side RCU grace period.

If the underlying route is deleted and freed, and the MFC queue is later
resolved with a wrong parent interface, ip6_mr_forward() invokes
ip6mr_cache_report(..., MRT6MSG_WRONGMIF), which executes
dst_clone(skb_dst(pkt)) on the freed dst entry, triggering a slab
use-after-free.

Report packets queued to mroute6_sk (a raw socket) and netlink
notifications do not require an attached dst entry.

Fix this by:
1. Removing dst_clone() in ip6mr_cache_report() and ensuring report skbs
   do not hold a dst.
2. Dropping skb_dst before queuing unresolved skbs in
   ip6mr_cache_unresolved(), matching the fact that multicast
   forwarding resolves outgoing routes anew via ip6_route_output().

Fixes: 67f415dd2906 ("ipv6: convert rx data path to not take refcnt on dst")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260818172755.4083692-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a7fa0d1d82b08..1724d50c50fd8 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1128,7 +1128,6 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 	msg->im6_src = ipv6_hdr(pkt)->saddr;
 	msg->im6_dst = ipv6_hdr(pkt)->daddr;
 
-	skb_dst_set(skb, dst_clone(skb_dst(pkt)));
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
@@ -1138,6 +1137,7 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 		return -EINVAL;
 	}
 
+	skb_dst_drop(skb);
 	mrt6msg_netlink_event(mrt, skb);
 
 	/* Deliver to user space multicast routing algorithms */
@@ -1217,6 +1217,7 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 			skb->dev = dev;
 			skb->skb_iif = dev->ifindex;
 		}
+		skb_dst_drop(skb);
 		skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
 		err = 0;
 	}
-- 
2.53.0



