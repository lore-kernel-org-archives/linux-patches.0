Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C19338DC59;
	Sat, 12 Sep 2026 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204770; cv=none; b=fwiMs6yD9bdLvTu534t/pBsG5l4ySkplvnwiAvVKgoBxilsFr7/C7px7WoH50Y1lXvNDZRcMbb5yP/HEIi83jkOwrvkofHtqXA5vtXVG2QXHFsmJSusDmq/lY7GlDJiUFzLARmqlBUl4soNnOqpk08wQKKEFTArjwSB+iIif6rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204770; c=relaxed/simple;
	bh=omQ2YHgxYnVFDxsxK0EKKNA1MQepHfaqJ1nH/KCV2cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQGz9QX6uh0UGJMTVRd4xE4fiv5gnOeM1pTsK+fWx2Lt3PNiyKHFABgBU3U2fWxz+psGPkeCdhMhu6xj4xMYfhA/UxZDVPDmztnqwg4T3MF6nLGsm024pSpxVJYWkgm6NVdqhuLCGb9Mh1bK6dP2Ddzr5+pmKvwh2Xidhr32VzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=day++hSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="day++hSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E39D1F000FF;
	Sat, 12 Sep 2026 09:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204769;
	bh=XFxw4DZ1Y2vahorSGw1GHasLQFZ7qmBs7FyUGQKU/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=day++hSKHpai6BKRI+aMeE2JbJd3MR4FX3Tghq82+6SbA+DA7UWImSID5248DXn4Z
	 fX+LVXkOoBUqIQVH1JNsdPnn8w2yL3KE7nAHhuV9f11MczDWD6Uv53bRNa/E6Cv1D8
	 sDC40zMOWloawXES4LKyvrX9lCNVLClxvG+A6nSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1680/1815] ip6mr: do not clone dst in ip6mr_cache_report()
Date: Sat, 12 Sep 2026 08:57:10 +0200
Message-ID: <20260912065728.424382410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 604a58838901a..3f2ed9b77deb5 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1162,10 +1162,10 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 	msg->im6_src = ipv6_hdr(pkt)->saddr;
 	msg->im6_dst = ipv6_hdr(pkt)->daddr;
 
-	skb_dst_set(skb, dst_clone(skb_dst(pkt)));
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
+	skb_dst_drop(skb);
 	mrt6msg_netlink_event(mrt, skb);
 
 	/* Deliver to user space multicast routing algorithms */
@@ -1246,6 +1246,7 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 		skb->skb_iif = dev->ifindex;
 	}
 
+	skb_dst_drop(skb);
 	skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
 
 	spin_unlock_bh(&mfc_unres_lock);
-- 
2.53.0



