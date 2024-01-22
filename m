Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BBF153BC3;
	Tue, 23 Jan 2024 00:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969372; cv=none; b=S9UMj25jcg9EaECpozdU3Bo9Ye8NsF1eHotcibfZujix2B5EBxZtZFI1iGIh0i9YLb7/B/tzB0Hp2G3gjX/Szq9HDOCtqbhNthlYaN144sbFcUi3KZ/7y8qQr5FplHsPzJA0RbMaJpMK8TkQ4qmXPlLF/1F5WnHwpNQxDLQ7caM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969372; c=relaxed/simple;
	bh=l6Ekw+TvCpzJgSvGze7YZVfx/EqsoXrDmlmct8sYPKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFdskZ+NCpMe9nXNPFbjruw/Rt56ERAyruY20AAEvvvgQ4A9msOmYwwQpwA9SS9k5ObrjrI0PVbYV14vHGa5BN/y90+/Bfi3gRc7s3bW59QT2R45dpbKKPTVvrRufFbqLJ9Fwp9XqdJYmvZcOjBaKJ5q4ItULLkB3UJX50bbXWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB0+TRv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB0+TRv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7258C433C7;
	Tue, 23 Jan 2024 00:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969371;
	bh=l6Ekw+TvCpzJgSvGze7YZVfx/EqsoXrDmlmct8sYPKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB0+TRv/PvXNSSU6J7mqf/RTYxSametFfXj0bNuNFN6hTr4JbJySq/vxVXroxmPAW
	 kDPACxg+7StFvxg0xLUpUBPpSsIkkXiuR8e7g3odO2Y7mdkIm4Y1QeQmBsvYBLBzwh
	 QvKmN27P3dGVmyXf2XLhS9R4ID9ee/CCnxCj8D4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leone Fernando <leone4fernando@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 185/641] ipmr: support IP_PKTINFO on cache report IGMP msg
Date: Mon, 22 Jan 2024 15:51:29 -0800
Message-ID: <20240122235823.775002073@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leone Fernando <leone4fernando@gmail.com>

[ Upstream commit bb7403655b3c3eb245d0ee330047cd3e20b3c4af ]

In order to support IP_PKTINFO on those packets, we need to call
ipv4_pktinfo_prepare.

When sending mrouted/pimd daemons a cache report IGMP msg, it is
unnecessary to set dst on the newly created skb.
It used to be necessary on older versions until
commit d826eb14ecef ("ipv4: PKTINFO doesnt need dst reference") which
changed the way IP_PKTINFO struct is been retrieved.

Changes from v1:
1. Undo changes in ipv4_pktinfo_prepare function. use it directly
   and copy the control block.

Fixes: d826eb14ecef ("ipv4: PKTINFO doesnt need dst reference")
Signed-off-by: Leone Fernando <leone4fernando@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 9e222a57bc2b..0063a237253b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1025,6 +1025,10 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 	struct sk_buff *skb;
 	int ret;
 
+	mroute_sk = rcu_dereference(mrt->mroute_sk);
+	if (!mroute_sk)
+		return -EINVAL;
+
 	if (assert == IGMPMSG_WHOLEPKT || assert == IGMPMSG_WRVIFWHOLE)
 		skb = skb_realloc_headroom(pkt, sizeof(struct iphdr));
 	else
@@ -1069,7 +1073,8 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg = (struct igmpmsg *)skb_network_header(skb);
 		msg->im_vif = vifi;
 		msg->im_vif_hi = vifi >> 8;
-		skb_dst_set(skb, dst_clone(skb_dst(pkt)));
+		ipv4_pktinfo_prepare(mroute_sk, pkt);
+		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
 		/* Add our header */
 		igmp = skb_put(skb, sizeof(struct igmphdr));
 		igmp->type = assert;
@@ -1079,12 +1084,6 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		skb->transport_header = skb->network_header;
 	}
 
-	mroute_sk = rcu_dereference(mrt->mroute_sk);
-	if (!mroute_sk) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
 	igmpmsg_netlink_event(mrt, skb);
 
 	/* Deliver to mrouted */
-- 
2.43.0



