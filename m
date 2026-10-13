Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34541D11F;
	Tue, 13 Oct 2026 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893973; cv=none; b=TJS4sjKrRDIhFbjbV7/7DJuzKaH2ZMgBGjrde4/ZJJCTCSeZjyyq4wFFlAwmFN/lyf5NDk48E1OZ4BD4ZD0BwmFVaEZycp8WAvjZL8tDxzbkLbUqD6FhCKdtw+wE2p24sKarYBcOYqCFNbN4YijMvdVo+StGmtHvCbQI8dq+XMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893973; c=relaxed/simple;
	bh=DW+BwiulfW2pnLopr2RAEqciqf5Vd6Uf+Ny4ifvO1Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWtwy6zEoN5WNid5Jt04dWvEPsAQhrZPrpPe2pkHNkHrAYiFnN9KjvrR/t5QmoeBX/7cnqBmh6pMTIiHfodR/TLPXfwqD1Tymh3pZ6LaTay3p3RIheegTKVxnY7VEqyHxICxWXpjeZPi300ToQfAksjAufbA7BzW2qxO4wXoMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBSAE5bI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBSAE5bI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6B31F000FF;
	Tue, 13 Oct 2026 12:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893971;
	bh=xqNn9P9eXxM1I4vpQJJGyRCeTBhh7ubQEXaslmXX7II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBSAE5bIjWtlJ00VpvOzDI8PvhrccxupuPTBOVTtxYhRnFnKP5FAjoYhJra/alhSq
	 vPonLn+6fRiTez7rpOEw/1REK8KVEtcPX+t3zbldWpNyDhbhp7+5bDXxUd+stgot2W
	 9Wfh+1Wl0/6XTyUZIqCszlg1pHwo1aaeJQREcCiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 405/621] ip6mr: do not clone dst in ip6mr_cache_report()
Date: Tue, 13 Oct 2026 13:36:40 +0200
Message-ID: <20261013112930.451145850@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index d59d31ab960a5..7b60e4b2a8179 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1136,10 +1136,10 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 	msg->im6_src = ipv6_hdr(pkt)->saddr;
 	msg->im6_dst = ipv6_hdr(pkt)->daddr;
 
-	skb_dst_set(skb, dst_clone(skb_dst(pkt)));
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
+	skb_dst_drop(skb);
 	mrt6msg_netlink_event(mrt, skb);
 
 	/* Deliver to user space multicast routing algorithms */
@@ -1219,6 +1219,7 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 			skb->dev = dev;
 			skb->skb_iif = dev->ifindex;
 		}
+		skb_dst_drop(skb);
 		skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
 		err = 0;
 	}
-- 
2.53.0



