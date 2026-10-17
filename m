Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF33AB47A;
	Sat, 17 Oct 2026 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255080; cv=none; b=jtwEzEt6BSkB0Rn7cCUiZSfp0DZ/wm8vgUtE1hM/jgeSjyrSJ4wUFH90RfhKQP5ak8NNbdso/J4BH1rR6Lg6nn/Cwzl8vCkNYA3nr/VF8F5wJ77q9LJnEXWp0FrqezlverAQYMN0VyqfTmfOvvFljW7r3VmHSJw7iU9UJQvGMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255080; c=relaxed/simple;
	bh=Y7O1OkuSGWn5c7a4KF4ZGLecB1jqrUj1x16Pytyw5as=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG9m7F2QfkuUmKgCJDZ8udjKyKcIixqsvXakhCki1hNkJXVaa0PrAqnXgxQzNypYWIv9eID+aZKskEy6ZDX4a5pFS37aghDBk76o/PDRA8VAcXUq2slwUmEgANSlVyTcPa+gboWeburDRi57EmPzNQ1ruzrv2/kjuc066QuIFdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtLODh+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtLODh+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A26D1F000C4;
	Sat, 17 Oct 2026 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255079;
	bh=7rxP240wHr0g6EpX1D/hyXstGeVyiYrNfj5VOCcOWaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtLODh+tAPLn/ydunUfJrYwPKV32ODgHHaJOmf4bCYgW8AnbmhMYDXWG+l5D7gz2m
	 NeYQtXb7tmurLBLL8k8T++8XUU0l/9zA3gOzbuk2aVltyTao2CaVnNApF5ETp5Kvca
	 qgD9apKENwRaxEEUHxp1aOR5ms6JDsc1gASGJudc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 612/869] ip6mr: do not clone dst in ip6mr_cache_report()
Date: Sat, 17 Oct 2026 17:57:33 +0200
Message-ID: <20261017160052.727524937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ac0120b75ff2b..d95b988be4afe 100644
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



