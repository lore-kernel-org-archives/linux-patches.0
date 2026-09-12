Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B34BEE32;
	Sat, 12 Sep 2026 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212071; cv=none; b=GbxlR8f7AEAlI7/xRkQeymCVwTrfkV2fHru1dLO+9mV8GtIMUrkdoRS9FKaNK/wa9kXyZMN1CkilCZoVSZqGdfx67xIiLk9KJrCBycILkDTtjvP/M905XIySKu9CVVQhoZxkoOdveW/UZnWtdmVdLpbl2picsgvPocfUc16RDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212071; c=relaxed/simple;
	bh=WYMvZQv+Uds6QywqSXpuHrl/uvjU1yU8tDKD42lnI6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri9z+YcHrKrIDbpF46e1DIZpmkg980JjpTucCEoFJQ6XTXGGn/xWCzmUF0zP6h/czSECh4YVUDpFUJbIG3dzzaPQCsTkTmcbMrqGKukzVzf22Bw1Ok+qmkKXyGQW607R76E54d+nKiyJaOh0OCkKH7gLY/khxDx53gWy0SZlR1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSdgVCN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSdgVCN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833571F000FF;
	Sat, 12 Sep 2026 11:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212070;
	bh=dSzS7J4hU2+pkPxy8o11AUCrAusviNmtd800FVS2cR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSdgVCN57t3riIDT73m1tDoJCSd99XljRCghnNW0S5rHQEJUFNzt07DYwmzlO5XQo
	 mn/m5JTZ63dHl8Qc+UxLhb7skMo6FqI/ru0Tx07O5Fgu1zrrZtfC5BpX0oJ2YyZc6h
	 8i04vpEptFhfich15lhIkNLUeDPzpado6CEt6glY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1360/1518] ip6mr: plug drop_reason to ip6mr_cache_report()
Date: Sat, 12 Sep 2026 08:58:49 +0200
Message-ID: <20260912065654.298280409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 8d59a7a188c0a7f6d52e4a829f3ce75534255d76 ]

- Check mrt->mroute_sk earlier in the function.

- Use sock_queue_rcv_skb_reason() instead of sock_queue_rcv_skb().
- Use sk_skb_reason_drop() instead of kfree_skb().
  Note that we return -ENOMEM if sock_queue_rcv_skb_reason() failed,
  as the precise error is not really needed for callers.

- Remove one net_warn_ratelimited().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260430074004.4133602-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 235b42b58601 ("ip6mr: do not clone dst in ip6mr_cache_report()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index e047a4680ab0e..61e61e36f0907 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1063,10 +1063,14 @@ static void ip6mr_cache_resolve(struct net *net, struct mr_table *mrt,
 static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 			      mifi_t mifi, int assert)
 {
+	enum skb_drop_reason reason;
 	struct sock *mroute6_sk;
 	struct sk_buff *skb;
 	struct mrt6msg *msg;
-	int ret;
+
+	mroute6_sk = rcu_dereference(mrt->mroute_sk);
+	if (!mroute6_sk)
+		return -EINVAL;
 
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (assert == MRT6MSG_WHOLEPKT || assert == MRT6MSG_WRMIFWHOLE)
@@ -1136,23 +1140,17 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	mroute6_sk = rcu_dereference(mrt->mroute_sk);
-	if (!mroute6_sk) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
 	mrt6msg_netlink_event(mrt, skb);
 
 	/* Deliver to user space multicast routing algorithms */
-	ret = sock_queue_rcv_skb(mroute6_sk, skb);
+	reason = sock_queue_rcv_skb_reason(mroute6_sk, skb);
 
-	if (ret < 0) {
-		net_warn_ratelimited("mroute6: pending queue full, dropping entries\n");
-		kfree_skb(skb);
+	if (reason) {
+		sk_skb_reason_drop(mroute6_sk, skb, reason);
+		return -ENOMEM;
 	}
 
-	return ret;
+	return 0;
 }
 
 /* Queue a packet for resolution. It gets locked cache entry! */
-- 
2.53.0



